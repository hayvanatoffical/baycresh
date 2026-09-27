#!/usr/bin/env python3
"""Layer 3 of K0 validation: run the REAL Luau sources on a mock engine.

Bundles the scene builders, the four active runtime sources and the legacy
runtime into one Luau program together with TOOLS/luau_harness/*.luau and runs
it with the Luau CLI on a virtual clock. See TOOLS/luau_harness/README.md.

This is still not Roblox Studio. It proves that the source runs end to end
against a strict stand-in of the engine API it uses; it cannot prove rendering,
physics, replication latency, device performance or player understanding.
"""
from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
HARNESS = ROOT / "TOOLS" / "luau_harness"
CONFIG_SOURCE = "GAME/src/ReplicatedStorage/K0MarketConfig.lua"

sys.path.insert(0, str(ROOT / "TOOLS" / "place_build"))
from smoke_bundle import build_smoke_script, config_expectation  # noqa: E402

SOURCES = {
    "SCENE_BUILD": "GAME/SCENE_BUILD.lua",
    "STALL_ART_BUILD": "GAME/STALL_ART_BUILD.lua",
    "ART_V2_FIX": "GAME/ART_V2_FIX.lua",
    "STALL_ART_V3": "GAME/STALL_ART_V3.lua",
    "MARKET_SYSTEM_BUILD": "GAME/MARKET_SYSTEM_BUILD.lua",
    "K0_MARKET_V3_MIGRATION": "GAME/K0_MARKET_V3_MIGRATION.lua",
    "K0MarketConfig": "GAME/src/ReplicatedStorage/K0MarketConfig.lua",
    "K0Market": "GAME/src/ServerScriptService/K0Market.server.lua",
    "K0MarketHUD": "GAME/src/StarterPlayerScripts/K0MarketHUD.client.lua",
    "K0NpcMotion": "GAME/src/StarterPlayerScripts/K0NpcMotion.client.lua",
    "K0Game": "GAME/legacy/K0Game.server.lua",
    "K0HUD": "GAME/legacy/K0HUD.client.lua",
    "K0Config": "GAME/legacy/K0Config.lua",
}
# Optional sources are bundled when present so later sessions can add files
# without editing this list twice.
OPTIONAL = {
    "K0_INSTALL": "GAME/K0_INSTALL.lua",
}


def long_string(text: str) -> str:
    level = 1
    while f"]{'=' * level}]" in text:
        level += 1
    eq = "=" * level
    return f"[{eq}[\n{text}]{eq}]"


def find_luau() -> str | None:
    for candidate in (shutil.which("luau"), "/tmp/luaubin/luau"):
        if candidate and Path(candidate).exists():
            return candidate
    return None


def build_bundle(only: list[str], signal_modes: list[str], echo: bool, dump_scene: bool = False) -> str:
    parts = ["--!nocheck", "local SOURCES = {}"]
    # H17 runs the exact Open Cloud smoke task script that roblox_cloud.py sends.
    config_text = (ROOT / CONFIG_SOURCE).read_text(encoding="utf-8")
    smoke = build_smoke_script({**config_expectation(config_text), "profile": None})
    parts.append(f"SOURCES['CLOUD_SMOKE'] = {long_string(smoke)}")
    for name, rel in {**SOURCES, **OPTIONAL}.items():
        path = ROOT / rel
        if not path.is_file():
            if name in OPTIONAL:
                continue
            raise SystemExit(f"missing source: {rel}")
        parts.append(f"SOURCES[{name!r}] = {long_string(path.read_text(encoding='utf-8'))}")
    only_lua = ", ".join(f"[{n!r}] = true" for n in only)
    modes_lua = ", ".join(repr(m) for m in signal_modes)
    parts.append(
        "local OPTIONS = {only = {" + only_lua + "}, hasOnly = " + ("true" if only else "false")
        + ", signalModes = {" + modes_lua + "}, echo = " + ("true" if echo else "false")
        + ", dumpScene = " + ("true" if dump_scene else "false") + "}")
    engine = (HARNESS / "engine.luau").read_text(encoding="utf-8")
    parts.append("local Engine = (function()\n" + engine + "\nend)()")
    parts.append("local Vector3, Vector2, CFrame, Color3, UDim, UDim2, Enum = "
                 "Engine.types.Vector3, Engine.types.Vector2, Engine.types.CFrame, Engine.types.Color3, "
                 "Engine.types.UDim, Engine.types.UDim2, Engine.types.Enum")
    world = (HARNESS / "k0_world.luau").read_text(encoding="utf-8")
    parts.append("local K0World = (function()\n" + world + "\nend)()")
    parts.append((HARNESS / "k0_scenarios.luau").read_text(encoding="utf-8"))
    return "\n".join(parts) + "\n"


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("scenarios", nargs="*", help="run only these scenario ids (e.g. H01 H04)")
    ap.add_argument("--mode", choices=["Deferred", "Immediate", "both"], default="both",
                    help="signal behaviour to emulate (default: both)")
    ap.add_argument("--echo", action="store_true", help="echo script output while running")
    ap.add_argument("--keep", action="store_true", help="keep the generated bundle for debugging")
    ap.add_argument("--dump-scene", action="store_true",
                    help="only build the scene, install the runtime and print every instance path (used by build_place.py)")
    args = ap.parse_args()

    luau = find_luau()
    if not luau:
        print("SKIP — Luau CLI not found (install luau or place it at /tmp/luaubin/luau).")
        return 2
    modes = ["Deferred", "Immediate"] if args.mode == "both" else [args.mode]
    bundle = build_bundle(args.scenarios, modes, args.echo, args.dump_scene)
    with tempfile.TemporaryDirectory() as tmp:
        path = Path(tmp) / "k0_harness_bundle.luau"
        path.write_text(bundle, encoding="utf-8")
        if args.keep:
            keep = ROOT / "TOOLS" / "luau_harness" / "_bundle.luau"
            keep.write_text(bundle, encoding="utf-8")
            print(f"bundle kept at {keep.relative_to(ROOT)}")
        r = subprocess.run([luau, str(path)], capture_output=True, text=True)
    sys.stdout.write(r.stdout)
    if r.stderr:
        sys.stderr.write(r.stderr)
    if r.returncode != 0:
        return r.returncode
    if args.dump_scene:
        return 0 if "HARNESS RESULT: DUMP" in r.stdout else 1
    return 0 if "HARNESS RESULT: PASS" in r.stdout else 1


if __name__ == "__main__":
    sys.exit(main())
