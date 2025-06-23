function LEVEL.GetLevel(ply)
    return ply:GetNWInt("LEVEL.Level", 1)
end

function LEVEL.GetXP(ply)
    return LEVEL.DATA[ply:SteamID64()].xp
end

if CLIENT then
    net.Receive("LEVEL::Sync", function()
        LEVEL.DATA[LocalPlayer():SteamID64()] = net.ReadTable()
        LEVEL.CFG.ConfValues = net.ReadTable()
    end)

    function LEVEL.GetMaxXP(ply)
        return LEVEL.CFG.ConfValues.XPPerLevel * (LEVEL.GetLevel(ply) + 1)
    end
end
