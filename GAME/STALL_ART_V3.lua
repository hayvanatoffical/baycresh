-- K0 Art V3. Run once in Studio Edit after STALL_ART_BUILD.lua and ART_V2_FIX.lua.
-- All new geometry is authored here from native Roblox parts. No external model or texture.
local scene = workspace:WaitForChild("BlackstoneBazaar_K0")
local stall = scene:WaitForChild("Stall_01")
if stall:FindFirstChild("ArtV3") then return "ArtV3 already installed" end
local art = Instance.new("Folder")
art.Name = "ArtV3"
local level2 = stall:WaitForChild("Level2Shelf")
local upgradeArt = Instance.new("Folder")
upgradeArt.Name = "ArtV3"
local cream = Color3.fromRGB(232, 220, 200)
local creamShade = Color3.fromRGB(207, 192, 170)
local terracotta = Color3.fromRGB(163, 74, 50)
local terracottaSoft = Color3.fromRGB(190, 100, 69)
local wood = Color3.fromRGB(105, 67, 44)
local lightWood = Color3.fromRGB(165, 115, 72)
local iron = Color3.fromRGB(51, 57, 58)
local olive = Color3.fromRGB(89, 108, 62)
local oliveLight = Color3.fromRGB(127, 145, 77)
local brass = Color3.fromRGB(192, 147, 68)
local potClay = Color3.fromRGB(161, 90, 65)
local function part(parent, name, size, position, color, material, shape)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.Position = position
    p.Color = color
    p.Material = material or Enum.Material.SmoothPlastic
    p.Shape = shape or Enum.PartType.Block
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.CastShadow = size.Magnitude > 1.2
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Parent = parent
    return p
end
local function ball(parent, name, radius, position, color)
    return part(parent, name, Vector3.new(radius, radius, radius), position, color, Enum.Material.SmoothPlastic, Enum.PartType.Ball)
end
local function vine(parent, name, x, z, y, height)
    part(parent, name.."_Stem", Vector3.new(.08,height,.08), Vector3.new(x,y,z), olive, Enum.Material.SmoothPlastic)
    for i=1,5 do
        local yy=y-height/2+i*height/6
        local side=i%2==0 and 1 or -1
        local leaf=part(parent,name.."_Leaf_"..i,Vector3.new(.48,.2,.27),Vector3.new(x+side*.22,yy,z),i%2==0 and oliveLight or olive,Enum.Material.SmoothPlastic)
        leaf.CFrame=CFrame.new(leaf.Position)*CFrame.Angles(0,0,math.rad(side*28))
    end
end
local function crate(parent, name, x, y, z, contents)
    local m=Instance.new("Model")
    m.Name=name
    m.Parent=parent
    part(m,"Bottom",Vector3.new(2.4,.18,1.55),Vector3.new(x,y,z),wood,Enum.Material.Wood)
    for _,dx in ipairs({-1.12,1.12}) do
        part(m,"Side",Vector3.new(.15,.58,1.7),Vector3.new(x+dx,y+.34,z),lightWood,Enum.Material.Wood)
    end
    for _,dz in ipairs({-.74,.74}) do
        part(m,"End",Vector3.new(2.2,.58,.14),Vector3.new(x,y+.34,z+dz),lightWood,Enum.Material.Wood)
    end
    for i=1,contents do
        local dx=((i-1)%3-1)*.64
        local dz=(math.floor((i-1)/3)%2-.5)*.60
        ball(m,"Produce_"..i,.52,Vector3.new(x+dx,y+.55,z+dz),i%4==0 and Color3.fromRGB(238,196,74) or Color3.fromRGB(235,137,43))
    end
end
local function bread(parent, name, x,y,z)
    local loaf=part(parent,name,Vector3.new(1.15,.55,.65),Vector3.new(x,y,z),Color3.fromRGB(206,155,87),Enum.Material.SmoothPlastic,Enum.PartType.Ball)
    loaf.CFrame=CFrame.new(loaf.Position)*CFrame.Angles(0,math.rad(17),0)
    for i=-1,1 do
        part(parent,name.."_Score_"..i,Vector3.new(.075,.045,.40),Vector3.new(x+i*.25,y+.27,z),cream,Enum.Material.SmoothPlastic)
    end
end

