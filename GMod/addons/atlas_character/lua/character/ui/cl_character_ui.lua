-- File: character_ui.lua

-- Declare global variables for the entire UI and its Modules 
CHARACTER.CharScreen = CHARACTER.CharScreen or false
CHARACTER.CharCreationScreen = CHARACTER.CharCreationScreen or false
CHARACTER.LoadingScreen = CHARACTER.LoadingScreen or false
CHARACTER.DialogPopup = CHARACTER.DialogPopup or false
CHARACTER.ConfirmUI = CHARACTER.ConfirmUI or false
CHARACTER.MyCharacters = CHARACTER.MyCharacters or {}

-- Load Fonts
include("character/ui/modules/fonts.lua")

-- Load external UI modules
include("character/ui/modules/derma.lua") -- This comes first because it contains the label used by the rest
include("character/ui/modules/warning.lua")
include("character/ui/modules/loading.lua")
local dialog = include("character/ui/modules/dialog.lua")

-- Materials for UI components
local plusMaterial = Material("materials/character/ui/plus.png")
local soundoffMaterial = Material("materials/character/ui/sound-off.png")
local soundonMaterial = Material("materials/character/ui/sound-on.png")
local charBox = Material( "materials/ui/character_box.png" )

local playIcon = Material( "materials/ui/play.png" )
local editIcon = Material( "materials/ui/edit.png" )
local deleteIcon = Material( "materials/ui/delete.png" )
local cancelIcon = Material( "materials/ui/cancel.png" )

CHARACTER.theme = {
    bg_alpha = 250,
    bg_color = {r = 13, g = 13, b = 13},
    button_hover = {r = 179, g = 181, b = 201},
    button_active = {r = 211, g = 49, b = 49},
    button_inactive = {r = 56, g = 58, b = 74},
}

local theme = CHARACTER.theme

function CHARACTER.drawBtnUi(s, w, h, col, doNotHover)
    draw.RoundedBox( 0, 0, 0, 5, h, col or Color( 255, 255, 255) )
    draw.RoundedBox( 0, w - 5, 0, 5, h, col or Color( 255, 255, 255) )
    draw.RoundedBox( 0, 0, 0, w, 5, col or Color( 255, 255, 255) )
    draw.RoundedBox( 0, 0, h - 5, w, 5, col or Color( 255, 255, 255) )
    s:SetTextColor( col or Color( 255, 255, 255, 255 ) )

    if s:IsHovered() and not doNotHover then
        draw.RoundedBox( 0, 0, 0, 5, h, Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b) )
        draw.RoundedBox( 0, w - 5, 0, 5, h, Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b) )
        draw.RoundedBox( 0, 0, 0, w, 5, Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b) )
        draw.RoundedBox( 0, 0, h - 5, w, 5, Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b) )
        s:SetTextColor( Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b) )
    end
end

