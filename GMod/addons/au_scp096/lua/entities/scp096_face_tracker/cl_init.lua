include("shared.lua")

-- I'm aware this could probably be exploited somehow but it would take
-- too much proccessing power to be viable server side - Ninja
local function EntIsOnScreen(ply, ent)
    if not IsValid(ent) or not IsValid(ply) then return false end
    -- Get the player's view position and angles
    local plyPos = ply:EyePos()
    local plyAngles = ply:EyeAngles()
    local plyFOV = ply:GetFOV()

    -- Get the entity's position
    local entPos = ent:GetPos()
    
    -- Do a trace to check for obstructions
    local trace = util.TraceLine({
        start = plyPos,
        endpos = entPos,
        filter = ply
    })
    
    -- Check if the trace hit the entity
    if trace.Entity == ent then
        -- Calculate the angle between the player and the entity
        local direction = (entPos - plyPos):GetNormalized()
        local angleToEnt = direction:Angle()
        
        -- Calculate the difference between the player's view angles and the angle to the entity
        local yawDiff = math.abs(math.AngleDifference(plyAngles.yaw, angleToEnt.yaw))
        local pitchDiff = math.abs(math.AngleDifference(plyAngles.pitch, angleToEnt.pitch))
        -- Check if the entity is within the player's field of view (e.g., 90 degrees)
        if yawDiff < plyFOV * 0.58 and pitchDiff < plyFOV * 0.37  then
            return true
        end
    end
    
    return false
end


-- Only run check if 096 is within drawing range.
-- Makes sure it is not drawn but ENT:Draw is
-- still called each frame when in drawing distance.
local ply = LocalPlayer()
local checkCD = CurTime()

function ENT:Draw()
    --self:DrawModel()

    local TimeRN = CurTime()
    if checkCD > TimeRN then return end
    checkCD = TimeRN + 0.5
    if not ply or not ply:IsValid() then ply = LocalPlayer() end
    -- Check if player is not 096
    if ply:GetNWBool("SCP:096SAWFACE", false) or not ply:Alive() then return end
    if ply:HasWeapon("AU_scp096_swep") then return end
    if(EntIsOnScreen(ply, self)) then
        net.Start("SCP096PlySawFace")
        net.SendToServer()
    end
end
