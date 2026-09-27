-- Baycrest K0 Market HUD (version: K0MarketConfig.Version)
-- Read-only state presentation. All economic decisions are validated by the server.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local Config = require(ReplicatedStorage:WaitForChild("K0MarketConfig"))
local C = Config.Prototype
local decision = ReplicatedStorage:WaitForChild("K0MarketDecision")

local gui = Instance.new("ScreenGui")
gui.Name = "BaycrestK0MarketHUD"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.Parent = player:WaitForChild("PlayerGui")

local cream = Color3.fromRGB(237, 226, 206)
local accent = Color3.fromRGB(235, 153, 105)
local dark = Color3.fromRGB(35, 43, 45)
local muted = Color3.fromRGB(174, 181, 176)
local good = Color3.fromRGB(162, 196, 139)

local function frame(name, size, pos, anchor)
    local p = Instance.new("Frame")
    p.Name = name
    p.Size = size
    p.Position = pos
    p.AnchorPoint = anchor or Vector2.zero
    p.BackgroundColor3 = dark
    p.BackgroundTransparency = 0.06
    p.Parent = gui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = p
    local stroke = Instance.new("UIStroke")
    stroke.Color = accent
    stroke.Thickness = 2
    stroke.Parent = p
    return p
end

local function label(parent, name, text, y, height, size, color)
    local t = Instance.new("TextLabel")
    t.Name = name
    t.Position = UDim2.new(0, 14, 0, y)
    t.Size = UDim2.new(1, -28, 0, height)
    t.BackgroundTransparency = 1
    t.Font = Enum.Font.GothamMedium
    t.TextSize = size
    t.TextColor3 = color or cream
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextYAlignment = Enum.TextYAlignment.Center
    t.TextWrapped = true
    t.Text = text
    t.Parent = parent
    return t
end

-- K0.4.3 greybox icons (ASSET-PROMPTS/07-UI-ICONOGRAPHY.md). Until the image set
-- exists, each icon is a few filled UI frames on a 24 px grid with one base colour
-- and at most one accent. The SHAPE carries the meaning (round orange, long bread,
-- an arrow for demand, a fill level for the budget), so nothing depends on colour
-- alone. Icons sit beside the text and the text stays: they speed up scanning,
-- they do not replace it.
local ROUND = UDim.new(0.5, 0)
local gold = Color3.fromRGB(230, 184, 92)
local orangeFruit = Color3.fromRGB(238, 143, 47)
local breadCrust = Color3.fromRGB(205, 151, 87)

local function shape(parent, name, w, h, x, y, color, corner, rotation)
    local s = Instance.new("Frame")
    s.Name = name
    s.AnchorPoint = Vector2.new(0.5, 0.5)
    s.Size = UDim2.fromOffset(w, h)
    s.Position = UDim2.fromOffset(x, y)
    s.BackgroundColor3 = color
    s.BorderSizePixel = 0
    s.Rotation = rotation or 0
    s.Parent = parent
    if corner then
        local c = Instance.new("UICorner")
        c.CornerRadius = corner
        c.Parent = s
    end
    return s
end