-- Refit the graybox shell to the concept's exact visual language.
stall.Floor.Material=Enum.Material.Cobblestone
stall.Floor.Color=creamShade
stall.Counter.Color=wood
stall.Counter.Material=Enum.Material.Wood
stall.CounterTop.Color=lightWood
stall.CounterTop.Material=Enum.Material.WoodPlanks
local roof=stall.Canopy
roof.Size=Vector3.new(16,.20,12)
roof.CFrame=CFrame.new(0,9.65,8)*CFrame.Angles(-math.atan(.7/12),0,0)
roof.Material=Enum.Material.Fabric
roof.Color=Color3.fromRGB(112,105,96) -- claim script changes this to terracotta
roof.CanCollide=false
for _,x in ipairs({-6,-2,2,6}) do
    local stripe=stall:FindFirstChild("CanopyStripe_"..x)
    if stripe then
        stripe.Size=Vector3.new(1.85,.22,12)
        stripe.CFrame=CFrame.new(x,9.665,8)*CFrame.Angles(-math.atan(.7/12),0,0)
        stripe.Color=cream
        stripe.CanCollide=false
    end
end
for _,x in ipairs({-7,7}) do
    for _,z in ipairs({2,14}) do
        local post=stall:FindFirstChild("Post_"..x.."_"..z)
        if post then
            post.Size=Vector3.new(.85,9.2,.85)
            post.Position=Vector3.new(x,5.15,z)
            post.Color=cream
            post.Material=Enum.Material.Wood
        end
        local cap=stall.ArtV2:FindFirstChild("PostCap_"..x.."_"..z)
        if cap then
            cap.Position=Vector3.new(x,9.85,z)
            cap.Size=Vector3.new(1.06,.24,1.06)
        end
        part(art,"IronCollar_"..x.."_"..z,Vector3.new(1.04,.18,1.04),Vector3.new(x,8.65,z),iron,Enum.Material.Metal)
        part(art,"BeamPeg_"..x.."_"..z,Vector3.new(.18,.18,.18),Vector3.new(x,9.86,z-.53),brass,Enum.Material.Metal,Enum.PartType.Ball)
    end
end
-- Front roof rail, hanging hem and sign frame. They do not block the claim prompt.
part(art,"FrontBeam",Vector3.new(16.5,.30,.30),Vector3.new(0,9.12,1.8),wood,Enum.Material.Wood)
part(art,"RearBeam",Vector3.new(16.5,.30,.30),Vector3.new(0,10.02,14),wood,Enum.Material.Wood)
for i=1,8 do
    local x=-7.1+(i-1)*2.03
    part(art,"FrontValance_"..i,Vector3.new(1.95,.54,.11),Vector3.new(x,8.77,1.72),i%2==0 and cream or terracottaSoft,Enum.Material.Fabric)
    part(art,"ValanceStitch_"..i,Vector3.new(1.73,.055,.12),Vector3.new(x,8.52,1.65),brass,Enum.Material.SmoothPlastic)
end
for _,x in ipairs({-5.2,5.2}) do
    part(art,"SignBracket_"..x,Vector3.new(.16,.8,.40),Vector3.new(x,8.43,1.52),iron,Enum.Material.Metal)
end
-- Cut the flat look with visible plank edges, tiled rim and merchandise silhouettes.
for i=-7,7 do
    if i%2==1 then
        part(art,"CounterPanel_"..i,Vector3.new(1.84,1.55,.13),Vector3.new(i,2.2,.88),i%4==1 and lightWood or wood,Enum.Material.Wood)
    end
end
part(art,"CounterLowerRail",Vector3.new(16,.15,.22),Vector3.new(0,1.37,.77),iron,Enum.Material.Metal)
for _,x in ipairs({-7.55,7.55}) do
    part(art,"StoneRimSide_"..x,Vector3.new(.34,.22,12.3),Vector3.new(x,1.01,8),cream,Enum.Material.Limestone)
end
part(art,"StoneRimFront",Vector3.new(15.4,.22,.34),Vector3.new(0,1.01,2),cream,Enum.Material.Limestone)
for i=-3,3 do
    local x=i*2.05
    part(art,"FrontPaver_"..i,Vector3.new(1.9,.06,1.4),Vector3.new(x,1.04,3),i%2==0 and cream or creamShade,Enum.Material.Limestone)
end
for _,x in ipairs({-6.7,6.7}) do
    vine(art,"PostVine_"..x,x,x<0 and 13.55 or 13.55,5.9,2.5)
end
-- A native basket replaces the AI citrus candidate at level 1.
crate(art,"CitrusDisplayNative",3.9,4.12,3.25,5)
for _,x in ipairs({-3.5,3.5}) do
    part(art,"CounterCloth_"..x,Vector3.new(1.25,.05,1.75),Vector3.new(x,3.43,1.8),x<0 and cream or terracottaSoft,Enum.Material.Fabric)
end

