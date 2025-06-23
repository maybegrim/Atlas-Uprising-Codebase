ATLASSCPSWEPS.SCP106 = ATLASSCPSWEPS.SCP106 or {}

ATLASSCPSWEPS.SCP106.PocketDimension = Vector(-929.014832, 4948.749023, 19.436424)

function ATLASSCPSWEPS.SCP106.SetPDPos(vector)
    if !vector then return end
    if !vector.x or !vector.y or !vector.z then return end
    ATLASSCPSWEPS.SCP106.PocketDimension = vector
end

hook.Add("ShouldCollide", "ATLASSCPSWEPS.SCP106.ShouldCollide", function(ent1, ent2)
    if !IsValid(ent1) or !IsValid(ent2) then return end
    if ent1:IsPlayer() and not ent1:HasWeapon("atlas_scp_106") then return end
    if ent2:IsPlayer() and not ent2:HasWeapon("atlas_scp_106") then return end
    if ent1:GetModel() == "models/props/106zelle_neu.mdl" or ent2:GetModel() == "models/props/106zelle_neu.mdl" then
        return
    end
    -- if ent is func_door
    if ent1:GetClass() == "prop_door_rotating" or ent2:GetClass() == "prop_door_rotating" then
        return false
    elseif ent1:GetClass() == "func_door" or ent2:GetClass() == "func_door" then
        return false
    elseif ent1:GetClass() == "prop_dynamic" or ent2:GetClass() == "prop_dynamic" then
        return false
    end
    return
end)