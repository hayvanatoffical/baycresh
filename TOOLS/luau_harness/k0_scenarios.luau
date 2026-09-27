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

-- Viewport = the whole screen; the HUD lays out in it minus the Roblox top bar
-- (engine world.guiInset, 58 px assumed). Landscape is the Roblox mobile default.
-- K0.4.5: sizes are Roblox UI pixels, which on a phone are about Android dp
-- (PRODUCTION/K0_TELEFON_EKRAN_VE_YAZI.md). The two Redmi rows divide the panel
-- resolution by an assumed Android density: 720x1640 at 2.0 and 1080x2400 at
-- 2.75. "floor" screens must keep every HUD text at TEXT_MIN or above; the
-- narrow 16:9-and-smaller class is measured and reported, not held to it.
-- K0.4.6: the owner's phone is a Redmi Note 13 Pro+ (1220x2712, 446 ppi). Its
-- two rows are the sister Note 13 Pro's reported default of 406 dp (density 3.0)
-- and Roblox's own ~160 dpi normalisation. On floor screens each HUD part must
-- also land on TEXT_MIN, not above it (KARARLAR UK-19: 12 px, not bigger).
local VIEWPORTS = {
    {name = "PC 1280x720", x = 1280, y = 720},
    {name = "Note 13 Pro+ 904x406", x = 904, y = 406, floor = true},
    {name = "Note 13 Pro+ 973x437", x = 973, y = 437, floor = true},
    {name = "Redmi HD+ 820x360", x = 820, y = 360, floor = true},
    {name = "Redmi FHD+ 873x393", x = 873, y = 393, floor = true},
    {name = "phone landscape 740x360", x = 740, y = 360, floor = true},
    {name = "narrow phone 568x320", x = 568, y = 320},
}
local TAP_MIN = 44 -- EKIP/06 §5
local TEXT_MIN = 12 -- KARARLAR UK-19: enough on a phone, and the phone HUD stays at it
local HUD_PARTS = {"Status", "Help", "Notice", "Offer"}

