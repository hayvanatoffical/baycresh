--!nocheck
-- K0 place assembly and player actions on top of the mock engine.
-- Expects SOURCES (name -> Luau text) and Engine to be defined by the bundle.

local K0World = {}

local BUILD_ORDER = {"SCENE_BUILD", "STALL_ART_BUILD", "ART_V2_FIX", "STALL_ART_V3", "MARKET_SYSTEM_BUILD"}
K0World.BUILD_ORDER = BUILD_ORDER

-- options.configPatch(text) -> text lets a scenario shorten timers on a copy,
-- exactly like the Edit-mode smoke copy described in the test plan.
function K0World.new(options)
    options = options or {}
    local world = Engine.new({signalMode = options.signalMode, echo = options.echo})
    local game = world.game
    local self = {world = world, game = game, options = options, builderResults = {}}
    setmetatable(self, {__index = K0World})

    self.editContext = {kind = "edit", G = {}}
    self.serverContext = {kind = "server", G = {}}
    self.clients = {}
    return self
end

function K0World:runBuilder(name)
    local rec = self.world:runChunk(SOURCES[name], name, nil, self.editContext)
    self.world:advance(0)
    -- Builders use WaitForChild on objects that already exist; let any yield settle.
    self.world:advance(0.5)
    local result = rec and rec.returned and rec.returned[1]
    table.insert(self.builderResults, {name = name, finished = rec and rec.finished or false, result = result})
    return rec
end

function K0World:buildScene(order)
    for _, name in ipairs(order or BUILD_ORDER) do self:runBuilder(name) end
end

local function newScript(world, className, name, source, parent)
    local s = world.newInstance(className)
    s.Name = name
    world.internals[s].source = source
    s.Parent = parent
    return s
end

-- Installs the three active runtime sources at their Studio paths.
function K0World:installRuntime()
    local world, game = self.world, self.game
    local configSource = SOURCES.K0MarketConfig
    if self.options.configPatch then configSource = self.options.configPatch(configSource) end
    self.configModule = newScript(world, "ModuleScript", "K0MarketConfig", configSource, game:GetService("ReplicatedStorage"))
    self.serverScript = newScript(world, "Script", "K0Market", SOURCES.K0Market, game:GetService("ServerScriptService"))
    local sps = game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts")
    self.hudScript = newScript(world, "LocalScript", "K0MarketHUD", SOURCES.K0MarketHUD, sps)
    self.motionScript = newScript(world, "LocalScript", "K0NpcMotion", SOURCES.K0NpcMotion, sps)
end

-- Places the historical legacy runtime into the place, enabled, as a copied
-- Studio place would still have it.
function K0World:installLegacy()
    local world, game = self.world, self.game
    newScript(world, "Script", "K0Game", SOURCES.K0Game, game:GetService("ServerScriptService"))
    local sps = game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts")
    newScript(world, "LocalScript", "K0HUD", SOURCES.K0HUD, sps)
end

-- Play: every enabled Script in ServerScriptService starts in the server context.
function K0World:startServer()
    local world = self.world
    world.defaultContext = self.serverContext
    for _, s in ipairs(self.game:GetService("ServerScriptService"):GetChildren()) do
        if s:IsA("Script") and s.Enabled then
            world:runChunk(world.internals[s].source, s.Name, s, self.serverContext)
        end
    end
    world:advance(0.1)
end

