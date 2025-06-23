include("shared.lua")

surface.CreateFont("CIBoostFont", {
    font = "MADE Tommy",
    size = 30,
    weight = 700,
    antialias = true,
    shadow = false
})

function ENT:Draw()
    -- if too far away, don't draw
    if LocalPlayer():GetPos():Distance(self:GetPos()) > 4000 then return end

    -- Draw nice UI above that says Armor Repair with dark background and a dark grey bar on top of that bar
    cam.Start3D2D(self:GetPos() + Vector(0, 0, 45), Angle(0, LocalPlayer():EyeAngles().yaw - 90, 90), 0.1)
        draw.RoundedBox(0, -112.5, -50, 225, 100, Color(30, 30, 30, 200)) -- Dark background
        -- Draw a top bar behind the text
        draw.RoundedBox(0, -112.5, -50, 225, 30, Color(22, 172, 209, 200)) -- Dark grey bar
        draw.SimpleText("RAID BOOST", "CIBoostFont", 0, -50, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        -- Draw Press E to Repair
        draw.SimpleText("Press E to Boost", "CIBoostFont", 0, -5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    cam.End3D2D()

    self:DrawModel()
end