#!/usr/bin/env python3
"""Static integrity checks for the BAYCREST K0.4.x source package.

This is not a Roblox Studio/Luau runtime test. It verifies package topology,
version consistency, retired-runtime isolation, local Markdown links, and the
source-level invariants that K0.4 established after the K0.3 audit and K0.4.1
added after the headless-harness findings, (K0.4.2) that every sound cue has
a well-formed candidate id with a provenance record, and (K0.4.3) that every NPC
is drawn with a known role and every HUD icon has a drawing.

Layer 1 of the validation. Layer 2 is TOOLS/simulate_k0.py (+ scenarios_k0.py),
which runs the economy/scenario model instead of inspecting the text. Layer 3
is TOOLS/run_luau_harness.py, which executes the real Luau sources on a mock
engine. Layer 4 is TOOLS/build_place.py, which builds and verifies .rbxl place
files with Lune (no Studio). Layer 5, TOOLS/roblox_cloud.py, publishes to Roblox
and runs a smoke test there; it needs the owner's key and is never run here.
"""
from __future__ import annotations

import re
import shutil
import subprocess
import sys
from pathlib import Path
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parents[1]
EXPECTED_VERSION = "K0-market-0.4.3"
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


# ---------------------------------------------------------------- topology
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
    "PRODUCTION/K0.4_IMPLEMENTATION_REPORT.md",
    "PRODUCTION/K0.4_DOUBLE_VALIDATION_REPORT.md",
    "PRODUCTION/K0.4_KNOWN_LIMITATIONS.md",
    "PRODUCTION/K0.4_NEXT_TEST_PLAN.md",
    "PRODUCTION/K0.4_ASSET_REQUIREMENTS.md",
    "PRODUCTION/K0.4.1_IMPLEMENTATION_REPORT.md",
    "TOOLS/simulate_k0.py",
    "TOOLS/scenarios_k0.py",
    "TOOLS/run_luau_harness.py",
    "TOOLS/luau_harness/README.md",
    "TOOLS/luau_harness/engine.luau",
    "TOOLS/luau_harness/k0_world.luau",
    "TOOLS/luau_harness/k0_scenarios.luau",
    "TOOLS/build_place.py",
    "TOOLS/roblox_cloud.py",
    "TOOLS/test_roblox_cloud.py",
    "TOOLS/place_build/README.md",
    "TOOLS/place_build/build_place.luau",
    "TOOLS/place_build/cloud_smoke.luau",
    "TOOLS/place_build/smoke_bundle.py",
    "PRODUCTION/K0_STUDIOSUZ_TEST_YOLU.md",
    "ASSET-PROMPTS/00-ASSET-PIPELINE.md",
    "ASSET-PROMPTS/01-3D-CHARACTERS.md",
    "ASSET-PROMPTS/02-3D-ENVIRONMENT.md",
    "ASSET-PROMPTS/03-3D-PROPS.md",
    "ASSET-PROMPTS/04-ANIMATION.md",
    "ASSET-PROMPTS/05-MUSIC.md",
    "ASSET-PROMPTS/06-SFX.md",
    "ASSET-PROMPTS/07-UI-ICONOGRAPHY.md",
    "ASSET-PROMPTS/08-MATERIALS-TEXTURES.md",
    "ASSET-PROMPTS/09-VOICE-OPTIONAL.md",
    "ASSET-PROMPTS/10-ASSET-VALIDATION.md",
    "ASSET-PROMPTS/11-LICENSE-AND-PROVENANCE.md",
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
    fail("GAME/src must contain exactly the three active runtime Lua files; found: "
         + ", ".join(str(p.relative_to(ROOT)) for p in active_lua))

for rel in ["README.md", "GAME/README.md", "GAME/src/ReplicatedStorage/K0MarketConfig.lua"]:
    if EXPECTED_VERSION not in read(rel):
        fail(f"version mismatch: {rel} does not contain {EXPECTED_VERSION}")

server = read("GAME/src/ServerScriptService/K0Market.server.lua")
hud = read("GAME/src/StarterPlayerScripts/K0MarketHUD.client.lua")
config = read("GAME/src/ReplicatedStorage/K0MarketConfig.lua")
active_text = "\n".join([server, hud, config])

# ------------------------------------------------- retired mechanics/files
if "CounterAcceptChance" in active_text:
    fail("retired hidden bargaining RNG CounterAcceptChance appears in active runtime")
