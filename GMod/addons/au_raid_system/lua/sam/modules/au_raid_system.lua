timer.Simple(1, function()

    sam.command.set_category("Raid System")

    sam.command.new("startraid")
        :SetPermission("startraid", "admin")
        :Help("Starts a raid on the specified faction.")
        :AddArg("dropdown", {
            hint = "faction",
            options = table.GetKeys(AU.RaidSystem.Factions)
        })
        :OnExecute(function (caller, faction)
            AU.RaidSystem.TriggerRaid(faction, caller)

            sam.player.send_message(caller, "Initiated raid on {f}.", {
                f = faction
            })
        end)
    :End()

    sam.command.new("extendraid")
        :SetPermission("extendraid", "admin")
        :Help("Extends the raid on the target faction.")
        :AddArg("number", {
            hint = "seconds",
            check = function (faction)
                return AU.RaidSystem.Factions[faction]
            end
        })
        :OnExecute(function (caller, time)
            AU.RaidSystem.ExtendRaid(time)

            sam.player.send_message(caller, "Extended current raid to {b}.", {
                b = time
            })
        end)
    :End()

    sam.command.new("endraid")
        :SetPermission("endraid", "admin")
        :Help("Ends the current raid.")
        :OnExecute(function (caller)
            AU.RaidSystem.EndRaid()

            sam.player.send_message(caller, "Ended raid.")
        end)
    :End()

    sam.permissions.add("can_manage_raids", "Raid System", "admin")
end)