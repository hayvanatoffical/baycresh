#!/usr/bin/env python3
"""Offline test of TOOLS/roblox_cloud.py against a local fake of the Roblox Open Cloud API.

No Roblox account or key is used. The fake answers the documented request and
response shapes (place publishing, Luau execution task create/poll/logs) so the
client's request format, polling, retry, guards and secret handling are tested.
It does not prove that Roblox accepts the requests; that needs the owner's key.

Requires a verified default build: python3 TOOLS/build_place.py default
"""
from __future__ import annotations

import json
import os
import shutil
import subprocess
import sys
import tempfile
import threading
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CLI = ROOT / "TOOLS" / "roblox_cloud.py"
sys.path.insert(0, str(CLI.parent))
from roblox_cloud import short_version  # noqa: E402  (the rule the CLI uses to pick a build)
KEY = "TEST-KEY-must-never-be-printed-8c1f"
UNIVERSE, PLACE, MAIN = "111", "222", "83986068176961"


class Fake:
    def __init__(self):
        self.requests = []
        self.mode = "pass"   # pass | fail_report | fail_task
        self.polls = 0
        self.logs_429 = True


FAKE = Fake()


def report(ok: bool) -> dict:
    checks = [{"ok": True, "name": "scene exists"}, {"ok": ok, "name": "board shows config price", "detail": "x"}]
    return {"pass": ok, "checks": checks, "notes": [], "output": []}


class Handler(BaseHTTPRequestHandler):
    def log_message(self, *_):
        pass

    def _send(self, code: int, obj: dict):
        raw = json.dumps(obj).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(raw)))
        self.end_headers()
        self.wfile.write(raw)

    def _record(self, body: bytes):
        FAKE.requests.append({"method": self.command, "path": self.path, "headers": {k.lower(): v for k, v in self.headers.items()}, "body": body})

    def do_POST(self):
        body = self.rfile.read(int(self.headers.get("Content-Length", 0)))
        self._record(body)
        if self.headers.get("x-api-key") != KEY:
            return self._send(401, {"message": "bad key"})
        if self.path.startswith(f"/universes/v1/{UNIVERSE}/places/{PLACE}/versions?versionType="):
            return self._send(200, {"versionNumber": 7})
        if self.path == f"/cloud/v2/universes/{UNIVERSE}/places/{PLACE}/luau-execution-session-tasks":
            FAKE.polls = 0
            return self._send(200, {"path": f"universes/{UNIVERSE}/places/{PLACE}/versions/7/luau-execution-sessions/s1/tasks/t1",
                                    "state": "QUEUED"})
        return self._send(404, {"message": "no route"})

    def do_GET(self):
        self._record(b"")
        if self.headers.get("x-api-key") != KEY:
            return self._send(401, {"message": "bad key"})
        task = f"/cloud/v2/universes/{UNIVERSE}/places/{PLACE}/versions/7/luau-execution-sessions/s1/tasks/t1"
        if self.path == task:
            FAKE.polls += 1
            if FAKE.polls < 2:
                return self._send(200, {"path": task[10:], "state": "PROCESSING"})
            if FAKE.mode == "fail_task":
                return self._send(200, {"path": task[10:], "state": "FAILED",
                                        "error": {"code": "SCRIPT_ERROR", "message": "boom"}})
            return self._send(200, {"path": task[10:], "state": "COMPLETE",
                                    "output": {"results": [report(FAKE.mode == "pass")]}})
        if self.path.startswith(task + "/logs"):
            if FAKE.logs_429:
                FAKE.logs_429 = False
                return self._send(429, {"message": "slow down"})
            return self._send(200, {"luauExecutionSessionTaskLogs": [{"messages": ["SMOKE PASS scene exists", "SMOKE RESULT: PASS"]}]})
        return self._send(404, {"message": "no route"})


def run(args, env_extra, place_dir):
    env = {k: v for k, v in os.environ.items() if not k.startswith("ROBLOX_")}
    env.update({"K0_PLACE_DIR": str(place_dir)})
    env.update(env_extra)
    r = subprocess.run([sys.executable, str(CLI)] + args, capture_output=True, text=True, env=env, timeout=120)
    return r.returncode, r.stdout + r.stderr


