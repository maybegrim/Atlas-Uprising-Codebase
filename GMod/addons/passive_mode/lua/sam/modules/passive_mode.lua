sam.command.set_category("User Management")

sam.command.new("togglepassive")
    :SetPermission("togglepassive", "admin")
    :Help("Toggles the passive mode status of a user.")
    :AddArg("player", {
        single_target = true
    })
    :OnExecute(function (caller, target)
        target[1]:SetPassiveMode(not target[1]:InPassiveMode())
    end)
:End()