-- Character screen open/close functions
function CHARACTER.OpenCharScreen(job)
    if CHARACTER.CharScreen then
        CHARACTER.CharScreen:Remove()
        CHARACTER.CharScreen = false
        alpha = 0
        if musicStream then
            musicStream:Stop()
            musicStream = false
        end
    end

    if not job then
        job = TEAM_DCLASS
    end

    local sW, sH = ScrW(), ScrH()
    CHARACTER.CharScreen = vgui.Create( "EditablePanel" )
    local chpanel = CHARACTER.CharScreen
    chpanel:SetPos( 0, 0 )
    chpanel:SetSize( sW, sH )

    -- [Cursor] Enable the cursor
    gui.EnableScreenClicker( true )

    -- [Sound] Play the main menu music
    --[[sound.PlayFile( "sound/character/char_main_music.wav", "noplay", function( station, errCode, errStr )
        if ( IsValid( station ) ) then
            station:Play()
            musicStream = station
        else
            print( "Error playing sound!", errCode, errStr )
        end
    end )]]


    -- [FadeDelay] FadeDelay Variable is set here to delay the fade-in effect by three seconds.
    local FadeDelay = CurTime() + 3

    -- [CharactersDelay] CharactersDelay Variable is set here to delay the character selection by five seconds.
    local CharactersDelay = CurTime() + 5

    local alpha = 0
    chpanel.Paint = function(s, w, h)
        -- [Background] Draw the background image
        surface.SetDrawColor(0,0,0, 255)
        surface.DrawRect(0, 0, w, h)
        -- [Skip Message] Draw the "Press Space to Skip" message
        if alpha < theme.bg_alpha then
            surface.SetFont("Character_Name")
            surface.SetTextColor(255, 255, 255, 255)
            surface.SetTextPos(w / 2 - 100, h - 50)
            surface.DrawText("Press SPACE to skip", false)

        end
    
        -- Check if space is pressed and skip fade-in if true
        if input.IsKeyDown(KEY_SPACE) then
            alpha = theme.bg_alpha
            FadeDelay = 0 -- Skip the fade delay
            CharactersDelay = 0 -- Skip character selection delay
        end
    
        
        -- [FadeDelay] Check if the current time is less than the FadeDelay variable
        if FadeDelay > CurTime() then return end
    
        -- [Fade] Increase the alpha value by 0.5 every frame until it reaches 210
        alpha = math.min(alpha + 0.5, theme.bg_alpha)
    
        -- [Fade] Set the draw color to black with the current alpha value
        surface.SetDrawColor(theme.bg_color.r, theme.bg_color.g, theme.bg_color.b, alpha)  -- RGBA color
        surface.DrawRect(0, 0, w, h)  -- draw at position (0,0) with width w and height h

        
    end
    

    -- matSizedDown is a table that contains the width and height of the logo material multiplied by 0.2
    local matSizedDown = {w = 240, h = 87}

    local logoBack = vgui.Create( "DImage", chpanel )
    logoBack:SetPos( sW / 2 - (matSizedDown.w / 2) + 5, sH / 2 - (sH * 0.465) )
    logoBack:DockMargin( 0, 50, 0, 0 )

    -- [Logo] Set the logo size
    logoBack:SetSize( matSizedDown.w, matSizedDown.h )

    logoBack:SetImage( "materials/branding/atlas_logo_small.png" )
    logoBack:SetImageColor(Color(0, 0, 0))

    -- [Logo] Create a DImage and set the logo material
    local logo = vgui.Create( "DImage", chpanel )
    logo:SetPos( sW / 2 - (matSizedDown.w / 2), sH / 2 - (sH * 0.47) )
    logo:DockMargin( 0, 50, 0, 0 )

    -- [Logo] Set the logo size
    logo:SetSize( matSizedDown.w, matSizedDown.h )

    logo:SetImage( "materials/branding/atlas_logo_small.png" )

    local matSizedDown = {w = 450, h = 115}
    -- Create a DImage and set the logo material
    --[[local logoUnderBar = vgui.Create( "DImage", chpanel )
    logoUnderBar:SetPos( sW / 2 - (matSizedDown.w / 2), sH / 2 - (sH * 0.5) )
    logoUnderBar:SetSize( matSizedDown.w, matSizedDown.h )
    logoUnderBar:SetImage( "materials/branding/logo_under_bar.png" )]]


    -- [Logo] Make the logo and bar fade in
    logo.Think = function(s)
        local currentTime = CurTime()
        local progress = math.Clamp((currentTime - FadeDelay) / 2, 0, 1)
        local alpha = progress * 255
        s:SetAlpha(alpha)
        --logoUnderBar:SetAlpha(alpha)
    end

    -- [Characters] 
    local charPanelSize = {w = 313, h = 605}
    local charOnePanel = vgui.Create( "DPanel", chpanel )
    charOnePanel:SetPos( sW / 2 - 600, sH / 2 - 220 )
    charOnePanel:SetSize( charPanelSize.w, charPanelSize.h )
    charOnePanel:SetVisible( false )

    local pCharOne = CHARACTER.MyCharacters[1]
    local pCharTwo = CHARACTER.MyCharacters[2]
    local pCharThree = CHARACTER.MyCharacters[3]

    local parentSizeW, parentSizeH = charOnePanel:GetSize()

    if pCharOne then
        local charOneMdl = vgui.Create( "DModelPanel", charOnePanel )
        charOneMdl:SetSize( parentSizeW, parentSizeH * 0.9 )
        charOneMdl:SetPos( 0, 0)
        charOneMdl:SetModel( pCharOne.preferred_model )
        charOneMdl:SetCamPos( Vector( 30, 30, 50 ) )
        charOneMdl:SetLookAt( Vector( 0, 0, 40 ) )
        charOneMdl.LayoutEntity = function( panel, entity )
            -- do nothing, this will stop the model from rotating
        end

        charOneMdl.Entity:SetAngles(Angle(0, 45, 0))  -- set the model's angles, adjust as needed
    end

    local startTime = CurTime() + 5 -- Start time of the fade-in effect
    local duration = 4 -- Duration of the fade-in effect (in seconds)
    local maxAlpha = 255 -- Maximum alpha value (0 = completely transparent, 255 = completely opaque)
    local alpha = 0 -- Initialize alpha
    local FadeDelay = startTime -- Initialize FadeDelay
    local jobData = pCharOne and RPExtraTeams[tonumber(pCharOne.team)] or false
    
    charOnePanel.Paint = function(s, w, h)
        local currentTime = CurTime()
    
        -- Check if space is pressed and skip fade-in if true
        if input.IsKeyDown(KEY_SPACE) then
            alpha = maxAlpha
            FadeDelay = 0 -- Skip the fade delay
        end
    
        -- Check if the current time is less than the FadeDelay variable
        if FadeDelay > CurTime() then return end
    
        -- Increase the alpha value by 0.5 every frame until it reaches maxAlpha
        alpha = math.min(alpha + 0.5, maxAlpha)
    
        surface.SetFont("Character_Name")
        -- Draw the text
        if pCharOne then
            draw.SimpleText(pCharOne.first_name .. " " .. pCharOne.last_name, "Character_Name", w / 2, h / 1.15, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(jobData.name, "Character_Name", w / 2, h / 1.1, jobData.color and Color(jobData.color.r, jobData.color.g, jobData.color.b, jobData.color.a) or Color(151, 151, 151, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            -- Draw the text
            draw.SimpleText("CREATE A CHARACTER", "Character_Name", w / 2, h / 1.075, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            local plusSize = 128 -- You can change this to the size you want
            surface.SetDrawColor(Color(255, 255, 255, alpha)) -- Set color to white for the material
            surface.SetMaterial(plusMaterial)
            surface.DrawTexturedRect(w / 2 - plusSize / 2, h / 2 - plusSize / 2, plusSize, plusSize) -- Draw the material in the center of the panel
        end
    
        surface.SetDrawColor(Color(255, 255, 255, alpha))
        surface.SetMaterial(charBox)
        surface.DrawTexturedRect(0, 0, w, h)
    end

    -- Create a panel that is transparent but acts like a button and covers the entire character panel
    local charOneButton = vgui.Create( "DPanel", charOnePanel )
    charOneButton:SetPos( 0, 0 )
    charOneButton:SetSize( charPanelSize.w, charPanelSize.h )
    charOneButton:SetVisible( true )

    -- Make the panel transparent
    charOneButton.Paint = function(s, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 0) )
    end

    -- Change mouse cursor to a hand when hovering over the panel
    charOneButton.OnCursorEntered = function(s)
        s:SetCursor("hand")
    end

    -- On mouse click print
    charOneButton.OnMousePressed = function(s)
        if pCharOne then
            dialog.Create(pCharOne, chpanel)
        else
            CHARACTER.OpenCharCreation(job)
            CHARACTER.CloseCharScreen()
        end
    end

    -- [Characters] 
    local charTwoPanel = vgui.Create( "DPanel", chpanel )
    charTwoPanel:SetPos( sW / 2 - 165, sH / 2 - 180 )
    charTwoPanel:SetSize( charPanelSize.w, charPanelSize.h )
    charTwoPanel:SetVisible( false )

    if pCharTwo then
        local charTwoMdl = vgui.Create( "DModelPanel", charTwoPanel )
        charTwoMdl:SetSize( parentSizeW, parentSizeH * 0.9 )
        charTwoMdl:SetPos( 0, 0)
        charTwoMdl:SetModel( pCharTwo.preferred_model )
        charTwoMdl:SetCamPos( Vector( 30, 30, 50 ) )
        charTwoMdl:SetLookAt( Vector( 0, 0, 40 ) )
        charTwoMdl.LayoutEntity = function( panel, entity )
            -- do nothing, this will stop the model from rotating
        end

        charTwoMdl.Entity:SetAngles(Angle(0, 45, 0))  -- set the model's angles, adjust as needed
    end


    local startTime = CurTime() + 5 -- Start time of the fade-in effect
    local duration = 4 -- Duration of the fade-in effect (in seconds)
    local maxAlpha = 255 -- Maximum alpha value (0 = completely transparent, 255 = completely opaque)
    local alpha = 0 -- Initialize alpha
    local FadeDelay = startTime -- Initialize FadeDelay
    local jobTwoData = pCharTwo and RPExtraTeams[tonumber(pCharTwo.team)] or false
    
    charTwoPanel.Paint = function(s, w, h)
        local currentTime = CurTime()
    
        -- Check if space is pressed and skip fade-in if true
        if input.IsKeyDown(KEY_SPACE) then
            alpha = maxAlpha
            FadeDelay = 0 -- Skip the fade delay
        end
    
        -- Check if the current time is less than the FadeDelay variable
        if FadeDelay > CurTime() then return end
    
        -- Increase the alpha value by 0.5 every frame until it reaches maxAlpha
        alpha = math.min(alpha + 0.5, maxAlpha)
    
        surface.SetDrawColor(Color(255, 255, 255, alpha))
        surface.SetMaterial(charBox)
        surface.DrawTexturedRect(0, 0, w, h)
    
        if pCharTwo then
            draw.SimpleText(pCharTwo.first_name .. " " .. pCharTwo.last_name, "Character_Name", w / 2, h / 1.15, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(jobTwoData.name, "Character_Name", w / 2, h / 1.1, jobTwoData.color and Color(jobTwoData.color.r, jobTwoData.color.g, jobTwoData.color.b, jobTwoData.color.a) or Color(151, 151, 151, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            -- Draw the text
            draw.SimpleText("CREATE A CHARACTER", "Character_Name", w / 2, h / 1.075, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            local plusSize = 128 -- You can change this to the size you want
            surface.SetDrawColor(Color(255, 255, 255, alpha)) -- Set color to white for the material
            surface.SetMaterial(plusMaterial)
            surface.DrawTexturedRect(w / 2 - plusSize / 2, h / 2 - plusSize / 2, plusSize, plusSize) -- Draw the material in the center of the panel
        end
    end
    -- Create a panel that is transparent but acts like a button and covers the entire character panel
    local charTwoButton = vgui.Create( "DPanel", charTwoPanel )
    charTwoButton:SetPos( 0, 0 )
    charTwoButton:SetSize( charPanelSize.w, charPanelSize.h )
    charTwoButton:SetVisible( true )

    -- Make the panel transparent
    charTwoButton.Paint = function(s, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 0) )
    end

    -- Change mouse cursor to a hand when hovering over the panel
    charTwoButton.OnCursorEntered = function(s)
        s:SetCursor("hand")
    end

    -- On mouse click print
    charTwoButton.OnMousePressed = function(s)
        if pCharTwo then
            dialog.Create(pCharTwo, chpanel)
        else
            CHARACTER.OpenCharCreation(job)
            CHARACTER.CloseCharScreen()
        end
    end

    -- [Characters] 
    local charThreePanel = vgui.Create( "DPanel", chpanel )
    charThreePanel:SetPos( sW / 2 + 270, sH / 2 - 220 )
    charThreePanel:SetSize( charPanelSize.w, charPanelSize.h )
    charThreePanel:SetVisible( false )

    if pCharThree then
        local charThreeMdl = vgui.Create( "DModelPanel", charThreePanel )
        charThreeMdl:SetSize( parentSizeW, parentSizeH * 0.9 )
        charThreeMdl:SetPos( 0, 0)
        charThreeMdl:SetModel( pCharThree.preferred_model )
        charThreeMdl:SetCamPos( Vector( 30, 30, 50 ) )
        charThreeMdl:SetLookAt( Vector( 0, 0, 40 ) )
        charThreeMdl.LayoutEntity = function( panel, entity )
            -- do nothing, this will stop the model from rotating
        end

        charThreeMdl.Entity:SetAngles(Angle(0, 45, 0))  -- set the model's angles, adjust as needed
    end

    local startTime = CurTime() + 5 -- Start time of the fade-in effect
    local duration = 4 -- Duration of the fade-in effect (in seconds)
    local maxAlpha = 255 -- Maximum alpha value (0 = completely transparent, 255 = completely opaque)
    local alpha = 0 -- Initialize alpha
    local FadeDelay = startTime -- Initialize FadeDelay
    local jobThreeData = pCharThree and RPExtraTeams[tonumber(pCharThree.team)] or false
    
    charThreePanel.Paint = function(s, w, h)
        local currentTime = CurTime()
    
        -- Check if space is pressed and skip fade-in if true
        if input.IsKeyDown(KEY_SPACE) then
            alpha = maxAlpha
            FadeDelay = 0 -- Skip the fade delay
        end
    
        -- Check if the current time is less than the FadeDelay variable
        if FadeDelay > CurTime() then return end
    
        -- Increase the alpha value by 0.5 every frame until it reaches maxAlpha
        alpha = math.min(alpha + 0.5, maxAlpha)
    
        surface.SetDrawColor(Color(255, 255, 255, alpha))
        surface.SetMaterial(charBox)
        surface.DrawTexturedRect(0, 0, w, h)
    
        if pCharThree then
            draw.SimpleText(pCharThree.first_name .. " " .. pCharThree.last_name, "Character_Name", w / 2, h / 1.15, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(jobThreeData.name, "Character_Name", w / 2, h / 1.1, jobThreeData.color and Color(jobThreeData.color.r, jobThreeData.color.g, jobThreeData.color.b, jobThreeData.color.a) or Color(151, 151, 151, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            -- Draw the text
            draw.SimpleText("CREATE A CHARACTER", "Character_Name", w / 2, h / 1.075, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            local plusSize = 128 -- You can change this to the size you want
            surface.SetDrawColor(Color(255, 255, 255, alpha)) -- Set color to white for the material
            surface.SetMaterial(plusMaterial)
            surface.DrawTexturedRect(w / 2 - plusSize / 2, h / 2 - plusSize / 2, plusSize, plusSize) -- Draw the material in the center of the panel
        end
    end
    -- Create a panel that is transparent but acts like a button and covers the entire character panel
    local charThreeButton = vgui.Create( "DPanel", charThreePanel )
    charThreeButton:SetPos( 0, 0 )
    charThreeButton:SetSize( charPanelSize.w, charPanelSize.h )
    charThreeButton:SetVisible( true )

    -- Make the panel transparent
    charThreeButton.Paint = function(s, w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 0) )
    end

    -- Change mouse cursor to a hand when hovering over the panel
    charThreeButton.OnCursorEntered = function(s)
        s:SetCursor("hand")
    end

    -- On mouse click print
    charThreeButton.OnMousePressed = function(s)
        if pCharThree then
            dialog.Create(pCharThree, chpanel)
        else
            CHARACTER.OpenCharCreation(job)
            CHARACTER.CloseCharScreen()
        end
    end

    -- Create dlabel which says "SELECT OR CREATE YOUR CHARACTER" in the center of the screen
    local startTime = CurTime() + 5 -- Start time of the fade-in effect
    local duration = 4 -- Duration of the fade-in effect (in seconds)
    local maxAlpha = 255 -- Maximum alpha value (0 = completely transparent, 255 = completely opaque)
    local alpha = 0 -- Initialize alpha
    
    local selectLabel = vgui.Create("DLabel", chpanel)
    selectLabel:SetPos(sW / 2 - 600, sH / 2 - 300)
    selectLabel:SetSize(1200, 100)
    selectLabel:SetFont("Character_Title")
    selectLabel:SetText("CHOOSE YOUR CHARACTER")
    selectLabel:SetTextColor(Color(255, 255, 255, 255))
    selectLabel:SetContentAlignment(5)
    selectLabel:SetVisible(false)
    
    -- Make label fade in
    selectLabel.Think = function(s)
        local currentTime = CurTime()
    
        -- Check if space is pressed and skip fade-in if true
        if input.IsKeyDown(KEY_SPACE) then
            alpha = maxAlpha
        else
            local progress = math.Clamp((currentTime - startTime) / duration, 0, 1)
            alpha = progress * maxAlpha
        end
        s:SetAlpha(alpha)
        if alpha == maxAlpha then
            s.Think = nil
        end
    end

    -- Close Button top right
    local closeBtn = vgui.Create( "DButton", chpanel )
    closeBtn:SetPos( sW - 60, 10 )
    closeBtn:SetSize( 50, 50 )
    closeBtn:SetText( "X" )
    closeBtn:SetFont( "Character.Creation.Label" )
    closeBtn:SetVisible( false )
    closeBtn.Paint = function(s, w, h)
        CHARACTER.drawBtnUi(s, w, h)
    end
    closeBtn.DoClick = function()
        CHARACTER.CloseCharScreen()
    end

    -- Toggle sound icon
    --[[local soundToggle = vgui.Create( "DImageButton", chpanel )
    soundToggle:SetPos( 150, 150 )

    soundToggle:SetSize( 64, 64 )
    soundToggle:SetMaterial( soundonMaterial )
    soundToggle:SetColor( Color( 255, 255, 255, 255 ) )
    soundToggle.Think = function(s)
        s:SetMaterial( musicStream and soundonMaterial or soundoffMaterial )
    end

    soundToggle.DoClick = function()
        if musicStream then
            musicStream:Stop()
            musicStream = false
        else
            sound.PlayFile( "sound/character/char_main_music.wav", "noplay", function( station, errCode, errStr )
                if ( IsValid( station ) ) then
                    station:Play()
                    musicStream = station
                else
                    print( "Error playing sound!", errCode, errStr )
                end
            end )
        end
    end]]


    -- [CharactersDelay] Add think hook to check if the current time is less than the CharactersDelay variable
    local f1Delay = CurTime() + 0.5
    chpanel.Think = function()
        -- if pressing F1, close the character screen
        if input.IsKeyDown(KEY_F1) and f1Delay < CurTime() then
            CHARACTER.CloseCharScreen()
        end
        -- [Characters] Check if the current time is less than the CharactersDelay variable
        if CharactersDelay > CurTime() then return end

        -- [Characters] Set the visibility of the character panels to true
        charOnePanel:SetVisible( true )
        charTwoPanel:SetVisible( true )
        charThreePanel:SetVisible( true )
        selectLabel:SetVisible( true )
        closeBtn:SetVisible( true )
    end
    chpanel:MakePopup()
end

function CHARACTER.CloseCharScreen()
    if CHARACTER.CharScreen then
        CHARACTER.CharScreen:Remove()
        CHARACTER.CharScreen = false
        if musicStream then
            musicStream:Stop()
            musicStream = false
        end
        gui.EnableScreenClicker(false)
    end
end

-- Helper function to fully load models
function FullyLoadModelsClient(modelsTable, callback)
    local dummyPanels = {}

    -- Create hidden model panels to force load models
    for _, models in pairs(modelsTable) do
        for _, model in ipairs(models) do
            local mdlPanel = vgui.Create("DModelPanel")
            mdlPanel:SetSize(0, 0)  -- Setting size to 0 effectively hides it
            mdlPanel:SetModel(model)
            table.insert(dummyPanels, mdlPanel)
        end
    end

    -- Give it a few seconds to ensure models are loaded.
    timer.Simple(2, function()
        for _, panel in ipairs(dummyPanels) do
            panel:Remove()  -- Remove the dummy panels
        end
        callback()  -- Call the provided callback (e.g., to open the UI)
    end)
end

-- Helper to get team index by name
function getTeamIndexByName(name)
    for teamIndex = 0, #team.GetAllTeams() do
        if team.GetName(teamIndex) == name then
            return teamIndex
        end
    end
    return nil
end

-- Confirmation UI
function CHARACTER.ConfirmDeleteUI(callback)
    if CHARACTER.ConfirmUI then
        CHARACTER.ConfirmUI:Remove()
        CHARACTER.ConfirmUI = false
    end

    local confirmPanel = vgui.Create( "EditablePanel", chpanel )
    CHARACTER.ConfirmUI = confirmPanel
    confirmPanel:SetSize( 400, 300 )
    confirmPanel:Center()
    confirmPanel:MakePopup()
    confirmPanel.OnRemove = function()
        CHARACTER.ConfirmUI = false
    end
    confirmPanel.Paint = function(s, w, h)
        surface.SetDrawColor( Color( 27, 27, 35) )
        surface.DrawRect( 0, 0, w, h )

        Derma_DrawBackgroundBlur( s, s.m_fCreateTime )
    end

    local confirmLabel = vgui.Create( "DLabel", confirmPanel )
    confirmLabel:Dock(TOP)
    confirmLabel:SetSize( 400, 50 )
    confirmLabel:DockMargin(0, 20, 0, 0)
    confirmLabel:SetFont( "CHARACTER_CONFIRM_Font" )
    confirmLabel:SetText( "TYPE 'DELETE' IN THE\nTEXT BOX TO CONFIRM" )
    confirmLabel:SetTextColor( Color( 255, 255, 255, 255 ) )
    confirmLabel:SetContentAlignment( 5 )

    local confirmEntry = vgui.Create( "DTextEntry", confirmPanel )
    confirmEntry:Dock(TOP)
    confirmEntry:SetSize( 200, 50 )
    confirmEntry:DockMargin(140, 10, 140, 0)
    confirmEntry:SetText( "" )
    confirmEntry:SetTextColor( Color( 255, 255, 255, 255 ) )
    confirmEntry:SetFont( "Character_Title" )
    confirmEntry:SetPlaceholderText("Type 'DELETE' here")
    confirmEntry:SetContentAlignment( 5 )

    confirmEntry.Paint = function(self, w, h)
        -- Draw a background
        draw.RoundedBox(4, 0, 0, w, h, Color(30, 30, 30, 255))
        
        -- Center the text
        local text = self:GetText()
        local font = self:GetFont()
        surface.SetFont(font)
        local tw, th = surface.GetTextSize(text)
    
        -- Set text color to white
        self:SetTextColor(Color(255, 255, 255, 255))
    
        -- Draw the text entry text (including cursor)
        self:DrawTextEntryText(Color(255, 255, 255, 255), Color(30, 144, 255, 255), Color(255, 255, 255, 255))
    end
    
    -- Select all text when the DTextEntry gets focus
    confirmEntry.OnGetFocus = function(self)
        self:SelectAllText()
    end
    
    // Make it so players cant type beyond the 6 character limit
    confirmEntry.OnTextChanged = function(self)
        local text = self:GetText()
        local limit = 6
    
        if string.len(text) > limit then
            self:SetText(string.sub(text, 1, limit))
            self:SetCaretPos(string.len(text))
        end
    end


    local confirmButton = vgui.Create( "DButton", confirmPanel )
    confirmButton:Dock(TOP)
    confirmButton:DockMargin(50, 10, 50, 0)
    confirmButton:SetSize( 400, 50 )
    confirmButton:SetText( "DELETE" )
    confirmButton:SetTextColor( Color( 255, 255, 255) )
    confirmButton:SetFont( "Character_Title" )
    confirmButton.Paint = function(s, w, h)

        if confirmEntry:GetText() == "DELETE" then
            draw.RoundedBox( 20, 0, 0, w, h, Color( 255, 68, 68) )
        else
            draw.RoundedBox( 20, 0, 0, w, h, Color( 68, 68, 68) )
        end

        surface.SetDrawColor( Color( 255, 255, 255) )
        surface.SetMaterial( deleteIcon )
        surface.DrawTexturedRect( 10, h / 2 - 16, 32, 32 )
    end

    confirmButton.DoClick = function()
        if confirmEntry:GetText() == "DELETE" then
            callback()
            confirmPanel:Remove()
        else
            -- Play error sound
            sound.Play( "common/wpn_denyselect.wav", LocalPlayer():GetPos(), 75, 100, 1 )
        end
    end

    -- Cancel button
    local cancelButton = vgui.Create( "DButton", confirmPanel )
    cancelButton:Dock(TOP)
    cancelButton:DockMargin(50, 10, 50, 0)
    cancelButton:SetSize( 400, 50 )
    cancelButton:SetText( "CANCEL" )
    cancelButton:SetTextColor( Color( 255, 255, 255) )
    cancelButton:SetFont( "Character_Title" )

    cancelButton.Paint = function(s, w, h)
        draw.RoundedBox( 20, 0, 0, w, h, Color( 237, 166, 96) )
        surface.SetDrawColor( Color( 255, 255, 255) )
        surface.SetMaterial( cancelIcon )
        surface.DrawTexturedRect( 10, h / 2 - 16, 32, 32 )
    end

    cancelButton.DoClick = function()
        confirmPanel:Remove()
    end
end

-- Close Confirmation UI
function CHARACTER.CloseConfirmationUI()
    if CHARACTER.ConfirmUI then
        CHARACTER.ConfirmUI:Remove()
        CHARACTER.ConfirmUI = false
    end
end
