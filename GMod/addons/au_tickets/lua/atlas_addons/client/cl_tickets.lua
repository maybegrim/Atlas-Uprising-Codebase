--[[
	This file has been copyrighted by Atlas Uprising.
	Do not distribute or copy any files.
]]--

local OffDuty = CreateClientConVar( "cl_autickets_offduty", "0", false, false, "Enable/Disable admin tickets" )

--#################################################
-- Main frame
--#################################################

---------------------------------------------------
-- FONTS
---------------------------------------------------

surface.CreateFont("cats.small", {
    font = "Roboto Bold",
	extended = true,
	size = 14,
	weight = 500,
})

surface.CreateFont("cats.xlarge", {
    font = "Roboto Bold",
	extended = true,
	size = 46,
	weight = 500,
})

surface.CreateFont("cats.large", {
    font = "Roboto Bold",
	extended = true,
	size = 34,
	weight = 500,
})

surface.CreateFont("cats.medium", {
    font = "Roboto Bold",
	extended = true,
	size = 22,
	weight = 500,
})

---------------------------------------------------
-- HELPER FUNCTIONS
---------------------------------------------------

-- apply table to action button
local buttons -- declare here, fill later
local function applyButton(pnl, name, ply)
    local data = buttons[name]
    if not data then data = {
        tooltip = 'error',
        icon = Material('icon16/error.png'),
        click = function() end
    } end

    pnl:SetToolTip(data.tooltip)
    pnl.icon = data.icon
    pnl.DoClick = function(self) data.click(self, ply) end
    pnl.Think = function(self) self:MoveToFront() end
end

-- nice time
local function niceTime(time)

	local h, m, s
	h = math.floor(time / 60 / 60)
	m = math.floor(time / 60) % 60
	s = math.floor(time) % 60

	return string.format("%02i:%02i:%02i", h, m, s)

end

-- draw circle
function drawCircle( x, y, radius, seg )

	local cir = {}

	table.insert( cir, {
		x = x,
		y = y,
		u = 0.5,
		v = 0.5
	})
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, {
			x = x + math.sin( a ) * radius,
			y = y + math.cos( a ) * radius,
			u = math.sin( a ) / 2 + 0.5,
			v = math.cos( a ) / 2 + 0.5
		})
	end

	local a = math.rad( 0 )
	table.insert( cir, {
		x = x + math.sin( a ) * radius,
		y = y + math.cos( a ) * radius,
		u = math.sin( a ) / 2 + 0.5,
		v = math.cos( a ) / 2 + 0.5
	})

	surface.DrawPoly( cir )

end

---------------------------------------------------
-- CACHE
---------------------------------------------------

-- icons cache
local icons = {
    action_claim = Material('icon16/accept.png'),
    action_unclaim = Material('icon16/delete.png'),
    actions = Material('icon16/wand.png'),
    action_callon = Material('icon16/lightbulb_off.png'),
    action_calloff = Material('icon16/lightbulb.png'),
    action_close = Material('icon16/report_delete.png'),
    noStar = Material('icon16/bullet_white.png'),
    star = Material('icon16/star.png'),
}

-- button tables
buttons = {
    action_claim = {
        tooltip = cats.lang.action_claim,
        icon = icons.action_claim,
        click = function(self, ply)
            net.Start('cats.claimTicket')
                --net.WriteString(ply:SteamID())
                net.WriteString(ply)
                net.WriteBool(true)
            net.SendToServer()
            applyButton(self, 'action_unclaim', ply)
        end
    },
    action_unclaim = {
        tooltip = cats.lang.action_unclaim,
        icon = icons.action_unclaim,
        click = function(self, ply)
            net.Start('cats.claimTicket')
                --net.WriteString(ply:SteamID())
                net.WriteString(ply)
                net.WriteBool(false)
            net.SendToServer()
            applyButton(self, 'action_claim', ply)
        end
    },
    actions = {
        tooltip = cats.lang.actions,
        icon = icons.actions,
        click = function(self, ply)
            local m = DermaMenu()
			for i, act in ipairs( cats.config.commands ) do
				m:AddOption( act.text, function()
					act.click(ply)
				end):SetIcon('icon16/' .. (act.icon or 'wand') .. '.png')
            end
            m:SetPos( input.GetCursorPos() )
			m:Open()
        end
    },
    action_callon = {
        tooltip = cats.lang.action_callon,
        icon = icons.action_callon,
        click = function(self, ply)
            -- TODO: make help button
            applyButton(self, 'action_calloff', ply)
        end
    },
    action_calloff = {
        tooltip = cats.lang.action_calloff,
        icon = icons.action_calloff,
        click = function(self, ply)
            -- TODO: make help button
            applyButton(self, 'action_callon', ply)
        end
    },
    action_close = {
        tooltip = cats.lang.action_close,
        icon = icons.action_close,
        click = function(self, ply)
            net.Start('cats.closeTicket')
                --net.WriteString(ply:SteamID())
                net.WriteString(ply)
            net.SendToServer()
        end
    },
}

