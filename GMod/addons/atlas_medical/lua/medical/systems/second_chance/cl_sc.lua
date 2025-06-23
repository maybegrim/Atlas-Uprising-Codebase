ATLASMED.SC = ATLASMED.SC or {}

local res_mat = Material("atlas_medical/secondchance/revive.png")
local backGround = Material("atlas_medical/defibs/blur_strong.png")
local isRes, isKill = false, false
local progress_sound = false

surface.CreateFont("ATLASMED.SecondChance", {
    font = "MADE Tommy Soft",
    size = 18,
    weight = 500
})

local function getDistUnits(ply)
    local ragdoll = ply:GetNWEntity("DeathRagdoll")
    if not IsValid(ragdoll) then return nil end

    local pos = ragdoll:GetPos()
    local dist = LocalPlayer():GetPos():Distance(pos)
    if dist > 1000000 then return nil end

    return dist, dist / 24
end

local function startSound()
    if progress_sound then return end
    sound.PlayFile("sound/atlas_medical/secondchance/progress.wav", "mono", function(station)
        if IsValid(station) then
            station:SetVolume(1)
            station:Play()
            progress_sound = station
        end
    end)
end

local function endSound()
    if not progress_sound then return end
    progress_sound:Stop()
    progress_sound = false
end

function ATLASMED.SC.startRevive(ply)
    local startTime = CurTime()
    local endTime = startTime + 3
    isRes = true

    hook.Add("HUDPaint", "SC.DrawReviveUI", function()
        ATLASMED.SC.drawReviveUI(startTime, endTime, ply)
    end)

    startSound()
    timer.Create("ATLAS.SecondChance.ReviveTimer", 3, 1, function()
        if not IsValid(ply) then return end
        if ply:Alive() then
            ATLASMED.SC.cancelRevive()
            return
        end

        net.Start("ATLAS.SecondChance.Revive")
            net.WriteEntity(ply)
        net.SendToServer()

        ATLASMED.SC.cancelRevive()
    end)

end

function ATLASMED.SC.cancelRevive()
    hook.Remove("HUDPaint", "SC.DrawReviveUI")
    -- Added delay for server to network
    timer.Simple(0.5, function()
        isRes = false
    end)
    endSound()
    if timer.Exists("ATLAS.SecondChance.ReviveTimer") then
        timer.Remove("ATLAS.SecondChance.ReviveTimer")
    end
end

function ATLASMED.SC.isResurrecting()
    return isRes
end

function ATLASMED.SC.isKilling()
    return isKill
end

function ATLASMED.SC.startKill(ply)
    local startTime = CurTime()
    local endTime = startTime + 3
    isKill = true

    hook.Add("HUDPaint", "SC.DrawKillUI", function()
        ATLASMED.SC.drawReviveUI(startTime, endTime, ply, true)
    end)

    startSound()

    timer.Create("ATLAS.SecondChance.KillTimer", 3, 1, function()
        if not IsValid(ply) then return end
        if ply:Alive() then
            ATLASMED.SC.cancelKill()
            return
        end

        net.Start("ATLAS.SecondChance.Kill")
            net.WriteEntity(ply)
        net.SendToServer()

        ATLASMED.SC.cancelKill()
    end)
end

function ATLASMED.SC.cancelKill()
    hook.Remove("HUDPaint", "SC.DrawKillUI")
    -- Added delay for server to network
    timer.Simple(0.5, function()
        isKill = false
    end)
    endSound()
    if timer.Exists("ATLAS.SecondChance.KillTimer") then
        timer.Remove("ATLAS.SecondChance.KillTimer")
    end
end

