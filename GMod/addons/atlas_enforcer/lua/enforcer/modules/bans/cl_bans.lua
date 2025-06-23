ENFORCER.MyBans = ENFORCER.MyBans or {}
ENFORCER.AllBans = ENFORCER.AllBans or {}

ENFORCER.GetBans = function(callback)
    -- Grab ban history because player wouldn't be playing if they were on the active ban db.
    ATLASDATA.RetrieveData({
        t = "enforcer_ban_history",
        p = {steamid = LocalPlayer():SteamID64()}
    },
    function(result, data)
        if result then
            callback(data.data)
        else
            callback(false)
        end
    end)
end

ENFORCER.RetrieveBans = function(complete_fnc)
    ENFORCER.GetBans(function(data)
        if data then
            ENFORCER.MyBans = data
            if complete_fnc then complete_fnc() end
        else
            MsgC(Color(255, 0, 0), "ENFORCER | ", Color(255,255,255), "Failed to retrieve bans, retrying in 5 seconds...\n")
            timer.Simple(5, ENFORCER.RetrieveBans)
        end
    end)
end

ENFORCER.GetAllBans = function(callback)
    local activeBans = {}
    local banHistory = {}
    ATLASDATA.RetrieveData({
        t = "enforcer_bans",
        p = {["1"] = "1"}
    },
    function(result, data)
        if result then
            activeBans = data.data
            ATLASDATA.RetrieveData({
                t = "enforcer_ban_history",
                p = {["1"] = "1"}
            },
            function(result, data)
                if result then
                    banHistory = data.data
                    local bansCombined = {}
                    for k, v in pairs(activeBans) do
                        if v.unban > os.time() then
                            v.active = true
                        else
                            v.active = false
                        end
                        table.insert(bansCombined, v)
                    end
                    for k, v in pairs(banHistory) do
                        v.active = false
                        table.insert(bansCombined, v)
                    end
                    ENFORCER.AllBans = bansCombined
                    callback(bansCombined)
                else
                    callback(false)
                end
            end)
        else
            callback(false)
        end
    end)
end

ENFORCER.RetrieveAllBans = function(complete_fnc)
    if not LocalPlayer():HasPermission("view_ban_db") then return end

    ENFORCER.GetAllBans(function(data)
        if data then
            if complete_fnc then complete_fnc(data) end
        else
            MsgC(Color(255, 0, 0), "ENFORCER | ", Color(255,255,255), "Failed to retrieve bans, retrying in 5 seconds...\n")
            timer.Simple(5, ENFORCER.RetrieveAllBans)
        end
    end)
end

hook.Add("InitPostEntity", "ENFORCER.GetBans", function()
    ENFORCER.RetrieveBans()
end)