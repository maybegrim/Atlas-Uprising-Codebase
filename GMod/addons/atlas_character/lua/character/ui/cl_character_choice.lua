
local hoverSound = Sound("atlas_audio/ui/click.mp3")
CHARACTER.JobSelectScreen = CHARACTER.JobSelectScreen or false
function CHARACTER.OpenJobSelectScreen()
    -- If the screen is already open, close it
    if CHARACTER.JobSelectScreen then
        CHARACTER.JobSelectScreen:Remove()
        CHARACTER.JobSelectScreen = false
    end

    -- Get screen dimensions
    local sW, sH = ScrW(), ScrH()

    -- Create the main panel for the UI
    CHARACTER.JobSelectScreen = vgui.Create("EditablePanel")
    local chpanel = CHARACTER.JobSelectScreen
    chpanel:SetPos(0, 0)
    chpanel:SetSize(sW, sH)

    -- Enable the cursor
    gui.EnableScreenClicker(true)

    -- Background fade logic
    local alpha = 0
    local maxAlpha = 255
    local fadeInTime = 0
    local startTime = CurTime()

    -- Panel paint function for background fade
    chpanel.Paint = function(s, w, h)
        local elapsedTime = CurTime() - startTime
        alpha = math.Clamp(elapsedTime / fadeInTime * maxAlpha, 0, maxAlpha)

        surface.SetDrawColor(CHARACTER.theme.bg_color.r, CHARACTER.theme.bg_color.g, CHARACTER.theme.bg_color.b, alpha)
        surface.DrawRect(0, 0, w, h)
    end

    -- Logo at the top
    local logo = vgui.Create("DImage", chpanel)
    logo:SetSize(240, 87)
    logo:SetPos(sW / 2 - 120, sH * 0.1)
    logo:SetImage("materials/branding/atlas_logo_small.png")

    -- Job selection text
    local selectLabel = vgui.Create("DLabel", chpanel)
    selectLabel:SetPos(sW / 2 - 300, sH * 0.25)
    selectLabel:SetSize(600, 100)
    selectLabel:SetFont("Character_Title")
    selectLabel:SetText("CHOOSE YOUR STARTING JOB")
    selectLabel:SetTextColor(Color(255, 255, 255, 255))
    selectLabel:SetContentAlignment(5)

    -- Panel size and position for job boxes
    local jobPanelSize = {w = 300, h = 600}

    -- Citizen job color
    local citizenColor = Color(49, 196, 49) -- Example color
    -- D-Class job color
    local dclassColor = Color(219, 112, 35) -- Example color

    -- Hover state for job panels
    local isCitizenHovered = false
    local isDClassHovered = false

    -- Citizen option
    local citizenPanel = vgui.Create("DPanel", chpanel)
    citizenPanel:SetPos(sW / 2 - 350, sH * 0.4)
    citizenPanel:SetSize(jobPanelSize.w, jobPanelSize.h)
    
    -- Citizen hover logic
    citizenPanel.Paint = function(s, w, h)
        if isCitizenHovered then
            -- Use the gradient if hovered
            surface.SetDrawColor(citizenColor)
            surface.SetMaterial(Material("vgui/gradient-d"))
            surface.DrawTexturedRect(0, 0, w, h)
        end
    end
    
    -- Citizen hover handling
    citizenPanel.OnCursorEntered = function()
        isCitizenHovered = true
    end
    citizenPanel.OnCursorExited = function()
        isCitizenHovered = false
    end

    -- Citizen model
    local citizenModel = vgui.Create("DModelPanel", citizenPanel)
    citizenModel:SetSize(jobPanelSize.w, jobPanelSize.h * 0.8)
    citizenModel:SetModel("models/player/Group01/male_02.mdl")
    citizenModel:SetCamPos(Vector(30, 30, 50))
    citizenModel:SetLookAt(Vector(0, 0, 40))

    citizenModel.OnCursorEntered = function()
        if not isCitizenHovered then
            surface.PlaySound(hoverSound) -- Play hover sound once on hover
        end
        isCitizenHovered = true
    end
    citizenModel.OnCursorExited = function()
        isCitizenHovered = false
    end

    -- Access the model's entity and set sequences
    local citizenEntity = citizenModel:GetEntity()
    local defaultSequence = citizenEntity:LookupSequence("idle_all_01") -- Default idle
    local crossArmsSequence = citizenEntity:LookupSequence("pose_standing_04") -- Substitute with cross arms animation
    -- Apply citizen model layout
    citizenModel.LayoutEntity = function(panel, entity)
        if isCitizenHovered and crossArmsSequence >= 0 then
            entity:SetSequence(crossArmsSequence) -- Set cross arms sequence if available
        else
            entity:SetSequence(defaultSequence) -- Default idle sequence
        end
        entity:SetAngles(Angle(0, 45, 0)) -- Keep model angle fixed
    end

    -- Citizen label
    local citizenLabel = vgui.Create("DLabel", citizenPanel)
    citizenLabel:SetPos(0, jobPanelSize.h * 0.85)
    citizenLabel:SetSize(jobPanelSize.w, 50)
    citizenLabel:SetFont("Character_Name")
    citizenLabel:SetText("Citizen")
    citizenLabel:SetTextColor(Color(255, 255, 255, 255))
    citizenLabel:SetContentAlignment(5)

    -- Citizen button logic
    citizenPanel.OnMousePressed = function()
        CHARACTER.OpenCharCreation(TEAM_CITIZEN)
        CHARACTER.CloseJobSelectScreen()
    end

    citizenModel.OnMousePressed = function()
        CHARACTER.OpenCharCreation(TEAM_CITIZEN)
        CHARACTER.CloseJobSelectScreen()
    end

    -- D-Class option
    local dclassPanel = vgui.Create("DPanel", chpanel)
    dclassPanel:SetPos(sW / 2 + 50, sH * 0.4)
    dclassPanel:SetSize(jobPanelSize.w, jobPanelSize.h)
    
    -- D-Class hover logic
    dclassPanel.Paint = function(s, w, h)
        if isDClassHovered then
            -- Use the gradient if hovered
            surface.SetDrawColor(dclassColor)
            surface.SetMaterial(Material("vgui/gradient-d"))
            surface.DrawTexturedRect(0, 0, w, h)
        end
    end
    
    -- D-Class hover handling
    dclassPanel.OnCursorEntered = function()
        isDClassHovered = true
        surface.PlaySound(hoverSound) -- Play hover sound once on hover
    end
    dclassPanel.OnCursorExited = function()
        isDClassHovered = false
    end

    -- D-Class model
    local dclassModel = vgui.Create("DModelPanel", dclassPanel)
    dclassModel:SetSize(jobPanelSize.w, jobPanelSize.h * 0.8)
    dclassModel:SetModel("models/player/cheddar/class_d/class_d_eric.mdl")
    dclassModel:SetCamPos(Vector(30, 30, 50))
    dclassModel:SetLookAt(Vector(0, 0, 40))

    dclassModel.OnCursorEntered = function()
        if not isDClassHovered then
            surface.PlaySound(hoverSound) -- Play hover sound once on hover
        end
        isDClassHovered = true
    end
    dclassModel.OnCursorExited = function()
        isDClassHovered = false
    end

    -- Access the model's entity and set sequences
    local dclassEntity = dclassModel:GetEntity()
    local dclassDefaultSequence = dclassEntity:LookupSequence("idle_all_01")
    local dclassCrossArmsSequence = dclassEntity:LookupSequence("pose_standing_04") -- Replace with cross arms animation

    -- Apply dclass model layout
    dclassModel.LayoutEntity = function(panel, entity)
        if isDClassHovered and dclassCrossArmsSequence >= 0 then
            entity:SetSequence(dclassCrossArmsSequence) -- Set cross arms sequence
        else
            entity:SetSequence(dclassDefaultSequence) -- Default idle sequence
        end
        entity:SetAngles(Angle(0, 45, 0)) -- Keep model angle fixed
    end

    -- D-Class label
    local dclassLabel = vgui.Create("DLabel", dclassPanel)
    dclassLabel:SetPos(0, jobPanelSize.h * 0.85)
    dclassLabel:SetSize(jobPanelSize.w, 50)
    dclassLabel:SetFont("Character_Name")
    dclassLabel:SetText("D-Class")
    dclassLabel:SetTextColor(Color(255, 255, 255, 255))
    dclassLabel:SetContentAlignment(5)

    -- D-Class button logic
    dclassPanel.OnMousePressed = function()
        CHARACTER.OpenCharCreation(TEAM_DCLASS)
        CHARACTER.CloseJobSelectScreen()
    end

    dclassModel.OnMousePressed = function()
        CHARACTER.OpenCharCreation(TEAM_DCLASS)
        CHARACTER.CloseJobSelectScreen()
    end

    -- Close screen function
    local closeBtn = vgui.Create("DButton", chpanel)
    closeBtn:SetPos(sW - 60, 10)
    closeBtn:SetSize(50, 50)
    closeBtn:SetText( "X" )
    closeBtn:SetFont( "Character.Creation.Label" )
    closeBtn.DoClick = function()
        CHARACTER.OpenCharScreen()
        CHARACTER.CloseJobSelectScreen()
    end

    -- CHARACTER.drawBtnUi(s, w, h, col, doNotHover)
    -- Draw the button UI
    closeBtn.Paint = function(s, w, h)
        CHARACTER.drawBtnUi(s, w, h)
    end
end

function CHARACTER.CloseJobSelectScreen()
    if CHARACTER.JobSelectScreen then
        CHARACTER.JobSelectScreen:Remove()
        CHARACTER.JobSelectScreen = false
    end
end