INVENTORY.NetworkedData = INVENTORY.NetworkedData or {}
INVENTORY.NET = INVENTORY.NET or {}
if SERVER then
    util.AddNetworkString("INVENTORY:Network_Item")
    util.AddNetworkString("INVENTORY:Network_Set")

    function INVENTORY.NET.WriteData(ply, pItemID, pKey, pValue)
        if not pItemID then
            print("INVENTORY.NET.WriteData: pItemID is nil")
            return
        end
        if not pKey then
            print("INVENTORY.NET.WriteData: pKey is nil")
            return
        end
        if not pValue then
            print("INVENTORY.NET.WriteData: pValue is nil")
            return
        end

        if not INVENTORY.NetworkedData[ply:SteamID64()] then
            INVENTORY.NET.Set(ply)
        end

        INVENTORY.NetworkedData[ply:SteamID64()][pItemID] = INVENTORY.NetworkedData[ply:SteamID64()][pItemID] or {}
        INVENTORY.NetworkedData[ply:SteamID64()][pItemID][pKey] = pValue

        net.Start("INVENTORY:Network_Item")
            net.WriteInt(pItemID, 21)
            net.WriteString(pKey)
            net.WriteType(pValue)
        net.Send(ply)
    end

    hook.Add("PlayerSpawn", "INVENTORY:Network_Set", function(pPly)
        INVENTORY.NET.Set(pPly)
    end)
end

-- Shared

-- Server: INVENTORY.NET.ReadData(ply, pItemID, pKey)
-- Client: INVENTORY.NET.ReadData(pItemID, pKey)
function INVENTORY.NET.ReadData(ply, pItemID, pKey)
    if CLIENT then
        pKey = pItemID
        pItemID = ply
        ply = LocalPlayer()
    end
    if not pItemID then
        print("INVENTORY.NET.ReadData: pItemID is nil")
        return
    end
    if not pKey then
        print("INVENTORY.NET.ReadData: pKey is nil")
        return
    end

    if not INVENTORY.NetworkedData[ply:SteamID64()] then
        return
    end

    if not INVENTORY.NetworkedData[ply:SteamID64()][pItemID] then
        INVENTORY.NetworkedData[ply:SteamID64()][pItemID] = {}
    end

    return INVENTORY.NetworkedData[ply:SteamID64()][pItemID][pKey]
end

function INVENTORY.NET.Set(pPly)
    INVENTORY.NetworkedData[pPly:SteamID64()] = {}

    if not SERVER then return end
    if not pPly:IsNetReady() then return end

    net.Start("INVENTORY:Network_Set")
    net.Send(pPly)
end

if CLIENT then
    net.Receive("INVENTORY:Network_Item", function()
        local itemID = net.ReadInt(21)
        local key = net.ReadString()
        local value = net.ReadType()

        if not INVENTORY.NetworkedData[LocalPlayer():SteamID64()] then
            INVENTORY.NET.Set(LocalPlayer())
        end

        INVENTORY.NetworkedData[LocalPlayer():SteamID64()][itemID] = INVENTORY.NetworkedData[LocalPlayer():SteamID64()][itemID] or {}
        INVENTORY.NetworkedData[LocalPlayer():SteamID64()][itemID][key] = value
    end)

    net.Receive("INVENTORY:Network_Set", function()
        INVENTORY.NET.Set(LocalPlayer())
    end)
end