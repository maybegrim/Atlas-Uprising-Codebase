--init.lua
--all the goods go here
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Humans/Group02/male_02.mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_IDLE)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetBloodColor(BLOOD_COLOR_RED)
	self.NextHurt = 0
end

function ENT:Use( ent, ply )

end

function ENT:OnRemove()
	
end

function ENT:Think()
	
end

function ENT:AcceptInput(name, activator, caller)
	if name == "Use" and caller:IsPlayer() then
		
		local diam = caller:GetNWInt( "HeldDiam", 0 )
		local gold = caller:GetNWInt( "HeldGold", 0 )
		local rhod = caller:GetNWInt( "HeldRhod", 0 )
		local plat = caller:GetNWInt( "HeldPlat", 0 )
		local totalMinerals = diam + gold + rhod + plat
		local totalMones = 0
		totalMones = ( diam * ST_CONFIGS[ "STMining" ][ "DiamondValue" ] ) + ( gold * ST_CONFIGS[ "STMining" ][ "GoldValue" ] ) + ( rhod * ST_CONFIGS[ "STMining" ][ "RhodiumValue" ] ) + ( plat * ST_CONFIGS[ "STMining" ][ "PlatinumValue" ] )
		if totalMones > 0 then
			self:EmitSound( "vo/npc/male01/hi0" .. math.random(1,2) .. ".wav" )
			if DarkRP then
				DarkRP.notify( caller, 0, 5, "You got $" .. string.Comma( totalMones ) .. " for " .. diam .. " diamond, " .. gold .. " gold, " .. rhod .. " rhodium, and " .. plat .. " platinum." )
			else
				caller:ChatPrint( "You got $" .. string.Comma( totalMones ) .. " for " .. diam .. " diamond, " .. gold .. " gold, " .. rhod .. " rhodium, and " .. plat .. " platinum." )
			end
			caller:SetNWInt( "HeldDiam", 0 )
			caller:SetNWInt( "HeldGold", 0 )
			caller:SetNWInt( "HeldRhod", 0 )
			caller:SetNWInt( "HeldPlat", 0 )
			if DarkRP then
				caller:addMoney( totalMones )
			end
			timer.Simple( 1.5, function()
				if diam > 0 then
					self:EmitSound( "vo/npc/male01/nice.wav" )
				else
					self:EmitSound( "vo/npc/male01/yeah02.wav" )
				end
			end )
		else
			self:EmitSound( "vo/npc/male01/sorry0" .. math.random(1,3) .. ".wav" )
			if DarkRP then
				DarkRP.notify( caller, 1, 5, "You don't have any minerals to sell!" )
			end
		end
	end
end

function ENT:OnTakeDamage( dmg )
	local ouch = {
		"vo/npc/male01/no02.wav",
		"vo/npc/male01/ow01.wav",
		"vo/npc/male01/ow02.wav",
		"vo/npc/male01/pain01.wav",
		"vo/npc/male01/pain02.wav",
		"vo/npc/male01/pain03.wav",
		"vo/npc/male01/pain04.wav",
		"vo/npc/male01/pain05.wav",
		"vo/npc/male01/pain06.wav",
		"vo/npc/male01/pain07.wav",
		"vo/npc/male01/pain08.wav",
		"vo/npc/male01/pain09.wav"
	}
	if CurTime() > self.NextHurt then
		self:EmitSound( ouch[ math.random( 1, 12 ) ] )
		self.NextHurt = CurTime() + 0.333
	end
	return 0
end