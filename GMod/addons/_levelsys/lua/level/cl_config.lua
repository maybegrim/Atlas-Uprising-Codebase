-- UI for config

-- default values
LEVEL.CFG.ConfValues = {
    MaxLevel = 100,
    XPPerLevel = 1000,
    XPForActivity = 100,
    ActivityCooldown = 60,
    XPForNPCKill = 100,
}

-- UI to change config values
function LEVEL.ConfigUI()
    local tempConfValue = table.Copy(LEVEL.CFG.ConfValues)
    local frame = vgui.Create("DFrame")
    frame:SetSize(400, 400)  -- Increased size for better spacing
    frame:Center()
    frame:SetTitle("Level System Configuration")
    frame:SetDraggable(true)
    frame:ShowCloseButton(true)
    frame:MakePopup()
    frame.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(45, 45, 48))
    end
    
    -- Create a scroll panel for better UI management
    local scrollPanel = vgui.Create("DScrollPanel", frame)
    scrollPanel:Dock(FILL)
    scrollPanel:DockMargin(10, 10, 10, 10)
    scrollPanel.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(37, 37, 38))
    end
    
    for key, value in pairs(tempConfValue) do
        local panel = vgui.Create("DPanel", scrollPanel)
        panel:Dock(TOP)
        panel:DockMargin(5, 5, 5, 5)
        panel:SetTall(40)
        panel.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(37, 37, 38))
        end

        local warningLabel = vgui.Create("DLabel", scrollPanel)
        warningLabel:Dock(TOP)
        warningLabel:SetWide(150)  -- Wider for better visibility
        warningLabel:SetText("Not saved, you must press enter for it to save.")
        warningLabel:SetFont("DermaDefaultBold")
        warningLabel:SetTextColor(Color(255, 0, 0))
        warningLabel:DockMargin(15, 1, 10, 1)
        warningLabel:SetVisible(false)
        
        local label = vgui.Create("DLabel", panel)
        label:Dock(LEFT)
        label:SetWide(150)  -- Wider for better visibility
        label:SetText(key)
        label:SetFont("DermaDefaultBold")
        label:SetTextColor(Color(255, 255, 255))
        label:DockMargin(10, 10, 10, 10)

        
        local textEntry = vgui.Create("DTextEntry", panel)
        textEntry:Dock(FILL)
        textEntry:SetText(value)
        textEntry:DockMargin(10, 5, 10, 5)
        textEntry:SetTextColor(Color(255, 255, 255))
        textEntry.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(28, 28, 28))
            self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
        end
        textEntry.AllowInput = function(self, char)
            return not tonumber(char)  -- Ignore non-numeric input
        end
        textEntry.OnChange = function(self)
            if tonumber(textEntry:GetValue()) != tempConfValue[key] then
                warningLabel:SetVisible(true)
            else
                warningLabel:SetVisible(false)
            end
        end
        textEntry.OnEnter = function(self)
            tempConfValue[key] = tonumber(textEntry:GetValue())
            warningLabel:SetVisible(false)
        end
    end
    
    local buttonPanel = vgui.Create("DPanel", frame)
    buttonPanel:Dock(BOTTOM)
    buttonPanel:SetTall(40)
    buttonPanel:DockMargin(10, 10, 10, 10)
    buttonPanel.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(45, 45, 48))
    end
    
    local saveButton = vgui.Create("DButton", buttonPanel)
    saveButton:Dock(RIGHT)
    saveButton:SetWide(100)
    saveButton:SetText("Save")
    saveButton:DockMargin(10, 5, 10, 5)
    saveButton:SetTextColor(Color(255, 255, 255))
    saveButton.Paint = function(self, w, h)
        if self:IsHovered() then
            draw.RoundedBox(4, 0, 0, w, h, Color(30, 30, 30))
        else
            draw.RoundedBox(4, 0, 0, w, h, Color(28, 28, 28))
        end
    end
    saveButton.DoClick = function()
        for key, value in pairs(LEVEL.CFG.ConfValues) do
            local newValue = tempConfValue[key]
            --print(value, newValue)
            if value != newValue then
                net.Start("LEVEL::Config::Save")
                net.WriteString(key)
                net.WriteString(tostring(newValue))
                net.SendToServer()
                chat.AddText("[LEVEL] Requested to save config value "..key.." with value "..tostring(newValue)..".")

                LEVEL.CFG.ConfValues[key] = newValue
            end
        end
    end
    local cancelButton = vgui.Create("DButton", buttonPanel)
    cancelButton:Dock(LEFT)
    cancelButton:SetWide(100)
    cancelButton:SetText("Cancel")
    cancelButton:DockMargin(10, 5, 10, 5)
    cancelButton:SetTextColor(Color(255, 255, 255))
    cancelButton.Paint = function(self, w, h)
        if self:IsHovered() then
            draw.RoundedBox(4, 0, 0, w, h, Color(30, 30, 30))
        else
            draw.RoundedBox(4, 0, 0, w, h, Color(28, 28, 28))
        end
    end
    cancelButton.DoClick = function()
        frame:Close()
    end
end


concommand.Add("level_config", LEVEL.ConfigUI)