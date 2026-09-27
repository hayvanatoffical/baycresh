#!/usr/bin/env python3
"""Build K0 Roblox place files without Roblox Studio, then verify them.

Runs the real scene builders in Lune (open-source Luau runtime with Roblox's
DOM, rbx-dom), installs the four active runtime sources at their Studio paths
and writes a binary .rbxl per test profile under dist/place/. See
TOOLS/place_build/README.md.

Checks on every built place:
  1. every builder ran; no property name or value type was rejected by Roblox's
     reflection database;
  2. the file reads back with the same instance count;
  3. each runtime script is present with byte-identical source;
  4. the config module evaluates, the profile changed exactly the intended
     Prototype values and nothing else;
  5. the scene tree equals the one the Luau harness builds from the same sources
     (two independent DOM implementations must agree).

A place built here has NOT run on Roblox. Publishing it and playing it is a
separate, owner-approved step (TOOLS/roblox_cloud.py).
"""
from __future__ import annotations

import argparse
import collections
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LUNE_SCRIPT = ROOT / "TOOLS" / "place_build" / "build_place.luau"
OUT_DIR = ROOT / "dist" / "place"

BUILDERS = ["SCENE_BUILD", "STALL_ART_BUILD", "ART_V2_FIX", "STALL_ART_V3", "MARKET_SYSTEM_BUILD"]
CONFIG_PATH = "GAME/src/ReplicatedStorage/K0MarketConfig.lua"
SCRIPTS = [
    # (className, name, Studio parent path, source, evaluate as data)
    ("ModuleScript", "K0MarketConfig", "ReplicatedStorage", CONFIG_PATH, True),
    ("Script", "K0Market", "ServerScriptService", "GAME/src/ServerScriptService/K0Market.server.lua", False),
    ("LocalScript", "K0MarketHUD", "StarterPlayer/StarterPlayerScripts",
     "GAME/src/StarterPlayerScripts/K0MarketHUD.client.lua", False),
    ("LocalScript", "K0NpcMotion", "StarterPlayer/StarterPlayerScripts",
     "GAME/src/StarterPlayerScripts/K0NpcMotion.client.lua", False),
]

# Test profiles replace the Edit-mode copy edits of PRODUCTION/K0.4_NEXT_TEST_PLAN.md.
# Only Prototype values change; the source file on disk is never touched.
PROFILES: dict[str, dict[str, int]] = {
    "default": {},
    "permit90": {"PermitPeriodSeconds": 90},   # plan 2b: registration expiry and rescue
    "cash325": {"StartingCash": 325},          # plan 2d B11: upgrade refused without stock
    "cash385": {"StartingCash": 385},          # plan 2d B11: cashier refused without stock
}

# Known, explained differences between the harness tree and a Lune-built file.
ENGINE_ONLY = {"Workspace.Camera\tCamera"}  # the engine creates the camera at run time
FILE_ONLY = {"StarterPlayer.StarterCharacterScripts\tStarterCharacterScripts"}  # Studio template folder


def find_lune() -> str | None:
    for candidate in (os.environ.get("LUNE"), shutil.which("lune"), "/tmp/lunebin/lune"):
        if candidate and Path(candidate).exists():
            return candidate
    return None


def read(rel: str) -> str:
    return (ROOT / rel).read_text(encoding="utf-8")


def config_version(text: str) -> str:
    m = re.search(r'Version\s*=\s*"([^"]+)"', text)
    if not m:
        raise SystemExit("config has no Version string")
    return m.group(1)


def short_version(version: str) -> str:
    # "K0-market-0.4.1" -> "K0.4.1"
    m = re.search(r"(\d+)\.(\d+)\.(\d+)$", version)
    if not m:
        return version
    return "K0.%s.%s" % (m.group(2), m.group(3)) if m.group(1) == "0" else version


