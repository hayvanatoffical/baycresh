-- Baycrest K0 Market (version: K0MarketConfig.Version)
-- Server-authoritative ownership, permit, stock, offers, demand, upgrade and wages.
-- This script is the only active K0 server runtime. Legacy K0Game is archived in GAME/legacy.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local Config = require(ReplicatedStorage:WaitForChild("K0MarketConfig"))
local C = Config.Prototype
local economyRng = Random.new(C.PlaytestSeed or 260926)
local cosmeticRng = Random.new()

-- Working-capital floor: the cheapest single unit at the wholesaler. With an
-- empty shelf no customer is spawned, so cash below this ends the economy for the
-- session. K0.4.1 refuses any non-stock payment that would create that state.
local minUnitCost = math.huge
for _, product in pairs(C.Products) do
    minUnitCost = math.min(minUnitCost, math.floor(product.WholesaleCost / product.WholesaleBundle))
end

local scene = workspace:WaitForChild("BlackstoneBazaar_K0")

-- A copied Studio place can still contain the historical K0Game script even when
-- the source package is clean. Do not silently pretend this is safe: both
-- runtimes can write the same prompts and player state. The migration script
-- disables it; this runtime also emits a visible warning if it is still active.
local legacyServer = game:GetService("ServerScriptService"):FindFirstChild("K0Game")
if legacyServer and legacyServer:IsA("BaseScript") and not legacyServer.Disabled then
    warn("[Baycrest K0] Legacy ServerScriptService/K0Game is still enabled. Run K0_MARKET_V3_MIGRATION.lua or disable it before testing.")
end

local stall = scene:WaitForChild("Stall_01")
local points = scene:WaitForChild("Waypoints")
local interaction = scene:WaitForChild("Interaction")
local market = scene:WaitForChild("MarketSystem")
local displays = scene:WaitForChild("ProductDisplays")

local claimPrompt = stall.NameSign:WaitForChild("ClaimPrompt")
local salePrompt = interaction.SalePoint:WaitForChild("SalePrompt")
local upgradePrompt = interaction.UpgradeBoard:WaitForChild("UpgradeBoardPrompt")
local hirePrompt = interaction.HireBoard:WaitForChild("HireBoardPrompt")
local payPrompt = interaction.PayBoard:WaitForChild("PayBoardPrompt")
local permitPrompt = market.PermitOffice:WaitForChild("PermitPrompt")
local orangePrompt = market.OrangeWholesale:WaitForChild("OrangeRestockPrompt")
local breadPrompt = market.BreadWholesale:WaitForChild("BreadRestockPrompt")
local signText = stall.NameSign.SignSurface.OwnerText
local demandBoard = market:FindFirstChild("DemandBoard")

-- Stop accidental double-installation of this runtime, including a duplicate
-- script with the exact same version. The lock exists only for this server run.
local runtimeLock = scene:FindFirstChild("__K0MarketRuntimeLock")
if runtimeLock then
    error("Bir K0Market runtime zaten etkin. Aktif ServerScriptService kaynaklarını tek kopyaya indirin.")
end
runtimeLock = Instance.new("ObjectValue")
runtimeLock.Name = "__K0MarketRuntimeLock"
runtimeLock.Value = script
runtimeLock.Parent = scene

local existingRuntime = scene:GetAttribute("K0RuntimeVersion")
if existingRuntime and existingRuntime ~= Config.Version then
    error("Başka bir K0 runtime sürümü işaretli: " .. tostring(existingRuntime) .. ". Legacy scriptleri kaldırın.")
end
scene:SetAttribute("K0RuntimeVersion", Config.Version)

local decision = ReplicatedStorage:FindFirstChild("K0MarketDecision")
if decision and not decision:IsA("RemoteEvent") then
    error("ReplicatedStorage/K0MarketDecision RemoteEvent olmalı; farklı sınıfta nesne bulundu.")
end
if not decision then
    decision = Instance.new("RemoteEvent")
    decision.Name = "K0MarketDecision"
    decision.Parent = ReplicatedStorage
end

local state = {}
local owner = nil
local worker = nil
local visitor = nil
local crowdCount = 0
local crowdSerial = 0
local noticeSerial = 0
local offerSerial = 0

local function resetState()
    -- Restart gameplay RNG for each owner session so controlled K0 tests begin
    -- from the same economy sequence. Decorative crowd RNG stays independent.
    state.sessionSerial = (state.sessionSerial or 0) + 1
    economyRng = Random.new(C.PlaytestSeed or 260926)
    state.cash = C.StartingCash
    state.permit = false
    state.permitDue = false
    state.permitRemaining = 0
    state.claimed = false
    state.level = 1
    state.stock = {orange = 0, bread = 0}
    state.sales = 0
    state.revenue = 0
    state.wholesaleSpent = 0
    state.permitSpent = 0
    state.wagesSpent = 0
    state.upgradeSpent = 0
    state.hireSpent = 0
    state.hired = false
    state.wagesDue = false
    state.shiftRemaining = C.ShiftSeconds
    state.visitorState = "none"
    state.currentOffer = nil
    state.offerOpen = false
    state.lostSales = 0
    state.browsers = 0
    state.passers = 0
    state.lastAction = 0
    state.sessionStartedAt = os.clock()
    state.firstClaimSeconds = -1
    state.firstStockSeconds = -1
    state.firstOfferSeconds = -1
    state.firstDecisionSeconds = -1
    state.firstSaleSeconds = -1
    state.firstUpgradeSeconds = -1
    state.firstHireSeconds = -1
    state.stockPurchases = 0
    state.demandAlignedPurchases = 0
    state.acceptCount = 0
    state.counterCount = 0
    state.counterSuccess = 0
    state.counterFailure = 0
    state.declineCount = 0
    state.permitRenewals = 0
    state.wagePayments = 0
    state.liquidations = 0
    state.liquidationRevenue = 0
    state.rescueGrants = 0
    state.deadEndSeconds = -1
    state.targetSummaryPrinted = false
    state.finalSummaryPrinted = false
    -- A fixed opening condition makes the three K0 playtests comparable.
    state.demandSKU = economyRng:NextInteger(1, 2) == 1 and "orange" or "bread"
    state.demandRemaining = C.DemandCycleSeconds
end
resetState()

local function elapsedSeconds()
    return math.max(0, math.floor(os.clock() - state.sessionStartedAt + 0.5))
end

local function milestone(name)
    local seconds = elapsedSeconds()
    local fieldByName = {
        claim = "firstClaimSeconds",
        stock = "firstStockSeconds",
        offer = "firstOfferSeconds",
        decision = "firstDecisionSeconds",
        sale = "firstSaleSeconds",
        upgrade = "firstUpgradeSeconds",
        hire = "firstHireSeconds",
    }
    local field = fieldByName[name]
    if not field or state[field] >= 0 then return end
    state[field] = seconds
    print(string.format("[Baycrest K0] milestone=%s seconds=%d", name, seconds))