function K0World:addPlayer(name, spawnPos)
    local world, game = self.world, self.game
    world.userIds = (world.userIds or 0) + 1
    local player = world.newInstance("Player")
    player.Name = name
    player.DisplayName = name
    player.UserId = 1000 + world.userIds
    local gui = world.newInstance("PlayerGui")
    gui.Name = "PlayerGui"
    gui.Parent = player
    local scripts = world.newInstance("PlayerScripts")
    scripts.Name = "PlayerScripts"
    scripts.Parent = player
    player.Parent = game:GetService("Players")
    game:GetService("Players").PlayerAdded:_fire(player)
    world:advance(0)

    -- Character
    local model = world.newInstance("Model")
    model.Name = name
    local root = world.newInstance("Part")
    root.Name = "HumanoidRootPart"
    root.Size = Vector3.new(2, 2, 1)
    root.Anchored = true
    root.Transparency = 1
    root.Parent = model
    local humanoid = world.newInstance("Humanoid")
    humanoid.Name = "Humanoid"
    humanoid.Parent = model
    model.PrimaryPart = root
    model.Parent = game:GetService("Workspace")
    local spawn = spawnPos or Vector3.new(-40, 4, -6)
    root.Position = spawn
    player.Character = model
    player.CharacterAdded:_fire(model)

    -- Client scripts
    local ctx = {kind = "client", player = player, playerName = name, G = {}}
    self.clients[player] = ctx
    local sps = game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts")
    for _, s in ipairs(sps:GetChildren()) do
        if s:IsA("LocalScript") and s.Enabled then
            local copy = s:Clone()
            copy.Parent = scripts
            world:runChunk(world.internals[copy].source, s.Name, copy, ctx)
        end
    end
    world:advance(0.1)
    return player
end

function K0World:removePlayer(player)
    local world, game = self.world, self.game
    game:GetService("Players").PlayerRemoving:_fire(player)
    world:advance(0)
    local ctx = self.clients[player]
    if ctx then ctx.dead = true end
    if player.Character then player.Character:Destroy() end
    player.Parent = nil
    world:advance(0.1)
end

function K0World:root(player)
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

-- Stand in front of a target part on the street side, at character root height.
function K0World:walkTo(player, part, offset)
    local p = part.Position
    local pos = Vector3.new(p.X, 3.6, p.Z - 2.5)
    if offset then pos = pos + offset end
    self:root(player).Position = pos
    self.world:advance(0.1)
end

function K0World:promptPosition(prompt)
    local parent = prompt.Parent
    if parent:IsA("BasePart") then return parent.Position end
    if parent:IsA("Model") then return parent:GetPivot().Position end
    return nil
end

-- Returns every enabled prompt with the same key that is closer to the player
-- than the requested one; under the default OnePerButton exclusivity those can
-- take the on-screen slot. Reported, not failed: the rule is Roblox-side.
function K0World:closerPrompts(player, prompt)
    local out = {}
    local here = self:root(player).Position
    local mine = (here - self:promptPosition(prompt)).Magnitude
    for _, d in ipairs(self.game:GetService("Workspace"):GetDescendants()) do
        if d:IsA("ProximityPrompt") and d ~= prompt and d.Enabled and d.KeyboardKeyCode == prompt.KeyboardKeyCode then
            local pos = self:promptPosition(d)
            if pos then
                local dist = (here - pos).Magnitude
                if dist <= d.MaxActivationDistance and dist < mine then table.insert(out, d) end
            end
        end
    end
    return out
end

-- Simulates the player holding the prompt key. Returns ok, reason.
function K0World:trigger(player, prompt)
    local world = self.world
    if not prompt:IsDescendantOf(self.game:GetService("Workspace")) then return false, "not in workspace" end
    if not prompt.Enabled then return false, "disabled" end
    local pos = self:promptPosition(prompt)
    if not pos then return false, "no position" end
    local dist = (self:root(player).Position - pos).Magnitude
    if dist > prompt.MaxActivationDistance then return false, string.format("out of range %.1f > %.1f", dist, prompt.MaxActivationDistance) end
    local closer = self:closerPrompts(player, prompt)
    if #closer > 0 then
        self.promptOcclusions = self.promptOcclusions or {}
        table.insert(self.promptOcclusions, {t = world.now, prompt = world.fullName(prompt), closer = world.fullName(closer[1])})
    end
    if prompt.HoldDuration > 0 then
        world:advance(prompt.HoldDuration)
        if not prompt.Enabled then return false, "disabled during hold" end
    end
    prompt.Triggered:_fire(player)
    self.game:GetService("ProximityPromptService").PromptTriggered:_fire(prompt, player)
    world:advance(0)
    return true
end