def patch_prototype(text: str, changes: dict[str, int]) -> str:
    """Replace numeric Prototype values; each key must occur exactly once there."""
    start = text.index("Prototype = {")
    end = text.index("Products = {", start)
    block = text[start:end]
    for key, value in changes.items():
        pattern = re.compile(r"(\n\s*%s\s*=\s*)(-?\d+(?:\.\d+)?)(\s*,)" % re.escape(key))
        hits = pattern.findall(block)
        if len(hits) != 1:
            raise SystemExit(f"profile key {key}: expected one numeric line in Prototype, found {len(hits)}")
        block = pattern.sub(lambda m: f"{m.group(1)}{value}{m.group(3)}", block)
    return text[:start] + block + text[end:]


def harness_tree() -> collections.Counter | None:
    r = subprocess.run([sys.executable, str(ROOT / "TOOLS" / "run_luau_harness.py"), "--dump-scene"],
                       capture_output=True, text=True)
    if r.returncode == 2:
        return None
    if r.returncode != 0:
        raise SystemExit("harness scene dump failed:\n" + r.stdout + r.stderr)
    tree = collections.Counter()
    for line in r.stdout.splitlines():
        if line.startswith("SCENE\t"):
            _, path, cls = line.split("\t")
            tree[f"{path}\t{cls}"] += 1
    return tree


