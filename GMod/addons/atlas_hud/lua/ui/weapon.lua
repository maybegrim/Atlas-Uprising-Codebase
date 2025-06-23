local sw, sh = ScrW(), ScrH()

local padding = sw * .025
local offset = sw * .01
local spacing = sw * .005      

local mainCol = Color(255, 255, 255, 255)
local backCol = Color(255, 255, 255, 10)
local barBackCol = Color(50, 50, 50, 100)

local gradientRight = Material("vgui/gradient-r.png")
local weaponWidth, weaponHeight = sw * .2, sh * .2
local weaponDrawHeight = sh * .03
local weaponHighlightW, weaponHightlightH = weaponWidth, weaponHeight * .18
local weaponStartX, weaponStartY = sw - sw * .01 - weaponWidth, sh * .035

function createSCPHUDCustomWeaponSelectPanel()

    local p = IsValid(LocalPlayer()) and LocalPlayer()

    local wsPanel = wsPanel or vgui.Create("DPanel")
    wsPanel.ID = 1
    wsPanel.wsLabels = {}
    wsPanel:SetPos(weaponStartX, weaponStartY + weaponHightlightH + offset * .5)
    wsPanel:SetSize(weaponWidth, weaponHeight)
    wsPanel:SetVisible(false)
    wsPanel.Paint = function(s, w, h)

    end
    wsPanel.Think = function(s)
        s.wepTable = p:GetWeapons()
        if p.weaponSelectTimer != nil and p.weaponSelectTimer <= CurTime() then
            s:SetVisible(false)
        end
        if !p:Alive() then
            s:SetVisible(false)
        end

        local tbl = p:GetWeapons()
        wsPanel:SetTall(#tbl * weaponDrawHeight)

        if !p:Alive() then return end
        local wep = p:GetActiveWeapon()
        if !IsValid(wep) then return end
        local ammo = wep:GetMaxClip1()
        if ammo > 0 then
            wsPanel:SetPos(weaponStartX, weaponStartY + weaponHightlightH * 2.5 + offset * .5)
        else
            wsPanel:SetPos(weaponStartX, weaponStartY + weaponHightlightH + offset * .5)
        end
    end
    wsPanel.createLabels = function()
        local tbl = p:GetWeapons()
        local font
        for k, v in ipairs(tbl) do
            local label = wsPanel.wsLabels[k] or vgui.Create("DPanel", wsPanel)
            label:Dock(TOP)
            label:SetTall(weaponDrawHeight)
            label.Paint = function(s, w, h)
                local mat = Matrix()
                mat:Translate(Vector(sw/2, sh/2))
                mat:Rotate(Angle(0,-2,0))
                mat:Scale(Vector(1,1,1))
                mat:Translate(-Vector(sw/2, sh/2))
                cam.PushModelMatrix(mat)

                if IsValid(v) then
                    if wsPanel.ID == k then
                        font = "Mono35"
                    else
                        font = "Mono25"
                    end
                    local wep = string.upper(v:GetPrintName())
                    draw.SimpleText(wep, font, w - w * .01, h * .5, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                    draw.SimpleText(wep, font, w - w * .01 - h * .2, h * .5 + h * .2, backCol, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                end

                cam.PopModelMatrix()
            end

            wsPanel.wsLabels[k] = label
        end
    end

    wsPanel.getSelectedWeapon = function()
        local tbl = p:GetWeapons()
        return tbl[wsPanel.ID]
    end

    wsPanel.drawWeapons = function()
        wsPanel.createLabels()
    end

    p.weaponPanel = wsPanel
end

function drawSCPHUDCustomWeaponSelect()

    local p = IsValid(LocalPlayer()) and LocalPlayer()
    if !p:Alive() then return end
    if !IsValid(p:GetActiveWeapon()) then return end

    local hudX, hudY = getHUDPositionXY()
    weaponStartX, weaponStartY = hudX + sw * .49 - weaponWidth, hudY - sh * .865
    
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

    cam.PushModelMatrix(mat)
        surface.SetMaterial(gradientRight)
        surface.SetDrawColor(Color(255, 255, 255, 15))
        surface.DrawTexturedRect(weaponStartX - offset * .5, weaponStartY + offset * .5, weaponWidth, weaponHightlightH)
        surface.SetDrawColor(Color(255, 255, 255, 55))
        surface.DrawTexturedRect(weaponStartX, weaponStartY, weaponWidth, weaponHightlightH)
        draw.SimpleText(wepName, "Mono30", weaponStartX - padding * .3 + weaponWidth, weaponStartY + padding * .3, backCol, 2, 0)
        draw.SimpleText(wepName, "Mono30", weaponStartX - padding * .1 + weaponWidth, weaponStartY + padding * .1, mainCol, 2, 0)

        if maxAmmo > 0 then
            surface.SetDrawColor(Color(255, 255, 255, 15))
            surface.DrawTexturedRect(weaponStartX + weaponWidth - weaponWidth * .3 - offset * .5, weaponStartY + weaponHightlightH + padding * .3 + offset * .5, weaponWidth * .3, weaponHightlightH)
            surface.SetDrawColor(Color(255, 255, 255, 55))
            surface.DrawTexturedRect(weaponStartX + weaponWidth - weaponWidth * .3 , weaponStartY + weaponHightlightH + padding * .3, weaponWidth * .3, weaponHightlightH)

            local ammoText = currentAmmo .. " / " .. reserveAmmo
            draw.SimpleText(ammoText, "Mono30", weaponStartX - padding * .3 + weaponWidth, weaponStartY + weaponHightlightH + padding * .3 + padding * .3, backCol, 2, 0)
            draw.SimpleText(ammoText, "Mono30", weaponStartX - padding * .1 + weaponWidth, weaponStartY + weaponHightlightH + padding * .3 + padding * .1, mainCol, 2, 0)
        end
    cam.PopModelMatrix()

end

hook.Add("InitPostEntity", "cl.scphud.main.create.weapon.select.panel", function()
    timer.Simple(1, function() createSCPHUDCustomWeaponSelectPanel() end)
end)

hook.Add("PlayerBindPress", "cl.main.detect.bind.press", function(p, bind, bool, code)

    if not IsValid(p) or not IsValid(p.weaponPanel) then return end
    if !p:Alive() then return end

    local tbl = p:GetWeapons()
    local count = #tbl

    p.weaponPanel:InvalidateLayout()
    if bind == "invnext" or bind == "invprev" then

        local activeWeapon = p:GetActiveWeapon()
        
        local activeWeaponClass = IsValid(activeWeapon) and activeWeapon:GetClass() or ""
        local isAttackPressed = p.isAttackBindPressed and true or false
        if activeWeaponClass == "weapon_physgun" and isAttackPressed then
            return true // If a player is scrolling with physgun, we skip the rest of the code
        end

        p.weaponSelectTimer = CurTime() + 2

        if not p.weaponPanel:IsVisible() then
            p.weaponPanel:SetVisible(true)
            p.weaponPanel:drawWeapons()
        elseif p.weaponPanel:IsVisible() then
            if bind == "invnext" then
                p.weaponPanel.ID = math.min(p.weaponPanel.ID + 1, count)
                surface.PlaySound("uiscroll.wav")
            elseif bind == "invprev" then
                p.weaponPanel.ID = math.max(p.weaponPanel.ID - 1, 1)
                surface.PlaySound("uiscroll.wav")
            end
        end
    end

    if bind == "+attack" and p.weaponPanel:IsVisible() then
        local id = p.weaponPanel.ID
        local wep = p.weaponPanel.getSelectedWeapon()
        net.Start("SCPHUDWeaponChangeNetMessage")
            net.WriteEntity(wep) -- Adjust the bit count based on your needs
        net.SendToServer()
        surface.PlaySound("uiclick.wav")
        p.weaponPanel:SetVisible(false)
        return true
    end
end)

local function updateWeaponPanel()
    local p = LocalPlayer()
    if not IsValid(p) or not IsValid(p.weaponPanel) then return end
    p.weaponPanel:InvalidateLayout()
    p.weaponPanel:drawWeapons()
end

local function checkNewWeapon()
    local p = LocalPlayer()
    if not IsValid(p) or not IsValid(p.weaponPanel) or not p.weaponPanel:IsVisible() then return end
    local tbl = p:GetWeapons()
    local count = #tbl
    if count ~= p.weaponPanel.weaponCount then
        updateWeaponPanel()
        p.weaponPanel.weaponCount = count
    end
end

hook.Add("Think", "cl.scphud.weapon.checknewweapon", checkNewWeapon)



hook.Add("Think", "cl.scphud.weaponwheel.checkmouse1", function() //This checks if the player has their +Attack bind in
    local p = IsValid(LocalPlayer()) and LocalPlayer()
    if !IsValid(p) then return end
    local b = p:KeyDown( IN_ATTACK )
    p.isAttackBindPressed = b
end)

hook.Add("HUDPaint", "cl.scphud.weapon.hudpaint", function()
    drawSCPHUDCustomWeaponSelect()
end)
