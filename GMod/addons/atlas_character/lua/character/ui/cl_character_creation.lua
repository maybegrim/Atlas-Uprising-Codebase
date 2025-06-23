-- File: character_creation.lua

-- Load external modules
local mdlutil = include("character/ui/modules/models.lua")
local dialog = include("character/ui/modules/dialog.lua")
-- Reference to the theme
local theme = CHARACTER.theme

-- Character Creation UI
function CHARACTER.OpenCharCreation(job, isEdit, charData)
    if CHARACTER.CharCreationScreen then
        CHARACTER.CharCreationScreen:Remove()
        CHARACTER.CharCreationScreen = false
        alpha = 0
    end

    if not job then
        job = TEAM_DCLASS
    end

    if isEdit then
        job = tonumber(charData.team)
    end

    local dept = RPExtraTeams[job].category
    local confData
    if dept and CHARACTER.CONFIG.UseJobModels[dept] then
        local jobIndex
        if not isnumber(job) then
            jobIndex = getTeamIndexByName(job)
        else
            jobIndex = job
        end
        local mdls_M, mdls_F = mdlutil:GetModelTable(jobIndex)
        confData = {male = mdls_M, female = mdls_F}
    else
        confData = CHARACTER.CONFIG.ModelChoice[RPExtraTeams[job].faction]
    end

    if not confData then
        print("[ERROR] No config data for job: " .. team.GetName(job))
        return
    end

    local selectedType = "A"

    local sW, sH = ScrW(), ScrH()
    CHARACTER.CharCreationScreen = vgui.Create( "EditablePanel" )
    local chpanel = CHARACTER.CharCreationScreen
    --chpanel:SetPos( 0, 0 )
    chpanel:SetSize( sW, sH )
    chpanel:Dock(FILL)
    -- Panel paint function
    chpanel.Paint = function(s, w, h)
        -- [Background] Draw the background image
        surface.SetDrawColor(theme.bg_color.r, theme.bg_color.g, theme.bg_color.b, 255)
        surface.DrawRect(0, 0, w, h)

        -- [Fade] Set the draw color to black with the current alpha value
        surface.SetDrawColor(0, 0, 0, theme.bg_alpha)  -- RGBA color
        surface.DrawRect(0, 0, w, h)  -- draw at position (0,0) with width w and height h
    end

    -- Enable Keyboard and Mouse
    chpanel:MakePopup()
    CHARACTER.OpenLoadingScreen()
    timer.Simple(0.2, function() -- Additional timer so that loading screen can open.
    FullyLoadModelsClient(confData, function()
        CHARACTER.CloseLoadingScreen()

        --[[ UTILITY FUNCTIONS FOR UI ]]
        local function drawBoxUI(s, w, h)
            draw.RoundedBox( 0, 0, 0, 5, h, Color( 255, 255, 255) )
            draw.RoundedBox( 0, w - 5, 0, 5, h, Color( 255, 255, 255) )
            draw.RoundedBox( 0, 0, 0, 40, 5, Color( 255, 255, 255) )
            draw.RoundedBox( 0, 0, h - 5, 40, 5, Color( 255, 255, 255) )
            draw.RoundedBox( 0, w - 40, 0, 40, 5, Color( 255, 255, 255) )
            draw.RoundedBox( 0, w - 40, h - 5, 40, 5, Color( 255, 255, 255) )

            if s:GetChild(0):IsHovered() or s:IsHovered() then
                draw.RoundedBox( 0, 0, 0, 5, h, Color(Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b).r, Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b).g, Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b).b) )
                draw.RoundedBox( 0, w - 5, 0, 5, h, Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b) )
                draw.RoundedBox( 0, 0, 0, 40, 5, Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b) )
                draw.RoundedBox( 0, 0, h - 5, 40, 5, Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b) )
                draw.RoundedBox( 0, w - 40, 0, 40, 5, Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b) )
                draw.RoundedBox( 0, w - 40, h - 5, 40, 5, Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b) )
            end
        end

        local function drawBtnUi(s, w, h, col, doNotHover)
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

        local function drawTextBox(s, w, h)
            s:DrawTextEntryText( Color( 255, 255, 255, 255 ), Color( 41, 45, 65), Color( 255, 255, 255, 255 ) )

            if s:GetText() == "" and not s:IsMultiline() then
                draw.SimpleText( s:GetPlaceholderText(), "Character.Creation.Label", 5, h / 2, Color( 228, 218, 218, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            end

            if s:GetText() == "" and s:IsMultiline() then
                draw.SimpleText( s:GetPlaceholderText(), "Character.Creation.Label", 1, 17, Color( 228, 218, 218, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            end
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

        local posW = 700
        local posH = 350
        local firstNameLabelPosX, firstNameLabelPosY = sW / 2 - posW, sH / 2 - posH
        local firstNameLabel = vgui.Create( "BIOBOLT.UI.AutoSizeLabel", chpanel )
        firstNameLabel:SetPos( firstNameLabelPosX, firstNameLabelPosY )
        firstNameLabel:SetFont( "Character.Creation.Label" )
        firstNameLabel:SetText( "FIRST NAME" )
        firstNameLabel:SetTextColor( Color( 255, 255, 255, 255 ) )
        firstNameLabel:SetContentAlignment( 5 )


        local firstNameParent = vgui.Create("DPanel", chpanel)
        firstNameParent:SetSize(300, 60)
        firstNameParent:SetPos(sW / 2 - posW, sH / 2 - (posH - 50))

        local firstNameEntry = vgui.Create( "DTextEntry", firstNameParent )
        firstNameEntry:SetPos(10, 5)
        firstNameEntry:SetSize( 400, 50 )
        firstNameEntry:SetText( "" )
        firstNameEntry:SetTextColor( Color( 255, 255, 255, 255 ) )
        firstNameEntry:SetFont( "Character.Creation.Label" )
        firstNameEntry:SetPlaceholderText("First Name")

        local jobLabel = vgui.Create( "BIOBOLT.UI.AutoSizeLabel", chpanel )
        jobLabel:SetPos( sW / 2 - 350, sH / 2 - posH )
        jobLabel:SetFont( "Character.Creation.Label" )
        jobLabel:SetText( "SELECTED JOB" )
        jobLabel:SetTextColor( Color( 255, 255, 255, 255 ) )
        jobLabel:SetContentAlignment( 5 )

        local jobParent = vgui.Create("DPanel", chpanel)
        jobParent:SetSize(300, 60)
        jobParent:SetPos(sW / 2 - 350, sH / 2 - (posH - 50))

        local dropDownMenu = vgui.Create("DScrollPanel", chpanel)
        dropDownMenu:SetPos(sW / 2 - 350, sH / 2 - (posH - 110))
        dropDownMenu:SetSize(300, 250)
        dropDownMenu:SetVisible(false)

        -- Change the color of the scroll bar
        dropDownMenu.VBar.Paint = function(s, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
        end

        -- Change the color of the scroll bar button
        dropDownMenu.VBar.btnUp.Paint = function(s, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(126, 126, 126))
            -- Draw Up arrow
            draw.SimpleText("▲", "Character.Creation.LabelSmall", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        -- Change the color of the scroll bar button
        dropDownMenu.VBar.btnDown.Paint = function(s, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(126, 126, 126))
            -- Draw Text
            draw.SimpleText("▼", "Character.Creation.LabelSmall", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        -- Change the color of the scroll bar grip
        dropDownMenu.VBar.btnGrip.Paint = function(s, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255))
        end

        -- Put a info icon to left of jobWarningLabel
        local infoIcon = vgui.Create("DImage", chpanel)
        infoIcon:SetPos(sW / 2 - 353, sH / 2 - posH + 30)
        infoIcon:SetSize(16, 16)
        infoIcon:SetImage("materials/biobolt_ui/icons/16/help.png")

        -- Create under label
        local jobWarningLabelUnder = vgui.Create( "BIOBOLT.UI.AutoSizeLabel", chpanel )
        jobWarningLabelUnder:SetPos( sW / 2 - 331, sH / 2 - posH + 32 )
        jobWarningLabelUnder:SetFont( "Character.Creation.LabelSmall" )
        jobWarningLabelUnder:SetText( "Only jobs you're whitelisted to will appear." )
        jobWarningLabelUnder:SetTextColor( Color( 14,14,14) )

        -- Create a label thats above jobParent
        local jobWarningLabel = vgui.Create( "BIOBOLT.UI.AutoSizeLabel", chpanel )
        jobWarningLabel:SetPos( sW / 2 - 333, sH / 2 - posH + 30 )
        jobWarningLabel:SetFont( "Character.Creation.LabelSmall" )
        jobWarningLabel:SetText( "Only jobs you're whitelisted to will appear." )
        jobWarningLabel:SetTextColor( Color( 37, 183, 211 ) )

        local dropDownSelectedValue = false

        local dropDownButton = vgui.Create("DButton", jobParent)
        dropDownButton:SetPos(5, 5)
        dropDownButton:SetSize(290, 50)
        dropDownButton:SetText(isstring(dropDownSelectedValue) and dropDownSelectedValue or "Select a job")
        dropDownButton:SetTextColor(Color(255, 255, 255))
        dropDownButton:SetFont("Character.Creation.Label")
        dropDownButton.DoClick = function()
            if dropDownMenu:IsVisible() then
                dropDownMenu:SetVisible(false)
            else
                dropDownMenu:SetVisible(true)
            end
        end

        dropDownButton.Paint = function(s, w, h)
            -- If hovered change color text
            if s:IsHovered() then
                s:SetTextColor(Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b))
            else
                s:SetTextColor(Color(255, 255, 255))
            end
        end

        local MenuItemHeight = 50

        local options = {}
        for k,v in pairs(RPExtraTeams) do
            if v.customCheck and not v.customCheck(LocalPlayer()) then continue end
            if v.noChar then continue end
            if not GAS.JobWhitelist.AccessibleJobs[k] then continue end
            table.insert(options, v.name)
            if team.GetName(job) == v.name then
                dropDownSelectedValue = v.name
                dropDownButton:SetText(v.name)
            end
        end

        for k, option in pairs(options) do
            local menuItem = vgui.Create("DButton", dropDownMenu)
            menuItem:SetSize(290, MenuItemHeight)
            menuItem:Dock(TOP)
            menuItem:DockMargin(5, 5, 5, 5)
            menuItem:SetText(option)
            menuItem.DoClick = function()
                dropDownMenu:SetVisible(false)
                dropDownSelectedValue = option
                dropDownButton:SetText(option)
                selectedType = "A"
                local dept = RPExtraTeams[getTeamIndexByName(option)].category
                local job = getTeamIndexByName(option)
                if dept and CHARACTER.CONFIG.UseJobModels[dept] then
                    local jobIndex
                    if not isnumber(job) then
                        jobIndex = tonumber(job)
                    else
                        jobIndex = job
                    end
                    local mdls_M, mdls_F = mdlutil:GetModelTable(jobIndex)
                    confData = {male = mdls_M, female = mdls_F}
                    return 
                end
                confData = CHARACTER.CONFIG.ModelChoice[RPExtraTeams[getTeamIndexByName(option)].faction]
            end
            menuItem.Paint = function(s, w, h)
                drawBtnUi(s, w, h)
            end
        end



        -- Adjust the position of the next element
        posW = posW
        posH = posH - 150
        -- Last Name
        local lastNameLabel = vgui.Create( "BIOBOLT.UI.AutoSizeLabel", chpanel )
        lastNameLabel:SetPos( sW / 2 - posW, sH / 2 - posH )
        lastNameLabel:SetFont( "Character.Creation.Label" )
        lastNameLabel:SetText( "LAST NAME" )
        lastNameLabel:SetTextColor( Color( 255, 255, 255, 255 ) )
        lastNameLabel:SetContentAlignment( 5 )

        local lastNameParent = vgui.Create("DPanel", chpanel)
        lastNameParent:SetSize(300, 60)
        lastNameParent:SetPos(sW / 2 - posW, sH / 2 - (posH - 50))

        local lastNameEntry = vgui.Create( "DTextEntry", lastNameParent )
        lastNameEntry:SetPos(10, 5)
        lastNameEntry:SetSize( 400, 50 )
        lastNameEntry:SetText( "" )
        lastNameEntry:SetTextColor( Color( 255, 255, 255, 255 ) )
        lastNameEntry:SetFont( "Character.Creation.Label" )
        lastNameEntry:SetPlaceholderText("Last Name")


        local nameGeneratorIcon = vgui.Create("DImage", chpanel)
        nameGeneratorIcon:SetPos(firstNameLabelPosX + 285, firstNameLabelPosY + 28)
        nameGeneratorIcon:SetSize(16, 16)
        nameGeneratorIcon:SetImage("materials/biobolt_ui/icons/32/magic_wand_test.png")
        nameGeneratorIcon:SetMouseInputEnabled(true)
        nameGeneratorIcon:SetTooltip("Generate a random first and last name.")
        nameGeneratorIcon:SetImageColor(Color(126, 56, 158))

        nameGeneratorIcon.OnMousePressed = function(s)
            local rFirst, rLast = CHARACTER.RandomName()
            firstNameEntry:SetText(rFirst)
            lastNameEntry:SetText(rLast)
        end

        nameGeneratorIcon.Think = function(s)
            if s:IsHovered() then
                nameGeneratorIcon:SetImage("materials/biobolt_ui/icons/32/magic_wand_hover.png")
            else
                nameGeneratorIcon:SetImage("materials/biobolt_ui/icons/32/magic_wand_test.png")
            end
        end

        -- Adjust the position of the next element
        posW = posW
        posH = posH - 150
        -- Create a label that says body type
        local bodyTypeLabel = vgui.Create( "BIOBOLT.UI.AutoSizeLabel", chpanel )
        bodyTypeLabel:SetPos( sW / 2 - 700, sH / 2 - 60 )
        bodyTypeLabel:SetFont( "Character.Creation.Label" )
        bodyTypeLabel:SetText( "BODY TYPE" )
        bodyTypeLabel:SetTextColor( Color( 255, 255, 255, 255 ) )



        -- Create two button side by side each other that are labeled A or B
        local bodyTypeButtonA = vgui.Create( "DButton", chpanel )
        bodyTypeButtonA:SetPos( sW / 2 - 700, sH / 2 - 10 )
        bodyTypeButtonA:SetSize( 70, 70 )
        bodyTypeButtonA:SetText( "A" )
        bodyTypeButtonA:SetTextColor( Color( 255, 255, 255, 255 ) )
        bodyTypeButtonA:SetFont( "Character.Creation.BtnLbl" )


        local bodyTypeButtonB = vgui.Create( "DButton", chpanel )
        bodyTypeButtonB:SetPos( sW / 2 - 620, sH / 2 - 10 )
        bodyTypeButtonB:SetSize( 70, 70 )
        bodyTypeButtonB:SetText( "B" )
        bodyTypeButtonB:SetTextColor( Color( 255, 255, 255, 255 ) )
        bodyTypeButtonB:SetFont( "Character.Creation.BtnLbl" )


        -- On press change the selected type
        bodyTypeButtonA.DoClick = function()
            selectedType = "A"
        end

        bodyTypeButtonB.DoClick = function()
            if table.IsEmpty(confData.female) then return end
            selectedType = "B"
        end

        bodyTypeButtonA.Paint = function(s, w, h)

            if selectedType == "B" then
                drawBtnUi(s, w, h)
            else
                drawBtnUi(s, w, h, Color(theme.button_active.r, theme.button_active.g, theme.button_active.b))
            end
        end
        bodyTypeButtonB.Paint = function(s, w, h)
            if table.IsEmpty(confData.female) then
                drawBtnUi(s, w, h, Color(theme.button_inactive.r, theme.button_inactive.g, theme.button_inactive.b), true)
                return
            end

            if selectedType == "A" then
                drawBtnUi(s, w, h)
            else
                drawBtnUi(s, w, h, Color(theme.button_active.r, theme.button_active.g, theme.button_active.b))
            end
        end

        -- Adjust the position of the next element
        posW = posW
        posH = posH - 150

        -- Last Name
        local descLabel = vgui.Create( "BIOBOLT.UI.AutoSizeLabel", chpanel )
        descLabel:SetPos( sW / 2 - posW, sH / 2 - posH )
        descLabel:SetFont( "Character.Creation.Label" )
        descLabel:SetText( "DESCRIPTION" )
        descLabel:SetTextColor( Color( 255, 255, 255, 255 ) )
        descLabel:SetContentAlignment( 5 )

        local descParent = vgui.Create("DPanel", chpanel)
        descParent:SetSize(500, 200)
        descParent:SetPos(sW / 2 - posW, sH / 2 - (posH - 50))

        local descEntry = vgui.Create( "DTextEntry", descParent )
        descEntry:SetPos(10, 5)
        descEntry:SetSize( 485, 200 )
        descEntry:SetText( "" )
        descEntry:SetTextColor( Color( 255, 255, 255, 255 ) )
        descEntry:SetFont( "Character.Creation.Label" )
        descEntry:SetPlaceholderText("Description")
        descEntry:SetMultiline(true)

        local descGeneratorIcon = vgui.Create("DImage", chpanel)
        descGeneratorIcon:SetPos(sW / 2 - posW + 485, sH / 2 - posH + 30)
        descGeneratorIcon:SetSize(16, 16)
        descGeneratorIcon:SetImage("materials/biobolt_ui/icons/32/magic_wand_test.png")
        descGeneratorIcon:SetMouseInputEnabled(true)
        descGeneratorIcon:SetTooltip("Generate a random description.")
        descGeneratorIcon:SetImageColor(Color(126, 56, 158))

        descGeneratorIcon.OnMousePressed = function(s)
            local rDesc = CHARACTER.RandomDescription()
            descEntry:SetText(rDesc)
        end

        descGeneratorIcon.Think = function(s)
            if s:IsHovered() then
                s:SetImage("materials/biobolt_ui/icons/32/magic_wand_hover.png")
            else
                s:SetImage("materials/biobolt_ui/icons/32/magic_wand_test.png")
            end
        end

        --[HEIGHT SLIDER]
        -- Main slider background
        local sliderW = sW / 2
        local sliderH = sH / 2 - 250

        --[[
            Values to put slider in the model panel
            local sliderW = sW / 2 + 270
            local sliderH = sH - 460
        ]]

        local heightLabel = vgui.Create( "BIOBOLT.UI.AutoSizeLabel", chpanel )
        heightLabel:SetPos( sliderW, sliderH - 50 )
        heightLabel:SetFont( "Character.Creation.Label" )
        heightLabel:SetText( "HEIGHT" )
        heightLabel:SetTextColor( Color( 255, 255, 255, 255 ) )

        local sliderBG = vgui.Create("DPanel", chpanel)
        sliderBG:SetSize(30, 300)
        sliderBG:SetPos(sliderW, sliderH)
        sliderBG.Paint = function(self, w, h)
            draw.RoundedBox( 0, 0, 0, 5, h, Color( 255, 255, 255) )
            draw.RoundedBox( 0, w - 5, 0, 5, h, Color( 255, 255, 255) )
            draw.RoundedBox( 0, 0, 0, w, 5, Color( 255, 255, 255) )
            draw.RoundedBox( 0, 0, h - 5, w, 5, Color( 255, 255, 255) )
        end

        -- Slider handle
        local sliderHandle = vgui.Create("DPanel", sliderBG)
        sliderHandle:SetSize(30, 30)
        sliderHandle:SetPos(0, 0)
        sliderHandle.Paint = function(self, w, h)
            -- Draw rounded box that fits inside the slider sliderBG
            draw.RoundedBox( 0, 5, 5, w - 10, h - 10, Color( 241, 85, 85) )
        end

        -- Variables to keep track of dragging
        local dragging = false
        local lastY = 0
        local heightInToFT = {
            [63] = "6'3\"",
            [64] = "6'2\"",
            [65] = "6'1\"",
            [66] = "6'0\"",
            [67] = "5'11\"",
            [68] = "5'10\"",
            [69] = "5'9\"",
            [70] = "5'8\"",
            [71] = "5'7\"",
            [72] = "5'6\"",
            [73] = "5'5\"",
            [74] = "5'4\"",
            [75] = "5'3\"",
        }

        local returnValueFlip = {
            [63] = 75,
            [64] = 74,
            [65] = 73,
            [66] = 72,
            [67] = 71,
            [68] = 70,
            [69] = 69,
            [70] = 68,
            [71] = 67,
            [72] = 66,
            [73] = 65,
            [74] = 64,
            [75] = 63,
        }
        local minValue = 63
        local maxValue = 75

        -- Optionally, you can add a label to show the current value of the slider
        local labelW = sliderW + 40
        local labelH = sliderH
        local valueLabel = vgui.Create("BIOBOLT.UI.AutoSizeLabel", chpanel)
        valueLabel:SetPos(labelW, labelH)  -- Initial position next to slider handle
        valueLabel:SetFont("Character.Creation.Label")
        valueLabel:SetTextColor(Color(255, 255, 255, 255))
        valueLabel.Paint = function(self, w, h)
            -- Draw white outline box
            surface.SetDrawColor(255, 255, 255)
            surface.DrawOutlinedRect(0, 0, w, h, 2)
        end



        local function getGlobalCursorPos()
            return gui.MousePos()
        end

        sliderHandle.OnMousePressed = function(self, keyCode)
            if keyCode == MOUSE_LEFT then
                dragging = true
                local x, y = getGlobalCursorPos()
                lastY = y
            end
        end

        sliderHandle.OnMouseReleased = function(self, keyCode)
            if keyCode == MOUSE_LEFT then
                dragging = false
            end
        end

        function SetDefaultValue(defaultValue)
            defaultValue = math.Clamp(defaultValue, minValue, maxValue)  -- Ensure the default value is within bounds

            -- Calculate the position of the handle based on the default value
            local percentage = (defaultValue - minValue) / (maxValue - minValue)
            local newY = percentage * (sliderBG:GetTall() - sliderHandle:GetTall())

            sliderHandle:SetPos(0, newY)
            valueLabel:SetPos(labelW, labelH + newY)
            valueLabel:SetText(" " .. heightInToFT[defaultValue] .. " ")
        end

        -- Call this function with the desired default value, for example:
        SetDefaultValue(69)

        sliderHandle.Think = function(self)
            if dragging then
                local x, y = getGlobalCursorPos()
                local delta = y - lastY

                local _, curY = self:GetPos()
                local newY = curY + delta

                -- Clamp the slider handle position so it doesn't go out of bounds
                newY = math.Clamp(newY, 0, sliderBG:GetTall() - self:GetTall())

                self:SetPos(0, newY)

                -- Reposition the label next to the slider handle
                valueLabel:SetPos(labelW, labelH + newY)

                -- Reset lastY for the next frame
                lastY = y

                -- Calculate the value based on slider handle position
                local percentage = newY / (sliderBG:GetTall() - self:GetTall())
                local value = Lerp(percentage, minValue, maxValue)
                value = math.Round(value)
                valueLabel:SetText(" " .. heightInToFT[value] .. " ")

                -- Check if mouse is released and no longer hovering over the handle
                if not input.IsMouseDown(MOUSE_LEFT) then
                    dragging = false
                end
            end
        end

        local function GetCurrentValue()
            local _, curY = sliderHandle:GetPos()
            local percentage = curY / (sliderBG:GetTall() - sliderHandle:GetTall())
            local value = Lerp(percentage, minValue, maxValue)
            return returnValueFlip[math.Round(value)]
        end

        valueLabel:SetText(" " .. heightInToFT[GetCurrentValue()] .. " ")


        -- Model selection
        local modelParent = vgui.Create("DPanel", chpanel)
        modelParent:SetSize(500, 800)
        modelParent:SetPos(sW / 2 + 250, sH / 2 - 380)

        modelParent.Paint = function(s, w, h)
            -- Draw nothing here
        end

        local parentPanel = vgui.Create("DPanel", modelParent)
        parentPanel:SetSize(500, 800)
        parentPanel:SetPos(0, 0)

        -- Override the paint function for the parent panel
        local barW = 60
        parentPanel.Paint = function(self, w, h)
            -- Your custom painting here. For instance:
            draw.RoundedBox( 0, 0, 0, 5, h, Color( 255, 255, 255) )
            draw.RoundedBox( 0, w - 5, 0, 5, h, Color( 255, 255, 255) )
            draw.RoundedBox( 0, 0, 0, barW, 5, Color( 255, 255, 255) )
            draw.RoundedBox( 0, 0, h - 5, barW, 5, Color( 255, 255, 255) )
            draw.RoundedBox( 0, w - barW, 0, barW, 5, Color( 255, 255, 255) )
            draw.RoundedBox( 0, w - barW, h - 5, barW, 5, Color( 255, 255, 255) )
        end

        -- Create a DModelPanel and set the model to the first model in the table
        local currentModel = 1
        local modelPanel = vgui.Create( "DModelPanel", parentPanel )
        modelPanel:Dock(FILL)
        modelPanel:SetModel( confData.male[currentModel] )
        -- Set the model's position and angles to face the camera
        modelPanel:SetCamPos( Vector( 30, 30, 50 ) )
        modelPanel:SetLookAt( Vector( 0, 0, 40 ) )

        modelPanel.LayoutEntity = function( panel, entity )
            entity:SetAngles(Angle(0, 45, 0))
            -- Set height of the model based on the slider
            local height = (GetCurrentValue() / 69) - 0.1

            entity:SetModelScale(height, 0)
            if selectedType == "A" and not table.HasValue(confData.male, entity:GetModel()) then
                entity:SetModel(confData.male[1])
                currentModel = 1
            elseif selectedType == "B" and not table.HasValue(confData.female, entity:GetModel()) then
                entity:SetModel(confData.female[1])
                currentModel = 1
            end

            -- set sequence
            local seq = entity:LookupSequence("idle_all_01")
            entity:SetSequence(seq)
        end


        -- Create a DButton to the left-center of modelPanel
        local leftButton = vgui.Create( "DButton", chpanel )
        leftButton:SetPos( sW / 2 + 170, sH / 2 - 50 )
        leftButton:SetSize( 70, 70 )
        leftButton:SetText( "<" )
        leftButton:SetTextColor( Color( 255, 255, 255, 255 ) )
        leftButton:SetFont( "Character.Creation.BtnLbl" )

        -- Paint function for the left button
        leftButton.Paint = drawBtnUi

        -- Create a DButton to the right-center of modelPanel
        local rightButton = vgui.Create( "DButton", chpanel )
        rightButton:SetPos( sW / 2 + 760, sH / 2 - 50 )
        rightButton:SetSize( 70, 70 )
        rightButton:SetText( ">" )
        rightButton:SetTextColor( Color( 255, 255, 255, 255 ) )
        rightButton:SetFont( "Character.Creation.BtnLbl" )

        -- On left press change the model to the previous model in the table
        leftButton.DoClick = function()
            if currentModel == 1 then
                return
            end
            modelPanel:SetModel(selectedType == "A" and confData.male[currentModel - 1] or selectedType == "B" and confData.female[currentModel - 1])
            currentModel = currentModel - 1
        end

        -- On right press change the model to the next model in the table
        rightButton.DoClick = function()
            local max = selectedType == "A" and #confData.male or selectedType == "B" and #confData.female
            if currentModel == max then
                return
            end
            -- Set model to next one and lower the string
            local model = selectedType == "A" and confData.male[currentModel + 1] or selectedType == "B" and confData.female[currentModel + 1]
            modelPanel:SetModel(model:lower())
            currentModel = currentModel + 1
        end

        -- Paint function for the right button
        rightButton.Paint = drawBtnUi


        -- Apply Paint functions
        firstNameParent.Paint = drawBoxUI
        jobParent.Paint = drawBoxUI
        firstNameEntry.Paint = drawTextBox

        lastNameParent.Paint = drawBoxUI
        lastNameEntry.Paint = drawTextBox

        descParent.Paint = drawBoxUI
        descEntry.Paint = drawTextBox

        -- Create a button near the bottom and center styled like the other buttons
        local createButton = vgui.Create( "DButton", chpanel )
        createButton:SetPos( sW / 2 - 100, sH - 140 )
        createButton:SetSize( 200, 60 )
        createButton:SetText( "CREATE" )
        createButton:SetTextColor( Color( 255, 255, 255, 255 ) )
        createButton:SetFont( "Character.Creation.BtnLbl" )

        -- Paint function for the create button
        createButton.Paint = function(s, w, h)

            draw.RoundedBox( 0, 0, 0, 5, h, Color( 255, 255, 255) )
            draw.RoundedBox( 0, w - 5, 0, 5, h, Color( 255, 255, 255) )
            draw.RoundedBox( 0, 0, 0, 40, 5, Color( 255, 255, 255) )
            draw.RoundedBox( 0, 0, h - 5, 40, 5, Color( 255, 255, 255) )
            draw.RoundedBox( 0, w - 40, 0, 40, 5, Color( 255, 255, 255) )
            draw.RoundedBox( 0, w - 40, h - 5, 40, 5, Color( 255, 255, 255) )
            s:SetTextColor( col or Color( 255, 255, 255, 255 ) )

            if s:IsHovered() then
                draw.RoundedBox( 0, 0, 0, 5, h, Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b) )
                draw.RoundedBox( 0, w - 5, 0, 5, h, Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b) )
                draw.RoundedBox( 0, 0, 0, w, 5, Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b) )
                draw.RoundedBox( 0, 0, h - 5, w, 5, Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b) )
                s:SetTextColor( Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b) )
            end
        end

        createButton.DoClick = function()
            local firstName = firstNameEntry:GetText()
            local lastName = lastNameEntry:GetText()
            local desc = descEntry:GetText()
            local height = GetCurrentValue()
            local model = modelPanel:GetModel()
            local bodyType = selectedType == "A" and 1 or selectedType == "B" and 2 or false

            if firstName == "" or lastName == "" or desc == "" then
                return
            end

            if dropDownSelectedValue == false then
                return
            end

            CHARACTER.OpenLoadingScreen()

            local teamIndex = getTeamIndexByName(dropDownSelectedValue)

            if not teamIndex then return end

            timer.Simple(10, function()
                CHARACTER.CloseLoadingScreen()
            end)
            net.Start("ATLAS::Characters::CreateChar")
            net.WriteTable({
                first_name = firstName,
                last_name = lastName,
                description = desc,
                height = height,
                preferred_model = model,
                type = bodyType,
                team = teamIndex
            })
            net.SendToServer()
        end

        local backButton = vgui.Create( "DButton", chpanel )
        backButton:SetPos( sW / 2 - 100, sH - 65 )
        backButton:SetSize( 200, 60 )
        backButton:SetText( "BACK" )
        backButton:SetTextColor( Color( 255, 255, 255, 255 ) )
        backButton:SetFont( "Character.Creation.BtnLbl" )

        -- Paint function for the create button
        backButton.Paint = function(s, w, h)

            draw.RoundedBox( 0, 0, 0, 5, h, Color( 255, 255, 255) )
            draw.RoundedBox( 0, w - 5, 0, 5, h, Color( 255, 255, 255) )
            draw.RoundedBox( 0, 0, 0, 40, 5, Color( 255, 255, 255) )
            draw.RoundedBox( 0, 0, h - 5, 40, 5, Color( 255, 255, 255) )
            draw.RoundedBox( 0, w - 40, 0, 40, 5, Color( 255, 255, 255) )
            draw.RoundedBox( 0, w - 40, h - 5, 40, 5, Color( 255, 255, 255) )
            s:SetTextColor( col or Color( 255, 255, 255, 255 ) )

            if s:IsHovered() then
                draw.RoundedBox( 0, 0, 0, 5, h, Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b) )
                draw.RoundedBox( 0, w - 5, 0, 5, h, Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b) )
                draw.RoundedBox( 0, 0, 0, w, 5, Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b) )
                draw.RoundedBox( 0, 0, h - 5, w, 5, Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b) )
                s:SetTextColor( Color(theme.button_hover.r, theme.button_hover.g, theme.button_hover.b) )
            end
        end

        backButton.DoClick = function()
            CHARACTER.CloseCharCreation()
            CHARACTER.OpenCharScreen()
        end

        if isEdit then
            -- fill in the data with the current character
            firstNameEntry:SetText(charData.first_name)
            lastNameEntry:SetText(charData.last_name)
            descEntry:SetText(charData.description)
            SetDefaultValue(returnValueFlip[charData.height])
            modelPanel:SetModel(charData.preferred_model)
            selectedType = charData.type == 1 and "A" or charData.type == 2 and "B" or false

            local teamName = RPExtraTeams[job].name
            dropDownSelectedValue = teamName
            dropDownButton:SetText(teamName)

            createButton:SetText("SAVE")
            createButton.DoClick = function()
                local firstName = firstNameEntry:GetText()
                local lastName = lastNameEntry:GetText()
                local desc = descEntry:GetText()
                local height = GetCurrentValue()
                local model = modelPanel:GetModel()
                local bodyType = selectedType == "A" and 1 or selectedType == "B" and 2 or false

                if firstName == "" or lastName == "" or desc == "" then
                    return
                end

                if dropDownSelectedValue == false then
                    return
                end

                CHARACTER.OpenLoadingScreen()

                local teamIndex = getTeamIndexByName(dropDownSelectedValue)

                if not teamIndex then return end

                timer.Simple(10, function()
                    CHARACTER.CloseLoadingScreen()
                end)
                net.Start("ATLAS::Characters::EditChar")
                -- Write table of old data 
                net.WriteTable({
                    first_name = charData.first_name,
                    last_name = charData.last_name,
                    description = charData.description,
                    height = charData.height,
                    preferred_model = charData.preferred_model,
                    type = charData.type,
                    team = tonumber(charData.team),
                })
                net.WriteTable({
                    first_name = firstName,
                    last_name = lastName,
                    description = desc,
                    height = height,
                    preferred_model = model,
                    type = bodyType,
                    team = teamIndex,
                })
                net.SendToServer()
            end
        end


        -- Panel paint function
        chpanel.Paint = function(s, w, h)
            -- [Background] Draw the background image
            surface.SetDrawColor(theme.bg_color.r, theme.bg_color.g, theme.bg_color.b, 255)
            surface.DrawRect(0, 0, w, h)
        end

        local bodyTypeBUnavalUnder = vgui.Create( "BIOBOLT.UI.AutoSizeLabel", chpanel )
        bodyTypeBUnavalUnder:SetPos( sW / 2 - 678, sH / 2 - 28 )
        bodyTypeBUnavalUnder:SetFont( "Character.Creation.LabelSmall" )
        bodyTypeBUnavalUnder:SetText( "BODY TYPE B NOT AVAILABLE FOR THIS JOB" )
        bodyTypeBUnavalUnder:SetTextColor( Color( 14, 14, 15) )
        bodyTypeBUnavalUnder:SetVisible(false)

        local bodyTypeBUnaval = vgui.Create( "BIOBOLT.UI.AutoSizeLabel", chpanel )
        bodyTypeBUnaval:SetPos( sW / 2 - 680, sH / 2 - 30 )
        bodyTypeBUnaval:SetFont( "Character.Creation.LabelSmall" )
        bodyTypeBUnaval:SetText( "BODY TYPE B NOT AVAILABLE FOR THIS JOB" )
        bodyTypeBUnaval:SetTextColor( Color( 255, 213, 79) )
        bodyTypeBUnaval:SetVisible(false)



        local infoIcon = vgui.Create("DImage", chpanel)
        infoIcon:SetPos(sW / 2 - 700, sH / 2 - 30)
        infoIcon:SetSize(16, 16)
        infoIcon:SetImage("materials/biobolt_ui/icons/16/warning.png")
        infoIcon:SetVisible(false)

        chpanel.Think = function()
            if table.IsEmpty(confData.female) then
                bodyTypeBUnavalUnder:SetVisible(true)
                bodyTypeBUnaval:SetVisible(true)
                infoIcon:SetVisible(true)
            else
                bodyTypeBUnavalUnder:SetVisible(false)
                bodyTypeBUnaval:SetVisible(false)
                infoIcon:SetVisible(false)
            end
        end

        -- Enable Keyboard and Mouse
        chpanel:MakePopup()

    end)
    end)
end

-- Close character creation screen
function CHARACTER.CloseCharCreation()
    if CHARACTER.CharCreationScreen then
        CHARACTER.CharCreationScreen:Remove()
        CHARACTER.CharCreationScreen = false
        gui.EnableScreenClicker(false)
    end
end
