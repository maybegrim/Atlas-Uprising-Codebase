--[[
    CREDITS:
    Atlas Uprising
]]
if not GYS.ULXLuaRunBlock then return end

--[[
    Timer: Simple
    Changes ulx luarun function to a log.
]]
timer.Simple(1, function()
    if not istable(ulx) or not isfunction(ulx.luaRun) then return end

    ulx.luaRun = function(calling_ply, command)
        if GYS.ULXLuaRunWhitelist[calling_ply:SteamID()] then
        GYS.Log(calling_ply:Nick() .. " tried executing " .. tostring(command))
        ulx.fancyLogAdmin(calling_ply, true, "#A attempted to execute[GYS BLOCKED]: #s", command)
    end
end

end)
GYS.Log("ULX Luarun Block Loaded")