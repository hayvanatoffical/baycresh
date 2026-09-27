--!nocheck
-- BAYCREST K0 headless harness — mock Roblox engine.
--
-- Runs the REAL K0 Luau sources (scene builders, K0Market server, K0MarketHUD
-- client) on a deterministic virtual clock. It is a stand-in for the parts of
-- the Roblox engine those sources touch, not a Roblox emulator:
--   * no physics, rendering, networking latency or real replication;
--   * server and client share one DataModel (instant, perfect replication);
--   * Random is a deterministic stand-in, NOT bit-identical to Roblox's PCG;
--   * member/type validation covers only the API surface listed below.
-- Unknown members and wrong property types raise errors like Roblox does, so a
-- typo or a missing scene object fails loudly instead of passing silently.

local Engine = {}
Engine.__index = Engine

local FRAME = 1 / 60
local TWEEN_STEP = 0.1

--------------------------------------------------------------------- helpers
local function copyArgs(...)
    return table.pack(...)
end

local function fmtNum(n)
    if n == math.floor(n) then return tostring(math.floor(n)) end
    return string.format("%.4g", n)
end

------------------------------------------------------------------ datatypes
local function makeType(name)
    local mt = {__type = name}
    return mt
end

local V3 = makeType("Vector3")
local function v3(x, y, z)
    return setmetatable({X = x or 0, Y = y or 0, Z = z or 0}, V3)
end
local V3methods = {}
function V3methods.Dot(a, b) return a.X * b.X + a.Y * b.Y + a.Z * b.Z end
function V3methods.Cross(a, b)
    return v3(a.Y * b.Z - a.Z * b.Y, a.Z * b.X - a.X * b.Z, a.X * b.Y - a.Y * b.X)
end
function V3methods.Lerp(a, b, t) return v3(a.X + (b.X - a.X) * t, a.Y + (b.Y - a.Y) * t, a.Z + (b.Z - a.Z) * t) end
function V3methods.FuzzyEq(a, b, eps)
    eps = eps or 1e-5
    return math.abs(a.X - b.X) <= eps and math.abs(a.Y - b.Y) <= eps and math.abs(a.Z - b.Z) <= eps
end
V3.__index = function(v, k)
    if k == "Magnitude" then return math.sqrt(v.X * v.X + v.Y * v.Y + v.Z * v.Z) end
    if k == "Unit" then
        local m = math.sqrt(v.X * v.X + v.Y * v.Y + v.Z * v.Z)
        return m == 0 and v3(0 / 0, 0 / 0, 0 / 0) or v3(v.X / m, v.Y / m, v.Z / m)
    end
    if k == "x" then return v.X elseif k == "y" then return v.Y elseif k == "z" then return v.Z end
    if V3methods[k] then return V3methods[k] end
    error(tostring(k) .. " is not a valid member of Vector3", 2)
end
local function isType(v, name)
    local mt = type(v) == "table" and getmetatable(v)
    return mt ~= nil and mt ~= false and rawget(mt, "__type") == name
end
V3.__add = function(a, b)
    assert(isType(a, "Vector3") and isType(b, "Vector3"), "invalid Vector3 addition")
    return v3(a.X + b.X, a.Y + b.Y, a.Z + b.Z)
end
V3.__sub = function(a, b)
    assert(isType(a, "Vector3") and isType(b, "Vector3"), "invalid Vector3 subtraction")
    return v3(a.X - b.X, a.Y - b.Y, a.Z - b.Z)
end
V3.__mul = function(a, b)
    if type(a) == "number" then return v3(a * b.X, a * b.Y, a * b.Z) end
    if type(b) == "number" then return v3(a.X * b, a.Y * b, a.Z * b) end
    return v3(a.X * b.X, a.Y * b.Y, a.Z * b.Z)
end
V3.__div = function(a, b)
    if type(b) == "number" then return v3(a.X / b, a.Y / b, a.Z / b) end
    return v3(a.X / b.X, a.Y / b.Y, a.Z / b.Z)
end
V3.__unm = function(a) return v3(-a.X, -a.Y, -a.Z) end
V3.__eq = function(a, b) return a.X == b.X and a.Y == b.Y and a.Z == b.Z end
V3.__tostring = function(v) return fmtNum(v.X) .. ", " .. fmtNum(v.Y) .. ", " .. fmtNum(v.Z) end
V3.__newindex = function() error("Vector3 is immutable", 2) end
local Vector3 = {
    new = function(x, y, z) return v3(x, y, z) end,
    zero = v3(0, 0, 0),
    one = v3(1, 1, 1),
    xAxis = v3(1, 0, 0),
    yAxis = v3(0, 1, 0),
    zAxis = v3(0, 0, 1),
}

local V2 = makeType("Vector2")
local function v2(x, y) return setmetatable({X = x or 0, Y = y or 0}, V2) end
V2.__index = function(v, k)
    if k == "Magnitude" then return math.sqrt(v.X * v.X + v.Y * v.Y) end
    if k == "x" then return v.X elseif k == "y" then return v.Y end
    error(tostring(k) .. " is not a valid member of Vector2", 2)
end
V2.__add = function(a, b) return v2(a.X + b.X, a.Y + b.Y) end
V2.__sub = function(a, b) return v2(a.X - b.X, a.Y - b.Y) end
V2.__mul = function(a, b)
    if type(a) == "number" then return v2(a * b.X, a * b.Y) end
    if type(b) == "number" then return v2(a.X * b, a.Y * b) end
    return v2(a.X * b.X, a.Y * b.Y)
end
V2.__eq = function(a, b) return a.X == b.X and a.Y == b.Y end
V2.__tostring = function(v) return fmtNum(v.X) .. ", " .. fmtNum(v.Y) end
local Vector2 = {new = function(x, y) return v2(x, y) end, zero = v2(0, 0), one = v2(1, 1)}

-- CFrame: position + row-major 3x3 rotation.
local CF = makeType("CFrame")
local function cf(px, py, pz, r)
    r = r or {1, 0, 0, 0, 1, 0, 0, 0, 1}
    return setmetatable({_p = v3(px, py, pz), _r = r}, CF)
end
local function matMul(a, b)
    local r = {}
    for i = 0, 2 do
        for j = 0, 2 do
            local s = 0
            for k = 0, 2 do s += a[i * 3 + k + 1] * b[k * 3 + j + 1] end
            r[i * 3 + j + 1] = s
        end
    end
    return r
end
local function matVec(m, v)
    return v3(m[1] * v.X + m[2] * v.Y + m[3] * v.Z, m[4] * v.X + m[5] * v.Y + m[6] * v.Z, m[7] * v.X + m[8] * v.Y + m[9] * v.Z)
end
local function transpose(m) return {m[1], m[4], m[7], m[2], m[5], m[8], m[3], m[6], m[9]} end
local CFmethods = {}
function CFmethods.Inverse(c)
    local rt = transpose(c._r)
    local p = matVec(rt, c._p)
    return cf(-p.X, -p.Y, -p.Z, rt)
end
function CFmethods.ToObjectSpace(a, b) return CFmethods.Inverse(a) * b end
function CFmethods.ToWorldSpace(a, b) return a * b end
function CFmethods.PointToWorldSpace(a, v) return a * v end
function CFmethods.PointToObjectSpace(a, v) return CFmethods.Inverse(a) * v end
-- Rotation part of Lerp turns about one axis at a steady rate (as Roblox's
-- spherical interpolation does), so an in-between CFrame is still a rotation.
-- Until K0.4.4 the nine matrix entries were lerped one by one, which shrank the
-- axes half-way through a turn.
local function axisAngle(R)
    local angle = math.acos(math.clamp((R[1] + R[5] + R[9] - 1) / 2, -1, 1))
    if angle < 1e-9 then return v3(0, 1, 0), 0 end
    local x, y, z = R[8] - R[6], R[3] - R[7], R[4] - R[2]
    local len = math.sqrt(x * x + y * y + z * z)
    if len > 1e-6 then return v3(x / len, y / len, z / len), angle end
    -- Half turn: the axis comes from the symmetric part, R = 2kk^T - I.
    local kx = math.sqrt(math.max(0, (R[1] + 1) / 2))
    local ky = math.sqrt(math.max(0, (R[5] + 1) / 2))
    local kz = math.sqrt(math.max(0, (R[9] + 1) / 2))
    if kx >= ky and kx >= kz then
        ky, kz = (R[2] + R[4]) / (4 * kx), (R[3] + R[7]) / (4 * kx)
    elseif ky >= kz then
        kx, kz = (R[2] + R[4]) / (4 * ky), (R[6] + R[8]) / (4 * ky)
    else
        kx, ky = (R[3] + R[7]) / (4 * kz), (R[6] + R[8]) / (4 * kz)
    end
    return v3(kx, ky, kz).Unit, angle
end
local function axisRotation(k, a)
    local c, s = math.cos(a), math.sin(a)
    local t = 1 - c
    local x, y, z = k.X, k.Y, k.Z
    return {t * x * x + c, t * x * y - s * z, t * x * z + s * y,
        t * x * y + s * z, t * y * y + c, t * y * z - s * x,
        t * x * z - s * y, t * y * z + s * x, t * z * z + c}
end
function CFmethods.Lerp(a, b, t)
    local axis, angle = axisAngle(matMul(transpose(a._r), b._r))
    local r = angle == 0 and table.clone(a._r) or matMul(a._r, axisRotation(axis, angle * t))
    local p = a._p:Lerp(b._p, t)
    return cf(p.X, p.Y, p.Z, r)
end
function CFmethods.GetComponents(c)
    local r = c._r
    return c._p.X, c._p.Y, c._p.Z, r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9]
end
CF.__index = function(c, k)
    if k == "Position" or k == "p" then return c._p end
    if k == "X" then return c._p.X elseif k == "Y" then return c._p.Y elseif k == "Z" then return c._p.Z end
    if k == "LookVector" then return v3(-c._r[3], -c._r[6], -c._r[9]) end
    if k == "RightVector" then return v3(c._r[1], c._r[4], c._r[7]) end
    if k == "UpVector" then return v3(c._r[2], c._r[5], c._r[8]) end
    if k == "Rotation" then return cf(0, 0, 0, c._r) end
    if CFmethods[k] then return CFmethods[k] end
    error(tostring(k) .. " is not a valid member of CFrame", 2)