def build_one(lune: str, profile: str, version: str, out_dir: Path, tmp: Path) -> tuple[list[str], dict]:
    changes = PROFILES[profile]
    config_text = read(CONFIG_PATH)
    patched = patch_prototype(config_text, changes) if changes else config_text
    scripts = []
    for class_name, name, parent, rel, evaluate in SCRIPTS:
        source = patched if rel == CONFIG_PATH else read(rel)
        scripts.append({"className": class_name, "name": name, "parent": parent,
                        "source": source, "evaluate": evaluate})
    inputs = {
        "profile": profile,
        "version": version,
        "baseplate": True,
        "builders": [{"name": n, "source": read(f"GAME/{n}.lua")} for n in BUILDERS],
        "scripts": scripts,
        "workspaceAttributes": {"K0BuildProfile": profile, "K0BuildVersion": version},
    }
    inputs_path = tmp / f"{profile}.inputs.json"
    inputs_path.write_text(json.dumps(inputs), encoding="utf-8")
    stem = f"BAYCREST-{short_version(version)}-{profile}"
    place = out_dir / f"{stem}.rbxl"
    manifest_path = out_dir / f"{stem}.manifest.json"
    r = subprocess.run([lune, "run", str(LUNE_SCRIPT), str(inputs_path), str(place), str(manifest_path)],
                       capture_output=True, text=True)
    problems: list[str] = []
    if manifest_path.exists() and manifest_path.stat().st_mtime_ns < inputs_path.stat().st_mtime_ns:
        manifest_path.unlink()  # a stale manifest from an earlier run must not be read as this one
    if not manifest_path.exists():
        tail = (r.stdout + r.stderr).strip().splitlines()[-12:]
        problems.append("lune build failed (exit %d):\n      " % r.returncode + "\n      ".join(tail))
        return problems, {}
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    manifest["file"] = place.name
    if r.returncode != 0 and not manifest.get("failures"):
        problems.append(f"lune exited {r.returncode} without recording a failure")

    problems += [f"build: {f}" for f in manifest.get("failures", [])]
    if manifest.get("roundTripDescendants") != manifest.get("originalDescendants"):
        problems.append("round trip changed the instance count: %s -> %s"
                        % (manifest.get("originalDescendants"), manifest.get("roundTripDescendants")))
    by_path = {s["path"]: s for s in manifest.get("scripts", [])}
    for class_name, name, parent, _rel, _ev in SCRIPTS:
        s = by_path.get(f"{parent}/{name}")
        if not s or s["className"] != class_name or not s["sourceMatches"]:
            problems.append(f"script {parent}/{name}: missing, wrong class or source mismatch ({s})")

    attrs = manifest.get("workspaceAttributes") or {}
    if attrs.get("K0BuildProfile") != profile or attrs.get("K0BuildVersion") != version:
        problems.append(f"workspace build attributes did not survive the file: {attrs}")

    # Config: version, intended profile values, no other drift.
    base_cfg = manifest.get("evaluated", {}).get("K0MarketConfig")
    if not isinstance(base_cfg, dict):
        problems.append("config module did not evaluate to a table")
    else:
        if base_cfg.get("Version") != version:
            problems.append(f"config Version {base_cfg.get('Version')!r} != {version!r}")
        proto = base_cfg.get("Prototype", {})
        for key, value in changes.items():
            if proto.get(key) != value:
                problems.append(f"profile {profile}: Prototype.{key} is {proto.get(key)!r}, expected {value}")
        manifest["prototype"] = {k: v for k, v in proto.items() if isinstance(v, (int, float))}
    return problems, manifest


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("profiles", nargs="*", help="profiles to build (default: all). Known: " + ", ".join(PROFILES))
    ap.add_argument("--out-dir", default=str(OUT_DIR), help="output directory (default: dist/place)")
    ap.add_argument("--no-harness-compare", action="store_true", help="skip the cross-check against the Luau harness tree")
    args = ap.parse_args()

    unknown = [p for p in args.profiles if p not in PROFILES]
    if unknown:
        print("unknown profile(s): " + ", ".join(unknown))
        return 1
    profiles = args.profiles or list(PROFILES)

    lune = find_lune()
    if not lune:
        print("SKIP — Lune not found (set LUNE, put lune on PATH or at /tmp/lunebin/lune). See TOOLS/place_build/README.md.")
        return 2

    version = config_version(read(CONFIG_PATH))
    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    tree = None if args.no_harness_compare else harness_tree()
    all_ok = True
    manifests = {}
    with tempfile.TemporaryDirectory() as tmp_name:
        tmp = Path(tmp_name)
        for profile in profiles:
            problems, manifest = build_one(lune, profile, version, out_dir, tmp)
            if manifest and tree is not None:
                built = collections.Counter()
                for rows in manifest.get("instances", {}).values():
                    built.update(rows)
                only_file = {k for k in (built - tree)} - FILE_ONLY
                only_engine = {k for k in (tree - built)} - ENGINE_ONLY
                for k in sorted(only_file):
                    problems.append("only in built file: " + k.replace("\t", " : "))
                for k in sorted(only_engine):
                    problems.append("only in harness tree: " + k.replace("\t", " : "))
                manifest["harnessTreeMatch"] = not only_file and not only_engine
            if problems:
                # A place that failed verification must not be left where it could be published.
                for leftover in out_dir.glob(f"BAYCREST-{short_version(version)}-{profile}.rbxl"):
                    leftover.unlink()
            status = "PASS" if not problems else "FAIL"
            all_ok &= not problems
            detail = ""
            if manifest:
                detail = " · %d instances · %d bytes" % (manifest.get("originalDescendants", 0), manifest.get("bytes", 0))
                changes = PROFILES[profile]
                if changes:
                    detail += " · " + ", ".join(f"{k}={v}" for k, v in changes.items())
            print(f"[{status}] {profile}: {manifest.get('file', '-')}{detail}")
            for p in problems:
                print("    - " + p)
            if manifest:
                # Rewrite the manifest with the verification outcome for the record.
                place_file = out_dir / manifest["file"]
                manifest["sha256"] = hashlib.sha256(place_file.read_bytes()).hexdigest() if place_file.exists() else None
                manifest["verified"] = not problems
                manifest["problems"] = problems
                manifest.pop("log", None)
                stem = Path(manifest["file"]).stem
                (out_dir / f"{stem}.manifest.json").write_text(
                    json.dumps(manifest, ensure_ascii=False, indent=1), encoding="utf-8")
                manifests[profile] = manifest

    if tree is None and not args.no_harness_compare:
        print("NOTE — Luau CLI not found; the cross-check against the harness tree was SKIPPED.")
    print(f"Source version {version} · output {out_dir.relative_to(ROOT) if out_dir.is_relative_to(ROOT) else out_dir}")
    print("PLACE BUILD RESULT: " + ("PASS" if all_ok else "FAIL"))
    print("Not run on Roblox. Publishing and playing are separate steps (TOOLS/roblox_cloud.py).")
    return 0 if all_ok else 1


if __name__ == "__main__":
    sys.exit(main())
