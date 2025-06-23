AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
 
include("shared.lua")

function ENT:SpawnFunction(ply, tr, cn)
  local ang = ply:GetAngles()
  local ent = ents.Create(cn)
  ent:SetPos(tr.HitPos + tr.HitNormal + Vector(0,0,20))
  ent:SetAngles(Angle(0, ang.y, 0) - Angle(270, 270, 0))
  ent:Spawn()

  return ent
end

function ENT:Initialize()
	self:SetModel("models/props_pipes/pipe03_90degree01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(false)
 
  local phys = self:GetPhysicsObject()
  if IsValid(phys) then
      phys:EnableMotion(false)
  end
end

function ENT:MakeLaundry(stage, color)
	self:EmitSound("buttons/lever5.wav")
	timer.Simple(1, function()
		local pos = self:LocalToWorld(self:OBBCenter())
		local ang = self:GetAngles()

		ang:RotateAroundAxis(ang:Up(), 90)
		ang:RotateAroundAxis(ang:Forward(), 90)

		local cloth = ents.Create("laundryitem_dirty")
		if not cloth:IsValid() then return end
		cloth:SetPos(pos + (ang:Up() * 25))
		cloth:SetAngles(self:GetAngles())
		cloth:SetStage(stage)
		if color then
			cloth:SetColor(color)
		end
		cloth:Spawn()  
    end)
end

function ENT:Use(act, caller)
	-- Initialize the caller usage table if not already done
	self.CallerUses = self.CallerUses or {}

	local callerID = caller:UserID() -- Using UserID as the key; you can use SteamID as well

	-- Initialize this caller's usage info if not already done
	if not self.CallerUses[callerID] then
		self.CallerUses[callerID] = {count = 0, cooldownStart = 0}
	end

	local usageInfo = self.CallerUses[callerID]

	-- Check if the caller is in cooldown
	if usageInfo.cooldownStart > CurTime() then
		return -- Still in cooldown, do nothing
	end

	-- Check if the caller can use it again or if the cooldown needs to reset
	if usageInfo.count >= 2 then
		-- Reset if 30 seconds have passed since the cooldown started
		if CurTime() - usageInfo.cooldownStart > 30 then
			usageInfo.count = 0
			usageInfo.cooldownStart = 0
		else
			return -- Still within the 30 seconds cooldown
		end
	end

	-- Increment the use count and set cooldown start time if necessary
	usageInfo.count = usageInfo.count + 1
	if usageInfo.count == 1 then
		-- Start the cooldown with the first use
		usageInfo.cooldownStart = CurTime()
	end

	-- Allow the action if not returned by now
	if SimpleLaundryTeam(caller) then return end
	self:MakeLaundry(0, Color(127, 95, 0))
end