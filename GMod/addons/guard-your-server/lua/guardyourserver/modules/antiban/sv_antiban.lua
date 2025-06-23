--[[
    CREDITS:
    Atlas Uprising
]]
if not GYS.AntiBan then
    return
end
local function AntiBanInit()
    if istable(ULib) and not GYS.CustomBanSys then
        ULib.addBan = function(steamid, time, reason, name, admin)
            if GYS.AntiBanSteamIDs[steamid] then
                GYS.Log("Stopped ban for '" .. steamid .. "' due to GYS.AntiBan.")
                return
            end
            if reason == "" then
                reason = nil
            end
    
            local admin_name
            if admin then
                admin_name = "(Console)"
                if admin:IsValid() then
                    admin_name = string.format("%s(%s)", admin:Name(), admin:SteamID())
                end
            end
    
            -- Clean up passed data
            local t = {}
            local timeNow = os.time()
            if ULib.bans[steamid] then
                t = ULib.bans[steamid]
                t.modified_admin = admin_name
                t.modified_time = timeNow
            else
                t.admin = admin_name
            end
            t.time = t.time or timeNow
            if time > 0 then
                t.unban = ((time * 60) + timeNow)
            else
                t.unban = 0
            end
            t.reason = reason
            t.name = name
            t.steamID = steamid
    
            ULib.bans[steamid] = t
    
            local strTime = time ~= 0 and ULib.secondsToStringTime(time * 60)
            local shortReason = "Banned for " .. (strTime or "eternity")
            if reason then
                shortReason = shortReason .. ": " .. reason
            end
    
            local longReason = shortReason
            if reason or strTime or admin then -- If we have something useful to show
                longReason = "\n" .. ULib.getBanMessage(steamid) .. "\n" -- Newlines because we are forced to show "Disconnect: <msg>."
            end
    
            local ply = player.GetBySteamID(steamid)
            if ply then
                ULib.kick(ply, longReason, nil, true)
            end
    
            -- Remove all semicolons from the reason to prevent command injection
            shortReason = string.gsub(shortReason, ";", "")
    
            -- This redundant kick is to ensure they're kicked -- even if they're joining
            game.ConsoleCommand(string.format("kickid %s %s\n", steamid, shortReason or ""))
    
            writeBan(t)
            hook.Call(ULib.HOOK_USER_BANNED, _, steamid, t)
        end
    elseif istable(SAM) and not GYS.CustomBanSys then
            -- REDACTED CODE FOR SAM SINCE IT'S A PAID ADDON
    elseif istable(gBan) then
            -- REDACTED CODE FOR gBan SINCE IT'S A PAID ADDON
    end
end
timer.Create("GYS.AntiBanLoad", 5, 1, AntiBanInit)
GYS.Log("AntiBan Loaded")