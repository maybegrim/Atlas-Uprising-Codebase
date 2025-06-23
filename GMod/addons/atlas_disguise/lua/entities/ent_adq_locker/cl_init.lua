
include("shared.lua")

function ENT:Draw()
    -- if too far away, don't draw
    if LocalPlayer():GetPos():Distance(self:GetPos()) > 1000 then return end

    -- Draw nice UI above that says Armor Repair with dark background and a dark grey bar on top of that bar
    cam.Start3D2D(self:GetPos() + Vector(0, 0, 80), Angle(0, LocalPlayer():EyeAngles().yaw - 90, 90), 0.1)
        -- Increase the size of the rounded boxes by 15%
        local multiplier = 1.40
        draw.RoundedBox(0, -112.5 * multiplier, -50 * multiplier, 225 * multiplier, 100, Color(30, 30, 30, 200)) -- Dark background
        -- Draw a top bar behind the text
        draw.RoundedBox(0, -112.5 * multiplier, -50 * multiplier, 225 * multiplier, 40, Color(52, 170, 87, 200)) -- Dark grey bar
        draw.SimpleText("CITIZEN UNIFORM", "CIBoostFont", 0, -50 * multiplier, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    
        -- Draw Press E to Repair
        draw.SimpleText("Press E to Select Outfit", "CIBoostFont", 0, -17 , Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    cam.End3D2D()

    self:DrawModel()
end