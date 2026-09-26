--!nocheck
-- K0 harness scenarios. Each scenario builds a fresh place from the real scene
-- builders, installs the real runtime sources and drives them like a player.
-- Expected behaviour comes from GAME/README.md, PRODUCTION/K0.4_NEXT_TEST_PLAN.md
-- and the K0.4 implementation report; a failing check is a source defect or a
-- harness defect and is investigated, never silenced.

local RESULTS = {}
local CURRENT

local function check(cond, message)
    table.insert(CURRENT.checks, {ok = cond and true or false, message = message})
    return cond
end

local function note(message)
    table.insert(CURRENT.notes, message)
end

local function scenario(id, title, modes, fn)
    if OPTIONS.hasOnly and not OPTIONS.only[id] then return end
    for _, mode in ipairs(modes or OPTIONS.signalModes) do
        local wanted = false
        for _, m in ipairs(OPTIONS.signalModes) do if m == mode then wanted = true end end
        if wanted then
            CURRENT = {id = id, title = title, mode = mode, checks = {}, notes = {}}
            local ok, err = pcall(fn, mode)
            if not ok then
                table.insert(CURRENT.checks, {ok = false, message = "scenario crashed: " .. tostring(err)})
            end
            table.insert(RESULTS, CURRENT)
        end
    end
end

--------------------------------------------------------------------- setup
local function readConfig()
    local fn = loadstring(SOURCES.K0MarketConfig, "=K0MarketConfig")
    return fn()
end
local CONFIG = readConfig()
local C = CONFIG.Prototype

-- build_place.py compares the scene tree Lune builds from the same sources with
-- this one (two independent implementations of the DOM must agree).
if OPTIONS.dumpScene then
    local w = K0World.new({signalMode = "Deferred"})
    w:buildScene()
    w:installRuntime()
    for _, service in ipairs({"Workspace", "Lighting", "ReplicatedStorage", "ServerScriptService", "StarterPlayer"}) do
        for _, inst in ipairs(w.game:GetService(service):GetDescendants()) do
            print("SCENE\t" .. inst:GetFullName() .. "\t" .. inst.ClassName)
        end
    end
    print("HARNESS RESULT: DUMP")
    return
end

-- Every player-facing text any scenario produced, for the fit check in H15.
local SEEN_TEXT = {notice = {}, help = {}, goal = {}}

local function remember(kind, text)
    if type(text) == "string" and text ~= "" then SEEN_TEXT[kind][text] = true end
end

local function setup(mode, opts)
    opts = opts or {}
    local w = K0World.new({signalMode = mode, echo = OPTIONS.echo, configPatch = opts.configPatch})
    w:buildScene()
    w:installRuntime()
    w:startServer()
    w.addPlayer = function(self, name, spawnPos)
        local p = K0World.addPlayer(self, name, spawnPos)
        p:GetAttributeChangedSignal("K0Notice"):Connect(function() remember("notice", p:GetAttribute("K0Notice")) end)
        local gui = self:hud(p)
        local helpText = gui and gui:FindFirstChild("Help") and gui.Help:FindFirstChild("HelpText")
        local goal = gui and gui:FindFirstChild("Status") and gui.Status:FindFirstChild("Goal")
        if helpText then helpText:GetPropertyChangedSignal("Text"):Connect(function() remember("help", helpText.Text) end) end
        if goal then goal:GetPropertyChangedSignal("Text"):Connect(function() remember("goal", goal.Text) end) end
        return p
    end
    return w
end

-- Patches a number inside the Prototype block only (Production repeats some names,
-- e.g. ShiftSeconds).
local function patchNumber(field, value)
    return function(text)
        local at = assert(string.find(text, "Prototype = {", 1, true), "Prototype block not found")
        local head, tail = string.sub(text, 1, at - 1), string.sub(text, at)
        local out, n = string.gsub(tail, "(%f[%w]" .. field .. "%s*=%s*)%d+", "%1" .. value, 1)
        assert(n == 1, "config patch failed for " .. field)
        return head .. out
    end
end

local function patches(...)
    local list = {...}
    return function(text)
        for _, f in ipairs(list) do text = f(text) end
        return text
    end
end

local function noScriptErrors(w)
    local ok = #w.world.errors == 0
    check(ok, "no script errors" .. (ok and "" or (":\n" .. w:errorsText())))
    return ok
end

