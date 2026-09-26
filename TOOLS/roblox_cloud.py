#!/usr/bin/env python3
"""Studio-free bridge to Roblox: publish a built K0 place and run the cloud smoke test.

Uses two official Roblox Open Cloud APIs (docs checked 26 Sep 2026):
  * Place Publishing  POST /universes/v1/{universe}/places/{place}/versions?versionType=...
    https://create.roblox.com/docs/cloud/guides/usage-place-publishing
  * Luau Execution    POST /cloud/v2/universes/{universe}/places/{place}[/versions/{v}]/luau-execution-session-tasks
    https://create.roblox.com/docs/cloud/features/luau-execution

Credentials come only from environment variables and are never printed:
  ROBLOX_API_KEY       Open Cloud API key (universe-places write; luau-execution-session write)
  ROBLOX_UNIVERSE_ID   the experience (universe) ID
  ROBLOX_PLACE_ID      the place to publish to and to run tasks on

Commands:
  status                       show which settings are present (no network call)
  publish <profile> [--yes]    upload dist/place/BAYCREST-<ver>-<profile>.rbxl (dry run without --yes)
  smoke <profile>              run TOOLS/place_build/cloud_smoke.luau on the place in a real Roblox server
  run <file.luau>              run any task script and print its logs and return values

Publishing replaces what players join. It is the owner's decision; this tool
refuses to publish without --yes, refuses an unverified build, and refuses the
main K0 place unless --allow-main-place is also given.
"""
from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import json
import os
import re
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PLACE_DIR = Path(os.environ.get("K0_PLACE_DIR") or ROOT / "dist" / "place")  # override for tests
CONFIG = ROOT / "GAME" / "src" / "ReplicatedStorage" / "K0MarketConfig.lua"
MAIN_PLACE_ID = "83986068176961"  # GAME/README.md: the owner's K0 Studio place
DEFAULT_BASE = "https://apis.roblox.com"
TASK_SCRIPT_LIMIT = 4 * 1024 * 1024  # Roblox: scripts up to 4 MB
TERMINAL = {"COMPLETE", "FAILED", "CANCELLED"}

sys.path.insert(0, str(ROOT / "TOOLS" / "place_build"))
from smoke_bundle import build_smoke_script, config_expectation  # noqa: E402


class CloudError(Exception):
    pass


# --------------------------------------------------------------- settings
def settings(require: bool = True) -> dict:
    s = {
        "key": os.environ.get("ROBLOX_API_KEY", "").strip(),
        "universe": os.environ.get("ROBLOX_UNIVERSE_ID", "").strip(),
        "place": os.environ.get("ROBLOX_PLACE_ID", "").strip(),
        "base": os.environ.get("ROBLOX_API_BASE", DEFAULT_BASE).rstrip("/"),
    }
    base = urllib.parse.urlparse(s["base"])
    local = base.hostname in ("127.0.0.1", "localhost")
    if base.scheme != "https" and not local:
        raise CloudError("ROBLOX_API_BASE must be https (plain http is accepted only for a local test server)")
    if require:
        missing = [name for name, k in (("ROBLOX_API_KEY", "key"), ("ROBLOX_UNIVERSE_ID", "universe"),
                                        ("ROBLOX_PLACE_ID", "place")) if not s[k]]
        if missing:
            raise CloudError("missing environment variable(s): " + ", ".join(missing)
                             + ". See TOOLS/place_build/README.md (never paste the key into chat or a file).")
        for name in ("universe", "place"):
            if not s[name].isdigit():
                raise CloudError(f"ROBLOX_{name.upper()}_ID must be a number")
    return s


def redact(text: str, s: dict) -> str:
    return text.replace(s["key"], "***") if s.get("key") else text


# --------------------------------------------------------------- HTTP
def request(s: dict, method: str, url: str, body: bytes | None = None, content_type: str | None = None,
            attempts: int = 4) -> dict:
    headers = {"x-api-key": s["key"], "Accept": "application/json"}
    if content_type:
        headers["Content-Type"] = content_type
    delay = 2.0
    for attempt in range(1, attempts + 1):
        req = urllib.request.Request(url, data=body, method=method, headers=headers)
        try:
            with urllib.request.urlopen(req, timeout=120) as resp:
                raw = resp.read()
                return json.loads(raw) if raw else {}
        except urllib.error.HTTPError as e:
            detail = e.read().decode("utf-8", "replace")[:600]
            retryable = e.code == 429 or e.code >= 500
            if retryable and attempt < attempts:
                time.sleep(delay)
                delay *= 2
                continue
            raise CloudError(redact(f"HTTP {e.code} for {method} {url.split('?')[0]}: {detail}", s)) from None
        except urllib.error.URLError as e:
            if attempt < attempts:
                time.sleep(delay)
                delay *= 2
                continue
            raise CloudError(redact(f"network error for {method} {url.split('?')[0]}: {e.reason}", s)) from None
    raise CloudError("unreachable")


