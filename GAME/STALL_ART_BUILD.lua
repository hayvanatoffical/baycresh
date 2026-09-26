-- Run once in Edit after SCENE_BUILD.lua. Pure Studio Parts/Gui; no third-party assets.
local scene = workspace:WaitForChild("BlackstoneBazaar_K0")
local stall = scene:WaitForChild("Stall_01")
if stall:FindFirstChild("ArtV2") then
	print("ArtV2 already exists")
	return
end
local art = Instance.new("Folder")
art.Name = "ArtV2"
local upgraded = stall:WaitForChild("Level2Shelf")
local interaction = scene:WaitForChild("Interaction")
local cream = Color3.fromRGB(232, 220, 200)
local clay = Color3.fromRGB(201, 123, 90)
local roof = Color3.fromRGB(163, 74, 50)
local wood = Color3.fromRGB(118, 78, 50)
local woodLight = Color3.fromRGB(160, 111, 71)
local dark = Color3.fromRGB(49, 58, 61)
local olive = Color3.fromRGB(107, 123, 74)
local orange = Color3.fromRGB(244, 156, 53)
local lemon = Color3.fromRGB(238, 203, 84)
local bread = Color3.fromRGB(211, 163, 93)
local function p(parent, name, size, pos, color, material, shape)
	local item = Instance.new("Part")
	item.Name = name
	item.Size = size
	item.Position = pos
	item.Color = color
	item.Material = material or Enum.Material.SmoothPlastic
	item.Shape = shape or Enum.PartType.Block
	item.Anchored = true
	item.CanCollide = false
	item.CanTouch = false
	item.CanQuery = false
	item.CastShadow = size.Magnitude > 1.5
	item.TopSurface = Enum.SurfaceType.Smooth
	item.BottomSurface = Enum.SurfaceType.Smooth
	item.Parent = parent
	return item
end
local function tag(parent, name, text, face)
	local gui = Instance.new("SurfaceGui")
	gui.Name = name
	gui.Face = face or Enum.NormalId.Front
	gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	gui.PixelsPerStud = 45
	gui.LightInfluence = 0
	gui.AlwaysOnTop = false
	gui.Parent = parent
	local label = Instance.new("TextLabel")
	label.Name = "Text"
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.GothamBold
	label.TextColor3 = cream
	label.TextScaled = true
	label.TextWrapped = true
	label.Text = text
	label.Parent = gui
	return label
end
local function fruitCrate(name, x, z, y, fruitColor, count, parent)
	local m = Instance.new("Model")
	m.Name = name
	m.Parent = parent
	p(m, "Base", Vector3.new(2.8, 0.25, 1.9), Vector3.new(x, y, z), wood, Enum.Material.Wood)
	for _, sx in ipairs({-1.25, 1.25}) do
		p(m, "RailX", Vector3.new(0.18, 0.65, 2), Vector3.new(x + sx, y + 0.33, z), woodLight, Enum.Material.Wood)
	end
	for _, sz in ipairs({-0.88, 0.88}) do
		p(m, "RailZ", Vector3.new(2.6, 0.65, 0.18), Vector3.new(x, y + 0.33, z + sz), woodLight, Enum.Material.Wood)
	end
	for i = 1, count do
		local col = (i - 1) % 3
		local row = math.floor((i - 1) / 3)
		local f = p(m, "Fruit_" .. i, Vector3.new(0.64, 0.64, 0.64), Vector3.new(x - 0.77 + col * 0.77, y + 0.55 + (row >= 2 and 0.45 or 0), z - 0.43 + (row % 2) * 0.82), fruitColor, Enum.Material.SmoothPlastic, Enum.PartType.Ball)
		p(m, "Leaf_" .. i, Vector3.new(0.32, 0.1, 0.16), f.Position + Vector3.new(0.08, 0.35, 0), olive, Enum.Material.SmoothPlastic)
	end
	return m
end
local function plant(name, x, z, y, parent, scale)
	scale = scale or 1
	local m = Instance.new("Model")
	m.Name = name
	m.Parent = parent
	p(m, "Pot", Vector3.new(0.8, 0.8, 0.8) * scale, Vector3.new(x, y, z), clay, Enum.Material.Brick, Enum.PartType.Cylinder)
	p(m, "Soil", Vector3.new(0.65, 0.1, 0.65) * scale, Vector3.new(x, y + 0.43 * scale, z), dark, Enum.Material.Ground, Enum.PartType.Cylinder)
	for i = 1, 5 do
		local a = (i / 5) * math.pi * 2
		local leaf = p(m, "Leaf_" .. i, Vector3.new(0.28, 0.7, 0.22) * scale, Vector3.new(x + math.cos(a) * 0.22 * scale, y + 0.9 * scale, z + math.sin(a) * 0.22 * scale), olive, Enum.Material.SmoothPlastic)
		leaf.CFrame = CFrame.new(leaf.Position) * CFrame.Angles(math.sin(a) * 0.35, 0, math.cos(a) * 0.35)
	end
