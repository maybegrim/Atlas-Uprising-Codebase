local rulesUI = false

local rules = {
    "No racism, sexism, or homophobia.",
    "No toxicity or harassment.",
    "Avoid sensitive topics. (Politics, Religion, etc.)",
    "No cheating, exploiting, or hacking.",
    "No extremely derogatory language.",
}

-- Function to calculate font size based on screen height
local function getFontSize(baseSize)
    return math.floor(ScrH() * (baseSize / 1080))  -- assuming 1080p as base resolution
end

-- Update font creation with dynamic sizes
surface.CreateFont("WELCOMEUI:RULES:RuleFont", {
    font = "Tahoma",
    extended = false,
    size = getFontSize(32),
    weight = 700,
})

surface.CreateFont( "WELCOMEUI:RULES:RuleTitle", {
    font = "Tahoma",
    extended = false,
    size = getFontSize(36),
    weight = 700,
} )

surface.CreateFont( "WELCOMEUI:RULES:NoteFont", {
    font = "Tahoma",
    extended = false,
    size = getFontSize(18),
    weight = 700,
} )

surface.CreateFont( "WELCOMEUI:RULES:BtnSmall", {
    font = "Verdana",
    extended = false,
    size = getFontSize(16),
    weight = 700,
} )
surface.CreateFont( "WELCOMEUI:RULES:BtnLarge", {
    font = "Verdana",
    extended = false,
    size = getFontSize(20),
    weight = 700,
} )

