--[[
    CREDITS:
    Atlas Uprising
]]
if not GYS.RootGuard then return end

--[[
    Hook: GYS.RootGuard
    This is checking everytime a usergroup is changed
    on a player for the root rank being accessed.
]]
if GYS.AdminMod == "ulx" then
    hook.Add("ULibUserGroupChange", "GYS.RootGuard", function(ply_id, _, _, new, old)
        if new ~= GYS.RootRank then return end
        local ply = player.GetBySteamID( ply_id )
        if not GYS.RootAccess[ply_id] then
            GYS.SetUserGroup(ply, "user")
            if GYS.RootBan then
                hook.Run("GYS.Detection", ply, "RootGuard")
                GYS.Ban(ply, 0, "GYS: Accessing Root Rank", "Exploiting")
            elseif not GYS.RootBan then
                hook.Run("GYS.Detection", ply, "RootGuard")
            end
        end
    end)
elseif GYS.AdminMod == "sam" then
    hook.Add("SAM.ChangedPlayerRank", "GYS.RootGuard", function(ply, new, old)
        if new ~= GYS.RootRank then return end
        if not ply:IsPlayer() then return end
        local plyid = ply:SteamID()
        if not GYS.RootAccess[plyid] then
            GYS.SetUserGroup(ply, "user")
            if GYS.RootBan then
                hook.Run("GYS.Detection", ply, "RootGuard")
                GYS.Ban(ply, 0, "GYS: Accessing Root Rank", "Exploiting")
            elseif not GYS.RootBan then
                hook.Run("GYS.Detection", ply, "RootGuard")
            end
        end
    end)
end

--[[
    Hook: GYS.RootGuard.Spawn
    Same as GYS.RootGuard but when a player spawns
    for the first time.
]]
hook.Add( "PlayerAuthed", "GYS.RootGuard.Spawn", function( ply, plyid )
    if ply:IsBot() then return end
    if GYS.GetUserGroup(ply) ~= GYS.RootRank then return end
	if not GYS.RootAccess[plyid] then
        GYS.SetUserGroup(ply, "user")
        if GYS.RootBan then
            hook.Run("GYS.Detection", ply, "RootGuard")
            GYS.Ban(ply, 0, "GYS: Accessing Root Rank", "Exploiting")
        elseif not GYS.RootBan then
            hook.Run("GYS.Detection", ply, "RootGuard")
        end
    end
end)
GYS.Log("RootGuard Loaded")