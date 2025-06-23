AddCSLuaFile()

AU = AU or {}
AU.Amnestics = AU.Amnestics or {}

if SERVER then
    resource.AddWorkshop("2595071184")

    util.AddNetworkString("AU.Message")

    AU = AU or {}

    function AU.Message(ply, message)
        net.Start("AU.Message")
            net.WriteString(message)
        net.Send(ply)
    end

    local player_meta = FindMetaTable("Player")

    function player_meta:AUMessage(message)
        AU.Message(self, message)
    end
else
    net.Receive("AU.Message", function ()
        local message = net.ReadString()

        chat.AddText(Color(189, 28, 28), "[AMNESTICS] ", Color(255, 255, 255), message)
    end)
end