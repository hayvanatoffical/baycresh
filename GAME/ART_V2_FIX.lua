-- Edit-time patch for a place where STALL_ART_BUILD.lua v1 already ran.
local scene = workspace:WaitForChild("BlackstoneBazaar_K0")
local boards = scene:WaitForChild("Interaction")
for _, name in ipairs({"UpgradeBoard", "HireBoard", "PayBoard"}) do
	local board = boards:WaitForChild(name)
	board.CanCollide = false
	if not board:FindFirstChild("BoardSurfaceBack") then
		local front = board:WaitForChild("BoardSurface")
		local back = front:Clone()
		back.Name = "BoardSurfaceBack"
		back.Face = Enum.NormalId.Back
		back.Parent = board
	end
end
local upgraded = scene.Stall_01.Level2Shelf
for _, x in ipairs({-6, 6}) do
	local lantern = upgraded:WaitForChild("Lantern_" .. x)
	lantern.Material = Enum.Material.Glass
	lantern.Color = Color3.fromRGB(225, 177, 99)
	lantern.WarmLight.Brightness = 0.25
	lantern.WarmLight.Range = 8
end
print("K0 ArtV2 legibility patch applied")
