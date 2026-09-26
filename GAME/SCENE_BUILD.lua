-- Run once in the Edit DataModel with Roblox Studio MCP execute_luau.
-- Idempotent: an existing K0 scene is left untouched.
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
if Workspace:FindFirstChild("BlackstoneBazaar_K0") then
	print("BlackstoneBazaar_K0 already exists")
	return
end

local scene = Instance.new("Folder")
scene.Name = "BlackstoneBazaar_K0"
local geometry = Instance.new("Folder")
geometry.Name = "Geometry"
geometry.Parent = scene
local facades = Instance.new("Folder")
facades.Name = "Facades"
facades.Parent = scene
local stall = Instance.new("Folder")
stall.Name = "Stall_01"
stall.Parent = scene
local interaction = Instance.new("Folder")
interaction.Name = "Interaction"
interaction.Parent = scene
local waypoints = Instance.new("Folder")
waypoints.Name = "Waypoints"
waypoints.Parent = scene

local cream = Color3.fromRGB(232, 220, 200)
local terra = Color3.fromRGB(201, 123, 90)
local red = Color3.fromRGB(163, 74, 50)
local dark = Color3.fromRGB(49, 58, 61)
local stone = Color3.fromRGB(157, 146, 127)
local function part(parent, name, size, position, color, material, collision)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Position = position
	p.Anchored = true
	p.CanCollide = collision ~= false
	p.Material = material or Enum.Material.SmoothPlastic
	p.Color = color
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end
local function label(parent, title, color, width)
	local gui = Instance.new("BillboardGui")
	gui.Name = "WorldLabel"
	gui.Adornee = parent
	gui.Size = UDim2.fromOffset(width or 200, 48)
	gui.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
	gui.MaxDistance = 55
	gui.AlwaysOnTop = true
	gui.Parent = parent
	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromScale(1, 1)
	frame.BackgroundColor3 = dark
	frame.BackgroundTransparency = 0.1
	frame.Parent = gui
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame
	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "Title"
	textLabel.BackgroundTransparency = 1
	textLabel.Size = UDim2.fromScale(1, 1)
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextScaled = true
	textLabel.TextColor3 = color
	textLabel.Text = title
	textLabel.Parent = frame
	return textLabel
end
local function prompt(parent, name, action, object, distance)
	local pp = Instance.new("ProximityPrompt")
	pp.Name = name
	pp.ActionText = action
	pp.ObjectText = object
	pp.KeyboardKeyCode = Enum.KeyCode.E
	pp.HoldDuration = 0.2
	pp.MaxActivationDistance = distance or 11
	pp.RequiresLineOfSight = false
	pp.Parent = parent
	return pp
end

-- A compact 4 stud grid street. The single functioning stall faces the road.
part(geometry, "Street", Vector3.new(128, 0.4, 24), Vector3.new(0, 0.2, -10), dark, Enum.Material.Asphalt)
part(geometry, "NorthSidewalk", Vector3.new(128, 0.6, 16), Vector3.new(0, 0.3, 10), stone, Enum.Material.Concrete)
part(geometry, "SouthSidewalk", Vector3.new(128, 0.6, 12), Vector3.new(0, 0.3, -28), stone, Enum.Material.Concrete)
for x = -56, 56, 16 do
	part(geometry, "StreetStripe_" .. x, Vector3.new(6, 0.04, 0.4), Vector3.new(x, 0.43, -15), cream, Enum.Material.SmoothPlastic, false)
end
for x = -60, 60, 8 do
	part(geometry, "SidewalkJoint_" .. x, Vector3.new(0.08, 0.02, 16), Vector3.new(x, 0.62, 10), dark, Enum.Material.SmoothPlastic, false)
end

-- Background massing only. These blocks do not represent usable buildings.
for i, x in ipairs({-52, -32, -12, 12, 32, 52}) do
	local height = ({17, 21, 15, 20, 17, 19})[i]
	local wall = part(facades, "NorthFacade_" .. i, Vector3.new(16, height, 8), Vector3.new(x, height / 2, 23), i % 2 == 0 and cream or terra, Enum.Material.Concrete)
		part(facades, "Roofline_" .. i, Vector3.new(17, 1, 9), wall.Position + Vector3.new(0, height / 2 + 0.5, 0), red, Enum.Material.Brick)
	for row = 1, 2 do
		for col = -1, 1 do
			part(facades, "Window_" .. i .. "_" .. row .. "_" .. col, Vector3.new(2.5, 3, 0.15), Vector3.new(x + col * 4, 5 + row * 5, 18.92), dark, Enum.Material.Glass, false)
		end
	end
end