local function noUnexpectedWarnings(w, allow)
    local bad = {}
    for _, x in ipairs(w.world.warnings) do
        local allowed = false
        for _, pat in ipairs(allow or {}) do if string.find(x.message, pat) then allowed = true end end
        if not allowed then table.insert(bad, x.message) end
    end
    check(#bad == 0, "no unexpected warnings" .. (#bad == 0 and "" or (": " .. table.concat(bad, " | "))))
end

-- Scene handles ------------------------------------------------------------
local function handles(w)
    local scene = w:scene()
    local market = scene.MarketSystem
    local interaction = scene.Interaction
    return {
        scene = scene,
        claim = scene.Stall_01.NameSign.ClaimPrompt,
        sale = interaction.SalePoint.SalePrompt,
        upgrade = interaction.UpgradeBoard.UpgradeBoardPrompt,
        hire = interaction.HireBoard.HireBoardPrompt,
        pay = interaction.PayBoard.PayBoardPrompt,
        permit = market.PermitOffice.PermitPrompt,
        orange = market.OrangeWholesale.OrangeRestockPrompt,
        bread = market.BreadWholesale.BreadRestockPrompt,
        sign = scene.Stall_01.NameSign.SignSurface.OwnerText,
    }
end

local function attr(p, name) return p:GetAttribute(name) end
local function stockOf(p, sku) return sku == "orange" and attr(p, "K0OrangeStock") or attr(p, "K0BreadStock") end
local function capOf(p, sku)
    local product = C.Products[sku]
    return (attr(p, "K0Level") or 1) >= 2 and product.Level2Capacity or product.Level1Capacity
end
local function unitCost(sku) return C.Products[sku].WholesaleCost // C.Products[sku].WholesaleBundle end
local MIN_UNIT = math.min(unitCost("orange"), unitCost("bread"))

-- Travel at default walk speed so customer patience is spent realistically.
local WALK_SPEED = 16
local function go(w, p, prompt)
    local target = prompt.Parent.Position
    local stand = Vector3.new(target.X, 3.6, target.Z - 2.5)
    local here = w:root(p).Position
    local dt = (stand - here).Magnitude / WALK_SPEED
    if dt > 0.05 then w.world:advance(dt) end
    w:root(p).Position = stand
    w.world:advance(0.05)
    return w:trigger(p, prompt)
end

local function hudParts(w, p)
    local gui = w:hud(p)
    return gui, gui and gui:FindFirstChild("Offer")
end

-- Opens the offer at the stall and answers it through the HUD buttons.
local function answerOffer(w, p, h, decide, think)
    local ok, why = go(w, p, h.sale)
    if not ok then return false, "sale prompt: " .. tostring(why) end
    w.world:advance(think or 1.0)
    if not attr(p, "K0OfferOpen") then return false, "offer did not open" end
    local _, offer = hudParts(w, p)
    local action = decide(p)
    local button = offer:FindFirstChild(action == "accept" and "Accept" or action == "counter" and "Counter" or "Decline")
    local fired, reason = w:click(p, button)
    w.world:advance(0.1)
    return fired, reason
end

local function defaultDecision(p)
    local sku = attr(p, "K0OfferSKU")
    local have = stockOf(p, sku)
    if have < (attr(p, "K0OfferUnits") or 0) then return "decline" end
    if attr(p, "K0OfferType") == "Bargainer" then
        return attr(p, "K0OfferSignal") == "SIKI" and "accept" or "counter"
    end
    return "accept"
end

-- Invariant monitor ------------------------------------------------------------
local function ledgerHolds(p)
    local cash = attr(p, "K0Cash")
    local expected = C.StartingCash + attr(p, "K0Revenue") - attr(p, "K0OperatingCost") - attr(p, "K0InvestmentSpent")
    return cash == expected, cash, expected
end

-- A state from which no sequence of player actions can produce income again.
local function deadEnd(p)
    if not attr(p, "K0Claimed") or not attr(p, "K0Permit") then return false end
    local cash = attr(p, "K0Cash")
    local stock = attr(p, "K0OrangeStock") + attr(p, "K0BreadStock")
    if attr(p, "K0RentDue") then
        -- Paying must leave enough to buy one unit, otherwise the renewal itself strands.
        return stock == 0 and cash < C.PermitFee + MIN_UNIT and (attr(p, "K0RescueGrants") or 0) >= (C.RescueGrantLimit or 1)
    end
    return stock == 0 and cash < MIN_UNIT
end

local function checkInvariants(w, p, bag)
    local ok, cash, expected = ledgerHolds(p)
    if not ok and not bag.ledger then bag.ledger = string.format("t=%.1f cash %s ~= ledger %s", w.world.now, tostring(cash), tostring(expected)) end
    if attr(p, "K0Cash") < 0 and not bag.negative then bag.negative = string.format("t=%.1f cash %d", w.world.now, attr(p, "K0Cash")) end
    for _, sku in ipairs({"orange", "bread"}) do
        local s = stockOf(p, sku)
        if (s < 0 or s > capOf(p, sku)) and not bag.stock then bag.stock = string.format("t=%.1f %s stock %d cap %d", w.world.now, sku, s, capOf(p, sku)) end
    end
    if deadEnd(p) and not bag.dead then
        bag.dead = string.format("t=%.1f cash=%d stock=%d permitDue=%s rescues=%d", w.world.now, attr(p, "K0Cash"),
            attr(p, "K0OrangeStock") + attr(p, "K0BreadStock"), tostring(attr(p, "K0RentDue")), attr(p, "K0RescueGrants") or 0)
    end
end

-- Balanced player bot ----------------------------------------------------------
-- Mirrors the "dengeli" policy of TOOLS/simulate_k0.py closely enough to reach
-- every K0 system; it plays through the prompts and HUD buttons only.
local function botStep(w, p, h, policy)
    policy = policy or {}
    local reserve = policy.reserve or 30
    local cash = attr(p, "K0Cash")
    if not attr(p, "K0Claimed") then return go(w, p, h.claim) end
    if not attr(p, "K0Permit") or attr(p, "K0RentDue") then
        if attr(p, "K0RentDue") and cash < C.PermitFee then
            for _, sku in ipairs({"orange", "bread"}) do
                if stockOf(p, sku) > 0 then return go(w, p, h[sku]) end
            end
        end
        if policy.renew == false and attr(p, "K0RentDue") then w.world:advance(1) return end
        return go(w, p, h.permit)
    end
    if attr(p, "K0WagesDue") and cash >= C.WagePerShift and h.pay.Enabled then return go(w, p, h.pay) end
    if attr(p, "K0CustomerReady") and not policy.ignoreCustomers then
        return answerOffer(w, p, h, policy.decide or defaultDecision, policy.think)
    end
    local level = attr(p, "K0Level")
    if level == 1 and policy.upgrade ~= false and cash >= C.UpgradeCost + reserve then return go(w, p, h.upgrade) end
    if level >= 2 and policy.hire ~= false and not attr(p, "K0Hired") and cash >= C.HireCost + reserve then return go(w, p, h.hire) end
    local demand = attr(p, "K0DemandSKU")
    local other = demand == "orange" and "bread" or "orange"
    -- stockOnly = "demand" | "anti" isolates the demand decision for H16.
    local skus = policy.stockOnly == "demand" and {demand} or policy.stockOnly == "anti" and {other} or {demand, other}
    for _, sku in ipairs(skus) do
        local s = stockOf(p, sku)
        local low = (policy.stockOnly or sku == demand) and s < capOf(p, sku) or s < 2
        if low and cash >= unitCost(sku) and not policy.noRestock then return go(w, p, h[sku]) end
    end
    -- Idle at the stall like a player waiting for customers.
    local sale = h.sale.Parent.Position
    w:root(p).Position = Vector3.new(sale.X, 3.6, sale.Z - 1)
    w.world:advance(0.5)
end

local function playFor(w, p, h, seconds, policy, bag)
    bag = bag or {}
    local stop = w.world.now + seconds
    while w.world.now < stop do
        botStep(w, p, h, policy)
        checkInvariants(w, p, bag)
        if #w.world.errors > 0 then break end
    end
    return bag
end

local function reportBag(bag, allowDead)
    check(bag.ledger == nil, "cash equals ledger (start + revenue - operating cost - investment)" .. (bag.ledger and (": " .. bag.ledger) or ""))
    check(bag.negative == nil, "cash never negative" .. (bag.negative and (": " .. bag.negative) or ""))
    check(bag.stock == nil, "stock stays within 0..capacity" .. (bag.stock and (": " .. bag.stock) or ""))
    if not allowDead then
        check(bag.dead == nil, "no unrecoverable dead end" .. (bag.dead and (": " .. bag.dead) or ""))
    end
end

------------------------------------------------------------------ scenarios

scenario("H01", "Scene contract: builders + K0.4 runtime start cleanly", nil, function(mode)
    local w = setup(mode)
    for _, r in ipairs(w.builderResults) do
        check(r.finished, "builder finished: " .. r.name)
    end
    local sceneCount = 0
    for _, o in ipairs(w.world.output) do
        local n = string.match(o.line, "BlackstoneBazaar_K0 scene built (%d+) instances")
        if n then sceneCount = tonumber(n) end
    end
    check(sceneCount == 133, "SCENE_BUILD creates 133 instances, as recorded in Studio on 25 Sep (got " .. sceneCount .. ")")
    local p = w:addPlayer("Tester1")
    w.world:advance(3)
    noScriptErrors(w)
    local ready = w:outputMatching("^Baycrest K0 market server ready")
    check(#ready == 1, "exactly one ready line (got " .. #ready .. ")")
    check(#ready == 1 and string.find(ready[1].line, CONFIG.Version, 1, true) ~= nil, "ready line carries " .. CONFIG.Version)
    check(#w:outputMatching("Baycrest K0 server ready") == 0, "legacy ready line absent")
    local waits = w:pendingWaits()
    check(#waits == 0, "no pending WaitForChild" .. (#waits > 0 and (": " .. table.concat(waits, "; ")) or ""))
    noUnexpectedWarnings(w)
    check(attr(p, "K0Owner") == true and attr(p, "K0Cash") == C.StartingCash, "first player owns the session with starting cash")
    check(w:hud(p) ~= nil, "HUD ScreenGui created in PlayerGui")
    local h = handles(w)
    check(h.claim.Enabled and not h.permit.Enabled and not h.orange.Enabled and not h.sale.Enabled,
        "only the claim prompt is enabled before ownership")
    check(h.sign.Text == "TEZGÂHI SAHİPLEN", "sign invites the claim")
end)

scenario("H02", "Builders and migration are idempotent", {"Deferred"}, function(mode)
    local w = setup(mode)
    local before = #w:scene():GetDescendants()
    for _, name in ipairs(K0World.BUILD_ORDER) do w:runBuilder(name) end
    local after = #w:scene():GetDescendants()
    check(before == after, string.format("re-running all builders leaves the scene unchanged (%d -> %d)", before, after))
    w:runBuilder("K0_MARKET_V3_MIGRATION")
    local once = #w:scene():GetDescendants()
    w:runBuilder("K0_MARKET_V3_MIGRATION")
    local twice = #w:scene():GetDescendants()
    check(once == twice, string.format("migration is idempotent (%d -> %d)", once, twice))
    noScriptErrors(w)
    -- A second SurfaceGui on the same face of the same part renders two text
    -- layers on top of each other.
    local board = w:scene().MarketSystem.DemandBoard
    local faces = {}
    for _, g in ipairs(board:GetChildren()) do
        if g:IsA("SurfaceGui") then faces[g.Face.Name] = (faces[g.Face.Name] or 0) + 1 end
    end
    check((faces.Front or 0) <= 1 and (faces.Back or 0) <= 1,
        string.format("DemandBoard has one SurfaceGui per face after migration (Front=%d Back=%d)", faces.Front or 0, faces.Back or 0))
end)

scenario("H03", "Legacy runtime is disabled by migration or loudly reported", {"Deferred"}, function(mode)
    local w = K0World.new({signalMode = mode})
    w:buildScene()
    w:installLegacy()
    w:runBuilder("K0_MARKET_V3_MIGRATION")
    local legacy = w.game:GetService("ServerScriptService"):FindFirstChild("K0Game")
    local legacyHud = w.game:GetService("StarterPlayer").StarterPlayerScripts:FindFirstChild("K0HUD")
    check(legacy and legacy.Disabled, "migration disables ServerScriptService/K0Game")
    check(legacyHud and legacyHud.Disabled, "migration disables StarterPlayerScripts/K0HUD")
    w:installRuntime()
    w:startServer()
    w:addPlayer("Tester1")
    w.world:advance(2)
    noScriptErrors(w)
    local warned = false
    for _, x in ipairs(w.world.warnings) do if string.find(x.message, "Legacy ServerScriptService/K0Game") then warned = true end end
    check(not warned, "no legacy warning once migrated")

    -- Without the migration the runtime must warn instead of pretending.
    local w2 = K0World.new({signalMode = mode})
    w2:buildScene()
    w2:installLegacy()
    local legacyServer = w2.game:GetService("ServerScriptService"):FindFirstChild("K0Game")
    w2:installRuntime()
    -- Start only K0Market: the point is the warning, not running two runtimes.
    legacyServer.Enabled = false
    w2.world.internals[legacyServer].props.Enabled = true -- restore "enabled" without firing
    local serverScript = w2.serverScript
    w2.world.defaultContext = w2.serverContext
    w2.world:runChunk(w2.world.internals[serverScript].source, "K0Market", serverScript, w2.serverContext)
    w2.world:advance(1)
    local warned2 = false
    for _, x in ipairs(w2.world.warnings) do if string.find(x.message, "Legacy ServerScriptService/K0Game is still enabled") then warned2 = true end end
    check(warned2, "runtime warns when legacy K0Game is still enabled")
end)

scenario("H04", "Test-plan stage 1 smoke flow through prompts and HUD", nil, function(mode)
    local w = setup(mode)
    local p = w:addPlayer("Tester1")
    local h = handles(w)
    local world = w.world

    -- 1 claim
    check(go(w, p, h.claim), "1 claim prompt triggers")
    world:advance(0.5)
    check(attr(p, "K0Claimed") == true and attr(p, "K0Cash") == C.StartingCash, "1 claimed, cash unchanged " .. C.StartingCash)
    check(string.find(h.sign.Text, "TESTER1", 1, true) ~= nil, "1 sign shows the owner: " .. h.sign.Text)
    -- 2 permit
    check(go(w, p, h.permit), "2 permit prompt triggers")
    world:advance(0.5)
    check(attr(p, "K0Permit") == true and attr(p, "K0Cash") == C.StartingCash - C.PermitFee, "2 registration active, cash " .. (C.StartingCash - C.PermitFee))
    -- 3 demand board
    local demand = attr(p, "K0DemandSKU")
    local boardText
    for _, g in ipairs(w:scene().MarketSystem.DemandBoard:GetChildren()) do
        if g:IsA("SurfaceGui") and g:FindFirstChild("Detail") then boardText = g.Detail.Text end
    end
    check(boardText and string.find(boardText, string.upper(C.Products[demand].Name), 1, true) and string.find(boardText, "+15%", 1, true),
        "3 demand board names the demanded product and +15%: " .. tostring(boardText))
    -- 4 restock the demanded product
    local cashBefore = attr(p, "K0Cash")
    check(go(w, p, h[demand]), "4 wholesale prompt triggers (ActionText=" .. h[demand].ActionText .. ")")
    world:advance(0.5)
    local bundle = C.Products[demand].WholesaleBundle
    check(stockOf(p, demand) == bundle and attr(p, "K0Cash") == cashBefore - C.Products[demand].WholesaleCost,
        "4 bought one bundle: stock " .. stockOf(p, demand) .. ", cash " .. attr(p, "K0Cash"))
    local display = w:scene().ProductDisplays[demand == "orange" and "OrangeFront" or "BreadFront"]
    local shown = 0
    for _, u in ipairs(display:GetChildren()) do if u.Transparency == 0 then shown += 1 end end
    check(shown == bundle, "4 shelf shows " .. bundle .. " units (shown " .. shown .. ")")
    -- 5 customer arrives
    local came = world:runUntil(function() return attr(p, "K0CustomerReady") == true end, 120)
    check(came, "5 a buying customer arrives within 120 s")
    local visitor
    for _, c in ipairs(w:scene():GetChildren()) do if string.match(c.Name, "^Visitor_") then visitor = c end end
    check(visitor ~= nil and visitor.Head:FindFirstChild("Talk") ~= nil, "5 visitor NPC stands at the stall with a speech bubble")
    check(h.sale.Enabled and h.sale.ObjectText ~= "Tezgâh", "5 sale prompt advertises the order: " .. h.sale.ObjectText)
    -- 6-8 answer offers through the HUD until one normal sale and one counter happened
    local sawCounter, sawSale = false, false
    local guard = 0
    while (not sawCounter or not sawSale) and guard < 40 do
        guard += 1
        if not world:runUntil(function() return attr(p, "K0CustomerReady") == true end, 120) then break end
        if stockOf(p, attr(p, "K0OfferSKU")) < attr(p, "K0OfferUnits") then
            go(w, p, h[attr(p, "K0OfferSKU")])
        end
        local kind, signal, counterPrice = attr(p, "K0OfferType"), attr(p, "K0OfferSignal"), attr(p, "K0OfferCounter")
        local salesBefore, cashB = attr(p, "K0Sales"), attr(p, "K0Cash")
        local _, offer = hudParts(w, p)
        local ok = answerOffer(w, p, h, function(pp)
            if attr(pp, "K0OfferType") == "Bargainer" then return "counter" end
            return "accept"
        end)
        if kind == "Bargainer" and ok then
            sawCounter = true
            local sold = attr(p, "K0Sales") > salesBefore
            local ask = attr(p, "K0OfferAsk")
            if signal == "SIKI" then
                note("counter vs SIKI: " .. (sold and "accepted" or "refused"))
            else
                check(sold, "8 counter-offer accepted for budget signal " .. signal)
            end
            if sold then check(attr(p, "K0Cash") == cashB + counterPrice, "8 counter price paid: +" .. counterPrice) end
        elseif ok and attr(p, "K0Sales") > salesBefore then
            sawSale = true
            check(not offer.Visible, "7 offer card closes after the sale")
        end
        if stockOf(p, demand) == 0 then go(w, p, h[demand]) end
    end
    check(sawSale, "7 normal buyer sale through the HUD")
    check(sawCounter, "8 at least one bargainer answered with a counter-offer")
    -- 9 grow to 250 and upgrade
    local bag = playFor(w, p, h, 900, {hire = false, upgrade = false})
    local reached = world:runUntil(function() return attr(p, "K0Cash") >= C.UpgradeCost end, 1)
    check(reached, "9 accumulated " .. C.UpgradeCost .. " ₡ (cash " .. attr(p, "K0Cash") .. ")")
    local cashU = attr(p, "K0Cash")
    check(go(w, p, h.upgrade), "9 upgrade prompt triggers")
    world:advance(0.5)
    check(attr(p, "K0Level") == 2 and attr(p, "K0Cash") == cashU - C.UpgradeCost, "9 level 2 bought for " .. C.UpgradeCost)
    local hidden = 0
    for _, d in ipairs(w:scene().Stall_01.Level2Shelf:GetDescendants()) do
        if d:IsA("BasePart") and d.Transparency ~= 0 then hidden += 1 end
    end
    check(hidden == 0, "9 every level-2 part is visible (" .. hidden .. " still hidden)")
    -- 10 hire
    world:runUntil(function() return attr(p, "K0Cash") >= C.HireCost end, 300)
    playFor(w, p, h, 0, {})
    local cashH = attr(p, "K0Cash")
    check(go(w, p, h.hire), "10 hire prompt triggers")
    world:advance(0.5)
    check(attr(p, "K0Hired") == true and attr(p, "K0Cash") == cashH - C.HireCost, "10 cashier hired for " .. C.HireCost)
    check(w:scene():FindFirstChild("Worker_K0") ~= nil, "10 cashier NPC appears")
    -- 11 shift ends
    playFor(w, p, h, C.ShiftSeconds + 5, {hire = false, upgrade = false}, bag)
    -- The bot pays automatically; confirm that a payday happened.
    check((attr(p, "K0WagePayments") or 0) >= 1, "11-12 wages fell due and were paid (" .. tostring(attr(p, "K0WagePayments")) .. ")")
    reportBag(bag)
    noScriptErrors(w)
    noUnexpectedWarnings(w)
end)

scenario("H05", "B1: partial restock tops up a part-empty shelf", nil, function(mode)
    local w = setup(mode)
    local p = w:addPlayer("Tester1")
    local h = handles(w)
    go(w, p, h.claim)
    go(w, p, h.permit)
    go(w, p, h.orange)
    go(w, p, h.bread)
    local tested = 0
    local guard = 0
    while tested < 3 and guard < 60 do
        guard += 1
        if not w.world:runUntil(function() return attr(p, "K0CustomerReady") == true end, 120) then break end
        answerOffer(w, p, h, defaultDecision)
        for _, sku in ipairs({"orange", "bread"}) do
            local s, cap = stockOf(p, sku), capOf(p, sku)
            if s > 0 and s < cap then
                local cash = attr(p, "K0Cash")
                local expectUnits = math.min(cap - s, cash // unitCost(sku))
                go(w, p, h[sku])
                w.world:advance(0.2)
                check(stockOf(p, sku) == s + expectUnits and attr(p, "K0Cash") == cash - expectUnits * unitCost(sku),
                    string.format("%s %d/%d topped up by %d for %d ₡ (now %d, cash %d)", sku, s, cap, expectUnits,
                        expectUnits * unitCost(sku), stockOf(p, sku), attr(p, "K0Cash")))
                tested += 1
            end
        end
    end
    check(tested >= 3, "exercised partial restock at least 3 times (" .. tested .. ")")
    local notice = attr(p, "K0Notice") or ""
    noScriptErrors(w)
end)

local function lapse(w, p)
    return w.world:runUntil(function() return attr(p, "K0RentDue") == true end, C.PermitPeriodSeconds + 30)
end

scenario("H06", "B2: lapsed registration -> liquidation -> renewal", nil, function(mode)
    local w = setup(mode, {configPatch = patchNumber("PermitPeriodSeconds", 90)})
    local p = w:addPlayer("Tester1")
    local h = handles(w)
    go(w, p, h.claim)
    go(w, p, h.permit)
    go(w, p, h.orange)
    go(w, p, h.bread)
    check(attr(p, "K0Cash") == C.StartingCash - C.PermitFee - 96, "cash drawn below the fee while holding stock: " .. attr(p, "K0Cash"))
    -- Ignore customers so the stock is still there at lapse.
    check(lapse(w, p), "registration lapses after the patched 90 s")
    w.world:advance(1)
    check(not h.sale.Enabled, "sale prompt closed while lapsed")
    check(h.orange.Enabled and h.orange.ActionText == "Tasfiye et", "orange desk switches to liquidation: " .. h.orange.ActionText .. " / enabled=" .. tostring(h.orange.Enabled))
    check(h.bread.Enabled and h.bread.ActionText == "Tasfiye et", "bread desk switches to liquidation")
    check(h.permit.Enabled, "permit prompt open for renewal")
    local cash0, stock0 = attr(p, "K0Cash"), stockOf(p, "orange")
    go(w, p, h.orange)
    w.world:advance(0.3)
    local ratio = C.LiquidationRatio
    local per = math.floor(C.Products.orange.Retail * ratio + 0.5)
    check(attr(p, "K0Cash") == cash0 + per and stockOf(p, "orange") == stock0 - 1, "one orange liquidated for " .. per .. " ₡")
    check(string.find(attr(p, "K0Notice") or "", "Tasfiye", 1, true) ~= nil, "liquidation notice shown")
    local guard = 0
    while attr(p, "K0Cash") < C.PermitFee and guard < 30 do
        guard += 1
        local sku = stockOf(p, "orange") > 0 and "orange" or "bread"
        go(w, p, h[sku])
        w.world:advance(0.3)
    end
    check(attr(p, "K0Cash") >= C.PermitFee, "liquidation raised the fee: " .. attr(p, "K0Cash"))
    go(w, p, h.permit)
    w.world:advance(0.5)
    check(attr(p, "K0RentDue") == false and attr(p, "K0PermitRenewals") == 1, "registration renewed from liquidation proceeds")
    check(h.orange.ActionText == "Stok al", "desks return to buying after renewal")
    local ok = ledgerHolds(p)
    check(ok, "ledger still balances after liquidation")
    noScriptErrors(w)
end)

scenario("H07", "Rescue: after the one-time rescue the player can trade again", nil, function(mode)
    -- Liquidation pays 50% of the label, which is above the wholesale unit cost, so
    -- a standard opening never needs the rescue. A lower starting purse reaches the
    -- only state the rescue exists for: registration lapsed, shelf liquidated,
    -- cash still below the fee.
    local start = C.PermitFee + C.Products.orange.WholesaleCost + 2
    local w = setup(mode, {configPatch = patches(patchNumber("PermitPeriodSeconds", 90), patchNumber("StartingCash", start))})
    local p = w:addPlayer("Tester1")
    local h = handles(w)
    go(w, p, h.claim)
    go(w, p, h.permit)
    go(w, p, h.orange)
    check(attr(p, "K0Cash") == 2 and stockOf(p, "orange") == C.Products.orange.WholesaleBundle, "opening: 2 ₡ cash, one orange bundle")
    check(lapse(w, p), "registration lapses")
    w.world:advance(1)
    local guard = 0
    while stockOf(p, "orange") + stockOf(p, "bread") > 0 and guard < 40 do
        guard += 1
        go(w, p, h[stockOf(p, "orange") > 0 and "orange" or "bread"])
        w.world:advance(0.3)
    end
    local cash = attr(p, "K0Cash")
    note("cash after full liquidation: " .. cash)
    check(cash < C.PermitFee, "liquidation alone does not cover the fee (" .. cash .. " < " .. C.PermitFee .. ")")
    go(w, p, h.permit)
    w.world:advance(0.5)
    check(attr(p, "K0RescueGrants") == 1, "rescue granted once")
    check(#w:outputMatching("rescue_grant") == 1, "rescue_grant written to Output")
    check(attr(p, "K0RentDue") == false, "registration active after rescue")
    -- The point of the rescue: the player must be able to act and earn again.
    check(attr(p, "K0Cash") >= MIN_UNIT, "after the rescue the player can still buy at least one unit (cash "
        .. attr(p, "K0Cash") .. ", cheapest unit " .. MIN_UNIT .. ")")
    local bag = playFor(w, p, h, 200, {upgrade = false, hire = false, renew = false})
    check((attr(p, "K0Sales") or 0) > 0, "a sale happens after the rescue (sales " .. attr(p, "K0Sales") .. ")")
    check(bag.dead == nil or attr(p, "K0RentDue"), "no dead end right after the rescue" .. (bag.dead and (": " .. bag.dead) or ""))
    -- The rescue is bounded: once spent, a stranded renewal is refused and the
    -- dead end is reported instead of passing silently.
    lapse(w, p)
    w.world:advance(1)
    guard = 0
    while stockOf(p, "orange") + stockOf(p, "bread") > 0 and guard < 60 do
        guard += 1
        go(w, p, h[stockOf(p, "orange") > 0 and "orange" or "bread"])
        w.world:advance(0.3)
    end
    if attr(p, "K0Cash") < C.PermitFee + MIN_UNIT then
        go(w, p, h.permit)
        w.world:advance(0.5)
        check(attr(p, "K0RescueGrants") == 1 and attr(p, "K0RentDue") == true, "second rescue refused (limit " .. C.RescueGrantLimit .. ")")
        check(#w:outputMatching("dead_end") == 1, "dead end written to Output once")
    else
        note("second lapse had enough cash (" .. attr(p, "K0Cash") .. "); limit not exercised")
    end
    noScriptErrors(w)
end)

scenario("H08", "Decision remote: validation and rate limit", nil, function(mode)
    local w = setup(mode)
    local p = w:addPlayer("Tester1")
    local h = handles(w)
    go(w, p, h.claim)
    go(w, p, h.permit)
    go(w, p, h.orange)
    go(w, p, h.bread)
    check(w.world:runUntil(function() return attr(p, "K0CustomerReady") == true end, 120), "customer arrived")
    go(w, p, h.sale)
    w.world:advance(0.5)
    local id = attr(p, "K0OfferId")
    local sales = attr(p, "K0Sales")
    -- Junk that must be ignored without script errors.
    w:fireDecision(p, 0 / 0, "accept")
    w:fireDecision(p, id + 0.5, "accept")
    w:fireDecision(p, tostring(id), "accept")
    w:fireDecision(p, id, "steal")
    w:fireDecision(p, id, nil)
    w:fireDecision(p)
    check(attr(p, "K0Sales") == sales, "malformed decisions change nothing")
    noScriptErrors(w)
    -- Six calls have been spent inside the 3 s window: a valid accept is now dropped.
    w:fireDecision(p, id, "accept")
    check(attr(p, "K0Sales") == sales, "7th call inside the window is rate limited")
    w.world:advance(C.DecisionRateWindow + 0.1)
    if attr(p, "K0CustomerReady") and attr(p, "K0OfferId") == id then
        if attr(p, "K0OfferType") ~= "Bargainer" then
            w:fireDecision(p, id, "counter")
            check(attr(p, "K0Sales") == sales and attr(p, "K0CounterCount") == 0, "counter on a normal buyer is rejected")
        end
        w:fireDecision(p, id, "accept")
        local enough = stockOf(p, attr(p, "K0OfferSKU") or "orange") >= 0
        check(attr(p, "K0Sales") == sales + 1 or not enough, "valid accept after the window is served")
    else
        note("customer left before the window reopened")
    end
    -- Out of range: walk away and try again on the next offer.
    noScriptErrors(w)
end)

scenario("H09", "Owner handover when the owner leaves", nil, function(mode)
    local w = setup(mode)
    local p1 = w:addPlayer("Owner1")
    local p2 = w:addPlayer("Watcher2")
    local h = handles(w)
    check(attr(p1, "K0Owner") == true and attr(p2, "K0Owner") == false, "second player is a spectator")
    local hud2 = w:hud(p2)
    check(hud2 and hud2.Status.Ownership.Text == "Bu oturumda izleyicisin", "spectator HUD explains the single-seller test")
    go(w, p1, h.claim)
    go(w, p1, h.permit)
    go(w, p1, h.orange)
    w.world:runUntil(function() return attr(p1, "K0CustomerReady") == true end, 120)
    -- Spectator cannot act.
    local ok = go(w, p2, h.sale)
    w.world:advance(0.3)
    check(attr(p2, "K0OfferOpen") == nil or attr(p2, "K0OfferOpen") == false, "spectator cannot open the offer")
    w:removePlayer(p1)
    w.world:advance(1)
    check(#w:outputMatching("summary reason=owner_left") == 1, "summary printed when the owner leaves")
    check(attr(p2, "K0Owner") == true and attr(p2, "K0Cash") == C.StartingCash and attr(p2, "K0Claimed") == false,
        "next player becomes owner with a fresh session")
    local leftovers = 0
    for _, c in ipairs(w:scene():GetChildren()) do
        if string.match(c.Name, "^Visitor_") or c.Name == "Worker_K0" then leftovers += 1 end
    end
    check(leftovers == 0, "previous owner's NPCs are cleaned up")
    check(h.claim.Enabled and h.sign.Text == "TEZGÂHI SAHİPLEN", "stall is claimable again")
    local hud = w:hud(p2)
    w.world:advance(1)
    check(hud.Status.Ownership.Text == "Sahiplik: henüz yok", "new owner's HUD leaves spectator mode: " .. hud.Status.Ownership.Text)
    go(w, p2, h.claim)
    go(w, p2, h.permit)
    go(w, p2, h.bread)
    check(w.world:runUntil(function() return attr(p2, "K0CustomerReady") == true end, 120), "new owner receives customers")
    noScriptErrors(w)
end)

local function customerSequence(mode, delays, decide, count)
    local w = setup(mode)
    local p = w:addPlayer("Tester1")
    local h = handles(w)
    local seq = {}
    local scene = w:scene()
    scene.ChildAdded:Connect(function(child)
        if string.match(child.Name, "^PassingVisitor_") then table.insert(seq, "P")
        elseif string.match(child.Name, "^Visitor_") then table.insert(seq, "?") end
    end)
    p:GetAttributeChangedSignal("K0Browsers"):Connect(function() seq[#seq] = "Br" end)
    p:GetAttributeChangedSignal("K0OfferId"):Connect(function()
        if (attr(p, "K0OfferId") or 0) > 0 then
            seq[#seq] = attr(p, "K0OfferType") == "Bargainer" and ("Bg:" .. attr(p, "K0OfferSignal")) or "Buy"
        end
    end)
    w.world:advance(delays[1]); go(w, p, h.claim)
    w.world:advance(delays[2]); go(w, p, h.permit)
    w.world:advance(delays[3]); go(w, p, h.orange); go(w, p, h.bread)
    local guard = 0
    while #seq < count and guard < 2000 do
        guard += 1
        botStep(w, p, h, {decide = decide, upgrade = false, hire = false})
    end
    return seq, w
end

scenario("H10", "Seeded comparability: tester speed does not shift the customer sequence", {"Deferred"}, function(mode)
    local fastSeq, w1 = customerSequence(mode, {2, 2, 2}, defaultDecision, 30)
    local slowSeq, w2 = customerSequence(mode, {70, 90, 60}, function() return "decline" end, 30)
    local same = #fastSeq >= 30 and #slowSeq >= 30
    local firstDiff
    for i = 1, math.min(#fastSeq, #slowSeq, 30) do
        if fastSeq[i] ~= slowSeq[i] then same = false firstDiff = firstDiff or i end
    end
    check(same, "first 30 customers identical in kind and budget signal" ..
        (firstDiff and string.format(" (first difference at #%d: %s vs %s)", firstDiff, fastSeq[firstDiff], slowSeq[firstDiff]) or ""))
    note("sequence: " .. table.concat(fastSeq, " ", 1, math.min(#fastSeq, 30)))
    noScriptErrors(w1)
    noScriptErrors(w2)
end)

scenario("H11", "20-minute balanced session: summary, milestones, invariants", nil, function(mode)
    local w = setup(mode)
    local p = w:addPlayer("Tester1")
    local h = handles(w)
    local bag = playFor(w, p, h, C.TargetSessionSeconds + 10, {})
    local summary = w:outputMatching("summary reason=target_20m")
    check(#summary == 1, "one target_20m summary line")
    if summary[1] then note(summary[1].line) end
    for _, m in ipairs({"K0FirstClaimSeconds", "K0FirstStockSeconds", "K0FirstOfferSeconds", "K0FirstDecisionSeconds",
        "K0FirstSaleSeconds"}) do
        check((attr(p, m) or -1) >= 0, "milestone recorded: " .. m .. "=" .. tostring(attr(p, m)))
    end
    -- Investment milestones are decisions, not guarantees: they must match state.
    check(((attr(p, "K0FirstUpgradeSeconds") or -1) >= 0) == (attr(p, "K0Level") >= 2), "upgrade milestone matches level")
    check(((attr(p, "K0FirstHireSeconds") or -1) >= 0) == (attr(p, "K0Hired") == true), "hire milestone matches cashier state")
    note(string.format("milestones: stock=%d sale=%d upgrade=%d hire=%d", attr(p, "K0FirstStockSeconds"),
        attr(p, "K0FirstSaleSeconds"), attr(p, "K0FirstUpgradeSeconds"), attr(p, "K0FirstHireSeconds")))
    check(attr(p, "K0SessionTargetReached") == true, "K0SessionTargetReached set")
    check((attr(p, "K0RescueGrants") or 0) == 0 and (attr(p, "K0Liquidations") or 0) == 0, "no rescue or liquidation inside the 20-minute gate")
    reportBag(bag)
    note(string.format("sales=%d revenue=%d result=%d lost=%d level=%d hired=%s", attr(p, "K0Sales"), attr(p, "K0Revenue"),
        attr(p, "K0OperatingResult"), attr(p, "K0LostSales"), attr(p, "K0Level"), tostring(attr(p, "K0Hired"))))
    note(string.format("server attribute writes=%d, part property writes=%d over %.0f s",
        w.world.attrWrites or 0, w.world.propWrites, w.world.now))
    check(attr(p, "K0DeadEndSeconds") == -1, "no dead end in the balanced session (K0DeadEndSeconds="
        .. tostring(attr(p, "K0DeadEndSeconds")) .. ")")
    -- Stopping the Studio test must still leave a final summary line, once.
    local cash = attr(p, "K0Cash")
    w.world:close()
    w.world:close()
    local closing = w:outputMatching("summary reason=server_close")
    check(#closing == 1, "server_close summary printed exactly once (" .. #closing .. ")")
    check(closing[1] ~= nil and string.find(closing[1].line, "deadEnd=-1 cash=" .. tostring(cash), 1, true) ~= nil,
        "final summary ends with deadEnd and the current cash")
    noScriptErrors(w)
    noUnexpectedWarnings(w)
end)

local VIEWPORTS = {
    {name = "PC 1280x720", x = 1280, y = 720},
    {name = "phone landscape 740x360", x = 740, y = 360},
    {name = "narrow phone 568x320", x = 568, y = 320},
}

scenario("H12", "HUD layout: offer card states and estimated text fit", {"Deferred"}, function(mode)
    local w = setup(mode)
    local p = w:addPlayer("Tester1")
    local h = handles(w)
    local gui = w:hud(p)
    go(w, p, h.claim)
    go(w, p, h.permit)
    go(w, p, h.orange)
    go(w, p, h.bread)
    local sawBargainer, sawBuyer = false, false
    local guard = 0
    local risks = {}
    local function scanFit(label)
        for _, vp in ipairs(VIEWPORTS) do
            w.world:setViewport(vp.x, vp.y)
            w.world:advance(0.1)
            for _, r in ipairs(w:textFitRisks(gui)) do
                local key = vp.name .. "/" .. r.name
                if not risks[key] then
                    risks[key] = string.format("%s · %s: ~%d lines need %.0f px, box %.0f px (\"%s\")", vp.name, r.name, r.lines, r.needPx, r.havePx, r.text)
                end
            end
            local minSize, who = w:minTextSize(gui)
            if vp.name == "narrow phone 568x320" then
                CURRENT.minText = math.min(CURRENT.minText or math.huge, minSize)
                CURRENT.minTextWho = CURRENT.minText == minSize and who or CURRENT.minTextWho
            end
        end
        w.world:setViewport(1280, 720)
        w.world:advance(0.1)
    end
    scanFit("idle")
    while (not sawBargainer or not sawBuyer) and guard < 30 do
        guard += 1
        if not w.world:runUntil(function() return attr(p, "K0CustomerReady") == true end, 120) then break end
        go(w, p, h.sale)
        w.world:advance(0.5)
        local offer = gui.Offer
        check(offer.Visible, "offer card visible after opening")
        local kind = attr(p, "K0OfferType")
        if kind == "Bargainer" then
            sawBargainer = true
            check(offer.Counter.Visible, "counter button visible for a bargainer")
            check(string.find(offer.OfferSignal.Text, attr(p, "K0OfferSignal"), 1, true) ~= nil, "budget signal shown: " .. offer.OfferSignal.Text)
        else
            sawBuyer = true
            check(not offer.Counter.Visible, "counter button hidden for a normal buyer")
        end
        -- Narrow layout: buttons stacked and tall enough to tap.
        w.world:setViewport(568, 320)
        w.world:advance(0.1)
        local bw, bh = w:absSize(offer.Accept)
        local scale = w:uiScale(offer.Accept)
        CURRENT.tapPx = math.min(CURRENT.tapPx or math.huge, bh * scale)
        check(offer.Counter.Position.Y.Offset > offer.Accept.Position.Y.Offset, "narrow layout stacks the buttons vertically")
        w.world:setViewport(1280, 720)
        w.world:advance(0.1)
        scanFit("offer")
        answerOffer(w, p, h, defaultDecision)
        w.world:advance(0.5)
        check(not offer.Visible, "offer card closes after answering")
    end
    check(sawBargainer and sawBuyer, "both offer kinds rendered")
    local list = {}
    for _, v in pairs(risks) do table.insert(list, v) end
    table.sort(list)
    check(#list == 0, "no HUD label is estimated to overflow its box" .. (#list > 0 and (":\n      - " .. table.concat(list, "\n      - ")) or ""))
    note(string.format("narrow phone: smallest effective text %.1f px (%s); tap target height %.0f px (estimate, before device test)",
        CURRENT.minText or -1, tostring(CURRENT.minTextWho), CURRENT.tapPx or -1))
    noScriptErrors(w)
end)

scenario("H13", "Monkey session: random prompts and remote junk for 40 minutes", nil, function(mode)
    local w = setup(mode)
    local p = w:addPlayer("Tester1")
    local h = handles(w)
    local rng = w.world.Random.new(4242)
    local prompts = {h.claim, h.permit, h.orange, h.bread, h.sale, h.upgrade, h.hire, h.pay}
    local bag = {}
    local stop = w.world.now + 2400
    local junk = {0 / 0, -1, 1.5, "x", true, 1e308}
    while w.world.now < stop do
        local r = rng:NextNumber()
        if r < 0.45 then
            botStep(w, p, h, {})
        elseif r < 0.8 then
            local pr = prompts[rng:NextInteger(1, #prompts)]
            go(w, p, pr)
        elseif r < 0.9 then
            w:fireDecision(p, junk[rng:NextInteger(1, #junk)], ({"accept", "counter", "decline", "x"})[rng:NextInteger(1, 4)])
        else
            w.world:advance(rng:NextNumber() * 8)
        end
        checkInvariants(w, p, bag)
        if #w.world.errors > 0 then break end
    end
    reportBag(bag, true)
    if bag.dead then note("dead end reached by random play: " .. bag.dead) end
    note(string.format("sales=%d cash=%d level=%d renewals=%d liquidations=%d rescues=%d", attr(p, "K0Sales"), attr(p, "K0Cash"),
        attr(p, "K0Level"), attr(p, "K0PermitRenewals"), attr(p, "K0Liquidations"), attr(p, "K0RescueGrants")))
    noScriptErrors(w)
end)

-- Each case starts with a purse sized so one more payment would leave an empty
-- shelf and less than one unit's cash: the only state with no way back.
local function strandSetup(mode, extra, more)
    local list = {patchNumber("StartingCash", extra + MIN_UNIT - 1)}
    for _, f in ipairs(more or {}) do table.insert(list, f) end
    local w = setup(mode, {configPatch = patches(table.unpack(list))})
    local p = w:addPlayer("Tester1")
    return w, p, handles(w)
end

local function stranded(p)
    return stockOf(p, "orange") + stockOf(p, "bread") == 0 and attr(p, "K0Cash") < MIN_UNIT
end

scenario("H14", "Spending cannot strand the player with no stock and no cash", nil, function(mode)
    -- Upgrade with an empty shelf.
    local w, p, h = strandSetup(mode, C.PermitFee + C.UpgradeCost)
    go(w, p, h.claim)
    go(w, p, h.permit)
    go(w, p, h.upgrade)
    w.world:advance(0.3)
    check(not stranded(p), "upgrade refused when it would strand (cash " .. attr(p, "K0Cash") .. ", level " .. attr(p, "K0Level") .. ")")
    check(go(w, p, h.orange) and stockOf(p, "orange") > 0, "player can still buy stock after the refusal")
    noScriptErrors(w)

    -- Hire with an empty shelf.
    w, p, h = strandSetup(mode, C.PermitFee + C.UpgradeCost + C.HireCost)
    go(w, p, h.claim)
    go(w, p, h.permit)
    go(w, p, h.upgrade)
    check(attr(p, "K0Level") == 2, "upgrade allowed while enough cash remains")
    go(w, p, h.hire)
    w.world:advance(0.3)
    check(not stranded(p), "hire refused when it would strand (cash " .. attr(p, "K0Cash") .. ", hired " .. tostring(attr(p, "K0Hired")) .. ")")
    noScriptErrors(w)

    -- Wage with an empty shelf.
    w, p, h = strandSetup(mode, C.PermitFee + C.UpgradeCost + C.HireCost + C.WagePerShift, {patchNumber("ShiftSeconds", 20)})
    go(w, p, h.claim)
    go(w, p, h.permit)
    go(w, p, h.upgrade)
    go(w, p, h.hire)
    check(attr(p, "K0Hired") == true, "hire allowed while enough cash remains")
    check(w.world:runUntil(function() return attr(p, "K0WagesDue") == true end, 40), "payday arrives")
    go(w, p, h.pay)
    w.world:advance(0.3)
    check(not stranded(p), "wage refused when it would strand (cash " .. attr(p, "K0Cash") .. ")")
    check(go(w, p, h.orange) and stockOf(p, "orange") > 0, "player buys stock instead, then pays from sales")
    noScriptErrors(w)

    -- Renewal with an empty shelf: the rescue covers it instead of stranding.
    w, p, h = strandSetup(mode, 2 * C.PermitFee, {patchNumber("PermitPeriodSeconds", 30)})
    go(w, p, h.claim)
    go(w, p, h.permit)
    check(lapse(w, p), "registration lapses with an empty shelf")
    go(w, p, h.permit)
    w.world:advance(0.3)
    check(not stranded(p) and attr(p, "K0RentDue") == false,
        "renewal keeps enough cash to restart (cash " .. attr(p, "K0Cash") .. ", due " .. tostring(attr(p, "K0RentDue")) .. ")")
    check(go(w, p, h.orange) and stockOf(p, "orange") > 0, "player can trade after the renewal")
    noScriptErrors(w)
end)

scenario("H15", "Every notice, help and goal text seen fits its HUD box (estimate)", {"Deferred"}, function(mode)
    local count = 0
    for _ in pairs(SEEN_TEXT.notice) do count += 1 end
    if count < 10 then
        -- Run alone: produce a representative set first.
        local w = setup(mode)
        local p = w:addPlayer("Tester1")
        playFor(w, p, handles(w), 900, {})
    end
    -- Box sizes come from the HUD source at scale 1; UIScale shrinks the box and
    -- the text together, so the line count does not change with the viewport.
    local boxes = {
        notice = {width = 510 - 28, height = 76, size = 15, what = "Notice"},
        help = {width = 620 - 28, height = 60, size = 15, what = "Help"},
        goal = {width = 410 - 28, height = 52, size = 14, what = "Goal"},
    }
    local bad, total, longest = {}, 0, 0
    for kind, box in pairs(boxes) do
        for text in pairs(SEEN_TEXT[kind]) do
            total += 1
            longest = math.max(longest, utf8.len(text) or #text)
            local lines = K0World.estimateLines(text, box.size, box.width)
            if lines * box.size * 1.2 > box.height + 0.5 then
                table.insert(bad, string.format("%s ~%d lines, %d px box: %s", box.what, lines, box.height, text))
            end
        end
    end
    table.sort(bad)
    note(string.format("%d distinct texts checked; longest %d characters", total, longest))
    check(#bad == 0, "no text is estimated to overflow" .. (#bad > 0 and (":\n      - " .. table.concat(bad, "\n      - ")) or ""))
end)

-- Measurement, not a gate: does reading the demand board pay in the real
-- runtime? Same seeds, one bot restocks only the demanded product, the other
-- only the other product. The design question it informs is recorded in
-- PRODUCTION/K0.4.1_IMPLEMENTATION_REPORT.md.
scenario("H16", "Measurement: value of following the demand board (real runtime, 12 seeds)", {"Deferred"}, function(mode)
    local diffs, wins, salesA, salesB = {}, 0, 0, 0
    for i = 1, 12 do
        local seed = 5000 + i * 37
        local results = {}
        for _, only in ipairs({"demand", "anti"}) do
            local w = setup(mode, {configPatch = patchNumber("PlaytestSeed", seed)})
            local p = w:addPlayer("Tester1")
            local bag = playFor(w, p, handles(w), C.TargetSessionSeconds, {stockOnly = only, upgrade = false, hire = false})
            check(bag.dead == nil and bag.ledger == nil, "seed " .. seed .. " " .. only .. ": invariants hold")
            results[only] = {result = attr(p, "K0OperatingResult"), sales = attr(p, "K0Sales")}
        end
        local d = results.demand.result - results.anti.result
        table.insert(diffs, d)
        if d > 0 then wins += 1 end
        salesA += results.demand.sales
        salesB += results.anti.sales
    end
    local sum = 0
    for _, d in ipairs(diffs) do sum += d end
    table.sort(diffs)
    note(string.format("demand-only minus other-only operating result over 20 min: mean %+.1f ₡, median %+.1f ₡, demand wins %d/12; sales %.1f vs %.1f",
        sum / #diffs, (diffs[6] + diffs[7]) / 2, wins, salesA / 12, salesB / 12))
end)

scenario("H17", "Cloud smoke task script (TOOLS/place_build/cloud_smoke.luau) runs against this place", {"Deferred", "Immediate"}, function(mode)
    -- Luau Execution: the place is loaded but its Scripts do not start; the task
    -- script runs alone and starts the runtime itself.
    local w = K0World.new({signalMode = mode, echo = OPTIONS.echo})
    w:buildScene()
    w:installRuntime()
    local rec = w.world:runChunk(SOURCES.CLOUD_SMOKE, "cloud_smoke", nil, w.serverContext)
    w.world:advance(5)
    check(rec ~= nil and rec.finished == true, "smoke script finished")
    local report = rec and rec.returned and rec.returned[1]
    check(type(report) == "table" and #report.checks >= 20, "smoke returned its report (" .. (type(report) == "table" and #report.checks or 0) .. " checks)")
    if type(report) == "table" then
        local failedChecks = {}
        for _, c in ipairs(report.checks) do
            if not c.ok then table.insert(failedChecks, c.name .. (c.detail and (" (" .. tostring(c.detail) .. ")") or "")) end
        end
        check(report.pass == true, "smoke reports PASS" .. (#failedChecks > 0 and (": " .. table.concat(failedChecks, "; ")) or ""))
        note(string.format("smoke: %d checks, %d failed", #report.checks, #failedChecks))
    end
    check(#w:outputMatching("^SMOKE RESULT: PASS") == 1, "smoke printed its PASS line")
    noScriptErrors(w)
end)

-- Sound cues (K0.4.2) ---------------------------------------------------------
-- The harness produces no audio; Sound:Play() is recorded with the calling client.
local function plays(w, who, since)
    local list = {}
    for i, r in ipairs(w.world.soundPlays or {}) do
        if i > (since or 0) and (who == nil or r.player == who) then table.insert(list, r) end
    end
    return list
end
local function playMark(w) return #(w.world.soundPlays or {}) end
local function cueName(r) return (string.gsub(r.name, "^K0Sfx_", "")) end
local function cueCounts(list)
    local counts = {}
    for _, r in ipairs(list) do counts[cueName(r)] = (counts[cueName(r)] or 0) + 1 end
    return counts
end
local function cueText(counts)
    local names = {}
    for n, c in pairs(counts) do table.insert(names, n .. "x" .. c) end
    table.sort(names)
    return #names > 0 and table.concat(names, ",") or "none"
end
-- Exactly these cues (name -> count) and nothing else since the mark.
local function expectCues(w, who, since, want, label)
    w.world:advance(0.3) -- deferred flush and the delayed cash cue
    local got = cueCounts(plays(w, who, since))
    local ok = true
    for n, c in pairs(want) do if got[n] ~= c then ok = false end end
    for n in pairs(got) do if not want[n] then ok = false end end
    check(ok, label .. ": expected " .. cueText(want) .. ", got " .. cueText(got))
end
local function patchText(from, to)
    return function(text)
        local s, e = string.find(text, from, 1, true)
        assert(s, "config patch failed: " .. from)
        return string.sub(text, 1, s - 1) .. to .. string.sub(text, e + 1)
    end
end

scenario("H18", "Sound cues: one cue per event, seller only, silent start, empty id stays silent", nil, function(mode)
    check(type(CONFIG.Sounds) == "table", "config has a Sounds table")
    local names = {"SaleSuccess", "Cash", "UiClick", "StockPlace", "CustomerArrive", "SaleFail", "Negotiate",
        "Upgrade", "Hire", "Notify", "PermitLapse", "Liquidate"}
    for _, n in ipairs(names) do
        local spec = CONFIG.Sounds and CONFIG.Sounds[n]
        check(type(spec) == "table" and type(spec.Id) == "string" and (spec.Id == "" or string.match(spec.Id, "^rbxassetid://%d+$") ~= nil)
            and type(spec.Volume) == "number" and spec.Volume > 0 and spec.Volume <= 2,
            "Sounds." .. n .. " has an rbxassetid (or empty) Id and a Volume in (0, 2]")
    end

    -- A 400 s registration puts lapses inside the run.
    local w = setup(mode, {configPatch = patchNumber("PermitPeriodSeconds", 400)})
    local p = w:addPlayer("Seller1")
    local s = w:addPlayer("Watcher2")
    local h = handles(w)
    local world = w.world

    -- Independent event counts, observed on the server-side attributes.
    local arrivals, bargains, lapses = 0, 0, 0
    local wasReady, lastBargain, wasLapsed = false, 0, false
    p:GetAttributeChangedSignal("K0CustomerReady"):Connect(function()
        local now = attr(p, "K0CustomerReady") == true
        if now and not wasReady then arrivals += 1 end
        wasReady = now
    end)
    local function watchBargain()
        local id = (attr(p, "K0OfferOpen") == true and attr(p, "K0OfferType") == "Bargainer") and attr(p, "K0OfferId") or 0
        if id ~= 0 and id ~= lastBargain then bargains += 1 end
        lastBargain = id
    end
    p:GetAttributeChangedSignal("K0OfferOpen"):Connect(watchBargain)
    p:GetAttributeChangedSignal("K0OfferId"):Connect(watchBargain)
    p:GetAttributeChangedSignal("K0RentDue"):Connect(function()
        local now = attr(p, "K0RentDue") == true
        if now and not wasLapsed then lapses += 1 end
        wasLapsed = now
    end)

    world:advance(1)
    check(#plays(w) == 0, "joining plays no cue: " .. cueText(cueCounts(plays(w))))

    local m = playMark(w)
    go(w, p, h.claim)
    expectCues(w, "Seller1", m, {Notify = 1}, "claim (notice only)")
    m = playMark(w)
    go(w, p, h.permit)
    expectCues(w, "Seller1", m, {Notify = 1}, "registration (notice only)")
    m = playMark(w)
    go(w, p, h[attr(p, "K0DemandSKU")])
    expectCues(w, "Seller1", m, {StockPlace = 1}, "restock (its notice stays silent)")

    m = playMark(w)
    check(world:runUntil(function() return attr(p, "K0CustomerReady") == true end, 120), "a customer arrives")
    world:advance(0.3)
    local arrive = cueCounts(plays(w, "Seller1", m))
    check(arrive.CustomerArrive == 1, "arrival plays CustomerArrive once: " .. cueText(arrive))

    -- Answer one offer by accepting (or declining when short) through the HUD.
    local kind = attr(p, "K0OfferType")
    local short = stockOf(p, attr(p, "K0OfferSKU")) < attr(p, "K0OfferUnits")
    m = playMark(w)
    answerOffer(w, p, h, function() return short and "decline" or "accept" end)
    local want = {UiClick = 1}
    if kind == "Bargainer" then want.Negotiate = 1 end
    if short then want.SaleFail = 1 else want.SaleSuccess = 1; want.Cash = 1 end
    expectCues(w, "Seller1", m, want, "answering a " .. kind .. (short and " (decline)" or " (accept)"))

    -- A long balanced session that also declines every fourth offer: every cue
    -- count must equal its event count.
    local offers = 0
    local bag = playFor(w, p, h, 1500, {decide = function(pp)
        offers += 1
        if offers % 4 == 0 then return "decline" end
        return defaultDecision(pp)
    end}, {})
    world:advance(1)
    local all = plays(w, "Seller1")
    local c = cueCounts(all)
    local function n(x) return c[x] or 0 end
    local sales = attr(p, "K0Sales")
    check(n("SaleSuccess") == sales, "SaleSuccess plays once per sale (" .. n("SaleSuccess") .. " vs " .. sales .. ")")
    check(n("Cash") == sales, "Cash follows every sale (" .. n("Cash") .. " vs " .. sales .. ")")
    check(n("StockPlace") == attr(p, "K0StockPurchases"), "StockPlace once per purchase (" .. n("StockPlace") .. " vs " .. attr(p, "K0StockPurchases") .. ")")
    check(n("Liquidate") == (attr(p, "K0Liquidations") or 0), "Liquidate once per liquidation (" .. n("Liquidate") .. " vs " .. tostring(attr(p, "K0Liquidations")) .. ")")
    check(n("CustomerArrive") == arrivals, "CustomerArrive once per arrival (" .. n("CustomerArrive") .. " vs " .. arrivals .. ")")
    check(n("Negotiate") == bargains, "Negotiate once per bargainer offer opened (" .. n("Negotiate") .. " vs " .. bargains .. ")")
    check(n("Upgrade") == ((attr(p, "K0Level") or 1) >= 2 and 1 or 0), "Upgrade once for level 2 (" .. n("Upgrade") .. ")")
    check(n("Hire") == (attr(p, "K0Hired") and 1 or 0), "Hire once for the cashier (" .. n("Hire") .. ")")
    check(lapses >= 1 and n("PermitLapse") == lapses, "PermitLapse once per lapse (" .. n("PermitLapse") .. " vs " .. lapses .. ")")
    local decisions = (attr(p, "K0AcceptCount") or 0) + (attr(p, "K0CounterCount") or 0) + (attr(p, "K0DeclineCount") or 0)
    check(n("UiClick") == decisions, "UiClick once per decision sent (" .. n("UiClick") .. " vs " .. decisions .. ")")
    local lost = attr(p, "K0LostSales") or 0
    check(n("SaleFail") >= 1 and n("SaleFail") <= lost and n("SaleFail") >= lost - lapses, "SaleFail once per lost sale, lapse pauses excepted (" .. n("SaleFail") .. " vs lost " .. lost .. ", lapses " .. lapses .. ")")
    local together = 0
    local atTime = {}
    for _, r in ipairs(all) do
        local name = cueName(r)
        atTime[r.t] = atTime[r.t] or {}
        atTime[r.t][name] = true
    end
    for _, set in pairs(atTime) do
        if set.Notify then
            for name in pairs(set) do if name ~= "Notify" and name ~= "UiClick" then together += 1 end end
        end
        if set.PermitLapse and set.SaleFail then together += 1 end
    end
    check(together == 0, "a notice or a lapse never doubles another cue (" .. together .. " overlaps)")
    local wrong = {}
    for _, r in ipairs(plays(w)) do
        local spec = CONFIG.Sounds[cueName(r)]
        if not spec or r.id ~= spec.Id or r.volume ~= spec.Volume or r.parent ~= "SoundService" then
            table.insert(wrong, r.name .. "=" .. tostring(r.id) .. "@" .. tostring(r.parent))
        end
    end
    check(#wrong == 0, "every play uses its configured id and volume under SoundService" .. (#wrong > 0 and (": " .. table.concat(wrong, ", ")) or ""))
    check(#plays(w, "Watcher2") == 0, "the spectator hears nothing (" .. #plays(w, "Watcher2") .. " plays)")
    note(string.format("20+ min: %d plays, %s", #all, cueText(c)))
    reportBag(bag)

    -- Handover: the new owner's fresh session is not replayed as events.
    m = playMark(w)
    w:removePlayer(p)
    world:advance(2)
    local after = cueCounts(plays(w, "Watcher2", m))
    local extra = 0
    for name, k in pairs(after) do if name ~= "Notify" or k > 1 then extra += 1 end end
    check(extra == 0, "handover plays at most one notice cue for the new owner: " .. cueText(after))
    noScriptErrors(w)
    noUnexpectedWarnings(w)

    -- Upgrade and cashier, each exactly once and without the notice cue.
    local w3 = setup(mode, {configPatch = patchNumber("StartingCash", C.PermitFee + C.UpgradeCost + C.HireCost + 150)})
    local p3 = w3:addPlayer("Seller1")
    local h3 = handles(w3)
    go(w3, p3, h3.claim)
    go(w3, p3, h3.permit)
    go(w3, p3, h3.orange)
    m = playMark(w3)
    go(w3, p3, h3.upgrade)
    check(attr(p3, "K0Level") == 2, "upgrade bought")
    expectCues(w3, "Seller1", m, {Upgrade = 1}, "upgrade")
    m = playMark(w3)
    go(w3, p3, h3.hire)
    check(attr(p3, "K0Hired") == true, "cashier hired")
    expectCues(w3, "Seller1", m, {Hire = 1}, "hire")
    noScriptErrors(w3)

    -- A lapse that pauses a waiting customer plays PermitLapse, not also SaleFail.
    local w4 = setup(mode, {configPatch = patchNumber("PermitPeriodSeconds", 60)})
    local p4 = w4:addPlayer("Seller1")
    local h4 = handles(w4)
    local ready4, paused = false, {}
    p4:GetAttributeChangedSignal("K0RentDue"):Connect(function()
        if attr(p4, "K0RentDue") == true and ready4 then table.insert(paused, w4.world.now) end
    end)
    p4:GetAttributeChangedSignal("K0CustomerReady"):Connect(function() ready4 = attr(p4, "K0CustomerReady") == true end)
    go(w4, p4, h4.claim)
    go(w4, p4, h4.permit)
    go(w4, p4, h4.orange)
    go(w4, p4, h4.bread)
    for _ = 1, 6 do
        if #paused > 0 then break end
        w4.world:runUntil(function() return attr(p4, "K0RentDue") == true end, 90)
        w4.world:advance(1)
        go(w4, p4, h4.permit) -- customers are ignored; renew and wait for the next lapse
    end
    w4.world:advance(0.5)
    check(#paused >= 1, "a lapse caught a waiting customer (" .. #paused .. ")")
    local doubled = 0
    for _, at in ipairs(paused) do
        local set = {}
        for _, r in ipairs(plays(w4, "Seller1")) do if r.t == at then set[cueName(r)] = true end end
        if not set.PermitLapse or set.SaleFail then doubled += 1 end
    end
    check(doubled == 0, "each such lapse plays PermitLapse alone (" .. doubled .. " wrong)")
    noScriptErrors(w4)

    -- An empty Id keeps its cue silent and creates no Sound.
    local stockId = CONFIG.Sounds.StockPlace.Id
    local w2 = setup(mode, {configPatch = patchText('StockPlace = {Id = "' .. stockId .. '"', 'StockPlace = {Id = ""')})
    local p2 = w2:addPlayer("Seller1")
    local h2 = handles(w2)
    go(w2, p2, h2.claim)
    go(w2, p2, h2.permit)
    m = playMark(w2)
    go(w2, p2, h2.orange)
    w2.world:advance(0.3)
    check(attr(p2, "K0StockPurchases") == 1, "restock happened with the cue emptied")
    check(#plays(w2, "Seller1", m) == 0, "emptied StockPlace plays nothing: " .. cueText(cueCounts(plays(w2, "Seller1", m))))
    local made = 0
    for _, inst in ipairs(w2.game:GetService("SoundService"):GetChildren()) do
        if inst.Name == "K0Sfx_StockPlace" then made += 1 end
    end
    check(made == 0, "no Sound instance is created for an empty Id")
    noScriptErrors(w2)
end)

------------------------------------------------------------------ report
local total, failed = 0, 0
print("")
print("BAYCREST K0 headless harness — real Luau sources on a mock engine")
print("Config " .. CONFIG.Version .. " · seed " .. C.PlaytestSeed .. " · modes " .. table.concat(OPTIONS.signalModes, "+"))
print(string.rep("-", 78))
for _, r in ipairs(RESULTS) do
    local bad = 0
    for _, c in ipairs(r.checks) do if not c.ok then bad += 1 end end
    total += 1
    if bad > 0 then failed += 1 end
    print(string.format("%s [%s] %-9s %s", bad == 0 and "PASS" or "FAIL", r.id, r.mode, r.title))
    for _, c in ipairs(r.checks) do
        if not c.ok then print("    x " .. c.message) end
    end
    for _, n in ipairs(r.notes) do print("    · " .. n) end
end
print(string.rep("-", 78))
print(string.format("%d scenario runs, %d failed", total, failed))
print("HARNESS RESULT: " .. (failed == 0 and "PASS" or "FAIL"))
