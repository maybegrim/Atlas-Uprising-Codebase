include("shared.lua")

local SWEP = SWEP
SWEP.ColorModifyCVAR = CreateConVar("fv_scp682_colormodify", 1, FCVAR_ARCHIVE, "Modify the colors of the screen when playing SCP-682")

local MaskMat =			Material("fv_addons/682_mask.png", "smooth")
local KeyMat =			Material("fv_addons/682_key.png")
local LeftMouseMat =	Material("fv_addons/682_leftmouse.png")
local RightMouseMat =	Material("fv_addons/682_rightmouse.png")
local RedColor = 		Color(255, 0, 0)
local color_white = 	color_white

local function CreateFonts()
	surface.CreateFont("FV:SCP682:HUD", {
		font = "Roboto",
		size = 18 * ScrH()/1080
	})
end
CreateFonts()
hook.Add("OnScreenSizeChanged", "FV:SCP682:Fonts", CreateFonts)

sound.Add( {
	name = "scp682_walk",
	channel = CHAN_STATIC,
	volume = 1,
    level = 100,
	sound = "fv_addons/682_walk.wav"
})

local Lang = {
	["fr"] = {
		["loading"] = "Chargement...",
		["breaking_door"] = "Destruction de la porte...",
		["size"] = "Taille: %G",
		["passive"] = "Vous êtes dans un état passif !",
		["roar"] = "Rugir",
		["attack"] = "Attaquer",
		["break_door"] = "Défoncer une porte"
	},
	["en"] = {
		["loading"] = "Loading...",
		["breaking_door"] = "Breaking the door...",
		["size"] = "Size: %G",
		["passive"] = "You are in a passive state !",
		["roar"] = "Roar",
		["attack"] = "Attack",
		["break_door"] = "Break down a door"
	},
	["es-ES"] = {
		["loading"] = "Cargando...",
		["breaking_door"] = "Rompiendo la puerta...",
		["size"] = "Talla: %G",
		["passive"] = "¡Estás en un estado pasivo !",
		["roar"] = "Rugido",
		["attack"] = "Atacar",
		["break_door"] = "Romper una puerta"
	},
	["ru"] = {
		["loading"] = "загрузка...",
		["breaking_door"] = "Взламываю дверь...",
		["size"] = "размер: %G",
		["passive"] = "Вы находитесь в пассивном состоянии !",
		["roar"] = "рычать",
		["attack"] = "Атаковать",
		["break_door"] = "сломать дверь"
	}
}

local CurLang = GetConVar("gmod_language"):GetString()
cvars.AddChangeCallback("gmod_language", function(name, old, new)
    CurLang = new
end)

local function L(path)
	return Lang[Lang[CurLang] and CurLang or "en"][path]
end

local function DrawProgress(x, y, radius, text, percent) -- From Wk
	local col = 255 - percent * 255

    render.SetScissorRect(x - radius, y - radius + radius * 2 * ( 1 - percent ), x + radius, y + radius * 2, true)
    draw.RoundedBox(radius, x - radius, y - radius, radius * 2, radius * 2, Color(col, col, col)) -- More efficient than draw.Circle (And I don't want to use a Lib, even if Sneaky's Circle Lib is fucking good)
    render.SetScissorRect(0, 0, 0, 0, false)
	
	draw.SimpleText(text, "FV:SCP682:HUD", x, y + radius + 2, nil, TEXT_ALIGN_CENTER)
end