-- default button list
local actionList = {
    'action_claim',
    'actions',
    -- 'action_callon',
    'action_close',
}

-- debug ticket data
local debugTicket = {
    user = LocalPlayer(),
    userID = 'STEAM_X:X:XXXXXXXX',
    admin = LocalPlayer(),
    adminID = 'STEAM_X:X:XXXXXXXX',
    chatLog = {
        {"User", "Admin let me test my ticket!", false},
        {"Admin", "Alright.", true},
    }
}

-- my ticket
local myTicket

---------------------------------------------------
-- MAIN CODE
---------------------------------------------------

-- add a ticket frame to container
local function addTicketToFrame( data )
    if OffDuty:GetBool() then print( "Ticket not displayed due to being offduty" ) PrintTable( data ) return end
    if IsValid( cats.ticketContainer[data.userID] ) then cats.ticketContainer[data.userID]:Remove() end--return Error( "Duplicate ticket... " .. util.TableToJSON( data ) .. "\n" ) end

    -- sound notification
    surface.PlaySound(cats.config.newTicketSound)

    -- ticket panel
    local t = cats.ticketContainer:Add("DButton")
    t:SetSize(cats.config.spawnSize[1], 180)
    t:SetText('')
    t:MoveToFront()
	t.expanded = true
    t.ticket = data -- apply ticket
    t.Paint = function(self, w, h)
        if not self.ticket then return end
        local user, admin = self.ticket.user, self.ticket.admin

        surface.SetDrawColor(44,44,44, 220)
        surface.DrawRect(0, 0, w, h)
        if self.Hovered then
            surface.SetDrawColor(255,255,255, 2)
            surface.DrawRect(0, 0, w, h)
        end
        surface.SetDrawColor(0,0,0, 255)
        surface.DrawLine(0, -1, 0, h)
        surface.DrawLine(-1, h-1, w, h-1)
        surface.DrawLine(w-1, h, w-1, -1)

        local time = '(' .. os.date( "%M:%S", CurTime() - (self.ticket.created or CurTime()) ) .. ')'
        local userName = IsValid(user) and user:Name() or cats.lang.userDisconnected
		local rating = '★'.. math.Round(user:GetNWFloat("cats_averageRating", 1), 1)
        draw.SimpleText(time .. ' ' .. rating .. ' ' .. userName, 'cats.small', 8, 15, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        if IsValid(admin) then
			local ratingAdmin = '★'.. math.Round(admin:GetNWFloat("cats_adminRating", 1), 1)
            draw.SimpleText(ratingAdmin .. ' ' .. admin:Name(), 'cats.small', w-8, 15, Color(180,200,240), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end
    end
    t.DoClick = function(self)
        self.expanded = not self.expanded
        for i,v in ipairs(cats.ticketContainer:GetChildren()) do
            -- if self ~= v then v.expanded = false end
            v:InvalidateLayout(true)
        end
        cats.ticketContainer:Layout()
        timer.Simple(0, function()
            self.chatLog:GotoTextEnd()
        end)
    end
    t.PerformLayout = function(self)
        self:SetSize(self:GetParent():GetWide(), self.expanded and 180 or 30)
        self.controls:SetVisible(self.expanded)

    end

    t.Think = function( self )
        self:MoveToFront()
    end

    -- controls for ticket
    local c = vgui.Create("DPanel", t)
    c:DockMargin(1,1,1,1)
    c:Dock(BOTTOM)
    c:SetTall(150)
    c.Paint = function() end
    t.controls = c

    -- action buttons for controls
    t.controls.buttons = {}
    for i, v in pairs(actionList) do
        local b = vgui.Create("DButton", c)
        b:SetSize(30, 30)
        b:SetPos(0, (i-1)*30)
        b:SetText('')
        b.Paint = function(self, w, h)
            if self.Hovered then draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,2)) end
            surface.SetMaterial(self.icon)
            surface.SetDrawColor(255,255,255)
            surface.DrawTexturedRect(7, 7, 16, 16)
        end

        applyButton(b, v, t.ticket.user:SteamID())
        t.controls.buttons[v] = b
    end

    -- chat
    local cp = vgui.Create("DPanel", t.controls)
    cp:Dock(FILL)
    cp:DockMargin(30,0,0,0)
    cp.Paint = function(self, w, h)
        surface.SetDrawColor(0,0,0, 100)
        surface.DrawRect(0, 0, w, h-20)
        surface.SetDrawColor(0,0,0, 255)
        surface.DrawLine(0, h, 0, 0)
        surface.DrawLine(-1, 0, w, 0)
        surface.DrawLine(-1, h-21, w, h-21)
    end
    t.chat = cp

    -- chat entry
    local ce = vgui.Create("DButton", t.chat)
    ce:Dock(BOTTOM)
    ce:SetText('')
    ce:SetTall(20)
    ce:SetCursor('beam')
    ce.Paint = function(self, w, h)
        if self.Hovered then draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,1)) end
        draw.SimpleText(cats.lang.sendMessage, 'cats.small', 8, 10, Color(255,255,255, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    ce.DoClick = function(self)
        Derma_StringRequest(
            cats.lang.sendMessage, cats.lang.typeYourMessage, '',
            function(val)
                net.Start( "cats.dispatchMessage" )
                    net.WriteString(data.userID)
                    net.WriteString(val)
                net.SendToServer()
            end, function()
            end,
            cats.lang.ok, cats.lang.cancel
        )
    end

    -- chat log
    local cl = vgui.Create("RichText", t.chat)
    cl:Dock(FILL)
    cl.Paint = function(self) -- WHAT. THE. FUCK.
        self.m_FontName = "cats.small"
        self:SetFontInternal("cats.small")
        self:SetBGColor(Color(0,0,0,0))
        self.Paint = nil
    end
    t.chatLog = cl

    cats.ticketContainer[data.userID] = t
    cats.ticketFrame:PerformLayout()

end

local function addTicketChatLog(steamID, sender, msg, isAdmin)
    if OffDuty:GetBool() then print( "Ticket not displayed due to being offduty" ) return end
    local cl = cats.ticketContainer[steamID].chatLog
    if not IsValid(cl) then return end

    if isAdmin then
        cl:InsertColorChange(50,120,180, 255)
    else
        cl:InsertColorChange(180,160,50, 255)
    end
    cl:AppendText("\n" .. sender)

    cl:InsertColorChange(255,255,255, 255)
    cl:AppendText(": " .. msg)

end

-- generate main frame
if not cats.ticketFrame then
    hook.Add("Think", "cats", function()

        if IsValid(cats.ticketFrame) then cats.ticketFrame:Remove() end
        local w, h = cats.config.spawnSize[1], cats.config.spawnSize[2]
        local x, y = cats.config.spawnPosAdmin[1], cats.config.spawnPosAdmin[2]

        -- main frame
        local p0 = vgui.Create("DFrame")
        if not IsValid( p0 ) then return end
        --p0:MoveToFront()
        p0:SetSize(w, h)
        p0:SetPos(x, y)
        p0:DockPadding(0, 24, 0, 0)
        p0:SetTitle('')
        p0:ShowCloseButton(false)
        cats.ticketFrame = p0

        -- scroll panel
        local p1 = vgui.Create("DScrollPanel", p0)
        p1:Dock(FILL)
        local oldLayout = p1.PerformLayout
        p1.PerformLayout = function(self)
            oldLayout(self)
            for i, v in ipairs(cats.ticketContainer:GetChildren()) do
                v:InvalidateLayout()
            end
        end

        --p0.Think = function( self )
        --    self:MoveToFront()
        --end

        -- icon layout
        local p2 = vgui.Create("DIconLayout", p1)
        p2:Dock(FILL)
        p2:SetSpaceX(0)
        p2:SetSpaceY(0)
        cats.ticketContainer = p2

        -- finish up main frame with some spicy hooks
        local oldLayout = p0.PerformLayout
        p0.PerformLayout = function(self)
            oldLayout(self)
            self:SetTall( math.min(p2:GetTall(), ScrH() - 100, 600) + 27 )
            self:SetVisible(#p2:GetChildren() > 0)
        end
        p0.Paint = function(self, w, h)
            surface.SetDrawColor(44,44,44, 255)
            surface.DrawRect(0, 0, w, 24)
            surface.SetDrawColor(0,0,0, 255)
            surface.DrawOutlinedRect(0, 0, w, 24)
            draw.SimpleText(cats.lang.openTickets .. ' (' .. #p2:GetChildren() .. ')', 'cats.small', 8, 12, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        --p0:MakePopup()
        p0:SetFocusTopLevel(true)
        function p0:Think()
            self:MoveToFront()
            self:SetDrawOnTop(true)
        end
    	hook.Remove("Think", "cats")
    end)
end

-- my ticket frame
--if IsValid(cats.myTicketFrame) then cats.myTicketFrame:Remove() end
local function createMyTicket( data )

    -- sound notification
    surface.PlaySound(cats.config.newTicketSound)

    myTicket = data
    local w, h = cats.config.spawnSize[1], cats.config.spawnSize[2]
    local x, y = cats.config.spawnPosUser[1], cats.config.spawnPosUser[2]

    -- ticket frame
    local t = vgui.Create("DFrame")
    t:ShowCloseButton(false)
    t:SetSize(w, 220)
    t:SetPos(x, y)
    t:DockPadding(0,30,0,0)
    t:SetTitle('')
    t:MoveToFront()
    t.ticket = myTicket -- apply ticket
    t.Paint = function(self, w, h)
        local user, admin = self.ticket.user, self.ticket.admin

        surface.SetDrawColor(44,44,44, 220)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(0,0,0, 255)
        surface.DrawOutlinedRect(0,0,w,h)

        local time = '(' .. os.date( "%M:%S", CurTime() - self.ticket.created ) .. ')'
        draw.SimpleText(time .. ' ' .. cats.lang.myTicket, 'cats.small', 8, 15, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        if IsValid(admin) then
			local ratingAdmin = '★'.. math.Round(admin:GetNWFloat("cats_adminRating"), 1)
            draw.SimpleText(ratingAdmin .. ' ' .. admin:Name(), 'cats.small', w-8, 15, Color(180,200,240), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end
    end

	-- close ticket button
	surface.SetFont('cats.small')
	local tw, th = surface.GetTextSize(cats.lang.action_close)
	local b = vgui.Create("DButton", t)
	b:SetText('')
	b:SetSize(tw + 16,30)
	b:AlignRight(1)
	b.Paint = function(self, w, h)
        if self.Hovered then draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,1)) end
        draw.SimpleText(cats.lang.action_close, 'cats.small', w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
	b.DoClick = function(self)
		net.Start('cats.closeTicket')
			net.WriteString(LocalPlayer():SteamID())
		net.SendToServer()
	end
    b.Think = function(self) self:MoveToFront() end
	t.closeBut = b

    -- chat
    local cp = vgui.Create("DPanel", t)
    cp:Dock(FILL)
    cp.Paint = function(self, w, h)
        surface.SetDrawColor(0,0,0, 100)
        surface.DrawRect(0, 0, w, h-20)
        surface.SetDrawColor(0,0,0, 255)
        surface.DrawLine(0, h, 0, 0)
        surface.DrawLine(-1, 0, w, 0)
        surface.DrawLine(-1, h-21, w, h-21)
    end
    t.chat = cp

    -- chat entry
    local ce = vgui.Create("DButton", t.chat)
    ce:Dock(BOTTOM)
    ce:SetText('')
    ce:SetTall(20)
    ce:SetCursor('beam')
    ce.Paint = function(self, w, h)
        if self.Hovered then draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,1)) end
        draw.SimpleText(cats.lang.sendMessage, 'cats.small', 8, 10, Color(255,255,255, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    ce.DoClick = function(self)
        Derma_StringRequest(
            cats.lang.sendMessage, cats.lang.typeYourMessage, '',
            function(val)
                net.Start( "cats.dispatchMessage" )
                    net.WriteString(LocalPlayer():SteamID())
                    net.WriteString(val)
                net.SendToServer()
            end, function()
            end,
            cats.lang.ok, cats.lang.cancel
        )
    end
    ce.Think = function(self) self:MoveToFront() end

    -- chat log
    local cl = vgui.Create("RichText", t.chat)
    cl:Dock(FILL)
    cl.Paint = function(self) -- WHAT. THE. FUCK.
        self.m_FontName = "cats.small"
        self:SetFontInternal("cats.small")
        self:SetBGColor(Color(0,0,0,0))
        self.Paint = nil
    end
    t.chatLog = cl

    -- ticket closed, set rating
    t.SwitchToRating = function( self )
        -- remove chat thingies
        --cp:MoveToFront()
        cp:Clear()
        cp.Paint = function() end

        -- apply button
        local b = vgui.Create('DButton', cp)
        b:DockPadding(1,0,1,1)
        b:SetTall(30)
        b:Dock(BOTTOM)
        b:SetText('')
        b:SetEnabled(false)
        b.Paint = function( self, w, h )
            if self:IsEnabled() then
                if self.Hovered then draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,2)) end
                draw.SimpleText(cats.lang.ok, "cats.small", w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            surface.SetDrawColor(0,0,0, 255)
        end
        b.DoClick = function( self )
            net.Start('cats.setRating')
                net.WriteUInt(math.Clamp(myTicket.rating or cats.config.defaultRating, 1, 5), 8)
            net.SendToServer()
            cats.myTicketFrame:Remove()
            myTicket = nil
        end
        b.Think = function(self) end --self:MoveToFront() end

        -- stars panel
        local sp = vgui.Create('DPanel', cp)
        sp:Dock(FILL)
        --sp:MoveToFront()
        sp.Paint = function( self, w, h )
            draw.SimpleText(cats.lang.rateAdmin, "cats.small", w/2, h/2 - 24, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0, 100))
            surface.DrawLine(-1, 0, w, 0)
            surface.DrawLine(-1, h, w, h)
        end

        sp.Think = function( self )
            --self:MoveToFront()
        end

        -- stars buttons
        for i = 1, 5 do
            local off = i - 3
            local s = vgui.Create('DButton', sp)
            s:SetText('')
            s:SetSize(64, 64)
            --s:MoveToFront()
            s:SetPos(w / 2 + off * 64 - 32, 160 / 2 - 18)
            s.Paint = function(self, w, h)
                if self.Hovered then
                    draw.RoundedBox(0, 8, 8, 48, 48, Color(255,255,255, 2))
                end

                if not myTicket.rating then
                    surface.SetDrawColor(255,255,255, 20)
                    surface.SetMaterial(icons.star)
                    surface.DrawTexturedRect(16, 16, 32, 32)
                elseif myTicket.rating and i <= myTicket.rating then
                    surface.SetDrawColor(255,255,255)
                    surface.SetMaterial(icons.star)
                    surface.DrawTexturedRect(16, 16, 32, 32)
                else
                    surface.SetDrawColor(255,255,255)
                    surface.SetMaterial(icons.noStar)
                    surface.DrawTexturedRect(24, 24, 16, 16)
                end
            end
            s.DoClick = function( self )
                b:SetEnabled(true)
                myTicket.rating = i
            end
            s.Think = function(self) end --self:MoveToFront() end
            --s:SetFocusTopLevel(true)
        end

        --sp:MakePopup()
    end

    --t:MakePopup()
    cats.myTicketFrame = t
    t:SetFocusTopLevel(true)
    --t:MakePopup()

end

local function addMyTicketChatLog(sender, msg, isAdmin)

    local cl = cats.myTicketFrame.chatLog
    if not IsValid(cl) then return end

    if isAdmin then
        cl:InsertColorChange(50,120,180, 255)
    else
        cl:InsertColorChange(180,160,50, 255)
    end
    cl:AppendText("\n" .. sender)

    cl:InsertColorChange(255,255,255, 255)
    cl:AppendText(": " .. msg)

end

net.Receive('cats.dispatchMessage', function( len )
    if OffDuty:GetBool() then print( "Ticket not displayed due to being offduty" ) return end
    if not IsValid( LocalPlayer() ) then return end
    local steamID = net.ReadString()
    local sender = net.ReadEntity()
    local msg = net.ReadString()
    local name = cats.config.getPlayerName(sender)

    if not IsValid(sender) then return end

    if steamID == LocalPlayer():SteamID() then
        if myTicket then
            addMyTicketChatLog(name, msg, sender:SteamID() ~= LocalPlayer():SteamID())
        else
            createMyTicket({created = CurTime()})
            addMyTicketChatLog(name, msg, sender:SteamID() ~= LocalPlayer():SteamID())
        end
    elseif IsValid(cats.ticketContainer[steamID]) then
        addTicketChatLog(steamID, name, msg, sender:SteamID() ~= steamID)
    else
        local user = player.GetBySteamID(steamID)
        if not IsValid(user) then return end

        addTicketToFrame({
            user = user,
            userID = steamID,
            created = CurTime(),
        })
        addTicketChatLog(steamID, name, msg, sender:SteamID() ~= steamID)
    end

end)

net.Receive('cats.claimTicket', function( len )
    if OffDuty:GetBool() then print( "Ticket not displayed due to being offduty" ) return end
    if not IsValid( LocalPlayer() ) then return end
    local steamID = net.ReadString()
    local admin = net.ReadEntity()
    local doClaim = net.ReadBool()

    if not IsValid(admin) then return end

    if steamID == LocalPlayer():SteamID() and myTicket then
        myTicket.admin = doClaim and admin or nil
        myTicket.adminID = doClaim and admin:SteamID() or nil
		cats.myTicketFrame.closeBut:SetVisible(not doClaim)
    elseif IsValid(cats.ticketContainer[steamID]) then
        local ticket = cats.ticketContainer[steamID].ticket
        ticket.admin = doClaim and admin or nil
        ticket.adminID = doClaim and admin:SteamID() or nil

        if ticket.adminID ~= LocalPlayer():SteamID() then
            local b = cats.ticketContainer[steamID].controls.buttons['action_claim']
            if doClaim then
                applyButton(b, 'action_unclaim', steamID)
                b:SetEnabled(false)
            else
                applyButton(b, 'action_claim', steamID)
                b:SetEnabled(true)
            end
        end
    end

end)

net.Receive('cats.closeTicket', function( len )
    if OffDuty:GetBool() then print( "Ticket not displayed due to being offduty" ) return end
    if not IsValid( LocalPlayer() ) then return end
    local steamID = net.ReadString()

    if steamID == LocalPlayer():SteamID() and myTicket then
		if IsValid(myTicket.admin) then
	        cats.myTicketFrame:SwitchToRating()
		else
			cats.myTicketFrame:Remove()
            myTicket = nil
		end

        if ValidPanel( g_IDCardFrame ) and g_IDCardFrame:IsVisible() then
            g_IDCardFrame:Remove()
        end
    elseif IsValid(cats.ticketContainer[steamID]) then
        cats.ticketContainer[steamID].ticket = nil
        cats.ticketContainer[steamID]:Remove()
        cats.ticketContainer[steamID] = nil
        cats.ticketFrame:PerformLayout()
    end

end)

net.Receive('cats.setRating', function( len )
    if OffDuty:GetBool() then print( "Ticket not displayed due to being offduty" ) return end
    if not IsValid( LocalPlayer() ) then return end
    local steamID = net.ReadString()
    local rating = net.ReadUInt(8)

    if steamID == LocalPlayer():SteamID() then
        cats.myTicketFrame:Remove()
    end

end)

net.Receive('cats.syncTickets', function( len )
    if OffDuty:GetBool() then print( "Ticket not displayed due to being offduty" ) return end
    if not IsValid( LocalPlayer() ) then return end
    local tickets = net.ReadTable()
    for steamID, t in pairs(tickets) do
        local user = player.GetBySteamID(steamID)
        if IsValid(user) then
			addTicketToFrame({
				user = user,
				userID = steamID,
				created = t.createdGameTime,
				admin = t.admin,
				adminID = t.adminID
			})

			if IsValid(t.admin) then
				local b = cats.ticketContainer[steamID].controls.buttons['action_claim']
				applyButton(b, 'action_unclaim', t.user:SteamID())
				b:SetEnabled(false)
			end

			for k, v in pairs(t.chatLog) do
				addTicketChatLog(steamID, v[1], v[2], v[3])
			end
		end
    end

end)

concommand.Add("autickets_test_admin", function()

	local steamID = LocalPlayer():SteamID()
	addTicketToFrame({
		user = LocalPlayer(),
		userID = steamID,
		created = CurTime(),
		admin = LocalPlayer(),
		adminID = steamID,
	})
	addTicketChatLog(steamID, "User", "Admin let me test my ticket!", false)
	addTicketChatLog(steamID, "Admin", "Alright.", true)

end)

concommand.Add("autickets_test_admin_clear", function()

	cats.ticketContainer:Clear()

end)

concommand.Add("autickets_test_myticket", function()

	createMyTicket({created = CurTime()})
	addMyTicketChatLog("User", "Admin let me test my ticket!", false)
	addMyTicketChatLog("Admin", "Alright.", true)

end)

--#################################################
-- Analytics
--#################################################

local function createAnalyticsFrame()

    -- sound notification
    surface.PlaySound(cats.config.newTicketSound)

    local f = vgui.Create('DFrame')
    f:SetSize(1024, 768)
    f:SetTitle('AU Tickets - Analytics')
    f:Center()
    f:MakePopup()
    --f:MoveToFront()
    cats.analyticsFrame = f

    local l = vgui.Create('DListView', f)
    l:Dock(LEFT)
    l:SetWide(160)
    l:SetMultiSelect(false)
    l:AddColumn('Rating'):SetFixedWidth(50)
    l:AddColumn('Admin')
    l.OnRowSelected = function(self, i, line)
        f.pnl:Clear()
        local lbl = vgui.Create('DLabel', f.pnl)
        lbl:SetText('Loading...')
        lbl:SizeToContents()
        lbl:Center()

        net.Start('cats.getAdminData')
            net.WriteString(line.steamID)
        net.SendToServer()
    end
    f.list = l

    local p = vgui.Create('DScrollPanel', f)
    p:DockMargin(5,0,0,0)
    p:Dock(FILL)
    f.pnl = p

    net.Start('cats.getAdminList')
    net.SendToServer()

end
concommand.Add('autickets_analytics', createAnalyticsFrame)

net.Receive('cats.getAdminList', function()

    local data = net.ReadTable()
    for steamID, adminData in pairs(data) do
        local rating = '★'.. math.Round(adminData.ratingTotal, 2)
        local l = cats.analyticsFrame.list:AddLine(rating, adminData.lastNick)
        l.steamID = steamID
    end
    cats.analyticsFrame.list:SortByColumn(1, true)

end)

net.Receive('cats.getAdminData', function()

    local data = net.ReadTable()
    if not IsValid(cats.analyticsFrame) or not IsValid(cats.analyticsFrame.pnl) then return end

    local p = cats.analyticsFrame.pnl
    p:Clear()

    -- nickname
    local l_nick = vgui.Create('DLabel', p)
    l_nick:DockMargin(20,10,20,0)
    l_nick:Dock(TOP)
    l_nick:SetTall(50)
    l_nick:SetFont('cats.xlarge')
    l_nick:SetText(data.lastNick)

    -- steamid
    local l_steamid = vgui.Create('DLabel', p)
    l_steamid:DockMargin(20,5,20,0)
    l_steamid:Dock(TOP)
    l_steamid:SetTall(20)
    l_steamid:SetFont('cats.medium')
    l_steamid:SetText(data.steamID)
    l_steamid:SetToolTip('Click to copy SteamID')
    l_steamid.DoClick = function(self) SetClipboardText(data.steamID) end
    l_steamid.Think = function(self) self:MoveToFront() end

    -- stats
    local stats = {
        { 'RATING', '★' .. math.Round(data.ratingTotal, 2) },
        { 'TICKETS', data.claimsTotal },
        { 'UNIQUE USERS', data.uniqueUsers },
        { 'PER WEEK', math.Round(data.claimsTotal / (data.updateTime - data.createdTime) * 604800) },
        { 'TICKET TIME', niceTime(data.ticketTimeTotal) },
    }

    if data.playTimeTotal then
        table.insert( stats, { 'ONLINE TIME', niceTime(data.playTimeTotal) })
    end

    local i_stats = vgui.Create('DIconLayout', p)
    i_stats:DockMargin(20,20,20,0)
    i_stats:Dock(TOP)
    i_stats:SetTall(100)
    for i, v in ipairs(stats) do
        local item = i_stats:Add('DPanel')
        item:SetSize((p.pnlCanvas:GetWide() - 40) / 3, 100)
        item.Paint = function(self, w, h)
            draw.RoundedBox(8, 5, 5, w-10, h-10, Color(0,0,0, 60))
            draw.SimpleText(v[1], "cats.medium", w/2, 30, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(v[2], "cats.xlarge", w/2, 65, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        item.PerformLayout = function(self)
            self:SetWide((p.pnlCanvas:GetWide() - 40) / 3)
        end
    end

    -- timeCard header
    local l_timeCard = vgui.Create('DLabel', p)
    l_timeCard:DockMargin(20,20,20,5)
    l_timeCard:Dock(TOP)
    l_timeCard:SetTall(20)
    l_timeCard:SetFont('cats.medium')
    l_timeCard:SetText('Play time card')

    -- timeCard
    local dow, punchMode, punchStart = cats.lang.dow, cats.config.punchCardMode, cats.config.punchCardStart - 1
    local maxTimePunch = 1
    for i1 = 1, 7 do
        for i2 = 1, 24 do
            maxTimePunch = math.max(maxTimePunch, data.timeCard[i1][i2])
        end
    end

    local p_timeCard = vgui.Create('DPanel', p)
    p_timeCard:DockMargin(20,10,20,0)
    p_timeCard:Dock(TOP)
    p_timeCard:SetTall(400)
    p_timeCard.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(0,0,0, 60))

        w, h = w - 55, h - 35
        local eh, ew = h / 7, w / 24

        draw.NoTexture()
        for day = 1, 7 do
            draw.SimpleText(dow[day], "cats.medium", 25, 30 + eh * (day) - eh / 2, Color(255,255,255, 35), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        surface.SetDrawColor(255,255,255, 4)
        for hourRaw = 1, 24 do
            local hour = hourRaw - punchStart
            hour = hour > 0 and hour or hour + 24

            draw.SimpleText(hourRaw ~= 24 and hourRaw or 0, "cats.small", 50 + ew * (hour-1) + ew / 2, 20, Color(255,255,255, 35), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            surface.SetDrawColor(255,255,255, 4)
            if punchMode == 'dots' then
                surface.DrawLine(50 + ew * (hour-1) + ew / 2, 30 + eh / 2, 50 + ew * (hour-1) + ew / 2, 30 + h - eh / 2)
            elseif punchMode == 'line' then
                surface.DrawLine(50 + ew * (hour-1) + ew / 2, 30, 50 + ew * (hour-1) + ew / 2, 30 + h)
            end
        end
    end

    local p_punchdraw = vgui.Create('DPanel', p_timeCard)
    p_punchdraw:DockMargin(50,30,5,5)
    p_punchdraw:Dock(FILL)
    p_punchdraw.Paint = function(self, w, h)
        local eh, ew = h / 7, w / 24
        draw.NoTexture()

        for day = 1, 7 do
            for hourRaw = 1, 24 do
                local hour = hourRaw - punchStart
                hour = hour > 0 and hour or hour + 24

                if punchMode == 'dots' then
                    local r = math.max(math.floor((ew - 4) * data.timeCard[day][hourRaw] / maxTimePunch), 2)
                    local x, y = math.floor(ew * (hour-1) + ew / 2), math.floor(eh * (day) - eh / 2)
                    surface.SetDrawColor(255,255,255)
                    drawCircle(x, y, r / 2, math.max(r, 6))
                elseif punchMode == 'line' then
                    if hour < 24 then
                        local x1, y1 = ew * (hour-1) + ew / 2, eh * (day) - (eh - 16) * data.timeCard[day][hourRaw] / maxTimePunch - 8
                        local x2, y2 = ew * (hour) + ew / 2, eh * (day) - (eh - 16) * data.timeCard[day][hour + 1] / maxTimePunch - 8
                        surface.SetDrawColor(255,255,255)
                        surface.DrawLine(math.floor(x1), math.floor(y1), math.floor(x2), math.floor(y2))
                    end
                else
                    local curH = math.floor(math.floor((eh - 8) * data.timeCard[day][hourRaw] / maxTimePunch))
                    draw.RoundedBoxEx(math.floor(math.min(curH, 4)), ew * (hour-1) + 3, math.floor(eh * (day) - curH), ew - 6, curH, Color(255,255,255), true, true, false, false)
                end

            end
        end
    end

    -- claimCard header
    local l_claimCard = vgui.Create('DLabel', p)
    l_claimCard:DockMargin(20,20,20,5)
    l_claimCard:Dock(TOP)
    l_claimCard:SetTall(20)
    l_claimCard:SetFont('cats.medium')
    l_claimCard:SetText('Ticket claim card')

    -- claimCard
    local maxClaimPunch = 1
    for i1 = 1, 7 do
        for i2 = 1, 24 do
            maxClaimPunch = math.max(maxClaimPunch, data.claimCard[i1][i2])
        end
    end

    local p_claimCard = vgui.Create('DPanel', p)
    p_claimCard:DockMargin(20,10,20,0)
    p_claimCard:Dock(TOP)
    p_claimCard:SetTall(400)
    p_claimCard.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(0,0,0, 60))

        w, h = w - 55, h - 35
        local eh, ew = h / 7, w / 24

        draw.NoTexture()
        for day = 1, 7 do
            draw.SimpleText(dow[day], "cats.medium", 25, 30 + eh * (day) - eh / 2, Color(255,255,255, 35), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        surface.SetDrawColor(255,255,255, 4)
        for hourRaw = 1, 24 do
            local hour = hourRaw - punchStart
            hour = hour > 0 and hour or hour + 24

            draw.SimpleText(hourRaw ~= 24 and hourRaw or 0, "cats.small", 50 + ew * (hour-1) + ew / 2, 20, Color(255,255,255, 35), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            surface.SetDrawColor(255,255,255, 4)
            if punchMode == 'dots' then
                surface.DrawLine(50 + ew * (hour-1) + ew / 2, 30 + eh / 2, 50 + ew * (hour-1) + ew / 2, 30 + h - eh / 2)
            elseif punchMode == 'line' then
                surface.DrawLine(50 + ew * (hour-1) + ew / 2, 30, 50 + ew * (hour-1) + ew / 2, 30 + h)
            end
        end
    end

    local dow, punchMode, punchStart = cats.lang.dow, cats.config.punchCardMode, cats.config.punchCardStart - 1
    local p_punchdraw = vgui.Create('DPanel', p_claimCard)
    p_punchdraw:DockMargin(50,30,5,5)
    p_punchdraw:Dock(FILL)
    p_punchdraw.Paint = function(self, w, h)
        local eh, ew = h / 7, w / 24
        draw.NoTexture()

        for day = 1, 7 do
            for hourRaw = 1, 24 do
                local hour = hourRaw - punchStart
                hour = hour > 0 and hour or hour + 24

                if punchMode == 'dots' then
                    local r = math.max(math.floor((ew - 4) * data.claimCard[day][hourRaw] / maxClaimPunch), 2)
                    local x, y = math.floor(ew * (hour-1) + ew / 2), math.floor(eh * (day) - eh / 2)
                    surface.SetDrawColor(255,255,255)
                    drawCircle(x, y, r / 2, math.max(r, 6))
                elseif punchMode == 'line' then
                    if hour < 24 then
                        local x1, y1 = ew * (hour-1) + ew / 2, eh * (day) - (eh - 16) * data.claimCard[day][hourRaw] / maxClaimPunch - 8
                        local x2, y2 = ew * (hour) + ew / 2, eh * (day) - (eh - 16) * data.claimCard[day][hour + 1] / maxClaimPunch - 8
                        surface.SetDrawColor(255,255,255)
                        surface.DrawLine(math.floor(x1), math.floor(y1), math.floor(x2), math.floor(y2))
                    end
                else
                    local curH = math.floor(math.floor((eh - 8) * data.claimCard[day][hourRaw] / maxClaimPunch))
					draw.RoundedBoxEx(math.floor(math.min(curH, 4)), ew * (hour-1) + 3, math.floor(eh * (day) - curH), ew - 6, curH, Color(255,255,255), true, true, false, false)
                end

            end
        end
    end

end)