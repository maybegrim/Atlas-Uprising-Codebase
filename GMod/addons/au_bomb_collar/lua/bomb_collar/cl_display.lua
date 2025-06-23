local IconBomb = Material("icons/bomb.png", "smooth")
local IconUse = Material("icons/use.png", "smooth")

--timer.Simple(20, function()
hook.Add("PostDrawTranslucentRenderables", "AU.BombCollar.DisplayCollars", function ()
    local ply = LocalPlayer()

    for _,p in ipairs(player.GetAll()) do
        if p:HasBombCollar() then
            local pos = p:GetPos()

            local dist = pos:Distance(ply:GetPos())

            if dist > 400 then continue end
            
            pos = pos + Vector(0, 0, 98)

            local ang = ply:GetAngles()

            ang:RotateAroundAxis(ang:Forward(), 90);
            ang:RotateAroundAxis(ang:Right(), 90);

            ang.z = 90

            local color = p:IsCollarDiffusible() and Color(200, 0, 0) or Color(0, 200, 0)

            cam.Start3D2D(pos, ang, 0.2)
                surface.SetDrawColor(color)
                surface.SetMaterial(IconBomb)
                surface.DrawTexturedRect(-8, 110, 16, 16)
            cam.End3D2D()
        end
    end
end)
--end)

surface.CreateFont("AU.BombCollar.Display.TamperText", {
    font = "Roboto",
    size = 22,
    antialias = true,
    weight = 300
})

surface.CreateFont("AU.BombCollar.Display.Toggle", {
    font = "Montserrat",
    size = 22,
    antialias = true,
    weight = 300
})


surface.CreateFont("AU.BombCollar.Display.Timer", {
    font = "Roboto",
    size = 40,
    antialias = true,
    weight = 300
})

hook.Add("HUDPaint", "AU.BombCollar.DisplayTamper", function ()
    local ply = LocalPlayer()

    if ply:HasBombCollar() then
        local color = ply:IsCollarDiffusible() and Color(200, 0, 0) or Color(0, 200, 0)

        surface.SetDrawColor(color)
        surface.SetMaterial(IconBomb)
        surface.DrawTexturedRect((ScrW() - 50) / 2, 100, 50, 50)

        draw.SimpleTextOutlined("Press 'R' to toggle defusal.", "AU.BombCollar.Display.Toggle", ScrW() / 2, 170, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))

        local curtime = CurTime()
        local start_time = ply:GetNWFloat("AU.BombCollar.StartDetonateTime", 0)
        
        if start_time ~= 0 and (start_time + AU.BombCollar.DetonationTime > curtime) then
            draw.SimpleTextOutlined(tostring(math.ceil((start_time + AU.BombCollar.DetonationTime) - curtime)), "AU.BombCollar.Display.Timer", ScrW() / 2, 40, Color(200, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
        end
    end

    local trace = ply:GetEyeTrace()

    if not IsValid(trace.Entity) or not trace.Entity:IsPlayer() or not trace.Entity:HasBombCollar() or trace.HitPos:DistToSqr(ply:EyePos()) > 10000 then return end

    surface.SetFont("AU.BombCollar.Display.TamperText")
    local width, height = surface.GetTextSize("Tamper with bomb collar.")

    local total_width = width + 32

    local color = trace.Entity:IsCollarDiffusible() and Color(255, 255, 255) or Color(200, 0, 0)

    surface.SetDrawColor(color)
    surface.SetMaterial(IconUse)
    surface.DrawTexturedRect(ScrW() / 2 - total_width / 2 - 16, ScrH() - 300 - 16, 32, 32)

    draw.SimpleTextOutlined("Tamper with bomb collar.", "AU.BombCollar.Display.TamperText", ScrW() / 2 - (total_width / 2) + 32, ScrH() - 300, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
end)