function K0World:walkAndTrigger(player, prompt)
    self:walkTo(player, prompt.Parent)
    return self:trigger(player, prompt)
end

function K0World:hud(player)
    return player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("BaycrestK0MarketHUD")
end

local function visibleChain(obj)
    local cur = obj
    while cur do
        if cur:IsA("GuiObject") and not cur.Visible then return false end
        if cur:IsA("LayerCollector") then return cur.Enabled end
        cur = cur.Parent
    end
    return false
end
K0World.visibleChain = visibleChain

-- Taps a GUI button. Activated fires only when the button is visible and Active,
-- which is the documented GuiButton behaviour.
function K0World:click(player, button)
    if not visibleChain(button) then return false, "not visible" end
    local fired = false
    if button.Active then
        button.Activated:_fire({UserInputType = Enum.UserInputType.Touch}, 1)
        fired = true
    end
    button.MouseButton1Click:_fire()
    self.world:advance(0)
    return fired, fired and "activated" or "inactive"
end

function K0World:press(player, keyName)
    local ctx = self.clients[player]
    local input = {KeyCode = Enum.KeyCode[keyName], UserInputType = Enum.UserInputType.Keyboard, UserInputState = Enum.UserInputState.Begin}
    self.game:GetService("UserInputService").InputBegan:_fireFiltered(function(c) return c == ctx end, input, false)
    self.world:advance(0)
end

-- Fires the decision remote from inside the player's client context.
function K0World:fireDecision(player, ...)
    local world = self.world
    local ctx = self.clients[player]
    local args = table.pack(...)
    local rec = {co = coroutine.create(function()
        local remote = self.game:GetService("ReplicatedStorage"):WaitForChild("K0MarketDecision")
        remote:FireServer(table.unpack(args, 1, args.n))
    end), context = ctx, name = "test-remote"}
    world._resume(rec)
    world:advance(0)
end

function K0World:scene()
    return self.game:GetService("Workspace"):FindFirstChild("BlackstoneBazaar_K0")
end

function K0World:attr(player, name) return player:GetAttribute(name) end

function K0World:outputMatching(pattern)
    local out = {}
    for _, o in ipairs(self.world.output) do
        if string.find(o.line, pattern) then table.insert(out, o) end
    end
    return out
end

function K0World:errorsText()
    local lines = {}
    for _, e in ipairs(self.world.errors) do
        table.insert(lines, string.format("t=%.2f %s %s", e.t, e.context, e.traceback or e.message))
    end
    return table.concat(lines, "\n")
end

function K0World:pendingWaits()
    local out = {}
    for _, w in ipairs(self.world.waits) do
        if not w.done and not (w.context and w.context.dead) then
            table.insert(out, string.format("%s:WaitForChild(\"%s\") since t=%.1f", self.world.fullName(w.parent), w.name, w.since))
        end
    end
    return out
end

-- Absolute layout size of a GuiObject in pixels, before UIScale.
function K0World:absSize(obj)
    local world = self.world
    local parent = obj.Parent
    local pw, ph
    if parent:IsA("ScreenGui") then
        local area = parent.AbsoluteSize
        pw, ph = area.X, area.Y
    elseif parent:IsA("GuiObject") then
        pw, ph = self:absSize(parent)
    else
        return nil
    end
    local s = obj.Size
    return s.X.Scale * pw + s.X.Offset, s.Y.Scale * ph + s.Y.Offset
end

function K0World:uiScale(obj)
    local scale = 1
    local cur = obj
    while cur and not cur:IsA("LayerCollector") do
        for _, c in ipairs(cur:GetChildren()) do
            if c:IsA("UIScale") then scale *= c.Scale end
        end
        cur = cur.Parent
    end
    return scale
end