end

local function inRange(player, target)
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    return root ~= nil and (root.Position - target.Position).Magnitude <= C.InteractionDistance
end

local function guard(player, target)
    if player ~= owner or not inRange(player, target) then return false end
    local now = os.clock()
    if now - state.lastAction < 0.2 then return false end
    state.lastAction = now
    return true
end

local function notice(message)
    if not owner then return end
    noticeSerial += 1
    owner:SetAttribute("K0Notice", message)
    owner:SetAttribute("K0NoticeSerial", noticeSerial)
end

local function totalStock()
    return state.stock.orange + state.stock.bread
end

-- True when paying `cost` would leave an empty shelf and less than one unit's
-- cash. K0.4 allowed it for the upgrade, the cashier, the wage and the renewal;
-- the headless harness reached each case and the session could not recover.
local function wouldStrand(cost)
    return totalStock() == 0 and state.cash - cost < minUnitCost
end

local function strandNotice(what, cost)
    local step = state.permitDue and "Önce Pazar Yönetimi'nde kaydı yenile, sonra stok al." or ("Önce toptancıdan en az 1 birim stok al (" .. minUnitCost .. " ₡).")
    notice(what .. " şimdi ödenirse kasada " .. (state.cash - cost) .. " ₡ kalır ve rafta ürün yok; stoksuz tezgâha müşteri gelmez. " .. step)
end

-- A state no player action can leave. The guards above should make it
-- unreachable inside the rescue limit; if it happens anyway it is reported once
-- so an observer never mistakes a stalled session for a slow one.
local function economyDeadEnd()
    if not (owner and state.claimed and state.permit) or totalStock() > 0 then return nil end
    if state.permitDue then
        if state.cash >= C.PermitFee + minUnitCost then return nil end
        if state.rescueGrants < (C.RescueGrantLimit or 1) then return nil end
        return "renewal_unaffordable"
    end
    if state.cash < minUnitCost then return "empty_shelf_no_cash" end
    return nil
end

local function reportDeadEnd()
    if state.deadEndSeconds >= 0 then return end
    local reason = economyDeadEnd()
    if not reason then return end
    state.deadEndSeconds = elapsedSeconds()
    print(string.format("[Baycrest K0] dead_end seconds=%d reason=%s cash=%d rescueGrants=%d",
        state.deadEndSeconds, reason, state.cash, state.rescueGrants))
    notice("Bu oturumda ekonomik çıkmaz oluştu: kasa " .. state.cash .. " ₡, stok yok, kurtarma hakkı kalmadı. Gözlemci bunu kayda geçirsin.")
end

local function setDemandBoardText(text)
    if not demandBoard then return end
    for _, gui in ipairs(demandBoard:GetChildren()) do
        if gui:IsA("SurfaceGui") then
            local detail = gui:FindFirstChild("Detail")
            if detail and detail:IsA("TextLabel") then detail.Text = text end
        end
    end
end

local function setBoardDetail(part, text)
    if not part then return end
    for _, gui in ipairs(part:GetChildren()) do
        if gui:IsA("SurfaceGui") then
            local detail = gui:FindFirstChild("Detail")
            if detail and detail:IsA("TextLabel") then detail.Text = text end
        end
    end
end

local function setPriceTag(part, sku)
    if not part then return end
    local product = C.Products[sku]
    local multiplier = sku == state.demandSKU and (1 + C.DemandBonusRatio) or 1
    local price = math.max(1, math.floor(product.Retail * multiplier + 0.5))
    for _, gui in ipairs(part:GetChildren()) do
        if gui:IsA("SurfaceGui") then
            local text = gui:FindFirstChild("Price")
            if text and text:IsA("TextLabel") then
                text.Text = string.upper(product.Name) .. " " .. price .. " ₡/" .. product.Unit
            end
        end
    end
end

local function visibleUnits(model, count)
    if not model then return end
    for _, item in ipairs(model:GetChildren()) do
        if item:IsA("BasePart") then
            local n = tonumber(string.match(item.Name, "^Unit_(%d+)$"))
            if n then item.Transparency = n <= count and 0 or 1 end
        end
    end
end

local function updateDisplays()
    visibleUnits(displays.OrangeFront, math.min(state.stock.orange, 8))
    visibleUnits(displays.BreadFront, math.min(state.stock.bread, 6))
    visibleUnits(displays.OrangeUpper, state.level >= 2 and math.max(0, state.stock.orange - 8) or 0)
    visibleUnits(displays.BreadUpper, state.level >= 2 and math.max(0, state.stock.bread - 6) or 0)
end

local function applyLevel()
    for _, item in ipairs(stall.Level2Shelf:GetDescendants()) do
        if item:IsA("BasePart") then item.Transparency = state.level >= 2 and 0 or 1 end
        if item:IsA("Light") then item.Enabled = state.level >= 2 end
    end
    updateDisplays()
end

local function syncOffer()
    if not owner then return end
    local offer = state.currentOffer
    owner:SetAttribute("K0OfferOpen", state.offerOpen and offer ~= nil)
    owner:SetAttribute("K0OfferId", offer and offer.id or 0)
    owner:SetAttribute("K0OfferSKU", offer and offer.sku or "")
    owner:SetAttribute("K0OfferUnits", offer and offer.units or 0)
    owner:SetAttribute("K0OfferAsk", offer and offer.ask or 0)
    owner:SetAttribute("K0OfferBid", offer and offer.bid or 0)
    owner:SetAttribute("K0OfferCounter", offer and offer.counter or 0)
    owner:SetAttribute("K0OfferType", offer and offer.kind or "")
    owner:SetAttribute("K0OfferSignal", offer and offer.signal or "")
end