# --------------------------------------------------------------- builds
def short_version() -> str:
    version = re.search(r'Version\s*=\s*"([^"]+)"', CONFIG.read_text(encoding="utf-8")).group(1)
    m = re.search(r"0\.(\d+)\.(\d+)$", version)
    return f"K0.{m.group(1)}.{m.group(2)}" if m else version


def load_build(profile: str) -> tuple[Path, dict]:
    stem = f"BAYCREST-{short_version()}-{profile}"
    place = PLACE_DIR / f"{stem}.rbxl"
    manifest_path = PLACE_DIR / f"{stem}.manifest.json"
    if not place.exists() or not manifest_path.exists():
        raise CloudError(f"{shown(place)} not built. Run: python3 TOOLS/build_place.py {profile}")
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if not manifest.get("verified"):
        raise CloudError(f"{place.name} did not pass verification; rebuild and fix before publishing")
    digest = hashlib.sha256(place.read_bytes()).hexdigest()
    if digest != manifest.get("sha256"):
        raise CloudError(f"{place.name} changed after it was verified (sha256 mismatch); rebuild it")
    return place, manifest


def shown(path: Path) -> str:
    try:
        return str(path.relative_to(ROOT))
    except ValueError:
        return str(path)


def evidence(name: str, data: dict) -> Path:
    PLACE_DIR.mkdir(parents=True, exist_ok=True)
    stamp = dt.datetime.now(dt.timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    path = PLACE_DIR / f"{name}-{stamp}.json"
    path.write_text(json.dumps(data, ensure_ascii=False, indent=1), encoding="utf-8")
    return path


# --------------------------------------------------------------- commands
def cmd_status(_args) -> int:
    s = settings(require=False)
    for label, k in (("ROBLOX_API_KEY", "key"), ("ROBLOX_UNIVERSE_ID", "universe"), ("ROBLOX_PLACE_ID", "place")):
        value = s[k]
        shown = ("set" if value else "MISSING") if k == "key" else (value or "MISSING")
        print(f"{label:20} {shown}")
    print(f"{'API base':20} {s['base']}")
    if s["place"] == MAIN_PLACE_ID:
        print("NOTE: ROBLOX_PLACE_ID is the main K0 place; publish needs --allow-main-place.")
    builds = sorted(PLACE_DIR.glob("BAYCREST-*.rbxl")) if PLACE_DIR.exists() else []
    print("built places: " + (", ".join(b.name for b in builds) if builds else "none (python3 TOOLS/build_place.py)"))
    return 0 if all(s[k] for k in ("key", "universe", "place")) else 2


def cmd_publish(args) -> int:
    s = settings()
    place, manifest = load_build(args.profile)
    version_type = "Saved" if args.saved else "Published"
    url = (f"{s['base']}/universes/v1/{s['universe']}/places/{s['place']}/versions"
           f"?versionType={version_type}")
    print(f"file      {shown(place)} ({place.stat().st_size} bytes, sha256 {manifest['sha256'][:12]}…)")
    print(f"profile   {args.profile} · source {manifest.get('version')}")
    print(f"target    universe {s['universe']} · place {s['place']} · versionType={version_type}")
    if s["place"] == MAIN_PLACE_ID and not args.allow_main_place:
        raise CloudError("refusing to publish over the main K0 place " + MAIN_PLACE_ID
                         + " (it holds the Studio scene and AI assets). Use a separate test place, or pass"
                           " --allow-main-place after the owner has decided; older versions stay in version history.")
    if not args.yes:
        print("DRY RUN — nothing sent. Add --yes to publish. Publishing replaces the version players join.")
        return 0
    result = request(s, "POST", url, body=place.read_bytes(), content_type="application/octet-stream")
    number = result.get("versionNumber")
    record = {"action": "publish", "profile": args.profile, "file": place.name, "sha256": manifest["sha256"],
              "sourceVersion": manifest.get("version"), "universe": s["universe"], "place": s["place"],
              "versionType": version_type, "versionNumber": number}
    path = evidence(f"publish-{args.profile}", record)
    print(f"PUBLISHED place version {number} ({version_type}) · record {shown(path)}")
    return 0


def run_task(s: dict, script: str, place_version: int | None, timeout_s: int) -> tuple[dict, list[str]]:
    size = len(script.encode("utf-8"))
    if size > TASK_SCRIPT_LIMIT:
        raise CloudError(f"task script is {size} bytes; Roblox accepts at most {TASK_SCRIPT_LIMIT}")
    parent = f"universes/{s['universe']}/places/{s['place']}"
    if place_version is not None:
        parent += f"/versions/{place_version}"
    body = json.dumps({"script": script, "timeout": f"{timeout_s}s"}).encode("utf-8")
    task = request(s, "POST", f"{s['base']}/cloud/v2/{parent}/luau-execution-session-tasks", body=body,
                   content_type="application/json")
    path = task.get("path")
    if not path:
        raise CloudError("task creation returned no path")
    print(f"task      {path}")
    deadline = time.monotonic() + timeout_s + 90
    state = task.get("state")
    while state not in TERMINAL:
        if time.monotonic() > deadline:
            raise CloudError(f"task still {state} after {timeout_s + 90}s")
        time.sleep(3)
        task = request(s, "GET", f"{s['base']}/cloud/v2/{path}")
        if task.get("state") != state:
            state = task.get("state")
            print(f"state     {state}")
    logs: list[str] = []
    token = None
    while True:
        query = "?maxPageSize=10000" + (f"&pageToken={urllib.parse.quote(token)}" if token else "")
        page = request(s, "GET", f"{s['base']}/cloud/v2/{path}/logs{query}")
        for chunk in page.get("luauExecutionSessionTaskLogs", []):
            logs.extend(str(m) for m in chunk.get("messages", []))
        token = page.get("nextPageToken")
        if not token:
            break
    return task, logs


def cmd_run(args) -> int:
    s = settings()
    script = Path(args.file).read_text(encoding="utf-8")
    task, logs = run_task(s, script, args.place_version, args.timeout)
    for line in logs:
        print("  | " + line)
    if task.get("state") != "COMPLETE":
        print(f"TASK {task.get('state')}: {json.dumps(task.get('error'), ensure_ascii=False)}")
        return 1
    print("results   " + json.dumps(task.get("output", {}).get("results"), ensure_ascii=False)[:4000])
    return 0


def cmd_smoke(args) -> int:
    s = settings()
    _place, manifest = load_build(args.profile)
    expect = {**config_expectation(CONFIG.read_text(encoding="utf-8")), "profile": args.profile}
    expect["prototype"] = manifest.get("prototype") or expect["prototype"]
    script = build_smoke_script(expect)
    task, logs = run_task(s, script, args.place_version, args.timeout)
    for line in logs:
        print("  | " + line)
    results = (task.get("output") or {}).get("results") or []
    report = results[0] if results and isinstance(results[0], dict) else None
    record = {"action": "smoke", "profile": args.profile, "universe": s["universe"], "place": s["place"],
              "placeVersion": args.place_version, "state": task.get("state"), "error": task.get("error"),
              "report": report, "logs": logs}
    path = evidence(f"smoke-{args.profile}", record)
    if task.get("state") != "COMPLETE" or report is None:
        print(f"SMOKE TASK {task.get('state')}: {json.dumps(task.get('error'), ensure_ascii=False)} · record {shown(path)}")
        return 1
    failed = [c for c in report.get("checks", []) if not c.get("ok")]
    for c in failed:
        print(f"  x {c.get('name')} {('· ' + str(c.get('detail'))) if c.get('detail') else ''}")
    verdict = "PASS" if report.get("pass") and not failed else "FAIL"
    print(f"CLOUD SMOKE RESULT: {verdict} ({len(report.get('checks', []))} checks, {len(failed)} failed)"
          f" · record {shown(path)}")
    return 0 if verdict == "PASS" else 1


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("status", help="show which settings are present")
    p = sub.add_parser("publish", help="publish a verified build")
    p.add_argument("profile")
    p.add_argument("--yes", action="store_true", help="actually send (default is a dry run)")
    p.add_argument("--saved", action="store_true", help="save a version without making it live")
    p.add_argument("--allow-main-place", action="store_true", help="permit publishing over place " + MAIN_PLACE_ID)
    for name, helptext in (("smoke", "run the cloud smoke test for a profile"), ("run", "run a task script file")):
        q = sub.add_parser(name, help=helptext)
        q.add_argument("profile" if name == "smoke" else "file")
        q.add_argument("--place-version", type=int, default=None, help="run on this place version (default: latest)")
        q.add_argument("--timeout", type=int, default=300, help="task timeout in seconds (Roblox maximum 300)")
    args = ap.parse_args()
    if getattr(args, "timeout", 300) > 300 or getattr(args, "timeout", 300) < 1:
        ap.error("--timeout must be between 1 and 300 seconds")
    try:
        return {"status": cmd_status, "publish": cmd_publish, "smoke": cmd_smoke, "run": cmd_run}[args.cmd](args)
    except CloudError as e:
        print(f"ERROR: {e}")
        return 2


if __name__ == "__main__":
    sys.exit(main())
