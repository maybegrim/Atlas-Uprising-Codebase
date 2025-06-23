AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include("shared.lua")

local simplelaundry_sellprice = GetConVar( "simplelaundry_sellprice" )
local simplelaundry_maxlaundry = GetConVar( "simplelaundry_maxlaundry" )

function ENT:SpawnFunction(ply, tr, cn)
	local ang = ply:GetAngles()
	local ent = ents.Create(cn)
	ent:SetPos(tr.HitPos + tr.HitNormal + Vector(0,0,20))
	ent:SetAngles(Angle(0, ang.y, 0) - Angle(0, 90, 0))
	ent:Spawn()

	return ent
end

function ENT:Initialize()
	self:SetModel("models/props_wasteland/laundry_cart002.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	self:SetClothesNumber(0)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
	    phys:EnableMotion(false)
	end
end

function ENT:Touch( ent )
  if IsValid(ent) and !ent.Used then
    if ent:GetClass() == "laundryitem_folded" and self:GetClothesNumber() < simplelaundry_maxlaundry:GetInt() and ent:GetStage() == 3 then
      ent:Remove()
      self:SetClothesNumber(self:GetClothesNumber() + 1)
    else
        return
    end
    ent.Used = true
  end
end

function ENT:Use(act, caller)
	if self.BasketUse and self.BasketUse > CurTime() then
		return
	end
	self.BasketUse = CurTime() + 1.2
	if self:GetClothesNumber() > 0 and IsValid(caller) and caller:IsPlayer() then
		if SimpleLaundryTeam(caller) then return end
		local money = self:GetClothesNumber() * 75
		caller:addMoney(money)
		SimpleLaundryPay(caller, self:GetClothesNumber(), money)
		self:SetClothesNumber(0)
	else
		return
	end
end