for retired in ["K0Config.lua", "K0Game.server.lua", "K0HUD.client.lua"]:
    matches = [p for p in (ROOT / "GAME").rglob(retired) if "legacy" not in p.parts]
    if matches:
        fail(f"retired runtime file outside GAME/legacy: {retired}: "
             + ", ".join(str(p.relative_to(ROOT)) for p in matches))

# -------------------------------------------------------- K0 timing locks
if "PlaytestSeed" not in config or "TargetSessionSeconds" not in config:
    fail("controlled K0 playtest seed/session target missing from config")
permit_match = re.search(r"PermitPeriodSeconds\s*=\s*(\d+)", config)
target_match = re.search(r"TargetSessionSeconds\s*=\s*(\d+)", config)
if not permit_match or not target_match:
    fail("permit/session timing values could not be parsed from config")
elif int(permit_match.group(1)) <= int(target_match.group(1)):
    fail("K0 permit period must outlast the 20-minute core gate so renewal friction "
         "does not interrupt the tested loop")

# --------------------------------------------------- runtime isolation
if "__K0MarketRuntimeLock" not in server:
    fail("same-version runtime lock missing from server")
if "economyRng = Random.new(C.PlaytestSeed" not in server or "state.sessionSerial" not in server \
        or "waitForSession" not in server:
    fail("controlled economy RNG/session reset guard is incomplete")

# --------------------------------------- K0.4 product / economy invariants
# A whole-bundle-only restock combined with Level1Capacity == WholesaleBundle made
# a shelf with any leftover unit impossible to refill. Lock both halves down.
product_blocks = re.findall(
    r"(\w+)\s*=\s*\{\s*\n\s*Name\s*=.*?\n(.*?)\n\s*\},", config, re.S)
if len(product_blocks) < 2:
    fail("could not parse product table from config")
for sku, body in product_blocks:
    def field(name: str):
        m = re.search(rf"\b{name}\s*=\s*(\d+)", body)
        return int(m.group(1)) if m else None

    bundle, cost = field("WholesaleBundle"), field("WholesaleCost")
    cap1, cap2 = field("Level1Capacity"), field("Level2Capacity")
    if None in (bundle, cost, cap1, cap2):
        fail(f"product {sku}: missing one of WholesaleBundle/WholesaleCost/Level1Capacity/Level2Capacity")
        continue
    if cost % bundle != 0:
        fail(f"product {sku}: WholesaleCost {cost} must divide evenly by WholesaleBundle "
             f"{bundle} so a partial restock is priced per unit without rounding drift")
    if cap1 < bundle:
        fail(f"product {sku}: Level1Capacity {cap1} is smaller than one bundle {bundle}")
    if cap2 < cap1:
        fail(f"product {sku}: Level2Capacity {cap2} must not be below Level1Capacity {cap1}")

if re.search(r"state\.stock\[sku\]\s*\+\s*product\.WholesaleBundle\s*>\s*cap", server):
    fail("whole-bundle-only restock check is back: a shelf holding any leftover unit "
         "can never be topped up (K0.3 stock deadlock)")
if "capacityFor" not in server or "unitCost" not in server:
    fail("K0.4 partial restock helpers (unitCost/capacityFor) missing from server")

# ------------------------------------------------- K0.4 dead-end recovery
for token, why in [
    ("liquidate", "liquidation route out of a lapsed registration"),
    ("LiquidationRatio", "liquidation ratio read from config"),
    ("rescueGrants", "bounded rescue grant counter"),
    ("RescueGrantLimit", "rescue grant limit read from config"),
]:
    if token not in server:
        fail(f"K0.4 dead-end recovery incomplete: missing {token} ({why})")
if "K0RescueGrants" not in server:
    fail("rescue grants must be published as telemetry so an observer sees them")

# ------------------------------------------ K0.4.1 stranding / dead-end guards
# The harness proved that paying for an upgrade, a cashier, a wage or a renewal
# could leave an empty shelf and less cash than one unit of stock, which no
# customer can ever fix. Every discretionary spend must pass through the guard.
if "local function wouldStrand" not in server or "minUnitCost" not in server:
    fail("K0.4.1 stranding guard (wouldStrand/minUnitCost) missing from server")
for label in ["Raf yükseltmesi", "Kasiyer ücreti", "Maaş"]:
    if f'strandNotice("{label}"' not in server:
        fail(f"K0.4.1 stranding guard not applied to: {label}")
if "wouldStrand(fee)" not in server:
    fail("permit renewal does not check whether paying the fee strands the stall")
if "reportDeadEnd" not in server or "dead_end seconds=" not in server:
    fail("an unrecoverable economy state must be reported (dead_end telemetry line)")
if "BindToClose" not in server:
    fail("session summary is not printed on server shutdown (BindToClose)")
