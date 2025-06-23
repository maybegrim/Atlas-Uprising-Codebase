if SAM_LOADED then return end

local sam, command, language = sam, sam.command, sam.language

timer.Simple(1, function()
command.set_category("Enforcer")

    print("[ENFORCER-SAM] Overwriting Ban Command")
    command.remove_command("ban")
    command.remove_command("banid")
    command.remove_command("unban")

    command.new("ban")
        :SetPermission("ban", "admin")

        :AddArg("player", {single_target = true})
        :AddArg("length", {optional = true, default = 0})
        :AddArg("text", {hint = "reason", optional = true})
        :AddArg("text", {hint = "URL of evidence", optional = true})

        :GetRestArgs()

        :OnExecute(function(ply, targets, length, reason, evidence)
            local target = targets[1]
            if ply:GetBanLimit() ~= 0 then
                if length == 0 then
                    length = ply:GetBanLimit()
                else
                    length = math.Clamp(length, 1, ply:GetBanLimit())
                end
            end
            ENFORCER.Ban.Player(target, ply:SteamID64(), length, reason, evidence)

            sam.player.send_message(nil, "ban", {
                A = ply, T = target:Name(), V = sam.format_length(length), V_2 = reason
            })
        end)
    :End()


    command.new("banid")
        :SetPermission("banid", "admin")

        :AddArg("steamid")
        :AddArg("length", {optional = true, default = 0})
        :AddArg("text", {hint = "reason", optional = true})
        :AddArg("text", {hint = "URL of evidence", optional = true})

        :GetRestArgs()

        :OnExecute(function(ply, promise, length, reason, evidence)
            local a_steamid, a_name, a_ban_limit = ply:SteamID(), ply:Name(), ply:GetBanLimit()

            promise:done(function(data)
                local steamid, target = data[1], data[2]

                if a_ban_limit ~= 0 then
                    if length == 0 then
                        length = a_ban_limit
                    else
                        length = math.Clamp(length, 1, a_ban_limit)
                    end
                end

                if target then
                    ENFORCER.Ban.Player(target, ply:SteamID64(), length, reason, evidence)

                    sam.player.send_message(nil, "ban", {
                        A = a_name, T = target:Name(), V = sam.format_length(length), V_2 = reason
                    })
                else
                    ENFORCER.Ban.Player(steamid, ply:SteamID64(), length, reason, evidence)

                    sam.player.send_message(nil, "banid", {
                        A = a_name, T = steamid, V = sam.format_length(length), V_2 = reason
                    })
                end
            end)
        end)
    :End()

    command.new("unban")
        :SetPermission("unban", "admin")

        :AddArg("steamid", {allow_higher_target = true})
        :AddArg("text", {hint = "reason", optional = true})


        :OnExecute(function(ply, steamid, reason)
            ENFORCER.Ban.Unban(steamid, ply, reason)

            sam.player.send_message(nil, "unban", {
                A = ply, T = steamid
            })
        end)
    :End()

    command.new("stop")
        :SetPermission("stop", "admin")

        :AddArg("player", {single_target = true})

        :GetRestArgs()

        :OnExecute(function(ply, targets)
            local target = targets[1]
            ENFORCER.CMDS.StopPlayer(target)

            --[[sam.player.send_message(nil, "kick", {
                A = ply, T = target:Name(), V = reason
            })]]
        end)
    :End()

    command.new("unstop")
        :SetPermission("unstop", "admin")

        :AddArg("player", {single_target = true})

        :GetRestArgs()

        :OnExecute(function(ply, targets)
            local target = targets[1]
            ENFORCER.CMDS.UnStopPlayer(target)

            --[[sam.player.send_message(nil, "kick", {
                A = ply, T = target:Name(), V = reason
            })]]
        end)
    :End()

    command.new("warn")
        :SetPermission("warn", "admin")

        :AddArg("player", {single_target = true})
        :AddArg("text", {hint = "reason", optional = false})
        :AddArg("text", {hint = "evidence", optional = true})

        :GetRestArgs()

        :OnExecute(function(ply, targets, reason, evidenceURL)
            local target = targets[1]
            --ENFORCER.Warn.WarnPlayer(plyOrId, adminPly, reason, evidenceURL)
            ENFORCER.Warn.WarnPlayer(target, ply, reason, evidenceURL)

            --[[sam.player.send_message(nil, "warn", {
                A = ply, T = target:Name(), V = reason
            })]]
        end)
    :End()

    command.new("warnid")
        :SetPermission("warnid", "admin")

        :AddArg("steamid")
        :AddArg("text", {hint = "reason", optional = false})
        :AddArg("text", {hint = "evidence", optional = true})

        :GetRestArgs()

        :OnExecute(function(ply, promise, reason, evidenceURL)
            promise:done(function(data)
                local steamid, target = data[1], data[2]

                if target then
                    ENFORCER.Warn.WarnPlayer(target, ply, reason, evidenceURL)
                else
                    ENFORCER.Warn.WarnPlayer(steamid, ply, reason, evidenceURL)
                end
            end)
        end)
    :End()

end)