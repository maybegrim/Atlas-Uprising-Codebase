--[[
    CREDITS:
    Atlas Uprising
]]
if not GYS.NPCGuard then return end

--[[
    Hook: GYS.NPCGuard
    This is seeing if someone spawned an NPC
    that doesn't have permission to due so.
]]
hook.Add( "OnEntityCreated", "GYS.NPCGuard", function(ent)
    if IsValid(ent) and ent:IsNPC() then
        local ply = ent:GetOwner()
        if not ply:IsPlayer() then return end
        if ply:IsSuperAdmin() then return end
        if not GYS.NPCRanks[GYS.GetUserGroup(ply)] then
            hook.Run("GYS.Detection", ply, "NPCGuard")
            ent:Remove()
            GYS.Ban(ply, 0, "GYS: Exploiting NPCs", "Exploiting")
        end
    end
end )
GYS.Log("NPCGuard Loaded")