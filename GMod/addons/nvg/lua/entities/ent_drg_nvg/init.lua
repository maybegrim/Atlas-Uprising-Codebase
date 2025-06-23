AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

resource.AddFile("materials/entities/ent_drg_nvg.png")

function ENT:SpawnFunction(ply, tr, ClassName)
	if not tr.Hit then return end
	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y + 180
	local ent = ents.Create(ClassName)
	ent:SetPos(tr.HitPos + Vector(0, 0, 1))
	ent:SetAngles(SpawnAng + Angle(0, 150))
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
  self:SetModel("models/mishka/models/nvg.mdl")
  self:PhysicsInit(SOLID_VPHYSICS)
  self:SetMoveType(MOVETYPE_VPHYSICS)
  self:SetSolid(SOLID_VPHYSICS)
  local phys = self:GetPhysicsObject()
  if phys:IsValid() then
    phys:Wake()
  end
  self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
  self:SetUseType(SIMPLE_USE)
  	timer.Simple(120, function()
		if IsValid(self) then
			self:Remove()
		end
	end)
end

function ENT:Use(ply)
	if not ply:GetNWBool("WearingDrGNVG") then
  		ply:SetNWBool("WearingDrGNVG", true)
		net.Start("WearingDrGNVG")
		self:Remove()
	else
		net.Start("AlreadyWearingDrGNVG")
	end
	net.Send(ply)
end

local function ToggNVG(ply, sound)
	if ply:Team() == TEAM_SCP_2451 then
		ply:SetNWBool("ActiveDrGNVG", not ply:GetNWBool("ActiveDrGNVG"))
		net.Start("ToggleDrGNVG")
		net.WriteBool(sound)
		net.Send(ply)
		return
	end
	if ply:GetNWBool("WearingDrGNVG") then
	  ply:SetNWBool("ActiveDrGNVG", not ply:GetNWBool("ActiveDrGNVG"))
	  net.Start("ToggleDrGNVG")
		net.WriteBool(sound)
	  net.Send(ply)
	else
		net.Start("NotWearingDrGNVG")
		net.Send(ply)
	end
end

local function DropNVG(ply, normal)
	if ply:GetNWBool("WearingDrGNVG") then
		if ply:GetNWBool("ActiveDrGNVG") then
			ToggNVG(ply, false)
		end
	  ply:SetNWBool("WearingDrGNVG", false)
	  net.Start("DropDrGNVG")
	  net.WriteBool(normal)
	  net.Send(ply)
	  local ent = ents.Create("ent_drg_nvg")
	  if not ent:IsValid() then return end
	  ent:SetPos(ply:GetPos() + Vector(0, 0, 1))
	  ent:SetAngles(Angle(0, math.random(0, 359)))
	  ent:Spawn()
		ent:Activate()
	else
		net.Start("NotWearingDrGNVG")
		net.Send(ply)
	end
end

net.Receive("DropDrGNVG", function(len, ply)
  DropNVG(ply, true)
end)

net.Receive("ToggleDrGNVG", function(len, ply)
  ToggNVG(ply, true)
end)

hook.Add("PlayerSay", "DrGNVGChatCommandSV", function(ply, str)
	if str == "!dropnvg" then
		DropNVG(ply, true)
		return ""
	elseif str == "!toggnvg" then
		ToggNVG(ply, true)
		return ""
	end
end)

hook.Add("PostPlayerDeath", "DropDrGNVGDeath", function(ply)
  if ply:GetNWBool("WearingDrGNVG") then
    DropNVG(ply, false)
  end
end)
