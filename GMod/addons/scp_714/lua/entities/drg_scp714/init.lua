AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr, ClassName)
	if not tr.Hit then return end
	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y + 180
	local ent = ents.Create(ClassName)
	ent:SetPos(tr.HitPos + Vector(0, 0, 1))
	ent:SetAngles(SpawnAng)
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
  self:SetModel("models/mishka/models/scp714.mdl")
  self:PhysicsInit(SOLID_VPHYSICS)
  self:SetMoveType(MOVETYPE_VPHYSICS)
  self:SetSolid(SOLID_VPHYSICS)
  local phys = self:GetPhysicsObject()
  if phys:IsValid() then
    phys:Wake()
  end
  self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
  self:SetUseType(SIMPLE_USE)
end

function ENT:Use(ply)
	if ply:GetNWInt("DrGRunSpeed") == 0 then
    ply:SetNWInt("DrGRunSpeed", ply:GetRunSpeed())
  end
  if ply:GetNWInt("DrGJumpPower") == 0 then
		ply:SetNWInt("DrGJumpPower", ply:GetJumpPower())
  end
	if not ply:GetNWBool("714CantUse") then
	  if not ply:GetNWBool("Wearing714") then
	    self:Remove()
			ply:SetNWBool("Wearing714", true)
			net.Start("Wearing714")
	    net.Send(ply)
			if GetConVar("scp714_disable_running"):GetBool() and GetConVar("scp714_disable_jumping") then
				net.Start("714RunJumpFatigue")
				net.Send(ply)
				ply:SetRunSpeed(ply:GetWalkSpeed())
				ply:SetNWInt("DrGSlowRun", ply:GetNWInt("DrGSlowRun") + 1)
				ply:SetJumpPower(0)
				ply:SetNWInt("DrGWeakJumps", ply:GetNWInt("DrGWeakJumps") + 1)
			elseif GetConVar("scp714_disable_running"):GetBool() then
				net.Start("714RunFatigue")
				net.Send(ply)
				ply:SetRunSpeed(ply:GetWalkSpeed())
				ply:SetNWInt("DrGSlowRun", ply:GetNWInt("DrGSlowRun") + 1)
			elseif GetConVar("scp714_disable_jumping") then
				net.Start("714JumpFatigue")
				net.Send(ply)
				ply:SetJumpPower(0)
				ply:SetNWInt("DrGWeakJumps", ply:GetNWInt("DrGWeakJumps") + 1)
			end
			if GetConVar("scp714_kill"):GetBool() then
				local val = math.random(1, 10000)
				ply:SetNWInt("714KillVal", val)
				timer.Simple(math.random(GetConVar("scp714_kill_min"):GetInt(), GetConVar("scp714_kill_max"):GetInt()), function()
					if ply:GetNWBool("Wearing714") and ply:Alive() and val == ply:GetNWInt("714KillVal") then
						net.Start("714FatigueKill")
						net.Send(ply)
						ply:Kill()
					end
				end)
			end
	  else
	    net.Start("AlreadyWearing714")
	    net.Send(ply)
	  end
	end
end
