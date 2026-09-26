-- Run once in Roblox Studio Edit mode on an existing BlackstoneBazaar_K0 scene.
-- Safe to run repeatedly. It adds/updates only the small K0 Market world-facing pieces.
local scene = workspace:WaitForChild("BlackstoneBazaar_K0")
local market = scene:WaitForChild("MarketSystem")
local stall = scene:WaitForChild("Stall_01")
local interaction = scene:WaitForChild("Interaction")

local cream = Color3.fromRGB(232, 220, 200)
local dark = Color3.fromRGB(49, 58, 61)
local olive = Color3.fromRGB(96, 115, 69)

local function disableLegacyRuntime()
    local server = game:GetService("ServerScriptService"):FindFirstChild("K0Game")
    local starterScripts = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
    local client = starterScripts:FindFirstChild("K0HUD")

    for _, item in ipairs({server, client}) do
        if item and item:IsA("BaseScript") and not item.Disabled then
            item.Disabled = true
            print("Baycrest K0 migration disabled legacy runtime:", item:GetFullName())
        end
    end
end

disableLegacyRuntime()

local function ensureDemandBoard()
    local board = market:FindFirstChild("DemandBoard")
    if not board then
        board = Instance.new("Part")
        board.Name = "DemandBoard"
        board.Size = Vector3.new(4, 4, 0.34)
        board.Position = Vector3.new(-25.5, 2.5, 7)
        board.Color = olive
        board.Material = Enum.Material.Wood
        board.Anchored = true
        board.CanCollide = false
        board.CanTouch = false
        board.CanQuery = false
        board.Parent = market
    end
    -- MARKET_SYSTEM_BUILD already gives the board a "BoardFace" SurfaceGui on each
    -- face. Up to K0.4 this migration added its own on top, so every face drew two
    -- text layers. Only add a face that is missing, and remove the extra copy
    -- earlier runs left behind.
    local function otherGuiOnFace(face, except)
        for _, child in ipairs(board:GetChildren()) do
            if child ~= except and child:IsA("SurfaceGui") and child.Face == face then return child end
        end
        return nil
    end
    for _, face in ipairs({Enum.NormalId.Front, Enum.NormalId.Back}) do
        local guiName = face == Enum.NormalId.Front and "DemandFront" or "DemandBack"
        local gui = board:FindFirstChild(guiName)
        if gui and otherGuiOnFace(face, gui) then
            gui:Destroy()
            gui = nil
            print("Baycrest K0 migration removed duplicate DemandBoard text layer:", guiName)
        elseif not gui and otherGuiOnFace(face, nil) then
            gui = otherGuiOnFace(face, nil)
        end
        if not gui then
            gui = Instance.new("SurfaceGui")
            gui.Name = guiName
            gui.Face = face
            gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
            gui.PixelsPerStud = 48
            gui.LightInfluence = 0
            gui.Parent = board
            local heading = Instance.new("TextLabel")
            heading.Name = "Heading"
            heading.BackgroundTransparency = 1
            heading.Position = UDim2.fromScale(0.06, 0.13)
            heading.Size = UDim2.fromScale(0.88, 0.28)
            heading.Font = Enum.Font.GothamBold
            heading.TextScaled = true
            heading.TextColor3 = cream
            heading.Text = "BUGÜN TALEP"
            heading.Parent = gui
            local detail = heading:Clone()
            detail.Name = "Detail"
            detail.Position = UDim2.fromScale(0.07, 0.55)
            detail.Size = UDim2.fromScale(0.86, 0.21)
            detail.Font = Enum.Font.GothamMedium
            detail.Text = "OYUN BAŞLAYINCA GÜNCELLENİR"
            detail.Parent = gui
        end
    end
    return board
end

local board = ensureDemandBoard()
local permit = market.PermitOffice:FindFirstChild("PermitPrompt")
if permit then
    permit.ActionText = "Pazar kaydını yap"
    permit.ObjectText = "Pazar yönetimi"
end
local claim = stall.NameSign:FindFirstChild("ClaimPrompt")
if claim then claim.ActionText = "Tezgâhı sahiplen" end
local sale = interaction.SalePoint:FindFirstChild("SalePrompt")
if sale then sale.ActionText = "Teklife bak" end

print("Baycrest K0 Market migration ready", board:GetFullName())
