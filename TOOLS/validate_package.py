#!/usr/bin/env python3
"""Static integrity checks for the BAYCREST K0.3 source package.

This is not a Roblox Studio/Luau runtime test. It verifies package topology,
version consistency, retired-runtime isolation, and local Markdown links.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parents[1]
EXPECTED_VERSION = "K0-market-0.3.0"
ERRORS: list[str] = []
WARNINGS: list[str] = []


def fail(msg: str) -> None:
    ERRORS.append(msg)


def warn(msg: str) -> None:
    WARNINGS.append(msg)


def read(rel: str) -> str:
    p = ROOT / rel
    if not p.is_file():
        fail(f"missing required file: {rel}")
        return ""
    try:
        return p.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        fail(f"not valid UTF-8 text: {rel}")
        return ""


required = [
    "README.md",
    "OKU-ONCE.md",
    "KARARLAR.md",
    "EKIP/07-YOL-HARITASI.md",
    "GAME/README.md",
    "GAME/K0_MARKET_V3_MIGRATION.lua",
    "GAME/src/ReplicatedStorage/K0MarketConfig.lua",
    "GAME/src/ServerScriptService/K0Market.server.lua",
    "GAME/src/StarterPlayerScripts/K0MarketHUD.client.lua",
    "GAME/legacy/K0Config.lua",
    "GAME/legacy/K0Game.server.lua",
    "GAME/legacy/K0HUD.client.lua",
    "PRODUCTION/K0_FINAL_AUDIT_2026-09-26.md",
    "PRODUCTION/K0_TEST_RECORD_TEMPLATE.md",
    "PRODUCTION/AI-ASSET-RIGHTS-AND-ATTRIBUTION-2026-09-26.md",
    "PRODUCTION/AI_TOOL_LICENSE_MATRIX_2026-09-26.md",
    "PRODUCTION/ASSET_PROVENANCE.md",
]
for rel in required:
    if not (ROOT / rel).is_file():
        fail(f"missing required file: {rel}")

active_lua = sorted((ROOT / "GAME/src").rglob("*.lua"))
expected_active = {
    (ROOT / "GAME/src/ReplicatedStorage/K0MarketConfig.lua").resolve(),
    (ROOT / "GAME/src/ServerScriptService/K0Market.server.lua").resolve(),
    (ROOT / "GAME/src/StarterPlayerScripts/K0MarketHUD.client.lua").resolve(),
}
if {p.resolve() for p in active_lua} != expected_active:
    fail("GAME/src must contain exactly the three K0.3 active runtime Lua files; found: " + ", ".join(str(p.relative_to(ROOT)) for p in active_lua))

for rel in ["README.md", "GAME/README.md", "GAME/src/ReplicatedStorage/K0MarketConfig.lua"]:
    text = read(rel)
    if EXPECTED_VERSION not in text:
        fail(f"version mismatch: {rel} does not contain {EXPECTED_VERSION}")

server = read("GAME/src/ServerScriptService/K0Market.server.lua")
hud = read("GAME/src/StarterPlayerScripts/K0MarketHUD.client.lua")
config = read("GAME/src/ReplicatedStorage/K0MarketConfig.lua")
active_text = "\n".join([server, hud, config])
if "CounterAcceptChance" in active_text:
    fail("retired hidden bargaining RNG CounterAcceptChance appears in active runtime")
if "PlaytestSeed" not in config or "TargetSessionSeconds" not in config:
    fail("controlled K0 playtest seed/session target missing from config")
permit_match = re.search(r"PermitPeriodSeconds\s*=\s*(\d+)", config)
target_match = re.search(r"TargetSessionSeconds\s*=\s*(\d+)", config)
if not permit_match or not target_match:
    fail("permit/session timing values could not be parsed from config")
elif int(permit_match.group(1)) <= int(target_match.group(1)):
    fail("K0 permit period must outlast the 20-minute core gate so renewal friction does not interrupt the tested loop")
if "__K0MarketRuntimeLock" not in server:
    fail("same-version runtime lock missing from server")
for token in ["K0FirstStockSeconds", "K0FirstOfferSeconds", "K0FirstDecisionSeconds", "K0DemandAlignedPurchases", "K0CounterSuccess", "K0WagePayments"]:
    if token not in server:
        fail(f"expected K0.3 telemetry field missing from server: {token}")
if 'action == "counter" and offer.kind ~= "Bargainer"' not in server:
    fail("server does not explicitly reject counter-offer action for non-bargainers")
if "economyRng = Random.new(C.PlaytestSeed" not in server or "state.sessionSerial" not in server or "waitForSession" not in server:
    fail("controlled economy RNG/session reset guard is incomplete")

# Retired runtime names must not reappear as active source filenames.
for retired in ["K0Config.lua", "K0Game.server.lua", "K0HUD.client.lua"]:
    matches = [p for p in (ROOT / "GAME").rglob(retired) if "legacy" not in p.parts]
    if matches:
        fail(f"retired runtime file outside GAME/legacy: {retired}: " + ", ".join(str(p.relative_to(ROOT)) for p in matches))

# Current-status documents must not contain the pre-code claim.
for rel in ["README.md", "OKU-ONCE.md", "DOKUMAN-DENETIMI.md", "GAME/README.md"]:
    if "Hiçbir kod yazılmadı" in read(rel):
        fail(f"stale no-code claim in current document: {rel}")

# Local Markdown links: ignore web URLs, mailto, anchors, and image data.
link_re = re.compile(r"(?<!!)\[[^\]]*\]\(([^)]+)\)")
for md in ROOT.rglob("*.md"):
    try:
        text = md.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        fail(f"not valid UTF-8 markdown: {md.relative_to(ROOT)}")
        continue
    for raw in link_re.findall(text):
        target = raw.strip().split()[0].strip("<>\"'")
        if not target or target.startswith(("http://", "https://", "mailto:", "#", "data:")):
            continue
        target = unquote(target.split("#", 1)[0])
        if not target:
            continue
        dest = (md.parent / target).resolve()
        try:
            dest.relative_to(ROOT.resolve())
        except ValueError:
            warn(f"link escapes package root: {md.relative_to(ROOT)} -> {target}")
            continue
        if not dest.exists():
            fail(f"broken local markdown link: {md.relative_to(ROOT)} -> {target}")

print(f"BAYCREST static validator — expected {EXPECTED_VERSION}")
print(f"Root: {ROOT}")
print(f"Active runtime Lua files: {len(active_lua)}")
if WARNINGS:
    print(f"Warnings: {len(WARNINGS)}")
    for item in WARNINGS:
        print(f"  WARN: {item}")
if ERRORS:
    print(f"FAIL — {len(ERRORS)} error(s)")
    for item in ERRORS:
        print(f"  ERROR: {item}")
    sys.exit(1)
print("PASS — package topology, current-version invariants, and local Markdown links are consistent.")
