util.AddNetworkString("OpenTeleportMenu")
util.AddNetworkString("TeleportPlayer")

local placesTaGo = {
    { name = "EC Box", pos = Vector(13985.795898, 4772.251465, 3231.417480) },
    { name = "Sit Room 1", pos = Vector(3618.363281, 4600.819336, -256.109863) },
    { name = "Sit Room 2", pos = Vector(3613.091553, 5094.363281, -270.468750) },
    { name = "Sit Room 3", pos = Vector(3591.123779, 5588.886719, -269.824341) },
    { name = "LCZ", pos = Vector(-2274.623047, -2222.673340, -2596.320312) },
    { name = "HCZ", pos = Vector(3869.861084, -3932.701904, -1355.088745) },
    { name = "Garage", pos = Vector(10629.969727, -6345.025879, 6056.083008) },
    { name = "U-11 Bunks", pos = Vector(10697.909180, -11166.338867, 9345.482422) },
    { name = "CI Base", pos = Vector(-8927.757812, -12614.642578, 5373.151855) },
    { name = "Town", pos = Vector(-8111.083496, 3109.648926, 5306.602539) }
}

local staffRanks = {
    trialmoderator = true, trialeventcoordinator = true, moderator = true, junioreventcoordinator = true,
    seniormoderator = true, eventcoordinator = true, junioradmin = true, senioreventcoordinator = true,
    admin = true, leadeventcoordinator = true, senioradmin = true, supportsmt = true, creativewriter = true,
    commsmt = true, leadadmin = true, admindirector = true, serversupervisor = true, supportsmt = true,
    qolsupervisor = true, servermanager = true, superadmin = true
}

local function IsStaff(ply)
    local userGroup = string.lower(ply:GetUserGroup())
    return staffRanks[userGroup] or false
end

local cookoutSpots = {}

hook.Add("PlayerDisconnected", "CleanupTeleportData", function(ply)
    cookoutSpots[ply:SteamID()] = nil
end)

hook.Add("PlayerSay", "OpenTeleportMenuCommand", function(ply, text)
    if not IsStaff(ply) then return end

    if string.lower(text) == "!teleport" then
        cookoutSpots[ply:SteamID()] = {
            pos = ply:GetPos(),
            ang = ply:EyeAngles()
        }

        net.Start("OpenTeleportMenu")
        net.WriteUInt(#placesTaGo + 1, 8)

        for _, location in ipairs(placesTaGo) do
            net.WriteString(location.name)
            net.WriteVector(location.pos)
        end

        net.WriteString("Return")
        net.WriteVector(cookoutSpots[ply:SteamID()] and cookoutSpots[ply:SteamID()].pos or Vector(0, 0, 0))
        net.Send(ply)

        return ""
    end
end)

net.Receive("TeleportPlayer", function(_, ply)
    if not IsStaff(ply) then return end

    local listoPlaces = net.ReadUInt(8)

    if listoPlaces == #placesTaGo + 1 then
        local tacoTruck = cookoutSpots[ply:SteamID()]

        if tacoTruck then
            ply:SetPos(tacoTruck.pos)
            ply:SetEyeAngles(tacoTruck.ang)
            ply:SetMoveType(MOVETYPE_WALK)
        else
            ply:ChatPrint("No return location stored!")
        end
    else
        local location = placesTaGo[listoPlaces]
        if location then
            if not cookoutSpots[ply:SteamID()] then
                cookoutSpots[ply:SteamID()] = {
                    pos = ply:GetPos(),
                    ang = ply:EyeAngles()
                }
            end

            ply:SetPos(location.pos)
            ply:SetMoveType(MOVETYPE_WALK)
        end
    end
end)