local function updateWorldState()
    local activeCommerce = owner ~= nil and state.claimed and state.permit and not state.permitDue
    claimPrompt.Enabled = owner ~= nil and not state.claimed
    permitPrompt.Enabled = owner ~= nil and state.claimed and (not state.permit or state.permitDue)
    -- While the registration is lapsed the wholesale desks stay reachable as a
    -- liquidation route, so the player is never left without an available action.
    local liquidating = owner ~= nil and state.claimed and state.permitDue
    orangePrompt.Enabled = activeCommerce or (liquidating and state.stock.orange > 0)
    breadPrompt.Enabled = activeCommerce or (liquidating and state.stock.bread > 0)
    orangePrompt.ActionText = liquidating and "Tasfiye et" or "Stok al"
    breadPrompt.ActionText = liquidating and "Tasfiye et" or "Stok al"
    salePrompt.Enabled = activeCommerce and state.visitorState == "ready"
    upgradePrompt.Enabled = activeCommerce and state.level == 1
    hirePrompt.Enabled = activeCommerce and state.level >= 2 and not state.hired
    payPrompt.Enabled = owner ~= nil and state.claimed and state.hired and state.wagesDue

    if owner and state.claimed then
        local suffix = activeCommerce and (" | SEVİYE " .. state.level) or " | KAYIT BEKLİYOR"
        signText.Text = string.upper(owner.DisplayName) .. suffix
    elseif owner then
        signText.Text = "TEZGÂHI SAHİPLEN"
    else
        signText.Text = "TEST OTURUMU BEKLİYOR"
    end

    local demandProduct = C.Products[state.demandSKU]
    setDemandBoardText(string.upper(demandProduct.Name) .. "  +" .. math.floor(C.DemandBonusRatio * 100 + 0.5) .. "%")
    setBoardDetail(market:FindFirstChild("PermitOffice"), "PAZAR KAYDI " .. C.PermitFee .. " ₡")
    setBoardDetail(market:FindFirstChild("OrangeWholesale"), C.Products.orange.WholesaleBundle .. " " .. C.Products.orange.Unit .. "  /  " .. C.Products.orange.WholesaleCost .. " ₡")
    setBoardDetail(market:FindFirstChild("BreadWholesale"), C.Products.bread.WholesaleBundle .. " " .. C.Products.bread.Unit .. "  /  " .. C.Products.bread.WholesaleCost .. " ₡")
    -- The builders print fixed prices on these boards; the runtime owns the numbers.
    setBoardDetail(interaction:FindFirstChild("UpgradeBoard"), C.UpgradeCost .. " ₡ / DAHA ÇOK STOK")
    setBoardDetail(interaction:FindFirstChild("HireBoard"), C.HireCost .. " ₡ / OTOMATİK SATIŞ")
    setBoardDetail(interaction:FindFirstChild("PayBoard"), C.WagePerShift .. " ₡ / VARDİYA")
    setPriceTag(displays:FindFirstChild("OrangePrice"), "orange")
    setPriceTag(displays:FindFirstChild("BreadPrice"), "bread")
end

local function sync()
    if owner then
        local operatingCost = state.wholesaleSpent + state.permitSpent + state.wagesSpent
        local operatingResult = state.revenue - operatingCost
        local investmentSpent = state.upgradeSpent + state.hireSpent

        owner:SetAttribute("K0Owner", true)
        owner:SetAttribute("K0Cash", state.cash)
        owner:SetAttribute("K0Permit", state.permit)
        owner:SetAttribute("K0RentDue", state.permitDue)
        owner:SetAttribute("K0PermitRemaining", state.permitRemaining)
        owner:SetAttribute("K0Claimed", state.claimed)
        owner:SetAttribute("K0Level", state.level)
        owner:SetAttribute("K0OrangeStock", state.stock.orange)
        owner:SetAttribute("K0BreadStock", state.stock.bread)
        owner:SetAttribute("K0Sales", state.sales)
        owner:SetAttribute("K0Revenue", state.revenue)
        owner:SetAttribute("K0WholesaleSpent", state.wholesaleSpent)
        owner:SetAttribute("K0PermitSpent", state.permitSpent)
        owner:SetAttribute("K0WagesSpent", state.wagesSpent)
        owner:SetAttribute("K0OperatingCost", operatingCost)
        owner:SetAttribute("K0OperatingResult", operatingResult)
        owner:SetAttribute("K0InvestmentSpent", investmentSpent)
        owner:SetAttribute("K0LostSales", state.lostSales)
        owner:SetAttribute("K0Browsers", state.browsers)
        owner:SetAttribute("K0Passers", state.passers)
        owner:SetAttribute("K0Hired", state.hired)
        owner:SetAttribute("K0WagesDue", state.wagesDue)
        owner:SetAttribute("K0SalaryDue", state.wagesDue and C.WagePerShift or 0)
        owner:SetAttribute("K0ShiftRemaining", state.shiftRemaining)
        owner:SetAttribute("K0UpgradeCost", C.UpgradeCost)
        owner:SetAttribute("K0CustomerReady", state.visitorState == "ready")
        owner:SetAttribute("K0DemandSKU", state.demandSKU)
        owner:SetAttribute("K0DemandRemaining", state.demandRemaining)
        owner:SetAttribute("K0DemandBonusPercent", math.floor(C.DemandBonusRatio * 100 + 0.5))
        owner:SetAttribute("K0SessionSeconds", elapsedSeconds())
        owner:SetAttribute("K0FirstClaimSeconds", state.firstClaimSeconds)
        owner:SetAttribute("K0FirstStockSeconds", state.firstStockSeconds)
        owner:SetAttribute("K0FirstOfferSeconds", state.firstOfferSeconds)
        owner:SetAttribute("K0FirstDecisionSeconds", state.firstDecisionSeconds)
        owner:SetAttribute("K0FirstSaleSeconds", state.firstSaleSeconds)
        owner:SetAttribute("K0FirstUpgradeSeconds", state.firstUpgradeSeconds)
        owner:SetAttribute("K0FirstHireSeconds", state.firstHireSeconds)
        owner:SetAttribute("K0StockPurchases", state.stockPurchases)
        owner:SetAttribute("K0DemandAlignedPurchases", state.demandAlignedPurchases)
        owner:SetAttribute("K0AcceptCount", state.acceptCount)
        owner:SetAttribute("K0CounterCount", state.counterCount)
        owner:SetAttribute("K0CounterSuccess", state.counterSuccess)
        owner:SetAttribute("K0CounterFailure", state.counterFailure)
        owner:SetAttribute("K0DeclineCount", state.declineCount)
        owner:SetAttribute("K0PermitRenewals", state.permitRenewals)
        owner:SetAttribute("K0WagePayments", state.wagePayments)
        owner:SetAttribute("K0Liquidations", state.liquidations)
        owner:SetAttribute("K0LiquidationRevenue", state.liquidationRevenue)
        owner:SetAttribute("K0RescueGrants", state.rescueGrants)
        owner:SetAttribute("K0DeadEndSeconds", state.deadEndSeconds)
        owner:SetAttribute("K0TargetSessionSeconds", C.TargetSessionSeconds)
        owner:SetAttribute("K0SessionTargetReached", elapsedSeconds() >= C.TargetSessionSeconds)

        local stats = owner:FindFirstChild("leaderstats")
        local cashValue = stats and stats:FindFirstChild("Cash")
        if cashValue then cashValue.Value = state.cash end
        syncOffer()
    end
    updateWorldState()
end

local function npcPart(model, name, size, offset, color, position, shape)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.CFrame = CFrame.new(position + offset)
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.Color = color
    p.Material = Enum.Material.SmoothPlastic
    p.Shape = shape or Enum.PartType.Block
    p.Parent = model
    return p
end

