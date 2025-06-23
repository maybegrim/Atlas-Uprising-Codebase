AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local simplelaundry_dryingtime = GetConVar( "simplelaundry_dryingtime" )

function ENT:SpawnFunction(ply, tr, cn)
  local ang = ply:GetAngles()
  local ent = ents.Create(cn)
  ent:SetPos(tr.HitPos + tr.HitNormal + Vector(0,0,20))
  ent:SetAngles(Angle(0, ang.y, 0) - Angle(0, 270, 0))
  ent:Spawn()

  return ent
end

function ENT:Initialize()
  self:SetModel("models/props_wasteland/laundry_washer003.mdl")
  self:PhysicsInit(SOLID_VPHYSICS)
  self:SetMoveType(MOVETYPE_VPHYSICS)
  self:SetSolid(SOLID_VPHYSICS)
  self:DrawShadow(false)
  
  local phys = self:GetPhysicsObject()
  if IsValid(phys) then
      phys:EnableMotion(false)
  end
  if IsValid(self.dt.owning_ent) then
      self:CPPISetOwner(self.dt.owning_ent)
      self.SID = self.dt.owning_ent.SID
  end
end

function ENT:MakeLaundry(stage, color)
  self:EmitSound("buttons/lever5.wav")
  timer.Simple(1, function()
    local pos = self:LocalToWorld(self:OBBCenter())
    local ang = self:GetAngles()

    ang:RotateAroundAxis(ang:Up(), 180)
    ang:RotateAroundAxis(ang:Forward(), 90)

    local cloth = ents.Create("laundryitem_dry")
    if not cloth:IsValid() then return end
    cloth:SetPos(pos + (ang:Up() * 35))
    cloth:SetAngles(self:GetAngles())
    cloth:SetStage(stage)
    cloth.Used = nil
    if color then
      cloth:SetColor(color)
    end
    cloth:Spawn()
  end)
end

function ENT:Touch( ent )
  if IsValid(ent) and !ent.Used then
    if ent:GetClass() == "laundryitem_wet" and self:GetLaundry1() == 0 and ent:GetStage() == 1 then
      ent:Remove()
      ent.Used = true
      self:SetLaundry1(1)
      self:EmitSound("vehicles/APC/apc_idle1.wav")
      timer.Create("DryTimer1" .. self:EntIndex(), simplelaundry_dryingtime:GetInt(), 1, function()
          self:StopSound("vehicles/APC/apc_idle1.wav")
          self:SetLaundry1(2)          
        timer.Simple(1, function()
          self:SetLaundry1(3)
          self:MakeLaundry(2)
        end)
        timer.Simple(2, function()
          self:SetLaundry1(0)
        end)
      end)
    elseif ent:GetClass() == "laundryitem_wet" and self:GetLaundry2() == 0 and ent:GetStage() == 1 then
      ent:Remove()
      ent.Used = true
      self:SetLaundry2(1)
      self:StopSound("vehicles/APC/apc_idle1.wav")
      self:EmitSound("vehicles/APC/apc_idle1.wav")
      timer.Create("DryTimer2" .. self:EntIndex(), simplelaundry_dryingtime:GetInt(), 1, function()
          self:StopSound("vehicles/APC/apc_idle1.wav")
          self:SetLaundry2(2)
        timer.Simple(1, function()
          self:SetLaundry2(3)
          self:MakeLaundry(2)
        end)
        timer.Simple(2, function()
          self:SetLaundry2(0)
        end)
      end)
    elseif ent:GetClass() == "laundryitem_wet" and self:GetLaundry3() == 0 and ent:GetStage() == 1 then
      ent:Remove()
      ent.Used = true
      self:SetLaundry3(1)
      self:StopSound("vehicles/APC/apc_idle1.wav")
      self:EmitSound("vehicles/APC/apc_idle1.wav")
      timer.Create("DryTimer3" .. self:EntIndex(), simplelaundry_dryingtime:GetInt(), 1, function()
          self:StopSound("vehicles/APC/apc_idle1.wav")
          self:SetLaundry3(2)
        timer.Simple(1, function()
          self:SetLaundry3(3)
          self:MakeLaundry(2)
        end)
        timer.Simple(2, function()
          self:SetLaundry3(0)
        end)
      end)
    elseif ent:GetClass() == "laundryitem_wet" and self:GetLaundry4() == 0 and ent:GetStage() == 1 then
      ent:Remove()
      ent.Used = true
      self:SetLaundry4(1)
      self:StopSound("vehicles/APC/apc_idle1.wav")
      self:EmitSound("vehicles/APC/apc_idle1.wav")
      timer.Create("DryTimer4" .. self:EntIndex(), simplelaundry_dryingtime:GetInt(), 1, function()
          self:StopSound("vehicles/APC/apc_idle1.wav")
          self:SetLaundry4(2)
        timer.Simple(1, function()
          self:SetLaundry4(3)
          self:MakeLaundry(2)
        end)
        timer.Simple(2.5, function()
          self:SetLaundry4(0)
        end)
      end)
    else
        return
    end
    ent.Used = true
  end
end

function ENT:OnRemove()
  if timer.Exists("DryTimer1" .. self:EntIndex()) then
    timer.Remove("DryTimer1" .. self:EntIndex())
  end
  if timer.Exists("DryTimer2" .. self:EntIndex()) then
    timer.Remove("DryTimer2" .. self:EntIndex())
  end
  if timer.Exists("DryTimer3" .. self:EntIndex()) then
    timer.Remove("DryTimer3" .. self:EntIndex())
  end
  if timer.Exists("DryTimer4" .. self:EntIndex()) then
    timer.Remove("DryTimer4" .. self:EntIndex())
  end
end