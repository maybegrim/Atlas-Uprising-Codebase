include("shared.lua")

local materialPath = "materials/memorial/maurice.png" -- Path to the material created from your PNG
local woodMaterial = "models/props/de_nuke/pipeset_metal"
function ENT:DrawTranslucent()
    -- Do not draw the model
end
function ENT:Draw()
    --self:DrawModel() -- Draw the model (make sure it's transparent or not visible)
    
    local pos = self:GetPos()
    local ang = self:GetAngles()

    cam.Start3D2D(pos, Angle(0, ang.y, 90), 1)
        render.SuppressEngineLighting(true) -- Disable lighting
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(Material(materialPath))
        surface.DrawTexturedRect(-10, -7.5, 20, 15)
        -- add a wooden frame around the image
        surface.SetMaterial(Material(woodMaterial))
        surface.DrawTexturedRect(-10, -7.5, 20, 1)
        surface.DrawTexturedRect(-10, 7.5, 20, 1)
        surface.DrawTexturedRect(-10, -7.5, 1, 15)
        surface.DrawTexturedRect(9, -7.5, 1, 15)
        render.SuppressEngineLighting(false) -- Enable lighting
    cam.End3D2D()
end
