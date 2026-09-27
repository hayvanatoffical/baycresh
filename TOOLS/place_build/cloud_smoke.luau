--!nocheck
-- K0 cloud smoke test: the task script for Roblox Open Cloud Luau Execution.
--
-- Runs inside a real Roblox game server on the published place version, without
-- Studio. Roblox documents that a task's DataModel changes are local to the task
-- and are not saved, that physics does not run, that Scripts in the place do not
-- start by themselves and that no players exist. This script therefore:
--   1. re-runs the scene builders and the migration on the real engine and checks
--      they leave the scene unchanged (idempotency, real property validation);
--   2. requires the config module and compares it with the published profile;
--   3. starts the K0 server runtime itself and reads what it wrote to the world.
-- It never calls DataStores, SavePlaceAsync or HTTP.
--
-- TOOLS/place_build/smoke_bundle.py replaces the marker line below with EXPECT and
-- BUNDLE (every source wrapped in a function). The same bundle also runs in the
-- Luau harness as scenario H17, so this script's logic is tested before use.
--@@BUNDLE@@

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local report = {pass = true, checks = {}, notes = {}, output = {}}
local realPrint, realWarn = print, warn

local function check(ok, name, detail)
    ok = ok and true or false
    table.insert(report.checks, {ok = ok, name = name, detail = detail})
    if not ok then report.pass = false end
    realPrint(string.format("SMOKE %s %s%s", ok and "PASS" or "FAIL", name, detail and (" · " .. tostring(detail)) or ""))
end

local function note(text)
    table.insert(report.notes, text)
    realPrint("SMOKE NOTE " .. text)
end

local function capture(label)
    local function out(kind, realFn)
        return function(...)
            local n = select("#", ...)
            local parts = {}
            for i = 1, n do parts[i] = tostring((select(i, ...))) end
            local line = table.concat(parts, " ")
            table.insert(report.output, {source = label, kind = kind, line = line})
            realFn(...)
        end
    end
    return out("print", realPrint), out("warn", realWarn)
end

local function outputMatching(pattern)
    local hits = {}
    for _, o in ipairs(report.output) do
        if string.find(o.line, pattern) then table.insert(hits, o) end
    end
    return hits
end

local function firstLine(err)
    return string.match(tostring(err), "[^\n]+") or tostring(err)
end

local scene = Workspace:FindFirstChild("BlackstoneBazaar_K0")
check(scene ~= nil, "scene Workspace/BlackstoneBazaar_K0 exists")
if not scene then
    return report
end

-- Which build is this? A mismatch means the task ran on a different place version.
local profile = Workspace:GetAttribute("K0BuildProfile")
local version = Workspace:GetAttribute("K0BuildVersion")
if EXPECT.profile then
    check(profile == EXPECT.profile and version == EXPECT.version, "place build is the expected one",
        string.format("place %s/%s, expected %s/%s", tostring(profile), tostring(version), EXPECT.profile, EXPECT.version))
else
    note(string.format("build attributes: profile=%s version=%s", tostring(profile), tostring(version)))
end

-- 1. Builders and migration on this engine: no errors, no duplicates.
local before = #scene:GetDescendants()
for _, name in ipairs(BUILD_ORDER) do
    local p, w = capture(name)
    local ok, err = pcall(BUNDLE[name], p, w)
    check(ok, "builder re-run " .. name, not ok and firstLine(err) or nil)
end
local afterBuilders = #scene:GetDescendants()
check(before == afterBuilders, "re-running every builder leaves the scene unchanged", before .. " -> " .. afterBuilders)

local migrationCounts = {}
for run = 1, 2 do
    local p, w = capture("K0_MARKET_V3_MIGRATION")
    local ok, err = pcall(BUNDLE.K0_MARKET_V3_MIGRATION, p, w)
    check(ok, "migration run " .. run, not ok and firstLine(err) or nil)
    migrationCounts[run] = #scene:GetDescendants()
end
check(migrationCounts[1] == migrationCounts[2], "migration is idempotent", migrationCounts[1] .. " -> " .. migrationCounts[2])

local market = scene:FindFirstChild("MarketSystem")
local board = market and market:FindFirstChild("DemandBoard")
if board then
    local faces = {}
    for _, g in ipairs(board:GetChildren()) do
        if g:IsA("SurfaceGui") then faces[g.Face.Name] = (faces[g.Face.Name] or 0) + 1 end
    end
    check((faces.Front or 0) <= 1 and (faces.Back or 0) <= 1, "demand board has one text layer per face",
        string.format("Front=%d Back=%d", faces.Front or 0, faces.Back or 0))
else
    check(false, "MarketSystem/DemandBoard exists")
end

-- 2. Config as published.
local configModule = ReplicatedStorage:FindFirstChild("K0MarketConfig")
check(configModule ~= nil and configModule:IsA("ModuleScript"), "ReplicatedStorage/K0MarketConfig is a ModuleScript")
local okConfig, Config = pcall(require, configModule)
check(okConfig and type(Config) == "table", "config module requires", not okConfig and firstLine(Config) or nil)
if not (okConfig and type(Config) == "table") then
    return report
