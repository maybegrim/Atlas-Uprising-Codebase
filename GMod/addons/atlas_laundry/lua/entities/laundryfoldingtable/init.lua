AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include("shared.lua")

function ENT:SpawnFunction(ply, tr, cn)
	local ang = ply:GetAngles()
	local ent = ents.Create(cn)
	ent:SetPos(tr.HitPos + tr.HitNormal + Vector(0,0,20))
	ent:SetAngles(Angle(0, ang.y, 0) - Angle(0, 180, 0))
	ent:Spawn()

	return ent
end

function ENT:Initialize()
	self:SetModel("models/props_wasteland/controlroom_desk001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
	    phys:EnableMotion(false)
	end
end

function ENT:StartTouch( ent )
  if IsValid(ent) and !ent.Used then
    if ent:GetClass() == "laundryitem_dry" and ent:GetStage() == 2 then
      ent:SetCanFold(true)
    else
        return
    end
  end
end

function ENT:EndTouch( ent )
  if IsValid(ent) and !ent.Used then
    if ent:GetClass() == "laundryitem_dry" and ent:GetStage() == 2 then
      ent:SetCanFold(false)
    else
        return
    end
  end
end