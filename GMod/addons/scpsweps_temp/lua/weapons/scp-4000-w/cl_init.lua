include("shared.lua")

function SWEP:DrawHUD()
    if self:GetDrawMat()  then
        surface.SetMaterial(Material("Models/effects/comball_sphere"))
        surface.SetDrawColor(255, 191, 0)
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    end
end

function SWEP:PrimaryAttack()
    return false
end

function SWEP:SecondaryAttack()
    return false
end