function WELCOMEUI.ShowRules()
    if rulesUI then
        rulesUI:Close()
    end
    local sW, sH = ScrW(), ScrH()
    local frame = vgui.Create("DFrame")
    frame:SetSize(sW, sH)
    frame:Center()
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:MakePopup()
    frame:SetDraggable(false)
    frame.Paint = function(self, w, h)
        surface.SetDrawColor(0, 0, 0)

        surface.DrawRect(0, 0, w, h)
    end

    rulesUI = frame

    local logo = vgui.Create("DImage", frame)
    local logoSize = sH * 0.4
    logo:SetSize(logoSize, logoSize * 0.35)  -- Maintain aspect ratio
    logo:CenterHorizontal(0.49)
    logo:AlignTop(sH * 0.2)  -- Adjust ratio as needed
    logo:SetImage("branding/atlas_logo.png") -- Replace with the path to your logo


    local label = vgui.Create("DLabel", frame)
    label:SetFont("WELCOMEUI:RULES:RuleTitle")
    label:SetText("SERVER RULES")
    label:SizeToContents()
    label:CenterHorizontal()
    label:AlignTop(sH * 0.36)
    label:SetTextColor(Color(255, 255, 255))


    --[[local note = vgui.Create("DLabel", frame)
    note:SetFont("WELCOMEUI:RULES:NoteFont")
    note:SetText("Our server takes the above rules extremely seriously. If you break any of these rules, you will NOT be given a second chance.")
    note:SizeToContents()
    note:CenterHorizontal()
    note:AlignTop(sH * 0.61)
    note:SetTextColor(Color(255, 66, 66))]]

    -- Create a panel to hold the label
    local notePanel = vgui.Create("DPanel", frame)
    notePanel:SetSize(sW * 0.5, sH * 0.05)  -- Set the size based on screen size
    notePanel:CenterHorizontal()
    notePanel:AlignTop(sH * 0.60)
    notePanel.Paint = function(self, w, h)  -- Draw the background of the panel
        draw.RoundedBox(0, 0, 0, w, h, Color(27, 27, 27))
    end

    -- Create the label
    local note = vgui.Create("DLabel", notePanel)
    note:SetFont("WELCOMEUI:RULES:NoteFont")
    note:SetText("Our server takes the above rules extremely seriously. If you break any of these rules, you will NOT be given a second chance.")
    note:SizeToContents()
    note:CenterHorizontal()
    note:CenterVertical()
    note:SetTextColor(Color(255, 66, 66))


    local moreRules = vgui.Create("DLabel", frame)
    moreRules:SetFont("WELCOMEUI:RULES:NoteFont")
    moreRules:SetText("NOTICE: This is not a complete list of rules. Type !rules in chat when you load in for the full list.")
    moreRules:SizeToContents()
    -- Make responsive
    moreRules:CenterHorizontal()
    moreRules:AlignBottom(sH * 0.2)
    moreRules:SetTextColor(Color(255, 255, 255))

    local rulesLabels = {}
    for i, rule in ipairs(rules) do
        rulesLabels[i] = vgui.Create("DLabel", frame)
        rulesLabels[i]:SetFont("WELCOMEUI:RULES:RuleFont")
        rulesLabels[i]:SetText("• " .. rule)
        rulesLabels[i]:SizeToContents()
        rulesLabels[i]:CenterHorizontal(0.49)
        rulesLabels[i]:SetTextColor(Color(255, 255, 255))
        -- Space the labels out vertically
        local ruleSpacing = sH * 0.01  -- Adjust ratio as needed
        if i == 1 then
            rulesLabels[i]:AlignTop(sH * 0.4)
        else
            local x, y = rulesLabels[i-1]:GetPos()
            local _, h = rulesLabels[i-1]:GetSize()
            rulesLabels[i]:SetPos(x, y + h + ruleSpacing)
        end
    end

    local button = vgui.Create("DButton", frame)
    button:SetSize(sW * 0.4, sH * 0.05)  -- Set the size based on screen size
    button:CenterHorizontal()
    button:AlignBottom(sH * 0.29)
    button:SetText("")
    
    local holdTime = 5 -- time in seconds
    local heldSince = 0
    
    button.Paint = function(s, w, h)
        -- Draw base button color
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255))
    
        if s:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, Color(231, 231, 231))
        end

        if s:IsDown() and heldSince > 0 then
            local holdPercentage = math.Clamp((SysTime() - heldSince) / holdTime, 0, 1)
    
            draw.RoundedBox(0, 0, 0, w, h, Color(42, 42, 42))
            -- Draw progress color
            draw.RoundedBox(0, 0, 0, w * holdPercentage, h, Color(115, 115, 115, 255))
        end
    
        -- Draw button text
        draw.SimpleText("I agree that if I break the rules and get caught by a staff member or am reported by players;", "WELCOMEUI:RULES:BtnSmall", w / 2, h / 4, s:IsDown() and Color(255,255,255) or Color(70, 70, 70), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("My account will be PERMANENTLY banned from the server", "WELCOMEUI:RULES:BtnLarge", w / 2, h / 1.5, Color(248, 45, 45), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    button.Think = function(s)
        if s:IsDown() then
            if heldSince == 0 then
                heldSince = SysTime()
            elseif SysTime() - heldSince >= holdTime then
                heldSince = 0
                net.Start("WELCOMEUI::RulesReply")
                net.WriteBool(true)
                net.SendToServer()
                -- Hide all frame children
                for _, child in pairs(frame:GetChildren()) do
                    if IsValid(child) then
                        child:SetVisible(false)
                    end
                end
                timer.Simple(0.1, function()
                    rulesUI:Close()
                    rulesUI = false
                end)
            end
        else
            heldSince = 0
        end
    end
    

    local rejectButton = vgui.Create("DButton", frame)
    rejectButton:SetSize(sW * 0.4, sH * 0.05)  -- Set the size based on screen size
    rejectButton:CenterHorizontal()
    rejectButton:AlignBottom(sH * 0.23)
    rejectButton:SetText("")

    local holdTimeReject = 3 -- time in seconds
    local heldSinceReject = 0

    rejectButton.Paint = function(s, w, h)
        -- Draw base button color
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255))

        if s:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, Color(231, 231, 231))
        end

        if s:IsDown() and heldSinceReject > 0 then
            local holdPercentage = math.Clamp((SysTime() - heldSinceReject) / holdTimeReject, 0, 1)

            draw.RoundedBox(0, 0, 0, w, h, Color(42, 42, 42))
            -- Draw progress color
            draw.RoundedBox(0, 0, 0, w * holdPercentage, h, Color(245, 73, 73))
        end

        -- Draw button text
        draw.SimpleText("I Reject", "WELCOMEUI:RULES:BtnLarge", w / 2, h / 2, s:IsDown() and Color(255,255,255) or Color(29, 29, 29), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    rejectButton.Think = function(s)
        if s:IsDown() then
            if heldSinceReject == 0 then
                heldSinceReject = SysTime()
            elseif SysTime() - heldSinceReject >= holdTimeReject then
                heldSinceReject = 0
                net.Start("WELCOMEUI::RulesReply")
                net.WriteBool(false)
                net.SendToServer()
                frame:Close()
            end
        else
            heldSinceReject = 0
        end
    end

end

function WELCOMEUI.CloseRules()
    if rulesUI then
        rulesUI:Close()
        rulesUI = false
    end
end
