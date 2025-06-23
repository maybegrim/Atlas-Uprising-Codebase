--[[
    CREDITS:
    Atlas Uprising
]]
if not GYS.Sandbox then return end

--[[
    Module: Sandbox
    This is changing all ban/kick functions to logs as protection.
]]
if GYS.CustomBanSys then
    --[[if GYS.BanSys == "gban" then
        gBan:PlayerBan = function(caller, target, time, reason)
            GYS.Log("GBAN: " .. caller:Nick() .. " tried banning " .. target:Nick() .. ". reason: " .. reason .. " for " .. tostring(time))
        end
        gBan:PlayerBanID = function(caller, steamid, time, reason, edit)
            GYS.Log("GBAN: " .. caller:Nick() .. " tried banning " .. steamid .. ". reason: " .. reason .. " for " .. tostring(time))
        end
        gBan:PlayerUnban = function(caller, steamid)
            GYS.Log("ULX: " caller:Nick() .. " tried unbanning " .. tostring(steamid))
        end
    end]]
elseif GYS.AdminMod == "ulx" then
    ULib.kick = function(ply, reason, calling_ply)
        GYS.Log("ULX: " .. calling_ply:Nick() .. " tried calling kick on " .. ply:Nick() .. " for reason: " .. reason)
    end
    ULib.ban = function(ply, time, reason, admin)
        GYS.Log("ULX: " .. admin:Nick() .. " tried banning " .. ply:Nick() .. ". reason: " .. reason .. " for " .. tostring(time))
    end
    ULib.addBan = function(ply, time, reason, admin)
        GYS.Log("ULX: " .. admin:Nick() .. " tried banning " .. ply:Nick() .. ". reason: " .. reason .. " for " .. tostring(time))
    end
    ULib.unban = function(steamid, admin)
        GYS.Log("ULX: " .. admin:Nick() .. " tried unbanning " .. tostring(steamid))
    end
elseif GYS.AdminMod == "sam" then
    sam.player.ban = function(ply, length, reason, admin_steamid)
        local admin = util.GetBySteamID(admin_steamid)
        GYS.Log("SAM: " .. admin:Nick() .. " tried banning " .. ply:Nick() .. ". reason: " .. reason .. " for " .. tostring(length))
    end
    sam.player.ban_id = function(steamid, length, reason, admin_steamid)
        local admin = util.GetBySteamID(admin_steamid)
        GYS.Log("SAM: " .. admin:Nick() .. " tried banning " .. steamid .. ". reason: " .. reason .. " for " .. tostring(length))
    end
    sam.player.unban = function(steamid, admin)
        local adminply = util.GetBySteamID(admin)
        GYS.Log("SAM: " .. adminply:Nick() .. " tried unbanning " .. tostring(steamid))
    end
end
GYS.Log("GYS Sandbox Loaded")