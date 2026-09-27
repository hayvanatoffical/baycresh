-- Baycrest K0 NPC motion (version: K0MarketConfig.Version)
-- K0.4.7 greybox animation for the Part-built figures (ASSET-PROMPTS/04-ANIMATION.md):
-- ANIM-WALK, ANIM-IDLE, ANIM-WAIT-QUEUE, ANIM-HAND-ITEM and ANIM-RECEIVE-ITEM,
-- until rigged characters and animation assets exist. The server moves only each
-- figure's anchored root and builds five Motor6D joints (waist, two shoulders,
-- two hips). This script poses those joints every frame through
-- Motor6D.Transform, which Roblox does not replicate: each client animates what
-- it sees and the network carries nothing extra. Presentation only: nothing here
-- reads or changes the economy, and a figure without joints simply stays still.
local RunService = game:GetService("RunService")

local scene = workspace:WaitForChild("BlackstoneBazaar_K0")

local TAU = 2 * math.pi
-- ANIM-WALK: one cycle (two steps) per second at a customer's usual 6 studs/s.
-- The cycle follows the distance walked, so a faster figure steps faster, up
-- to two cycles a second.
local STRIDE = 6
local MAX_CYCLES = 2
local LEG_SWING, ARM_SWING = 0.5, 0.35 -- radians at full walk
local MOVING = 0.5 -- studs/s; slower counts as standing
local IDLE_PERIOD, WAIT_PERIOD = 3, 4 -- ANIM-IDLE and ANIM-WAIT-QUEUE loops
local HANDOVER = 1.2 -- ANIM-HAND-ITEM and ANIM-RECEIVE-ITEM
local GIVE_ANGLE, RECEIVE_ANGLE = 1.2, 1.0
local CUSTOMER = {Buyer = true, Bargainer = true, Browser = true}

local rigs = {}
local clock = 0

local function track(model)
    if rigs[model] or not model:IsA("Model") or type(model:GetAttribute("NpcRole")) ~= "string" then return end
    local root = model.PrimaryPart
    if not root then
        local pending
        pending = model:GetPropertyChangedSignal("PrimaryPart"):Connect(function()
            pending:Disconnect()
            track(model)
        end)
        return
    end
    local rig = {
        role = model:GetAttribute("NpcRole"), root = root, joints = {}, last = root.Position,
        speed = 0, walk = 0, phase = 0, handover = -math.huge,
        -- Figures do not breathe in step with each other.
        offset = ((tonumber(string.match(model.Name, "%d+")) or 0) * 0.73) % IDLE_PERIOD,
    }
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("Motor6D") then rig.joints[d.Name] = d end
    end
    model.DescendantAdded:Connect(function(d)
        if d:IsA("Motor6D") then rig.joints[d.Name] = d end
    end)
    model:GetAttributeChangedSignal("K0Handover"):Connect(function() rig.handover = clock end)
    rigs[model] = rig
end

local function smooth(x) return x * x * (3 - 2 * x) end

-- 0 -> 1 -> 0 over the clip: reach, hold briefly, return to the standing pose.
local function handoverWeight(since)
    if since < 0 or since >= HANDOVER then return 0 end
    local third = HANDOVER / 3
    if since < third then return smooth(since / third) end
    if since < 2 * third then return 1 end
    return smooth((HANDOVER - since) / third)
end

local function pose(joint, cframe)
    if joint and joint.Parent then joint.Transform = cframe end
end

local function animate(rig, dt)
    local pos = rig.root.Position
    local moved = Vector3.new(pos.X - rig.last.X, 0, pos.Z - rig.last.Z).Magnitude
    rig.last = pos
    if moved > 4 then moved = 0 end -- a placement, not a step
    rig.speed += (moved / dt - rig.speed) * math.min(1, dt * 10)
    rig.walk += ((rig.speed > MOVING and 1 or 0) - rig.walk) * math.min(1, dt * 6)
    rig.phase = (rig.phase + TAU * math.min(moved / STRIDE, MAX_CYCLES * dt)) % TAU

    local j = rig.joints
    local walk, still = rig.walk, 1 - rig.walk
    local step = math.sin(rig.phase)
    local t = clock + rig.offset
    local breathe = math.sin(TAU * t / IDLE_PERIOD)
    local waiting = CUSTOMER[rig.role] and still or 0
    local shift = math.sin(TAU * t / WAIT_PERIOD)

    -- Waist: lean into the walk and rise once per step. Standing, breathe and
    -- shift weight; a waiting customer shifts more and now and then glances
    -- aside and back. A browser leans in and looks along the goods.
    local browser = rig.role == "Browser"
    local lean = -0.05 * walk + still * 0.012 * breathe + (browser and -0.08 * waiting or 0)
    local roll = still * 0.015 * shift + waiting * 0.035 * shift
    local yaw = browser and waiting * 0.3 * math.sin(TAU * t / 6)
        or waiting * 0.2 * math.max(0, math.sin(TAU * t / (2 * WAIT_PERIOD))) ^ 6
    pose(j.Waist, CFrame.new(0, 0.04 * walk * math.abs(step), 0) * CFrame.Angles(lean, yaw, roll))

    -- Legs swing in opposition; arms against the leg on their own side. A
    -- positive angle takes a hanging limb forward (the figure faces -Z).
    pose(j.HipL, CFrame.Angles(LEG_SWING * walk * step, 0, 0))
    pose(j.HipR, CFrame.Angles(-LEG_SWING * walk * step, 0, 0))
    local swing = browser and 0 or ARM_SWING * walk * step -- a browser keeps its hands behind its back
    local left = -swing - still * 0.02 * breathe
    local right = swing - still * 0.02 * breathe
    local leftArm = CFrame.Angles(left, 0, 0)
    local rightArm = CFrame.Angles(right, 0, 0)
    if rig.role == "Bargainer" then
        -- The raised hand stays up and gestures while the bargainer waits.
        rightArm = CFrame.Angles(0, 0, waiting * 0.12 * math.sin(TAU * t / 1.5))
    end

    local give = handoverWeight(clock - rig.handover)
    if give > 0 then
        if rig.role == "Worker" then
            -- ANIM-HAND-ITEM: one hand forward and down onto the counter.
            rightArm = CFrame.Angles(right * (1 - give) + GIVE_ANGLE * give, 0, 0)
        elseif rig.role == "Buyer" or rig.role == "Bargainer" then
            -- ANIM-RECEIVE-ITEM: hands forward at waist height; the bargainer's
            -- raised hand stays where it is.
            leftArm = CFrame.Angles(left * (1 - give) + RECEIVE_ANGLE * give, 0, 0)
            if rig.role == "Buyer" then
                rightArm = CFrame.Angles(right * (1 - give) + RECEIVE_ANGLE * give, 0, 0)
            end
        end
    end
    pose(j.ShoulderL, leftArm)
    pose(j.ShoulderR, rightArm)
end

scene.ChildAdded:Connect(track)
scene.ChildRemoved:Connect(function(child) rigs[child] = nil end)
for _, child in ipairs(scene:GetChildren()) do track(child) end

-- Motor6D.Transform is applied after PreSimulation, just before physics steps.
RunService.PreSimulation:Connect(function(dt)
    if dt <= 0 then return end
    clock += dt
    for model, rig in pairs(rigs) do
        if model.Parent then animate(rig, dt) else rigs[model] = nil end
    end
end)
