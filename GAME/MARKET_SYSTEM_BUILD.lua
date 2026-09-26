-- Run once in Studio Edit after SCENE_BUILD, STALL_ART_BUILD, ART_V2_FIX and STALL_ART_V3.
-- Product displays are a separate scene layer. Replacing the stall model does not change SKU logic.
local scene=workspace:WaitForChild("BlackstoneBazaar_K0")
if scene:FindFirstChild("MarketSystem") then return "MarketSystem already installed" end
local stall=scene:WaitForChild("Stall_01")
local interaction=scene:WaitForChild("Interaction")
local market=Instance.new("Folder")
market.Name="MarketSystem"
local displays=Instance.new("Folder")
displays.Name="ProductDisplays"
local cream=Color3.fromRGB(232,220,200)
local dark=Color3.fromRGB(49,58,61)
local wood=Color3.fromRGB(118,78,50)
local terra=Color3.fromRGB(163,74,50)
local olive=Color3.fromRGB(96,115,69)
local function part(parent,name,size,pos,color,material,shape)
    local p=Instance.new("Part")
    p.Name=name
    p.Size=size
    p.Position=pos
    p.Color=color
    p.Material=material or Enum.Material.SmoothPlastic
    p.Shape=shape or Enum.PartType.Block
    p.Anchored=true
    p.CanCollide=false
    p.CanTouch=false
    p.CanQuery=false
    p.TopSurface=Enum.SurfaceType.Smooth
    p.BottomSurface=Enum.SurfaceType.Smooth
    p.Parent=parent
    return p
end
local function board(parent,name,pos,color,heading,detail)
    local p=part(parent,name,Vector3.new(4,4,.34),pos,color,Enum.Material.Wood)
    for _,face in ipairs({Enum.NormalId.Front,Enum.NormalId.Back}) do
        local gui=Instance.new("SurfaceGui")
        gui.Face=face
        gui.Name="BoardFace"
        gui.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud
        gui.PixelsPerStud=48
        gui.LightInfluence=0
        gui.Parent=p
        local title=Instance.new("TextLabel")
        title.Name="Heading"
        title.BackgroundTransparency=1
        title.Position=UDim2.fromScale(.06,.13)
        title.Size=UDim2.fromScale(.88,.28)
        title.Font=Enum.Font.GothamBold
        title.TextScaled=true
        title.TextColor3=cream
        title.Text=heading
        title.Parent=gui
        local small=title:Clone()
        small.Name="Detail"
        small.Position=UDim2.fromScale(.07,.55)
        small.Size=UDim2.fromScale(.86,.21)
        small.Font=Enum.Font.GothamMedium
        small.Text=detail
        small.Parent=gui
    end
    return p
end
local function prompt(parent,name,action,object)
    local p=Instance.new("ProximityPrompt")
    p.Name=name
    p.ActionText=action
    p.ObjectText=object
    p.HoldDuration=.35
    p.MaxActivationDistance=11
    p.RequiresLineOfSight=false
    p.KeyboardKeyCode=Enum.KeyCode.E
    p.Parent=parent
    return p
end
local office=board(market,"PermitOffice",Vector3.new(-31,2.5,7),dark,"PAZAR YÖNETİMİ","PAZAR KAYDI 70 ₡")
prompt(office,"PermitPrompt","Pazar kaydını yap","Pazar yönetimi")
board(market,"DemandBoard",Vector3.new(-25.5,2.5,7),olive,"BUGÜN TALEP","OYUN BAŞLAYINCA GÜNCELLENİR")
local oranges=board(market,"OrangeWholesale",Vector3.new(-20,2.5,7),terra,"TOPTAN PORTAKAL","8 kg  /  48 ₡")
prompt(oranges,"OrangeRestockPrompt","8 kg stok al","Toptancı")
local bread=board(market,"BreadWholesale",Vector3.new(-14,2.5,7),wood,"TOPTAN EKMEK","6 adet  /  48 ₡")
prompt(bread,"BreadRestockPrompt","6 ekmek al","Toptancı")
part(market,"OfficeLamp",Vector3.new(.35,.35,.35),Vector3.new(-31,5.0,7),Color3.fromRGB(230,188,113),Enum.Material.Glass,Enum.PartType.Ball)
part(market,"StockCrateOrange",Vector3.new(3,1.1,1.2),Vector3.new(-20,1,7.5),wood,Enum.Material.Wood)
part(market,"StockCrateBread",Vector3.new(3,1.1,1.2),Vector3.new(-14,1,7.5),wood,Enum.Material.Wood)
local function priceTag(name,pos,line)
    local p=part(displays,name,Vector3.new(2.8,.72,.12),pos,dark,Enum.Material.Wood)
    local gui=Instance.new("SurfaceGui")
    gui.Face=Enum.NormalId.Front
    gui.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud
    gui.PixelsPerStud=60
    gui.LightInfluence=0
    gui.Parent=p
    local t=Instance.new("TextLabel")
    t.Name="Price"
    t.Size=UDim2.fromScale(1,1)
    t.BackgroundTransparency=1
    t.Font=Enum.Font.GothamBold
    t.TextScaled=true
    t.TextColor3=cream
    t.Text=line
    t.Parent=gui
    return p
