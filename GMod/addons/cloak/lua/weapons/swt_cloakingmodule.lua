--[[
	=================================================
	███████╗██╗    ██╗████████╗    ██████╗███╗   ███╗
	██╔════╝██║    ██║╚══██╔══╝   ██╔════╝████╗ ████║
	███████╗██║ █╗ ██║   ██║█████╗██║     ██╔████╔██║
	╚════██║██║███╗██║   ██║╚════╝██║     ██║╚██╔╝██║
	███████║╚███╔███╔╝   ██║      ╚██████╗██║ ╚═╝ ██║
	╚══════╝ ╚══╝╚══╝    ╚═╝       ╚═════╝╚═╝     ╚═╝
	=================================================
	-> Shadow-Trooper Cloaking Module

	_______________________________
	Created by
		- Speedcup (https://steamcommunity.com/id/speedcup/ - 76561198261053079)
		- Schmockwurst (https://steamcommunity.com/id/schmockwurst/ - 76561198197583550)
]]

--[[-------------------------------------------------------------------
    SWT-CM - Weapon
--]]-------------------------------------------------------------------

AddCSLuaFile()

SWEP.PrintName = "SWT Cloaking Module"
SWEP.Category = "[SW:RP] Speedcup & Schmockwurst"

SWEP.Author = "Speedcup & Schmockwurst"
SWEP.Purpose = "You can now cloak yourself! Like a real SWT! HOW COOL?!"
SWEP.Instructions = "LeftClick: Cloak / Uncloak\nRightClick: Scan a Player/NPC!\nReload: Toggle Hud"

SWEP.HoldType = "passive"

SWEP.Slot = 2
SWEP.SlotPos = 100

SWEP.Spawnable = true

SWEP.ViewModel = ""
SWEP.WorldModel = "models/Items/combine_rifle_ammo01.mdl"
SWEP.ViewModelFOV = 54
SWEP.UseHands = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false

SWEP.HitDistance = 0

function SWEP:Initialize()
	if SERVER then
		SWT_CM:Cloak(self:GetOwner(), false)
		self:SetHoldType( "normal" )
	end
end

function SWEP:OnRemove()
	if SERVER then
		if self:GetOwner():IsCloaked() then
			SWT_CM:Cloak(self:GetOwner(), false)
		end
	end
end

SWEP.PrimaryCooldown = 0
function SWEP:PrimaryAttack()
	if self.PrimaryCooldown < CurTime() and SWT_CM:CanCloak(self:GetOwner()) then
		if SERVER then
			local ply = self:GetOwner()
			SWT_CM:Cloak(ply)
		end

		self.PrimaryCooldown = CurTime() + SWT_CM.Config.DefaultSWEPCooldown
	end
end

SWEP.SecondaryCooldown = 0
function SWEP:SecondaryAttack()
	if SERVER then return end

	if self.SecondaryCooldown < CurTime() then
		local trace = LocalPlayer():GetEyeTrace()
		local ent = trace.Entity

		-- IDEA
		-- Im not sure, should we only allow relationship additions (basically scanning) while in ESP Mode? (Maybe ill create a poll in further future)
		--[[
			if not LocalPlayer():HasESPEnabled() then
				SWT_CM:Print("You've to activate your ESP module, to be able to scan people!", "error", true)
				return
			end
		]]
		if IsValid(ent) and LocalPlayer():GetPos():Distance(ent:GetPos()) <= SWT_CM.Config.ESPDistance then
			LocalPlayer():AddToRelations(ent)
		elseif IsValid(ent) and LocalPlayer():GetPos():Distance(ent:GetPos()) >= SWT_CM.Config.ESPDistance then
			SWT_CM:Print("The player / npc you are currently looking at is too far away from you!", "error", true)
		else
			SWT_CM:Print("You have to look at a player / npc in front of you!", "error", true)
		end

		self.SecondaryCooldown = CurTime() + SWT_CM.Config.DefaultSWEPCooldown
	end
end

SWEP.ReloadCooldown = 0
function SWEP:Reload()
	if self.ReloadCooldown < CurTime() then
		if SERVER then
			local ply = self:GetOwner()
			SWT_CM:ChangeESP( ply )
		end

		self.ReloadCooldown = CurTime() + SWT_CM.Config.DefaultSWEPCooldown
	end
end