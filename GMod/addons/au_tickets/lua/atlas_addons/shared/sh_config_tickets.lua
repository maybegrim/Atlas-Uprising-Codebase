--[[
	This file has been copyrighted by Atlas Uprising.
	Do not distribute or copy any files.
]]--

if SERVER then function ScrW() return 1920 end function ScrH() return 1080 end end cats = cats or {} cats.config = {}
-- ^
-- | please do not touch these

------------------------------------------------------
-- BASIC CONFIG
------------------------------------------------------

-- positions
cats.config.spawnSize = { 320, 220 } -- size of ticket window
cats.config.spawnPosAdmin = { 10, 10 } -- position of admin ticket panel
cats.config.spawnPosUser = { 10, 10 } -- position of user ticket panel

-- appearance
cats.config.punchCardMode = 'dots' -- 'line', 'dots' or 'columns'
cats.config.punchCardStart = 5 -- first hour of punchcard (typically server restart time in 24 format)

-- rating
cats.config.defaultRating = 3 -- if somehow we timed out ticket rating, which rating it falls back to
cats.config.ratingTimeout = 60 -- after what time in seconds rating will be timed out

-- sound
cats.config.newTicketSound = 'buttons/bell1.wav' -- well, new ticket sound (surprise)

-- language
cats.lang = {
    openTickets = "Open tickets",
    myTicket = "My ticket",
    userDisconnected = "User left",
    claimedBy = "Claimed by",
    sendMessage = "Send a message...",
    typeYourMessage = "Enter your message:",
    actions = "Actions",
    action_claim = "Claim ticket",
    action_unclaim = "Unclaim ticket",
    action_goto = "Go to",
    action_bring = "Bring",
    action_return = "Return him",
    action_returnself = "Return me",
    action_copySteamID = "Copy SteamID",
	action_billySit = "Begin sit",
    action_close = "Close ticket",
    error_wait = "Shhh... Chill, dude",
    error_noAccess = "Access denied",
    error_playerNotFound = "Player not found",
    error_ticketNotEnded = "Ticket is not closed yet",
    error_ticketNotFound = "Ticket not found",
    error_ticketEnded = "Ticket is already closed",
    error_ticketNotClaimed = "Ticket is not claimed",
    error_ticketAlreadyClaimed = "Ticket is already claimed",
    error_needToRate = "You must rate your previous ticket!",
	error_cantCancelHasAdmin = "You can't cancel already claimed ticket!",
    ticketClaimed = "You claimed the ticket",
    ticketUnclaimed = "You unclaimed the ticket",
    ticketClaimedBy = "%s claimed your ticket",
    ticketUnclaimedBy = "Your ticket was unclaimed",
    ticketClosed = "You closed the ticket",
    ticketClosedBy = "%s closed the ticket. Rate his work!",
    ticketRatedForAdmin = "Your ticket rating: %s",
    ticketRatedForUser = "You rated ticket: %s",
    ticketUserLeft = "User who opened ticket you claimed has left",
    rateAdmin = "Rate your experience. How satisfied were you with his result?",
    ok = "OK",
    cancel = "Cancel",
    ticket_noAdmins = "There's no admins in the server, however if someone joins, he will see the ticket",
    dow = {"MO","TU","WE","TH","FR","SA","SU"},
}

------------------------------------------------------
-- ADVANCED SETTINGS (do not edit unless you're a dev)
------------------------------------------------------

cats.config.serverID = "scprp"
cats.config.getPlayerName = function(ply)
    return IsValid( ply ) and ply:Nick() .. " (" .. ply:SteamID() .. ")" or "N/A"
end
--local staffgroups = {"superadmin", "storylineproducer", "storylinedirector", "serversupervisor", "leadadmin", "admindirector", "seniormoderator", "tmod", "trialmoderator", "headadmin", "developer", "servermanager", "admin", "moderator", "trialmod", "seniormod", "senioradmin", "event", "leadevent", "tevent", "sevent", "junioradmin"}

cats.config.playerCanSeeTicket = function(ply, ticketSteamID)
    --return table.HasValue(staffgroups, ply:GetUserGroup()) or ply:SteamID() == ticketSteamID
    return ply:HasPermission("canviewtickets") or ply:SteamID() == ticketSteamID
end

cats.config.triggerText = function(ply, text)
    text = text:Trim()
    if text:sub(1,1) == '@' then
        return true, text:sub(2):Trim()
    end

    return false
end

cats.config.notify = function(ply, msg, type, duration)
    if IsValid(ply) then
		DarkRP.notify(ply, 1, 6, msg)
    else
		DarkRP.notify(player.GetHumans(), 1, 6,msg)
    end
end

-- NOTE: these are clientside
cats.config.commands = {
    { -- bring
        text = cats.lang.action_bring,
        icon = 'user_go',
        click = function(steamid)
            local pPlayer = player.GetBySteamID( steamid )
            if not IsValid( pPlayer ) then
                LocalPlayer():ChatPrint( "That player does not exist." )
                return
            end
            RunConsoleCommand('sam', 'bring', pPlayer:Nick())
        end
    },
    { -- return
        text = cats.lang.action_return,
        icon = 'arrow_undo',
        click = function(steamid)
            local pPlayer = player.GetBySteamID( steamid )
            if not IsValid( pPlayer ) then
                LocalPlayer():ChatPrint( "That player does not exist." )
                return
            end
            RunConsoleCommand('sam', 'return', pPlayer:Nick())
        end
    },
    { -- goto
        text = cats.lang.action_goto,
        icon = 'arrow_right',
        click = function(steamid)
            local pPlayer = player.GetBySteamID( steamid )
            if not IsValid( pPlayer ) then
                LocalPlayer():ChatPrint( "That player does not exist." )
                return
            end
            RunConsoleCommand('sam', 'goto', pPlayer:Nick())
        end
    },
    { -- return self
        text = cats.lang.action_returnself,
        icon = 'arrow_rotate_clockwise',
        click = function(steamid)
            RunConsoleCommand('sam', 'return', LocalPlayer():Nick())
        end
    },
    { -- copy steamID
        text = cats.lang.action_copySteamID,
        icon = 'key_go',
        click = function(steamid)
            SetClipboardText( steamid )
        end
    },
}

-- | also please do not touch these
-- V
if SERVER then ScrW = nil ScrH = nil end