--[[
	This file has been copyrighted by Atlas Uprising.
	Do not distribute or copy any files.
]]--

SWEP.Author			= "Heracles421"
SWEP.Purpose		= ""
SWEP.Category       = "Atlas Uprising - Temp SCP Sweps"
SWEP.Instructions	= "Left-Click to play the Beethoven sound.\nRight-Click to ask for Eric."
SWEP.PrintName		= "SCP-066"
SWEP.Slot			= 0
SWEP.SlotPos		= 0
SWEP.HoldType		= "normal"
SWEP.Spawnable		= true
SWEP.AdminSpawnable	= true
SWEP.ISSCP 			= true
SWEP.ViewModel		= ""
SWEP.WorldModel		= ""
SWEP.DrawAmmo 		= false
SWEP.DrawCrosshair 	= true
SWEP.nextThink 		= 0
SWEP.lastPrimary	= 0
SWEP.doThink		= false
SWEP.m_tblAffectedPlayers = {}

function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + 30 )
	self.lastPrimary = CurTime()
	self.doThink = true

	if SERVER then
	    self:GetOwner():EmitSound("SCP066.Beethoven")
	    self.Weapon:EmitSound("SCP066.Ring")
		local m_tblEntities = ents.FindInSphere( self:GetOwner():GetPos(), 300 )
		for k,v in pairs(m_tblEntities) do
			if v:IsPlayer() and v != self:GetOwner() then
				v:SetDSP( 32, false )
			end
		end
		self:BeginEarrape()
	end
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire( CurTime() + 1 )
	if SERVER then
		self:GetOwner():EmitSound("SCP066.Eric")
	end
end

function SWEP:ClearAffectedPlayers()
	for k,v in pairs(self.m_tblAffectedPlayers) do
		if SERVER then
			AtlasAddons.Net:UpdateSCP066Affected( v, false )
		end
	end
	self.m_tblAffectedPlayers = {}
end

function SWEP:BeginEarrape()
	timer.Create("AtlasAddons.SCP066:" .. self:GetOwner():SteamID64(), 1, 26, function()
		self:ClearAffectedPlayers()

		if (CurTime() - self.lastPrimary <= 25 ) then
			util.ScreenShake( self:GetOwner():GetPos(), 5, 5, 1, 300 )

			local m_tblEntities = ents.FindInSphere( self:GetOwner():GetPos(), 300 )
			for k,v in pairs(m_tblEntities) do
				if v:IsPlayer() and v != self:GetOwner() and SERVER then
					AtlasAddons.Net:UpdateSCP066Affected( v, true )
					v:TakeDamage( 5, self:GetOwner(), self )
					if !(self.m_tblAffectedPlayers[v]) then
						local m_tblTemp = {}
						m_tblTemp.v = v
						table.Add( self.m_tblAffectedPlayers, m_tblTemp )
					end
				end
			end
		end
	end)
end