end
local function loaf(name, x, y, z, parent)
	local b = p(parent, name, Vector3.new(1.05, 0.58, 0.5), Vector3.new(x, y, z), bread, Enum.Material.SmoothPlastic, Enum.PartType.Ball)
	b.CFrame = CFrame.new(b.Position) * CFrame.Angles(0, math.rad(18), 0)
	for i = -1, 1 do
		p(parent, name .. "_Score" .. i, Vector3.new(0.08, 0.04, 0.38), Vector3.new(x + i * 0.23, y + 0.28, z), cream, Enum.Material.SmoothPlastic)
	end
end

-- Permanent craft details, shared by both levels.
for _, x in ipairs({-7, 7}) do
	for _, z in ipairs({2, 14}) do
		p(art, "StoneFoot_" .. x .. "_" .. z, Vector3.new(1.2, 2.2, 1.2), Vector3.new(x, 1.7, z), cream, Enum.Material.Limestone)
		p(art, "PostCap_" .. x .. "_" .. z, Vector3.new(1, 0.35, 1), Vector3.new(x, 9.6, z), dark, Enum.Material.Metal)
	end
end
for x = -7, 7, 2 do
	p(art, "CounterSlat_" .. x, Vector3.new(1.8, 1.6, 0.1), Vector3.new(x, 2.15, 0.94), x % 4 == 1 and woodLight or wood, Enum.Material.Wood)
end
p(art, "CounterLip", Vector3.new(16, 0.26, 0.4), Vector3.new(0, 3.34, 0.8), woodLight, Enum.Material.Wood)
p(art, "BackShelf", Vector3.new(12, 0.3, 2.5), Vector3.new(0, 4.5, 12), woodLight, Enum.Material.Wood)
for _, x in ipairs({-6, 6}) do
	p(art, "BackShelfPost_" .. x, Vector3.new(0.3, 3.6, 0.3), Vector3.new(x, 3.2, 12), wood, Enum.Material.Wood)
end
for x = -6, 6, 4 do
	p(art, "CanopyFringe_" .. x, Vector3.new(2.4, 0.7, 0.2), Vector3.new(x, 9.1, 1.8), x % 8 == 2 and cream or roof, Enum.Material.Fabric)
end
for _, x in ipairs({-5, 0, 5}) do
	local old = stall:FindFirstChild("Crate_" .. x)
	if old and old:IsA("BasePart") then
		old.Color = wood
		old.Material = Enum.Material.Wood
	end
end
fruitCrate("OrangeCrate", -5, 2, 4.75, orange, 6, art)
fruitCrate("LemonCrate", 0, 2, 4.75, lemon, 5, art)
plant("FrontHerbs", 5.2, 2, 4.8, art, 0.9)
plant("BackHerbs", -5, 11.5, 5.0, art, 0.8)
loaf("Bread_1", 2.9, 4.9, 12, art)
loaf("Bread_2", 4.3, 4.9, 12, art)

local sign = stall:WaitForChild("NameSign")
stall.Canopy.Color = Color3.fromRGB(112, 105, 96)
local oldSign = sign:FindFirstChild("WorldLabel")
if oldSign then oldSign.Enabled = false end
sign.Color = wood
local signGui = Instance.new("SurfaceGui")
signGui.Name = "SignSurface"
signGui.Face = Enum.NormalId.Front
signGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
signGui.PixelsPerStud = 50
signGui.LightInfluence = 0
signGui.Parent = sign
local nameText = Instance.new("TextLabel")
nameText.Name = "OwnerText"
nameText.Size = UDim2.fromScale(1, 1)
nameText.BackgroundColor3 = dark
nameText.BorderSizePixel = 0
nameText.Font = Enum.Font.GothamBold
nameText.TextColor3 = cream
nameText.TextScaled = true
nameText.TextWrapped = true
nameText.Text = "TEZGÂHI SAHİPLEN"
nameText.Parent = signGui
local claimPrompt = Instance.new("ProximityPrompt")
claimPrompt.Name = "ClaimPrompt"
claimPrompt.ActionText = "Tezgâhı sahiplen"
claimPrompt.ObjectText = "Blackstone Bazaar"
claimPrompt.HoldDuration = 0.8
claimPrompt.MaxActivationDistance = 12
claimPrompt.RequiresLineOfSight = false
claimPrompt.KeyboardKeyCode = Enum.KeyCode.E
claimPrompt.Parent = sign