end
priceTag("OrangePrice",Vector3.new(-5,3.55,.71),"PORTAKAL 14 ₡/kg")
priceTag("BreadPrice",Vector3.new(0,3.55,.71),"EKMEK 18 ₡/adet")
local function productModel(name,sku)
    local m=Instance.new("Model")
    m.Name=name
    m:SetAttribute("SKU",sku)
    m.Parent=displays
    return m
end
local orangeFront=productModel("OrangeFront","orange")
local orangeUpper=productModel("OrangeUpper","orange")
local breadFront=productModel("BreadFront","bread")
local breadUpper=productModel("BreadUpper","bread")
for i=1,8 do
    local col=(i-1)%4
    local row=math.floor((i-1)/4)
    local fruit=part(orangeFront,"Unit_"..i,Vector3.new(.62,.62,.62),Vector3.new(-6.1+col*.72,4.95,2+row*.57),Color3.fromRGB(238,143,47),Enum.Material.SmoothPlastic,Enum.PartType.Ball)
    fruit.Transparency=1
    local upper=part(orangeUpper,"Unit_"..i,Vector3.new(.62,.62,.62),Vector3.new(-6.1+col*.72,6.72,10.35+row*.57),Color3.fromRGB(238,143,47),Enum.Material.SmoothPlastic,Enum.PartType.Ball)
    upper.Transparency=1
end
local function loaf(parent,i,x,y,z)
    local p=part(parent,"Unit_"..i,Vector3.new(.96,.52,.62),Vector3.new(x,y,z),Color3.fromRGB(205,151,87),Enum.Material.SmoothPlastic,Enum.PartType.Ball)
    p.Transparency=1
end
for i=1,6 do
    local col=(i-1)%3
    local row=math.floor((i-1)/3)
    loaf(breadFront,i,-.92+col*.92,4.96,1.65+row*.6)
    loaf(breadUpper,i,-.92+col*.92,6.75,10.15+row*.6)
end
-- Remove product-shaped props from the stall shell. Only SKU displays above show merchandise.
for _,name in ipairs({"OrangeCrate","LemonCrate","Bread_1","Bread_2","Bread_1_Score-1","Bread_1_Score0","Bread_1_Score1","Bread_2_Score-1","Bread_2_Score0","Bread_2_Score1"}) do
    local x=stall.ArtV2:FindFirstChild(name)
    if x then x:Destroy() end
end
local v3=stall:FindFirstChild("ArtV3")
if v3 then
    local x=v3:FindFirstChild("CitrusDisplayNative")
    if x then x:Destroy() end
end
local l2=stall.Level2Shelf
for _,child in ipairs(l2:GetChildren()) do
    if child.Name=="TomatoCrate" or child.Name=="FullCitrusCrate" or child.Name=="ExtraLemons" or child.Name=="ExtraOranges" or string.find(child.Name,"^ExtraBread_") then child:Destroy() end
end
local l2v3=l2:FindFirstChild("ArtV3")
if l2v3 then
    for _,name in ipairs({"HighCitrusNative","HighCitrusNativeB","BreadBasketNative"}) do
        local x=l2v3:FindFirstChild(name)
        if x then x:Destroy() end
    end
    for _,child in ipairs(l2v3:GetChildren()) do
        if string.find(child.Name,"^Garlic_") or string.find(child.Name,"^GarlicString_") then child:Destroy() end
    end
end
local upgrade=interaction.UpgradeBoard
for _,guiName in ipairs({"BoardSurface","BoardSurfaceBack"}) do
    local gui=upgrade:FindFirstChild(guiName)
    if gui and gui:FindFirstChild("Detail") then gui.Detail.Text="250 ₡ / DAHA ÇOK STOK" end
end
upgrade.UpgradeBoardPrompt.ActionText="Rafları büyüt"
interaction.SalePoint.SalePrompt.ActionText="Teklife bak"
market.Parent=scene
displays.Parent=scene
return string.format("MarketSystem ready; %d display units",#orangeFront:GetChildren()+#orangeUpper:GetChildren()+#breadFront:GetChildren()+#breadUpper:GetChildren())
