--[[hook.Add("PlayerJoinTeam", "ATLASPROP.GIVEPHYSGUN", function(ply, teamID)
    if ATLASPROPS.CFG.PropTeams[team.GetName(teamID)] then
        ply:Give("weapon_physgun")
        ply:Give("weapon_physcannon")
    end
end)]]

--[[hook.Add("PlayerSpawn", "ATLASPROP.GIVEPHYSGUN", function(ply)
    if ATLASPROPS.CFG.PropTeams[ply:Team()] then
        ply:Give("weapon_physgun")
        ply:Give("weapon_physcannon")
    end
end)]]
