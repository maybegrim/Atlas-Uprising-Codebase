AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include("shared.lua")

local simplelaundry_removetime = 30

function ENT:Initialize()
    self:SetUseType( SIMPLE_USE )
    self:DrawShadow(false)
    self:SetModel(self.Model)
    if self.ModelColor then
      	self:SetColor(self.ModelColor)
    end
    if self.MaterialType then
        self:SetMaterial(self.MaterialType)
    end
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetCollisionGroup( COLLISION_GROUP_DEBRIS  )
    self:SetCustomCollisionCheck(true)
    if self.CanFold then
    	self:SetCanFold(self.CanFold)
    end
    if self.Stage then
        self:SetStage(self.Stage)
    end
    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:Wake()
    end

    SafeRemoveEntityDelayed(self, simplelaundry_removetime)
end

function ENT:MakeFolded()
  timer.Simple(0.5, function()
    local pos = self:GetPos()
    local ang = self:GetAngles()
    self:Remove()
    local cloth = ents.Create("laundryitem_folded")
    if not cloth:IsValid() then return end
    cloth:SetPos(pos)
    cloth:SetAngles(ang)
    cloth:SetStage(3)
    cloth.Used = false
    cloth:Spawn()
    print(cloth:GetClass())
  end)
end

function ENT:Use(act, caller)
    if self.LaundryItemUse and self.LaundryItemUse > CurTime() then
        return
    end
    self.LaundryItemUse = CurTime() + 1.2
    if SimpleLaundryTeam(caller) then return end
	if self:GetCanFold() and IsValid(caller) and caller:IsPlayer() then
		self:MakeFolded()
	else
        caller:PickupObject(self)
		return
	end
end

function ENT:OnTakeDamage(damage)
    self:Remove()
end