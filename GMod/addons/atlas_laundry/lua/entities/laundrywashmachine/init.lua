AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include("shared.lua")

local simplelaundry_washingtime = GetConVar( "simplelaundry_washingtime" )

function ENT:SpawnFunction(ply, tr, cn)
  local ang = ply:GetAngles()
  local ent = ents.Create(cn)
  ent:SetPos(tr.HitPos + tr.HitNormal + Vector(0,0,60))
  ent:SetAngles(Angle(0, ang.y, 0) - Angle(0, 180, 0))
  ent:Spawn()

  return ent
end

function ENT:Initialize()
    self:SetModel("models/props_wasteland/laundry_dryer002.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:DrawShadow(false)
    
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
    end
end

function ENT:Touch( ent )
  if IsValid(ent) and !ent.Used then
    if ent:GetClass() == "laundryitem_dirty" and !self:GetWashing() and ent:GetStage() == 0 then
      ent:Remove()
      self:SetWashing(true)
      self:OnWash(ent)
    else
        return
    end
    --ent.Used = true
  end
end

function ENT:MakeLaundry(stage, color)
  local pos = self:LocalToWorld(self:OBBCenter())
  local ang = self:GetAngles()

  ang:RotateAroundAxis(ang:Up(), 90)
  ang:RotateAroundAxis(ang:Forward(), 90)

  local cloth = ents.Create("laundryitem_wet")
  if not cloth:IsValid() then return end
  cloth:SetPos(pos + (ang:Up() * 25))
  cloth:SetAngles(self:GetAngles())
  cloth:SetStage(stage)
  if color then
    cloth:SetColor(color)
  end
  cloth:Spawn()
end

function ENT:OnWash(ent)
  if timer.Exists("WashTimer" .. self:EntIndex()) then return end
  self:EmitSound("ambience/mechwhine.wav")
  timer.Create("WashTimer" .. self:EntIndex(), simplelaundry_washingtime:GetInt(), 1, function()
    self:StopSound("ambience/mechwhine.wav")
    timer.Simple(0.2, function()
      if self:IsValid() then
        self:SetWashing(false)
        timer.Remove("WashTimer"..self:EntIndex())
        self:MakeLaundry(1, Color(72, 72, 72))
      end
    end)   
  end)
end

function ENT:OnRemove()
  if timer.Exists("WashTimer" .. self:EntIndex()) then
    timer.Remove("WashTimer" .. self:EntIndex())
  end
end