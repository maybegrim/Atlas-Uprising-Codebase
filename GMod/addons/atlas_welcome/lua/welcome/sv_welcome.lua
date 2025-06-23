util.AddNetworkString("WELCOMEUI::SendRules")
util.AddNetworkString("WELCOMEUI::RulesReply")
util.AddNetworkString("WELCOMEUI::SendIntro")


hook.Add("ATLASCORE::PlayerNetReady", "WELCOMEUI::NetReady::SendRules", function(ply)
    net.Start("WELCOMEUI::SendRules")
    net.Send(ply)
end)

net.Receive("WELCOMEUI::RulesReply", function(len, ply)
    local reply = net.ReadBool()
    if reply then
        net.Start("WELCOMEUI::SendIntro")
        net.Send(ply)
    else
        ply:Kick("You must accept the rules to play on this server.")
    end
end)