-- Improvement pieces appear when the stall reaches level 2.
p(upgraded, "UpperDisplay", Vector3.new(12, 0.4, 2.7), Vector3.new(0, 6.0, 11.3), woodLight, Enum.Material.Wood)
for _, x in ipairs({-5.5, 5.5}) do
	p(upgraded, "UpperSupport_" .. x, Vector3.new(0.3, 2.8, 0.3), Vector3.new(x, 4.7, 11.3), wood, Enum.Material.Wood)
end
fruitCrate("TomatoCrate", 4, 10.7, 6.55, Color3.fromRGB(210, 76, 55), 8, upgraded)
fruitCrate("FullCitrusCrate", -4, 10.7, 6.55, orange, 8, upgraded)
fruitCrate("ExtraLemons", -5, 8.4, 5.2, lemon, 8, upgraded)
fruitCrate("ExtraOranges", 5, 8.4, 5.2, orange, 8, upgraded)
for i = 1, 3 do loaf("ExtraBread_" .. i, -3 + i * 1.1, 6.65, 8.3, upgraded) end
plant("OlivePlantLeft", -7, 12.6, 1.1, upgraded, 1.1)
plant("OlivePlantRight", 7, 12.6, 1.1, upgraded, 1.1)
for i = 1, 7 do
	local pennant = p(upgraded, "Pennant_" .. i, Vector3.new(0.8, 0.8, 0.15), Vector3.new(-6.3 + i * 1.55, 8.55, 1.45), i % 2 == 0 and olive or clay, Enum.Material.Fabric)
	pennant.CFrame = CFrame.new(pennant.Position) * CFrame.Angles(0, 0, math.rad(45))
end
for _, x in ipairs({-6, 6}) do
	local lamp = p(upgraded, "Lantern_" .. x, Vector3.new(0.65, 1, 0.65), Vector3.new(x, 7.35, 3.4), Color3.fromRGB(225, 177, 99), Enum.Material.Glass)
	p(upgraded, "LanternFrame_" .. x, Vector3.new(0.85, 0.12, 0.85), Vector3.new(x, 7.9, 3.4), dark, Enum.Material.Metal)
	p(upgraded, "LanternChain_" .. x, Vector3.new(0.09, 1.2, 0.09), Vector3.new(x, 8.55, 3.4), dark, Enum.Material.Metal)
	local light = Instance.new("PointLight")
	light.Name = "WarmLight"
	light.Brightness = 0.25
	light.Range = 8
	light.Color = Color3.fromRGB(255, 194, 112)
	light.Enabled = false
	light.Parent = lamp
end

-- Physical interaction boards are legible at third-person camera distance.
local boardSpecs = {
	{interaction.UpgradeBoard, "01  BÜYÜT", "5.000 ₡", clay},
	{interaction.HireBoard, "02  KASİYER", "OTOMATİK SATIŞ", olive},
	{interaction.PayBoard, "03  MAAŞ", "VARDİYA GİDERİ", dark},
}
for _, spec in ipairs(boardSpecs) do
	local board, title, detail, color = spec[1], spec[2], spec[3], spec[4]
	board.Color = color
	board.Material = Enum.Material.Wood
	board.CanCollide = false
	local old = board:FindFirstChild("WorldLabel")
	if old then old.Enabled = false end
	local bg = Instance.new("SurfaceGui")
	bg.Name = "BoardSurface"
	bg.Face = Enum.NormalId.Front
	bg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	bg.PixelsPerStud = 60
	bg.LightInfluence = 0
	bg.Parent = board
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Position = UDim2.fromScale(0.05, 0.12)
	titleLabel.Size = UDim2.fromScale(0.9, 0.3)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextScaled = true
	titleLabel.TextColor3 = cream
	titleLabel.Parent = bg
	local detailLabel = titleLabel:Clone()
	detailLabel.Name = "Detail"
	detailLabel.Position = UDim2.fromScale(0.05, 0.56)
	detailLabel.Size = UDim2.fromScale(0.9, 0.18)
	detailLabel.Text = detail
	detailLabel.Font = Enum.Font.GothamMedium
	detailLabel.Parent = bg
	local back = bg:Clone()
	back.Name = "BoardSurfaceBack"
	back.Face = Enum.NormalId.Back
	back.Parent = board
end
local sale = interaction.SalePoint
local oldSale = sale:FindFirstChild("WorldLabel")
if oldSale then oldSale.Enabled = false end
sale.Material = Enum.Material.Neon
sale.Color = clay
sale.Transparency = 0.32

for _, item in upgraded:GetDescendants() do
	if item:IsA("BasePart") then item.Transparency = 1 end
	if item:IsA("Light") then item.Enabled = false end
end

art.Parent = stall
print("ArtV2 built", #art:GetDescendants(), "always-on descendants", #upgraded:GetDescendants(), "upgrade descendants")
