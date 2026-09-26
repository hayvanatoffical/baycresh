"""Assemble TOOLS/place_build/cloud_smoke.luau into one self-contained task script.

Open Cloud Luau Execution runs a single script and does not start the place's
own Scripts, so the scene builders, the migration and the K0 server runtime are
embedded as functions. Each source body is inserted unchanged; only the
function header supplies `script`, `print` and `warn`.

Used by TOOLS/roblox_cloud.py (real engine) and TOOLS/run_luau_harness.py
(scenario H17, mock engine) so both run exactly the same text.
"""
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TEMPLATE = ROOT / "TOOLS" / "place_build" / "cloud_smoke.luau"
MARKER = "--@@BUNDLE@@"

BUILD_ORDER = ["SCENE_BUILD", "STALL_ART_BUILD", "ART_V2_FIX", "STALL_ART_V3", "MARKET_SYSTEM_BUILD"]
EDIT_SOURCES = BUILD_ORDER + ["K0_MARKET_V3_MIGRATION"]
RUNTIME = "GAME/src/ServerScriptService/K0Market.server.lua"
CONFIG = "GAME/src/ReplicatedStorage/K0MarketConfig.lua"


def lua_literal(value) -> str:
    if value is None:
        return "nil"
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        return repr(value)
    if isinstance(value, str):
        return '"' + value.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n") + '"'
    if isinstance(value, dict):
        items = []
        for k in sorted(value):
            if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", str(k)):
                raise ValueError(f"unsupported key {k!r}")
            items.append(f"{k} = {lua_literal(value[k])}")
        return "{" + ", ".join(items) + "}"
    raise ValueError(f"unsupported value {value!r}")


def config_expectation(config_text: str) -> dict:
    """Version and numeric Prototype values, read from the config source text."""
    version = re.search(r'Version\s*=\s*"([^"]+)"', config_text).group(1)
    start = config_text.index("Prototype = {")
    end = config_text.index("Products = {", start)
    proto = {}
    for key, num in re.findall(r"\n\s*([A-Za-z_]\w*)\s*=\s*(-?\d+(?:\.\d+)?)\s*,", config_text[start:end]):
        proto[key] = float(num) if "." in num else int(num)
    return {"version": version, "prototype": proto}


def build_smoke_script(expect: dict) -> str:
    """expect: {"version": str, "profile": str | None, "prototype": {key: number}}"""
    template = TEMPLATE.read_text(encoding="utf-8")
    if template.count(MARKER) != 1:
        raise SystemExit(f"{TEMPLATE} must contain the marker line {MARKER} exactly once")
    parts = [
        "local EXPECT = " + lua_literal(expect),
        "local BUILD_ORDER = {" + ", ".join(lua_literal(n) for n in BUILD_ORDER) + "}",
        "local BUNDLE = {}",
    ]
    for name in EDIT_SOURCES:
        body = (ROOT / "GAME" / f"{name}.lua").read_text(encoding="utf-8")
        parts.append(f"BUNDLE.{name} = function(print, warn)\n{body}\nend")
    runtime = (ROOT / RUNTIME).read_text(encoding="utf-8")
    parts.append(f"BUNDLE.K0Market = function(script, print, warn)\n{runtime}\nend")
    return template.replace(MARKER, "\n".join(parts))
