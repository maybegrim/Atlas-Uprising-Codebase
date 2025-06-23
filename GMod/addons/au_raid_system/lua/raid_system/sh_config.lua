AddCSLuaFile()

AU = AU or {}
AU.RaidSystem = AU.RaidSystem or {}

-- Raid time in seconds.
AU.RaidSystem.RaidTime = 1200

AU.RaidSystem.Factions = {
    ["FOUNDATION"] = true,
    ["CHAOS"] = true
}

timer.Simple(2, function()
    AU.RaidSystem.CanCallTeams = {
        [TEAM_LEADGENSECOFFICER] = true,
        [TEAM_GENSECCAPTAIN] = true,
        [TEAM_NTFLCO] = true,
        [TEAM_NTFCAPTAIN] = true,
        [TEAM_E6OFFICER] = true,
        [TEAM_E6LCO] = true,
        [TEAM_E6CAPTAIN] = true,
        [TEAM_MUENGINEER] = true,
        [TEAM_MUINQ] = true,
        [TEAM_MUCAPTAIN] = true,
        [TEAM_RADEPUTY] = true,
        [TEAM_RAHOR] = true,
        [TEAM_SITEDIRECTOR] = true,
        [TEAM_ASSITEDIRECTOR] = true,
        [TEAM_SECCHIEF] = true,
        [TEAM_ASSSECCHIEF] = true,
        [TEAM_AIOFFICER] = true,
        [TEAM_RIOFFICER] = true,
        [TEAM_SISENOPERATIVE] = true,
        [TEAM_SISPECIALIST] = true,
        [TEAM_SICAPTAIN] = true,
        [TEAM_CILEADRESEARCH] = true,
        [TEAM_CISUPERVISOR] = true,
        [TEAM_CIVICECOMMANDER] = true,
        [TEAM_CICOMMANDER] = true,
        [TEAM_SIOPERATIVE] = true,
        [TEAM_SICAPTAIN] = true,
        [TEAM_SISENOPERATIVE] = true,
        [TEAM_RISENRESEARCHER] = true,
        [TEAM_AILEADEXPLO] = true,
        [TEAM_AILEADHEAVY] = true,
        [TEAM_AILEADMEDIC] = true,
        [TEAM_AILEADSNIPER] = true,
        
    }
end)
-- I don't know if this was changed, but I'm 99%
-- sure I added factions to the job tables.
AU.RaidSystem.GetPlayerFaction = function(ply)
    local job_table = ply:getJobTable()
    return job_table.faction
end

AU.RaidSystem.CanCallRaid = function(ply)
    if not IsValid(ply) then return false end
    return AU.RaidSystem.CanCallTeams[ply:Team()] or ply:HasPermission("can_manage_raids")
end