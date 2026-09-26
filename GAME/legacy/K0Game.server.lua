-- Baycrest K0: one server-owned stall and a compressed, memory-only test loop.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Config = require(ReplicatedStorage:WaitForChild("K0Config"))
local test = Config.Prototype
local production = Config.Production

local scene = workspace:WaitForChild("BlackstoneBazaar_K0")
local points = scene:WaitForChild("Waypoints")
local interaction = scene:WaitForChild("Interaction")
local stall = scene:WaitForChild("Stall_01")
local salePrompt = interaction.SalePoint.SalePrompt
local upgradePrompt = interaction.UpgradeBoard.UpgradeBoardPrompt
local hirePrompt = interaction.HireBoard.HireBoardPrompt
local payPrompt = interaction.PayBoard.PayBoardPrompt
local claimPrompt = stall.NameSign:WaitForChild("ClaimPrompt")
local signText = stall.NameSign.SignSurface.OwnerText

local owner = nil
local claimed = false
local cash = 0
local level = 1
local sales = 0
local hired = false
local wagesDue = false
local salaryDue = 0
local shiftRemaining = test.ShiftSeconds
local customer = nil
local customerState = "none"
local customerSerial = 0
local worker = nil
local noticeSerial = 0
local lastAction = 0

local function insideRange(player, target)
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	return root and (root.Position - target.Position).Magnitude <= test.InteractionDistance
end

local function setCash(value)
	cash = math.max(0, math.floor(value))
	if owner then
		local stats = owner:FindFirstChild("leaderstats")
		local cashValue = stats and stats:FindFirstChild("Cash")
		if cashValue then cashValue.Value = cash end
		owner:SetAttribute("K0Cash", cash)
	end
end

local function sync()
	if not owner then return end
	owner:SetAttribute("K0Owner", true)
	owner:SetAttribute("K0Claimed", claimed)
	owner:SetAttribute("K0Level", level)
	owner:SetAttribute("K0Sales", sales)
	owner:SetAttribute("K0Hired", hired)
	owner:SetAttribute("K0WagesDue", wagesDue)
	owner:SetAttribute("K0SalaryDue", salaryDue)
	owner:SetAttribute("K0ShiftRemaining", shiftRemaining)
	owner:SetAttribute("K0CustomerReady", customerState == "ready")
	owner:SetAttribute("K0UpgradeCost", production.LevelCost[2])
	setCash(cash)
	claimPrompt.Enabled = not claimed
	salePrompt.Enabled = claimed and customerState == "ready"
	upgradePrompt.Enabled = claimed and level == 1
	hirePrompt.Enabled = claimed and level >= 2 and not hired
	payPrompt.Enabled = claimed and wagesDue
	signText.Text = claimed and (string.upper(owner.DisplayName) .. " | SEVİYE " .. level) or "TEZGÂHI SAHİPLEN"
	for _, item in stall.Level2Shelf:GetDescendants() do
		if item:IsA("BasePart") then item.Transparency = level >= 2 and 0 or 1 end
		if item:IsA("Light") then item.Enabled = level >= 2 end
	end
end

local function inform(message)
	if not owner then return end
	noticeSerial += 1
	owner:SetAttribute("K0Notice", message)
	owner:SetAttribute("K0NoticeSerial", noticeSerial)
end

local function guard(player, target)
	if player ~= owner then return false end
	if not insideRange(player, target) then return false end
	local now = os.clock()
	if now - lastAction < 0.25 then return false end
	lastAction = now
	return true
end

local function npcPart(model, name, size, offset, color, position)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.CFrame = CFrame.new(position + offset)
	p.Anchored = true
	p.CanCollide = false
	p.Material = Enum.Material.SmoothPlastic
	p.Color = color
	p.Parent = model
	return p
end

local function createNpc(name, position, shirtColor)
	local model = Instance.new("Model")
	model.Name = name
	local skin = Color3.fromRGB(196, 147, 111)
	local root = npcPart(model, "Root", Vector3.new(0.5, 0.5, 0.5), Vector3.zero, Color3.new(1, 1, 1), position)
	root.Transparency = 1
	model.PrimaryPart = root
	npcPart(model, "Torso", Vector3.new(1.7, 2, 0.85), Vector3.new(0, 0, 0), shirtColor, position)
	npcPart(model, "Head", Vector3.new(1.2, 1.2, 1.2), Vector3.new(0, 1.65, 0), skin, position)
	npcPart(model, "LeftArm", Vector3.new(0.55, 1.8, 0.65), Vector3.new(-1.1, -0.05, 0), skin, position)
	npcPart(model, "RightArm", Vector3.new(0.55, 1.8, 0.65), Vector3.new(1.1, -0.05, 0), skin, position)
	npcPart(model, "LeftLeg", Vector3.new(0.65, 1.8, 0.7), Vector3.new(-0.45, -1.9, 0), Color3.fromRGB(57, 66, 71), position)
	npcPart(model, "RightLeg", Vector3.new(0.65, 1.8, 0.7), Vector3.new(0.45, -1.9, 0), Color3.fromRGB(57, 66, 71), position)
	model.Parent = scene
	return model
