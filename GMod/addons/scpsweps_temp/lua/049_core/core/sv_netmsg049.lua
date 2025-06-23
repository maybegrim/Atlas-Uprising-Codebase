util.AddNetworkString("049_open")
util.AddNetworkString("049_sound")
util.AddNetworkString("049_msg")

hook.Add("PlayerDeath", "PD:REMOVEINFECTEDUI", function(victim)
    if victim.SCP049INFECTED then
        net.Start("HYPEX.049.Infected")
        net.WriteBool(true)
        net.Send(victim)
    end
end)
hook.Add("PlayerDisconnected", "PDC:REMOVEINFECTEDUI", function(victim)
    if victim.SCP049INFECTED then
        net.Start("HYPEX.049.Infected")
        net.WriteBool(true)
        net.Send(victim)
    end
end)
hook.Add("PlayerChangedTeam", "PCT:REMOVEINFECTEDUI", function(victim)
    if victim.SCP049INFECTED then
        net.Start("HYPEX.049.Infected")
        net.WriteBool(true)
        net.Send(victim)
    end
end)