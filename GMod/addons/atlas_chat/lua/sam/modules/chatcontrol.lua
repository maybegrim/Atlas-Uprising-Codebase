if SAM_LOADED then return end

local sam, command = sam, sam.command

command.set_category("Chat Control")

command.new("clearchat")
    :SetPermission("clearchat", "superadmin")


    :Help("Clear the chat of messages.")

    :OnExecute(function(ply)
        net.Start("Atlas.ClearChat")
        net.Broadcast()
        if sam.is_command_silent then return end
        sam.player.send_message(nil, "{A} cleared chat.", {
            A = ply, T = target
        })
    end)
:End()