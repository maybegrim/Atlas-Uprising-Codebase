ENFORCER.WarnFrame = ENFORCER.WarnFrame or false

--[[local function sizeScale(size)
    local screenWidth, screenHeight = ScrW(), ScrH()
    local averageScreenSize = (screenWidth + screenHeight) / 2
    return size * (averageScreenSize / 1080) -- 1080 is a base resolution, change it to your needs
end]]

for i = 1, 100 do
    surface.CreateFont( "ENFORCER.WarnFrame.Font."..i, {
        font = "MADE Tommy Soft",
        size = i,
        weight = 500,
        antialias = true,
    } )
end

local function screenScaleW(width)
    return width*(ScrW()/640)
end

local function screenScaleH(height)
    return height*(ScrH()/480)
end

local function screenScale(width,height)
    return screenScaleW(width),screenScaleH(height)
end

function ENFORCER.AreYouSure(wantText, callback)
    local frameX, frameY = 100,100

    local Frame = vgui.Create( "DFrame" )
    Frame:SetTitle("")
    Frame:SetSize( screenScaleW(frameX), screenScaleH(frameY) )
    Frame:Center()
    Frame:ShowCloseButton(false)
    Frame:SetDraggable(false)
    Frame:MakePopup()
    Frame.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 56, 56, 64))
    end

    local titleLabel = vgui.Create( "DLabel", Frame )
    titleLabel:SetPos( screenScaleW(10), screenScaleH(5) )
    titleLabel:SetSize( screenScaleW(frameX-20), screenScaleH(20) )
    titleLabel:SetText( "Are you sure you want to:" )
    titleLabel:SetFont( "ENFORCER.WarnFrame.Font.20" )
    titleLabel:SetColor( Color( 255, 255, 255 ) )
    titleLabel:SetContentAlignment( 5 )
    if not wantText then
        wantText = "Unknown Action"
    end
    local wantLabel = vgui.Create( "DLabel", Frame )
    wantLabel:SetPos( screenScaleW(10), screenScaleH(15) )
    wantLabel:SetSize( screenScaleW(frameX-20), screenScaleH(20) )
    wantLabel:SetText( wantText )
    wantLabel:SetFont( "ENFORCER.WarnFrame.Font.20" )
    wantLabel:SetColor( Color( 194, 78, 78) )
    wantLabel:SetContentAlignment( 5 )

    local yesButton = vgui.Create( "DButton", Frame )
    yesButton:SetPos( screenScaleW(10), screenScaleH(40) )
    yesButton:SetSize( screenScaleW(frameX-20), screenScaleH(20) )
    yesButton:SetText( "Yes" )
    yesButton:SetFont( "ENFORCER.WarnFrame.Font.20" )
    yesButton:SetColor( Color( 255, 255, 255) )
    yesButton:SetContentAlignment( 5 )
    yesButton.Paint = function( self, w, h )
        if self:IsHovered() then
            draw.RoundedBox( 0, 0, 0, w, h, Color( 35, 105, 93)) -- Change color when hovered
        else
            draw.RoundedBox( 0, 0, 0, w, h, Color( 45, 125, 111))
        end

        if not self:IsEnabled() then
            draw.RoundedBox( 0, 0, 0, w, h, Color( 19, 37, 35))
        end
    end
    yesButton.DoClick = function()
        Frame:Close()
        callback(true)
    end


    local noButton = vgui.Create( "DButton", Frame )
    noButton:SetPos( screenScaleW(10), screenScaleH(70) )
    noButton:SetSize( screenScaleW(frameX-20), screenScaleH(20) )
    noButton:SetText( "No" )
    noButton:SetFont( "ENFORCER.WarnFrame.Font.20" )
    noButton:SetColor( Color( 255, 255, 255 ) )
    noButton:SetContentAlignment( 5 )

    noButton.Paint = function( self, w, h )
        if self:IsHovered() then
            draw.RoundedBox( 0, 0, 0, w, h, Color( 113, 37, 37)) -- Change color when hovered
        else
            draw.RoundedBox( 0, 0, 0, w, h, Color( 156, 60, 60))
        end

        if not self:IsEnabled() then
            draw.RoundedBox( 0, 0, 0, w, h, Color( 37, 19, 19))
        end
    end

    noButton.DoClick = function()
        Frame:Close()
        callback(false)
    end

    yesButton:SetEnabled(false)
    noButton:SetEnabled(false)

    local function enableButtons()
        yesButton:SetEnabled(true)
        noButton:SetEnabled(true)
    end

    timer.Simple(1, enableButtons)
end