local skins = {
    Color3.fromRGB(229, 188, 150), Color3.fromRGB(184, 125, 89),
    Color3.fromRGB(115, 77, 57), Color3.fromRGB(205, 155, 112),
}
local shirts = {
    Color3.fromRGB(111, 132, 89), Color3.fromRGB(191, 119, 83),
    Color3.fromRGB(85, 119, 153), Color3.fromRGB(222, 203, 171),
}

local function makeNpc(name, position, style)
    style = style or cosmeticRng:NextInteger(1, 4)
    local model = Instance.new("Model")
    model.Name = name
    local skin = skins[style]
    local root = npcPart(model, "Root", Vector3.new(0.3, 0.3, 0.3), Vector3.zero, Color3.new(1, 1, 1), position)
    root.Transparency = 1
    model.PrimaryPart = root
    npcPart(model, "Torso", Vector3.new(1.55, 1.7, 0.75), Vector3.new(0, 0.12, 0), shirts[style], position)
    npcPart(model, "Head", Vector3.new(1.15, 1.15, 1.15), Vector3.new(0, 1.56, 0), skin, position, Enum.PartType.Ball)
    npcPart(model, "Hair", Vector3.new(1.18, 0.48, 1.17), Vector3.new(0, 2.05, 0), Color3.fromRGB(47 + style * 9, 41 + style * 6, 38 + style * 4), position, Enum.PartType.Ball)
    for _, side in ipairs({-1, 1}) do
        npcPart(model, "Arm", Vector3.new(0.42, 1.55, 0.48), Vector3.new(side * 0.98, 0.04, 0), skin, position)
        npcPart(model, "Leg", Vector3.new(0.58, 1.6, 0.62), Vector3.new(side * 0.40, -1.62, 0), Color3.fromRGB(62, 66 + style * 10, 69 + style * 8), position)
        npcPart(model, "Shoe", Vector3.new(0.62, 0.22, 0.82), Vector3.new(side * 0.40, -2.47, -0.12), Color3.fromRGB(48, 43, 43), position)
        npcPart(model, "Eye", Vector3.new(0.095, 0.11, 0.05), Vector3.new(side * 0.25, 1.67, -0.54), Color3.fromRGB(40, 39, 36), position, Enum.PartType.Ball)
    end
    if style == 1 or style == 3 then
        npcPart(model, "Tote", Vector3.new(0.78, 0.82, 0.15), Vector3.new(-1.15, -0.72, -0.2), Color3.fromRGB(206, 192, 155), position)
        npcPart(model, "ToteHandle", Vector3.new(0.13, 0.55, 0.16), Vector3.new(-1.15, -0.16, -0.2), Color3.fromRGB(181, 166, 135), position)
    end
    -- One anchored root carries the whole figure (see moveNpc).
    for _, part in ipairs(model:GetChildren()) do
        if part:IsA("BasePart") and part ~= root then
            part.Anchored = false
            part.Massless = true
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = root
            weld.Part1 = part
            weld.Parent = part
        end
    end
    model.Parent = scene
    return model
end

local function bubble(model, message)
    if not model or not model.Parent then return end
    local head = model:FindFirstChild("Head")
    if not head then return end
    local gui = head:FindFirstChild("Talk")
    if not gui then
        gui = Instance.new("BillboardGui")
        gui.Name = "Talk"
        gui.Size = UDim2.fromOffset(190, 52)
        gui.StudsOffsetWorldSpace = Vector3.new(0, 1.8, 0)
        gui.AlwaysOnTop = true
        gui.Parent = head
        local line = Instance.new("TextLabel")
        line.Name = "Line"
        line.Size = UDim2.fromScale(1, 1)
        line.BackgroundColor3 = Color3.fromRGB(35, 43, 45)
        line.BackgroundTransparency = 0.08
        line.TextColor3 = Color3.fromRGB(237, 226, 206)
        line.Font = Enum.Font.GothamMedium
        line.TextSize = 14
        line.TextWrapped = true
        line.Parent = gui
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = line
    end
    gui.Line.Text = message
end

-- K0.4 tweened a CFrameValue and re-pivoted every anchored part of the figure
-- (up to 17) on each step, so each part's CFrame was written and replicated
-- separately. The parts are welded to one anchored root now and only the root
-- is tweened. The harness counts the drop in writes; the device and network
-- effect is not measured yet.
local function moveNpc(model, from, to, duration)
    if not model or not model.Parent then return end
    local root = model.PrimaryPart
    if not root then return end
    root.CFrame = CFrame.new(from)
    local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = CFrame.new(to)})
    tween:Play()
    tween.Completed:Wait()
end

local function feedback(price, sku)
    local parcel = Instance.new("Part")
    parcel.Name = "Sold_" .. sku
    parcel.Size = Vector3.new(0.7, 0.6, 0.6)
    parcel.Position = interaction.SalePoint.Position + Vector3.new(0, 2.1, 0)
    parcel.Anchored = true
    parcel.CanCollide = false
    parcel.CanTouch = false
    parcel.CanQuery = false
    parcel.Color = sku == "orange" and Color3.fromRGB(238, 143, 47) or Color3.fromRGB(212, 165, 100)
    parcel.Material = Enum.Material.SmoothPlastic
    parcel.Parent = scene
    TweenService:Create(parcel, TweenInfo.new(0.8), {Position = points.CustomerQueue.Position + Vector3.new(0, 1, 0), Transparency = 1}):Play()
    Debris:AddItem(parcel, 1)

    local marker = Instance.new("Part")
    marker.Name = "SaleAmount"
    marker.Size = Vector3.new(0.1, 0.1, 0.1)
    marker.Position = interaction.SalePoint.Position + Vector3.new(0, 4, 0)
    marker.Anchored = true
    marker.CanCollide = false
    marker.Transparency = 1
    marker.Parent = scene
    local gui = Instance.new("BillboardGui")
    gui.Size = UDim2.fromOffset(140, 45)
    gui.AlwaysOnTop = true
    gui.Parent = marker
    local t = Instance.new("TextLabel")
    t.Size = UDim2.fromScale(1, 1)
    t.BackgroundTransparency = 1
    t.Font = Enum.Font.GothamBold
    t.TextScaled = true
    t.TextStrokeTransparency = 0.2
    t.TextColor3 = Color3.fromRGB(238, 211, 115)
    t.Text = "+" .. price .. " ₡"
    t.Parent = gui
    TweenService:Create(marker, TweenInfo.new(1.1), {Position = marker.Position + Vector3.new(0, 2, 0)}):Play()
    Debris:AddItem(marker, 1.2)
end

local function commerceActive()
    return owner ~= nil and state.claimed and state.permit and not state.permitDue
end

