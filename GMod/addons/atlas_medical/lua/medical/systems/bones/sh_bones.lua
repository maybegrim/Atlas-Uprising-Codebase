-- sh_bones.lua

-- Configuration for leg break rate
ATLASMED.BONES.BONE_BREAK_RATE = 0.1
ATLASMED.BONES.HEALTH_REDUCTION_RATE = 0.8

-- Function to check if legs are broken
function ATLASMED.BONES.AreLegsBroken(player)
    return player:GetNWBool("LegsBroken", false)
end
