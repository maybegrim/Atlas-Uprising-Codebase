include("shared.lua")

local myImage = Material("materials/scp096/face.png")

function ENT:Draw()
    self:DrawModel()

    local ent = self

    local entPos = ent:GetPos() + ent:GetUp() * 9
    local entAng = ent:GetAngles()

    entAng:RotateAroundAxis(entAng:Up(), 90)
    entAng:RotateAroundAxis(entAng:Forward(), 75)

    cam.Start3D2D(entPos, entAng, 0.1)
        surface.SetMaterial(myImage)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(-55, -90, 110, 180)
    cam.End3D2D()
end
