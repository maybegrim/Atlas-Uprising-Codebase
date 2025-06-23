include("shared.lua")

function SWEP:DrawHUD()
    for i, ply in pairs(player.GetAll()) do
        if not LocalPlayer():HasWeapon("AU_scp096_swep") then continue end
        if not ply:GetNWBool("SCP:096SAWFACE", false) then continue end
        local pos = ply:GetPos() + Vector(0, 0, 80) -- Adjust for player height
        local screenPos = pos:ToScreen() -- Convert the 3D position to 2D screen coordinates
        surface.SetDrawColor(255, 0, 0, 255)
        surface.DrawRect(screenPos.x - 5, screenPos.y - 5, 30, 30)
    end
end --adasdasdasdda

function SWEP:PrimaryAttack() end

function SWEP:SecondaryAttack() end