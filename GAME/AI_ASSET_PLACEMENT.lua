-- Run once in Edit after Roblox Studio's AI mesh jobs finish.
-- Asset IDs and generation tags are recorded in PRODUCTION/ASSET_PROVENANCE.md.
local CollectionService = game:GetService("CollectionService")
local stall = workspace.BlackstoneBazaar_K0.Stall_01
local specs = {
	{
		tag = "Assistant-d5a3646d-55b9-4ab9-8b0b-2f1681f4272d",
		name = "CitrusCrate_AI",
		parent = stall.ArtV2,
		position = Vector3.new(5, 5.75, 2),
		assetId = "140361811304430",
		hiddenUntilUpgrade = false,
	},
	{
		tag = "Assistant-1b27c240-4523-4a2a-9fe3-48ad49ec02af",
		name = "BreadBasket_AI",
		parent = stall.Level2Shelf,
		position = Vector3.new(0, 7.2, 11.3),
		assetId = "115094943790841",
		hiddenUntilUpgrade = true,
	},
}
for _, spec in specs do
	if not spec.parent:FindFirstChild(spec.name) then
		local source = CollectionService:GetTagged(spec.tag)[1]
		assert(source and source:IsA("Model"), "Missing generated candidate: " .. spec.tag)
		for _, child in source:GetDescendants() do
			assert(not child:IsA("BaseScript") and not child:IsA("RemoteEvent") and not child:IsA("RemoteFunction"), "Unexpected executable child in " .. spec.name)
			if child:IsA("BasePart") then
				child.Anchored = true
				child.CanCollide = false
				child.CanTouch = false
				child.CanQuery = false
				child.Transparency = spec.hiddenUntilUpgrade and 1 or 0
			end
		end
		source.Name = spec.name
		source:SetAttribute("PublishedAssetId", spec.assetId)
		source:SetAttribute("Source", "Roblox Studio AI mesh generation")
		source:PivotTo(CFrame.new(spec.position))
		source.Parent = spec.parent
	end
end
print("K0 generated produce props placed")
