AddCSLuaFile()

AU.RaidSystem.CurrentRaid = {}

if SERVER then
    util.AddNetworkString("AU.RaidSystem.RaidStart")
    util.AddNetworkString("AU.RaidSystem.RaidEnd")
    util.AddNetworkString("AU.RaidSystem.RaidExtend")
    util.AddNetworkString("AU.RaidSystem.DiedDuringRaid")

    hook.Add( "PlayerDeath", "AU.RaidSystem.DiedDuringRaid", function( victim,_,_ )
        if not timer.Exists("AU.RaidSystem.RaidDuration") then return end
        net.Start("AU.RaidSystem.DiedDuringRaid")
        net.Send(victim)
    end )

    function AU.RaidSystem.StartRaid(faction, duration, ply)
        AU.RaidSystem.CurrentRaid.Faction = faction
        AU.RaidSystem.CurrentRaid.EndTime = CurTime() + duration

        net.Start("AU.RaidSystem.RaidStart")
        net.WriteString(faction)
        net.WriteDouble(AU.RaidSystem.CurrentRaid.EndTime)
        net.Broadcast()

        timer.Create("AU.RaidSystem.RaidDuration", duration, 1, AU.RaidSystem.EndRaid)

        hook.Run("AU.RaidSystem.RaidStart", faction, ply)
    end

    function AU.RaidSystem.ExtendRaid(duration)
        AU.RaidSystem.CurrentRaid.EndTime = AU.RaidSystem.CurrentRaid.EndTime + duration

        net.Start("AU.RaidSystem.RaidExtend")
        net.WriteDouble(AU.RaidSystem.CurrentRaid.EndTime)
        net.Broadcast()

        timer.Create("AU.RaidSystem.RaidDuration", duration, 1, AU.RaidSystem.EndRaid)

        hook.Run("AU.RaidSystem.RaidExtend", duration)
    end

    function AU.RaidSystem.EndRaid()
        net.Start("AU.RaidSystem.RaidEnd")
        net.Broadcast()

        hook.Run("AU.RaidSystem.RaidEnd", AU.RaidSystem.CurrentRaid.Faction)
    end

    function AU.RaidSystem.TriggerRaid(faction, ply)
        if AU.RaidSystem.IsValidFaction(faction) then
            AU.RaidSystem.StartRaid(
                faction,
                AU.RaidSystem.RaidTime,
                ply
            )
        end
    end
end

function AU.RaidSystem.IsValidFaction(faction)
    return AU.RaidSystem.Factions[faction] or false
end

function AU.RaidSystem.GetRaidTime()
    return math.max((AU.RaidSystem.CurrentRaid.EndTime or 0) - CurTime(), 0)
end

if CLIENT then
    net.Receive("AU.RaidSystem.DiedDuringRaid", function ()
        AU.RaidSystem.DiedDuringRaid = true
    end)

    net.Receive("AU.RaidSystem.RaidStart", function ()
        AU.RaidSystem.CurrentRaid.Faction = net.ReadString()
        AU.RaidSystem.CurrentRaid.EndTime = net.ReadDouble()
        hook.Run("AU.RaidSystem.RaidStart")
    end)

    net.Receive("AU.RaidSystem.RaidEnd", function ()
        AU.RaidSystem.CurrentRaid.EndTime = CurTime()
        AU.RaidSystem.DiedDuringRaid = false
        hook.Run("AU.RaidSystem.RaidEnd")
    end)

    net.Receive("AU.RaidSystem.RaidExtend", function ()
        AU.RaidSystem.CurrentRaid.EndTime = net.ReadDouble()
        hook.Run("AU.RaidSystem.RaidExtend")
    end)
end