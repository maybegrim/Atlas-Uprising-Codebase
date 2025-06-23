include("shared.lua")

local ScrambleMode = 0
local isCooldown = false
local progressStart = 0
local SCRAMBLE_ACTIVE_DURATION = 15
local SCRAMBLE_COOLDOWN_DURATION = 120

function ENT:Draw()
    self:SetNoDraw(false)
    self:DrawModel()
end

local ScrWidth, ScrHeight = ScrW(), ScrH()

local ScrambleMode = 0 -- 0 = No Goggles | 1 = Goggles Enabled | 2 = Goggles Disabled

surface.CreateFont("ScrambleGoggleToggle", {

    font = "Arial", -- 
	extended = false,
	size = 40,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,

})

hook.Add("HUDPaint", "DrawScrambleStatus", function()

    -- Don't draw any text if they don't have goggles
    if ScrambleMode == 0 then
        return
    end

    surface.SetFont("ScrambleGoggleToggle")
    local timePassed = CurTime() - progressStart
    local barWidth = 200
    local barHeight = 20
    local barX = ScrWidth * 0.80 - barWidth / 2
    local barY = ScrHeight * 0.85

    if ScrambleMode == 1 then
        local progress = math.Clamp(timePassed / SCRAMBLE_ACTIVE_DURATION, 0, 1)
        surface.SetDrawColor(0, 255, 0, 160)
        surface.DrawRect(barX, barY, barWidth * progress, barHeight)

        surface.SetTextColor(0, 255, 0)
        surface.SetTextPos(barX, barY + barHeight + 5)
        surface.DrawText("Scramble Enabled")

    elseif isCooldown then
        local progress = math.Clamp(timePassed / SCRAMBLE_COOLDOWN_DURATION, 0, 1)
        surface.SetDrawColor(255, 255, 0, 160)
        surface.DrawRect(barX, barY, barWidth * (1 - progress), barHeight)

        surface.SetTextColor(255, 255, 0)
        surface.SetTextPos(barX, barY + barHeight + 5)
        surface.DrawText("Cooldown")
    end
	
	if ScrambleMode == 2 and not isCooldown then
		surface.SetTextColor(255, 0, 0)
		surface.SetTextPos(barX, barY + barHeight + 5)
		surface.DrawText("Scramble Disabled")
    end
end)


net.Receive("SCP096ScrambleToggle", function()
    ScrambleMode = net.ReadUInt(4)
    progressStart = CurTime()
end)

net.Receive("SCP096ScrambleCooldown", function()
    isCooldown = net.ReadBool()
    if isCooldown then
        progressStart = CurTime()
    end
end)

