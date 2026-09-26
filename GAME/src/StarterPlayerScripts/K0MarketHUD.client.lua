-- Baycrest K0 Market HUD (version: K0MarketConfig.Version)
-- Read-only state presentation. All economic decisions are validated by the server.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

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

local status = frame("Status", UDim2.fromOffset(410, 334), UDim2.fromOffset(18, 18))
local statusScale = Instance.new("UIScale")
statusScale.Parent = status
local title = label(status, "Title", "BAYCREST / K0 PAZAR", 8, 27, 18, accent)
title.Font = Enum.Font.GothamBold
local cashLabel = label(status, "Cash", "Kasa", 42, 29, 23, cream)
local ownershipLabel = label(status, "Ownership", "Tezgâh", 75, 24, 16, cream)
local permitLabel = label(status, "Permit", "Pazar kaydı", 101, 24, 16, cream)
local demandLabel = label(status, "Demand", "Talep", 127, 24, 16, good)
local stockLabel = label(status, "Stock", "Stok", 153, 24, 15, cream)
-- K0.4 put five figures on one 30 px line; with real numbers it wrapped to two
-- lines and the second was clipped. Flow and result now have a line each.
local resultLabel = label(status, "Result", "Satış", 179, 22, 14, cream)
local profitLabel = label(status, "Profit", "Sonuç", 201, 22, 14, cream)
local workerLabel = label(status, "Worker", "Kasiyer", 225, 24, 14, cream)
local goalLabel = label(status, "Goal", "Hedef", 251, 52, 14, accent)

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

local accept = button("Accept", 14, "1  Sat")
local counter = button("Counter", 172, "2  Karşı teklif")
local decline = button("Decline", 330, "3  Reddet")
counter.BackgroundColor3 = Color3.fromRGB(92, 116, 77)
decline.BackgroundColor3 = Color3.fromRGB(70, 76, 78)

local function updateScale()
    local camera = Workspace.CurrentCamera
    if not camera then return end
    local size = camera.ViewportSize
    local narrow = size.X < 620

    local statusScaleValue = math.min(math.clamp(size.X / 760, 0.72, 1), math.clamp(size.Y / 650, 0.76, 1))
    statusScale.Scale = statusScaleValue
    helpScale.Scale = math.min(math.clamp(size.X / 760, 0.56, 1), math.clamp(size.Y / 650, 0.72, 1))
    toastScale.Scale = math.min(math.clamp(size.X / 650, 0.62, 1), 1)

    if narrow then
        -- On phones, keep touch targets tall instead of shrinking three buttons
        -- into a single tiny row. The whole card is scaled to fit the viewport.
        offer.Size = UDim2.fromOffset(430, 374)
        offerDetail.Position = UDim2.new(0, 14, 0, 45)
        offerSignal.Position = UDim2.new(0, 14, 0, 105)
        offerStock.Position = UDim2.new(0, 14, 0, 133)
        accept.Position = UDim2.new(0, 14, 0, 174)
        counter.Position = UDim2.new(0, 14, 0, 234)
        decline.Position = UDim2.new(0, 14, 0, 294)
        accept.Size = UDim2.fromOffset(402, 52)
        counter.Size = UDim2.fromOffset(402, 52)
        decline.Size = UDim2.fromOffset(402, 52)
        offerScale.Scale = math.min(math.clamp(size.X / 455, 0.72, 1), math.clamp(size.Y / 640, 0.72, 1))
    else
        offer.Size = UDim2.fromOffset(490, 244)
        accept.Position = UDim2.new(0, 14, 0, 174)
        counter.Position = UDim2.new(0, 172, 0, 174)
        decline.Position = UDim2.new(0, 330, 0, 174)
        accept.Size = UDim2.fromOffset(146, 54)
        counter.Size = UDim2.fromOffset(146, 54)
        decline.Size = UDim2.fromOffset(146, 54)
        offerScale.Scale = math.min(math.clamp(size.X / 920, 0.72, 1), math.clamp(size.Y / 650, 0.76, 1))
    end
end
updateScale()
local viewportConnection = nil
local function watchCamera()
    if viewportConnection then viewportConnection:Disconnect() end
    local camera = Workspace.CurrentCamera
    viewportConnection = camera and camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale) or nil
    updateScale()
end
watchCamera()
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchCamera)

local function send(action)
    if not offer.Visible then return end
    local id = player:GetAttribute("K0OfferId")
    if type(id) == "number" and id > 0 then decision:FireServer(id, action) end
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
    stockLabel.Text = "Portakal " .. orange .. " kg  |  Ekmek " .. bread .. " adet"
    resultLabel.Text = "Satış " .. sold .. "  |  Ciro " .. revenue .. " ₡  |  Gider " .. operatingCost .. " ₡"
    profitLabel.Text = "Sonuç " .. operatingResult .. " ₡  |  Yatırım " .. investment .. " ₡"
    profitLabel.TextColor3 = operatingResult < 0 and accent or cream
    workerLabel.Text = hired and (due and ("Kasiyer: " .. C.WagePerShift .. " ₡ maaş bekliyor") or ("Kasiyer: " .. (player:GetAttribute("K0ShiftRemaining") or 0) .. " sn")) or "Kasiyer: yok"

    local cost = player:GetAttribute("K0UpgradeCost") or C.UpgradeCost
    fill.Size = UDim2.fromScale(claimed and (level >= 2 and 1 or math.clamp(cash / cost, 0, 1)) or 0, 1)

    if not claimed then
        goalLabel.Text = "1 / İlk dakikada tezgâhı sahiplen."
        helpText.Text = "Tezgâh tabelasına yaklaş ve E. Sahiplik ücretsiz; ekonomi kararı bundan sonra başlar."
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
        helpText.Text = "Alıcı teklifi için tezgahta E. Pazarlıkçıda düşük teklifi kabul et, bütçe sinyaline göre karşı teklif ver veya reddet."
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
        accept.Text = available < units and "Stok yok" or ("1  Sat  " .. bid .. " ₡")
        accept.Active = available >= units
        accept.AutoButtonColor = available >= units
        counter.Visible = kind == "Bargainer"
        counter.Text = "2  Karşı teklif  " .. counterPrice .. " ₡"
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
