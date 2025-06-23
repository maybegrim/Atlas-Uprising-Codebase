hook.Add("InitPostEntity", "ATLASCORE::NetworkReady", function()
    net.Start("ATLASCORE::NetReady")
    net.SendToServer()
end)