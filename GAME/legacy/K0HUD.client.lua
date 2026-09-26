-- Read-only HUD. All cash and interaction decisions stay on the server.
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "BaycrestK0HUD"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.Parent = player:WaitForChild("PlayerGui")

local function panel(name, size, position)
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.Size = size
	frame.Position = position
	frame.BackgroundColor3 = Color3.fromRGB(35, 43, 46)
	frame.BackgroundTransparency = 0.08
	frame.Parent = gui
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = frame
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(201, 123, 90)
	stroke.Thickness = 2
	stroke.Parent = frame
	return frame
end
local function text(parent, name, y, height, size, color)
	local label = Instance.new("TextLabel")
	label.Name = name
	label.Position = UDim2.new(0, 14, 0, y)
	label.Size = UDim2.new(1, -28, 0, height)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamMedium
	label.TextSize = size
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.TextWrapped = true
	label.TextColor3 = color
	label.Parent = parent
	return label
end
local cream = Color3.fromRGB(232, 220, 200)
local accent = Color3.fromRGB(241, 166, 125)
local card = panel("Status", UDim2.fromOffset(340, 222), UDim2.fromOffset(20, 20))
local title = text(card, "Title", 10, 30, 19, accent)
title.Font = Enum.Font.GothamBold
title.Text = "BAYCREST  /  BLACKSTONE BAZAAR"
local cashLabel = text(card, "Cash", 46, 28, 22, cream)
local levelLabel = text(card, "Level", 77, 24, 16, cream)
local salesLabel = text(card, "Sales", 104, 24, 16, cream)
local workerLabel = text(card, "Worker", 131, 24, 16, cream)
local goalLabel = text(card, "Goal", 158, 36, 14, accent)
local progressTrack = Instance.new("Frame")
progressTrack.Name = "UpgradeProgress"
progressTrack.Position = UDim2.new(0, 14, 0, 203)
progressTrack.Size = UDim2.new(1, -28, 0, 8)
progressTrack.BackgroundColor3 = Color3.fromRGB(70, 77, 72)
progressTrack.BorderSizePixel = 0
progressTrack.Parent = card
local progressFill = Instance.new("Frame")
progressFill.Name = "Fill"
progressFill.Size = UDim2.fromScale(0, 1)
progressFill.BackgroundColor3 = accent
progressFill.BorderSizePixel = 0
progressFill.Parent = progressTrack

local help = panel("Help", UDim2.fromOffset(470, 70), UDim2.new(0, 20, 1, -90))
local helpText = text(help, "HelpText", 7, 56, 15, cream)
helpText.Text = "Müşteri gelince tezgâhta E ile sat. Sağdaki tabelalar: yükseltme, çalışan, maaş."
local toast = panel("Notice", UDim2.fromOffset(420, 66), UDim2.new(0.5, -210, 0, 20))
local toastText = text(toast, "NoticeText", 7, 52, 16, cream)
toast.Visible = false
local lastNoticeSerial = -1

local function render()
	if player:GetAttribute("K0Owner") == false then
		cashLabel.Text = "Tek oyunculu K0 prototipi"
		levelLabel.Text = "Bir sonraki test oturumunu bekle."
		salesLabel.Text = ""
		workerLabel.Text = ""
		goalLabel.Text = ""
		progressFill.Size = UDim2.fromScale(0, 1)
		return
	end
	local claimed = player:GetAttribute("K0Claimed") or false
	local cash = player:GetAttribute("K0Cash") or 0
	local level = player:GetAttribute("K0Level") or 1
	local sales = player:GetAttribute("K0Sales") or 0
	local hired = player:GetAttribute("K0Hired") or false
	local due = player:GetAttribute("K0WagesDue") or false
	local remaining = player:GetAttribute("K0ShiftRemaining") or 0
	cashLabel.Text = string.format("Kasa  %s ₡", tostring(cash))
	levelLabel.Text = claimed and string.format("Benim tezgâhım  Seviye %d", level) or "Tezgâh  Sahiplenilmedi"
	salesLabel.Text = string.format("Satış  %d", sales)
	workerLabel.Text = hired and (due and "Kasiyer  Maaş bekliyor" or ("Kasiyer  Maaşa " .. remaining .. " sn")) or "Kasiyer  Henüz yok"
	local upgradeCost = player:GetAttribute("K0UpgradeCost") or 5000
	progressFill.Size = UDim2.fromScale(claimed and (level >= 2 and 1 or math.clamp(cash / upgradeCost, 0, 1)) or 0, 1)
	if not claimed then
		goalLabel.Text = "İlk adım: tezgâh tabelasından sahiplen."
		helpText.Text = "Tabelaya yaklaş ve E ile ilk tezgâhını sahiplen."
	elseif level == 1 then
		goalLabel.Text = "Büyümeye " .. math.max(0, upgradeCost - cash) .. " ₡ kaldı."
		helpText.Text = "Müşteri gelince tezgâhta E ile ürün ver."
	elseif not hired then
		goalLabel.Text = "Hedef: sağdaki tabeladan kasiyer tut."
		helpText.Text = "Tezgâh büyüdü. Çalışan tabelasından kasiyer tut."
	elseif due then
		goalLabel.Text = "Hedef: " .. tostring(player:GetAttribute("K0SalaryDue") or 0) .. " ₡ maaşı öde."
		helpText.Text = "Maaş tabelasına yaklaş ve E ile kasiyerin ücretini öde."
	else
		goalLabel.Text = "Kasiyer müşteri satışlarına yardım ediyor."
		helpText.Text = "İstersen satışa devam et; kasiyer de müşteri karşılar."
	end
	local serial = player:GetAttribute("K0NoticeSerial")
	if serial and serial ~= lastNoticeSerial then
		lastNoticeSerial = serial
		toastText.Text = player:GetAttribute("K0Notice") or ""
		toast.Visible = true
		local current = serial
		task.delay(4, function()
			if lastNoticeSerial == current then toast.Visible = false end
		end)
	end
end
for _, attr in ipairs({"K0Owner", "K0Claimed", "K0Cash", "K0Level", "K0Sales", "K0Hired", "K0WagesDue", "K0SalaryDue", "K0ShiftRemaining", "K0NoticeSerial"}) do
	player:GetAttributeChangedSignal(attr):Connect(render)
end
render()