end
CF.__mul = function(a, b)
    if isType(b, "Vector3") then return matVec(a._r, b) + a._p end
    assert(isType(b, "CFrame"), "invalid CFrame multiplication")
    local p = matVec(a._r, b._p) + a._p
    return cf(p.X, p.Y, p.Z, matMul(a._r, b._r))
end
CF.__add = function(a, b)
    assert(isType(b, "Vector3"), "CFrame + Vector3 expected")
    return cf(a._p.X + b.X, a._p.Y + b.Y, a._p.Z + b.Z, a._r)
end
CF.__sub = function(a, b)
    assert(isType(b, "Vector3"), "CFrame - Vector3 expected")
    return cf(a._p.X - b.X, a._p.Y - b.Y, a._p.Z - b.Z, a._r)
end
CF.__eq = function(a, b)
    if a._p ~= b._p then return false end
    for i = 1, 9 do if a._r[i] ~= b._r[i] then return false end end
    return true
end
CF.__tostring = function(c) return tostring(c._p) end
local function rotX(a) local c, s = math.cos(a), math.sin(a) return {1, 0, 0, 0, c, -s, 0, s, c} end
local function rotY(a) local c, s = math.cos(a), math.sin(a) return {c, 0, s, 0, 1, 0, -s, 0, c} end
local function rotZ(a) local c, s = math.cos(a), math.sin(a) return {c, -s, 0, s, c, 0, 0, 0, 1} end
local CFrame = {}
-- CFrame.lookAt(at, lookAt): position at, LookVector towards lookAt, world up
-- (the optional up argument is not modelled; the K0 sources do not pass it).
function CFrame.lookAt(at, target, up)
    assert(up == nil, "CFrame.lookAt up vector not modelled (harness)")
    return CFrame.new(at, target)
end
function CFrame.new(a, b, c, ...)
    if a == nil then return cf(0, 0, 0) end
    if isType(a, "Vector3") then
        if isType(b, "Vector3") then
            local fwd = (b - a).Unit
            local right = fwd:Cross(v3(0, 1, 0)).Unit
            local up = right:Cross(fwd)
            return cf(a.X, a.Y, a.Z, {right.X, up.X, -fwd.X, right.Y, up.Y, -fwd.Y, right.Z, up.Z, -fwd.Z})
        end
        return cf(a.X, a.Y, a.Z)
    end
    local extra = {...}
    if #extra == 9 then return cf(a, b, c, extra) end
    assert(type(a) == "number" and type(b) == "number" and type(c) == "number", "CFrame.new expects numbers")
    return cf(a, b, c)
end
function CFrame.Angles(rx, ry, rz) return cf(0, 0, 0, matMul(matMul(rotX(rx), rotY(ry)), rotZ(rz))) end
CFrame.fromEulerAnglesXYZ = CFrame.Angles
CFrame.identity = cf(0, 0, 0)

local C3 = makeType("Color3")
local function c3(r, g, b) return setmetatable({R = r or 0, G = g or 0, B = b or 0}, C3) end
C3.__index = function(c, k)
    if k == "Lerp" then return function(a, b, t) return c3(a.R + (b.R - a.R) * t, a.G + (b.G - a.G) * t, a.B + (b.B - a.B) * t) end end
    if k == "ToHex" then return function(x) return string.format("%02x%02x%02x", x.R * 255 + 0.5, x.G * 255 + 0.5, x.B * 255 + 0.5) end end
    error(tostring(k) .. " is not a valid member of Color3", 2)
end
C3.__eq = function(a, b) return a.R == b.R and a.G == b.G and a.B == b.B end
C3.__tostring = function(c) return fmtNum(c.R) .. ", " .. fmtNum(c.G) .. ", " .. fmtNum(c.B) end
local Color3 = {
    new = function(r, g, b) return c3(r, g, b) end,
    fromRGB = function(r, g, b) return c3((r or 0) / 255, (g or 0) / 255, (b or 0) / 255) end,
}

local UD = makeType("UDim")
local function udim(s, o) return setmetatable({Scale = s or 0, Offset = o or 0}, UD) end
UD.__index = function(_, k) error(tostring(k) .. " is not a valid member of UDim", 2) end
UD.__eq = function(a, b) return a.Scale == b.Scale and a.Offset == b.Offset end
UD.__add = function(a, b) return udim(a.Scale + b.Scale, a.Offset + b.Offset) end
local UDim = {new = function(s, o) return udim(s, o) end}

local UD2 = makeType("UDim2")
local function udim2(xs, xo, ys, yo) return setmetatable({X = udim(xs, xo), Y = udim(ys, yo)}, UD2) end
UD2.__index = function(u, k)
    if k == "Width" then return u.X elseif k == "Height" then return u.Y end
    if k == "Lerp" then
        return function(a, b, t)
            return udim2(a.X.Scale + (b.X.Scale - a.X.Scale) * t, a.X.Offset + (b.X.Offset - a.X.Offset) * t,
                a.Y.Scale + (b.Y.Scale - a.Y.Scale) * t, a.Y.Offset + (b.Y.Offset - a.Y.Offset) * t)
        end
    end
    error(tostring(k) .. " is not a valid member of UDim2", 2)
end
UD2.__eq = function(a, b) return a.X == b.X and a.Y == b.Y end
UD2.__add = function(a, b) return udim2(a.X.Scale + b.X.Scale, a.X.Offset + b.X.Offset, a.Y.Scale + b.Y.Scale, a.Y.Offset + b.Y.Offset) end
UD2.__tostring = function(u) return string.format("{%s, %s}, {%s, %s}", fmtNum(u.X.Scale), fmtNum(u.X.Offset), fmtNum(u.Y.Scale), fmtNum(u.Y.Offset)) end
local UDim2 = {
    new = function(xs, xo, ys, yo) return udim2(xs, xo, ys, yo) end,
    fromScale = function(x, y) return udim2(x, 0, y, 0) end,
    fromOffset = function(x, y) return udim2(0, x, 0, y) end,
}

local TI = makeType("TweenInfo")
TI.__index = function(_, k) error(tostring(k) .. " is not a valid member of TweenInfo", 2) end
local TweenInfo = {}

-- Deterministic PRNG stand-in (mulberry32 over bit32). Same seed -> same stream
-- inside the harness; NOT the same numbers Roblox's Random produces.
local RND = makeType("Random")
local function rndNext(self)
    local a = bit32.band(self._s + 0x6D2B79F5, 0xFFFFFFFF)
    self._s = a
    local function imul(x, y)
        local xl, xh = bit32.band(x, 0xFFFF), bit32.rshift(x, 16)
        local yl, yh = bit32.band(y, 0xFFFF), bit32.rshift(y, 16)
        return bit32.band(xl * yl + bit32.lshift(bit32.band(xh * yl + xl * yh, 0xFFFF), 16), 0xFFFFFFFF)
    end
    local t = imul(bit32.bxor(a, bit32.rshift(a, 15)), bit32.bor(a, 1))
    t = bit32.bxor(t, bit32.band(t + imul(bit32.bxor(t, bit32.rshift(t, 7)), bit32.bor(t, 61)), 0xFFFFFFFF))
    return bit32.bxor(t, bit32.rshift(t, 14)) / 4294967296
end
local RNDmethods = {}
function RNDmethods.NextNumber(self, lo, hi)
    self._draws += 1
    local u = rndNext(self)
    if lo == nil then return u end
    return lo + (hi - lo) * u
end
function RNDmethods.NextInteger(self, lo, hi)
    assert(type(lo) == "number" and type(hi) == "number", "NextInteger expects two numbers")
    if lo > hi then error("invalid argument #2 to 'NextInteger' (interval is empty)", 2) end
    self._draws += 1
    local u = rndNext(self)
    return math.floor(lo) + math.floor(u * (math.floor(hi) - math.floor(lo) + 1))
end
RND.__index = function(r, k)
    if RNDmethods[k] then return RNDmethods[k] end
    error(tostring(k) .. " is not a valid member of Random", 2)
end

---------------------------------------------------------------------- Enum
local ENUM_ITEMS = {
    Material = {"Plastic", "SmoothPlastic", "Wood", "WoodPlanks", "Metal", "Fabric", "Glass", "Neon",
        "Concrete", "Brick", "Limestone", "Sand", "Ground", "Cobblestone", "Asphalt", "Slate", "Granite",
        "Marble", "Grass", "ForceField", "DiamondPlate", "CorrodedMetal", "Foil", "Ice", "Pebble"},
    PartType = {"Ball", "Block", "Cylinder", "Wedge", "CornerWedge"},
    SurfaceType = {"Smooth", "Glue", "Weld", "Studs", "Inlet", "Universal", "Hinge", "Motor", "SteppingMotor", "SmoothNoOutlines"},
    NormalId = {"Right", "Top", "Back", "Left", "Bottom", "Front"},
    SurfaceGuiSizingMode = {"FixedSize", "PixelsPerStud"},
    Font = {"Legacy", "Arial", "ArialBold", "SourceSans", "SourceSansBold", "Gotham", "GothamMedium",
        "GothamBold", "GothamBlack", "Code", "Highway", "Fantasy", "Roboto", "BuilderSans", "BuilderSansBold"},
    KeyCode = {"Unknown", "E", "F", "Q", "R", "One", "Two", "Three", "Four", "Space", "Return", "Escape", "ButtonX", "ButtonA", "ButtonB"},
    TextXAlignment = {"Left", "Right", "Center"},
    TextYAlignment = {"Top", "Center", "Bottom"},
    EasingStyle = {"Linear", "Sine", "Back", "Quad", "Quart", "Quint", "Bounce", "Elastic", "Exponential", "Circular", "Cubic"},
    EasingDirection = {"In", "Out", "InOut"},
    PlaybackState = {"Begin", "Delayed", "Playing", "Paused", "Completed", "Cancelled"},
    UserInputType = {"MouseButton1", "Touch", "Keyboard", "Gamepad1"},
    UserInputState = {"Begin", "Change", "End", "Cancel"},
    ProximityPromptExclusivity = {"OnePerButton", "OneGlobally", "AlwaysShow"},
    ZIndexBehavior = {"Global", "Sibling"},
    ApplyStrokeMode = {"Contextual", "Border"},
    TextTruncate = {"None", "AtEnd", "SplitWord"},
    AutomaticSize = {"None", "X", "Y", "XY"},
}
local EI = makeType("EnumItem")
EI.__tostring = function(e) return "Enum." .. e.EnumType .. "." .. e.Name end
EI.__index = function(_, k) error(tostring(k) .. " is not a valid member of EnumItem", 2) end
local Enum = {}
for typeName, items in pairs(ENUM_ITEMS) do
    local et = {}
    for i, itemName in ipairs(items) do
        et[itemName] = setmetatable({Name = itemName, Value = i - 1, EnumType = typeName}, EI)
    end
    setmetatable(et, {
        __index = function(_, k) error(tostring(k) .. " is not a valid EnumItem of Enum." .. typeName .. " (harness)", 2) end,
        __newindex = function() error("Enum is read-only", 2) end,
    })
    Enum[typeName] = et