if "task.defer(chooseNextOwner" not in server:
    fail("owner handover must run after the leaving player is gone (task.defer)")

# ------------------------------------------------------- remote hardening
if "acceptDecisionCall" not in server or "DecisionRateLimit" not in server:
    fail("RemoteEvent rate limiting missing from server decision handler")
if 'action == "counter" and offer.kind ~= "Bargainer"' not in server:
    fail("server does not explicitly reject counter-offer action for non-bargainers")
if "id % 1 ~= 0" not in server:
    fail("server does not reject non-integer/NaN offer ids from the client")

# Actions accepted by the server must match exactly what the client can send.
server_actions = set(re.findall(r'action\s*[~=]=\s*"(\w+)"', server))
client_actions = set(re.findall(r'send\("(\w+)"\)', hud))
if server_actions != client_actions:
    fail(f"RemoteEvent action mismatch: server accepts {sorted(server_actions)}, "
         f"client sends {sorted(client_actions)}")

# ------------------------------------------- attribute producer/consumer parity
# A HUD reading an attribute the server never writes silently renders a default.
produced = set(re.findall(r'SetAttribute\("(K0\w+)"', server))
consumed = set(re.findall(r'GetAttribute\("(K0\w+)"', hud))
watched = set(re.findall(r'"(K0\w+)"', hud.split("local attributes = {", 1)[-1]))
orphan_reads = consumed - produced
if orphan_reads:
    fail(f"HUD reads attributes the server never writes: {sorted(orphan_reads)}")
# An attribute paired with a "<name>Serial" subscription is refreshed by that
# signal on purpose (the HUD reads K0Notice when K0NoticeSerial changes), so a
# direct subscription would only cause a duplicate render.
unwatched = {a for a in (consumed & produced) - watched if f"{a}Serial" not in watched}
if unwatched:
    warn(f"HUD reads but does not subscribe to: {sorted(unwatched)} (may render stale)")

# ------------------------------------------------- config field consumption
proto = config.split("Prototype = {", 1)[-1].split("\n    Sounds = {", 1)[0]
config_keys = set(re.findall(r"^\s{8}(\w+)\s*=", proto, re.M))
used_keys = set(re.findall(r"\bC\.(\w+)", server)) | set(re.findall(r"\bC\.(\w+)", hud))
missing_in_config = used_keys - config_keys
if missing_in_config:
    fail(f"runtime reads config fields that do not exist in Prototype: {sorted(missing_in_config)}")
unused = config_keys - used_keys
if unused:
    warn(f"config fields defined but never read by the runtime: {sorted(unused)}")

# ------------------------------------------------------- K0.4.2 sound cues
# ASSET-PROMPTS/06-SFX.md lists twelve cues. Each config slot holds a Creator
# Store candidate id (or "" for silent) and a Sound.Volume; each id must have a
# row in PRODUCTION/ASSET_PROVENANCE.md so an unlisted asset cannot slip in.
SFX_SLOTS = {"SaleSuccess", "Cash", "UiClick", "StockPlace", "CustomerArrive", "SaleFail",
             "Negotiate", "Upgrade", "Hire", "Notify", "PermitLapse", "Liquidate"}
sounds_block = re.search(r"\n    Sounds = \{\n(.*?)\n    \},", config, re.S)
if not sounds_block:
    fail("K0.4.2 Sounds table missing from config")
else:
    entries = re.findall(r'^\s{8}(\w+)\s*=\s*\{Id\s*=\s*"([^"]*)",\s*Volume\s*=\s*([\d.]+)\}',
                         sounds_block.group(1), re.M)
    slots = {name for name, _, _ in entries}
    if slots != SFX_SLOTS:
        fail(f"Sounds slots differ from 06-SFX: missing {sorted(SFX_SLOTS - slots)}, "
             f"unexpected {sorted(slots - SFX_SLOTS)}")
    provenance = read("PRODUCTION/ASSET_PROVENANCE.md")
    for name, sid, vol in entries:
        if sid and not re.fullmatch(r"rbxassetid://\d+", sid):
            fail(f"Sounds.{name}: Id must be rbxassetid://<number> or empty, got {sid!r}")
        if not 0 < float(vol) <= 2:
            fail(f"Sounds.{name}: Volume {vol} outside (0, 2]")
        if sid and f"store/asset/{sid.split('//', 1)[1]}" not in provenance:
            fail(f"Sounds.{name}: asset {sid} has no store-linked row in PRODUCTION/ASSET_PROVENANCE.md")
    played = set(re.findall(r'\b(?:play|want)\("(\w+)"\)', hud)) | set(re.findall(r'\bplay,\s*"(\w+)"', hud))
    if played != SFX_SLOTS:
        fail(f"HUD cues differ from config slots: never played {sorted(SFX_SLOTS - played)}, "
             f"no slot for {sorted(played - SFX_SLOTS)}")