local drawIcon = {
    Cash = function(box)
        for i, y in ipairs({18, 13, 8}) do
            local coin = shape(box, "Coin" .. i, 18, 7, 12, y, gold, ROUND)
            local rim = Instance.new("UIStroke")
            rim.Color = dark
            rim.Thickness = 2
            rim.Parent = coin
        end
    end,
    Orange = function(box)
        shape(box, "Fruit", 18, 18, 12, 13, orangeFruit, ROUND)
        shape(box, "Leaf", 7, 4, 15, 4, good, ROUND, -30)
    end,
    Bread = function(box)
        shape(box, "Loaf", 22, 12, 12, 13, breadCrust, UDim.new(0, 6))
        shape(box, "Slash1", 3, 8, 9, 13, dark, nil, 30)
        shape(box, "Slash2", 3, 8, 15, 13, dark, nil, 30)
    end,
    DemandUp = function(box)
        shape(box, "Shaft", 4, 12, 12, 13, good)
        shape(box, "HeadLeft", 4, 11, 9, 8, good, nil, 45)
        shape(box, "HeadRight", 4, 11, 15, 8, good, nil, -45)
        shape(box, "Base", 16, 3, 12, 21, good)
    end,
    Permit = function(box)
        shape(box, "Sheet", 16, 20, 12, 12, cream, UDim.new(0, 2))
        shape(box, "Fold", 8, 8, 20, 2, dark, nil, 45)
        shape(box, "Line", 8, 2, 10, 8, dark)
        shape(box, "Seal", 7, 7, 12, 16, accent, ROUND)
    end,
    -- One capsule, three fill levels (ASSET-PROMPTS/07 "Bütçe sinyali tasarım
    -- kararı"): the player reads how much room there is, not a symbol.
    Budget = function(box)
        local capsule = shape(box, "Capsule", 12, 24, 12, 12, dark, ROUND)
        capsule.BackgroundTransparency = 1
        local outline = Instance.new("UIStroke")
        outline.Color = cream
        outline.Thickness = 2
        outline.Parent = capsule
        local level = shape(box, "Level", 6, 18, 12, 21, good, UDim.new(0, 3))
        level.AnchorPoint = Vector2.new(0.5, 1)
    end,
}

local function icon(parent, kind, x, y)
    local box = Instance.new("Frame")
    box.Name = "Icon" .. kind
    box.Size = UDim2.fromOffset(24, 24)
    box.Position = UDim2.fromOffset(x, y)
    box.BackgroundTransparency = 1
    box.Parent = parent
    drawIcon[kind](box)
    return box
end

-- Moves a label right of its icon; the box keeps its 14 px right margin.
local function indent(t, x, y)
    t.Position = UDim2.new(0, x, 0, y or t.Position.Y.Offset)
    t.Size = UDim2.new(1, -(x + 14), 0, t.Size.Y.Offset)
end

local status = frame("Status", UDim2.fromOffset(410, 334), UDim2.fromOffset(18, 18))
local statusScale = Instance.new("UIScale")
statusScale.Parent = status
local title = label(status, "Title", "BAYCREST / K0 PAZAR", 8, 27, 18, accent)
title.Font = Enum.Font.GothamBold
local cashLabel = label(status, "Cash", "Kasa", 42, 29, 23, cream)
local ownershipLabel = label(status, "Ownership", "Tezgâh", 75, 24, 16, cream)
local permitLabel = label(status, "Permit", "Pazar kaydı", 101, 24, 16, cream)
local demandLabel = label(status, "Demand", "Talep", 127, 24, 16, good)
local stockLabel = label(status, "Stock", "Portakal", 153, 24, 15, cream)
local breadLabel = label(status, "BreadStock", "Ekmek", 153, 24, 15, cream)
-- K0.4 put five figures on one 30 px line; with real numbers it wrapped to two
-- lines and the second was clipped. Flow and result now have a line each.
local resultLabel = label(status, "Result", "Satış", 179, 22, 14, cream)
local profitLabel = label(status, "Profit", "Sonuç", 201, 22, 14, cream)
local workerLabel = label(status, "Worker", "Kasiyer", 225, 24, 14, cream)
local goalLabel = label(status, "Goal", "Hedef", 251, 52, 14, accent)

local statusIcons = {
    icon(status, "Cash", 14, 44),
    icon(status, "Permit", 14, 101),
    icon(status, "DemandUp", 14, 127),
    icon(status, "Orange", 14, 153),
    icon(status, "Bread", 204, 153),
}
indent(cashLabel, 46)
indent(permitLabel, 46)
indent(demandLabel, 46)
indent(stockLabel, 46)
stockLabel.Size = UDim2.fromOffset(150, 24)
indent(breadLabel, 236)

local track = Instance.new("Frame")
track.Name = "UpgradeTrack"
track.Size = UDim2.new(1, -28, 0, 9)
track.Position = UDim2.new(0, 14, 0, 313)
track.BackgroundColor3 = Color3.fromRGB(68, 73, 70)
track.BorderSizePixel = 0
track.Parent = status
local fill = Instance.new("Frame")
fill.Name = "Fill"
fill.Size = UDim2.fromScale(0, 1)
fill.BackgroundColor3 = accent
fill.BorderSizePixel = 0
fill.Parent = track

local help = frame("Help", UDim2.fromOffset(620, 72), UDim2.new(0, 18, 1, -90))
local helpScale = Instance.new("UIScale")
helpScale.Parent = help
local helpText = label(help, "HelpText", "Önce tezgâhı sahiplen.", 6, 60, 15, cream)

-- Four lines at 15 px: the longest K0 notice (rescue) needs about four.
local toast = frame("Notice", UDim2.fromOffset(510, 86), UDim2.new(0.5, 0, 0, 18), Vector2.new(0.5, 0))
local toastScale = Instance.new("UIScale")
toastScale.Parent = toast
local toastText = label(toast, "NoticeText", "", 5, 76, 15, cream)
toast.Visible = false

local offer = frame("Offer", UDim2.fromOffset(490, 244), UDim2.new(0.5, 0, 0.5, 0), Vector2.new(0.5, 0.5))
local offerScale = Instance.new("UIScale")
offerScale.Parent = offer
offer.Visible = false
local offerTitle = label(offer, "OfferTitle", "Müşteri teklifi", 10, 30, 21, accent)
offerTitle.Font = Enum.Font.GothamBold
local offerDetail = label(offer, "OfferDetail", "", 45, 58, 17, cream)
local offerSignal = label(offer, "OfferSignal", "", 105, 24, 14, good)
local offerStock = label(offer, "OfferStock", "", 131, 24, 14, muted)
local offerOrange = icon(offer, "Orange", 14, 49)
local offerBread = icon(offer, "Bread", 14, 49)
local offerBudget = icon(offer, "Budget", 14, 105)
local budgetLevel = offerBudget.Level
indent(offerDetail, 48)
indent(offerSignal, 48)
indent(offerStock, 48)

-- Fill rank follows each profile's MaxRatio, so the tightest budget is the
-- lowest level whatever order the config lists them in.
local budgetFill = {}
do
    local ranked = table.clone(C.BargainProfiles)
    table.sort(ranked, function(a, b) return a.MaxRatio < b.MaxRatio end)
    for i, profile in ipairs(ranked) do budgetFill[profile.Hint] = i / #ranked end
end

local function button(name, x, text)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Position = UDim2.new(0, x, 0, 174)
    b.Size = UDim2.fromOffset(146, 54)
    b.BackgroundColor3 = Color3.fromRGB(160, 83, 59)
    b.TextColor3 = cream
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 15
    b.TextWrapped = true
    b.Parent = offer
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = b
    return b
end

-- Texts are set on render: the 1/2/3 shortcut appears only with a keyboard.
local accept = button("Accept", 14, "Sat")
local counter = button("Counter", 172, "Karşı teklif")
local decline = button("Decline", 330, "Reddet")
counter.BackgroundColor3 = Color3.fromRGB(92, 116, 77)
decline.BackgroundColor3 = Color3.fromRGB(70, 76, 78)

-- K0.4.4 phone-first layout (EKIP/06 §1 "Telefon önce", §5 44×44 px touch
-- targets). The HUD lays out in the ScreenGui's own AbsoluteSize, which already
-- leaves out the Roblox top bar. A phone is what Roblox's touch controls also
-- call a small screen: the shorter side is at most 500 px. On a phone the status
-- panel keeps the left half, notices and help stack on the right, and the offer
-- buttons stay out of the bottom-right corner where the default jump button sits
-- (PlayerModule TouchJump: 70 px, 25 px from the right, 20 px from the bottom).
-- All sizes are estimates until the device test.
local TAP_MIN = 44
local JUMP_CLEAR_X, JUMP_CLEAR_Y = 100, 95
local STATUS_W, STATUS_H = 410, 334

local function place(obj, x, y, anchorX, anchorY)
    obj.AnchorPoint = Vector2.new(anchorX or 0, anchorY or 0)
    obj.Position = UDim2.fromOffset(x, y)
end

local function layoutButtons(y, width, height, xs)
    for i, b in ipairs({accept, counter, decline}) do
        b.Position = UDim2.fromOffset(xs[i], y)
        b.Size = UDim2.fromOffset(width, height)
    end
end

local function updateScale()
    local area = gui.AbsoluteSize
    local W, H = area.X, area.Y
    if W <= 0 or H <= 0 then return end
    local phone = math.min(W, H) <= 500

    local s
    if phone then
        s = math.min(1, (H - 36) / STATUS_H, (W / 2 - 24) / STATUS_W)
    else
        s = math.min(math.clamp(W / 760, 0.72, 1), math.clamp(H / 650, 0.76, 1))
    end
    statusScale.Scale = s
    local statusRight = 18 + STATUS_W * s

    if phone then
        -- Right column: notice on top, help under it, both above the jump button.
        local x0 = statusRight + 12
        local r = math.min(1, (W - 18 - x0) / 400, (H - 18 - JUMP_CLEAR_Y) / 216)
        toast.Size = UDim2.fromOffset(400, 104)
        toastText.Size = UDim2.new(1, -28, 0, 94)
        toastScale.Scale = r
        place(toast, x0, 18)
        help.Size = UDim2.fromOffset(400, 104)
        helpText.Size = UDim2.new(1, -28, 0, 92)
        helpScale.Scale = r
        place(help, x0, 18 + 112 * r)

        -- One row of three tall buttons. K0.4.3 stacked them on narrow screens,
        -- which made the card too tall for a landscape phone and shrank each
        -- button to about 37 px.
        offer.Size = UDim2.fromOffset(440, 236)
        indent(offerDetail, 48, 45)
        indent(offerSignal, 48, 105)
        indent(offerStock, 48, 131)
        layoutButtons(162, 130, 62, {14, 155, 296})
        local o = math.min(1, (W - 24) / 440, (H - 16) / 236)
        offerScale.Scale = o
        place(offer, math.min(W / 2, W - JUMP_CLEAR_X - 220 * o), H / 2, 0.5, 0.5)
    else
        -- The notice uses the free width right of the status panel so it never
        -- covers the cash line (K0.4.3 centred it over the panel's right edge).
        local free = W - 18 - (statusRight + 12)
        local t = math.min(1, free / 510)
        toast.Size = UDim2.fromOffset(510, 86)
        toastText.Size = UDim2.new(1, -28, 0, 76)
        toastScale.Scale = t
        place(toast, statusRight + 12 + (free - 510 * t) / 2, 18)
        help.Size = UDim2.fromOffset(620, 72)
        helpText.Size = UDim2.new(1, -28, 0, 60)
        helpScale.Scale = math.min(math.clamp(W / 760, 0.56, 1), math.clamp(H / 650, 0.72, 1), (W - 36) / 620)
        place(help, 18, H - 18, 0, 1)

        offer.Size = UDim2.fromOffset(490, 244)
        indent(offerDetail, 48, 45)
        indent(offerSignal, 48, 105)
        indent(offerStock, 48, 131)
        layoutButtons(174, 146, 54, {14, 172, 330})
        local o = math.clamp(math.min(W / 920, H / 650), TAP_MIN / 54, 1)
        offerScale.Scale = o
        place(offer, W / 2, H / 2, 0.5, 0.5)
    end
end
updateScale()
gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScale)

-- K0.4.2 sound cues (ASSET-PROMPTS/06-SFX.md). Sound only repeats what the HUD
-- already shows (EKIP/06 §8), plays for the seller only, and never for the state
-- found on the first render or after an owner handover.
local sounds = {}
local function play(name)
    local spec = Config.Sounds and Config.Sounds[name]
    if type(spec) ~= "table" or type(spec.Id) ~= "string" or spec.Id == "" then return end
    local sound = sounds[name]
    if not sound then
        sound = Instance.new("Sound")
        sound.Name = "K0Sfx_" .. name
        sound.SoundId = spec.Id
        sound.Volume = spec.Volume or 0.5
        sound.Parent = SoundService
        sounds[name] = sound
    end
    sound:Play()
end

-- One server update changes several attributes. The changes are collected and
-- resolved once, so one event plays one cue whatever the signal behaviour.
local CUE_ORDER = {"PermitLapse", "Upgrade", "Hire", "SaleSuccess", "SaleFail", "Liquidate",
    "StockPlace", "CustomerArrive", "Negotiate", "Notify"}
local CASH_AFTER_SALE = 0.12 -- seconds; 06-SFX: sale and cash read as one event
local heard = nil
local pending = nil

local function flushCues()
    local batch = pending
    pending = nil
    if not batch then return end
    -- A lapse pauses the waiting customer, which the server also counts as a lost sale.
    if batch.PermitLapse then batch.SaleFail = nil end
    -- A notice that accompanies another cue stays silent.
    for name in pairs(batch) do
        if name ~= "Notify" then batch.Notify = nil break end
    end
    for _, name in ipairs(CUE_ORDER) do
        if batch[name] then play(name) end
    end
    if batch.SaleSuccess then task.delay(CASH_AFTER_SALE, play, "Cash") end
end

local function want(name)
    if not pending then
        pending = {}
        task.defer(flushCues)
    end
    pending[name] = true
end

local function listen()
    if player:GetAttribute("K0Owner") ~= true then
        heard = nil
        return
    end
    local now = {
        sales = player:GetAttribute("K0Sales") or 0,
        lost = player:GetAttribute("K0LostSales") or 0,
        stock = player:GetAttribute("K0StockPurchases") or 0,
        liquidations = player:GetAttribute("K0Liquidations") or 0,
        ready = player:GetAttribute("K0CustomerReady") == true,
        bargain = (player:GetAttribute("K0OfferOpen") == true and player:GetAttribute("K0OfferType") == "Bargainer")
            and (player:GetAttribute("K0OfferId") or 0) or 0,
        level = player:GetAttribute("K0Level") or 1,
        hired = player:GetAttribute("K0Hired") == true,
        lapsed = player:GetAttribute("K0RentDue") == true,
        notice = player:GetAttribute("K0NoticeSerial") or 0,
    }
    local before = heard
    heard = now
    if not before then return end
    if now.sales > before.sales then want("SaleSuccess") end
    if now.lost > before.lost then want("SaleFail") end
    if now.stock > before.stock then want("StockPlace") end
    if now.liquidations > before.liquidations then want("Liquidate") end
    if now.ready and not before.ready then want("CustomerArrive") end
    if now.bargain ~= 0 and now.bargain ~= before.bargain then want("Negotiate") end
    if now.level > before.level then want("Upgrade") end
    if now.hired and not before.hired then want("Hire") end
    if now.lapsed and not before.lapsed then want("PermitLapse") end
    if now.notice ~= before.notice then want("Notify") end
end

local function send(action)
    if not offer.Visible then return end
    local id = player:GetAttribute("K0OfferId")
    if type(id) == "number" and id > 0 then
        play("UiClick")
        decision:FireServer(id, action)
    end
end
accept.Activated:Connect(function() send("accept") end)
counter.Activated:Connect(function() send("counter") end)
decline.Activated:Connect(function() send("decline") end)

UserInputService.InputBegan:Connect(function(input, handled)
    if handled or not offer.Visible then return end
    if input.KeyCode == Enum.KeyCode.One then send("accept") end
    if input.KeyCode == Enum.KeyCode.Two and counter.Visible then send("counter") end
    if input.KeyCode == Enum.KeyCode.Three then send("decline") end
end)

local lastNotice = -1

-- K0.4.4: a phone has no E key and no number row. The stall prompts are held
-- (HoldDuration > 0) and show their own on-screen button on touch devices, so
-- help names the key only when a keyboard exists, and the offer buttons carry
-- their 1/2/3 shortcut only then.
local function hasKeyboard()
    return UserInputService.KeyboardEnabled
end

local function promptHowTo()
    return hasKeyboard() and "E'yi basılı tut" or "çıkan düğmeye basılı tut"
end

local function keyHint(n)
    return hasKeyboard() and (n .. "  ") or ""
end

local function productName(sku)
    local p = C.Products[sku]
    return p and p.Name or "—"
end

local function render()
    if player:GetAttribute("K0Owner") == false then
        cashLabel.Text = "K0 tek satıcılı test"
        ownershipLabel.Text = "Bu oturumda izleyicisin"
        permitLabel.Text = ""
        demandLabel.Text = ""
        stockLabel.Text = ""
        breadLabel.Text = ""
        for _, i in ipairs(statusIcons) do i.Visible = false end
        resultLabel.Text = ""
        profitLabel.Text = ""
        workerLabel.Text = ""
        goalLabel.Text = ""
        offer.Visible = false
        return
    end

    local cash = player:GetAttribute("K0Cash") or 0
    local permit = player:GetAttribute("K0Permit") or false
    local claimed = player:GetAttribute("K0Claimed") or false
    local permitDue = player:GetAttribute("K0RentDue") or false
    local level = player:GetAttribute("K0Level") or 1
    local orange = player:GetAttribute("K0OrangeStock") or 0
    local bread = player:GetAttribute("K0BreadStock") or 0
    local sold = player:GetAttribute("K0Sales") or 0
    local revenue = player:GetAttribute("K0Revenue") or 0
    local operatingCost = player:GetAttribute("K0OperatingCost") or 0
    local operatingResult = player:GetAttribute("K0OperatingResult") or 0
    local investment = player:GetAttribute("K0InvestmentSpent") or 0
    local due = player:GetAttribute("K0WagesDue") or false
    local hired = player:GetAttribute("K0Hired") or false
    local demandSKU = player:GetAttribute("K0DemandSKU") or "orange"
    local demandRemaining = player:GetAttribute("K0DemandRemaining") or 0
    local demandBonus = player:GetAttribute("K0DemandBonusPercent") or 0
    local rescues = player:GetAttribute("K0RescueGrants") or 0
    local deadEnd = (player:GetAttribute("K0DeadEndSeconds") or -1) >= 0

    for _, i in ipairs(statusIcons) do i.Visible = true end
    cashLabel.Text = "Kasa  " .. cash .. " ₡"
    ownershipLabel.Text = claimed and ("Benim tezgâhım / Seviye " .. level) or "Sahiplik: henüz yok"
    if not claimed then
        permitLabel.Text = "Pazar kaydı: sahiplikten sonra"
    elseif not permit then
        permitLabel.Text = "Pazar kaydı yok / " .. C.PermitFee .. " ₡"
    elseif permitDue then
        permitLabel.Text = "Pazar kaydı YENİLE / " .. C.PermitFee .. " ₡"
    else
        permitLabel.Text = "Pazar kaydı: " .. (player:GetAttribute("K0PermitRemaining") or 0) .. " sn"
    end
    demandLabel.Text = "Talep  " .. productName(demandSKU) .. "  +" .. demandBonus .. "%  /  " .. demandRemaining .. " sn"
    stockLabel.Text = C.Products.orange.Name .. " " .. orange .. " " .. C.Products.orange.Unit
    breadLabel.Text = C.Products.bread.Name .. " " .. bread .. " " .. C.Products.bread.Unit
    resultLabel.Text = "Satış " .. sold .. "  |  Ciro " .. revenue .. " ₡  |  Gider " .. operatingCost .. " ₡"
    profitLabel.Text = "Sonuç " .. operatingResult .. " ₡  |  Yatırım " .. investment .. " ₡"
    profitLabel.TextColor3 = operatingResult < 0 and accent or cream
    workerLabel.Text = hired and (due and ("Kasiyer: " .. C.WagePerShift .. " ₡ maaş bekliyor") or ("Kasiyer: " .. (player:GetAttribute("K0ShiftRemaining") or 0) .. " sn")) or "Kasiyer: yok"

    local cost = player:GetAttribute("K0UpgradeCost") or C.UpgradeCost
    fill.Size = UDim2.fromScale(claimed and (level >= 2 and 1 or math.clamp(cash / cost, 0, 1)) or 0, 1)

    if not claimed then
        goalLabel.Text = "1 / İlk dakikada tezgâhı sahiplen."
        helpText.Text = "Tezgâh tabelasına yaklaş ve " .. promptHowTo() .. ". Sahiplik ücretsiz; ekonomi kararı bundan sonra başlar."
    elseif not permit then
        goalLabel.Text = "2 / Pazar Yönetimi'nde " .. C.PermitFee .. " ₡ kayıt yap."
        helpText.Text = "Sahiplik sende. Satış açmak için soldaki yönetim panosunda kaydı tamamla."
    elseif deadEnd then
        goalLabel.Text = "Ekonomik çıkmaz: kasa ve stok ticarete dönmeye yetmiyor."
        helpText.Text = "Bu oturumda kurtarma hakkı kullanıldı. Gözlemci çıkmaz anını kayda geçirsin; oturumun kalanı ekonomi ölçümü sayılmaz."
    elseif permitDue then
        goalLabel.Text = "Pazar kaydı bitti; ticaret geçici olarak durdu."
        local minUnit = math.min(math.floor(C.Products.orange.WholesaleCost / C.Products.orange.WholesaleBundle),
            math.floor(C.Products.bread.WholesaleCost / C.Products.bread.WholesaleBundle))
        if cash >= C.PermitFee and (orange + bread > 0 or cash >= C.PermitFee + minUnit) then
            helpText.Text = "Pazar Yönetimi'nde " .. C.PermitFee .. " ₡ yenile. Tezgâh ve stok sende kalır; yalnız ticaret bekler."
        elseif orange + bread > 0 then
            helpText.Text = "Kasan " .. C.PermitFee .. " ₡ kaydı karşılamıyor. Toptancıda stoğunu zararına tasfiye edip kaydı yenileyebilirsin: bu bir karar, çıkmaz değil."
        elseif rescues < (C.RescueGrantLimit or 1) then
            helpText.Text = "Kasan kaydı ve yeni stoğu birlikte karşılamıyor, tasfiye edilecek stok yok. Pazar Yönetimi bu oturumda bir kez kaydı ücretsiz yeniler; gözlemci bunu kayda geçirsin."
        else
            helpText.Text = "Kasan kaydı karşılamıyor ve bu oturumdaki kurtarma hakkı kullanıldı."
        end
    elseif orange + bread == 0 then
        goalLabel.Text = "3 / Talebe göre ilk stok kararını ver."
        helpText.Text = C.Products.orange.Name .. " " .. C.Products.orange.WholesaleBundle .. " " .. C.Products.orange.Unit .. " / " .. C.Products.orange.WholesaleCost .. " ₡, " .. C.Products.bread.Name .. " " .. C.Products.bread.WholesaleBundle .. " " .. C.Products.bread.Unit .. " / " .. C.Products.bread.WholesaleCost .. " ₡. Üstteki talep göstergesi hangi ürünün daha yüksek fiyata gittiğini söyler."
    elseif level == 1 then
        goalLabel.Text = "Büyüme: " .. cost .. " ₡ gerekli; eksik " .. math.max(0, cost - cash) .. " ₡."
        helpText.Text = "Müşteri gelince tezgâhta " .. promptHowTo() .. "; teklif kartı açılır. Pazarlıkçıda düşük teklifi kabul et, bütçe sinyaline göre karşı teklif ver veya reddet."
    elseif not hired then
        goalLabel.Text = "Seviye 2: kapasite büyüdü. Kasiyer " .. C.HireCost .. " ₡ yatırım."
        helpText.Text = "Kasiyer normal alıcıları otomatik servis eder; maaşı işletme gideridir. Yatırımın nakit etkisini gözle."
    else
        goalLabel.Text = due and ("Kasiyer durdu; " .. C.WagePerShift .. " ₡ maaşı öde.") or "Kasiyer normal alıcıları servis ediyor."
        helpText.Text = "Talep değişimini, stok kararını ve işletme sonucunu karşılaştır. K0 amacı tekrarlamak değil karar vermektir."
    end

    local opened = player:GetAttribute("K0OfferOpen") or false
    offer.Visible = opened
    if opened then
        local sku = player:GetAttribute("K0OfferSKU") or ""
        local units = player:GetAttribute("K0OfferUnits") or 0
        local ask = player:GetAttribute("K0OfferAsk") or 0
        local bid = player:GetAttribute("K0OfferBid") or 0
        local counterPrice = player:GetAttribute("K0OfferCounter") or 0
        local kind = player:GetAttribute("K0OfferType") or ""
        local signal = player:GetAttribute("K0OfferSignal") or ""
        local p = C.Products[sku]
        local unit = p and p.Unit or ""
        local available = sku == "orange" and orange or bread
        offerTitle.Text = kind == "Bargainer" and "Müşteri pazarlık ediyor" or "Müşteri satın almak istiyor"
        offerDetail.Text = productName(sku) .. "  " .. units .. " " .. unit .. "\nEtiket " .. ask .. " ₡   Teklif " .. bid .. " ₡"
        offerSignal.Text = kind == "Bargainer" and ("Bütçe sinyali: " .. signal .. "  |  Karşı teklif: " .. counterPrice .. " ₡") or "Etiket fiyatı kabul ediliyor."
        offerStock.Text = "Stok: " .. available .. " " .. unit .. (available < units and "  /  YETERSİZ" or "")
        offerOrange.Visible = sku == "orange"
        offerBread.Visible = sku == "bread"
        offerBudget.Visible = kind == "Bargainer" and budgetFill[signal] ~= nil
        budgetLevel.Size = UDim2.fromOffset(6, math.floor(18 * (budgetFill[signal] or 0) + 0.5))
        accept.Text = available < units and "Stok yok" or (keyHint(1) .. "Sat  " .. bid .. " ₡")
        accept.Active = available >= units
        accept.AutoButtonColor = available >= units
        counter.Visible = kind == "Bargainer"
        counter.Text = keyHint(2) .. "Karşı teklif  " .. counterPrice .. " ₡"
        decline.Text = keyHint(3) .. "Reddet"
        counter.Active = available >= units
        counter.AutoButtonColor = available >= units
    end

    local serial = player:GetAttribute("K0NoticeSerial")
    if serial and serial ~= lastNotice then
        lastNotice = serial
        local text = player:GetAttribute("K0Notice") or ""
        toastText.Text = text
        toast.Visible = true
        local current = serial
        -- K0.4 hid every notice after 4 s, including the 200-character rescue
        -- note. Reading time now grows with length (estimate, not device-tested).
        local seconds = math.clamp(2.5 + (utf8.len(text) or #text) / 20, 4, 10)
        task.delay(seconds, function()
            if lastNotice == current then toast.Visible = false end
        end)
    end
end

local attributes = {
    "K0Owner", "K0Cash", "K0Permit", "K0RentDue", "K0PermitRemaining", "K0Claimed",
    "K0Level", "K0OrangeStock", "K0BreadStock", "K0Sales", "K0Revenue",
    "K0OperatingCost", "K0OperatingResult", "K0InvestmentSpent", "K0Hired", "K0WagesDue",
    "K0ShiftRemaining", "K0UpgradeCost", "K0DemandSKU", "K0DemandRemaining", "K0DemandBonusPercent",
    "K0OfferOpen", "K0OfferId", "K0OfferSKU", "K0OfferUnits", "K0OfferAsk", "K0OfferBid",
    "K0OfferCounter", "K0OfferType", "K0OfferSignal", "K0NoticeSerial", "K0SessionSeconds",
    "K0TargetSessionSeconds", "K0SessionTargetReached",
    "K0Liquidations", "K0LiquidationRevenue", "K0RescueGrants", "K0DeadEndSeconds",
}
for _, name in ipairs(attributes) do player:GetAttributeChangedSignal(name):Connect(render) end
render()

local cueAttributes = {
    "K0Owner", "K0Sales", "K0LostSales", "K0StockPurchases", "K0Liquidations", "K0CustomerReady",
    "K0OfferOpen", "K0OfferType", "K0OfferId", "K0Level", "K0Hired", "K0RentDue", "K0NoticeSerial",
}
for _, name in ipairs(cueAttributes) do player:GetAttributeChangedSignal(name):Connect(listen) end
listen()