end
setmetatable(Enum, {__index = function(_, k) error(tostring(k) .. " is not a valid Enum (harness)", 2) end})

local function typeofValue(v)
    local t = type(v)
    if t == "table" then
        local mt = getmetatable(v)
        if type(mt) == "table" and rawget(mt, "__type") then return rawget(mt, "__type") end
    end
    return t
end

--------------------------------------------------------------------- world
function Engine.new(options)
    options = options or {}
    local world = setmetatable({}, Engine)
    function world:_onParentChanged(inst, old, new) end
    world.signalMode = options.signalMode or "Deferred"
    world.now = 0
    world.seq = 0
    world.heap = {}
    world.deferred = {}
    world.current = nil
    world.output = {}
    world.warnings = {}
    world.errors = {}
    world.waits = {}          -- pending WaitForChild records
    world.nextId = 0
    world.echo = options.echo
    world.moduleCache = {}
    world.propWrites = 0
    world.clientContexts = {}

    ------------------------------------------------------------- scheduler
    local heap = world.heap
    local function heapPush(item)
        heap[#heap + 1] = item
        local i = #heap
        while i > 1 do
            local p = i // 2
            local a, b = heap[p], heap[i]
            if a.t < b.t or (a.t == b.t and a.seq < b.seq) then break end
            heap[p], heap[i] = b, a
            i = p
        end
    end
    local function heapPop()
        local n = #heap
        if n == 0 then return nil end
        local top = heap[1]
        heap[1] = heap[n]
        heap[n] = nil
        n -= 1
        local i = 1
        while true do
            local l, r, s = i * 2, i * 2 + 1, i
            local function less(x, y) return heap[x].t < heap[y].t or (heap[x].t == heap[y].t and heap[x].seq < heap[y].seq) end
            if l <= n and less(l, s) then s = l end
            if r <= n and less(r, s) then s = r end
            if s == i then break end
            heap[s], heap[i] = heap[i], heap[s]
            i = s
        end
        return top
    end

    local function contextLabel(ctx)
        if not ctx then return "engine" end
        if ctx.kind == "client" then return "client:" .. ctx.playerName end
        return ctx.kind
    end

    local function reportError(rec, err)
        local tb = debug.traceback(rec.co, tostring(err))
        table.insert(world.errors, {t = world.now, context = contextLabel(rec.context), message = tostring(err), traceback = tb, name = rec.name})
        if world.echo then print(string.format("[%.2f] ERROR (%s) %s", world.now, contextLabel(rec.context), tb)) end
    end

    local function resume(rec, ...)
        if coroutine.status(rec.co) ~= "suspended" then return end
        -- A departed player's client threads stop with that client.
        if rec.context and rec.context.dead then return end
        local prev = world.current
        world.current = rec
        local ok, err = coroutine.resume(rec.co, ...)
        world.current = prev
        if not ok then reportError(rec, err) end
    end
    world._resume = resume

    local function newRec(fn, context, name)
        return {co = coroutine.create(fn), context = context, name = name}
    end

    local function schedule(rec, t, args)
        world.seq += 1
        heapPush({t = t, seq = world.seq, rec = rec, args = args})
    end

    local function currentContext()
        return world.current and world.current.context or world.defaultContext
    end
    world.currentContext = currentContext

    local task = {}
    function task.spawn(f, ...)
        local rec
        if type(f) == "thread" then
            rec = {co = f, context = currentContext()}
        else
            rec = newRec(f, currentContext())
        end
        resume(rec, ...)
        return rec.co
    end
    function task.defer(f, ...)
        local rec = type(f) == "thread" and {co = f, context = currentContext()} or newRec(f, currentContext())
        table.insert(world.deferred, {rec = rec, args = copyArgs(...)})
        return rec.co
    end
    function task.delay(t, f, ...)
        local rec = type(f) == "thread" and {co = f, context = currentContext()} or newRec(f, currentContext())
        schedule(rec, world.now + math.max(t or 0, FRAME), copyArgs(...))
        return rec.co
    end
    function task.wait(t)
        local rec = world.current
        if not rec then error("task.wait called outside of a script thread (harness)", 2) end
        local start = world.now
        schedule(rec, world.now + math.max(t or 0, FRAME), nil)
        coroutine.yield()
        return world.now - start
    end
    function task.cancel(co)
        for i = #heap, 1, -1 do if heap[i].rec.co == co then heap[i].rec.cancelled = true end end
    end
    world.task = task

    -- Dispatch a handler in its own thread according to the signal behaviour.
    local function dispatch(fn, context, args)
        local rec = newRec(fn, context)
        if world.signalMode == "Immediate" then
            resume(rec, table.unpack(args, 1, args.n))
        else
            table.insert(world.deferred, {rec = rec, args = args})
        end
    end
    local function resumeWaiter(rec, args)
        if world.signalMode == "Immediate" then
            resume(rec, table.unpack(args, 1, args.n))
        else
            table.insert(world.deferred, {rec = rec, args = args})
        end
    end

    function world:drainDeferred()
        local guard = 0
        while #self.deferred > 0 do
            guard += 1
            if guard > 200000 then error("deferred queue does not settle (harness)") end
            local item = table.remove(self.deferred, 1)
            resume(item.rec, table.unpack(item.args, 1, item.args.n))
        end
    end

    function world:advance(dt)
        local target = self.now + dt
        self:drainDeferred()
        while true do
            local top = heap[1]
            if not top or top.t > target then break end
            heapPop()
            self.now = top.t
            if not top.rec.cancelled then
                if top.args then resume(top.rec, table.unpack(top.args, 1, top.args.n)) else resume(top.rec) end
            end
            self:drainDeferred()
        end
        self.now = target
        self:drainDeferred()
    end

    function world:runUntil(predicate, timeout, step)
        step = step or 0.25
        local deadline = self.now + (timeout or 60)
        while self.now < deadline do
            if predicate() then return true end
            self:advance(step)
        end
        return predicate()
    end

    ---------------------------------------------------------------- signals
    local SignalMT = {__type = "RBXScriptSignal"}
    SignalMT.__index = SignalMT
    local ConnMT = {__type = "RBXScriptConnection"}
    ConnMT.__index = ConnMT
    function ConnMT:Disconnect()
        self.Connected = false
        local list = self._signal._handlers
        for i = #list, 1, -1 do if list[i] == self then table.remove(list, i) end end
    end
    local function newSignal(name)
        return setmetatable({_name = name, _handlers = {}, _waiting = {}}, SignalMT)
    end
    function SignalMT:Connect(fn)
        assert(type(fn) == "function", "Attempt to connect failed: Passed value is not a function")
        local c = setmetatable({Connected = true, _fn = fn, _signal = self, _context = currentContext()}, ConnMT)
        table.insert(self._handlers, c)
        return c
    end
    function SignalMT:Once(fn)
        local c
        c = self:Connect(function(...)
            c:Disconnect()
            fn(...)
        end)
        return c
    end
    function SignalMT:Wait()
        local rec = world.current
        if not rec then error("Signal:Wait outside of a thread (harness)", 2) end
        table.insert(self._waiting, rec)
        return coroutine.yield()
    end
    function SignalMT:_fire(...)
        local args = copyArgs(...)
        local handlers = table.clone(self._handlers)
        for _, c in ipairs(handlers) do
            if c.Connected then dispatch(c._fn, c._context, args) end
        end
        local waiting = self._waiting
        self._waiting = {}
        for _, rec in ipairs(waiting) do resumeWaiter(rec, args) end
    end
    -- Fire only the connections made from contexts accepted by pred; used for
    -- per-client input on services that every client shares in the harness.
    function SignalMT:_fireFiltered(pred, ...)
        local args = copyArgs(...)
        for _, c in ipairs(table.clone(self._handlers)) do
            if c.Connected and pred(c._context) then dispatch(c._fn, c._context, args) end
        end
    end
    function SignalMT:_disconnectAll()
        for _, c in ipairs(self._handlers) do c.Connected = false end
        self._handlers = {}
    end
    world.newSignal = newSignal

    -------------------------------------------------------------- instances
    local internals = setmetatable({}, {__mode = "k"})
    world.internals = internals
    local InstanceMT = {__type = "Instance"}
    local classes = {}
    world.classes = classes

    local function isInstance(v) return type(v) == "table" and getmetatable(v) == InstanceMT end
    world.isInstance = isInstance

    local function defClass(name, super, spec)
        local c = {name = name, super = super and classes[super], props = spec.props or {},
            methods = spec.methods or {}, events = spec.events or {}, creatable = spec.creatable ~= false,
            init = spec.init}
        classes[name] = c
        return c
    end

    local function findProp(class, key)
        local c = class
        while c do
            local p = c.props[key]
            if p then return p end
            c = c.super
        end
        return nil
    end
    local function findMethod(class, key)
        local c = class
        while c do
            local m = c.methods[key]
            if m then return m end
            c = c.super
        end
        return nil
    end
    local function hasEvent(class, key)
        local c = class
        while c do
            if c.events[key] then return true end
            c = c.super
        end
        return false
    end
    local function isA(class, name)
        local c = class
        while c do
            if c.name == name then return true end
            c = c.super
        end
        return false
    end

    local function getSignal(d, key)
        local s = d.signals[key]
        if not s then
            s = newSignal(key)
            d.signals[key] = s
        end
        return s
    end

    local function fullName(inst)
        local parts = {}
        local cur = inst
        while cur do
            local d = internals[cur]
            if d.class.name == "DataModel" then break end
            table.insert(parts, 1, d.props.Name)
            cur = d.parent
        end
        return table.concat(parts, ".")
    end
    world.fullName = fullName

    -- Property types. "?" suffix allows nil.
    local function coerce(expected, value, key, inst)
        local nullable = string.sub(expected, -1) == "?"
        local base = nullable and string.sub(expected, 1, -2) or expected
        if value == nil then
            if nullable then return nil end
            error(string.format("Unable to assign property %s. %s expected, got nil", key, base), 3)
        end
        if base == "string" then
            if type(value) == "number" then return tostring(value) end
            if type(value) ~= "string" then error(string.format("Unable to assign property %s. string expected, got %s", key, typeofValue(value)), 3) end
            return value
        elseif base == "number" then
            if type(value) ~= "number" then error(string.format("Unable to assign property %s. number expected, got %s", key, typeofValue(value)), 3) end
            if value ~= value then error(string.format("Unable to assign property %s. value is NaN (harness)", key), 3) end
            return value
        elseif base == "int" then
            if type(value) ~= "number" then error(string.format("Unable to assign property %s. int64 expected, got %s", key, typeofValue(value)), 3) end
            return value >= 0 and math.floor(value + 0.5) or -math.floor(-value + 0.5)
        elseif base == "boolean" then
            if type(value) ~= "boolean" then error(string.format("Unable to assign property %s. bool expected, got %s", key, typeofValue(value)), 3) end
            return value
        elseif string.sub(base, 1, 5) == "Enum:" then
            local et = string.sub(base, 6)
            if typeofValue(value) == "EnumItem" then
                if value.EnumType ~= et then error(string.format("Unable to assign property %s. Enum.%s expected, got Enum.%s", key, et, value.EnumType), 3) end
                return value
            end
            if type(value) == "string" then return Enum[et][value] end
            error(string.format("Unable to assign property %s. EnumItem expected, got %s", key, typeofValue(value)), 3)
        elseif string.sub(base, 1, 9) == "Instance:" then
            local cls = string.sub(base, 10)
            if not isInstance(value) then error(string.format("Unable to assign property %s. Object expected, got %s", key, typeofValue(value)), 3) end
            if cls ~= "" and not isA(internals[value].class, cls) then error(string.format("Unable to assign property %s. %s expected", key, cls), 3) end
            return value
        else
            if typeofValue(value) ~= base then
                error(string.format("Unable to assign property %s. %s expected, got %s", key, base, typeofValue(value)), 3)
            end
            return value
        end
    end

    -- propWrites counts script-initiated property sets; parts that move because
    -- they are welded to a moved part are counted in assemblyMoves instead.
    local function fireChanged(inst, d, key, value, derived)
        if not derived then world.propWrites += 1 end
        if isA(d.class, "ValueBase") then
            if key == "Value" and d.signals.Changed then d.signals.Changed:_fire(value) end
        elseif d.signals.Changed then
            d.signals.Changed:_fire(key)
        end
        local ps = d.propSignals[key]
        if ps then ps:_fire() end
    end

    local function setPropRaw(inst, key, value)
        local d = internals[inst]
        local old = d.props[key]
        if old == value then return end
        d.props[key] = value
        fireChanged(inst, d, key, value)
    end
    world.setPropRaw = setPropRaw

    local function eachDescendant(inst, fn)
        for _, child in ipairs(internals[inst].children) do
            fn(child)
            eachDescendant(child, fn)
        end
    end

    local function setParent(inst, newParent)
        local d = internals[inst]
        if d.parentLocked then
            error(string.format("The Parent property of %s is locked, current parent: NULL, new parent %s", d.props.Name, newParent and internals[newParent].props.Name or "NULL"), 3)
        end
        if newParent ~= nil and not isInstance(newParent) then
            error("Unable to assign property Parent. Object expected, got " .. typeofValue(newParent), 3)
        end
        if d.parent == newParent then return end
        local cur = newParent
        while cur do
            if cur == inst then error("Attempt to set " .. fullName(inst) .. " as its own parent", 3) end
            cur = internals[cur].parent
        end
        local old = d.parent
        if old then
            local od = internals[old]
            for i, c in ipairs(od.children) do if c == inst then table.remove(od.children, i) break end end
            if od.signals.ChildRemoved then od.signals.ChildRemoved:_fire(inst) end
            local anc = old
            while anc do
                local ad = internals[anc]
                if ad.signals.DescendantRemoving then ad.signals.DescendantRemoving:_fire(inst) end
                anc = ad.parent
            end
        end
        d.parent = newParent
        if newParent then
            local nd = internals[newParent]
            table.insert(nd.children, inst)
            if nd.signals.ChildAdded then nd.signals.ChildAdded:_fire(inst) end
            local anc = newParent
            while anc do
                local ad = internals[anc]
                if ad.signals.DescendantAdded then ad.signals.DescendantAdded:_fire(inst) end
                anc = ad.parent
            end
            -- Wake WaitForChild waiters on the new parent.
            local waiters = nd.childWaiters[d.props.Name]
            if waiters then
                nd.childWaiters[d.props.Name] = nil
                for _, w in ipairs(waiters) do
                    if not w.done then
                        w.done = true
                        resumeWaiter(w.rec, copyArgs(inst))
                    end
                end
            end
        end
        fireChanged(inst, d, "Parent", newParent)
        if d.signals.AncestryChanged then d.signals.AncestryChanged:_fire(inst, newParent) end
        world:_onParentChanged(inst, old, newParent)
    end

    InstanceMT.__index = function(inst, key)
        local d = internals[inst]
        if key == "ClassName" then return d.class.name end
        if key == "Parent" then return d.parent end
        local p = findProp(d.class, key)
        if p then
            if p.get then return p.get(inst, d) end
            local v = d.props[key]
            if v == nil and p.default ~= nil then
                v = type(p.default) == "function" and p.default() or p.default
                d.props[key] = v
            end
            return v
        end
        local m = findMethod(d.class, key)
        if m then return m end
        if hasEvent(d.class, key) then return getSignal(d, key) end
        for _, child in ipairs(d.children) do
            if internals[child].props.Name == key then return child end
        end
        error(string.format("%s is not a valid member of %s \"%s\"", tostring(key), d.class.name, fullName(inst)), 2)
    end
    InstanceMT.__newindex = function(inst, key, value)
        local d = internals[inst]
        if key == "Parent" then return setParent(inst, value) end
        local p = findProp(d.class, key)
        if not p then
            error(string.format("%s is not a valid member of %s \"%s\"", tostring(key), d.class.name, fullName(inst)), 2)
        end
        if p.readonly then error(string.format("Unable to assign property %s. Property is read only", key), 2) end
        local v = coerce(p.type, value, key, inst)
        if p.set then p.set(inst, d, v) else setPropRaw(inst, key, v) end
    end
    InstanceMT.__tostring = function(inst) return internals[inst].props.Name end

    local function newInstance(className, parent)
        local class = classes[className]
        if not class then error("Unable to create an Instance of type \"" .. tostring(className) .. "\" (harness)", 2) end
        world.nextId += 1
        local inst = setmetatable({}, InstanceMT)
        internals[inst] = {class = class, props = {Name = className}, children = {}, parent = nil,
            attrs = {}, signals = {}, propSignals = {}, attrSignals = {}, childWaiters = {}, id = world.nextId}
        local c = class
        local inits = {}
        while c do
            if c.init then table.insert(inits, 1, c.init) end
            c = c.super
        end
        for _, f in ipairs(inits) do f(inst, internals[inst]) end
        if parent then inst.Parent = parent end
        return inst
    end
    world.newInstance = newInstance

    ------------------------------------------------------ Instance methods
    local function destroy(inst)
        local d = internals[inst]
        if d.destroyed then return end
        if d.signals.Destroying then d.signals.Destroying:_fire() end
        for _, child in ipairs(table.clone(d.children)) do destroy(child) end
        if d.parent then setParent(inst, nil) end
        d.parentLocked = true
        d.destroyed = true
        for _, s in pairs(d.signals) do s:_disconnectAll() end
        for _, s in pairs(d.propSignals) do s:_disconnectAll() end
        for _, s in pairs(d.attrSignals) do s:_disconnectAll() end
    end

    local function clone(inst)
        local d = internals[inst]
        if d.props.Archivable == false then return nil end
        local c = newInstance(d.class.name)
        local cd = internals[c]
        for k, v in pairs(d.props) do cd.props[k] = v end
        for k, v in pairs(d.attrs) do cd.attrs[k] = v end
        cd.source = d.source
        for _, child in ipairs(d.children) do
            local cc = clone(child)
            if cc then cc.Parent = c end
        end
        return c
    end

    local ATTR_TYPES = {string = true, boolean = true, number = true, UDim = true, UDim2 = true, Color3 = true,
        Vector2 = true, Vector3 = true, CFrame = true, EnumItem = true}

    local baseMethods = {
        FindFirstChild = function(self, name, recursive)
            for _, c in ipairs(internals[self].children) do
                if internals[c].props.Name == name then return c end
            end
            if recursive then
                for _, c in ipairs(internals[self].children) do
                    local r = c:FindFirstChild(name, true)
                    if r then return r end
                end
            end
            return nil
        end,
        FindFirstChildWhichIsA = function(self, className, recursive)
            for _, c in ipairs(internals[self].children) do
                if isA(internals[c].class, className) then return c end
            end
            if recursive then
                for _, c in ipairs(internals[self].children) do
                    local r = c:FindFirstChildWhichIsA(className, true)
                    if r then return r end
                end
            end
            return nil
        end,
        FindFirstChildOfClass = function(self, className)
            for _, c in ipairs(internals[self].children) do
                if internals[c].class.name == className then return c end
            end
            return nil
        end,
        FindFirstAncestor = function(self, name)
            local cur = internals[self].parent
            while cur do
                if internals[cur].props.Name == name then return cur end
                cur = internals[cur].parent
            end
            return nil
        end,
        WaitForChild = function(self, name, timeout)
            assert(type(name) == "string", "WaitForChild expects a string name")
            local found = self:FindFirstChild(name)
            if found then return found end
            local rec = world.current
            if not rec then error("WaitForChild outside of a thread (harness)", 2) end
            local d = internals[self]
            local w = {rec = rec, done = false, parent = self, name = name, since = world.now, context = rec.context}
            d.childWaiters[name] = d.childWaiters[name] or {}
            table.insert(d.childWaiters[name], w)
            table.insert(world.waits, w)
            if timeout then
                task.delay(timeout, function()
                    if not w.done then
                        w.done = true
                        resumeWaiter(rec, copyArgs(nil))
                    end
                end)
            else
                task.delay(5, function()
                    if not w.done then
                        local msg = string.format("Infinite yield possible on '%s:WaitForChild(\"%s\")'", fullName(self), name)
                        table.insert(world.warnings, {t = world.now, context = contextLabel(rec.context), message = msg})
                    end
                end)
            end
            return coroutine.yield()
        end,
        GetChildren = function(self) return table.clone(internals[self].children) end,
        GetDescendants = function(self)
            local out = {}
            eachDescendant(self, function(x) table.insert(out, x) end)
            return out
        end,
        IsA = function(self, className) return isA(internals[self].class, className) end,
        IsDescendantOf = function(self, other)
            local cur = internals[self].parent
            while cur do
                if cur == other then return true end
                cur = internals[cur].parent
            end
            return false
        end,
        IsAncestorOf = function(self, other) return other:IsDescendantOf(self) end,
        Destroy = function(self) destroy(self) end,
        Clone = function(self) return clone(self) end,
        ClearAllChildren = function(self)
            for _, c in ipairs(table.clone(internals[self].children)) do destroy(c) end
        end,
        GetFullName = function(self) return fullName(self) end,
        SetAttribute = function(self, name, value)
            if type(name) ~= "string" or not string.match(name, "^[%w_]+$") or #name > 100 or string.sub(name, 1, 3) == "RBX" then
                error("SetAttribute: invalid attribute name '" .. tostring(name) .. "'", 2)
            end
            if value ~= nil then
                local t = typeofValue(value)
                if not ATTR_TYPES[t] then error("SetAttribute: " .. t .. " is not a supported attribute type", 2) end
                if t == "number" and value ~= value then
                    -- Roblox stores NaN; flag it because a NaN in telemetry is always a bug here.
                    table.insert(world.warnings, {t = world.now, context = "harness", message = "NaN attribute " .. name})
                end
            end
            local d = internals[self]
            if d.attrs[name] == value then return end
            d.attrs[name] = value
            world.attrWrites = (world.attrWrites or 0) + 1
            local s = d.attrSignals[name]
            if s then s:_fire() end
            if d.signals.AttributeChanged then d.signals.AttributeChanged:_fire(name) end
        end,
        GetAttribute = function(self, name) return internals[self].attrs[name] end,
        GetAttributes = function(self) return table.clone(internals[self].attrs) end,
        GetAttributeChangedSignal = function(self, name)
            local d = internals[self]
            local s = d.attrSignals[name]
            if not s then
                s = newSignal("AttributeChanged:" .. name)
                d.attrSignals[name] = s
            end
            return s
        end,
        GetPropertyChangedSignal = function(self, prop)
            local d = internals[self]
            if prop ~= "Parent" and prop ~= "Name" and not findProp(d.class, prop) then
                error(string.format("%s is not a valid property name.", tostring(prop)), 2)
            end
            local s = d.propSignals[prop]
            if not s then
                s = newSignal("Changed:" .. prop)
                d.propSignals[prop] = s
            end
            return s
        end,
    }

    defClass("Instance", nil, {
        creatable = false,
        props = {Name = {type = "string"}, Archivable = {type = "boolean", default = true}},
        methods = baseMethods,
        events = {ChildAdded = true, ChildRemoved = true, DescendantAdded = true, DescendantRemoving = true,
            AncestryChanged = true, Changed = true, Destroying = true, AttributeChanged = true},
    })

    -- Geometry --------------------------------------------------------------
    local function partGetCF(inst, d) return d.props.CFrame or cf(0, 0, 0) end

    -- WeldConstraint assemblies: moving one part by CFrame moves every part
    -- welded to it, keeping the offsets captured when the weld was completed.
    -- Physics, mass and network ownership are not modelled.
    world.welds = {}
    world.motors = {}
    world.assemblyMoves = 0
    -- Joints are indexed by the parts they join, so moving a part visits only
    -- its own joints (K0.4.7: per-frame limb poses made a whole-world scan per
    -- moved part too slow).
    local partJoints = setmetatable({}, {__mode = "k"})
    local function indexJoint(joint, oldPart, newPart)
        if oldPart and partJoints[oldPart] then partJoints[oldPart][joint] = nil end
        if newPart then
            partJoints[newPart] = partJoints[newPart] or {}
            partJoints[newPart][joint] = true
        end
    end
    local function motorLink(md)
        local p = md.props
        return (p.C0 or cf(0, 0, 0)) * (p.Transform or cf(0, 0, 0)) * (p.C1 or cf(0, 0, 0)):Inverse()
    end
    local function weldPeers(inst)
        local out = {}
        local joints = partJoints[inst]
        if not joints then return out end
        for joint in pairs(joints) do
            local jd = internals[joint]
            if jd.destroyed then
                joints[joint] = nil
                world.welds[joint] = nil
                world.motors[joint] = nil
            -- Enabled defaults to true; its default is filled in only when read,
            -- so an untouched weld has no stored value (K0.4.4 fix: before it,
            -- no weld ever moved its peer and NPC parts stayed where they spawned).
            elseif jd.parent and jd.props.Enabled ~= false then
                -- K0.4.7 Motor6D rigs: Part1 = Part0 * C0 * Transform * C1:Inverse(),
                -- the rig rule the Roblox animation system uses. Joint physics is
                -- not modelled.
                local link = world.motors[joint] and motorLink(jd) or jd.offset
                if link and jd.props.Part0 == inst and jd.props.Part1 then
                    table.insert(out, {part = jd.props.Part1, offset = link})
                elseif link and jd.props.Part1 == inst and jd.props.Part0 then
                    table.insert(out, {part = jd.props.Part0, offset = link:Inverse()})
                end
            end
        end
        return out
    end
    local function partSetCF(inst, d, v, derived, visited)
        local old = d.props.CFrame
        if old == v then return end
        d.props.CFrame = v
        fireChanged(inst, d, "CFrame", v, derived)
        fireChanged(inst, d, "Position", v.Position, true)
        local joints = partJoints[inst]
        if not joints or next(joints) == nil then return end
        visited = visited or {[inst] = true}
        for _, peer in ipairs(weldPeers(inst)) do
            if not visited[peer.part] then
                visited[peer.part] = true
                world.assemblyMoves += 1
                partSetCF(peer.part, internals[peer.part], v * peer.offset, true, visited)
            end
        end
    end
    defClass("PVInstance", "Instance", {creatable = false})
    defClass("BasePart", "PVInstance", {
        creatable = false,
        init = function(inst, d)
            d.props.CFrame = cf(0, 0, 0)
            d.props.Size = v3(4, 1, 2)
        end,
        props = {
            Size = {type = "Vector3"},
            CFrame = {type = "CFrame", get = partGetCF, set = partSetCF},
            Position = {type = "Vector3",
                get = function(inst, d) return d.props.CFrame.Position end,
                set = function(inst, d, v)
                    local c = d.props.CFrame
                    partSetCF(inst, d, cf(v.X, v.Y, v.Z, c._r))
                end},
            Color = {type = "Color3", default = function() return c3(0.64, 0.64, 0.64) end},
            Material = {type = "Enum:Material", default = function() return Enum.Material.Plastic end},
            Transparency = {type = "number", default = 0},
            Reflectance = {type = "number", default = 0},
            Anchored = {type = "boolean", default = false},
            CanCollide = {type = "boolean", default = true},
            CanTouch = {type = "boolean", default = true},
            CanQuery = {type = "boolean", default = true},
            CastShadow = {type = "boolean", default = true},
            Locked = {type = "boolean", default = false},
            Massless = {type = "boolean", default = false},
            TopSurface = {type = "Enum:SurfaceType", default = function() return Enum.SurfaceType.Smooth end},
            BottomSurface = {type = "Enum:SurfaceType", default = function() return Enum.SurfaceType.Smooth end},
        },
        methods = {
            PivotTo = function(self, target)
                assert(isType(target, "CFrame"), "PivotTo expects a CFrame")
                self.CFrame = target
            end,
            GetPivot = function(self) return self.CFrame end,
        },
        events = {Touched = true, TouchEnded = true},
    })
    defClass("Part", "BasePart", {props = {Shape = {type = "Enum:PartType", default = function() return Enum.PartType.Block end}}})
    defClass("SpawnLocation", "Part", {props = {Neutral = {type = "boolean", default = true}, Enabled = {type = "boolean", default = true}, Duration = {type = "number", default = 10}}})
    defClass("Model", "PVInstance", {
        props = {
            PrimaryPart = {type = "Instance:BasePart?"},
            WorldPivot = {type = "CFrame", get = function(inst, d)
                if d.props.PrimaryPart then return d.props.PrimaryPart.CFrame end
                return d.props.WorldPivot or cf(0, 0, 0)
            end},
        },
        methods = {
            GetPivot = function(self)
                local d = internals[self]
                if d.props.PrimaryPart then return d.props.PrimaryPart.CFrame end
                if d.props.WorldPivot then return d.props.WorldPivot end
                -- Roblox falls back to the bounding box centre; the first part is
                -- a stand-in that keeps relative motion correct.
                for _, x in ipairs(self:GetDescendants()) do
                    if x:IsA("BasePart") then return x.CFrame end
                end
                return cf(0, 0, 0)
            end,
            PivotTo = function(self, target)
                assert(isType(target, "CFrame"), "PivotTo expects a CFrame")
                local pivot = self:GetPivot()
                local delta = target * pivot:Inverse()
                for _, x in ipairs(self:GetDescendants()) do
                    if x:IsA("BasePart") then x.CFrame = delta * x.CFrame end
                end
                internals[self].props.WorldPivot = target
            end,
        },
    })
    defClass("Folder", "Instance", {})
    local function captureWeld(inst, d)
        world.welds[inst] = true
        local p0, p1 = d.props.Part0, d.props.Part1
        d.offset = (p0 and p1) and (p0.CFrame:Inverse() * p1.CFrame) or nil
    end
    defClass("WeldConstraint", "Instance", {
        props = {
            Part0 = {type = "Instance:BasePart?", set = function(inst, d, v) indexJoint(inst, d.props.Part0, v); d.props.Part0 = v; captureWeld(inst, d) end},
            Part1 = {type = "Instance:BasePart?", set = function(inst, d, v) indexJoint(inst, d.props.Part1, v); d.props.Part1 = v; captureWeld(inst, d) end},
            Enabled = {type = "boolean", default = true},
        },
    })
    -- A joint change re-places Part1 (and whatever hangs off it) from Part0.
    -- Transform is counted in world.motorTransforms rather than propWrites: in
    -- Roblox it is hidden, not replicated and written by the client each frame.
    world.motorTransforms = 0
    local function applyMotor(inst, d)
        world.motors[inst] = true
        local p0, p1 = d.props.Part0, d.props.Part1
        if not (p0 and p1) or d.props.Enabled == false then return end
        local target = p0.CFrame * motorLink(d)
        local p1d = internals[p1]
        if p1d.props.CFrame ~= target then
            world.assemblyMoves += 1
            partSetCF(p1, p1d, target, true, {[p0] = true, [p1] = true})
        end
    end
    local function jointSetter(key)
        return function(inst, d, v)
            if d.props[key] == v then return end
            if key == "Part0" or key == "Part1" then indexJoint(inst, d.props[key], v) end
            d.props[key] = v
            if key == "Transform" then
                world.motorTransforms += 1
                local ctx = currentContext()
                if not ctx or ctx.kind ~= "client" then world.serverTransforms = (world.serverTransforms or 0) + 1 end
            else
                world.propWrites += 1
            end
            applyMotor(inst, d)
        end
    end
    defClass("JointInstance", "Instance", {
        creatable = false,
        props = {
            Part0 = {type = "Instance:BasePart?", set = jointSetter("Part0")},
            Part1 = {type = "Instance:BasePart?", set = jointSetter("Part1")},
            C0 = {type = "CFrame", default = function() return cf(0, 0, 0) end, set = jointSetter("C0")},
            C1 = {type = "CFrame", default = function() return cf(0, 0, 0) end, set = jointSetter("C1")},
            Enabled = {type = "boolean", default = true},
        },
    })
    defClass("Motor6D", "JointInstance", {
        props = {Transform = {type = "CFrame", default = function() return cf(0, 0, 0) end, set = jointSetter("Transform")}},
    })
    defClass("Humanoid", "Instance", {props = {WalkSpeed = {type = "number", default = 16}, Health = {type = "number", default = 100}, DisplayName = {type = "string", default = ""}}})

    -- Lights / values -------------------------------------------------------
    defClass("Light", "Instance", {creatable = false, props = {
        Brightness = {type = "number", default = 1}, Color = {type = "Color3", default = function() return c3(1, 1, 1) end},
        Enabled = {type = "boolean", default = true}, Shadows = {type = "boolean", default = false}}})
    defClass("PointLight", "Light", {props = {Range = {type = "number", default = 8}}})
    defClass("ValueBase", "Instance", {creatable = false})
    defClass("ObjectValue", "ValueBase", {props = {Value = {type = "Instance:?"}}})
    defClass("CFrameValue", "ValueBase", {props = {Value = {type = "CFrame", default = function() return cf(0, 0, 0) end}}})
    defClass("IntValue", "ValueBase", {props = {Value = {type = "int", default = 0}}})
    defClass("NumberValue", "ValueBase", {props = {Value = {type = "number", default = 0}}})
    defClass("StringValue", "ValueBase", {props = {Value = {type = "string", default = ""}}})
    defClass("BoolValue", "ValueBase", {props = {Value = {type = "boolean", default = false}}})

    -- Scripts ---------------------------------------------------------------
    defClass("LuaSourceContainer", "Instance", {creatable = false})
    defClass("BaseScript", "LuaSourceContainer", {creatable = false, props = {
        Disabled = {type = "boolean", get = function(inst, d) return d.props.Enabled == false end,
            set = function(inst, d, v) setPropRaw(inst, "Enabled", not v) end},
        Enabled = {type = "boolean", default = true}}})
    defClass("Script", "BaseScript", {})
    defClass("LocalScript", "Script", {})
    defClass("ModuleScript", "LuaSourceContainer", {})
    defClass("RemoteEvent", "Instance", {
        methods = {
            FireServer = function(self, ...)
                local ctx = currentContext()
                if not ctx or ctx.kind ~= "client" then error("FireServer can only be called from the client", 2) end
                world.remoteCalls = (world.remoteCalls or 0) + 1
                local d = internals[self]
                if d.signals.OnServerEvent then d.signals.OnServerEvent:_fire(ctx.player, ...) end
            end,
            FireClient = function(self, player, ...)
                local d = internals[self]
                if d.signals.OnClientEvent then d.signals.OnClientEvent:_fire(...) end
            end,
            FireAllClients = function(self, ...)
                local d = internals[self]
                if d.signals.OnClientEvent then d.signals.OnClientEvent:_fire(...) end
            end,
        },
        events = {OnServerEvent = true, OnClientEvent = true},
    })

    -- Prompts ---------------------------------------------------------------
    defClass("ProximityPrompt", "Instance", {props = {
        ActionText = {type = "string", default = "Interact"},
        ObjectText = {type = "string", default = ""},
        HoldDuration = {type = "number", default = 0},
        MaxActivationDistance = {type = "number", default = 10},
        RequiresLineOfSight = {type = "boolean", default = true},
        KeyboardKeyCode = {type = "Enum:KeyCode", default = function() return Enum.KeyCode.E end},
        GamepadKeyCode = {type = "Enum:KeyCode", default = function() return Enum.KeyCode.ButtonX end},
        Enabled = {type = "boolean", default = true},
        Exclusivity = {type = "Enum:ProximityPromptExclusivity", default = function() return Enum.ProximityPromptExclusivity.OnePerButton end},
        ClickablePrompt = {type = "boolean", default = true},
        UIOffset = {type = "Vector2", default = function() return v2(0, 0) end},
    }, events = {Triggered = true, TriggerEnded = true, PromptShown = true, PromptHidden = true,
        PromptButtonHoldBegan = true, PromptButtonHoldEnded = true}})

    -- GUI -------------------------------------------------------------------
    defClass("LayerCollector", "Instance", {creatable = false, props = {
        Enabled = {type = "boolean", default = true}, ResetOnSpawn = {type = "boolean", default = true},
        ZIndexBehavior = {type = "Enum:ZIndexBehavior", default = function() return Enum.ZIndexBehavior.Sibling end}}})
    -- AbsoluteSize is the area a ScreenGui lays out in: the viewport minus the
    -- Roblox top bar unless IgnoreGuiInset is set. world.guiInset is 58 px, the
    -- top bar height Roblox reports since the 2024 top bar (an assumption to
    -- check on the device, not a measurement).
    local function screenGuiSize(inst)
        local vp = world.camera and internals[world.camera].props.ViewportSize or v2(1280, 720)
        local inset = internals[inst].props.IgnoreGuiInset and 0 or (world.guiInset or 0)
        return v2(vp.X, math.max(0, vp.Y - inset))
    end
    world.screenGuis = setmetatable({}, {__mode = "k"})
    defClass("ScreenGui", "LayerCollector", {props = {
        IgnoreGuiInset = {type = "boolean", default = false}, DisplayOrder = {type = "number", default = 0},
        AbsoluteSize = {type = "Vector2", readonly = true, get = function(inst) return screenGuiSize(inst) end}},
        init = function(inst, d) world.screenGuis[inst] = true end})
    defClass("BillboardGui", "LayerCollector", {props = {
        Adornee = {type = "Instance:?"}, Size = {type = "UDim2", default = function() return udim2(0, 0, 0, 0) end},
        StudsOffset = {type = "Vector3", default = function() return v3() end},
        StudsOffsetWorldSpace = {type = "Vector3", default = function() return v3() end},
        MaxDistance = {type = "number", default = math.huge}, AlwaysOnTop = {type = "boolean", default = false},
        LightInfluence = {type = "number", default = 1}, ClipsDescendants = {type = "boolean", default = false},
        SizeOffset = {type = "Vector2", default = function() return v2() end}}})
    defClass("SurfaceGui", "LayerCollector", {props = {
        Face = {type = "Enum:NormalId", default = function() return Enum.NormalId.Front end},
        SizingMode = {type = "Enum:SurfaceGuiSizingMode", default = function() return Enum.SurfaceGuiSizingMode.FixedSize end},
        PixelsPerStud = {type = "number", default = 50}, CanvasSize = {type = "Vector2", default = function() return v2(800, 600) end},
        LightInfluence = {type = "number", default = 1}, AlwaysOnTop = {type = "boolean", default = false},
        Adornee = {type = "Instance:?"}, Brightness = {type = "number", default = 1}, ZOffset = {type = "number", default = 0},
        ClipsDescendants = {type = "boolean", default = true}}})
    defClass("GuiObject", "Instance", {creatable = false, props = {
        Size = {type = "UDim2", default = function() return udim2(0, 100, 0, 100) end},
        Position = {type = "UDim2", default = function() return udim2(0, 0, 0, 0) end},
        AnchorPoint = {type = "Vector2", default = function() return v2(0, 0) end},
        BackgroundColor3 = {type = "Color3", default = function() return c3(1, 1, 1) end},
        BackgroundTransparency = {type = "number", default = 0},
        BorderSizePixel = {type = "number", default = 1},
        BorderColor3 = {type = "Color3", default = function() return c3(0.1, 0.1, 0.1) end},
        Visible = {type = "boolean", default = true},
        ZIndex = {type = "number", default = 1},
        LayoutOrder = {type = "number", default = 0},
        Rotation = {type = "number", default = 0},
        ClipsDescendants = {type = "boolean", default = false},
        Active = {type = "boolean", default = false},
        AutomaticSize = {type = "Enum:AutomaticSize", default = function() return Enum.AutomaticSize.None end},
    }, events = {InputBegan = true, InputEnded = true, MouseEnter = true, MouseLeave = true}})
    defClass("Frame", "GuiObject", {})
    local textProps = {
        Text = {type = "string", default = "Label"},
        Font = {type = "Enum:Font", default = function() return Enum.Font.Legacy end},
        TextSize = {type = "number", default = 14},
        TextColor3 = {type = "Color3", default = function() return c3(0.1, 0.1, 0.1) end},
        TextScaled = {type = "boolean", default = false},
        TextWrapped = {type = "boolean", default = false},
        TextXAlignment = {type = "Enum:TextXAlignment", default = function() return Enum.TextXAlignment.Center end},
        TextYAlignment = {type = "Enum:TextYAlignment", default = function() return Enum.TextYAlignment.Center end},
        TextTransparency = {type = "number", default = 0},
        TextStrokeTransparency = {type = "number", default = 1},
        TextStrokeColor3 = {type = "Color3", default = function() return c3(0, 0, 0) end},
        RichText = {type = "boolean", default = false},
        LineHeight = {type = "number", default = 1},
        TextTruncate = {type = "Enum:TextTruncate", default = function() return Enum.TextTruncate.None end},
    }
    defClass("TextLabel", "GuiObject", {props = textProps})
    defClass("GuiButton", "GuiObject", {creatable = false, props = {
        AutoButtonColor = {type = "boolean", default = true}, Modal = {type = "boolean", default = false},
        Selected = {type = "boolean", default = false}},
        init = function(inst, d) d.props.Active = true end,
        events = {Activated = true, MouseButton1Click = true, MouseButton1Down = true, MouseButton1Up = true}})
    local buttonProps = table.clone(textProps)
    buttonProps.Text = {type = "string", default = "Button"}
    defClass("TextButton", "GuiButton", {props = buttonProps})
    defClass("UIComponent", "Instance", {creatable = false})
    defClass("UICorner", "UIComponent", {props = {CornerRadius = {type = "UDim", default = function() return udim(0, 8) end}}})
    defClass("UIStroke", "UIComponent", {props = {Color = {type = "Color3", default = function() return c3(0, 0, 0) end},
        Thickness = {type = "number", default = 1}, Transparency = {type = "number", default = 0},
        Enabled = {type = "boolean", default = true},
        ApplyStrokeMode = {type = "Enum:ApplyStrokeMode", default = function() return Enum.ApplyStrokeMode.Contextual end}}})
    defClass("UIScale", "UIComponent", {props = {Scale = {type = "number", default = 1}}})
    defClass("UITextSizeConstraint", "UIComponent", {props = {MaxTextSize = {type = "number", default = 100}, MinTextSize = {type = "number", default = 1}}})
    defClass("UIListLayout", "UIComponent", {props = {Padding = {type = "UDim", default = function() return udim(0, 0) end}}})
    defClass("UIPadding", "UIComponent", {props = {
        PaddingLeft = {type = "UDim", default = function() return udim(0, 0) end}, PaddingRight = {type = "UDim", default = function() return udim(0, 0) end},
        PaddingTop = {type = "UDim", default = function() return udim(0, 0) end}, PaddingBottom = {type = "UDim", default = function() return udim(0, 0) end}}})

    -- Sound: no audio is produced. Play() is recorded with the calling client so
    -- a scenario can check which cue fired, for whom and how often (K0.4.2).
    defClass("Sound", "Instance", {props = {
        SoundId = {type = "string", default = ""}, Volume = {type = "number", default = 0.5},
        PlaybackSpeed = {type = "number", default = 1}, Looped = {type = "boolean", default = false},
        RollOffMaxDistance = {type = "number", default = 10000}},
        methods = {
            Play = function(self)
                local ctx = currentContext()
                world.soundPlays = world.soundPlays or {}
                table.insert(world.soundPlays, {t = world.now, name = self.Name, id = self.SoundId,
                    volume = self.Volume, looped = self.Looped, player = ctx and ctx.playerName,
                    parent = self.Parent and self.Parent.ClassName})
            end,
            Stop = function(self) end,
        },
        events = {Ended = true, Loaded = true}})

    -- Services --------------------------------------------------------------
    defClass("ServiceProvider", "Instance", {creatable = false})
    defClass("DataModel", "ServiceProvider", {creatable = false, props = {PlaceId = {type = "number", default = 0}}})
    defClass("Workspace", "Instance", {creatable = false, props = {CurrentCamera = {type = "Instance:Camera?"},
        Gravity = {type = "number", default = 196.2}},
        methods = {GetServerTimeNow = function() return world.now end}})
    defClass("Camera", "Instance", {creatable = false, props = {
        ViewportSize = {type = "Vector2", readonly = true, default = function() return v2(1280, 720) end},
        CFrame = {type = "CFrame", default = function() return cf(0, 10, 0) end},
        FieldOfView = {type = "number", default = 70}}})
    defClass("Lighting", "Instance", {creatable = false, props = {
        ClockTime = {type = "number", default = 14}, Brightness = {type = "number", default = 2},
        Ambient = {type = "Color3", default = function() return c3(0.27, 0.27, 0.27) end},
        OutdoorAmbient = {type = "Color3", default = function() return c3(0.5, 0.5, 0.5) end}}})
    defClass("ReplicatedStorage", "Instance", {creatable = false})
    defClass("ServerScriptService", "Instance", {creatable = false})
    defClass("ServerStorage", "Instance", {creatable = false})
    defClass("StarterPlayer", "Instance", {creatable = false})
    defClass("StarterPlayerScripts", "Instance", {creatable = false})
    defClass("StarterGui", "Instance", {creatable = false})
    defClass("SoundService", "Instance", {creatable = false})
    defClass("PlayerGui", "Instance", {creatable = false})
    defClass("PlayerScripts", "Instance", {creatable = false})
    defClass("Player", "Instance", {creatable = false, props = {
        DisplayName = {type = "string", default = ""}, UserId = {type = "number", default = 0},
        Character = {type = "Instance:Model?"}},
        methods = {Kick = function(self, msg) world:removePlayer(self, "kick") end},
        events = {CharacterAdded = true, CharacterRemoving = true}})
    defClass("Players", "Instance", {creatable = false, props = {
        LocalPlayer = {type = "Instance:Player?", readonly = true, get = function(inst, d)
            local ctx = currentContext()
            return ctx and ctx.kind == "client" and ctx.player or nil
        end},
        MaxPlayers = {type = "number", default = 8}},
        methods = {
            GetPlayers = function(self)
                local out = {}
                for _, c in ipairs(internals[self].children) do if c:IsA("Player") then table.insert(out, c) end end
                return out
            end,
            GetPlayerFromCharacter = function(self, model)
                for _, p in ipairs(self:GetPlayers()) do if p.Character == model then return p end end
                return nil
            end,
        },
        events = {PlayerAdded = true, PlayerRemoving = true}})
    defClass("Tween", "Instance", {creatable = false, props = {
        PlaybackState = {type = "Enum:PlaybackState", default = function() return Enum.PlaybackState.Begin end}},
        methods = {
            Play = function(self)
                local d = internals[self]
                if d.playing then return end
                d.playing = true
                setPropRaw(self, "PlaybackState", Enum.PlaybackState.Playing)
                local target, info, goals, starts = d.target, d.info, d.goals, {}
                for k in pairs(goals) do starts[k] = target[k] end
                local total = info.Time
                local rec = newRec(function()
                    local elapsed = 0
                    while elapsed < total and not d.cancelled do
                        local dt = task.wait(math.min(TWEEN_STEP, total - elapsed))
                        elapsed += dt
                        if d.cancelled then break end
                        local a = math.clamp(elapsed / total, 0, 1)
                        for k, goal in pairs(goals) do
                            local s = starts[k]
                            local v
                            local ty = typeofValue(goal)
                            if ty == "number" then v = s + (goal - s) * a
                            elseif ty == "Vector3" or ty == "CFrame" or ty == "Color3" or ty == "UDim2" then v = s:Lerp(goal, a)
                            else v = a >= 1 and goal or s end
                            -- Roblox keeps tweening a destroyed instance; only Parent is locked.
                            if a >= 1 then v = goal end
                            target[k] = v
                        end
                    end
                    if d.cancelled then return end
                    setPropRaw(self, "PlaybackState", Enum.PlaybackState.Completed)
                    getSignal(d, "Completed"):_fire(Enum.PlaybackState.Completed)
                end, {kind = "engine"}, "tween")
                if total <= 0 then
                    for k, goal in pairs(goals) do target[k] = goal end
                    setPropRaw(self, "PlaybackState", Enum.PlaybackState.Completed)
                    getSignal(d, "Completed"):_fire(Enum.PlaybackState.Completed)
                    return
                end
                resume(rec)
            end,
            Cancel = function(self)
                local d = internals[self]
                d.cancelled = true
                setPropRaw(self, "PlaybackState", Enum.PlaybackState.Cancelled)
            end,
            Pause = function(self) internals[self].cancelled = true end,
        },
        events = {Completed = true}})
    defClass("TweenService", "Instance", {creatable = false, methods = {
        Create = function(self, target, info, goals)
            if not isInstance(target) then error("TweenService:Create expects an Instance", 2) end
            if not isType(info, "TweenInfo") then error("TweenService:Create expects TweenInfo", 2) end
            local td = internals[target]
            for k, v in pairs(goals) do
                local p = findProp(td.class, k)
                if not p then error(string.format("TweenService:Create property named '%s' cannot be tweened due to type mismatch (property is a 'unknown', but given type is '%s')", k, typeofValue(v)), 2) end
                local ptype = string.gsub(p.type, "%?$", "")
                local vt = typeofValue(v)
                local ok = (ptype == "number" and vt == "number") or ptype == vt
                if not ok then error(string.format("TweenService:Create property named '%s' cannot be tweened due to type mismatch (property is a '%s', but given type is '%s')", k, ptype, vt), 2) end
            end
            local tw = newInstance("Tween")
            local d = internals[tw]
            d.target, d.info, d.goals = target, info, table.clone(goals)
            return tw
        end}})
    defClass("Debris", "Instance", {creatable = false, methods = {
        AddItem = function(self, item, lifetime)
            task.delay(lifetime or 10, function()
                if not internals[item].destroyed then destroy(item) end
            end)
        end}})
    defClass("UserInputService", "Instance", {creatable = false, props = {
        TouchEnabled = {type = "boolean", default = false}, KeyboardEnabled = {type = "boolean", default = true},
        GamepadEnabled = {type = "boolean", default = false}},
        events = {InputBegan = true, InputEnded = true, InputChanged = true}})
    defClass("CollectionService", "Instance", {creatable = false, methods = {
        GetTagged = function(self, tag) return {} end,
        HasTag = function() return false end,
        AddTag = function() end,
    }})
    defClass("ProximityPromptService", "Instance", {creatable = false, events = {PromptTriggered = true}})
    defClass("RunService", "Instance", {creatable = false, methods = {
        IsStudio = function() return true end,
        IsServer = function() local c = currentContext() return not c or c.kind ~= "client" end,
        IsClient = function() local c = currentContext() return c ~= nil and c.kind == "client" end,
    }, events = {Heartbeat = true, RenderStepped = true, Stepped = true, PreSimulation = true, PreRender = true,
        PostSimulation = true}})

    local SERVICES = {"Workspace", "Players", "Lighting", "ReplicatedStorage", "ServerScriptService", "ServerStorage",
        "StarterPlayer", "StarterGui", "SoundService", "TweenService", "Debris", "UserInputService",
        "CollectionService", "ProximityPromptService", "RunService"}
    classes.DataModel.methods.GetService = function(self, name)
        local s = self:FindFirstChildOfClass(name)
        if s then return s end
        error("'" .. tostring(name) .. "' is not a valid Service name (harness)", 2)
    end
    classes.DataModel.methods.FindService = function(self, name) return self:FindFirstChildOfClass(name) end
    classes.DataModel.methods.BindToClose = function(self, fn)
        world.closeHandlers = world.closeHandlers or {}
        table.insert(world.closeHandlers, {fn = fn, context = currentContext()})
    end
    -- Server shutdown (a Studio test stopping): every bound callback runs in its
    -- own thread, as Roblox runs them concurrently before the server closes.
    function world:close()
        for _, h in ipairs(self.closeHandlers or {}) do
            self._resume({co = coroutine.create(h.fn), context = h.context})
        end
        self:advance(0)
    end

    -- Build the DataModel of a fresh Baseplate place.
    local game = newInstance("DataModel")
    internals[game].props.Name = "Game"
    for _, name in ipairs(SERVICES) do
        local s = newInstance(name)
        internals[s].props.Name = name
        internals[s].parent = game
        table.insert(internals[game].children, s)
    end
    local ws = game:GetService("Workspace")
    local camera = newInstance("Camera")
    camera.Name = "Camera"
    camera.Parent = ws
    ws.CurrentCamera = camera
    local sps = newInstance("StarterPlayerScripts")
    sps.Name = "StarterPlayerScripts"
    sps.Parent = game:GetService("StarterPlayer")
    local baseplate = newInstance("Part")
    baseplate.Name = "Baseplate"
    baseplate.Size = v3(2048, 16, 2048)
    baseplate.Position = v3(0, -8, 0)
    baseplate.Anchored = true
    baseplate.Parent = ws
    local spawnLoc = newInstance("SpawnLocation")
    spawnLoc.Name = "SpawnLocation"
    spawnLoc.Size = v3(12, 1, 12)
    spawnLoc.Position = v3(0, 0.5, 0)
    spawnLoc.Anchored = true
    spawnLoc.Parent = ws
    world.game = game
    world.workspace = ws
    world.camera = camera
    world.defaultContext = {kind = "engine"}


    ------------------------------------------------------------ globals
    local Instance = {new = function(className, parent)
        local c = classes[className]
        if not c or not c.creatable then error("Unable to create an Instance of type \"" .. tostring(className) .. "\"", 2) end
        return newInstance(className, parent)
    end}
    function TweenInfo.new(time, style, direction, repeatCount, reverses, delayTime)
        return setmetatable({Time = time or 1, EasingStyle = style or Enum.EasingStyle.Quad,
            EasingDirection = direction or Enum.EasingDirection.Out, RepeatCount = repeatCount or 0,
            Reverses = reverses or false, DelayTime = delayTime or 0}, TI)
    end
    local Random = {new = function(seed)
        if seed == nil then
            world.unseededRandoms = (world.unseededRandoms or 0) + 1
            seed = 987654 + world.unseededRandoms * 7919
        end
        return setmetatable({_s = bit32.band(math.floor(seed), 0xFFFFFFFF), _draws = 0}, RND)
    end}
    world.Random = Random

    local function outputLine(kind, ...)
        local n = select("#", ...)
        local parts = {}
        for i = 1, n do parts[i] = tostring((select(i, ...))) end
        local line = table.concat(parts, " ")
        local ctx = contextLabel(currentContext())
        if kind == "print" then
            table.insert(world.output, {t = world.now, context = ctx, line = line})
        else
            table.insert(world.warnings, {t = world.now, context = ctx, message = line})
        end
        if world.echo then print(string.format("[%7.2f] %-5s %-14s %s", world.now, kind, ctx, line)) end
    end

    local osShim = setmetatable({
        clock = function() return world.now end,
        time = function() return 1790000000 + math.floor(world.now) end,
    }, {__index = os})

    local requireFn
    local globals = {
        game = game, workspace = ws, Workspace = ws,
        Instance = Instance, Vector3 = Vector3, Vector2 = Vector2, CFrame = CFrame, Color3 = Color3,
        UDim = UDim, UDim2 = UDim2, TweenInfo = TweenInfo, Random = Random, Enum = Enum,
        task = task, typeof = typeofValue, os = osShim,
        tick = function() return 1790000000 + world.now end,
        time = function() return world.now end,
        wait = function(t) return task.wait(t) end,
        spawn = function(f) return task.defer(f) end,
        delay = function(t, f) return task.delay(t, f) end,
        print = function(...) outputLine("print", ...) end,
        warn = function(...) outputLine("warn", ...) end,
        require = function(m) return requireFn(m) end,
    }
    setmetatable(globals, {__index = getfenv(0)})

    local function makeEnv(scriptInst, context)
        local env = setmetatable({script = scriptInst, _G = context.G, shared = context.G}, {__index = globals})
        return env
    end

    function requireFn(m)
        if not isInstance(m) or not m:IsA("ModuleScript") then error("Attempted to call require with invalid argument(s).", 2) end
        local ctx = currentContext()
        local key = (ctx and ctx.kind == "client") and ("client:" .. ctx.playerName) or "server"
        world.moduleCache[key] = world.moduleCache[key] or {}
        local cache = world.moduleCache[key]
        if cache[m] ~= nil then return cache[m].value end
        local src = internals[m].source
        if not src then error("ModuleScript has no source (harness): " .. fullName(m), 2) end
        local fn, err = loadstring(src, "=" .. internals[m].props.Name)
        if not fn then error("Syntax error in module " .. fullName(m) .. ": " .. tostring(err), 2) end
        setfenv(fn, makeEnv(m, ctx or {kind = "server", G = {}}))
        local results = table.pack(fn())
        if results.n ~= 1 then error("Module code did not return exactly one value", 2) end
        cache[m] = {value = results[1]}
        return results[1]
    end

    -- Runs a chunk as its own script thread. Returns the thread record.
    function world:runChunk(source, chunkName, scriptInst, context)
        local fn, err = loadstring(source, "=" .. chunkName)
        if not fn then
            table.insert(world.errors, {t = world.now, context = contextLabel(context), message = "Syntax error: " .. tostring(err), name = chunkName})
            return nil
        end
        setfenv(fn, makeEnv(scriptInst, context))
        local rec = {context = context, name = chunkName}
        rec.co = coroutine.create(function()
            local r = table.pack(fn())
            rec.returned = r
            rec.finished = true
        end)
        resume(rec)
        return rec
    end

    function world:setViewport(x, y)
        local before = {}
        for g in pairs(world.screenGuis) do before[g] = screenGuiSize(g) end
        setPropRaw(camera, "ViewportSize", v2(x, y))
        for g, old in pairs(before) do
            local now = screenGuiSize(g)
            if now ~= old then
                local d = internals[g]
                local ps = d.propSignals.AbsoluteSize
                if ps then ps:_fire() end
            end
        end
    end
    world.guiInset = 58

    -- K0.4.7 frame events. Off unless a scenario starts them, so every other
    -- scenario keeps its speed: RunService.PreSimulation then PreRender fire hz
    -- times per virtual second, each with its frame time.
    function world:startFrames(hz)
        local rs = game:GetService("RunService")
        self.frames = 0
        self.stopFrames = false
        resume({co = coroutine.create(function()
            while not self.stopFrames do
                local dt = task.wait(1 / hz)
                self.frames += 1
                rs.PreSimulation:_fire(dt)
                rs.PreRender:_fire(dt)
            end
        end), context = {kind = "engine"}, name = "frames"})
    end

    world.globals = globals
    world.Enum = Enum
    world.v3 = v3
    world.cf = cf
    world.typeof = typeofValue
    world.contextLabel = contextLabel
    return world
end

Engine.types = {Vector3 = Vector3, Vector2 = Vector2, CFrame = CFrame, Color3 = Color3, UDim = UDim,
    UDim2 = UDim2, Enum = Enum, typeof = typeofValue}

return Engine
