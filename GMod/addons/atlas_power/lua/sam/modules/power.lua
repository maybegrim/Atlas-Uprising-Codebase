if SAM_LOADED then return end

local sam, command, language = sam, sam.command, sam.language

command.set_category("Power Controls")

command.new("Power Down")
	:SetPermission("Power Down", "admin")

	:Help("Initiates a power down sequence.")

	:OnExecute(function(ply)
        RESEARCH.POWER.GoDown()
        sam.player.send_message(nil, "{A} initiated a power down sequence.", {
            A = ply
        })
    end)
:End()

command.new("Power Up")
    :SetPermission("Power Up", "admin")

    :Help("Initiates a power up sequence.")

    :OnExecute(function(ply)
        RESEARCH.POWER.Restore()
        sam.player.send_message(nil, "{A} initiated a power up sequence.", {
            A = ply
        })
    end)
:End()

command.new("Turn on Lights")
    :SetPermission("Turn on Lights", "admin")

    :Help("Turn on the lights.")

    :OnExecute(function(ply)
        for _, light in pairs(RESEARCH.POWER.LCZLights) do
            light:Fire("TurnOn", "", 0)
        end
        for _, light in pairs(RESEARCH.POWER.HCZLights) do
            light:Fire("TurnOn", "", 0)
        end
        for _, light in pairs(RESEARCH.POWER.EZLights) do
            light:Fire("TurnOn", "", 0)
        end
        sam.player.send_message(nil, "{A} turned on the lights.", {
            A = ply
        })
    end)
:End()

command.new("Turn off Lights")
    :SetPermission("Turn off Lights", "admin")

    :Help("Turn off the lights.")

    :OnExecute(function(ply)
        for _, light in pairs(RESEARCH.POWER.LCZLights) do
            light:Fire("TurnOff", "", 0)
        end
        for _, light in pairs(RESEARCH.POWER.HCZLights) do
            light:Fire("TurnOff", "", 0)
        end
        for _, light in pairs(RESEARCH.POWER.EZLights) do
            light:Fire("TurnOff", "", 0)
        end
        sam.player.send_message(nil, "{A} turned off the lights.", {
            A = ply
        })
    end)
:End()