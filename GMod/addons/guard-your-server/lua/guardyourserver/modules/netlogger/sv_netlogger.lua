--[[
    CREDITS:
    Atlas Uprising
]]
if not GYS.NetLogger then return end
local roots = {}
GYS.NetLimiter = false
if not GYS.NetLimiter then
    hook.Add("GYS.PreNet", "GYS.LimiterPush", function(client, strName, len)
        return true
    end)
end
hook.Add("GYS.PostNet", "GYS.NetLogger", function(client, strName, len)
    if not table.IsEmpty( GYS.NetLoggerBlacklist ) and GYS.NetLoggerBlacklist[strName] then return end
    GYS.Log("[Net Logger] " .. strName .. " was sent by " .. client:Nick() .. ", ID - " .. client:SteamID())
    if GYS.NetLoggerRoot then
        if table.IsEmpty(roots) then return end
        for _,v in pairs(roots) do
            if not v:GetNWBool("GYS.Logger") then return end
            v:SendLua("chat.AddText(Color(56, 255, 162), '[Net Logger] ', Color(255, 255 ,255), '" .. strName .. "',  ' was sent by' , ' " .. client:Nick() .. "', ', ID - ', '" .. client:SteamID() .. "')")
        end
    end
end)
GYS.Log("NetLogger Loaded")
if not GYS.NetLoggerRoot then return end

hook.Add("PlayerSay", "GYS.LoggerToggle", function( ply, text )
	if string.lower(text) == "/logger" then
		if ply:GetNWBool("GYS.Logger") then
            ply:SetNWBool("GYS.Logger", false)
            ply:SendLua("chat.AddText(Color(56, 255, 162), '[Net Logger] ', Color(255, 255 ,255), 'Disabled!')")
        else
            if GYS.GetUserGroup(ply) == GYS.RootRank and not table.HasValue(roots, ply) then
                ply:SetNWBool("GYS.Logger", true)
                table.insert(roots, ply)
            elseif GYS.NetLoggerRanks[GYS.GetUserGroup(ply)] and not table.HasValue(roots, ply) then
                ply:SetNWBool("GYS.Logger", true)
                table.insert(roots, ply)
            elseif GYS.GetUserGroup(ply) == GYS.RootRank or GYS.NetLoggerRanks[GYS.GetUserGroup(ply)] then
                ply:SetNWBool("GYS.Logger", true)
            end
            ply:SendLua("chat.AddText(Color(56, 255, 162), '[Net Logger] ', Color(255, 255 ,255), 'Enabled!')")
        end
		return ""
	end
end)
GYS.Log("NetLoggerRoot Loaded")