function ATLASMED.SC.drawReviveUI(startT, endT, ply, isKill)
    local dist, distFeet = getDistUnits(ply)
    if not dist then return end

    local ragdoll = ply:GetNWEntity("DeathRagdoll")
    if not IsValid(ragdoll) then return end
    if dist > 1000000 then return end

    if distFeet > 20 then
        return
    end

    local baseHeight = 30
    local size = math.Round(math.max(80 - (dist / 100) * 10, 10))

    local heightOffset = 50
    local heartPos = Vector(0, 0, baseHeight + heightOffset)

    -- Set pos height to static once we're close enough
    if distFeet < 3 then
        heartPos.z = 20
    end
    
    cam.Start2D()
        local heartScreenPos = (ragdoll:GetPos() + heartPos):ToScreen()

        surface.SetMaterial(backGround)
        surface.SetDrawColor(Color(250, 45, 45))
        local bgSW, bgSH = size * 2, size * 2
        surface.DrawTexturedRect(heartScreenPos.x - (bgSW / 4), heartScreenPos.y - (bgSH / 4), bgSW, bgSH)

        surface.SetDrawColor(255, 255, 255, 220)
        surface.SetMaterial(res_mat)
        surface.DrawTexturedRect(heartScreenPos.x, heartScreenPos.y, size, size)

        local textPos = Vector(heartScreenPos.x + (size / 2), heartScreenPos.y + size, 0)
        draw.SimpleText(isKill and "Killing" or "Reviving", "ATLASMED.SecondChance", textPos.x + 2, textPos.y + 22, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText(isKill and "Killing" or "Reviving", "ATLASMED.SecondChance", textPos.x, textPos.y + 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        local progress = math.Clamp((CurTime() - startT) / (endT - startT), 0, 1)
        local barWidth = 100
        local barHeight = 10
        local barX = textPos.x - (barWidth / 2)
        local barY = textPos.y + 40
        local barColor = Color(224, 62, 62)
        local barOutlineColor = Color(47, 48, 74)
        local barOutlineThickness = 2

        draw.RoundedBox(0, barX, barY, barWidth, barHeight, barOutlineColor)
        draw.RoundedBox(0, barX + barOutlineThickness, barY + barOutlineThickness, (barWidth - (barOutlineThickness * 2)) * progress, barHeight - (barOutlineThickness * 2), barColor)
    cam.End2D()
end

local function drawTextWithShadow(text, font, x, y, color, shadowColor, alignX, alignY)
    draw.SimpleText(text, font, x + 2, y + 2, shadowColor, alignX, alignY)
    draw.SimpleText(text, font, x, y, color, alignX, alignY)
end

local function drawReviveUIForPlayer(ply)
    local ragdoll = ply:GetNWEntity("DeathRagdoll")
    if not IsValid(ragdoll) then return end

    local pos = ragdoll:GetPos()
    local distFeet = LocalPlayer():GetPos():Distance(pos) / 24

    if distFeet > 20 then return end

    local font = distFeet < 15 and "DefibFontLarge" or "DefibFontMedium"
    local size = math.Round(math.max(80 - (distFeet * 100) / 30, 10))
    local heartPos = Vector(0, 0, 30 + math.sin(CurTime() * 4) * 10)

    if distFeet < 3 then
        heartPos.z = 20
    end

    cam.Start2D()
        local heartScreenPos = (pos + heartPos):ToScreen()

        surface.SetMaterial(backGround)
        surface.SetDrawColor(Color(250, 45, 45))
        surface.DrawTexturedRect(heartScreenPos.x - size / 2, heartScreenPos.y - size / 2, size * 2, size * 2)

        surface.SetDrawColor(255, 255, 255, 220)
        surface.SetMaterial(res_mat)
        surface.DrawTexturedRect(heartScreenPos.x, heartScreenPos.y, size, size)

        local textPos = Vector(heartScreenPos.x + size / 2, heartScreenPos.y + size, 0)
        drawTextWithShadow(math.Round(distFeet) .. " ft", font, textPos.x, textPos.y, Color(255, 255, 255, 255), Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        if distFeet < 3 then
            drawTextWithShadow("Hold [G] to revive", "ATLASMED.SecondChance", textPos.x, textPos.y + 20, Color(255, 255, 255, 255), Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            drawTextWithShadow("Hold [T] to kill", "ATLASMED.SecondChance", textPos.x, textPos.y + 40, Color(255, 255, 255, 255), Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        end
    cam.End2D()
end

hook.Add("HUDPaint", "SC.ShowReviveUI", function()
    if LocalPlayer():HasWeapon("weapon_defibrillator") then return end
    if ATLASMED.SC.isResurrecting() then return end
    if ATLASMED.SC.isKilling() then return end

    for _, ply in ipairs(player.GetAll()) do
        if ply == LocalPlayer() then continue end
        if ply:GetNWBool("ATLASMED.SC.Down", false) and not ply:Alive() then
            drawReviveUIForPlayer(ply)
        end
    end
end)


hook.Add("Think", "SC.RevivePlayer", function()
    local isKeyDown = input.IsKeyDown(KEY_G)

    if not isKeyDown then
        if ATLASMED.SC.isResurrecting() then
            ATLASMED.SC.cancelRevive()
        end
        return
    end
    for _, ply in ipairs(player.GetAll()) do
        if ply:GetNWBool("ATLASMED.SC.Down", false) and not ply:Alive() then
            local _, distFeet = getDistUnits(ply)
            if not distFeet or distFeet >= 3 then
                if ATLASMED.SC.isResurrecting() then
                    ATLASMED.SC.cancelRevive()
                end
                return
            end

            if isKeyDown and not ATLASMED.SC.isResurrecting() then
                ATLASMED.SC.startRevive(ply)
            end
        end
    end
end)

-- We need a kill player code now. Button is T
hook.Add("Think", "SC.KillPlayer", function()
    local isKeyDown = input.IsKeyDown(KEY_T)

    if not isKeyDown then
        if ATLASMED.SC.isKilling() then
            ATLASMED.SC.cancelKill()
        end
        return
    end

    for _, ply in ipairs(player.GetAll()) do
        if ply:GetNWBool("ATLASMED.SC.Down", false) and not ply:Alive() then
            local _, distFeet = getDistUnits(ply)
            if not distFeet or distFeet >= 3 then
                return
            end

            if isKeyDown and not ATLASMED.SC.isKilling() then
                ATLASMED.SC.startKill(ply)
            end
        end
    end
end)

net.Receive("ATLAS.SecondChance.Msg", function()
    local msg = net.ReadString()

    chat.AddText(Color(225, 55, 55), ":drop_of_blood: ", Color(246, 73, 73), msg)
end)