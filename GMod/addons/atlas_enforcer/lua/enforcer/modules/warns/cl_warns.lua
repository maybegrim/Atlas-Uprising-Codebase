ENFORCER.MyWarnings = ENFORCER.MyWarnings or {}
ENFORCER.AllWarnings = ENFORCER.AllWarnings or {}

ENFORCER.GetWarnings = function(callback)
    ATLASDATA.RetrieveData({
        t = "enforcer_warnings",
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

ENFORCER.RetrieveWarnings = function(complete_fnc)
    ENFORCER.GetWarnings(function(data)
        if data then
            ENFORCER.MyWarnings = data
            if complete_fnc then complete_fnc() end
        else
            MsgC(Color(255, 0, 0), "ENFORCER | ", Color(255,255,255), "Failed to retrieve warnings, retrying in 5 seconds...\n")
            timer.Simple(5, ENFORCER.RetrieveWarnings)
        end
    end)
end

ENFORCER.GetAllWarns = function(callback)
    ATLASDATA.RetrieveData({
        t = "enforcer_warnings",
        p = {["1"] = "1"}
    },
    function(result, data)
        if result then
            ENFORCER.AllWarnings = data.data
            callback(data.data)
        else
            callback(false)
        end
    end)
end

ENFORCER.RetrieveAllWarnings = function(complete_fnc)
    if not LocalPlayer():HasPermission("view_warning_db") then return end

    ENFORCER.GetAllWarns(function(data)
        if data then
            if complete_fnc then complete_fnc(data) end
        else
            MsgC(Color(255, 0, 0), "ENFORCER | ", Color(255,255,255), "Failed to retrieve warnings, retrying in 5 seconds...\n")
            timer.Simple(5, ENFORCER.RetrieveAllWarnings)
        end
    end)
end

ENFORCER.EditWarningSubmit = function(warningData)
    net.Start("ENFORCER::WARN::EditWarn")
        net.WriteInt(warningData.id, 32)
        net.WriteString(warningData.steamid)
        net.WriteString(warningData.reason)
        net.WriteString(warningData.evidence)
    net.SendToServer()
end

hook.Add("InitPostEntity", "ENFORCER.GetWarnings", function()
    ENFORCER.RetrieveWarnings()
end)