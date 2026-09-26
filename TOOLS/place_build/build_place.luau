--!nocheck
-- Builds a K0 Roblox place file WITHOUT Roblox Studio.
--
-- Runs the real scene builder sources against Lune's open-source Roblox DOM
-- (rbx-dom). Every property name and value type is checked against Roblox's
-- reflection database, so a typo or a wrong type fails here instead of in Studio.
-- Then installs the three runtime sources and serializes a binary .rbxl.
--
-- Driven by TOOLS/build_place.py, which prepares the inputs (including any test
-- profile patch) and verifies the result. Direct use:
--   lune run TOOLS/place_build/build_place.luau <inputs.json> <out.rbxl> <manifest.json>
--
-- Limits: no engine runs here. Scripts do not execute, physics and rendering do
-- not exist, and WaitForChild is a non-yielding lookup (builders only wait for
-- objects that already exist; a missing one fails loudly instead of yielding).

local fs = require("@lune/fs")
local luau = require("@lune/luau")
local process = require("@lune/process")
local roblox = require("@lune/roblox")
local serde = require("@lune/serde")

local inputsPath, outPath, manifestPath = process.args[1], process.args[2], process.args[3]
assert(inputsPath and outPath and manifestPath, "usage: build_place.luau <inputs.json> <out.rbxl> <manifest.json>")
local inputs = serde.decode("json", fs.readFile(inputsPath))

local Instance = roblox.Instance
local failures = {}
local log = {}

local function record(kind, text)
    table.insert(log, {kind = kind, text = text})
end

-- WaitForChild does not exist in Lune. Builders only wait for objects that an
-- earlier builder created, so a direct lookup is equivalent; a miss is an error.
roblox.implementMethod("Instance", "WaitForChild", function(self, name, _timeout)
    local child = self:FindFirstChild(name)
    if not child then
        error(string.format("WaitForChild: %s has no child %q (Studio would yield here)", self:GetFullName(), tostring(name)), 2)
    end
    return child
end)

-- DataModel skeleton: the services a Studio "Baseplate" place starts with that
-- the K0 sources touch.
local game = Instance.new("DataModel")
local Workspace = game:GetService("Workspace")
for _, service in ipairs({"Lighting", "ReplicatedStorage", "ServerScriptService", "StarterGui", "StarterPack", "Players", "SoundService"}) do
    game:GetService(service)
end
local StarterPlayer = game:GetService("StarterPlayer")
for _, name in ipairs({"StarterPlayerScripts", "StarterCharacterScripts"}) do
    if not StarterPlayer:FindFirstChild(name) then
        local folder = Instance.new(name)
        folder.Name = name
        folder.Parent = StarterPlayer
    end
end

-- SCENE_BUILD expects Studio's Baseplate template: it renames and moves the
-- template SpawnLocation and restyles the Baseplate. This is an equivalent of
-- that template, not a byte copy of it.
if inputs.baseplate then
    local baseplate = Instance.new("Part")
    baseplate.Name = "Baseplate"
    baseplate.Size = roblox.Vector3.new(2048, 16, 2048)
    baseplate.CFrame = roblox.CFrame.new(0, -8, 0)
    baseplate.Anchored = true
    baseplate.Locked = true
    baseplate.Parent = Workspace

    local spawnLocation = Instance.new("SpawnLocation")
    spawnLocation.Name = "SpawnLocation"
    spawnLocation.Size = roblox.Vector3.new(12, 1, 12)
    spawnLocation.CFrame = roblox.CFrame.new(0, 0.5, 0)
    spawnLocation.Anchored = true
    spawnLocation.Parent = Workspace
end

local function makeEnv(chunkName)
    local function out(kind)
        return function(...)
            local parts = table.pack(...)
            for i = 1, parts.n do parts[i] = tostring(parts[i]) end
            local text = table.concat(parts, " ", 1, parts.n)
            record(kind, chunkName .. ": " .. text)
            print(string.format("  [%s] %s", chunkName, text))
        end
    end
    return {
        game = game,
        workspace = Workspace,
        script = nil,
        print = out("print"),
        warn = out("warn"),
        Instance = Instance,
        Vector3 = roblox.Vector3,
        Vector2 = roblox.Vector2,
        CFrame = roblox.CFrame,
        Color3 = roblox.Color3,
        ColorSequence = roblox.ColorSequence,
        ColorSequenceKeypoint = roblox.ColorSequenceKeypoint,
        NumberSequence = roblox.NumberSequence,
        NumberSequenceKeypoint = roblox.NumberSequenceKeypoint,
        NumberRange = roblox.NumberRange,
        UDim = roblox.UDim,
        UDim2 = roblox.UDim2,
        BrickColor = roblox.BrickColor,
        Font = roblox.Font,
        Rect = roblox.Rect,
        Enum = roblox.Enum,
    }
end

