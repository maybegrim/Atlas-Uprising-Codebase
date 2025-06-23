ENFORCER.Warn = ENFORCER.Warn or {}

-- Declare Cache Variable
ENFORCER.Warn.Cache = ENFORCER.Warn.Cache or {}

ENFORCER.Warn.LatestID = 0

util.AddNetworkString("ENFORCER::WARN::DeleteWarn")
util.AddNetworkString("ENFORCER::WARN::EditWarn")

-- TODO: Setup network strings for warning

-- Function to issue warning
function ENFORCER.Warn.WarnPlayer(plyOrId, adminPly, reason, evidenceURL)
    if not adminPly:HasPermission("give_warn") then return end

    local plyId = ATLASCORE.UTIL:getSteamID64(plyOrId)

    if not plyId then return end

    local curTimeStamp = os.time()

    local warnID = ENFORCER.Warn.LatestID

    local adminOrAdminId = adminPly:IsPlayer() and adminPly:SteamID64() or adminPly

    if not ENFORCER.Warn.Cache[plyId] then
        ENFORCER.Warn.Cache[plyId] = {warnings = {}}
    end

    ENFORCER.Warn.Cache[plyId].warnings[warnID] = {
        steamid = plyId,
        admin = adminOrAdminId,
        reason = reason,
        time = curTimeStamp,
        id = warnID,
        evidence = evidenceURL
    }

    ENFORCER.Warn.LatestID = warnID + 1

    ENFORCER.DATA.CommitWarning(plyId, reason, adminOrAdminId, evidenceURL, curTimeStamp, function(result, id)
        if result then
            print(id)
        end
    end)
    
    if not adminPly then return end
    ATLASCORE.CHAT.Send(adminPly, Color(255,56,56), "ENFORCER | ", Color(255,255,255), "Warning has been issued.")
    -- Say you just warned BLUE player name
    ATLASCORE.CHAT.Send(adminPly, Color(255,56,56), "| ", Color(255,255,255), "You have warned ", Color(72,153,239), isstring(plyOrId) and plyOrId or IsValid(plyOrId) and isentity(plyOrId) and plyOrId:Name())
    -- then send another that says the reason
    ATLASCORE.CHAT.Send(adminPly, Color(255,56,56), "| ", Color(255,255,255), "Reason: ", Color(255,132,56), reason)
end

-- Function to remove warning
function ENFORCER.Warn.RemoveWarn(plyOrId, warnId, adminPly)
    if not adminPly:HasPermission("delete_warn") then return end

    local plyId = ATLASCORE.UTIL:getSteamID64(plyOrId)
    if not plyId then return end
    PrintTable(ENFORCER.Warn.Cache[plyId])
    PrintTable(ENFORCER.Warn.Cache[plyId].warnings)
    local warn = ENFORCER.Warn.Cache[plyId].warnings[warnId]
    if not warn then return end



    --ENFORCER.DATA.RemoveWarning(warnid, admin, time, callback)
    ENFORCER.DATA.RemoveWarning(warnId, adminOrAdminId, function(result)
        if result then
            ENFORCER.Warn.Cache[plyId].warnings[warnId] = nil
        end
    end)
end

-- Function to edit warning
function ENFORCER.Warn.EditWarn(plyId, warnId, reason, evidence, ply)
    if not ply:HasPermission("edit_warn") then return end

    local warn = ENFORCER.Warn.Cache[plyId].warnings[warnId]
    if not warn then return end

    warn.reason = reason
    warn.evidence = evidence

    --ENFORCER.DATA.EditWarning(warnid, reason, admin, evidence, callback)
    ENFORCER.DATA.EditWarning(warnId, reason, ply:SteamID64(), evidence, function(result)
        if result then
            ENFORCER.Warn.Cache[plyId].warnings[warnId] = warn
        end
    end)
end

hook.Add("ATLASDATA.Ready", "ENFORCER::WARN::Data", function()
    ENFORCER.DATA.GetAllWarns(function(result, data)
        if result then
            for k, v in pairs(data) do
                if ENFORCER.Warn.Cache[v.steamid] == nil then
                    ENFORCER.Warn.Cache[v.steamid] = {warnings = {}}
                end
                ENFORCER.Warn.Cache[v.steamid].warnings[v.id] = v
            end
        end
    end)

    timer.Simple(1, function()
        ENFORCER.DATA.GetWarnID(function(result, id)
            if result then
                ENFORCER.Warn.LatestID = id + 1
            end
        end)
    end)
end)

net.Receive("ENFORCER::WARN::DeleteWarn", function(len, ply)
    local warnId = net.ReadUInt(32)
    local plyId = net.ReadString()

    ENFORCER.Warn.RemoveWarn(plyId, warnId, ply)
end)

net.Receive("ENFORCER::WARN::EditWarn", function(len, ply)
    local warnId = net.ReadUInt(32)
    local plyId = net.ReadString()
    local reason = net.ReadString()
    local evidence = net.ReadString()

    ENFORCER.Warn.EditWarn(plyId, warnId, reason, evidence, ply)
end)