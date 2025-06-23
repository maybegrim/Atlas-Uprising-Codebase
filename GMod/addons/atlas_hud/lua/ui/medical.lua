print("MEDICAL")

local sw, sh = ScrW(), ScrH()

local padding = sw * .025
local offset = sw * .01
local spacing = sw * .005      

local mainCol = Color(183, 35, 35)
local backCol = Color(255, 255, 255, 10)
local barBackCol = Color(50, 50, 50, 100)

local gradientRight = Material("vgui/gradient-r.png")
local weaponWidth, weaponHeight = sw * .1, sh * .2
local weaponDrawHeight = sh * .03
local weaponHighlightW, weaponHightlightH = weaponWidth, weaponHeight * .18
local weaponStartX, weaponStartY = sw - sw * .01 - weaponWidth, sh * .045

function drawSCPHUDMedical()
    local p = IsValid(LocalPlayer()) and LocalPlayer()
    if !p:Alive() then return end
    
    if not ATLASMED.BONES.AreLegsBroken(p) then
        return
    end
    local hudX, hudY = getHUDPositionXY()
    weaponStartX, weaponStartY = hudX + sw * .49 - weaponWidth, hudY - sh * .100
    
    local wep = p:GetActiveWeapon()
    local wepName = string.upper(wep:GetPrintName())

    local currentAmmo = wep:Clip1()
    local maxAmmo = wep:GetMaxClip1()
    local reserveAmmo = p:GetAmmoCount(wep:GetPrimaryAmmoType())

    local mat = Matrix()
    mat:Translate(Vector(sw/2, sh/2))
    mat:Rotate(Angle(0,-2,0))
    mat:Scale(Vector(1,1,1))
    mat:Translate(-Vector(sw/2, sh/2))

    local flashAlpha = 150 + math.abs(math.sin(CurTime() * 5) * 155)

    cam.PushModelMatrix(mat)
        surface.SetMaterial(gradientRight)
        surface.SetDrawColor(Color(255, 255, 255, 15))
        surface.DrawTexturedRect(weaponStartX - offset * .5, weaponStartY + offset * .5, weaponWidth, weaponHightlightH)
        surface.SetDrawColor(Color(255, 255, 255, 55))
        surface.DrawTexturedRect(weaponStartX, weaponStartY, weaponWidth, weaponHightlightH)
        draw.SimpleText("LEGS: BROKEN", "Mono30", weaponStartX - padding * .3 + weaponWidth, weaponStartY + padding * .3, backCol, 2, 0)
        draw.SimpleText("LEGS: BROKEN", "Mono30", weaponStartX - padding * .1 + weaponWidth, weaponStartY + padding * .1, Color(183, 35, 35, flashAlpha), 2, 0)
    cam.PopModelMatrix()

end

hook.Add("HUDPaint", "cl.scphud.medical.hudpaint", function()
    drawSCPHUDMedical()
end)