for _, builder in ipairs(inputs.builders) do
    print("builder " .. builder.name)
    local ok, err = pcall(function()
        local chunk = luau.load(builder.source, {debugName = builder.name, environment = makeEnv(builder.name)})
        chunk()
    end)
    if not ok then
        local text = tostring(err):gsub("^<LuaError%(%s*", ""):gsub("%)>%s*$", "")
        local first = string.match(text, "[^\n]*[%w][^\n]*") or text
        local message = string.format("%s failed: %s", builder.name, first)
        table.insert(failures, message)
        record("error", message)
        print("  FAIL " .. message)
    end
end

-- Text objects: the builders set the legacy `Font` enum, which Roblox accepts and
-- mirrors into `FontFace`. rbx-dom stores the enum but cannot serialize it (it
-- expects a Font value under FontFace), so do the engine's mirroring here.
local fontFaces = 0
for _, inst in ipairs(game:GetDescendants()) do
    if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
        local ok, legacy = pcall(function() return inst.Font end)
        if ok and typeof(legacy) == "EnumItem" then
            local converted, err = pcall(function() inst.FontFace = roblox.Font.fromEnum(legacy) end)
            if converted then
                fontFaces += 1
            else
                table.insert(failures, string.format("FontFace for %s (%s): %s", inst:GetFullName(), legacy.Name, tostring(err)))
            end
        end
    end
end
record("info", string.format("legacy Font mirrored into FontFace on %d text objects", fontFaces))

-- Runtime scripts at their Studio paths.
local function resolve(path)
    local node = game
    for segment in string.gmatch(path, "[^/]+") do
        local nextNode
        if node == game then
            nextNode = game:GetService(segment)
        else
            nextNode = node:FindFirstChild(segment)
        end
        assert(nextNode, "path not found: " .. path)
        node = nextNode
    end
    return node
end

for _, spec in ipairs(inputs.scripts) do
    local s = Instance.new(spec.className)
    s.Name = spec.name
    s.Source = spec.source
    s.Parent = resolve(spec.parent)
    if s.Source ~= spec.source then
        table.insert(failures, "source did not round-trip for " .. spec.name)
    end
end

-- Pure-data modules (the config) are evaluated so the caller can confirm that a
-- test profile patch produced exactly the intended values.
local evaluated = {}
for _, spec in ipairs(inputs.scripts) do
    if spec.evaluate then
        local ok, value = pcall(function()
            return luau.load(spec.source, {debugName = spec.name})()
        end)
        if ok then
            evaluated[spec.name] = value
        else
            table.insert(failures, string.format("evaluating %s failed: %s", spec.name, tostring(value)))
        end
    end
end

for key, value in pairs(inputs.workspaceAttributes or {}) do
    Workspace:SetAttribute(key, value)
end

-- Manifest: every instance path and class so build_place.py can compare this
-- tree with the one the Luau harness builds from the same sources.
local function describe(root)
    local rows = {}
    for _, inst in ipairs(root:GetDescendants()) do
        table.insert(rows, inst:GetFullName() .. "\t" .. inst.ClassName)
    end
    table.sort(rows)
    return rows
end

local services = {}
for _, name in ipairs({"Workspace", "Lighting", "ReplicatedStorage", "ServerScriptService", "StarterPlayer"}) do
    services[name] = describe(game:GetService(name))
end

local lighting = game:GetService("Lighting")
local manifest = {
    profile = inputs.profile,
    version = inputs.version,
    failures = failures,
    log = log,
    instances = services,
    lighting = {ClockTime = lighting.ClockTime, Brightness = lighting.Brightness},
    evaluated = evaluated,
    scripts = {},
}

-- Serialize, then read the file back and confirm the tree survived.
local serialized, bytes = pcall(roblox.serializePlace, game)
if not serialized then
    table.insert(failures, "serialize failed: " .. (string.match(tostring(bytes), "[^\n]*[%w][^\n]*") or tostring(bytes)))
    manifest.failures = failures
    fs.writeFile(manifestPath, serde.encode("json", manifest, true))
    print("  FAIL " .. failures[#failures])
    process.exit(1)
end
fs.writeFile(outPath, bytes)
local reread = roblox.deserializePlace(fs.readFile(outPath))
manifest.bytes = #bytes
manifest.roundTripDescendants = #reread:GetDescendants()
manifest.originalDescendants = #game:GetDescendants()
manifest.workspaceAttributes = reread:GetService("Workspace"):GetAttributes()
for _, spec in ipairs(inputs.scripts) do
    local node = reread:GetService(string.match(spec.parent, "^[^/]+"))
    local rest = string.match(spec.parent, "^[^/]+/(.+)$")
    if rest then
        for segment in string.gmatch(rest, "[^/]+") do node = node and node:FindFirstChild(segment) end
    end
    local s = node and node:FindFirstChild(spec.name)
    table.insert(manifest.scripts, {
        path = spec.parent .. "/" .. spec.name,
        className = s and s.ClassName or "MISSING",
        sourceMatches = s ~= nil and s.Source == spec.source,
        bytes = s and #s.Source or 0,
    })
end

fs.writeFile(manifestPath, serde.encode("json", manifest, true))
print(string.format("place written: %s (%d bytes, %d instances, %d failures)", outPath, #bytes, manifest.originalDescendants, #failures))
if #failures > 0 then
    process.exit(1)
end