function ENFORCER.ViewData(data)
    local frameX, frameY = 180, 150

    local Frame = vgui.Create( "DFrame" )
    Frame:SetTitle("")
    Frame:SetSize( screenScaleW(frameX), screenScaleH(frameY) )
    Frame:Center()
    Frame:MakePopup()
    Frame:ShowCloseButton(true)
    Frame:SetDraggable(false)
    Frame.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 41, 51))
    end

    local title = vgui.Create( "DLabel", Frame )
    -- top left
    title:SetPos( screenScaleW(2), screenScaleH(1) )
    title:SetText( "Data Viewer" )
    title:SetFont( "ENFORCER.WarnFrame.Font.20" )
    title:SetColor( Color( 255, 255, 255 ) )
    title:SetContentAlignment( 5 )
    title:SizeToContents()

    -- data.title will be on top, data.content will be a table of data entries we will display
    local dataTitle = vgui.Create( "DLabel", Frame )
    dataTitle:SetPos( screenScaleW(10), screenScaleH(5) )
    dataTitle:SetSize( screenScaleW(frameX-20), screenScaleH(20) )
    dataTitle:SetText( data and data.title or "Unknown Title" )
    dataTitle:SetFont( "ENFORCER.WarnFrame.Font.30" )
    dataTitle:SetColor( Color( 255, 255, 255 ) )
    dataTitle:SetContentAlignment( 5 )

    local dataContent = vgui.Create( "DPanelList", Frame )
    dataContent:SetPos( screenScaleW(10), screenScaleH(30) )
    dataContent:SetSize( screenScaleW(frameX-20), screenScaleH(frameY-40) )
    dataContent:SetSpacing( 0 )
    dataContent:EnableHorizontal( false )
    dataContent:EnableVerticalScrollbar( true )
    dataContent:SetMouseInputEnabled(true)
    
    for k, v in ipairs(data.content) do
        local dataEntry = vgui.Create( "DPanel" )
        dataEntry:SetSize( dataContent:GetWide(), screenScaleH(15) )
        dataEntry.Paint = function( self, w, h )
            draw.SimpleText( v, "ENFORCER.WarnFrame.Font.20", w / 2, h / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
        dataContent:AddItem( dataEntry )
    end

    -- links
    if not data.link then return end
    local dataEntry = vgui.Create( "DPanel" )
    dataEntry:SetSize( dataContent:GetWide(), screenScaleH(20) )
    dataEntry.Paint = function( self, w, h )
        draw.SimpleText( "Evidence: ", "ENFORCER.WarnFrame.Font.20", w / 2, h / 3, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        if not data.link.text then return end
        draw.SimpleText( data.link.text, "ENFORCER.WarnFrame.Font.20", w / 2, h /1.5, Color( 220, 35, 35), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        surface.SetDrawColor(220, 35, 35)
        local textWidth, textHeight = surface.GetTextSize(data.link.text)
        surface.DrawLine(w/2 - textWidth/2, h/1.2, w/2 + textWidth/2, h/1.2)
    end
    dataEntry:SetCursor("hand")
    dataEntry:SetMouseInputEnabled(true)

    local function isValidUrl(url)
        local pattern = "^https?://[%w-_%.%?%.:/%+=&]+%.[%w]+.*$"
        return url:match(pattern) ~= nil
    end
    local confirmedURL = ""
    -- if url has a tld but no http:// or https:// then add https:// 
    if data.link.url:match("^[%w-_%.%?%.:/%+=&]+%.[%w]+$") and not data.link.url:match("^https?://") then    
        confirmedURL = "https://"..data.link.url
    elseif data.link.url:match("^https?://") then
        confirmedURL = data.link.url
    else
        confirmedURL = data.link.url
    end

    if isValidUrl(confirmedURL) then
        dataEntry.OnMousePressed = function()
            -- if left click
            if input.IsMouseDown(MOUSE_LEFT) then
                gui.OpenURL(confirmedURL)
            end
            if input.IsMouseDown(MOUSE_RIGHT) then
                SetClipboardText(confirmedURL)
            end
        end
    else
        dataEntry.Paint = function( self, w, h )
            draw.SimpleText( confirmedURL, "ENFORCER.WarnFrame.Font.20", w / 2, h / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
    end


    dataContent:AddItem( dataEntry )
end

function ENFORCER.EditWarning(pWarning)
    local frameX, frameY = 180, 130

    local Frame = vgui.Create( "DFrame" )
    Frame:SetTitle("")
    Frame:SetSize( screenScaleW(frameX), screenScaleH(frameY) )
    Frame:Center()
    Frame:MakePopup()
    Frame:ShowCloseButton(false)
    Frame:SetDraggable(false)
    Frame.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 41, 44))
    end

    -- x top right
    local closeLabel = vgui.Create( "DLabel", Frame )
    closeLabel:SetPos( screenScaleW(frameX-8), screenScaleH(0) )
    closeLabel:SetSize( screenScaleW(7), screenScaleH(10) )
    closeLabel:SetText( "X" )
    closeLabel:SetFont( "ENFORCER.WarnFrame.Font.25" )
    closeLabel:SetColor( Color( 255, 255, 255 ) )
    closeLabel:SetMouseInputEnabled( true )
    closeLabel:SetCursor( "hand" )
    closeLabel:SetContentAlignment( 5 )
    closeLabel.DoClick = function()
        Frame:Close()
    end
    closeLabel.Think = function()
        if closeLabel:IsHovered() then
            closeLabel:SetColor( Color( 248, 95, 95) )
        else
            closeLabel:SetColor( Color( 255, 255, 255 ) )
        end
    end


    local title = vgui.Create( "DLabel", Frame )
    -- top left
    title:SetPos( screenScaleW(2), screenScaleH(1) )
    title:SetText( "Edit Warning | For " .. pWarning.steamid )
    title:SetFont( "ENFORCER.WarnFrame.Font.20" )
    title:SetColor( Color( 255, 255, 255 ) )
    title:SetContentAlignment( 5 )
    title:SizeToContents()

    Frame.formatLabel = function(label)
        label:SetFont( "ENFORCER.WarnFrame.Font.20" )
        label:SetColor( Color( 255, 255, 255 ) )
        label:SetContentAlignment( 5 )
        label:SizeToContents()
        label.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 27, 26, 40))
        end
    end

    Frame.formatEntry = function(entry)
        entry:SetFont( "ENFORCER.WarnFrame.Font.20" )
        entry:SetContentAlignment( 5 )
        entry:SizeToContents()
        entry.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 27, 26, 40))
            self:DrawTextEntryText( Color( 255, 255, 255 ), Color( 255, 255, 255 ), Color( 255, 255, 255 ) )
        end
    end

    local reasonLabel = vgui.Create( "DLabel", Frame )
    reasonLabel:SetPos( screenScaleW(10), screenScaleH(21) )
    reasonLabel:SetText( " REASON " )
    Frame.formatLabel(reasonLabel)

    local reasonEntry = vgui.Create( "DTextEntry", Frame )
    reasonEntry:SetPos( screenScaleW(10), screenScaleH(30) )
    reasonEntry:SetSize( screenScaleW(frameX-20), screenScaleH(20) )
    reasonEntry:SetText( pWarning.reason )
    Frame.formatEntry(reasonEntry)

    local evidenceLabel = vgui.Create( "DLabel", Frame )
    evidenceLabel:SetPos( screenScaleW(10), screenScaleH(52) )
    evidenceLabel:SetText( " EVIDENCE " )
    Frame.formatLabel(evidenceLabel)

    local evidenceEntry = vgui.Create( "DTextEntry", Frame )
    evidenceEntry:SetPos( screenScaleW(10), screenScaleH(60) )
    evidenceEntry:SetSize( screenScaleW(frameX-20), screenScaleH(20) )
    evidenceEntry:SetText( pWarning.evidence )
    Frame.formatEntry(evidenceEntry)

    local submitButton = vgui.Create( "DButton", Frame )
    submitButton:SetPos( screenScaleW(10), screenScaleH(90) )
    submitButton:SetSize( screenScaleW(frameX-20), screenScaleH(20) )
    submitButton:SetText( "Submit" )
    submitButton:SetFont( "ENFORCER.WarnFrame.Font.20" )
    submitButton:SetColor( Color( 255, 255, 255) )
    submitButton:SetContentAlignment( 5 )
    submitButton.Paint = function( self, w, h )
        if self:IsHovered() then
            draw.RoundedBox( 0, 0, 0, w, h, Color( 35, 105, 93)) -- Change color when hovered
        else
            draw.RoundedBox( 0, 0, 0, w, h, Color( 45, 125, 111))
        end

        if not self:IsEnabled() then
            draw.RoundedBox( 0, 0, 0, w, h, Color( 19, 37, 35))
        end
    end
    submitButton.DoClick = function()
        local reason = reasonEntry:GetValue()
        local evidence = evidenceEntry:GetValue()
        local warnData = pWarning
        warnData.reason = reason
        warnData.evidence = evidence
        ENFORCER.EditWarningSubmit(warnData)
        Frame:Close()
    end


end

