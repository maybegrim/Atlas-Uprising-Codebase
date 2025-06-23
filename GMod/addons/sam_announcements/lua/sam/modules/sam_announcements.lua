if SERVER then util.AddNetworkString("sam_sendannounce") end

sam.command.set_category("Announcement")

sam.command.new("man_announce")
    :SetPermission("man_announce", "superadmin")
    :Help("Make a management announcement")
 
    :AddArg("text", {optional = false})
    :GetRestArgs() -- Get all the text.
    :MenuHide(false) -- hide this command from the menu
    :DisableNotify(true) -- hide <PLAYER(PLAYER_STEAMID)> ran command stuff in server console, useful for something like !menu command

    :OnExecute(function(ply, text)
        local message = {
            "[######]  {#A51B0B Management} Announcement!  [######]",
            " ", -- Invisible character to create the extra line.
            text,
            " ",
            "[####################################]"
        }

        net.Start("sam_sendannounce")
            net.WriteTable(message)
        net.Broadcast()

        sam.player.send_message(nil, "{A} made a management announcement.", {
            A = ply
        })
    end)
:End()

sam.command.new("staff_announce")
    :SetPermission("staff_announce", "admin")
    :Help("Make a staff announcement")
 
    :AddArg("text", {optional = false})
    :GetRestArgs() -- Get all the text.
    :MenuHide(false) -- hide this command from the menu
    :DisableNotify(true) -- hide <PLAYER(PLAYER_STEAMID)> ran command stuff in server console, useful for something like !menu command

    :OnExecute(function(ply, text)
        local message = {
            "[######]  {#6F9FE9 Staff} Announcement!  [######]",
            " ",
            text,
            " ",
            "[####################################]"
        }

        net.Start("sam_sendannounce")
            net.WriteTable(message)
        net.Broadcast()

        sam.player.send_message(nil, "{A} made a staff announcement.", {
            A = ply
        })
    end)
:End()

sam.command.new("ec_announce")
    :SetPermission("ec_announce", "admin")
    :Help("Make an event coordinator announcement")
 
    :AddArg("text", {optional = false})
    :GetRestArgs() -- Get all the text.
    :MenuHide(false) -- hide this command from the menu
    :DisableNotify(true) -- hide <PLAYER(PLAYER_STEAMID)> ran command stuff in server console, useful for something like !menu command
    
    :OnExecute(function(ply, text)
        local message = {
            "[######]  {#FE9823 Event Coordinator} Announcement!  [######]",
            " ",
            text,
            " ",
            "[####################################]"
        }

        net.Start("sam_sendannounce")
            net.WriteTable(message)
        net.Broadcast()

        sam.player.send_message(nil, "{A} made an EC announcement.", {
            A = ply
        })
    end)
:End()