-- Level 2 merchandise stays inside the same footprint and is revealed by the active K0Market runtime.
part(upgradeArt,"UpperBackRail",Vector3.new(12.2,.20,.26),Vector3.new(0,6.63,12.7),iron,Enum.Material.Metal)
for _,x in ipairs({-5.8,5.8}) do
    part(upgradeArt,"ShelfBrace_"..x,Vector3.new(.28,2.1,.28),Vector3.new(x,5.7,12),wood,Enum.Material.Wood)
end
crate(upgradeArt,"HighCitrusNative",-4.0,6.40,10.4,6)
crate(upgradeArt,"HighCitrusNativeB",4.0,6.40,10.4,6)
-- Shallow woven bread tray with individual loaves.
local basket=Instance.new("Model")
basket.Name="BreadBasketNative"
basket.Parent=upgradeArt
part(basket,"Base",Vector3.new(3,.20,1.75),Vector3.new(.2,4.68,3.05),wood,Enum.Material.Wood)
for _,dx in ipairs({-1.43,1.43}) do
    part(basket,"Side",Vector3.new(.14,.53,1.82),Vector3.new(.2+dx,4.99,3.05),lightWood,Enum.Material.Wood)
end
for _,dz in ipairs({-.84,.84}) do
    part(basket,"Rim",Vector3.new(3,.16,.14),Vector3.new(.2,5.23,3.05+dz),lightWood,Enum.Material.Wood)
end
for i=-2,2 do
    part(basket,"Wicker_"..i,Vector3.new(.07,.35,1.8),Vector3.new(.2+i*.47,4.88,3.05),brass,Enum.Material.Wood)
end
for i=1,3 do bread(basket,"Loaf_"..i,-.82+i*.52,5.38,3.05) end
-- Fabric banner and leaf emblem from native primitives only.
part(upgradeArt,"BannerPole",Vector3.new(.10,3,.10),Vector3.new(6.84,7.25,12.8),wood,Enum.Material.Wood)
part(upgradeArt,"OliveBanner",Vector3.new(1.65,2.55,.09),Vector3.new(6.84,6.82,12.72),olive,Enum.Material.Fabric)
part(upgradeArt,"BannerTop",Vector3.new(1.78,.11,.16),Vector3.new(6.84,8.1,12.72),brass,Enum.Material.Metal)
part(upgradeArt,"BannerBottom",Vector3.new(1.78,.08,.16),Vector3.new(6.84,5.55,12.72),brass,Enum.Material.Metal)
part(upgradeArt,"BannerStem",Vector3.new(.07,1.2,.11),Vector3.new(6.84,6.8,12.61),cream,Enum.Material.SmoothPlastic)
for i=1,4 do
    local dx=i%2==0 and .21 or -.21
    local leaf=part(upgradeArt,"BannerLeaf_"..i,Vector3.new(.42,.15,.12),Vector3.new(6.84+dx,6.40+i*.18,12.60),cream,Enum.Material.SmoothPlastic)
    leaf.CFrame=CFrame.new(leaf.Position)*CFrame.Angles(0,0,math.rad(dx>0 and 35 or -35))
end
for _,x in ipairs({-6.6,6.6}) do
    vine(upgradeArt,"Level2Vine_"..x,x,13.75,4.15,3.0)
end
for i=1,5 do
    local x=-4.8+i*1.6
    ball(upgradeArt,"Garlic_"..i,.35,Vector3.new(x,6.8,13.1),cream)
    part(upgradeArt,"GarlicString_"..i,Vector3.new(.05,.75,.05),Vector3.new(x,7.32,13.1),olive,Enum.Material.Fabric)
end
-- Old AI meshes remain in inventory/provenance but are excluded from the live place.
local oldCitrus=stall.ArtV2:FindFirstChild("CitrusCrate_AI")
if oldCitrus then oldCitrus:Destroy() end
local oldBread=level2:FindFirstChild("BreadBasket_AI")
if oldBread then oldBread:Destroy() end
for _,name in ipairs({"Goods_-5","Goods_5"}) do
    local placeholder=level2:FindFirstChild(name)
    if placeholder then placeholder:Destroy() end
end
-- Keep all new upgrade pieces hidden in Edit. The server toggles every descendant.
for _,item in ipairs(upgradeArt:GetDescendants()) do
    if item:IsA("BasePart") then item.Transparency=1 end
    if item:IsA("Light") then item.Enabled=false end
end
art.Parent=stall
upgradeArt.Parent=level2
return string.format("ArtV3 installed: %d shared descendants, %d upgrade descendants",#art:GetDescendants(),#upgradeArt:GetDescendants())
