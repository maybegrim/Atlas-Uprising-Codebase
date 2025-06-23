--[[
    CREDITS:
    Atlas Uprising
]]
function GYS.Ban(ply, time, reason, method)
    if ply:IsSuperAdmin() then return end
    if GYS.CustomBanSys then
        GYS.BanSys.banPly(ply:SteamID(), time, reason)
        GYS.Log("Player "..ply:Nick().." was banned for "..reason)
        BroadcastLua("chat.AddText(Color(56, 255, 162), 'GYS | ', Color(255, 255 ,255), '"..ply:Nick().."', ' was suspended due to detection: " .. method .. ".')")
        return
    end
    if GYS.AdminMod == "ulx" then
        ULib.addBan(ply:SteamID(), time, reason, ply:Nick())
        GYS.Log("[GYS] Player "..ply:Nick().." was banned for "..reason)
        BroadcastLua("chat.AddText(Color(56, 255, 162), 'GYS | ', Color(255, 255 ,255), '"..ply:Nick().."', ' was suspended due to detection: " .. method .. ".')")
    elseif GYS.AdminMod == "sam" then
        sam.player.ban_id(ply:SteamID(), time, reason)
        GYS.Log("[GYS] Player "..ply:Nick().." was banned for "..reason)
        BroadcastLua("chat.AddText(Color(56, 255, 162), 'GYS | ', Color(255, 255 ,255), '"..ply:Nick().."', ' was suspended due to detection: " .. method .. ".')")
    end
end

function GYS.GetUserGroup(ply)
    if not ply:IsPlayer() then return "bot" end
    if GYS.AdminMod == "ulx" then
        return ply:GetUserGroup()
    elseif GYS.AdminMod == "sam" then
        return ply:GetUserGroup()
    else
        return ply:GetUserGroup()
    end
end

function GYS.SetUserGroup(ply, rank)
    if GYS.AdminMod == "ulx" then
        ULib.ucl.addUser(ply:SteamID(), nil, nil, rank)
        return
    elseif GYS.AdminMod == "sam" then
        sam.player.set_rank_id(ply:SteamID(), rank, 0)
        ply:SetUserGroup(rank) -- Added due to the fact that this can bug.
        return
    else
        ply:SetUserGroup(rank)
        return
    end
end

function GYS.CheckBan(id)
    if GYS.CustomBanSys then
        return GYS.BanSys.isBanned(id)
    elseif GYS.AdminMod == "ulx" then
        return ULib.bans[id]
    elseif GYS.AdminMod == "sam" then
        sam.player.is_banned(id, function(banned)
            if banned then
                return true
            else
                return false
            end
        end)
    end
end

function GYS.Log(message)
    print("[GYS] " .. message)
end

if not GYS.NetLogger then return end
function net.Incoming( len, client )

	local i = net.ReadHeader()
	local strName = util.NetworkIDToString( i )
	
	if ( !strName ) then return end
	
	local func = net.Receivers[ strName:lower() ]
	if ( !func ) then return end

	--
	-- len includes the 16 bit int which told us the message name
	--
	len = len - 16
	
    local swab = hook.Run("GYS.PreNet", client, strName, len)
    if not swab then return end

	func( len, client )
    hook.Run("GYS.PostNet", client, strName, len)

end