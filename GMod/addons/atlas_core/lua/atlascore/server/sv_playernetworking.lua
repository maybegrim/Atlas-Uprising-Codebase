local netReadyPlys = {}

util.AddNetworkString("ATLASCORE::NetReady")

net.Receive("ATLASCORE::NetReady", function(_, ply)
    print("[ATLASCORE] " .. ply:Nick() .. " is ready for networking.")
    hook.Run("ATLASCORE::PlayerNetReady", ply)
    netReadyPlys[ply] = true
end)

hook.Add("PlayerDisconnected", "ATLASCORE::NetReady::Disconnect", function(ply)
    netReadyPlys[ply] = nil
end)

local meta = FindMetaTable("Player")

function meta:IsNetReady()
    return netReadyPlys[self] or false
end
