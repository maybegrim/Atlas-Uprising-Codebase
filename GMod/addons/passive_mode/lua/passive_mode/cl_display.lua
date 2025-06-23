if not CLIENT then return end

hook.Add("HUDPaint", "PassiveMode.Display", function ()
    local lply = LocalPlayer()

    if lply:InPassiveMode() then
        draw.SimpleTextOutlined("Passive Mode Enabled", "DermaLarge", ScrW() / 2, 100, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
    end
end)

timer.Create("PassiveMode.PlayerUpdate", 1, 0, function ()
    if not LocalPlayer then return end
    
    local lply = LocalPlayer()
    
    if not IsValid(lply) then return end

    if lply:InPassiveMode() then
        for _,ply in ipairs(player.GetAll()) do
            local color = ply:GetColor()
            ply:SetColor(Color(color.r, color.g, color.b, 255))
        end
    else
        for _,ply in ipairs(player.GetAll()) do
            local color = ply:GetColor()
            if ply:InPassiveMode() then
                ply:SetColor(Color(color.r, color.g, color.b, 150))       
                ply:SetRenderMode(RENDERMODE_TRANSCOLOR)         
            else
                ply:SetColor(Color(color.r, color.g, color.b, 255))
            end
        end
    end
end)

hook.Add("PostDrawTranslucentRenderables", "AU.BombCollar.DisplayCollars", function ()
    local ply = LocalPlayer()

    for _,p in ipairs(player.GetAll()) do
        if p:InPassiveMode() then
            local pos = p:GetPos()

            local dist = pos:Distance(ply:GetPos())

            if dist > 400 then continue end
            
            pos = pos + Vector(0, 0, 100)

            local ang = ply:GetAngles()

            ang:RotateAroundAxis(ang:Forward(), 90);
            ang:RotateAroundAxis(ang:Right(), 90);

            ang.z = 90

            cam.Start3D2D(pos, ang, 0.2)
                draw.SimpleTextOutlined("Passive", "DermaLarge", 0, 0, Color(200, 200, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0))
            cam.End3D2D()
        end
    end
end)