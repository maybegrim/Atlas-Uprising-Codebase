-- Define a table to track muted players
ENFORCER.CMDS = ENFORCER.CMDS or {}
ENFORCER.CMDS.MutedPlayers = ENFORCER.CMDS.MutedPlayers or {}

-- StopPlayer function
function ENFORCER.CMDS.StopPlayer(ply)
    if not ply or not ply:IsPlayer() then
        return false, "Invalid player"
    end

    -- Lock the player
    ply:Lock()

    -- Add the player to the MutedPlayers table
    ENFORCER.CMDS.MutedPlayers[ply:SteamID()] = true

    return true
end

-- UnStopPlayer function
function ENFORCER.CMDS.UnStopPlayer(ply)
    if not ply or not ply:IsPlayer() then
        return false, "Invalid player"
    end

    -- Unlock the player
    ply:UnLock()

    -- Remove the player from the MutedPlayers table
    ENFORCER.CMDS.MutedPlayers[ply:SteamID()] = nil

    return true
end

hook.Add("PlayerSay", "ENFORCER::CMDS::BlockMsgs", function(ply, text)
    if ENFORCER.CMDS.MutedPlayers[ply:SteamID()] then
        return ""
    end
end)

hook.Add("PlayerCanHearPlayersVoice", "ENFORCER_BlockMutedVoice", function(listener, talker)
    if ENFORCER.CMDS.MutedPlayers[talker:SteamID()] then
        return false, false
    end
end)