end

local function moveNpc(model, from, to, duration)
	local value = Instance.new("CFrameValue")
	value.Value = CFrame.new(from)
	local connection = value.Changed:Connect(function(cf)
		if model.Parent then model:PivotTo(cf) end
	end)
	local tween = TweenService:Create(value, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Value = CFrame.new(to)})
	tween:Play()
	tween.Completed:Wait()
	connection:Disconnect()
	value:Destroy()
end

local function transactionFeedback(reward)
	local parcel = Instance.new("Part")
	parcel.Name = "SaleParcel"
	parcel.Size = Vector3.new(0.7, 0.6, 0.55)
	parcel.Anchored = true
	parcel.CanCollide = false
	parcel.CanTouch = false
	parcel.CanQuery = false
	parcel.Color = Color3.fromRGB(232, 220, 200)
	parcel.Material = Enum.Material.Cardboard
	parcel.Position = Vector3.new(0, 4, 1.2)
	parcel.Parent = scene
	local tween = TweenService:Create(parcel, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = points.CustomerQueue.Position + Vector3.new(0, 0.9, 0), Transparency = 1})
	tween:Play()
	Debris:AddItem(parcel, 1)
	local marker = Instance.new("Part")
	marker.Name = "CashFeedback"
	marker.Size = Vector3.new(0.1, 0.1, 0.1)
	marker.Transparency = 1
	marker.Anchored = true
	marker.CanCollide = false
	marker.Position = interaction.SalePoint.Position + Vector3.new(0, 4, 0)
	marker.Parent = scene
	local gui = Instance.new("BillboardGui")
	gui.Size = UDim2.fromOffset(150, 46)
	gui.AlwaysOnTop = true
	gui.Parent = marker
	local text = Instance.new("TextLabel")
	text.Size = UDim2.fromScale(1, 1)
	text.BackgroundTransparency = 1
	text.Text = "+" .. reward .. " ₡"
	text.Font = Enum.Font.GothamBold
	text.TextScaled = true
	text.TextStrokeTransparency = 0.2
	text.TextColor3 = Color3.fromRGB(237, 210, 108)
	text.Parent = gui
	TweenService:Create(marker, TweenInfo.new(1.2), {Position = marker.Position + Vector3.new(0, 2.5, 0)}):Play()
	TweenService:Create(text, TweenInfo.new(1.2), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
	Debris:AddItem(marker, 1.3)
end

local function serve(byWorker)
	if customerState ~= "ready" or not owner then return end
	customerState = "served"
	sales += 1
	local reward = byWorker and math.floor(test.SaleReward * production.HappyWorkerEfficiency + 0.5) or test.SaleReward
	setCash(cash + reward)
	transactionFeedback(reward)
	sync()
	inform(byWorker and ("Kasiyer satış yaptı: +" .. reward .. " ₡") or ("Ürün verildi: +" .. reward .. " ₡"))
end

claimPrompt.Triggered:Connect(function(player)
	if not guard(player, stall.NameSign) or claimed then return end
	claimed = true
	TweenService:Create(stall.Canopy, TweenInfo.new(1.1, Enum.EasingStyle.Quad), {Color = Color3.fromRGB(163, 74, 50)}):Play()
	sync()
	inform("Bu tezgâh artık senin. İlk müşterini karşıla!")
end)

local function scheduleWorkerSale()
	if not hired or wagesDue or customerState ~= "ready" then return end
	local serial = customerSerial
	task.delay(test.WorkerServeSeconds, function()
		if serial == customerSerial and hired and not wagesDue then serve(true) end
	end)
end

salePrompt.Triggered:Connect(function(player)
	if claimed and guard(player, interaction.SalePoint) then serve(false) end
end)

upgradePrompt.Triggered:Connect(function(player)
	if not guard(player, interaction.UpgradeBoard) then return end
	if not claimed or level ~= 1 then return end
	local cost = production.LevelCost[2]
	if cash < cost then
		inform("Seviye 2 için " .. (cost - cash) .. " ₡ daha gerekli.")
		return
	end
	setCash(cash - cost)
	level = 2
	sync()
	inform("Tezgâh seviye 2! Raflar açıldı.")
end)

hirePrompt.Triggered:Connect(function(player)
	if not guard(player, interaction.HireBoard) then return end
	if not claimed or level < 2 or hired then return end
	hired = true
	shiftRemaining = test.ShiftSeconds
	worker = createNpc("Worker_K0", points.WorkerStand.Position, Color3.fromRGB(201, 123, 90))
	sync()
	inform("Kasiyer işe başladı. Maaş günü " .. test.ShiftSeconds .. " saniye sonra.")
	scheduleWorkerSale()
end)

payPrompt.Triggered:Connect(function(player)
	if not guard(player, interaction.PayBoard) or not wagesDue then return end
	if cash < salaryDue then
		inform("Maaş için " .. (salaryDue - cash) .. " ₡ daha gerekli.")
		return
	end
	local paid = salaryDue
	setCash(cash - paid)
	wagesDue = false
	salaryDue = 0
	shiftRemaining = test.ShiftSeconds
	sync()
	inform("Maaş ödendi: -" .. paid .. " ₡. Kasiyer çalışmaya devam ediyor.")
	scheduleWorkerSale()
end)

local function setupPlayer(player)
	local stats = Instance.new("Folder")
	stats.Name = "leaderstats"
	stats.Parent = player
	local cashValue = Instance.new("IntValue")
	cashValue.Name = "Cash"
	cashValue.Parent = stats
	if not owner then
		owner = player
		claimed = false
		cash = 0
		level = 1
		sales = 0
		hired = false
		wagesDue = false
		salaryDue = 0
		shiftRemaining = test.ShiftSeconds
		sync()
		inform("Blackstone Bazaar'a hoş geldin. Tabeladan ilk tezgâhını sahiplen!")
	else
		player:SetAttribute("K0Owner", false)
		player:SetAttribute("K0Notice", "K0 prototipi tek oyunculudur.")
	end
end
Players.PlayerAdded:Connect(setupPlayer)
for _, player in Players:GetPlayers() do setupPlayer(player) end
Players.PlayerRemoving:Connect(function(player)
	if player ~= owner then return end
	owner = nil
	claimed = false
	if customer then customer:Destroy(); customer = nil end
	if worker then worker:Destroy(); worker = nil end
	customerState = "none"
	salePrompt.Enabled = false
	payPrompt.Enabled = false
end)

task.spawn(function()
	while true do
		task.wait(1)
		if owner and hired and not wagesDue then
			shiftRemaining -= 1
			if shiftRemaining <= 0 then
				wagesDue = true
				shiftRemaining = 0
				salaryDue = math.floor(production.LevelNetPerMinute[level] * production.BaseSalaryRate * 48 + 0.5)
				inform("Maaş günü! Ödeme tabelasından " .. salaryDue .. " ₡ öde.")
			end
			sync()
		end
	end
end)

task.spawn(function()
	while true do
		if not owner or not claimed or customer then
			task.wait(0.5)
		else
			customerSerial += 1
			local entry = points.CustomerEntry.Position
			local queue = points.CustomerQueue.Position
			local exitPoint = points.CustomerExit.Position
			customer = createNpc("Customer_" .. customerSerial, entry, Color3.fromRGB(104, 144, 151))
			customerState = "walking"
			sync()
			moveNpc(customer, entry, queue, test.CustomerWalkSeconds)
			if customer and owner then
				customerState = "ready"
				sync()
				inform("Müşteri bekliyor. Tezgâhta E ile ürünü ver.")
				local arrivedAt = os.clock()
				scheduleWorkerSale()
				while owner and customerState == "ready" and os.clock() - arrivedAt < test.CustomerPatienceSeconds do
					task.wait(0.2)
				end
				if customerState == "ready" then
					customerState = "left"
					inform("Müşteri beklemekten vazgeçti.")
				end
				sync()
				if customer then moveNpc(customer, queue, exitPoint, 2) end
			end
			if customer then customer:Destroy(); customer = nil end
			customerState = "none"
			sync()
			task.wait(test.CustomerGapSeconds)
		end
	end
end)

print("Baycrest K0 server ready")