def main() -> int:
    src = ROOT / "dist" / "place"
    # dist/place keeps the builds of earlier versions too. Copy only the build of
    # the current source version: the CLI publishes that one, so the byte-for-byte
    # and tamper checks must look at the same file (K0.4.3 fix; picking any
    # "*-default.rbxl" compared against an older build once two versions existed).
    stem = f"BAYCREST-{short_version()}-default"
    if not (src / f"{stem}.rbxl").exists():
        print(f"SKIP — no default build for {short_version()}. Run: python3 TOOLS/build_place.py default")
        return 2
    server = ThreadingHTTPServer(("127.0.0.1", 0), Handler)
    threading.Thread(target=server.serve_forever, daemon=True).start()
    base = f"http://127.0.0.1:{server.server_address[1]}"
    env = {"ROBLOX_API_KEY": KEY, "ROBLOX_UNIVERSE_ID": UNIVERSE, "ROBLOX_PLACE_ID": PLACE, "ROBLOX_API_BASE": base}
    results = []
    outputs = []

    def check(ok, name, out=""):
        results.append((bool(ok), name))
        if not ok and out:
            print(out[-1500:])

    with tempfile.TemporaryDirectory() as tmp:
        place_dir = Path(tmp)
        for f in src.glob(f"{stem}.*"):
            shutil.copy(f, place_dir / f.name)
        place = place_dir / f"{stem}.rbxl"

        code, out = run(["status"], {}, place_dir); outputs.append(out)
        check(code == 2 and "MISSING" in out, "status without settings reports MISSING and exits 2", out)

        code, out = run(["status"], env, place_dir); outputs.append(out)
        check(code == 0 and "ROBLOX_API_KEY       set" in out, "status with settings shows the key only as 'set'", out)

        code, out = run(["publish", "default"], {**env, "ROBLOX_API_BASE": "http://example.com"}, place_dir); outputs.append(out)
        check(code == 2 and "must be https" in out, "plain http to a non-local host is refused", out)

        n = len(FAKE.requests)
        code, out = run(["publish", "default"], env, place_dir); outputs.append(out)
        check(code == 0 and "DRY RUN" in out and len(FAKE.requests) == n, "publish without --yes sends nothing", out)

        code, out = run(["publish", "default", "--yes"], {**env, "ROBLOX_PLACE_ID": MAIN}, place_dir); outputs.append(out)
        check(code == 2 and "refusing to publish over the main K0 place" in out and len(FAKE.requests) == n,
              "main place is refused without --allow-main-place", out)

        code, out = run(["publish", "default", "--yes"], env, place_dir); outputs.append(out)
        sent = FAKE.requests[-1] if len(FAKE.requests) > n else {}
        check(code == 0 and "PUBLISHED place version 7 (Published)" in out, "publish --yes reports the version", out)
        check(sent.get("path", "").endswith("versionType=Published"), "publish uses versionType=Published")
        check(sent.get("headers", {}).get("content-type") == "application/octet-stream", "publish sends a binary place")
        check(sent.get("body") == place.read_bytes(), "publish body is the verified file, byte for byte")
        check(any(place_dir.glob("publish-default-*.json")), "publish writes an evidence record")

        code, out = run(["publish", "default", "--yes", "--saved"], env, place_dir); outputs.append(out)
        check(FAKE.requests[-1]["path"].endswith("versionType=Saved"), "--saved uses versionType=Saved", out)

        FAKE.mode, FAKE.logs_429 = "pass", True
        code, out = run(["smoke", "default"], env, place_dir); outputs.append(out)
        create = [r for r in FAKE.requests if r["method"] == "POST" and "luau-execution" in r["path"]][-1]
        body = json.loads(create["body"])
        check(code == 0 and "CLOUD SMOKE RESULT: PASS" in out, "smoke passes on a passing report (after one 429 retry)", out)
        check(body.get("timeout") == "300s", "smoke asks for a 300 s timeout")
        check('profile = "default"' in body.get("script", "") and "SMOKE RESULT" in body.get("script", ""),
              "smoke sends the bundled script with the profile expectation")
        check("BUNDLE.K0Market = function(script, print, warn)" in body.get("script", ""), "runtime is embedded in the task script")
        check(any(place_dir.glob("smoke-default-*.json")), "smoke writes an evidence record")

        FAKE.mode = "fail_report"
        code, out = run(["smoke", "default"], env, place_dir); outputs.append(out)
        check(code == 1 and "CLOUD SMOKE RESULT: FAIL" in out and "board shows config price" in out,
              "a failing smoke check fails the command and is named", out)

        FAKE.mode = "fail_task"
        code, out = run(["smoke", "default"], env, place_dir); outputs.append(out)
        check(code == 1 and "SMOKE TASK FAILED" in out and "boom" in out, "a failed task fails the command with its error", out)

        with open(place, "ab") as fh:
            fh.write(b"\0")
        n = len(FAKE.requests)
        code, out = run(["publish", "default", "--yes"], env, place_dir); outputs.append(out)
        check(code == 2 and "sha256 mismatch" in out and len(FAKE.requests) == n, "a file changed after verification is refused", out)

        check(all(KEY not in o for o in outputs), "the API key never appears in any output")
        check(all(r["headers"].get("x-api-key") == KEY for r in FAKE.requests), "every request carries the key header")
        evidence_text = "".join(p.read_text() for p in place_dir.glob("*-*T*Z.json"))
        check(KEY not in evidence_text, "evidence records do not contain the key")

    server.shutdown()
    failed = [n for ok, n in results if not ok]
    for ok, name in results:
        print(("PASS " if ok else "FAIL ") + name)
    print(f"{len(results)} checks, {len(failed)} failed")
    print("CLOUD CLIENT TEST: " + ("PASS" if not failed else "FAIL"))
    return 0 if not failed else 1


if __name__ == "__main__":
    sys.exit(main())
