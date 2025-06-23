-- Function to draw a filled circle
local function DrawFilledCircle(cx, cy, radius)
    local segments = 360
    local circle = {}

    for i = 0, segments do
        local angle = math.rad((i / segments) * 360)
        table.insert(circle, {x = cx + math.cos(angle) * radius, y = cy + math.sin(angle) * radius})
    end

    surface.DrawPoly(circle)
end

-- Function to draw half of the circle
local function DrawHalfCircle(cx, cy, radius, startAngle, endAngle)
    local segments = 50
    local arc = {}
    local step = math.rad((endAngle - startAngle) / segments)

    for i = 0, segments do
        local angle = math.rad(startAngle) + (step * i)
        table.insert(arc, {x = cx + math.cos(angle) * radius, y = cy + math.sin(angle) * radius})
    end

    local poly = {}
    table.insert(poly, {x = cx, y = cy})
    for i, point in ipairs(arc) do
        table.insert(poly, point)
    end

    surface.DrawPoly(poly)
end

SCP = SCP or {}
SCP.BreachUI = SCP.BreachUI or false
SCP.BreachUIShadow = SCP.BreachUIShadow or false

function SCP.ShowBreachUI()
    if SCP.BreachUI then
        SCP.BreachUI:Remove()
        SCP.BreachUI = false
    end
    if SCP.BreachUIShadow then
        SCP.BreachUIShadow:Remove()
        SCP.BreachUIShadow = false
    end

    local spinSpeed = 0.5

    local shadowPanel = vgui.Create("DPanel")
    shadowPanel:SetSize(260, 60)
    shadowPanel:SetPos(ScrW() / 2 - 105, 5)
    shadowPanel.Paint = function(self, w, h)
        draw.RoundedBox(50, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    SCP.BreachUIShadow = shadowPanel

    local panel = vgui.Create("EditablePanel")
    local button = vgui.Create("DButton", panel)
    SCP.BreachUI = panel
    panel:SetSize(250, 50)
    panel:SetPos(ScrW() / 2 - 100, 10)
    panel.Paint = function(self, w, h)
        local BreachTime = LocalPlayer():GetNW2Float("Atlas_Breach::QueueTime", 0)
        if BreachTime == -1 then
            SCP.HideBreachUI()
            return
        end
        local TimeLeft = BreachTime - CurTime()
        local Breached = (BreachTime == -1)
        local radius = w * 0.05
        local centerX, centerY = w * 0.11, h / 2
        local time = RealTime()

        local cornerRadius = 50
        draw.RoundedBox(cornerRadius, 0, 0, w, h, Color(27, 27, 29))

        if not Breached then
            draw.NoTexture()
            surface.SetDrawColor(64, 42, 13)
            DrawFilledCircle(centerX, centerY, radius)

            local angle = math.sin(time * spinSpeed * 2 * math.pi) * 180

            draw.NoTexture()
            surface.SetDrawColor(230, 126, 52)
            DrawHalfCircle(centerX, centerY, radius - 5, angle - 90, angle + 90)
        else
            draw.NoTexture()
            local bg_flash = math.abs(math.sin(RealTime() * 4))
            local bg_r = Lerp(bg_flash, 128, 100)
            surface.SetDrawColor(bg_r, 0, 0)
            DrawFilledCircle(centerX, centerY, radius)

            draw.NoTexture()
            local fg_flash = math.abs(math.sin(RealTime() * 4))
            local fg_r = Lerp(fg_flash, 255, 140)
            surface.SetDrawColor(fg_r, 0, 0)
            DrawFilledCircle(centerX, centerY, radius - 5)
        end

        if TimeLeft <= 0 then
            if !button:IsVisible() then
                button:SetVisible(true)
                Breached = true
            end
            return
        end

        local textX, textY = centerX + radius + 10, h / 3.5
        draw.SimpleText("Breach Time: " .. string.ToMinutesSeconds(TimeLeft), "SCP::BREACH::FONT", textX, textY, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    button:SetSize(160, 30)
    button:SetPos(45, 10)
    button:SetText("BREACH")
    button:SetFont("SCP::BREACH::FONT")
    button:SetTextColor(Color(255, 255, 255))
    button.Paint = function(self, w, h)
        local radius = w * 0.05
        local centerX, centerY = w * 0.11, h / 2
        local time = RealTime()

        local cornerRadius = 50
        draw.RoundedBox(cornerRadius, 0, 0, w, h, Color(49, 49, 62))
        self:SetTextColor(Color(255, 255, 255))

        if self:IsHovered() then
            draw.RoundedBox(cornerRadius, 0, 0, w, h, Color(142, 40, 40, 100))
            self:SetTextColor(Color(223, 58, 58))
        end
    end
    button.DoClick = function()
        net.Start("Atlas_Breach::Interactions")
            net.WriteString("breach")
        net.SendToServer()
    end

    button:SetVisible(false)

    local textUnderPanel = vgui.Create("DPanel")
    textUnderPanel:SetSize(250, 20)
    textUnderPanel:SetPos(ScrW() / 2 - 100, 70)
    textUnderPanel.Paint = function(self, w, h)
        if not SCP.BreachUI then self:Remove() return end
        if !button:IsVisible() then return end
        draw.SimpleText("Press F3 to enable mouse cursor.", "SCP::BREACH::FONT", 0, 0, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end 
end

function SCP.HideBreachUI()
    if SCP.BreachUI then
        SCP.BreachUI:Remove()
        SCP.BreachUI = false

        SCP.BreachUIShadow:Remove()
        SCP.BreachUIShadow = false
    end
end

net.Receive("Atlas_Breach::Interactions", function()
    local methods = {
        ["removemenu"] = SCP.HideBreachUI,
        ["showmenu"] = SCP.ShowBreachUI,
    }
    local method = net.ReadString()
    if methods[method] then methods[method]() end
end)     

// function SCP.GetZone(ply)
//     local sectors = {
//         LCZ = {min = Vector(-5994.059082, -6976.634277, -2764.628906), max = Vector(1469.301880, 174.464951, -1843.958740)},
//         HCZ = {min = Vector(2616.677490, -4543.010254, -1422.409058), max = Vector(4340.747559, -3389.616455, -1103.998047)},
//         garage = {min = Vector(8389.305664, -7661.439941, 5948.347168), max = Vector(12612.249023, -4067.448486, 6688.019531)},
//         surface = {min = Vector(11103.250000, -5280.382812, 7545.059082), max = Vector(12272.167969, -2292.614258, 7936.589355)}
//     }

//     if ply and ply:IsValid() then
//         ppos = ply:GetPos()
//     else
//         ppos = LocalPlayer():GetPos()
//     end

//     for sector, bounds in pairs(sectors) do
//         local min = bounds.min
//         local max = bounds.max
//         if ppos:WithinAABox(min, max) then
//             return sector, true
//         end
//     end

//     return nil, false // Should never happen if the zones were configured properly.
// end

// net.Receive("Atlas_Breach::PlaySound", function()
//     local soundfile = net.ReadInt(11)
//     if (SCP.GetZone() == "dblock") or (SCP.GetZone() == "surface") then return end
//     AAUDIO.ANNOUNCEMENTS.Play(soundfile)
// end)