function ENFORCER.OpenWarnFrame()
    if ENFORCER.WarnFrame and ENFORCER.WarnFrame:IsValid() then
        ENFORCER.WarnFrame:Close()
        ENFORCER.WarnFrame = false
    end

    local frameX, frameY = 400, 300

    local Frame = vgui.Create( "DFrame" )
    ENFORCER.WarnFrame = Frame
    Frame:SetTitle("")
    Frame:SetSize( screenScaleW(frameX), screenScaleH(frameY) )
    Frame:Center()
    Frame:MakePopup()
    Frame:ShowCloseButton(false)
    Frame:SetDraggable(false)
    Frame.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 56, 56, 64))
    end



    -- Top panel
    local topPanel = vgui.Create( "DPanel", Frame )
    topPanel:SetPos( screenScaleW(40), 0 )
    topPanel:SetSize( screenScaleW(frameX-40), screenScaleH(40) )
    topPanel.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 27, 26, 40))
    end

    -- left panel
    local leftPanel = vgui.Create( "DPanel", Frame )
    leftPanel:SetPos( 0, screenScaleH(40) )
    leftPanel:SetSize( screenScaleW(40), screenScaleH(frameY-40) )
    leftPanel.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 27, 26, 40))
    end

    -- Top left panel with logo drawn in middle
    local topLeftPanel = vgui.Create( "DPanel", Frame )
    topLeftPanel:SetPos( 0, 0 )
    topLeftPanel:SetSize( screenScaleW(40), screenScaleH(40) )
    topLeftPanel.Paint = function( self, w, h )
        topLeftPanel.Paint = function( self, w, h )
            -- Draw a light red gradient box full size
            surface.SetTexture( surface.GetTextureID( "gui/gradient" ) )
            surface.SetDrawColor( Color( 255, 100, 120) ) -- Light red
            surface.DrawTexturedRect( 0, 0, w, h )

            -- Draw a dark red gradient box full size with transparency
            surface.SetTexture( surface.GetTextureID( "vgui/gradient-r" ) )
            surface.SetDrawColor( Color( 196, 42, 42, 120) ) -- Dark red
            surface.DrawTexturedRect( 0, 0, w, h )

            -- Letter E in middle
            -- draw behind E
            draw.SimpleText( "E", "ENFORCER.WarnFrame.Font.60", w/1.93, h/2.39, Color( 7, 7, 7, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            draw.SimpleText( "E", "ENFORCER.WarnFrame.Font.60", w/2, h/2.5, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            -- word ENFORCER under
            draw.SimpleText( "ENFORCER", "ENFORCER.WarnFrame.Font.20", w/1.93, h/1.26, Color( 7, 7, 7, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            draw.SimpleText( "ENFORCER", "ENFORCER.WarnFrame.Font.20", w/2, h/1.3, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end

    end



    -- X top right just text
    local closeLabel = vgui.Create( "DLabel", Frame )
    closeLabel:SetPos( screenScaleW(frameX-7), 0 )
    closeLabel:SetSize( screenScaleW(7), screenScaleH(10) )
    closeLabel:SetText( "X" )
    closeLabel:SetFont( "ENFORCER.WarnFrame.Font.25" )
    closeLabel:SetColor( Color( 255, 255, 255 ) )
    closeLabel:SetMouseInputEnabled( true )
    closeLabel:SetCursor( "hand" )
    closeLabel:SetContentAlignment( 5 )
    closeLabel.DoClick = function()
        ENFORCER.CloseWarnFrame()
    end
    closeLabel.Think = function()
        if closeLabel:IsHovered() then
            closeLabel:SetColor( Color( 248, 95, 95) )
        else
            closeLabel:SetColor( Color( 255, 255, 255 ) )
        end
    end

    -- Define position variables
    local userInfoX = 220
    local userInfoY = 5
    local avatarX = 2.5     -- Increase this to move the avatar image to the right
    local avatarY = 2.5

    -- User information located on top panel
    local userInfo = vgui.Create( "DPanel", topPanel)
    userInfo:SetPos( screenScaleW(userInfoX), screenScaleH(userInfoY) )
    userInfo:SetSize( screenScaleW(120), screenScaleH(30) )
    userInfo.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 56, 56, 64))
        draw.SimpleText( "Name: "..LocalPlayer():Nick(), "ENFORCER.WarnFrame.Font.20", screenScaleW(24), screenScaleH(5), Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        draw.SimpleText( "SteamID: "..LocalPlayer():SteamID64(), "ENFORCER.WarnFrame.Font.20", screenScaleW(24), screenScaleH(13), Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    end

    -- User profile picture
    local avatar = vgui.Create( "AvatarImage", userInfo )
    avatar:SetSize( screenScaleW(20), screenScaleH(25) )
    avatar:SetPos( screenScaleW(avatarX), screenScaleH(avatarY) )
    avatar:SetPlayer( LocalPlayer(), 128 )

    
    local topPanelLabel2 = vgui.Create( "DLabel", topPanel )
    topPanelLabel2:SetPos( screenScaleW(10.8), screenScaleH(10.8) )
    topPanelLabel2:SetSize( screenScaleW(120), screenScaleH(20) )
    topPanelLabel2:SetText( "MY WARNS" )
    topPanelLabel2:SetFont( "ENFORCER.WarnFrame.Font.50" )
    topPanelLabel2:SetColor( Color( 117, 117, 117, 100) )
    local topPanelLabel = vgui.Create( "DLabel", topPanel )
    topPanelLabel:SetPos( screenScaleW(10), screenScaleH(10) )
    topPanelLabel:SetSize( screenScaleW(120), screenScaleH(20) )
    topPanelLabel:SetText( "MY WARNS" )
    topPanelLabel:SetFont( "ENFORCER.WarnFrame.Font.50" )
    topPanelLabel:SetColor( Color( 255, 255, 255 ) )

    topPanel.changeTitle = function(title)
        topPanelLabel:SetText( title )
        topPanelLabel2:SetText( title )
    end



    local myWarns = vgui.Create( "DPanel", Frame )
    myWarns:SetPos( screenScaleW(40), screenScaleH(40) )
    myWarns:SetSize( screenScaleW(frameX-40), screenScaleH(frameY-40) )
    myWarns.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 56, 56, 64))
    end

    local myBans = vgui.Create( "DPanel", Frame )
    myBans:SetPos( screenScaleW(40), screenScaleH(40) )
    myBans:SetSize( screenScaleW(frameX-40), screenScaleH(frameY-40) )
    myBans.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 56, 56, 64))
    end
    myBans:SetVisible(false)

    local database = vgui.Create( "DPanel", Frame )
    database:SetPos( screenScaleW(40), screenScaleH(40) )
    database:SetSize( screenScaleW(frameX-40), screenScaleH(frameY-40) )
    database.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 56, 56, 64))
    end
    database:SetVisible(false)

    -- Call these early for reference.
    local loadingIcon_DB = vgui.Create("DPanel", database)
    local isDBPopulated = false

    local settings = vgui.Create( "DPanel", Frame )
    settings:SetPos( screenScaleW(40), screenScaleH(40) )
    settings:SetSize( screenScaleW(frameX-40), screenScaleH(frameY-40) )
    settings.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 56, 56, 64))
    end
    settings:SetVisible(false)

    local banDatabase = vgui.Create( "DPanel", Frame )
    banDatabase:SetPos( screenScaleW(40), screenScaleH(40) )
    banDatabase:SetSize( screenScaleW(frameX-40), screenScaleH(frameY-40) )
    banDatabase.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 56, 56, 64))
    end
    banDatabase:SetVisible(false)

    local loadingIcon_BanDB = vgui.Create("DPanel", banDatabase)
    local isBanDBPopulated = false

    -- Left panel side buttons
    local buttons = {
        [1] = {
            text = "My Warns",
            content = function()
                myWarns:SetVisible(true)
                database:SetVisible(false)
                settings:SetVisible(false)
                banDatabase:SetVisible(false)
                myBans:SetVisible(false)
                topPanel.changeTitle("MY WARNS")
            end,
        },
        [2] = {
            text = "My Bans",
            content = function()
                myWarns:SetVisible(false)
                database:SetVisible(false)
                settings:SetVisible(false)
                banDatabase:SetVisible(false)
                myBans:SetVisible(true)
                topPanel.changeTitle("MY BANS")
            end,
        },
        [3] = {
            text = "Warns DB",
            content = function()
                myWarns:SetVisible(false)
                database:SetVisible(true)
                settings:SetVisible(false)
                banDatabase:SetVisible(false)
                myBans:SetVisible(false)
                topPanel.changeTitle("WARNS DB")
                ENFORCER.RetrieveAllWarnings(function()
                    if isDBPopulated then return end
                    loadingIcon_DB:Remove()
                    database.populateContent()
                end)
            end,
        },
        [4] = {
            text = "Bans DB",
            content = function()
                myWarns:SetVisible(false)
                database:SetVisible(false)
                settings:SetVisible(false)
                banDatabase:SetVisible(true)
                myBans:SetVisible(false)
                topPanel.changeTitle("BANS DB")
                ENFORCER.RetrieveAllBans(function()
                    if isBanDBPopulated then return end
                    loadingIcon_BanDB:Remove()
                    banDatabase.populateContent()
                end)
            end,
        },
        [5] = {
            text = "Settings",
            content = function()
                myWarns:SetVisible(false)
                database:SetVisible(false)
                settings:SetVisible(true)
                banDatabase:SetVisible(false)
                myBans:SetVisible(false)
                topPanel.changeTitle("SETTINGS")
            end,
        },
        [6] = {
            text = "Close",
            content = function() ENFORCER.CloseWarnFrame() end,
        },
    }

    if not LocalPlayer():HasPermission("view_warning_db") then
        buttons[2] = nil
        -- fix the buttons table keys
        local tempButtons = {}
        for k, v in pairs(buttons) do
            print(k)
            if not tempButtons[k - 1] and k ~= 1 then
                tempButtons[k - 1] = v
            else
                tempButtons[k] = v
            end
        end
        buttons = tempButtons
    
    end

    local buttonHeight = 30
    local buttonWidth = 40
    local buttonSpacing = 5
    local buttonX = 0
    local buttonY = 0
    local activeButton = 1

    for k, v in ipairs(buttons) do
        local button = vgui.Create( "DButton", leftPanel )
        button:SetPos( screenScaleW(buttonX), screenScaleH(buttonY) )
        button:SetSize( screenScaleW(buttonWidth), screenScaleH(buttonHeight) )
        button:SetText( "" )
        button.ID = k
        button.Paint = function( self, w, h )
            if self:IsHovered() then
                draw.RoundedBox( 0, 0, 0, w, h, Color( 40, 40, 60)) -- Change color when hovered
            else
                draw.RoundedBox( 0, 0, 0, w, h, Color( 27, 26, 40))
            end
            if self.ID == activeButton then
                draw.RoundedBox( 0, 0, 0, w, h, Color( 56, 56, 64))
            end
            draw.SimpleText( v.text, "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(5), Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        end
        button.DoClick = function()
            v.content()
            activeButton = k
        end

        buttonY = buttonY + buttonHeight + buttonSpacing -- Increment buttonY for the next button
    end


    -- MyWarns
    myWarns.populateContent = function()
        local warnCountRounded = vgui.Create( "DPanel", myWarns )
        warnCountRounded:SetPos( screenScaleW(10), screenScaleH(10) )
        warnCountRounded:SetSize( screenScaleW(80), screenScaleH(15) )
        warnCountRounded.Paint = function( self, w, h )
            draw.RoundedBox( 50, 0, 0, w, h, Color( 27, 26, 40))
        end

        local warnCount = vgui.Create( "DLabel", warnCountRounded )
        warnCount:SetPos( screenScaleW(0), screenScaleH(0) )
        warnCount:SetSize( warnCountRounded:GetWide(), warnCountRounded:GetTall() )
        warnCount:SetText( "You have " .. #ENFORCER.MyWarnings .. " warns" )
        warnCount:SetFont( "ENFORCER.WarnFrame.Font.26" )
        warnCount:SetContentAlignment( 5 )
        warnCount:SetColor( Color( 255, 255, 255 ) )

        local warnList = vgui.Create( "DPanelList", myWarns )
        warnList:SetPos( screenScaleW(10), screenScaleH(30) )
        warnList:SetSize( screenScaleW(frameX-60), screenScaleH(220) )
        warnList:SetSpacing( 5 )
        warnList:EnableHorizontal( false )
        warnList:EnableVerticalScrollbar( true )


        local warns = {}

        local tempWarns = ENFORCER.MyWarnings

        -- sort tempWarns by date
        table.sort(tempWarns, function(a, b)
            return a.time > b.time
        end)

        for k,v in pairs(tempWarns) do
            local dateTable = os.date("*t", v.time)
            print(dateTable)
            local hour = dateTable.hour
            local minute = dateTable.min
            local second = dateTable.sec
            local ampm = "AM"
            if hour >= 12 then
                ampm = "PM"
            end
            if hour > 12 then
                hour = hour - 12
            end
            local date = string.format("%02d/%02d/%04d %02d:%02d:%02d %s", dateTable.month, dateTable.day, dateTable.year, hour, minute, second, ampm)

            warns[k] = {
                reason = v.reason,
                admin = v.admin,
                date = date,
            }
        end


        for k, v in ipairs(warns) do
            local warn = vgui.Create( "DPanel" )
            warn:SetSize( warnList:GetWide(), screenScaleH(40) )
            local admin = v.admin

            -- if admin is a steamid 64bit so like 769 then lets steamworks.RequestPlayerInfo their steamname to the admin var
            if tonumber(admin) then
                admin = "Loading..."
                steamworks.RequestPlayerInfo(v.admin, function(name)
                    
                    admin = name
                end)
            end
            warn.Paint = function( self, w, h )
                
                draw.RoundedBox( 0, 0, 0, w, h, Color( 27, 26, 40))
                draw.SimpleText( "Reason: "..v.reason, "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(5), Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
                draw.SimpleText( "Admin: "..admin, "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(15), Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
                draw.SimpleText( "Date: "..v.date, "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(25), Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

                -- Add a rounded box if the warn is less than 3 days old
                local currentDate = os.date("*t") -- Get current date as a table
                local warnDate = v.date

                -- Convert warnDate from string to table
                local month, day, year = warnDate:match("(%d+)/(%d+)/(%d+)")
                warnDate = {year = year, month = month, day = day}

                local diff = os.difftime(os.time(currentDate), os.time(warnDate))
                local days = math.floor(diff / (24 * 60 * 60))
                if days < 3 then
                    local boxWidth = screenScaleW(25)
                    local boxX = w - boxWidth - screenScaleW(5)
                    local boxY = screenScaleH(10)
                    draw.RoundedBox( 30, boxX, boxY, boxWidth, screenScaleH(20), Color( 246, 69, 69))

                    local text = "NEW"
                    surface.SetFont("ENFORCER.WarnFrame.Font.20")
                    local textWidth, textHeight = surface.GetTextSize(text)
                    local textX = boxX + (boxWidth*0.73) - (textWidth/2)
                    local textY = boxY + (screenScaleH(20)/2) - (textHeight/2)
                    draw.SimpleText( text, "ENFORCER.WarnFrame.Font.20", textX, textY, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
                end
            end
            warnList:AddItem( warn )
        end
    end

    -- Create a DPanel to act as the loading icon
    local loadingIcon = vgui.Create("DPanel", myWarns)
    loadingIcon:SetSize(50, 50) -- Set the size of the loading icon
    loadingIcon:Center() -- Center the loading icon in the parent panel
    loadingIcon.progress = 0 -- Initialize progress

    loadingIcon.Paint = function(self, w, h)
        -- Draw the gradient loading icon bar
        local gradient = Material("vgui/gradient_up")
        surface.SetDrawColor(212, 85, 53) -- Set the draw color to the start color
        surface.SetMaterial(gradient)
        surface.DrawTexturedRect(0, h * (1 - self.progress), w, h * self.progress) -- Draw the gradient rectangle

    end


    loadingIcon.Think = function(self)
        -- Update the progress
        self.progress = (self.progress + 0.01) % 2
    end

    ENFORCER.RetrieveWarnings(function()
        loadingIcon:Remove()
        myWarns.populateContent()
    end)

    -- If the warnings are not retrieved in 5 seconds then remove the loading icon and populate the content
    timer.Simple(5, function()
        if loadingIcon and loadingIcon:IsValid() then
            loadingIcon:Remove()
            myWarns.populateContent()
        end
    end)

    myBans.populateContent = function()
        local banCountRounded = vgui.Create( "DPanel", myBans )
        banCountRounded:SetPos( screenScaleW(10), screenScaleH(10) )
        banCountRounded:SetSize( screenScaleW(80), screenScaleH(15) )
        banCountRounded.Paint = function( self, w, h )
            draw.RoundedBox( 50, 0, 0, w, h, Color( 27, 26, 40))
        end

        local banCount = vgui.Create( "DLabel", banCountRounded )
        banCount:SetPos( screenScaleW(0), screenScaleH(0) )
        banCount:SetSize( banCountRounded:GetWide(), banCountRounded:GetTall() )
        banCount:SetText( "You have " .. #ENFORCER.MyBans .. " bans" )
        banCount:SetFont( "ENFORCER.WarnFrame.Font.26" )
        banCount:SetContentAlignment( 5 )
        banCount:SetColor( Color( 255, 255, 255 ) )

        local banList = vgui.Create( "DPanelList", myBans )
        banList:SetPos( screenScaleW(10), screenScaleH(30) )
        banList:SetSize( screenScaleW(frameX-60), screenScaleH(220) )
        banList:SetSpacing( 5 )
        banList:EnableHorizontal( false )
        banList:EnableVerticalScrollbar( true )


        local bans = {}

        local tempBans = ENFORCER.MyBans

        -- sort tempBans by date
        table.sort(tempBans, function(a, b)
            return a.time > b.time
        end)

        for k,v in pairs(tempBans) do
            local dateTable = os.date("*t", v.time)
            print(dateTable)
            local hour = dateTable.hour
            local minute = dateTable.min
            local second = dateTable.sec
            local ampm = "AM"
            if hour >= 12 then
                ampm = "PM"
            end
            if hour > 12 then
                hour = hour - 12
            end
            local date = string.format("%02d/%02d/%04d %02d:%02d:%02d %s", dateTable.month, dateTable.day, dateTable.year, hour, minute, second, ampm)

            bans[k] = {
                reason = v.reason,
                admin = v.admin,
                date = date,
                unban_reason = v.unban_reason or "N/A",
                unbantime = v.unban,
            }
        end


        for k, v in ipairs(bans) do
            local ban = vgui.Create( "DPanel" )
            ban:SetSize( banList:GetWide(), screenScaleH(50) )
            local steamName = "N/A"
            if v.admin == "Console" then
                steamName = "Console"
            else
                steamworks.RequestPlayerInfo(v.admin, function(name)
                    steamName = name .. " | " .. v.admin 
                end)
            end
            ban.Paint = function( self, w, h )
                draw.RoundedBox( 0, 0, 0, w, h, Color( 27, 26, 40))
                draw.SimpleText( "Reason: "..v.reason, "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(5), Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
                draw.SimpleText( "Admin: "..steamName, "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(15), Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
                draw.SimpleText( "Date: "..v.date, "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(25), Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
                draw.SimpleText( "Unban Reason: "..v.unban_reason, "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(35), Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

                -- Add a rounded box if the warn is less than 3 days old
                local currentDate = os.date("*t") -- Get current date as a table
                local banDate = os.date("*t", v.unbantime) -- Convert Unix time to a table

                local diff = os.difftime(os.time(currentDate), os.time(banDate))
                local days = math.floor(diff / (24 * 60 * 60))
                if days < 3 then
                    local boxWidth = screenScaleW(25)
                    local boxX = w - boxWidth - screenScaleW(5)
                    local boxY = screenScaleH(10)
                    draw.RoundedBox(30, boxX, boxY, boxWidth, screenScaleH(20), Color(246, 69, 69))

                    local text = "NEW"
                    surface.SetFont("ENFORCER.WarnFrame.Font.20")
                    local textWidth, textHeight = surface.GetTextSize(text)
                    local textX = boxX + (boxWidth * 0.73) - (textWidth / 2)
                    local textY = boxY + (screenScaleH(20) / 2) - (textHeight / 2)
                    draw.SimpleText(text, "ENFORCER.WarnFrame.Font.20", textX, textY, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                end
            end
            banList:AddItem( ban )
        end
    end

    -- Create a DPanel to act as the loading icon
    local loadingIcon = vgui.Create("DPanel", myBans)
    loadingIcon:SetSize(50, 50) -- Set the size of the loading icon
    loadingIcon:Center() -- Center the loading icon in the parent panel
    loadingIcon.progress = 0 -- Initialize progress

    loadingIcon.Paint = function(self, w, h)
        -- Draw the gradient loading icon bar
        local gradient = Material("vgui/gradient_up")
        surface.SetDrawColor(212, 85, 53) -- Set the draw color to the start color
        surface.SetMaterial(gradient)
        surface.DrawTexturedRect(0, h * (1 - self.progress), w, h * self.progress) -- Draw the gradient rectangle

    end


    loadingIcon.Think = function(self)
        -- Update the progress
        self.progress = (self.progress + 0.01) % 2
    end

    ENFORCER.RetrieveBans(function()
        loadingIcon:Remove()
        myBans.populateContent()
    end)


    -- Database
    -- ENFORCER.GetAllWarnings
    database.populateContent = function()
        if not LocalPlayer():HasPermission("view_warning_db") then return end

        isDBPopulated = true

        local currentPage = 1
        local pageSize = 100
        local totalPages = math.ceil(#ENFORCER.AllWarnings / pageSize)



        local warnList = vgui.Create( "DPanelList", database )
        warnList:SetPos( screenScaleW(10), screenScaleH(15) )
        warnList:SetSize( screenScaleW(frameX-60), screenScaleH(220) )
        warnList:SetSpacing( 5 )
        warnList:EnableHorizontal( false )
        warnList:EnableVerticalScrollbar( true )
        
        local warns = {}

        for k,v in pairs(ENFORCER.AllWarnings) do
            local dateTable = os.date("*t", v.time)
            PrintTable(dateTable)
            local hour = dateTable.hour
            local minute = dateTable.min
            local second = dateTable.sec
            local ampm = "AM"
            if hour >= 12 then
                ampm = "PM"
            end
            if hour > 12 then
                hour = hour - 12
            end
            local date = string.format("%02d/%02d/%04d %02d:%02d:%02d %s", dateTable.month, dateTable.day, dateTable.year, hour, minute, second, ampm)
            print(date)
            warns[k] = {
                name = v.name,
                steamid = v.steamid,
                reason = v.reason,
                admin = v.admin,
                date = date,
                id = v.id,
                evidence = v.evidence,
            }
        end

        local function addWarn(warnData)
            local warn = vgui.Create("DPanel")
            warn:SetSize(warnList:GetWide(), screenScaleH(70)) -- Increase the height to accommodate the buttons
            local steamName = "Loading..."
            steamworks.RequestPlayerInfo(warnData.steamid, function(name)
                steamName = name
            end)
            local adminName = "Loading..."
            steamworks.RequestPlayerInfo(warnData.admin, function(name)
                adminName = name .. " | " .. warnData.admin
            end)
            if adminName == " | " .. warnData.admin then
                adminName = warnData.admin
            end
            warn.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(27, 26, 40))
                draw.SimpleText("Steam Name: " .. steamName, "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(5), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                draw.SimpleText("SteamID: "..warnData.steamid, "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(15), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                draw.SimpleText("Reason: "..warnData.reason, "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(25), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                draw.SimpleText("Admin: "..adminName, "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(35), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                draw.SimpleText(warnData.date and "Date: "..warnData.date or "Date: Nil", "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(45), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            end

            -- Create the buttons
            local buttonWidth = screenScaleW(40)
            local buttonHeight = screenScaleH(10)
            local buttonSpacing = screenScaleW(2)
            local buttonY = screenScaleH(58) -- Position the buttons at the bottom of the panel

            local deleteButton = vgui.Create("DButton", warn)
            deleteButton:SetPos(buttonSpacing, buttonY)
            deleteButton:SetSize(buttonWidth, buttonHeight)
            deleteButton:SetText("Delete")
            deleteButton:SetFont("ENFORCER.WarnFrame.Font.20")
            deleteButton:SetTextColor(Color(255, 255, 255))
            deleteButton.DoClick = function()
                if not LocalPlayer():HasPermission("delete_warn") then return end
                ENFORCER.AreYouSure("Delete warning: " .. warnData.id, function(confirmed)
                    if confirmed then
                        net.Start("ENFORCER::WARN::DeleteWarn")
                            net.WriteUInt(warnData.id, 32)
                            net.WriteString(warnData.steamid)
                        net.SendToServer()
                        timer.Simple(0.5, function()
                            ENFORCER.OpenWarnFrame()
                        end)
                    end
                end)
            end

            local viewButton = vgui.Create("DButton", warn)
            viewButton:SetPos(2 * buttonSpacing + buttonWidth, buttonY) -- Position the button next to the delete button
            viewButton:SetSize(buttonWidth, buttonHeight)
            viewButton:SetText("View")
            viewButton:SetFont("ENFORCER.WarnFrame.Font.20")
            viewButton:SetTextColor(Color(255, 255, 255))
            viewButton.DoClick = function()
                ENFORCER.ViewData({
                    title = "Warning #" .. warnData.id,
                    content = {
                        "Steam Name: " .. steamName,
                        "SteamID: " .. warnData.steamid,
                        "Reason: " .. warnData.reason,
                        "Admin: " .. warnData.admin,
                        "Date: " .. (warnData.date or "Nil"),
                    },
                    link = {
                        text = warnData.evidence,
                        url = warnData.evidence,
                    },
                })
            end

            local editButton = vgui.Create("DButton", warn)
            editButton:SetPos(3 * buttonSpacing + 2 * buttonWidth, buttonY) -- Position the button next to the view button
            editButton:SetSize(buttonWidth, buttonHeight)
            editButton:SetText("Edit")
            editButton:SetFont("ENFORCER.WarnFrame.Font.20")
            editButton:SetTextColor(Color(255, 255, 255))
            editButton.DoClick = function()
                ENFORCER.EditWarning(warnData)
            end

            -- Copy steamid
            local copyButton = vgui.Create("DButton", warn)
            copyButton:SetPos(4 * buttonSpacing + 3 * buttonWidth, buttonY) -- Position the button next to the edit button
            copyButton:SetSize(buttonWidth, buttonHeight)
            copyButton:SetText("Copy SteamID")
            copyButton:SetFont("ENFORCER.WarnFrame.Font.20")
            copyButton:SetTextColor(Color(255, 255, 255))
            copyButton.DoClick = function()
                SetClipboardText(warnData.steamid)
                surface.PlaySound("buttons/button15.wav")
            end

            -- copy admin steamid
            local copyAdminButton = vgui.Create("DButton", warn)
            copyAdminButton:SetPos(5 * buttonSpacing + 4 * buttonWidth, buttonY) -- Position the button next to the edit button
            copyAdminButton:SetSize(buttonWidth + 10, buttonHeight)
            copyAdminButton:SetText("Copy Admin SID")
            copyAdminButton:SetFont("ENFORCER.WarnFrame.Font.20")
            copyAdminButton:SetTextColor(Color(255, 255, 255))
            copyAdminButton.DoClick = function()
                SetClipboardText(warnData.admin)
                surface.PlaySound("buttons/button15.wav")
            end

            local function hoverSound(button)
                button.OnCursorEntered = function()
                    surface.PlaySound("UI/buttonrollover.wav")
                end
            end
            -- Paint the buttons
            local function paintButton(button, color)
                button.Paint = function(self, w, h)
                    if self:IsHovered() then
                        local hovCol = Color(color.r + 20, color.g + 20, color.b + 20)
                        draw.RoundedBox(0, 0, 0, w, h, hovCol) -- Change color when hovered
                    else
                        draw.RoundedBox(0, 0, 0, w, h, color)
                    end
                end
            end

            paintButton(deleteButton, Color(135, 49, 49))
            paintButton(viewButton, Color(55, 134, 146))
            paintButton(editButton, Color(171, 100, 59))
            paintButton(copyButton, Color(184, 164, 77))
            paintButton(copyAdminButton, Color(184, 164, 77))

            hoverSound(deleteButton)
            hoverSound(viewButton)
            hoverSound(editButton)
            hoverSound(copyButton)
            hoverSound(copyAdminButton)

            warnList:AddItem(warn)
        end

        local function displayPage(page, warnings)
            currentPage = page
            -- Clear the current list
            warnList:Clear()

            warnings = warnings or warns -- Use the provided list of warnings or the default list if none is provided

            local startIndex = (page - 1) * pageSize + 1
            local endIndex = math.min(page * pageSize, #warnings)

            for i = startIndex, endIndex do
                local warning = warnings[i]
                addWarn(warning)
            end
        end

        local pageButtons = {}

        local pageButtonWidth = 40
        local pageButtonHeight = 30
        local pageButtonSpacing = 5
        local pageButtonX = 0
        local pageButtonY = 0

        -- Create a container for the page buttons
        local pageButtonContainer = vgui.Create("DHorizontalScroller", database)
        pageButtonContainer:SetPos(screenScaleW(0), screenScaleH(90)) -- Adjust the position to prevent overlap with the warnings
        pageButtonContainer:SetSize(screenScaleW(100), screenScaleH(50)) -- Adjust the size to fit the screen
        local containerWidth = screenScaleW(100)
        local containerHeight = screenScaleH(20)
        pageButtonContainer:SetSize(containerWidth, containerHeight) -- Set the size of the container
        local databaseWidth, databaseHeight = database:GetSize()
        local containerX = (databaseWidth - containerWidth) / 2 -- Center the container horizontally
        local containerY = databaseHeight - containerHeight -- Position the container at the bottom
        pageButtonContainer:SetPos(containerX, containerY)


        -- Create the left and right buttons
        local leftButton = vgui.Create("DButton", database)
        local rightButton = vgui.Create("DButton", database)
        local leftButtonText = "<"
        local rightButtonText = ">"

        -- Set the size of the buttons
        leftButton:SetSize(screenScaleW(10), screenScaleH(10))
        rightButton:SetSize(screenScaleW(10), screenScaleH(10))

        -- Set the text of the buttons
        leftButton:SetText(leftButtonText)
        rightButton:SetText(rightButtonText)

        -- Set the font of the buttons
        leftButton:SetFont("ENFORCER.WarnFrame.Font.20")
        rightButton:SetFont("ENFORCER.WarnFrame.Font.20")

        -- Set the text color of the buttons
        leftButton:SetTextColor(Color(255, 255, 255))
        rightButton:SetTextColor(Color(255, 255, 255))

        -- Position the buttons
        local leftButtonX = containerX - screenScaleW(10) -- Position the left button to the left of the container
        local leftButtonY = containerY + (containerHeight - screenScaleH(10)) / 2 -- Center the left button vertically
        local rightButtonX = containerX + containerWidth -- Position the right button to the right of the container
        local rightButtonY = leftButtonY -- Center the right button vertically
        leftButton:SetPos(leftButtonX, leftButtonY)
        rightButton:SetPos(rightButtonX, rightButtonY)

        -- Paint the buttons
        local function paintButton(button, color)
            button.Paint = function(self, w, h)
                if self:IsHovered() then
                    draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 60)) -- Change color when hovered
                else
                    draw.RoundedBox(0, 0, 0, w, h, color)
                end
            end
        end

        paintButton(leftButton, Color(27, 26, 40))
        paintButton(rightButton, Color(27, 26, 40))

        -- button functionality
        leftButton.DoClick = function()
            if currentPage > 1 then
                displayPage(currentPage - 1)
                pageButtonContainer:ScrollToChild(pageButtons[currentPage - 1])
            end
        end

        rightButton.DoClick = function()
            if currentPage < totalPages then
                displayPage(currentPage + 1)
                pageButtonContainer:ScrollToChild(pageButtons[currentPage])
            end
        end



        for i = 1, totalPages do
            local pageButton = vgui.Create("DButton")
            local buttonText = tostring(i)
            surface.SetFont("ENFORCER.WarnFrame.Font.20")
            local textWidth, textHeight = surface.GetTextSize(buttonText)
            pageButton:SetSize(textWidth + screenScaleW(5), screenScaleH(10)) -- Set the size of the button based on the text width
            pageButton:SetText("") -- Set the text of the button to the page number
            pageButton.ID = i
            pageButton.Paint = function( self, w, h )
                if self:IsHovered() then
                    draw.RoundedBox( 0, 0, 0, w, h, Color( 40, 40, 60)) -- Change color when hovered
                else
                    draw.RoundedBox( 0, 0, 0, w, h, Color( 27, 26, 40))
                end
                if self.ID == currentPage then
                    draw.RoundedBox( 0, 0, 0, w, h, Color( 32, 32, 74))
                end
                draw.SimpleText(buttonText, "ENFORCER.WarnFrame.Font.20", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            pageButton.DoClick = function()
                displayPage(i)
            end

            pageButtons[i] = pageButton

            pageButtonX = pageButtonX + pageButtonWidth + pageButtonSpacing -- Increment buttonX for the next button

            pageButtonContainer:AddPanel(pageButton)
        end
        local searchButton = vgui.Create("DButton", database)

        -- Create the text entry field
        local searchBox = vgui.Create("DTextEntry", database)
        searchBox:SetPos(screenScaleW(10), screenScaleH(3)) -- Position the text entry field at the top of the panel
        searchBox:SetSize(screenScaleW(200), screenScaleH(10)) -- Set the size of the text entry field
        searchBox:SetPlaceholderText("SteamID64: \"76561198182303579\"") -- Set the placeholder text
        searchBox:SetFont("ENFORCER.WarnFrame.Font.20") -- Set the font
        searchBox.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(35, 35, 46))
            self:DrawTextEntryText(Color(255, 255, 255), Color(255, 255, 255), Color(255, 255, 255))
            -- Draw the placeholder text
            if self:GetValue() == "" then
                draw.SimpleText(self:GetPlaceholderText(), "ENFORCER.WarnFrame.Font.20", 5, 0, Color(79, 77, 77), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            end
        end
        searchBox.OnEnter = function()
            searchButton:DoClick()
        end
        searchButton:SetPos(screenScaleW(212), screenScaleH(3)) -- Position the button next to the text entry field
        searchButton:SetSize(screenScaleW(50), screenScaleH(10)) -- Set the size of the button
        searchButton:SetText("SEARCH") -- Set the text of the button
        searchButton:SetFont("ENFORCER.WarnFrame.Font.20") -- Set the font
        searchButton:SetTextColor(Color(255, 255, 255)) -- Set the text color
        searchButton.DoClick = function()
            local query = searchBox:GetValue() -- Get the text in the text entry field

            -- Filter the warnings based on the query
            local filteredWarnings = {}
            for i, warning in ipairs(warns) do
                if string.find(warning.steamid:lower(), query:lower()) or string.find(warning.steamid:lower(), query:lower()) or string.find(warning.reason:lower(), query:lower()) or string.find(warning.admin:lower(), query:lower()) then
                    table.insert(filteredWarnings, warning)
                end
            end

            -- Display the filtered warnings
            displayPage(1, filteredWarnings)
        end
        searchButton.Paint = function(self, w, h)
            if self:IsHovered() then
                draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 60)) -- Change color when hovered
            else
                draw.RoundedBox(0, 0, 0, w, h, Color(27, 26, 40))
            end
        end

        displayPage(1)

        --[[for k, v in ipairs(warns) do
            local warn = vgui.Create( "DPanel" )
            warn:SetSize( warnList:GetWide(), screenScaleH(40) )
            warn.Paint = function( self, w, h )
                draw.RoundedBox( 0, 0, 0, w, h, Color( 27, 26, 40))
                draw.SimpleText( "Name: Example Name", "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(5), Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
                draw.SimpleText( "SteamID: "..v.steamid, "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(15), Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
                draw.SimpleText( "Reason: "..v.reason, "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(25), Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
                draw.SimpleText( "Admin: "..v.admin, "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(35), Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
                draw.SimpleText( "Date: "..v.date, "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(45), Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
            end
            warnList:AddItem( warn )
        end]]
    end

    -- Create a DPanel to act as the loading icon
    loadingIcon_DB:SetSize(50, 50) -- Set the size of the loading icon
    loadingIcon_DB:Center() -- Center the loading icon in the parent panel
    loadingIcon_DB.progress = 0 -- Initialize progress

    loadingIcon_DB.Paint = function(self, w, h)
        -- Draw the gradient loading icon bar
        local gradient = Material("vgui/gradient_up")
        surface.SetDrawColor(212, 85, 53) -- Set the draw color to the start color
        surface.SetMaterial(gradient)
        surface.DrawTexturedRect(0, h * (1 - self.progress), w, h * self.progress) -- Draw the gradient rectangle

    end

    loadingIcon_DB.Think = function(self)
        -- Update the progress
        self.progress = (self.progress + 0.01) % 2
    end

    --[[ENFORCER.RetrieveAllWarnings(function()
        loadingIcon_DB:Remove()
        database.populateContent()
    end)]]


    -- Bans Database
    -- ENFORCER.RetrieveAllBans
    banDatabase.populateContent = function()
        if not LocalPlayer():HasPermission("view_ban_db") then return end

        isBanDBPopulated = true

        local currentPage = 1
        local pageSize = 100
        local totalPages = math.ceil(#ENFORCER.AllBans / pageSize)



        local banList = vgui.Create( "DPanelList", banDatabase )
        banList:SetPos( screenScaleW(10), screenScaleH(15) )
        banList:SetSize( screenScaleW(frameX-60), screenScaleH(220) )
        banList:SetSpacing( 5 )
        banList:EnableHorizontal( false )
        banList:EnableVerticalScrollbar( true )

        local bans = {}

        for k,v in pairs(ENFORCER.AllBans) do
            local dateTable = os.date("*t", v.time)
            local hour = dateTable.hour
            local minute = dateTable.min
            local second = dateTable.sec
            local ampm = "AM"
            if hour >= 12 then
                ampm = "PM"
            end
            if hour > 12 then
                hour = hour - 12
            end
            local date = string.format("%02d/%02d/%04d %02d:%02d:%02d %s", dateTable.month, dateTable.day, dateTable.year, hour, minute, second, ampm)

            bans[k] = {
                name = v.name,
                steamid = v.steamid,
                reason = v.reason,
                admin = v.admin,
                date = date,
                id = v.id,
                unban_reason = v.unban_reason or "N/A",
                time = v.time,
                unban = v.unban,
                evidence = v.evidence,
            }
        end

        local function addBan(banData)
            local ban = vgui.Create("DPanel")
            ban:SetSize(banList:GetWide(), screenScaleH(70)) -- Increase the height to accommodate the buttons
            local steamName = "Loading..."
            steamworks.RequestPlayerInfo(banData.steamid, function(name)
                steamName = name
            end)
            local activeBan = banData.id and false or true
            ban.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(27, 26, 40))
                draw.SimpleText("Steam Name: " .. steamName, "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(5), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                draw.SimpleText("SteamID: "..banData.steamid, "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(15), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                draw.SimpleText("Reason: "..banData.reason, "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(25), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                draw.SimpleText("Admin: "..banData.admin, "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(35), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                draw.SimpleText(banData.date and "Date: "..banData.date or "Date: Nil", "ENFORCER.WarnFrame.Font.20", screenScaleW(5), screenScaleH(45), Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

                -- if ban is active or not lets indicate in a rounded box in the top right
                local boxWidth = screenScaleW(25)
                local boxX = w - boxWidth - screenScaleW(5)
                local boxY = screenScaleH(10)

                if activeBan then
                    draw.RoundedBox(30, boxX, boxY, boxWidth, screenScaleH(20), Color(214, 40, 40))
                else
                    draw.RoundedBox(30, boxX, boxY, boxWidth, screenScaleH(20), Color(69, 246, 69))
                end

                local text = activeBan and "ACTIVE" or "HISTORY"
                surface.SetFont("ENFORCER.WarnFrame.Font.20")
                local textWidth, textHeight = surface.GetTextSize(text)
                local textX = boxX + (boxWidth * 0.79) - (textWidth / 2)
                local textY = boxY + (screenScaleH(20) / 2) - (textHeight / 2)
                draw.SimpleText(text, "ENFORCER.WarnFrame.Font.20", textX, textY, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

            end

            -- Create the buttons
            local buttonWidth = screenScaleW(40)
            local buttonHeight = screenScaleH(10)
            local buttonSpacing = screenScaleW(2)
            local buttonY = screenScaleH(58) -- Position the buttons at the bottom of the panel

            local deleteButton = vgui.Create("DButton", ban)
            deleteButton:SetPos(buttonSpacing, buttonY)
            deleteButton:SetSize(buttonWidth, buttonHeight)
            deleteButton:SetText("Delete")
            deleteButton:SetFont("ENFORCER.WarnFrame.Font.20")
            deleteButton:SetTextColor(Color(255, 255, 255))

            deleteButton.DoClick = function()
                if banData.id then return end -- Means ban is history not active
                if not LocalPlayer():HasPermission("delete_ban") then return end
                ENFORCER.AreYouSure("Delete ban: " .. banData.steamid, function(confirmed)
                    if confirmed then
                        net.Start("ENFORCER::BAN::REMOVE")
                            net.WriteString(warnData.steamid)
                        net.SendToServer()
                        timer.Simple(0.5, function()
                            ENFORCER.OpenWarnFrame()
                        end)
                    end
                end)
            end

            local viewButton = vgui.Create("DButton", ban)
            viewButton:SetPos(2 * buttonSpacing + buttonWidth, buttonY) -- Position the button next to the delete button
            viewButton:SetSize(buttonWidth, buttonHeight)
            viewButton:SetText("View")
            viewButton:SetFont("ENFORCER.WarnFrame.Font.20")
            viewButton:SetTextColor(Color(255, 255, 255))
            viewButton.DoClick = function()
                local unbanTime = "Never"
                if banData.unban and banData.unban ~= 0 then
                    local dateTable = os.date("*t", banData.unban)
                    local hour = dateTable.hour
                    local minute = dateTable.min
                    local second = dateTable.sec
                    local ampm = "AM"
                    if hour >= 12 then
                        ampm = "PM"
                    end
                    if hour > 12 then
                        hour = hour - 12
                    end
                    unbanTime = string.format("%02d/%02d/%04d %02d:%02d:%02d %s", dateTable.month, dateTable.day, dateTable.year, hour, minute, second, ampm)
                end
                ENFORCER.ViewData({
                    title = "Ban #" .. banData.id,
                    content = {
                        "Steam Name: " .. steamName,
                        "SteamID: " .. banData.steamid,
                        "Reason: " .. banData.reason,
                        "Admin: " .. banData.admin,
                        "Date: " .. (banData.date or "Nil"),
                        "Unban Reason: " .. banData.unban_reason,
                        "Unban Time: " .. unbanTime,
                    },
                    link = {
                        text = banData.evidence,
                        url = banData.evidence,
                    },
                })
            end

            local editButton = vgui.Create("DButton", ban)
            editButton:SetPos(3 * buttonSpacing + 2 * buttonWidth, buttonY) -- Position the button next to the view button
            editButton:SetSize(buttonWidth, buttonHeight)
            editButton:SetText("Edit")
            editButton:SetFont("ENFORCER.WarnFrame.Font.20")
            editButton:SetTextColor(Color(255, 255, 255))
            editButton.DoClick = function()
                -- Edit the ban
            end

            -- copy steamid
            local copyButton = vgui.Create("DButton", ban)
            copyButton:SetPos(4 * buttonSpacing + 3 * buttonWidth, buttonY) -- Position the button next to the edit button
            copyButton:SetSize(buttonWidth, buttonHeight)
            copyButton:SetText("Copy SteamID")
            copyButton:SetFont("ENFORCER.WarnFrame.Font.20")
            copyButton:SetTextColor(Color(255, 255, 255))
            copyButton.DoClick = function()
                SetClipboardText(banData.steamid)
                surface.PlaySound("buttons/button15.wav")
            end

            -- copy admin steamid
            local copyAdminButton = vgui.Create("DButton", ban)
            copyAdminButton:SetPos(5 * buttonSpacing + 4 * buttonWidth, buttonY) -- Position the button next to the edit button
            copyAdminButton:SetSize(buttonWidth + 10, buttonHeight)
            copyAdminButton:SetText("Copy Admin SID")
            copyAdminButton:SetFont("ENFORCER.WarnFrame.Font.20")
            copyAdminButton:SetTextColor(Color(255, 255, 255))
            copyAdminButton.DoClick = function()
                SetClipboardText(banData.admin)
                surface.PlaySound("buttons/button15.wav")
            end

            local function hoverSound(button)
                button.OnCursorEntered = function()
                    surface.PlaySound("UI/buttonrollover.wav")
                end
            end

            -- Paint the buttons
            local function paintButton(button, color)
                button.Paint = function(self, w, h)
                    if self:IsHovered() then
                        local hovCol = Color(color.r + 20, color.g + 20, color.b + 20)
                        draw.RoundedBox(0, 0, 0, w, h, hovCol) -- Change color when hovered
                    else
                        draw.RoundedBox(0, 0, 0, w, h, color)
                    end
                end
            end

            paintButton(deleteButton, banData.id and Color(135, 135, 135) or Color(135, 49, 49))
            paintButton(viewButton, Color(55, 134, 146))
            paintButton(editButton, Color(171, 100, 59))
            paintButton(copyButton, Color(184, 164, 77))
            paintButton(copyAdminButton, Color(184, 164, 77))

            hoverSound(deleteButton)
            hoverSound(viewButton)
            hoverSound(editButton)
            hoverSound(copyButton)
            hoverSound(copyAdminButton)

            banList:AddItem(ban)
        end

        local function displayPage(page, pBans)
            currentPage = page
            -- Clear the current list
            banList:Clear()

            pBans = pBans or bans -- Use the provided list of bans or the default list if none is provided

            local startIndex = (page - 1) * pageSize + 1
            local endIndex = math.min(page * pageSize, #pBans)

            for i = startIndex, endIndex do
                local ban = pBans[i]
                addBan(ban)
            end
        end

        local pageButtons = {}

        local pageButtonWidth = 40
        local pageButtonHeight = 30
        local pageButtonSpacing = 5
        local pageButtonX = 0
        local pageButtonY = 0

        -- Create a container for the page buttons
        local pageButtonContainer = vgui.Create("DHorizontalScroller", banDatabase)
        pageButtonContainer:SetPos(screenScaleW(0), screenScaleH(90)) -- Adjust the position to prevent overlap with the bans
        pageButtonContainer:SetSize(screenScaleW(100), screenScaleH(50)) -- Adjust the size to fit the screen
        local containerWidth = screenScaleW(100)
        local containerHeight = screenScaleH(20)
        pageButtonContainer:SetSize(containerWidth, containerHeight) -- Set the size of the container
        local banDatabaseWidth, banDatabaseHeight = banDatabase:GetSize()
        local containerX = (banDatabaseWidth - containerWidth) / 2 -- Center the container horizontally
        local containerY = banDatabaseHeight - containerHeight -- Position the container at the bottom
        pageButtonContainer:SetPos(containerX, containerY)


        -- Create the left and right buttons
        local leftButton = vgui.Create("DButton", banDatabase)
        local rightButton = vgui.Create("DButton", banDatabase)
        local leftButtonText = "<"
        local rightButtonText = ">"
        -- Set the size of the buttons
        leftButton:SetSize(screenScaleW(10), screenScaleH(10))
        rightButton:SetSize(screenScaleW(10), screenScaleH(10))
        -- Set the text of the buttons
        leftButton:SetText(leftButtonText)
        rightButton:SetText(rightButtonText)
        -- Set the font of the buttons
        leftButton:SetFont("ENFORCER.WarnFrame.Font.20")
        rightButton:SetFont("ENFORCER.WarnFrame.Font.20")
        -- Set the text color of the buttons
        leftButton:SetTextColor(Color(255, 255, 255))
        rightButton:SetTextColor(Color(255, 255, 255))
        -- Position the buttons
        local leftButtonX = containerX - screenScaleW(10) -- Position the left button to the left of the container
        local leftButtonY = containerY + (containerHeight - screenScaleH(10)) / 2 -- Center the left button vertically
        local rightButtonX = containerX + containerWidth -- Position the right button to the right of the container
        local rightButtonY = leftButtonY -- Center the right button vertically
        leftButton:SetPos(leftButtonX, leftButtonY)
        rightButton:SetPos(rightButtonX, rightButtonY)
        -- Paint the buttons
        local function paintButton(button, color)
            button.Paint = function(self, w, h)
                if self:IsHovered() then
                    draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 60)) -- Change color when hovered
                else
                    draw.RoundedBox(0, 0, 0, w, h, color)
                end
            end
        end
        paintButton(leftButton, Color(27, 26, 40))
        paintButton(rightButton, Color(27, 26, 40))
        -- button functionality
        leftButton.DoClick = function()
            if currentPage > 1 then
                displayPage(currentPage - 1)
                pageButtonContainer:ScrollToChild(pageButtons[currentPage - 1])
            end
        end
        rightButton.DoClick = function()
            if currentPage < totalPages then
                displayPage(currentPage + 1)
                pageButtonContainer:ScrollToChild(pageButtons[currentPage])
            end
        end

        for i = 1, totalPages do
            local pageButton = vgui.Create("DButton")
            local buttonText = tostring(i)
            surface.SetFont("ENFORCER.WarnFrame.Font.20")
            local textWidth, textHeight = surface.GetTextSize(buttonText)
            pageButton:SetSize(textWidth + screenScaleW(5), screenScaleH(10)) -- Set the size of the button based on the text width
            pageButton:SetText("") -- Set the text of the button to the page number
            pageButton.ID = i
            pageButton.Paint = function( self, w, h )
                if self:IsHovered() then
                    draw.RoundedBox( 0, 0, 0, w, h, Color( 40, 40, 60)) -- Change color when hovered
                else
                    draw.RoundedBox( 0, 0, 0, w, h, Color( 27, 26, 40))
                end
                if self.ID == currentPage then
                    draw.RoundedBox( 0, 0, 0, w, h, Color( 32, 32, 74))
                end
                draw.SimpleText(buttonText, "ENFORCER.WarnFrame.Font.20", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            pageButton.DoClick = function()
                displayPage(i)
            end

            pageButtons[i] = pageButton

            pageButtonX = pageButtonX + pageButtonWidth + pageButtonSpacing -- Increment buttonX for the next button

            pageButtonContainer:AddPanel(pageButton)
        end

        local searchButton = vgui.Create("DButton", banDatabase)

        -- Create the text entry field
        local searchBox = vgui.Create("DTextEntry", banDatabase)
        searchBox:SetPos(screenScaleW(10), screenScaleH(3)) -- Position the text entry field at the top of the panel
        searchBox:SetSize(screenScaleW(200), screenScaleH(10)) -- Set the size of the text entry field
        searchBox:SetPlaceholderText("SteamID64: \"76561198182303579\"") -- Set the placeholder text
        searchBox:SetFont("ENFORCER.WarnFrame.Font.20") -- Set the font
        searchBox.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(35, 35, 46))
            self:DrawTextEntryText(Color(255, 255, 255), Color(255, 255, 255), Color(255, 255, 255))
            -- Draw the placeholder text
            if self:GetValue() == "" then
                draw.SimpleText(self:GetPlaceholderText(), "ENFORCER.WarnFrame.Font.20", 5, 0, Color(79, 77, 77), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            end
        end
        searchBox.OnEnter = function()
            searchButton:DoClick()
        end
        searchButton:SetPos(screenScaleW(212), screenScaleH(3)) -- Position the button next to the text entry field
        searchButton:SetSize(screenScaleW(50), screenScaleH(10)) -- Set the size of the button
        searchButton:SetText("SEARCH") -- Set the text of the button
        searchButton:SetFont("ENFORCER.WarnFrame.Font.20") -- Set the font
        searchButton:SetTextColor(Color(255, 255, 255)) -- Set the text color
        searchButton.DoClick = function()
            local query = searchBox:GetValue() -- Get the text in the text entry field

            -- Filter the warnings based on the query
            local filteredWarnings = {}
            for i, warning in ipairs(bans) do
                if string.find(warning.steamid:lower(), query:lower()) or string.find(warning.steamid:lower(), query:lower()) or string.find(warning.reason:lower(), query:lower()) or string.find(warning.admin:lower(), query:lower()) then
                    table.insert(filteredWarnings, warning)
                end
            end

            -- Display the filtered warnings
            displayPage(1, filteredWarnings)
        end
        searchButton.Paint = function(self, w, h)
            if self:IsHovered() then
                draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 60)) -- Change color when hovered
            else
                draw.RoundedBox(0, 0, 0, w, h, Color(27, 26, 40))
            end
        end

        displayPage(1)

    end

    -- Create a DPanel to act as the loading icon
    loadingIcon_BanDB:SetSize(50, 50) -- Set the size of the loading icon
    loadingIcon_BanDB:Center() -- Center the loading icon in the parent panel
    loadingIcon_BanDB.progress = 0 -- Initialize progress

    loadingIcon_BanDB.Paint = function(self, w, h)
        -- Draw the gradient loading icon bar
        local gradient = Material("vgui/gradient_up")
        surface.SetDrawColor(212, 85, 53) -- Set the draw color to the start color
        surface.SetMaterial(gradient)
        surface.DrawTexturedRect(0, h * (1 - self.progress), w, h * self.progress) -- Draw the gradient rectangle

    end

    loadingIcon_BanDB.Think = function(self)
        -- Update the progress
        self.progress = (self.progress + 0.01) % 2
    end




    -- If screen size changes and if less than 1080p then resize fonts
    local fontsCreated = false

    Frame.Think = function()
        if not fontsCreated and ScrH() < 1080 then
            for i = 1, 100 do
                surface.CreateFont( "ENFORCER.WarnFrame.Font."..i, {
                    font = "MADE Tommy Soft",
                    size = i*(ScrH()/1080),
                    weight = 500,
                    antialias = true,
                } )
            end
            fontsCreated = true
        elseif not fontsCreated and ScrH() >= 1080 then
            for i = 1, 100 do
                surface.CreateFont( "ENFORCER.WarnFrame.Font."..i, {
                    font = "MADE Tommy Soft",
                    size = i,
                    weight = 500,
                    antialias = true,
                } )
            end
            fontsCreated = true
        end
    end

end

function ENFORCER.CloseWarnFrame()
    if ENFORCER.WarnFrame then
        ENFORCER.WarnFrame:Close()
        ENFORCER.WarnFrame = false
    end
end

-- Chat command to open warn frame
hook.Add("OnPlayerChat", "ENFORCER.OpenWarnFrame", function(ply, text)
    if ply == LocalPlayer() and text == "!warns" then
        ENFORCER.OpenWarnFrame()
        return true
    end
end)