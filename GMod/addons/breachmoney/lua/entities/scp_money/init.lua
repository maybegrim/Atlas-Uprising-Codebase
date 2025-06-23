AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
util.AddNetworkString("funfish")
util.AddNetworkString("sadfish")
util.AddNetworkString("deadfish")

local disallowedscps = {
	["scp131a"] = true,
	["scp131b"] = true,
	["scp343"] = true,
	["scp912"] = true,
	["scp999"] = true,
	["scp947"] = true,
	["scp662"] = true,
	["scp774"] = true,
	["scp2282"] = true,
	["scp0214"] = true 
}
local cantuse = 0

hook.Add("PlayerDeath", "DeathReset", function(ply)
	net.Start("deadfish")
	net.Send(ply)
end)

function ENT:Initialize()
	self:SetModel("models/prototypgaming//mgs4_praying_mantis_merc.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Use(ply)
	local team = tostring(RPExtraTeams[ply:Team()].command)
	local faction = tostring(RPExtraTeams[ply:Team()].faction)
	playyaa = ply

	if faction == "SCP" then
		if disallowedscps[team] then
			cantuse = 1
			ply:ChatPrint("Your SCP can't use this!")
			goto fun
		else 
			cantuse = 0
			goto fun
		end
		::fun::
		if cantuse == 1 then return else
			net.Start("funfish")
			net.WriteBool(cantuse)
			net.WriteEntity(ply)
			net.Send(ply)
		end
	else
		ply:ChatPrint("You cannot use this as a human!!")
	end
end
net.Receive("sadfish", function()
	local steamid = playyaa:SteamID()
		print("Gave money to SCP for breaching")
	game.ConsoleCommand("sam addmoney " .. steamid .. " 200\n")
end)

