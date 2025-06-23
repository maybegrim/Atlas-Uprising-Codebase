AddCSLuaFile()

if CLIENT and not AU.RaidSystem.CanCallRaid(LocalPlayer()) then return end

concommand.Add(
    "start_raid",
    function (ply, cmd, args)
        if SERVER and AU.RaidSystem.CanCallRaid(ply) then
            if not args[1] then
                ply:PrintMessage(HUD_PRINTCONSOLE, "Must include faction.")
                return
            end

            AU.RaidSystem.TriggerRaid(args[1], ply)
        end
    end,
    function ()
        local auto = table.GetKeys(AU.RaidSystem.Factions)

        for k,v in pairs(auto) do
            auto[k] = "start_raid " .. v    
        end
        
        return auto
    end,
    "Starts a raid on the specified faction."
)

concommand.Add(
    "extend_raid",
    function (ply, cmd, args)
        if SERVER and AU.RaidSystem.CanCallRaid(ply) then
            if not args[1] then
                ply:PrintMessage(HUD_PRINTCONSOLE, "Must include new duration.")
                return
            end

            AU.RaidSystem.ExtendRaid(args[1])
        end
    end
)

concommand.Add(
    "end_raid",
    function (ply, cmd, args)
        if SERVER and AU.RaidSystem.CanCallRaid(ply) then
            AU.RaidSystem.EndRaid()
        end
    end
)