local function completeSale(price, byWorker)
    local offer = state.currentOffer
    if not commerceActive() or state.visitorState ~= "ready" or not offer then return false end
    if state.stock[offer.sku] < offer.units then return false end

    state.visitorState = "sold"
    state.stock[offer.sku] -= offer.units
    state.cash += price
    state.sales += 1
    state.revenue += price
    state.offerOpen = false
    state.currentOffer = nil
    if state.firstSaleSeconds < 0 then milestone("sale") end
    updateDisplays()
    sync()
    feedback(price, offer.sku)
    bubble(visitor, byWorker and "Teşekkürler!" or "Anlaştık!")
    notice((byWorker and "Kasiyer: " or "Satış: ") .. C.Products[offer.sku].Name .. " " .. offer.units .. " " .. C.Products[offer.sku].Unit .. " / +" .. price .. " ₡")
    return true
end

local function weightedChoice(weights, order)
    local total = 0
    for _, key in ipairs(order) do total += weights[key] or 0 end
    local roll = economyRng:NextNumber() * total
    local sum = 0
    for _, key in ipairs(order) do
        sum += weights[key] or 0
        if roll <= sum then return key end
    end
    return order[#order]
end

local function pickVisitor()
    return weightedChoice(C.VisitorWeights, {"Passerby", "Browser", "Buyer", "Bargainer"})
end

local function pickBargainProfile()
    local total = 0
    for _, profile in ipairs(C.BargainProfiles) do total += profile.Weight end
    local roll = economyRng:NextNumber() * total
    local sum = 0
    for _, profile in ipairs(C.BargainProfiles) do
        sum += profile.Weight
        if roll <= sum then return profile end
    end
    return C.BargainProfiles[#C.BargainProfiles]
end

local function pickOffer(kind)
    local sku
    if economyRng:NextNumber() < C.DemandPickChance then
        sku = state.demandSKU
    else
        sku = state.demandSKU == "orange" and "bread" or "orange"
    end
    local other = sku == "orange" and "bread" or "orange"
    -- Draw unconditionally: K0.3 only rolled this when the shelf happened to be
    -- empty, so the number of draws per customer depended on the player's stock and
    -- the seeded sequence diverged between testers. The roll is now always spent.
    local swapRoll = economyRng:NextNumber()
    if state.stock[sku] == 0 and state.stock[other] > 0 and swapRoll < 0.8 then sku = other end

    local units = sku == "orange" and economyRng:NextInteger(1, 3) or economyRng:NextInteger(1, 2)
    offerSerial += 1
    local product = C.Products[sku]
    local demandMultiplier = sku == state.demandSKU and (1 + C.DemandBonusRatio) or 1
    local ask = math.max(1, math.floor(product.Retail * units * demandMultiplier + 0.5))

    if kind ~= "Bargainer" then
        return {id = offerSerial, sku = sku, units = units, ask = ask, bid = ask, counter = ask, kind = kind, signal = "ETİKET"}
    end

    local profile = pickBargainProfile()
    return {
        id = offerSerial,
        sku = sku,
        units = units,
        ask = ask,
        bid = math.max(1, math.floor(ask * C.BargainBidRatio + 0.5)),
        counter = math.max(1, math.floor(ask * C.BargainCounterRatio + 0.5)),
        maxBudget = math.max(1, math.floor(ask * profile.MaxRatio + 0.5)),
        kind = kind,
        signal = profile.Hint,
    }
end

local function clearVisitor()
    state.offerOpen = false
    state.currentOffer = nil
    state.visitorState = "none"
    -- K0.3 left the last customer's request on the prompt after they walked off,
    -- so the stall advertised an order nobody was waiting for.
    salePrompt.ObjectText = "Tezgâh"
    if visitor then visitor:Destroy(); visitor = nil end
    sync()
end

local function suspendCurrentOfferForPermit()
    if state.visitorState == "ready" then
        state.lostSales += 1
        state.visitorState = "permit_paused"
        state.offerOpen = false
        state.currentOffer = nil
        bubble(visitor, "Kayıt yenilenince gelirim.")
    end
end

claimPrompt.Triggered:Connect(function(player)
    if not guard(player, stall.NameSign) or state.claimed then return end
    state.claimed = true
    milestone("claim")
    TweenService:Create(stall.Canopy, TweenInfo.new(1), {Color = Color3.fromRGB(163, 74, 50)}):Play()
    sync()
    notice("Tezgâh artık senin. Şimdi Pazar Yönetimi'nde kayıt yap; sonra hangi ürüne stok bağlayacağına karar ver.")
end)

permitPrompt.Triggered:Connect(function(player)
    if not guard(player, market.PermitOffice) or not state.claimed then return end
    if state.permit and not state.permitDue then return end

    local fee = C.PermitFee
    local rescued = false
    if state.cash < fee or wouldStrand(fee) then
        -- Last-resort guard rail: only when the player cannot pay, or paying would
        -- leave an empty shelf and less than one unit's cash, AND no stock is left
        -- to liquidate. K0.4 charged all remaining cash here, which produced
        -- exactly the stranded state it was meant to prevent; K0.4.1 waives the
        -- fee instead. Bounded per session and written to telemetry so an observer
        -- sees that the economy needed rescuing. A prototype measurement aid, not
        -- a production rule.
        if totalStock() > 0 then
            notice("Pazar kaydı için " .. (fee - state.cash) .. " ₡ eksik. Toptancıda stoğunu tasfiye edebilirsin.")
            return
        end
        if state.rescueGrants >= (C.RescueGrantLimit or 1) then
            if state.cash < fee then
                notice("Pazar kaydı için " .. (fee - state.cash) .. " ₡ eksik ve tasfiye edilecek stok yok. Bu oturumda kurtarma hakkı kalmadı.")
            else
                strandNotice("Kayıt ücreti", fee)
            end
            reportDeadEnd()
            return
        end
        state.rescueGrants += 1
        fee = 0
        rescued = true
    end

    local wasRenewal = state.permit and state.permitDue
    state.cash -= fee
    state.permitSpent += fee
    if wasRenewal then state.permitRenewals += 1 end
    state.permit = true
    state.permitDue = false
    state.permitRemaining = C.PermitPeriodSeconds
    sync()
    if rescued then
        notice("KURTARMA: kasan kaydı ve yeni stoğu birlikte karşılamıyor, tasfiye edilecek stok da yok. Kayıt bu seferlik ücretsiz yenilendi; kasan " .. state.cash .. " ₡ ile stok alabilirsin. Gözlemci bunu kayda geçirsin.")
        print(string.format("[Baycrest K0] rescue_grant seconds=%d cash=%d waived=%d", elapsedSeconds(), state.cash, C.PermitFee))
    else
        notice("Pazar kaydı aktif. Talep panosuna bak ve toptancıdan ilk stok kararını ver.")
    end
end)

local function unitCost(product)
    -- Config guarantees WholesaleCost divides evenly by WholesaleBundle.
    return math.floor(product.WholesaleCost / product.WholesaleBundle)
end

local function capacityFor(sku)
    local product = C.Products[sku]
    return state.level >= 2 and product.Level2Capacity or product.Level1Capacity
end

-- K0.3 sold whole bundles only. Because Level1Capacity equals one bundle, a shelf
-- holding a single unsold unit could never be topped up: customers kept asking for
-- 2-3 units, the player could not buy more, and the loop stalled on lost sales with
-- no action available. K0.4 buys exactly what fits at the same per-unit price.
local function restock(player, sku, target)
    if not guard(player, target) or not commerceActive() then
        if player == owner and state.permitDue then notice("Önce Pazar Yönetimi'nde kaydı yenile.") end
        return
    end
    local product = C.Products[sku]
    local room = capacityFor(sku) - state.stock[sku]
    if room <= 0 then
        notice(product.Name .. " rafı dolu. Sat veya tezgâhı büyüt.")
        return
    end
    local perUnit = unitCost(product)
    local units = math.min(product.WholesaleBundle, room)
    local affordable = math.floor(state.cash / perUnit)
    if affordable < 1 then
        notice(product.Name .. " için " .. (perUnit - state.cash) .. " ₡ eksik (birim " .. perUnit .. " ₡).")
        return
    end
    units = math.min(units, affordable)
    local cost = units * perUnit

    state.cash -= cost
    state.wholesaleSpent += cost
    state.stock[sku] += units
    state.stockPurchases += 1
    if sku == state.demandSKU then state.demandAlignedPurchases += 1 end
    milestone("stock")
    updateDisplays()
    sync()
    local demandNote = sku == state.demandSKU and " Talep yüksek." or ""
    local partialNote = units < product.WholesaleBundle and " (rafa sığan kadar)" or ""
    notice(product.Name .. " +" .. units .. " " .. product.Unit .. partialNote .. " alındı; kasa -" .. cost .. " ₡." .. demandNote)
end

-- K0.4 dead-end exit. With the registration lapsed, commerce is halted: no customer
-- spawns, no sale is possible. K0.3 therefore had a terminal state — cash below the
-- renewal fee meant the session could never recover, and the simulated 22-minute run
-- reproduced it at t=1328s. The wholesaler now buys stock back at a loss while the
-- registration is lapsed, so the player always has an action and a real decision.
local function liquidate(player, sku, target)
    if not guard(player, target) then return end
    if not (state.claimed and state.permitDue) then return end
    local product = C.Products[sku]
    if state.stock[sku] <= 0 then
        notice(product.Name .. " stoğu yok. Diğer üründen tasfiye et veya kaydı yenile.")
        return
    end
    local perUnit = math.max(1, math.floor(product.Retail * (C.LiquidationRatio or 0.5) + 0.5))
    state.stock[sku] -= 1
    state.cash += perUnit
    state.revenue += perUnit
    state.liquidations += 1
    state.liquidationRevenue += perUnit
    updateDisplays()
    sync()
    notice("Tasfiye: 1 " .. product.Unit .. " " .. product.Name .. " toptancıya " .. perUnit .. " ₡ (etiket " .. product.Retail .. " ₡). Kayıt için " .. math.max(0, C.PermitFee - state.cash) .. " ₡ kaldı.")
end

local function wholesaleTrigger(player, sku, target)
    if state.permitDue then
        liquidate(player, sku, target)
    else
        restock(player, sku, target)
    end
end

orangePrompt.Triggered:Connect(function(player) wholesaleTrigger(player, "orange", market.OrangeWholesale) end)
breadPrompt.Triggered:Connect(function(player) wholesaleTrigger(player, "bread", market.BreadWholesale) end)

salePrompt.Triggered:Connect(function(player)
    if not guard(player, interaction.SalePoint) or not commerceActive() then return end
    if state.visitorState ~= "ready" or not state.currentOffer then return end
    state.offerOpen = true
    milestone("offer")
    syncOffer()
    if state.stock[state.currentOffer.sku] < state.currentOffer.units then
        notice("İstenen ürün stokta yetersiz. Toptancıdan al veya teklifi reddet.")
    end
end)

-- Remote traffic is rate limited per player before any state is read. Roblox's
-- security guidance treats validation and rate limiting as the primary defence;
-- K0.3 validated owner, range, type and offer id but accepted unlimited traffic.
local decisionBuckets = {}

local function acceptDecisionCall(player)
    local now = os.clock()
    local bucket = decisionBuckets[player]
    if not bucket or now - bucket.windowStart >= (C.DecisionRateWindow or 3) then
        decisionBuckets[player] = {windowStart = now, count = 1}
        return true
    end
    if bucket.count >= (C.DecisionRateLimit or 6) then
        return false
    end
    bucket.count += 1
    return true
end

decision.OnServerEvent:Connect(function(player, id, action)
    if not acceptDecisionCall(player) then return end
    if player ~= owner or not commerceActive() or not inRange(player, interaction.SalePoint) then return end
    -- Reject NaN/inf and non-integer ids before they reach the offer comparison.
    if type(id) ~= "number" or id ~= id or id % 1 ~= 0 then return end
    if type(action) ~= "string" then return end
    if action ~= "accept" and action ~= "counter" and action ~= "decline" then return end
    local offer = state.currentOffer
    if not offer or state.visitorState ~= "ready" or not state.offerOpen or id ~= offer.id then return end
    if action == "counter" and offer.kind ~= "Bargainer" then return end
    milestone("decision")

    if action == "decline" then
        state.declineCount += 1
        state.visitorState = "declined"
        state.lostSales += 1
        state.offerOpen = false
        state.currentOffer = nil
        bubble(visitor, "Başka yere bakayım.")
        sync()
        notice("Teklif reddedildi; stok değişmedi.")
        return
    end

    if state.stock[offer.sku] < offer.units then
        notice("Stok yetmiyor; satış yapılmadı.")
        return
    end

    if action == "accept" then
        state.acceptCount += 1
        completeSale(offer.bid, false)
    elseif action == "counter" and offer.kind == "Bargainer" then
        state.counterCount += 1
        if offer.counter <= offer.maxBudget then
            state.counterSuccess += 1
            completeSale(offer.counter, false)
        else
            state.counterFailure += 1
            state.visitorState = "declined"
            state.lostSales += 1
            state.offerOpen = false
            state.currentOffer = nil
            bubble(visitor, "Bütçemi aşıyor.")
            sync()
            notice("Karşı teklif reddedildi. Müşterinin bütçe sinyali " .. offer.signal .. " idi; ürün sende kaldı.")
        end
    end
end)

upgradePrompt.Triggered:Connect(function(player)
    if not guard(player, interaction.UpgradeBoard) or not commerceActive() or state.level ~= 1 then return end
    if state.cash < C.UpgradeCost then
        notice("Raflar için " .. (C.UpgradeCost - state.cash) .. " ₡ eksik.")
        return
    end
    if wouldStrand(C.UpgradeCost) then
        strandNotice("Raf yükseltmesi", C.UpgradeCost)
        return
    end
    state.cash -= C.UpgradeCost
    state.upgradeSpent += C.UpgradeCost
    state.level = 2
    milestone("upgrade")
    applyLevel()
    sync()
    notice("Seviye 2 rafları açıldı. Kapasiten büyüdü; kasiyer artık bir yatırım seçeneği.")
end)

hirePrompt.Triggered:Connect(function(player)
    if not guard(player, interaction.HireBoard) or not commerceActive() or state.level < 2 or state.hired then return end
    if state.cash < C.HireCost then
        notice("Kasiyer için " .. (C.HireCost - state.cash) .. " ₡ eksik.")
        return
    end
    if wouldStrand(C.HireCost) then
        strandNotice("Kasiyer ücreti", C.HireCost)
        return
    end
    state.cash -= C.HireCost
    state.hireSpent += C.HireCost
    state.hired = true
    state.wagesDue = false
    state.shiftRemaining = C.ShiftSeconds
    worker = makeNpc("Worker_K0", points.WorkerStand.Position, 2)
    milestone("hire")
    sync()
    notice("Kasiyer alındı. Normal alıcıları stok varsa servis eder; vardiya ücreti " .. C.WagePerShift .. " ₡.")
end)

payPrompt.Triggered:Connect(function(player)
    if not guard(player, interaction.PayBoard) or not state.hired or not state.wagesDue then return end
    if state.cash < C.WagePerShift then
        notice("Maaşa " .. (C.WagePerShift - state.cash) .. " ₡ eksik.")
        return
    end
    if wouldStrand(C.WagePerShift) then
        strandNotice("Maaş", C.WagePerShift)
        return
    end
    state.cash -= C.WagePerShift
    state.wagesSpent += C.WagePerShift
    state.wagePayments += 1
    state.wagesDue = false
    state.shiftRemaining = C.ShiftSeconds
    sync()
    notice("Kasiyer maaşı ödendi: -" .. C.WagePerShift .. " ₡.")
end)

-- `final` summaries (owner left, server closing) print once per session; the
-- target_20m line is a mid-session snapshot and does not count.
local function printSessionSummary(reason, final)
    if not owner then return end
    if final then
        if state.finalSummaryPrinted then return end
        state.finalSummaryPrinted = true
    end
    local seconds = elapsedSeconds()
    print(string.format(
        "[Baycrest K0] summary reason=%s seconds=%d claim=%d stock=%d offer=%d decision=%d sale=%d upgrade=%d hire=%d sales=%d revenue=%d operatingCost=%d operatingResult=%d lostSales=%d stockPurchases=%d demandAligned=%d accept=%d counter=%d counterSuccess=%d counterFailure=%d decline=%d renewals=%d wagePayments=%d liquidations=%d rescueGrants=%d deadEnd=%d cash=%d",
        reason, seconds, state.firstClaimSeconds, state.firstStockSeconds, state.firstOfferSeconds, state.firstDecisionSeconds,
        state.firstSaleSeconds, state.firstUpgradeSeconds, state.firstHireSeconds, state.sales, state.revenue,
        state.wholesaleSpent + state.permitSpent + state.wagesSpent,
        state.revenue - (state.wholesaleSpent + state.permitSpent + state.wagesSpent),
        state.lostSales, state.stockPurchases, state.demandAlignedPurchases, state.acceptCount, state.counterCount,
        state.counterSuccess, state.counterFailure, state.declineCount, state.permitRenewals, state.wagePayments,
        state.liquidations, state.rescueGrants, state.deadEndSeconds, state.cash
    ))
end

local function ensureLeaderstats(player)
    local stats = player:FindFirstChild("leaderstats")
    if not stats then
        stats = Instance.new("Folder")
        stats.Name = "leaderstats"
        stats.Parent = player
    end
    local value = stats:FindFirstChild("Cash")
    if not value then
        value = Instance.new("IntValue")
        value.Name = "Cash"
        value.Parent = stats
    end
end

local function setSpectator(player)
    ensureLeaderstats(player)
    local stats = player:FindFirstChild("leaderstats")
    local cashValue = stats and stats:FindFirstChild("Cash")
    if cashValue then cashValue.Value = 0 end
    player:SetAttribute("K0Owner", false)
    player:SetAttribute("K0Notice", "K0 tek satıcılı prototiptir. Bu oturumda izleyicisin.")
end

local function cleanupActors()
    if visitor then visitor:Destroy(); visitor = nil end
    if worker then worker:Destroy(); worker = nil end
    for _, child in ipairs(scene:GetChildren()) do
        if string.match(child.Name, "^Pedestrian_") or string.match(child.Name, "^PassingVisitor_") then
            child:Destroy()
        end
    end
    crowdCount = 0
end

local function assignOwner(player)
    ensureLeaderstats(player)
    cleanupActors()
    owner = player
    resetState()
    applyLevel()
    sync()
    notice("Önce tabeladan tezgâhı sahiplen. Sahiplik ücretsiz ve ilk dakikada görünür; satış için sonra pazar kaydı ve stok gerekir.")
end

-- The leaving player can still be listed when the deferred choice runs (the
-- order of PlayerRemoving handlers and the Parent change is an engine detail);
-- K0.4 then handed the stall back to the player who had just left and every
-- remaining player stayed a spectator.
local function chooseNextOwner(leaving)
    if owner then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= leaving and player.Parent == Players then
            assignOwner(player)
            return
        end
    end
    updateWorldState()
end

local function setupPlayer(player)
    if owner then setSpectator(player) else assignOwner(player) end
end

Players.PlayerAdded:Connect(setupPlayer)
for _, player in ipairs(Players:GetPlayers()) do setupPlayer(player) end
Players.PlayerRemoving:Connect(function(player)
    decisionBuckets[player] = nil
    if player ~= owner then return end
    printSessionSummary("owner_left", true)
    owner = nil
    cleanupActors()
    resetState()
    updateWorldState()
    task.defer(chooseNextOwner, player)
end)

-- Stopping a Studio test or shutting the server down must still leave the
-- session's summary line in Output for the test record.
game:BindToClose(function()
    printSessionSummary("server_close", true)
end)

-- Shared one-second clock: permit, wages, demand and session metrics.
task.spawn(function()
    while true do
        task.wait(1)
        if owner then
            if state.permit and not state.permitDue then
                state.permitRemaining = math.max(0, state.permitRemaining - 1)
                if state.permitRemaining == 0 then
                    state.permitDue = true
                    suspendCurrentOfferForPermit()
                    notice("Pazar kaydı yenileme zamanı. Satış ve stok yenileme, " .. C.PermitFee .. " ₡ ödeme yapılana kadar durdu.")
                end
            end

            if state.hired and not state.wagesDue then
                state.shiftRemaining = math.max(0, state.shiftRemaining - 1)
                if state.shiftRemaining == 0 then
                    state.wagesDue = true
                    notice("Kasiyer maaşı " .. C.WagePerShift .. " ₡ ödenene dek kasiyer durdu.")
                end
            end

            state.demandRemaining = math.max(0, state.demandRemaining - 1)
            if state.demandRemaining == 0 then
                state.demandSKU = state.demandSKU == "orange" and "bread" or "orange"
                state.demandRemaining = C.DemandCycleSeconds
                if state.claimed then
                    notice("Talep değişti: " .. C.Products[state.demandSKU].Name .. " şimdi daha güçlü.")
                end
            end
            if not state.targetSummaryPrinted and elapsedSeconds() >= C.TargetSessionSeconds then
                state.targetSummaryPrinted = true
                printSessionSummary("target_20m")
                notice("20 dakikalık K0 test hedefi doldu. Oyun durmadı; gözlemci devam edip etmediğini ayrıca kaydetsin.")
            end
            reportDeadEnd()
            sync()
        end
    end
end)

-- Decorative pedestrians. They never affect economy state.
task.spawn(function()
    while true do
        task.wait(cosmeticRng:NextInteger(C.CrowdGapMin, C.CrowdGapMax))
        if owner and crowdCount < 4 then
            -- Crowd walkers are decoration: they are not counted as passers-by.
            crowdCount += 1
            crowdSerial += 1
            task.spawn(function()
                local lane = cosmeticRng:NextInteger(1, 2) == 1 and -7 or -10
                local east = cosmeticRng:NextInteger(1, 2) == 1
                local start = Vector3.new(east and -39 or 39, 2.8, lane)
                local finish = Vector3.new(east and 39 or -39, 2.8, lane)
                local pedestrian = makeNpc("Pedestrian_" .. crowdSerial, start)
                moveNpc(pedestrian, start, finish, cosmeticRng:NextInteger(10, 15))
                if pedestrian and pedestrian.Parent then pedestrian:Destroy() end
                crowdCount = math.max(0, crowdCount - 1)
            end)
        end
    end
end)

local function waitForSession(seconds, serial)
    local deadline = os.clock() + seconds
    while os.clock() < deadline do
        if state.sessionSerial ~= serial then return false end
        task.wait(math.min(0.25, math.max(0.01, deadline - os.clock())))
    end
    return state.sessionSerial == serial
end

-- Customer loop. No customer is spawned until ownership, permit and stock-ready commerce are active.
--
-- K0.4 draw discipline: the seeded economy stream is touched only when a customer
-- is genuinely about to be served. K0.3 drew an arrival gap on every iteration of
-- this loop, including the whole setup phase and every registration pause, so two
-- testers who reached the same point at different speeds were already reading
-- different parts of the sequence. The controlled-playtest seed then guaranteed
-- nothing. Waiting for the gate before and after the gap keeps the customer
-- sequence identical across testers; only wall-clock timing differs.
local function gateOpen()
    return commerceActive()
        and (state.stock.orange > 0 or state.stock.bread > 0)
        and not visitor
end

local function waitForGate(serial)
    while owner and state.sessionSerial == serial and not gateOpen() do
        task.wait(0.25)
    end
    return owner ~= nil and state.sessionSerial == serial and gateOpen()
end

task.spawn(function()
    while true do
        if not owner then
            task.wait(0.25)
            continue
        end
        local serial = state.sessionSerial
        if not waitForGate(serial) then
            continue
        end
        local gap = economyRng:NextInteger(C.ArrivalGapMin, C.ArrivalGapMax)
        if not waitForSession(gap, serial) then
            continue
        end
        if not waitForGate(serial) then
            continue
        end
        if commerceActive() and not visitor then
            local kind = pickVisitor()
            local entry = points.CustomerEntry.Position
            local queue = points.CustomerQueue.Position
            local exitPoint = points.CustomerExit.Position

            if kind == "Passerby" then
                state.passers += 1
                if owner then owner:SetAttribute("K0Passers", state.passers) end
                local passer = makeNpc("PassingVisitor_" .. state.passers, entry)
                moveNpc(passer, entry, exitPoint, economyRng:NextInteger(8, 12))
                if passer and passer.Parent then passer:Destroy() end
            else
                visitor = makeNpc("Visitor_" .. (offerSerial + 1), entry)
                state.visitorState = "walking"
                sync()
                moveNpc(visitor, entry, queue, economyRng:NextInteger(C.ShopperWalkMin, C.ShopperWalkMax))

                if visitor and visitor.Parent and owner and commerceActive() then
                    if kind == "Browser" then
                        state.browsers += 1
                        owner:SetAttribute("K0Browsers", state.browsers)
                        state.visitorState = "browsing"
                        bubble(visitor, "Sadece bakıyorum.")
                        task.wait(economyRng:NextInteger(3, 8))
                    else
                        state.currentOffer = pickOffer(kind)
                        state.visitorState = "ready"
                        state.offerOpen = false
                        local p = C.Products[state.currentOffer.sku]
                        bubble(visitor, p.Name .. " " .. state.currentOffer.units .. " " .. p.Unit .. "?")
                        salePrompt.ObjectText = p.Name .. " " .. state.currentOffer.units .. " " .. p.Unit
                        sync()
                        local note = kind == "Bargainer" and ("Pazarlıkçı geldi; bütçe sinyali " .. state.currentOffer.signal .. ".") or "Alıcı geldi."
                        notice(note .. " Tezgahta E ile teklifi aç.")

                        local thisId = state.currentOffer.id
                        if state.hired and not state.wagesDue and kind == "Buyer" then
                            task.delay(C.WorkerResponseSeconds, function()
                                if owner and commerceActive() and state.currentOffer and state.currentOffer.id == thisId and state.visitorState == "ready" and state.hired and not state.wagesDue then
                                    completeSale(state.currentOffer.ask, true)
                                end
                            end)
                        end

                        local deadline = os.clock() + economyRng:NextInteger(C.PatienceMin, C.PatienceMax)
                        while owner and commerceActive() and state.visitorState == "ready" and os.clock() < deadline do task.wait(0.25) end
                        if state.visitorState == "ready" then
                            state.lostSales += 1
                            state.visitorState = "left"
                            state.offerOpen = false
                            state.currentOffer = nil
                            bubble(visitor, "Bekleyemem.")
                            notice("Alıcı beklemekten vazgeçti; stok değişmedi.")
                        end
                    end
                    sync()
                    if visitor and visitor.Parent then moveNpc(visitor, queue, exitPoint, economyRng:NextInteger(3, 5)) end
                end
                clearVisitor()
            end
        end
    end
end)

sync()
print("Baycrest K0 market server ready", Config.Version)
