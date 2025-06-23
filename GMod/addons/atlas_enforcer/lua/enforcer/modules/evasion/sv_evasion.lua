util.AddNetworkString("ENFORCER.Check")

local checkedPlayers = {}

net.Receive("ENFORCER.Check", function(len, ply)
    -- Check if the player has already been checked
    if checkedPlayers[ply:SteamID64()] then return end
    checkedPlayers[ply:SteamID64()] = true
    -- Get the SteamID data from the client
    local steamIDsJSON = net.ReadString()
    local steamIDs = util.JSONToTable(steamIDsJSON) or {}

    if #steamIDs == 0 then return end
    if #steamIDs > 10 then return end -- 

    -- Check each SteamID to see if it's banned
    for _, steamID in ipairs(steamIDs) do
        timer.Simple(_, function()
            if ENFORCER.Ban.IsBanned(steamID) then
                -- If a banned ID is found, ban the current player
                local reason = "Ban Evasion (SteamID: " .. steamID .. ")"
                ENFORCER.Ban.Player(ply, false, 0, reason, evidence)
            end
        end)
    end
end)

hook.Add("PlayerDisconnected", "ENFORCER.PlayerDisconnected", function(ply)
    -- Remove the player from the checked players list
    checkedPlayers[ply:SteamID64()] = nil
end)