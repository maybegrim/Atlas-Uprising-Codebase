if SERVER then
    util.AddNetworkString("SetToChoosingAFK")

    local ChoosingTeamIndex
    local StaffTeamIndex
    local SCPTeamIndex

    -- Ensure the teams exist
    for TeamIndex, CurTeam in pairs(team.GetAllTeams()) do
        local teamName = team.GetName(TeamIndex)
        if teamName == "Choosing..." then
            ChoosingTeamIndex = TeamIndex
        elseif teamName == "STAFF" then
            StaffTeamIndex = TeamIndex
        elseif teamName == "SCP" then
            SCPTeamIndex = TeamIndex
        end
    end

    if not ChoosingTeamIndex then
    end

    net.Receive("SetToChoosingAFK", function(_, ply)
        if not IsValid(ply) then return end

        local playerTeam = ply:Team()
        if playerTeam ~= StaffTeamIndex and playerTeam ~= SCPTeamIndex then
            if ChoosingTeamIndex then
                ply:SetTeam(ChoosingTeamIndex)
                ply:Spawn()
            else
                print("[WARNING] ChoosingTeamIndex is nil.")
            end
        end
    end)
end