local function DrawKey(x, y, key, text)
	if key then
		key = string.upper(input.GetKeyName(input.GetKeyCode(key)))
	else
		key = "?"
	end

	local sH = 28 * ScrH()/1080
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(KeyMat)
	surface.DrawTexturedRect(x, y, sH, sH)
	
	draw.SimpleText(key, "FV:SCP682:HUD", x + sH/2, y + sH/2, nil, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(text, "FV:SCP682:HUD", x + sH + sH/4, y + sH/2, nil, nil, TEXT_ALIGN_CENTER)
	
	return sH
end

local function DrawMouse(x, y, side, text)
	local sH = 28 * ScrH()/1080
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(side == LEFT and LeftMouseMat or RightMouseMat)
	surface.DrawTexturedRect(x, y, sH, sH)
	
	draw.SimpleText(text, "FV:SCP682:HUD", x + sH + sH/4, y + sH/2, nil, nil, TEXT_ALIGN_CENTER)
	
	return sH
end

-- Remove default fire sounds
function SWEP:PrimaryAttack() end
function SWEP:SecondaryAttack() end

function SWEP:DrawHUD()
	-- Progress bar
	if self:GetAttacking() then
		local AttackTime = self.AttackSeqDur * self.AttackPercentage
		local AttackElapsed = CurTime() - self:GetAttackTime()
		
		if AttackElapsed <= AttackTime then
			local Status = AttackElapsed/AttackTime
			DrawProgress(ScrW()/2, ScrH()/2, ScrH() * 0.025, L("loading"), Status)
		end
	elseif self:GetDestroying() then
		local DestroyElapsed = CurTime() - self:GetDestroyTime()
		local Status = DestroyElapsed/SWEP.DestroyTimeCVAR:GetFloat()
		DrawProgress(ScrW()/2, ScrH()/2, ScrH() * 0.025, L("breaking_door"), Status)
	end
	
	local RespX, RespY = ScrW()/1920, ScrH()/1080
	local x, y, w, h = 25 * RespX, ScrH()/3 - 37.3 * RespY, 153 * RespX, 74 * RespY
	
	-- Show 682's size
	surface.SetMaterial(MaskMat)
	surface.SetDrawColor(0, 0, 0)
	surface.DrawTexturedRect(x, y, w, h)
	
	render.SetScissorRect(x, y + (1 - self:GetSizePercentage()) * h, x + w, y + h, true)
		surface.SetDrawColor(255, 0, 0)
		surface.DrawTexturedRect(x, y, w, h)
    render.SetScissorRect(0, 0, 0, 0, false)
	
	local _, th = draw.SimpleText(string.format(L("size"), math.Round(self:GetSCPSize(), 2)), "FV:SCP682:HUD", x, y + h, nil)
	if self:IsPassive() then
		draw.SimpleText(L("passive"), "FV:SCP682:HUD", x, y + h + th, RedColor)
	end
	
	-- Info about keys
	local sH = DrawKey(x, y + h + th * 3, input.LookupBinding("reload"), L("roar"))
	sH = sH + DrawMouse(x, y + h + th * 3 + sH + 7 * RespY, LEFT, L("attack"))
	
	if SWEP.DoorDestroyCVAR:GetBool() then
		DrawMouse(x, y + h + th * 3 + sH + 7 * 2 * RespY, RIGHT, L("break_door"))
	end
end

-- Add a bloody effect when using the swep
local ColModifier = {
	["$pp_colour_addr"] = 0.0125,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1.2,
	["$pp_colour_mulr"] = 0.4,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}
hook.Add("RenderScreenspaceEffects", "FV:SCP682", function()
	if not SWEP.ColorModifyCVAR:GetBool() then return end
	local wep = LocalPlayer():GetActiveWeapon()
	if not wep:IsValid() or wep:GetClass() ~= "fv_scp682" then return end

	DrawColorModify(ColModifier)
end)

-- Function Removed
--[[net.Receive("FV:DestroyDoor", function(len)
	local door = net.ReadEntity()
	if not IsValid(door) then return end

	door:EmitSound(SWEP.DestroySound, 90)
	ParticleEffect(SWEP.DestroyParticle, door:GetPos(), angle_zero)

	local calcPos = net.ReadVector()
	local calcAngle = net.ReadAngle()

	local detail = ents.CreateClientProp()
	detail:SetPos(calcPos)
	detail:SetAngles(calcAngle)
	detail:SetModel(door:GetModel())
	detail:Spawn()

	timer.Simple(SWEP.RespawnTimeCVAR:GetFloat(), function()
		if IsValid(detail) then
			detail:Remove()
		end
	end)
end)]]