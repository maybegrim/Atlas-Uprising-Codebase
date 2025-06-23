SWEP.WorldModel 		= ""
SWEP.HoldType 			= "normal"
SWEP.Spawnable			= true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end

hook.Add("ShouldCollide","SCP662NoCollide",function(ply,ply2)
	if (ply:IsPlayer() and ply:GetWeapon("weapon_662"):IsValid()) or 
	(ply2:IsPlayer() and ply2:GetWeapon("weapon_662"):IsValid()) then return false end
end)

function SWEP:IsSeen()
	local plyPos = self.Owner:WorldSpaceCenter()
	for k,v in ipairs(player.GetAll()) do
		if v != self.Owner and v:Alive() and v:GetMoveType() == MOVETYPE_WALK and XYZ.util.PlayerCanSeePosition(v,plyPos,70) then
			return true
		end
	end
	return false
end

function SWEP:IsInvisible()
	return self.Owner:GetMoveType() == MOVETYPE_NOCLIP
end

function SWEP:EnableCollide(bool)
	self.Owner:SetCustomCollisionCheck(!bool)
	self.Owner:CollisionRulesChanged()
end

function SWEP:MakeInvisible()
	self.Owner:SetMoveType(MOVETYPE_NOCLIP) 
	self:EnableCollide(false)
	if SERVER then
		self:GoInvisible()
	end
end

function SWEP:PrimaryAttack()
	if self:IsInvisible() then return end
	if self:IsSeen() then
		if SERVER and (!self.nextVanishMsg or self.nextVanishMsg < CurTime()) then
			self.nextVanishMsg = CurTime()+1
			self.Owner:ChatPrint("Cannot vanish while being watched!")
		end
		return
	end
	self:MakeInvisible()
end

function SWEP:SecondaryAttack()
	if !self:IsInvisible() then return end
	if self:IsSeen() then
		if SERVER and (!self.nextVisMsg or self.nextVisMsg < CurTime()) then
			self.nextVisMsg = CurTime()+1
			self.Owner:ChatPrint("Cannot become visible in watched location!")
		end
		return
	end
	self.Owner:SetMoveType(MOVETYPE_WALK)
	self:EnableCollide(true)
	if SERVER then
		self:GoVisible()
	end
end

function SWEP:OnRemove()
	if IsValid(self.Owner) then
		self.Owner:SetCustomCollisionCheck(false)
		self.Owner:CollisionRulesChanged()
	end
end

function SWEP:Deploy()
	self.Owner:DrawViewModel(false)
end

function SWEP:Holster()
	if self.Owner:GetNoDraw() then return false end
	return true
end
