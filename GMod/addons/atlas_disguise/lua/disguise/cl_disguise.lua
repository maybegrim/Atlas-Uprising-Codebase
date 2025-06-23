-- Variables to hold the models and current index
local function GetAvailableModels()
    local ply = LocalPlayer()
    if not IsValid(ply) then return {} end
    
    -- Check player's faction
    local job = ply:getJobTable()
    if not job then return {} end
    
    if job.faction == "FOUNDATION" then
        return ADQ.CONF.FoundationModels
    elseif job.faction == "CHAOS" then
        return ADQ.CONF.ChaosModels
    end
    
    return {}
end

-- Custom fonts
surface.CreateFont("ADQ_UI_Title", {
    font = "Roboto",
    size = 30,
    weight = 500,
})

surface.CreateFont("ADQ_UI_Button", {
    font = "Roboto",
    size = 22,
    weight = 400,
})

-- Click and hover sounds
local clickSound = Sound("atlas_audio/ui/click2.mp3")
local hoverSound = Sound("atlas_audio/ui/click.mp3")

-- Function to open the model selection UI
local function OpenModelSelectUI(ent)
    local availableModels = GetAvailableModels()
    local modelKeys = table.GetKeys(availableModels)
    local currentIndex = 1

    -- Blur the background
    local blurPanel = vgui.Create("DPanel")
    blurPanel:SetSize(ScrW(), ScrH())
    blurPanel:Center()
    blurPanel.Paint = function(self, w, h)
        Derma_DrawBackgroundBlur(self, 0)
    end

    -- Create the frame for the UI
    local frame = vgui.Create("DFrame")
    frame:SetTitle("") -- Remove the default title
    frame:SetSize(500, 600)
    frame:Center()
    frame:MakePopup()
    frame.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Color(35, 35, 35, 240)) -- Custom background color
        draw.SimpleText("Model Selection", "ADQ_UI_Title", w / 2, 25, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end

    frame.OnClose = function()
        blurPanel:Remove() -- Remove the blur panel when the frame closes
    end

    -- Model panel to display the model
    local modelPanel = vgui.Create("DModelPanel", frame)
    modelPanel:SetSize(450, 450) -- Increased the size for a bigger display
    modelPanel:SetPos(25, 20) -- Adjusted position to center it more
    modelPanel:SetModel(modelKeys[currentIndex]) -- Set initial model
    modelPanel:SetFOV(55) -- Lower FOV for a closer look at the model
    modelPanel:SetCamPos(Vector(70, 0, 50)) -- Adjust the camera position to zoom in more
    modelPanel:SetLookAt(Vector(0, 0, 60)) -- Adjust the look-at point to center the model vertically

    modelPanel.LayoutEntity = function() return end -- Stop model rotation

    -- Function to add hover effects to buttons with hover sound
    local function AddHoverEffect(button, normalColor, hoverColor)
        local isHovered = false
        button.Paint = function(self, w, h)
            if self:IsHovered() then
                draw.RoundedBox(4, 0, 0, w, h, hoverColor)
                if not isHovered then
                    isHovered = true
                    surface.PlaySound(hoverSound) -- Play hover sound once on hover
                end
            else
                draw.RoundedBox(4, 0, 0, w, h, normalColor)
                isHovered = false
            end
        end
    end

    -- Previous model button
    local prevButton = vgui.Create("DButton", frame)
    prevButton:SetText("<")
    prevButton:SetFont("ADQ_UI_Button")
    prevButton:SetSize(60, 40)
    prevButton:SetPos(50, 540)
    prevButton:SetTextColor(Color(255, 255, 255))

    -- Add hover effect to previous button
    AddHoverEffect(prevButton, Color(60, 60, 60, 200), Color(100, 100, 100, 255))

    prevButton.DoClick = function()
        currentIndex = currentIndex - 1
        if currentIndex < 1 then
            currentIndex = #modelKeys
        end
        modelPanel:SetModel(modelKeys[currentIndex]) -- Update model
        surface.PlaySound(clickSound) -- Play click sound
    end

    -- Next model button
    local nextButton = vgui.Create("DButton", frame)
    nextButton:SetText(">")
    nextButton:SetFont("ADQ_UI_Button")
    nextButton:SetSize(60, 40)
    nextButton:SetPos(390, 540)
    nextButton:SetTextColor(Color(255, 255, 255))

    -- Add hover effect to next button
    AddHoverEffect(nextButton, Color(60, 60, 60, 200), Color(100, 100, 100, 255))

    nextButton.DoClick = function()
        currentIndex = currentIndex + 1
        if currentIndex > #modelKeys then
            currentIndex = 1
        end
        modelPanel:SetModel(modelKeys[currentIndex]) -- Update model
        surface.PlaySound(clickSound) -- Play click sound
    end

    if LocalPlayer():GetNWBool("ADQ_Disguised") then
        local resetButton = vgui.Create("DButton", frame)
        resetButton:SetText("Reset Model")
        resetButton:SetFont("ADQ_UI_Button")
        resetButton:SetSize(150, 40)
        resetButton:SetPos(175, 490)
        resetButton:SetTextColor(Color(255, 255, 255))

        -- Add hover effect to reset button
        AddHoverEffect(resetButton, Color(150, 20, 20, 220), Color(200, 30, 30, 255))

        resetButton.DoClick = function()
            net.Start("ADQ_ResetPlayerModel")
            net.WriteEntity(ent)
            net.SendToServer()

            surface.PlaySound(clickSound) -- Play click sound
            frame:Close() -- Close the UI
        end
    else
        -- Confirm button to select the model
        local confirmButton = vgui.Create("DButton", frame)
        confirmButton:SetText("Select Outfit")
        confirmButton:SetFont("ADQ_UI_Button")
        confirmButton:SetSize(150, 40)
        confirmButton:SetPos(175, 540)
        confirmButton:SetTextColor(Color(255, 255, 255))

        -- Add hover effect to confirm button
        AddHoverEffect(confirmButton, Color(20, 150, 20, 220), Color(30, 200, 30, 255))

        confirmButton.DoClick = function()
            net.Start("ADQ_SetPlayerModel")
            net.WriteEntity(ent)  -- The locker entity
            net.WriteString(modelKeys[currentIndex])  -- The selected model path
            net.SendToServer()

            surface.PlaySound(clickSound) -- Play click sound
            frame:Close() -- Close the UI
        end
    end
end

-- Bind the UI to pressing "E" on an entity
net.Receive("ADQ_OpenModelSelectUI", function()
    OpenModelSelectUI(net.ReadEntity())
end)
