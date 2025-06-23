--[[
	This file has been copyrighted by Atlas Uprising.
	Do not distribute or copy any files.
]]--

local _={_="Primary",a="Secondary",b="Owner",c="Weapon"}

SWEP.Author			= "Heracles421 + Time"
SWEP.Purpose		= ""
SWEP.Category       = "Atlas Uprising - Temp SCP Sweps"
SWEP.Instructions	= "Left-Click to Kill Player.\nRight-Click to Walk faster."
SWEP.PrintName		= "SCP-682"
SWEP.Slot			= 0
SWEP.SlotPos		= 0
SWEP.HoldType		= "normal"
SWEP.Spawnable		= true
SWEP.AdminSpawnable	= true
SWEP.ISSCP 			= true
SWEP.ViewModel		= ""
SWEP.WorldModel		= ""
SWEP.DrawAmmo 		= false
SWEP.DrawCrosshair 	= true
SWEP.nextThink 		= 0

function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:Think()
	if ( !SERVER ) then return end
	if (CurTime() >= self.nextThink and self.Owner:Health() < self.Owner:GetMaxHealth()) then
		self.nextThink = CurTime() + 1
		self.Owner:SetHealth(self.Owner:Health() + 5)
	end
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )
	if (math.random(1,5) == 1) then
		self.Owner:EmitSound( "roar"..math.random(1,2)..".ogg", 100, 100, 1, CHAN_AUTO )
	end

	if ( !SERVER ) then return end
 		local trace = self.Owner:GetEyeTraceNoCursor()
			if trace.HitPos:Distance(self[_.b]:GetShootPos())<=200 then
			local intDamage = self.Owner:Health() / 10
				bullet = {}
				bullet.Num = 1
				bullet.Src = self[_.b]:GetShootPos()
				bullet.Dir = self[_.b]:GetAimVector()
				bullet.Spread = Vector(0,0,0)
				bullet.Tracer = 0
				bullet.Force = 25
				bullet.Damage = intDamage
				self[_.b]:FireBullets(bullet)
				self[_.b]:EmitSound("Weapon_Knife.Hit")
				if (self.Owner:Health() < self.Owner:GetMaxHealth()) then
		    		self.Owner:SetHealth(self.Owner:Health() + intDamage / 2)
       			end
			else
				self[_.b]:EmitSound("Weapon_Knife.Slash")
			end
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire( CurTime() + 15 )
	self:CustomSpeed()
	timer.Simple( 4, function () self:NormalSpeed() end)
end

function SWEP:NormalSpeed()
    if self.Owner:IsValid() then
    self.Owner:SetRunSpeed(200)
    self.Owner:SetWalkSpeed(200)
    self.Owner:SetMaxSpeed(200)
    end
end

function SWEP:CustomSpeed()
    if self.Owner:IsValid() then
    self.Owner:SetRunSpeed(350)
    self.Owner:SetWalkSpeed(350)
    self.Owner:SetMaxSpeed(350)
    end
end