-- On-screen rectangle of a GuiObject in its ScreenGui, in pixels: x, y, width,
-- height. A UIScale shrinks the object about its AnchorPoint and scales its
-- descendants' offsets with it (documented UIScale behaviour, approximated).
function K0World:rect(obj)
    local parent = obj.Parent
    local px, py, pw, ph, pk
    if parent:IsA("ScreenGui") then
        local area = parent.AbsoluteSize
        px, py, pw, ph, pk = 0, 0, area.X, area.Y, 1
    else
        local k
        px, py, pw, ph, k = self:rect(parent)
        pk = k
    end
    local uw, uh = pw / pk, ph / pk
    local own = 1
    for _, c in ipairs(obj:GetChildren()) do
        if c:IsA("UIScale") then own *= c.Scale end
    end
    local k = pk * own
    local s, p, a = obj.Size, obj.Position, obj.AnchorPoint
    local w = (s.X.Scale * uw + s.X.Offset) * k
    local h = (s.Y.Scale * uh + s.Y.Offset) * k
    local ax = px + (p.X.Scale * uw + p.X.Offset) * pk
    local ay = py + (p.Y.Scale * uh + p.Y.Offset) * pk
    return ax - a.X * w, ay - a.Y * h, w, h, k
end

function K0World.overlapArea(a, b)
    local w = math.min(a[1] + a[3], b[1] + b[3]) - math.max(a[1], b[1])
    local h = math.min(a[2] + a[4], b[2] + b[4]) - math.max(a[2], b[2])
    return (w > 0 and h > 0) and w * h or 0
end

-- Text fit ESTIMATE. Gotham glyph widths are approximated per character class;
-- this is a risk flag for the device test, not a measurement.
local function glyphEm(ch)
    if ch == " " then return 0.28 end
    if string.match(ch, "%d") then return 0.62 end
    if string.match(ch, "[%.,:;|!'%(%)/]") then return 0.30 end
    if string.match(ch, "%u") then return 0.70 end
    if string.match(ch, "%l") then return 0.56 end
    return 0.62 -- multibyte Turkish letters and symbols such as ₡
end
function K0World.estimateLines(text, textSize, widthPx)
    local lines = 0
    for paragraph in string.gmatch(text .. "\n", "([^\n]*)\n") do
        local lineW, count = 0, 1
        local spaceW = 0.28 * textSize
        for word in string.gmatch(paragraph, "%S+") do
            local w = 0
            for _, code in utf8.codes(word) do w += glyphEm(utf8.char(code)) * textSize end
            if lineW > 0 and lineW + spaceW + w > widthPx then
                count += 1
                lineW = w
            else
                lineW = lineW > 0 and (lineW + spaceW + w) or w
            end
        end
        lines += count
    end
    return lines
end

-- Returns a list of {name, text, needPx, havePx, effSize} for labels whose
-- estimated wrapped height exceeds their box.
function K0World:textFitRisks(root, lineHeight)
    lineHeight = lineHeight or 1.2
    local risks = {}
    for _, obj in ipairs(root:GetDescendants()) do
        if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and not obj.TextScaled and obj.Text ~= "" and visibleChain(obj) then
            local w, h = self:absSize(obj)
            if w and h then
                local lines = obj.TextWrapped and K0World.estimateLines(obj.Text, obj.TextSize, w) or 1
                local need = lines * obj.TextSize * lineHeight
                local widthNeed = 0
                if not obj.TextWrapped then
                    for _, code in utf8.codes(obj.Text) do widthNeed += glyphEm(utf8.char(code)) * obj.TextSize end
                end
                if need > h + 0.5 or widthNeed > w + 0.5 then
                    table.insert(risks, {name = obj.Name, text = obj.Text, needPx = need, havePx = h, lines = lines,
                        effSize = obj.TextSize * self:uiScale(obj)})
                end
            end
        end
    end
    return risks
end

-- Smallest effective (post-UIScale) text size among visible, non-scaled labels.
function K0World:minTextSize(root)
    local min, name = math.huge, nil
    for _, obj in ipairs(root:GetDescendants()) do
        if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and not obj.TextScaled and obj.Text ~= "" and visibleChain(obj) then
            local eff = obj.TextSize * self:uiScale(obj)
            if eff < min then min, name = eff, obj.Name end
        end
    end
    return min, name
end

return K0World
