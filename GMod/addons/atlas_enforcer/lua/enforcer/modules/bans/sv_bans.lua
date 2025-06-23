ENFORCER.Ban = ENFORCER.Ban or {}

ENFORCER.Ban.Cache = ENFORCER.Ban.Cache or {}

ENFORCER.Ban.IsBanDataReady = ENFORCER.Ban.IsBanDataReady or false

util.AddNetworkString("ENFORCER::BAN::REMOVE")

-- Utility function to get the ban reason for a player
local function getBanReason(pId)
    local banData = ENFORCER.Ban.Cache[pId]
    if not banData then return "Unknown" end
    local banMsg = "[ATLAS ENFORCER]\nYou're banned from this server.\nReason: " .. banData.reason .. "\nUnban time: " .. os.date("%c", banData.unban)
    return banMsg
end

-- TODO: Add a cooldown for bans. Rogue mods, etc

function ENFORCER.Ban.Player(pPlyOrId, pAdmin, pLength, pReason, pEvidence)
    local plyId = ATLASCORE.UTIL:getSteamID64(pPlyOrId)

    if not plyId then
        print("Invalid player to ban")
        return false, "Invalid player to ban"
    end

    local plyAdminId = type(pAdmin) == "string" and ATLASCORE.UTIL:getSteamID64(pAdmin) or "Console"

    if not plyAdminId then
        print("Invalid admin")
        return false, "Invalid admin"
    end

    if not pLength or type(pLength) ~= "number" then
        print("Invalid ban length")
        return false, "Invalid ban length"
    end

    if not pReason or type(pReason) ~= "string" or pReason == "" then
        print("Invalid ban reason")
        pReason = "No reason specified."
    end

    if not pEvidence or type(pEvidence) ~= "string" or pEvidence == "" then
        pEvidence = "No evidence specified."
    end

    local ply = type(pPlyOrId) == "Player" and pPlyOrId or ATLASCORE.UTIL:getPlayerBySteamID(pPlyOrId) and ATLASCORE.UTIL:getPlayerBySteamID(pPlyOrId) or false

    if not plyId then return end

    local length = pLength == 0 and 0 or os.time() + (pLength * 60)

    ENFORCER.Ban.Cache[plyId] = {reason = pReason, unban = length}

    ENFORCER.DATA.CommitBan(plyId, ply and ply:Nick() or "Unknown", pReason,  plyAdminId, os.time(), length, pEvidence)

    if ply then
        ply:Kick("ENFORCER | [BAN] " .. pReason)
    end
end

function ENFORCER.Ban.Update(pPlyOrId, pAdmin, pLength, pReason, pEvidence)
    local plyId = ATLASCORE.UTIL:getSteamID64(pPlyOrId)

    if not plyId then
        return false, "Invalid player to update ban"
    end

    -- Fetch the current ban info from the cache
    local currentBan = ENFORCER.Ban.Cache[plyId]

    -- If a ban exists, display or log the current ban details
    if currentBan then
        print(string.format("Current ban for player %s: Reason: %s, Unban time: %s", plyId, currentBan.reason, currentBan.unban))
        -- TODO: Do more with this information if needed, like sending it to the admin
    else
        return false, "No existing ban found for this player"
    end

    -- Call the original ban function to overwrite the ban
    return ENFORCER.Ban.Player(pPlyOrId, pAdmin, pLength, pReason, pEvidence)
end


function ENFORCER.Ban.IsBanned(pId)
    if not ATLASCORE.UTIL:IsSteamID(pId) then
        return false
    end

    local banData = ENFORCER.Ban.Cache[pId]
    if banData and banData.unban > os.time() then
        return true
    end

    if banData and banData.unban == 0 then
        return true
    end

    if banData then
        ENFORCER.Ban.Unban(pId, false, "Ban expired.")
    end
    return false
end

function ENFORCER.Ban.Unban(pSID, pAdmin, pReason)
    if not ATLASCORE.UTIL:IsSteamID(pSID) then
        return false, "Invalid Steam ID"
    end

    pSID = ATLASCORE.UTIL:getSteamID64(pSID)
    if not pSID or type(pSID) ~= "string" then
        return false, "Invalid Steam ID"
    end

    if not pAdmin or type(pSID) ~= "Player" then
        pAdmin = "Console"
    end

    if not pReason or type(pReason) ~= "string" or pReason == "" then
        pReason = "No reason specified." -- Default reason if none is provided
    end

    local adminSteamId = type(pAdmin) == "Player" and pAdmin:SteamID64() or false  -- Assuming the admin's Steam ID is required

    -- TODO: Add reason to ban removal
    ENFORCER.DATA.RemoveBan(pSID, adminSteamId or "Console", pReason, function(pResult)
        if pResult then
            ENFORCER.Ban.Cache[pSID] = nil
            if not pAdmin then return end
            ATLASCORE.CHAT.Send(pAdmin, Color(255,56,56), "ENFORCER | ", Color(255,255,255), "Successfully unbanned player with SteamID " .. pSID .. ".")
        else
            if not pAdmin then return end
            ATLASCORE.CHAT.Send(pAdmin, Color(255,56,56), "ENFORCER | ", Color(255,255,255), "Failed to unban player with SteamID " .. pSID .. ".")
        end
    end)
end

hook.Add("CheckPassword", "ENFORCER.BanCheck", function(sid64, ip)
    if not ENFORCER.Ban.IsBanDataReady then return false, "ENFORCER | Fetching latest ban data, retry joining in a few seconds." end
    if not ENFORCER.Ban.IsBanned(sid64) then return end
    return false, getBanReason(sid64)
end)

local function tryFetchData(delay)
    ENFORCER.DATA.GetAllBans(function(result, data)
        if not result then
            timer.Simple(delay, function()
                tryFetchData(delay)
            end)
            return
        end
        for k, v in pairs(data) do
            ENFORCER.Ban.Cache[v.steamid] = {reason = v.reason, unban = v.unban}
        end
        print("ENFORCER | Ban data fetched successfully.")
        ENFORCER.Ban.IsBanDataReady = true
    end)
end

hook.Add("ATLASDATA.Ready", "ENFORCER.CacheBans", function()
    local delay = 5  -- Delay between retries in seconds

    tryFetchData(delay)
end)

net.Receive("ENFORCER::BAN::REMOVE", function(_, adminPly)
    if not adminPly:HasPermission("delete_ban") then return end

    local steamId = net.ReadString()

    ENFORCER.Ban.Unban(steamId, adminPly, "Unbanned by staff.")
end)