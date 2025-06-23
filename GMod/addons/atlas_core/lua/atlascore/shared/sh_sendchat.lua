if SERVER then
    ATLASCORE.CHAT = ATLASCORE.CHAT or {}
    util.AddNetworkString("ATLASCORE::CHAT::Send")

    function ATLASCORE.CHAT.Send(ply, ...)
        if not IsValid(ply) or not ply:IsPlayer() then return end

        local args = {...}
        net.Start("ATLASCORE::CHAT::Send")
            net.WriteTable(args)
        net.Send(ply)
    end
else
    net.Receive("ATLASCORE::CHAT::Send", function()
        local args = net.ReadTable()

        chat.AddText(unpack(args))
    end)
end