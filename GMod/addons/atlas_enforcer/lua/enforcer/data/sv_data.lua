ENFORCER.DATA = ENFORCER.DATA or {}

-- Tables for Atlas Data to setup. Seperate file for better structure.
local dataTables = include("enforcer/data/tables/tables.lua")

-- Function that will go setup all the tables for Atlas Data
function ENFORCER.DATA.Setup()
    -- Atlas Data setup
    for k, v in pairs(dataTables) do
        print(v.name)
        ATLASDATA.CreateTable(v.name, v.columns, function(result, body)
            if result then
                print("ENFORCER | Successfully created table " .. v.name)
            else
                print("ENFORCER | Failed to create table " .. v.name)
                print(body)
            end
        end)
    end
end

-- Function that will go commit a ban to Atlas Ddta
function ENFORCER.DATA.CommitBan(steamid, name, reason, admin, time, unban, evidence, callback)
    -- TODO: Validate params. I don't think we need to escape any params because Atlas Data is escaping them but we can check.

    local paramTable = {
        steamid = steamid,
        name = name,
        reason = reason,
        admin = admin,
        time = time,
        unban = unban,
        evidence = evidence
    }
    ATLASDATA.CommitData("enforcer_bans", paramTable, function(pResult, data)
        -- TODO: If commit fails retry. To check if it failed we can check the success json value if it even exists.
        if pResult then
            if callback then callback(true) end
        else
            -- TODO: Following up with the previous TODO. If pResult is false/nil then that means server is not reachable. We should retry here no checks.
            if callback then callback(false, data) end
        end
    end)
end

-- Function that will go retrieve active ban info for a specific steamid
function ENFORCER.DATA.GetBanInfo(sid, callback)
    local paramTable = {
        steamid = sid
    }
    ATLASDATA.RequestData("enforcer_bans", paramTable, function(result, data)
        if result then
            callback(true, data.data)
        else
            callback(false)
        end
    end)
end

-- Function that will go retrieve all active bans. Used currently for cache.
function ENFORCER.DATA.GetAllBans(callback)
    -- 1 = 1 in string format ONLY! Changing this to any other format will fuck it. Yes I Coded Atlas Data, yes I didn't think of fetching all data - Mal
    local paramTable = {["1"] = "1"}

    ATLASDATA.RequestData("enforcer_bans", paramTable, function(result, data)
        if result then
            callback(true, data.data)
        else
            callback(false)
        end
    end)
end

function ENFORCER.DATA.RemoveBan(steamid, admin, unbanReason, callback)
    ENFORCER.DATA.GetBanInfo(steamid, function(result, pData)
        pData = pData[1]
        -- Atlas Data
        local paramTable = {
            steamid = pData.steamid,
            name = pData.name,
            reason = pData.reason,
            admin = pData.admin,
            time = pData.time,
            unban = os.time(),
            evidence = pData.evidence,
            unban_reason = unbanReason or "Not specified."
        }
        ATLASDATA.CommitData("enforcer_ban_history", paramTable, function(pResult, data)
            if pResult then
                -- Should have worked. We will come back around with checks
            end
        end)

        -- Atlas Data
        ATLASDATA.DeleteData("enforcer_bans", "steamid", steamid, function(result, data)
            if result then
                if callback then callback(true) end
            end
        end)
    end)
end

function ENFORCER.DATA.CommitWarning(steamid, reason, admin, evidence, time, callback)
    local paramTable = {
        steamid = steamid,
        reason = reason,
        admin = admin,
        time = time,
        evidence = evidence
    }
    ATLASDATA.CommitData("enforcer_warnings", paramTable, function(result, data)
        if result then
            print(data)
            callback(true, data.data.insertId)
        else
            callback(false, data)
        end
    end)
end

function ENFORCER.DATA.RemoveWarning(warnid, admin, callback)
    ATLASDATA.DeleteData("enforcer_warnings", "id", warnid, function(result, data)
        if result then
            if callback then callback(true) end
        else
            if callback then callback(false) end
        end
    end)
end

function ENFORCER.DATA.GetWarnID(callback)
    -- Get the latest id
    local paramTable = {["1"] = "1"}
    ATLASDATA.RequestData("enforcer_warnings", paramTable, function(result, data)
        if result then
            -- get the largest id
            local largestID = 0
            for k, v in pairs(data.data) do
                if v.id > largestID then
                    largestID = v.id
                end
            end
            callback(true, largestID)
        else
            callback(false)
        end
    end)
end

function ENFORCER.DATA.GetAllWarns(callback)
    local paramTable = {["1"] = "1"}
    ATLASDATA.RequestData("enforcer_warnings", paramTable, function(result, data)
        if result then
            callback(true, data.data)
        else
            callback(false)
        end
    end)
end

function ENFORCER.DATA.EditWarning(warnid, reason, admin, evidence, callback)
    local paramTable = {
        id = warnid,
        reason = reason,
        admin = admin,
        evidence = evidence
    }
    ATLASDATA.CommitData("enforcer_warnings", paramTable, function(result, data)
        if result then
            callback(true)
        else
            callback(false)
        end
    end)
end

-- When Atlas Data is ready we can call setup
hook.Add("ATLASDATA.Ready", "ENFORCER.DATA.Setup", function()
    ENFORCER.DATA.Setup()
end)