-- Stall footprint is 16 x 12 studs. Level 2 stays inside this footprint.
part(stall, "Floor", Vector3.new(16, 0.4, 12), Vector3.new(0, 0.8, 8), cream, Enum.Material.WoodPlanks)
part(stall, "Counter", Vector3.new(16, 2, 2), Vector3.new(0, 2, 2), cream, Enum.Material.Wood)
part(stall, "CounterTop", Vector3.new(16, 0.4, 2.5), Vector3.new(0, 3.2, 2), terra, Enum.Material.Wood)
for _, x in ipairs({-7, 7}) do
	for _, z in ipairs({2, 14}) do
		part(stall, "Post_" .. x .. "_" .. z, Vector3.new(0.7, 9, 0.7), Vector3.new(x, 5.1, z), dark, Enum.Material.Wood)
	end
end
part(stall, "Canopy", Vector3.new(16, 0.6, 12), Vector3.new(0, 9.6, 8), red, Enum.Material.Fabric, false)
for x = -6, 6, 4 do
	part(stall, "CanopyStripe_" .. x, Vector3.new(2, 0.65, 12), Vector3.new(x, 9.63, 8), cream, Enum.Material.Fabric, false)
end
for x = -5, 5, 5 do
	part(stall, "Crate_" .. x, Vector3.new(3, 1.3, 2), Vector3.new(x, 4.05, 2), terra, Enum.Material.Wood, false)
end
local sign = part(stall, "NameSign", Vector3.new(10, 2, 0.35), Vector3.new(0, 7.5, 1.65), dark, Enum.Material.Wood, false)
label(sign, "BLACKSTONE BAZAAR | TEZGÂH 01", cream, 300)
local l2 = Instance.new("Folder")
l2.Name = "Level2Shelf"
l2.Parent = stall
for _, x in ipairs({-5, 5}) do
	local shelf = part(l2, "Shelf_" .. x, Vector3.new(3, 0.5, 5), Vector3.new(x, 4.5, 10), terra, Enum.Material.Wood, false)
	shelf.Transparency = 1
	local goods = part(l2, "Goods_" .. x, Vector3.new(2.5, 1.2, 2), Vector3.new(x, 5.4, 10), red, Enum.Material.SmoothPlastic, false)
	goods.Transparency = 1
end

local sale = part(interaction, "SalePoint", Vector3.new(2, 0.2, 2), Vector3.new(0, 0.72, -1.5), terra, Enum.Material.SmoothPlastic, false)
label(sale, "SATIŞ", cream, 110)
local salePrompt = prompt(sale, "SalePrompt", "Ürünü ver", "Müşteri bekliyor", 11)
salePrompt.Enabled = false
local function panel(name, title, x, action)
	local board = part(interaction, name, Vector3.new(3.5, 4, 0.5), Vector3.new(x, 2.5, 6), dark, Enum.Material.Wood)
	label(board, title, cream, 175)
	local pp = prompt(board, name .. "Prompt", action, title, 11)
	return pp
end
panel("UpgradeBoard", "SEVİYE 2", 12, "Tezgâhı büyüt")
panel("HireBoard", "ÇALIŞAN", 18, "Kasiyer tut")
local pay = panel("PayBoard", "MAAŞ", 24, "Maaşı öde")
pay.Enabled = false

local function marker(name, position)
	local m = part(waypoints, name, Vector3.new(1, 1, 1), position, Color3.new(1, 1, 1), Enum.Material.SmoothPlastic, false)
	m.Transparency = 1
	return m
end
marker("CustomerEntry", Vector3.new(36, 2.8, -4))
marker("CustomerQueue", Vector3.new(0, 2.8, -4))
marker("CustomerExit", Vector3.new(-36, 2.8, -4))
marker("WorkerStand", Vector3.new(5, 2.8, 9))

local spawn = Workspace:FindFirstChildWhichIsA("SpawnLocation")
if spawn then
	spawn.Name = "K0_Spawn"
	spawn.Size = Vector3.new(8, 1, 8)
	spawn.Position = Vector3.new(-40, 1.5, -6)
	spawn.Anchored = true
	spawn.Neutral = true
	spawn.Material = Enum.Material.Neon
	spawn.Color = terra
end
local baseplate = Workspace:FindFirstChild("Baseplate")
if baseplate and baseplate:IsA("BasePart") then
	baseplate.Material = Enum.Material.Sand
	baseplate.Color = Color3.fromRGB(197, 181, 151)
end
Lighting.ClockTime = 17
Lighting.Brightness = 2
Lighting.Ambient = Color3.fromRGB(137, 125, 112)
scene.Parent = Workspace
print("BlackstoneBazaar_K0 scene built", #scene:GetDescendants(), "instances")