-- Geometry of the fixed HUD panels and the offer card at the current viewport.
-- Returns a list of problems. Phones (shorter side of the HUD area at most 500 px,
-- the small-screen rule of Roblox's touch controls) also keep the bottom-right
-- corner free for the default jump button (PlayerModule TouchJump on a small
-- screen: 70 px, 25 px from the right, 20 px from the bottom).
local function layoutProblems(w, gui, vpName, stats)
    local problems = {}
    local area = gui.AbsoluteSize
    local W, H = area.X, area.Y
    local phone = math.min(W, H) <= 500
    local jump = {W - 95, H - 90, 70, 70}
    local function box(obj)
        local x, y, bw, bh = w:rect(obj)
        return {x, y, bw, bh}
    end
    local function inside(name, r)
        if r[1] < -0.5 or r[2] < -0.5 or r[1] + r[3] > W + 0.5 or r[2] + r[4] > H + 0.5 then
            table.insert(problems, string.format("%s · %s leaves the screen (%.0f,%.0f %.0fx%.0f in %dx%d)", vpName, name, r[1], r[2], r[3], r[4], W, H))
        end
    end
    local panels = {Status = box(gui.Status), Help = box(gui.Help), Notice = box(gui.Notice)}
    for name, r in pairs(panels) do inside(name, r) end
    local names = {"Status", "Help", "Notice"}
    for i = 1, #names do
        for j = i + 1, #names do
            local a = K0World.overlapArea(panels[names[i]], panels[names[j]])
            if a > 0.5 then
                table.insert(problems, string.format("%s · %s and %s overlap (%.0f px²)", vpName, names[i], names[j], a))
            end
        end
    end
    if phone then
        for _, name in ipairs({"Help", "Notice"}) do
            if K0World.overlapArea(panels[name], jump) > 0.5 then
                table.insert(problems, vpName .. " · " .. name .. " covers the jump button corner")
            end
        end
    end
    local offer = gui.Offer
    if offer.Visible then
        inside("Offer", box(offer))
        for _, b in ipairs({offer.Accept, offer.Counter, offer.Decline}) do
            if b.Visible then
                local r = box(b)
                inside(b.Name, r)
                stats.tapW = math.min(stats.tapW or math.huge, r[3])
                stats.tapH = math.min(stats.tapH or math.huge, r[4])
                if r[3] < TAP_MIN - 0.01 or r[4] < TAP_MIN - 0.01 then
                    table.insert(problems, string.format("%s · %s button %.0fx%.0f px, under %d px", vpName, b.Name, r[3], r[4], TAP_MIN))
                end
                if phone and K0World.overlapArea(r, jump) > 0.5 then
                    table.insert(problems, vpName .. " · " .. b.Name .. " button under the jump button corner")
                end
            end
        end
    end
    return problems
end

scenario("H12", "HUD layout: offer card, 44 px taps, phone text at 12 px and not larger, no panel overlap on seven screens (estimate)", {"Deferred"}, function(mode)
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
    local risks, layout = {}, {}
    local stats = {}
    for _, vp in ipairs(VIEWPORTS) do stats[vp.name] = {} end
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
            for _, problem in ipairs(layoutProblems(w, gui, vp.name, stats[vp.name])) do layout[problem] = true end
            local minSize, who = w:minTextSize(gui)
            local st = stats[vp.name]
            if minSize < (st.minText or math.huge) then st.minText, st.minTextWho = minSize, who end
            local area = gui.AbsoluteSize
            local phone = math.min(area.X, area.Y) <= 500
            -- Smallest text per HUD part over every state seen: the part's scale.
            st.part = st.part or {}
            for _, name in ipairs(HUD_PARTS) do
                local obj = gui[name]
                if obj.Visible then
                    local m = w:minTextSize(obj)
                    if m < (st.part[name] or math.huge) then st.part[name] = m end
                end
            end
            if label == "idle" then
                local _, _, sw, sh = w:rect(gui.Status)
                st.statusShare = sw * sh / (area.X * area.Y)
            end
            if gui.Status.Title.Visible == phone then
                layout[vp.name .. " · title row " .. (phone and "shown on a phone" or "hidden on a wide screen")] = true
            end
            -- The HUD's own console line is what the device test will read; it
            -- must name this area and never promise more than the harness sees.
            local head = string.format("[K0 HUD] alan %dx%d ", area.X, area.Y)
            local lines = w:outputMatching("%[K0 HUD%]")
            local last = lines[#lines]
            local reported = last and string.find(last.line, head, 1, true) == 1
                and tonumber(string.match(last.line, "en küçük yazı ([%d%.]+) px"))
            if not reported then
                layout[vp.name .. " · no HUD console line for this area"] = true
            else
                st.reported = reported
                if reported > minSize + 0.05 then
                    layout[string.format("%s · console reports %.1f px, harness sees %.1f px (%s)", vp.name, reported, minSize, tostring(who))] = true
                end
            end
        end
        w.world:setViewport(1280, 720)
        w.world:advance(0.1)
    end
    -- The notice box is measured whether or not a notice is showing.
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
        -- Phones: one row of buttons, so the card stays short on a landscape screen.
        w.world:setViewport(740, 360)
        w.world:advance(0.1)
        check(offer.Counter.Position.Y.Offset == offer.Accept.Position.Y.Offset
            and offer.Decline.Position.Y.Offset == offer.Accept.Position.Y.Offset, "phone layout keeps the buttons in one row")
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
    local bad = {}
    for v in pairs(layout) do table.insert(bad, v) end
    table.sort(bad)
    check(#bad == 0, "panels inside the screen, no overlap, buttons at least 44 px, jump corner free, title only on wide screens, console line honest"
        .. (#bad > 0 and (":\n      - " .. table.concat(bad, "\n      - ")) or ""))
    local small, large = {}, {}
    for _, vp in ipairs(VIEWPORTS) do
        local st = stats[vp.name]
        if vp.floor and (st.minText or 0) < TEXT_MIN - 0.01 then
            table.insert(small, string.format("%s: %.1f px (%s)", vp.name, st.minText or -1, tostring(st.minTextWho)))
        end
        if vp.floor then
            for _, name in ipairs(HUD_PARTS) do
                local m = st.part and st.part[name]
                if not m then
                    table.insert(large, vp.name .. ": " .. name .. " never measured")
                elseif m > TEXT_MIN + 0.05 then
                    table.insert(large, string.format("%s: %s smallest text %.1f px", vp.name, name, m))
                end
            end
        end
        note(string.format("%s: smallest text %.1f px (%s), console %.1f px; smallest button %.0fx%.0f px; status panel %.0f%% of the HUD area (estimate, before device test)",
            vp.name, st.minText or -1, tostring(st.minTextWho), st.reported or -1, st.tapW or -1, st.tapH or -1, (st.statusShare or -1) * 100))
    end
    check(#small == 0, "no HUD text under " .. TEXT_MIN .. " px on the Redmi, Note 13 Pro+ and 740x360 phone screens"
        .. (#small > 0 and (":\n      - " .. table.concat(small, "\n      - ")) or ""))
    check(#large == 0, "phone HUD not larger than needed: status, help, notice and offer card each at " .. TEXT_MIN .. " px on those screens"
        .. (#large > 0 and (":\n      - " .. table.concat(large, "\n      - ")) or ""))
    noScriptErrors(w)
end)

-- K0.4.4: a phone has no E key and no number row (EKIP/06 §1 "Telefon önce").
local KEY_WORDS = {"E'yi", "E'ye", " E ", " E%.", "E ile", "[Tt]uş", "^%d  ", "klavye"}
local function keyOnly(text)
    for _, pat in ipairs(KEY_WORDS) do
        if string.find(text, pat) then return pat end
    end
    return nil
end

scenario("H20", "Touch-only device: no instruction names a key; keyboard keeps its shortcuts", {"Deferred"}, function(mode)
    for _, device in ipairs({"touch", "keyboard"}) do
        local w = setup(mode)
        local uis = w.game:GetService("UserInputService")
        uis.TouchEnabled = device == "touch"
        uis.KeyboardEnabled = device == "keyboard"
        local p = w:addPlayer("Tester1")
        local h = handles(w)
        local gui = w:hud(p)
        local texts = {}
        local function grab(kind, text) if type(text) == "string" and text ~= "" then texts[kind .. ": " .. text] = text end end
        p:GetAttributeChangedSignal("K0Notice"):Connect(function() grab("notice", p:GetAttribute("K0Notice")) end)
        gui.Help.HelpText:GetPropertyChangedSignal("Text"):Connect(function() grab("help", gui.Help.HelpText.Text) end)
        gui.Status.Goal:GetPropertyChangedSignal("Text"):Connect(function() grab("goal", gui.Status.Goal.Text) end)
        grab("help", gui.Help.HelpText.Text)
        local claimHelp = gui.Help.HelpText.Text
        local buttons = {}
        local offers = 0
        playFor(w, p, h, 600, {
            decide = function(pp)
                offers += 1
                for _, b in ipairs({gui.Offer.Accept, gui.Offer.Counter, gui.Offer.Decline}) do
                    if b.Visible then buttons[b.Name .. ": " .. b.Text] = b.Text end
                end
                return defaultDecision(pp)
            end,
        })
        check(offers > 0, device .. ": offers were answered (" .. offers .. ")")
        if device == "touch" then
            check(string.find(claimHelp, "düğmeye basılı tut", 1, true) ~= nil, "touch: claim help says to hold the on-screen button: " .. claimHelp)
            local bad = {}
            for label, text in pairs(texts) do
                local hit = keyOnly(text)
                if hit then table.insert(bad, label .. "  [" .. hit .. "]") end
            end
            for label, text in pairs(buttons) do
                if string.find(text, "^%d") then table.insert(bad, "button " .. label) end
            end
            table.sort(bad)
            check(#bad == 0, "touch: no text or button names a key" .. (#bad > 0 and (":\n      - " .. table.concat(bad, "\n      - ")) or ""))
        else
            check(string.find(claimHelp, "E'yi basılı tut", 1, true) ~= nil, "keyboard: claim help names the E key: " .. claimHelp)
            local numbered = 0
            for _, text in pairs(buttons) do
                if string.find(text, "^[123]  ") then numbered += 1 end
            end
            check(numbered > 0, "keyboard: offer buttons keep their 1/2/3 shortcut")
        end
        local serverNotices = 0
        for _, text in pairs(texts) do if string.find(text, "tezgâhta aç", 1, true) then serverNotices += 1 end end
        check(serverNotices > 0, device .. ": customer notice seen and device-neutral")
        noScriptErrors(w)
    end
end)

-- K0.4.4: the figure's front is -Z (eyes, cap brim, apron) = LookVector.
local function eyesForward(model)
    local root, head = model.PrimaryPart, model:FindFirstChild("Head")
    local sum, n = Vector3.new(0, 0, 0), 0
    for _, part in ipairs(model:GetChildren()) do
        if part.Name == "Eye" then sum += part.Position n += 1 end
    end
    if not root or not head or n == 0 then return false end
    return ((sum / n) - head.Position):Dot(root.CFrame.LookVector) > 0.3
end

local function flatDir(from, to)
    local d = Vector3.new(to.X - from.X, 0, to.Z - from.Z)
    return d.Magnitude > 0 and d.Unit or d
end

scenario("H21", "NPCs face where they walk; customers at the counter and the cashier face each other", nil, function(mode)
    -- Harness self-check: a CFrame half-way through a turn is still a rotation.
    local o = Vector3.new(0, 0, 0)
    for _, turn in ipairs({{Vector3.new(1, 0, 0), Vector3.new(0, 0, 1), 0.7071}, {Vector3.new(-1, 0, 0), Vector3.new(1, 0, 0), 0}}) do
        local mid = CFrame.lookAt(o, turn[1]):Lerp(CFrame.lookAt(o, turn[2]), 0.5)
        local look, right, up = mid.LookVector, mid.RightVector, mid.UpVector
        check(math.abs(look.Magnitude - 1) < 1e-6 and math.abs(right.Magnitude - 1) < 1e-6 and math.abs(look:Dot(right)) < 1e-6
            and math.abs(look:Dot(turn[1]) - turn[3]) < 1e-3 and up.Y > 0.999,
            string.format("harness Lerp keeps a rotation half-way through a %.0f° turn", math.deg(math.acos(turn[1]:Dot(turn[2])))))
    end
    local w = setup(mode)
    local p = w:addPlayer("Tester1")
    local h = handles(w)
    local scene = w:scene()
    local salePos = h.sale.Parent.Position
    go(w, p, h.claim)
    go(w, p, h.permit)
    go(w, p, h.orange)
    go(w, p, h.bread)
    local last, steps, badWalk, roles = {}, 0, {}, {}
    local function sample()
        for _, m in ipairs(scene:GetChildren()) do
            if m:IsA("Model") and m:GetAttribute("NpcRole") and m.PrimaryPart then
                local pos, look = m.PrimaryPart.Position, m.PrimaryPart.CFrame.LookVector
                local prev = last[m]
                -- A window in which the figure also turned (arrival at the
                -- counter) is not a walking step.
                if prev and prev.look:Dot(look) > 0.999
                    and Vector3.new(pos.X - prev.pos.X, 0, pos.Z - prev.pos.Z).Magnitude > 0.3 then
                    steps += 1
                    roles[m:GetAttribute("NpcRole")] = true
                    local dot = flatDir(prev.pos, pos):Dot(look)
                    if dot < 0.95 then badWalk[m.Name] = string.format("%s walks with look·move %.2f", m.Name, dot) end
                    if not eyesForward(m) then badWalk[m.Name .. "/eyes"] = m.Name .. " eyes not on its front while walking" end
                    -- Welded parts travel with the root (the harness moves weld
                    -- peers; real weld physics is a device check).
                    local head = m:FindFirstChild("Head")
                    if not head or (head.Position - pos).Magnitude > 2 then
                        badWalk[m.Name .. "/apart"] = m.Name .. " head left behind while walking"
                    end
                end
                last[m] = {pos = pos, look = look}
            end
        end
    end
    local atCounter, badCounter = 0, {}
    local stop = w.world.now + 600
    while w.world.now < stop do
        local ready = w.world:runUntil(function() sample() return attr(p, "K0CustomerReady") == true end, stop - w.world.now)
        if not ready then break end
        w.world:advance(0.6) -- the turn takes 0.35 s
        for _, m in ipairs(scene:GetChildren()) do
            if m:IsA("Model") and string.find(m.Name, "^Visitor_") and m.PrimaryPart then
                atCounter += 1
                local dot = flatDir(m.PrimaryPart.Position, salePos):Dot(m.PrimaryPart.CFrame.LookVector)
                if dot < 0.95 then table.insert(badCounter, string.format("%s at the counter: look·stall %.2f", m.Name, dot)) end
                if not eyesForward(m) then table.insert(badCounter, m.Name .. " eyes not on its front at the counter") end
            end
        end
        go(w, p, h.sale)
        answerOffer(w, p, h, defaultDecision)
        last = {}
    end
    local list = {}
    for _, v in pairs(badWalk) do table.insert(list, v) end
    table.sort(list)
    check(steps > 50, "walking NPCs sampled (" .. steps .. " steps)")
    check(roles.Buyer and roles.Passerby and roles.Pedestrian, "customers, passers-by and pedestrians all sampled")
    check(#list == 0, "every walking NPC holds together and faces its direction of travel" .. (#list > 0 and (":\n      - " .. table.concat(list, "\n      - ")) or ""))
    check(atCounter >= 5, "customers checked at the counter (" .. atCounter .. ")")
    check(#badCounter == 0, "a customer at the counter faces the stall" .. (#badCounter > 0 and (":\n      - " .. table.concat(badCounter, "\n      - ")) or ""))
    noScriptErrors(w)

    -- The cashier stands behind the counter and faces the customer spot.
    local w2 = setup(mode, {configPatch = patchNumber("StartingCash", C.PermitFee + C.UpgradeCost + C.HireCost + 150)})
    local p2 = w2:addPlayer("Seller1")
    local h2 = handles(w2)
    go(w2, p2, h2.claim)
    go(w2, p2, h2.permit)
    go(w2, p2, h2.orange)
    go(w2, p2, h2.upgrade)
    go(w2, p2, h2.hire)
    w2.world:advance(0.5)
    local worker = w2:scene():FindFirstChild("Worker_K0")
    local queue = w2:scene().Waypoints.CustomerQueue.Position
    check(worker ~= nil, "cashier hired")
    if worker then
        local dot = flatDir(worker.PrimaryPart.Position, queue):Dot(worker.PrimaryPart.CFrame.LookVector)
        check(dot > 0.9, string.format("cashier faces the customer spot (look·queue %.2f)", dot))
        check(eyesForward(worker), "cashier's eyes are on its front")
    end
    noScriptErrors(w2)
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
    -- K0.4.4: phones use a narrower, taller notice and help box (right column).
    local boxes = {
        {kind = "notice", width = 510 - 28, height = 76, size = 15, what = "Notice"},
        {kind = "notice", width = 400 - 28, height = 94, size = 15, what = "Notice (phone)"},
        {kind = "help", width = 620 - 28, height = 60, size = 15, what = "Help"},
        {kind = "help", width = 400 - 28, height = 92, size = 15, what = "Help (phone)"},
        {kind = "goal", width = 410 - 28, height = 52, size = 14, what = "Goal"},
    }
    local bad, total, longest = {}, 0, 0
    for _, list in pairs(SEEN_TEXT) do
        for text in pairs(list) do
            total += 1
            longest = math.max(longest, utf8.len(text) or #text)
        end
    end
    for _, box in ipairs(boxes) do
        for text in pairs(SEEN_TEXT[box.kind]) do
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

-- K0.4.3 readability greybox. The silhouette measure is a front + side
-- projection of the figure's parts on a 0.1 stud grid: a harness proxy for
-- "the roles read apart by shape", not a view on a phone screen.
local function silhouette(model)
    local root = model.PrimaryPart
    local front, side = {}, {}
    for _, part in ipairs(model:GetChildren()) do
        if part:IsA("BasePart") and part ~= root and part.Transparency < 1 then
            -- In the figure's own frame: NPCs turn since K0.4.4, and the parts
            -- are axis-aligned with the root, so Size maps onto local axes.
            local o = root.CFrame:PointToObjectSpace(part.Position)
            -- Snap away rotation round-off so a turned figure rasterises the same.
            o = Vector3.new(math.round(o.X * 1e6) / 1e6, math.round(o.Y * 1e6) / 1e6, math.round(o.Z * 1e6) / 1e6)
            local ball = part.Shape == Enum.PartType.Ball
            local function fill(cells, cx, cy, sx, sy)
                for gx = math.floor((cx - sx / 2) * 10), math.ceil((cx + sx / 2) * 10) do
                    for gy = math.floor((cy - sy / 2) * 10), math.ceil((cy + sy / 2) * 10) do
                        local dx, dy = (gx / 10 - cx) / (sx / 2), (gy / 10 - cy) / (sy / 2)
                        if (ball and dx * dx + dy * dy <= 1) or (not ball and math.abs(dx) <= 1 and math.abs(dy) <= 1) then
                            cells[gx .. ":" .. gy] = true
                        end
                    end
                end
            end
            fill(front, o.X, o.Y, part.Size.X, part.Size.Y)
            fill(side, o.Z, o.Y, part.Size.Z, part.Size.Y)
        end
    end
    return {front = front, side = side}
end

-- Share of the combined outline that only one of the two figures covers.
local function outlineDifference(a, b)
    local only, union = 0, 0
    for _, view in ipairs({"front", "side"}) do
        for k in pairs(a[view]) do union += 1; if not b[view][k] then only += 1 end end
        for k in pairs(b[view]) do if not a[view][k] then union += 1; only += 1 end end
    end
    return union > 0 and only / union or 0
end

local ICON_NAMES = {"IconCash", "IconPermit", "IconDemandUp", "IconOrange", "IconBread"}

scenario("H19", "Readability greybox: NPC roles read apart by shape; HUD icons and budget gauge follow state", nil, function(mode)
    local w = setup(mode)
    local p = w:addPlayer("Seller1")
    local s = w:addPlayer("Watcher2")
    local h = handles(w)
    local scene = w:scene()

    -- Every figure is recorded as it enters the scene.
    local expectedRole = {Pedestrian_ = "Pedestrian", PassingVisitor_ = "Passerby"}
    local shapes, counts, wrongRole = {}, {}, {}
    scene.ChildAdded:Connect(function(child)
        local role = child:GetAttribute("NpcRole")
        if role == nil then return end
        counts[role] = (counts[role] or 0) + 1
        for prefix, want in pairs(expectedRole) do
            if string.match(child.Name, "^" .. prefix) and role ~= want then
                table.insert(wrongRole, child.Name .. "=" .. role)
            end
        end
        if string.match(child.Name, "^Visitor_") and role ~= "Buyer" and role ~= "Bargainer" and role ~= "Browser" then
            table.insert(wrongRole, child.Name .. "=" .. role)
        end
        shapes[role] = shapes[role] or silhouette(child)
    end)
    local function currentVisitor()
        for _, c in ipairs(scene:GetChildren()) do
            if string.match(c.Name, "^Visitor_") then return c end
        end
        return nil
    end
    local browsersChecked, browserMismatch = 0, 0
    p:GetAttributeChangedSignal("K0Browsers"):Connect(function()
        local v = currentVisitor()
        browsersChecked += 1
        if not v or v:GetAttribute("NpcRole") ~= "Browser" then browserMismatch += 1 end
    end)

    -- The bot answers every offer; the decision hook inspects the open card first.
    local gui = w:hud(p)
    local offers, roleMismatch, iconMismatch, stockTextMismatch = 0, {}, {}, 0
    local function inspect(pp)
        offers += 1
        local kind, sku = attr(pp, "K0OfferType"), attr(pp, "K0OfferSKU")
        local v = currentVisitor()
        local role = v and v:GetAttribute("NpcRole")
        if role ~= kind then table.insert(roleMismatch, string.format("offer %d: %s drawn as %s", attr(pp, "K0OfferId"), kind, tostring(role))) end
        local card = gui.Offer
        if card.IconOrange.Visible ~= (sku == "orange") or card.IconBread.Visible ~= (sku == "bread") then
            table.insert(iconMismatch, "product icon for " .. sku)
        end
        if card.IconBudget.Visible ~= (kind == "Bargainer") then table.insert(iconMismatch, "budget gauge for " .. kind) end
        if not string.find(gui.Status.Stock.Text, " " .. attr(pp, "K0OrangeStock") .. " ", 1, true)
            or not string.find(gui.Status.BreadStock.Text, " " .. attr(pp, "K0BreadStock") .. " ", 1, true) then
            stockTextMismatch += 1
        end
        return defaultDecision(pp)
    end
    local bag = playFor(w, p, h, 900, {decide = inspect, hire = false})
    reportBag(bag)

    check(#wrongRole == 0, "every figure carries the role of its spawn: " .. table.concat(wrongRole, ", "))
    check(offers >= 10 and #roleMismatch == 0, string.format("each of %d offers came from a figure drawn as its kind%s", offers,
        #roleMismatch > 0 and (": " .. table.concat(roleMismatch, "; ")) or ""))
    check(browsersChecked >= 1 and browserMismatch == 0, string.format("each of %d browsers is drawn as a browser", browsersChecked))
    check(#iconMismatch == 0, "offer card icons follow the product and the offer kind: " .. table.concat(iconMismatch, ", "))
    check(stockTextMismatch == 0, "stock labels show the current orange and bread stock")
    for _, role in ipairs({"Buyer", "Bargainer", "Browser", "Passerby", "Pedestrian"}) do
        check(shapes[role] ~= nil, role .. " figure seen (" .. (counts[role] or 0) .. ")")
    end

    -- Outline differences between roles the player treats differently. Identical
    -- geometry scores 0 (skin colour does not count). The floors are regression
    -- guards, not a readability measurement: buyer and bargainer are the pair the
    -- offer decision depends on (ASSET-PROMPTS/01), so theirs is the higher one.
    local pairsToCheck = {
        {"Buyer", "Bargainer", 0.12}, {"Buyer", "Browser", 0.05}, {"Bargainer", "Browser", 0.05},
        {"Buyer", "Passerby", 0.05}, {"Bargainer", "Passerby", 0.05},
    }
    local notes = {}
    for _, pair in ipairs(pairsToCheck) do
        local a, b = shapes[pair[1]], shapes[pair[2]]
        if a and b then
            local d = outlineDifference(a, b)
            table.insert(notes, string.format("%s/%s %.0f%%", pair[1], pair[2], d * 100))
            check(d >= pair[3], string.format("%s and %s outlines differ by at least %.0f%% (%.1f%%)", pair[1], pair[2], pair[3] * 100, d * 100))
        end
    end
    note("outline difference (front + side projection): " .. table.concat(notes, ", "))

    -- Status icons: the owner sees them, a spectator does not.
    for _, name in ipairs(ICON_NAMES) do
        local i = gui.Status:FindFirstChild(name)
        check(i ~= nil and i.Visible and i.Size.X.Offset == 24 and i.Size.Y.Offset == 24, name .. " shown at 24 px for the seller")
        local si = w:hud(s).Status:FindFirstChild(name)
        check(si ~= nil and not si.Visible, name .. " hidden for the spectator")
    end
    -- Orange and bread must differ by shape alone (the greyscale test in 07).
    local fruit, loaf = gui.Status.IconOrange.Fruit.Size, gui.Status.IconBread.Loaf.Size
    check(fruit.X.Offset == fruit.Y.Offset and loaf.X.Offset >= 1.5 * loaf.Y.Offset,
        string.format("orange icon is round (%dx%d), bread icon is long (%dx%d)", fruit.X.Offset, fruit.Y.Offset, loaf.X.Offset, loaf.Y.Offset))
    noScriptErrors(w)

    -- Worker figure: a cashier gets the apron.
    local w3 = setup(mode, {configPatch = patchNumber("StartingCash", C.PermitFee + C.UpgradeCost + C.HireCost + 150)})
    local p3 = w3:addPlayer("Seller1")
    local h3 = handles(w3)
    go(w3, p3, h3.claim)
    go(w3, p3, h3.permit)
    go(w3, p3, h3.orange)
    go(w3, p3, h3.upgrade)
    go(w3, p3, h3.hire)
    w3.world:advance(0.5)
    local worker = w3:scene():FindFirstChild("Worker_K0")
    check(worker ~= nil and worker:GetAttribute("NpcRole") == "Worker" and worker:FindFirstChild("Apron") ~= nil,
        "the hired cashier is drawn with an apron")
    noScriptErrors(w3)

    -- Budget gauge: with bargainers made frequent, all three signals show and
    -- the fill level alone orders them.
    local w2 = setup(mode, {configPatch = patchText("Bargainer = 18}", "Bargainer = 600}")})
    local p2 = w2:addPlayer("Seller1")
    local h2 = handles(w2)
    local gui2 = w2:hud(p2)
    local levels, unstable = {}, 0
    local function gauge(pp)
        if attr(pp, "K0OfferType") == "Bargainer" then
            local signal = attr(pp, "K0OfferSignal")
            local height = gui2.Offer.IconBudget.Level.Size.Y.Offset
            if levels[signal] and levels[signal] ~= height then unstable += 1 end
            levels[signal] = height
        end
        return defaultDecision(pp)
    end
    local guard = 0
    while (levels.SIKI == nil or levels.ORTA == nil or levels.ESNEK == nil) and guard < 12 do
        guard += 1
        playFor(w2, p2, h2, 60, {decide = gauge, hire = false})
    end
    check(levels.SIKI and levels.ORTA and levels.ESNEK, string.format("all three budget signals seen (SIKI %s, ORTA %s, ESNEK %s)",
        tostring(levels.SIKI), tostring(levels.ORTA), tostring(levels.ESNEK)))
    if levels.SIKI and levels.ORTA and levels.ESNEK then
        check(levels.SIKI + 4 <= levels.ORTA and levels.ORTA + 4 <= levels.ESNEK and levels.ESNEK <= 18,
            string.format("fill rises SIKI < ORTA < ESNEK by at least 4 px on the 24 px icon (%d, %d, %d)", levels.SIKI, levels.ORTA, levels.ESNEK))
    end
    check(unstable == 0, "the same signal always shows the same fill")
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