# --------------------------------------------- K0.4.3 readability greybox
# ASSET-PROMPTS/01: a bargainer must read apart from a buyer before the card
# opens, so every figure is drawn for a role. A call without a role silently
# falls back to the plain passer-by look.
NPC_ROLES = {"Buyer", "Bargainer", "Browser", "Worker", "Passerby", "Pedestrian"}
looks_block = re.search(r"\nlocal looks = \{\n(.*?)\n\}\n(.*?)\nlocal function makeNpc", server, re.S)
if not looks_block:
    fail("K0.4.3 NPC role looks table missing from server")
else:
    looks = set(re.findall(r"^\s{4}(\w+)\s*=", looks_block.group(1), re.M)) \
        | set(re.findall(r"^looks\.(\w+)\s*=", looks_block.group(2), re.M))
    if looks != NPC_ROLES:
        fail(f"NPC looks differ from the K0 roles: missing {sorted(NPC_ROLES - looks)}, "
             f"unexpected {sorted(looks - NPC_ROLES)}")
    for call in re.findall(r"\bmakeNpc\(([^()]*(?:\([^()]*\)[^()]*)*)\)", server):
        if call.startswith("name, position"):
            continue
        role = call.rsplit(",", 1)[-1].strip() if call.count(",") >= 2 else ""
        if role != "kind" and role.strip('"') not in NPC_ROLES:
            fail(f"makeNpc call without a known role: makeNpc({call})")
# ASSET-PROMPTS/07 priority-1 icons and the budget gauge, drawn from UI frames
# until the image set exists.
HUD_ICONS = {"Cash", "Orange", "Bread", "DemandUp", "Permit", "Budget"}
drawn = set(re.findall(r"^\s{4}(\w+)\s*=\s*function\(box\)", hud, re.M))
used_icons = set(re.findall(r'\bicon\(\w+,\s*"(\w+)"', hud))
if drawn != HUD_ICONS or used_icons != HUD_ICONS:
    fail(f"HUD icons: drawn {sorted(drawn)}, placed {sorted(used_icons)}, expected {sorted(HUD_ICONS)}")

# ------------------------------------------------- telemetry completeness
for token in ["K0FirstStockSeconds", "K0FirstOfferSeconds", "K0FirstDecisionSeconds",
              "K0DemandAlignedPurchases", "K0CounterSuccess", "K0WagePayments",
              "K0Liquidations", "K0DeadEndSeconds"]:
    if token not in server:
        fail(f"expected telemetry field missing from server: {token}")

# Every %d/%s in the summary format string needs exactly one argument.
summary = re.search(r'"\[Baycrest K0\] summary (.*?)",\n(.*?)\n\s*\)\)', server, re.S)
if not summary:
    fail("could not locate the session summary print for argument checking")
else:
    specs = len(re.findall(r"%[ds]", summary.group(1)))
    args = [a for a in (x.strip() for x in summary.group(2).replace("\n", " ").split(","))
            if a]
    if specs != len(args):
        fail(f"session summary format takes {specs} values but {len(args)} are passed")

# --------------------------------------------------- stale-claim guards
for rel in ["README.md", "OKU-ONCE.md", "DOKUMAN-DENETIMI.md", "GAME/README.md"]:
    text = read(rel)
    if "Hiçbir kod yazılmadı" in text:
        fail(f"stale no-code claim in current document: {rel}")
    if "Roblox'ta doğrulandı" in text or "Studio'da doğrulandı" in text:
        fail(f"{rel} claims Studio verification that this package cannot support")

# ------------------------------------------------------ Luau syntax gate
luau = shutil.which("luau-compile") or "/tmp/luaubin/luau-compile"
if Path(luau).exists():
    for p in sorted(expected_active):
        r = subprocess.run([luau, "--null", str(p)], capture_output=True, text=True)
        if r.returncode != 0:
            fail(f"Luau syntax error in {p.relative_to(ROOT)}: "
                 f"{(r.stderr or r.stdout).strip().splitlines()[:1]}")
else:
    warn("luau-compile not available; Luau syntax was not machine-checked in this run")

# ------------------------------------------------------ markdown links
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
print("PASS — topology, version invariants, economy/runtime invariants, "
      "attribute and action parity, Luau syntax, and local Markdown links are consistent.")