end
check(Config.Version == EXPECT.version, "config version", tostring(Config.Version))
local mismatched = {}
for key, value in pairs(EXPECT.prototype or {}) do
    if Config.Prototype[key] ~= value then
        table.insert(mismatched, string.format("%s=%s (expected %s)", key, tostring(Config.Prototype[key]), tostring(value)))
    end
end
table.sort(mismatched)
check(#mismatched == 0, "config Prototype values match the published profile", #mismatched > 0 and table.concat(mismatched, ", ") or nil)
local C = Config.Prototype

-- 3. Start the runtime the way a server would, then read the world.
local runtimeScript = ServerScriptService:FindFirstChild("K0Market")
check(runtimeScript ~= nil and runtimeScript:IsA("Script"), "ServerScriptService/K0Market is a Script")
check(ServerScriptService:FindFirstChild("K0Game") == nil, "legacy K0Game absent")
local sps = game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts")
local hud = sps and sps:FindFirstChild("K0MarketHUD")
check(hud ~= nil and hud:IsA("LocalScript"), "StarterPlayerScripts/K0MarketHUD is a LocalScript")
local motion = sps and sps:FindFirstChild("K0NpcMotion")
check(motion ~= nil and motion:IsA("LocalScript"), "StarterPlayerScripts/K0NpcMotion is a LocalScript")

local runtimePrint, runtimeWarn = capture("K0Market")
local okRuntime, runtimeErr = pcall(BUNDLE.K0Market, runtimeScript, runtimePrint, runtimeWarn)
check(okRuntime, "runtime starts without error", not okRuntime and firstLine(runtimeErr) or nil)

local t0 = os.clock()
task.wait(2)
note(string.format("task.wait(2) took %.2f s of os.clock", os.clock() - t0))

local ready = outputMatching("^Baycrest K0 market server ready")
check(#ready == 1, "exactly one ready line", #ready .. " found")
check(#ready == 1 and string.find(ready[1].line, EXPECT.version, 1, true) ~= nil, "ready line carries " .. EXPECT.version)
local warnings = {}
for _, o in ipairs(report.output) do
    if o.source == "K0Market" and o.kind == "warn" then table.insert(warnings, o.line) end
end
check(#warnings == 0, "runtime printed no warnings", #warnings > 0 and table.concat(warnings, " | ") or nil)
check(scene:GetAttribute("K0RuntimeVersion") == EXPECT.version, "scene K0RuntimeVersion attribute", tostring(scene:GetAttribute("K0RuntimeVersion")))

local function detailText(part)
    if not part then return nil end
    for _, gui in ipairs(part:GetChildren()) do
        if gui:IsA("SurfaceGui") then
            local detail = gui:FindFirstChild("Detail")
            if detail and detail:IsA("TextLabel") then return detail.Text end
        end
    end
    return nil
end

local interaction = scene:FindFirstChild("Interaction")
local boards = {
    {market and market:FindFirstChild("PermitOffice"), "PAZAR KAYDI " .. C.PermitFee .. " ₡"},
    {interaction and interaction:FindFirstChild("UpgradeBoard"), C.UpgradeCost .. " ₡ / DAHA ÇOK STOK"},
    {interaction and interaction:FindFirstChild("HireBoard"), C.HireCost .. " ₡ / OTOMATİK SATIŞ"},
    {interaction and interaction:FindFirstChild("PayBoard"), C.WagePerShift .. " ₡ / VARDİYA"},
}
for _, b in ipairs(boards) do
    local text = detailText(b[1])
    check(text == b[2], "board shows config price: " .. b[2], text and ("got " .. text) or "board or label missing")
end
local demandText = board and detailText(board)
local bonus = math.floor(C.DemandBonusRatio * 100 + 0.5)
check(demandText ~= nil and string.find(demandText, "+" .. bonus .. "%", 1, true) ~= nil,
    "demand board shows +" .. bonus .. "%", tostring(demandText))

-- K0.4.7: the demanded product's world price tag carries the demand line.
local displays = scene:FindFirstChild("ProductDisplays")
local marked, tagTexts = 0, {}
for _, name in ipairs({"OrangePrice", "BreadPrice"}) do
    local part = displays and displays:FindFirstChild(name)
    local text
    for _, gui in ipairs(part and part:GetChildren() or {}) do
        local price = gui:IsA("SurfaceGui") and gui:FindFirstChild("Price")
        if price and price:IsA("TextLabel") then text = price.Text end
    end
    table.insert(tagTexts, name .. "=" .. string.gsub(tostring(text), "\n", " / "))
    if text and string.find(text, "\nTALEP +" .. bonus .. "%", 1, true) then marked += 1 end
end
check(marked == 1, "exactly one price tag carries the demand line", table.concat(tagTexts, " | "))

local signText = scene:FindFirstChild("Stall_01") and scene.Stall_01:FindFirstChild("NameSign")
signText = signText and signText:FindFirstChild("SignSurface")
signText = signText and signText:FindFirstChild("OwnerText")
check(signText ~= nil and signText.Text == "TEST OTURUMU BEKLİYOR", "stall sign waits for a test session (no players)",
    signText and signText.Text or "sign missing")

note(string.format("instances: scene=%d workspace=%d", #scene:GetDescendants(), #Workspace:GetDescendants()))
realPrint("SMOKE RESULT: " .. (report.pass and "PASS" or "FAIL"))
return report
