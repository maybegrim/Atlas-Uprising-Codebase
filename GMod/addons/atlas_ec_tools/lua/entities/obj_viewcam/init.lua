
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self:SetNotSolid(true)
	self:DrawShadow(false)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
end

function ENT:SetEntityOwner(ent)
	self.entOwner = ent
end

function ENT:Start()
	self.entOwner:Spectate(OBS_MODE_CHASE)
	self.entOwner:SetMaterial("player_invis")
	self.entOwner:DrawViewModel(false)
	self.entOwner:DrawWorldModel(false)
	
	self.entOwner:SpectateEntity(self)
	self.entOwner:SetMoveType(MOVETYPE_OBSERVER)
	
	self.tblPlayer = {}
	self.tblPlayer["Health"] = self.entOwner:Health()
	self.tblPlayer["Armor"] = self.entOwner:Armor()
	self.tblPlayer["ActiveWeapon"] = self.entOwner:GetActiveWeapon():GetClass()
	self.tblPlayer["Weapons"] = {}
	for k, v in pairs(self.entOwner:GetWeapons()) do
		table.insert(self.tblPlayer["Weapons"],v:GetClass())
	end
	self.entOwner:StripWeapons()
	
	self.bActive = true
	self.entOwner:SetNoTarget(true)
end

function ENT:Stop()
	if IsValid(self.entOwner) then
		self.entOwner:SetNoTarget(false)
		self.entOwner:UnSpectate()
		self.entOwner:SetMaterial()
		self.entOwner:DrawViewModel(true)
		self.entOwner:DrawWorldModel(true)
		
		self.entOwner:SetMoveType(MOVETYPE_WALK)
		
		local pos = self.entOwner:GetPos()
		self.entOwner:KillSilent()
		self.entOwner:Spawn()
		if IsValid(self.entTarget) then
			pos = self.entTarget:GetPos() +Vector(0,0,self.entTarget:OBBMaxs().z +20)
		end
		self.entOwner:SetPos(pos)
		if self.tblPlayer then
			for k, v in pairs(self.tblPlayer["Weapons"]) do
				self.entOwner:Give(v)
			end
			self.entOwner:SelectWeapon(self.tblPlayer["ActiveWeapon"])
			self.entOwner:SetHealth(self.tblPlayer["Health"])
			self.entOwner:SetArmor(self.tblPlayer["Armor"])
		end
	end
	
	self.bActive = false
	
	self.tblPlayer = nil
	self:Remove()
end

function ENT:SetTarget(ent)
	self.entTarget = ent
end

function ENT:OnRemove()
	self:Stop()
end

function ENT:Think()
	if IsValid(self.entOwner) && #self.entOwner:GetWeapons() > 0 then self.entOwner:StripWeapons() end
	if !IsValid(self.entTarget) || self.entTarget:Health() <= 0 || !IsValid(self.entOwner) || !self.entOwner:Alive() || self.entOwner:KeyDown(IN_USE) then
		self:Remove()
		return
	end
end
