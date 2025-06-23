AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:OnDrop()
	self:Remove()
end

local whitelistedSweps = {
	weapon_662 = true,
	hands = true,
}

function SWEP:GoInvisible()
	self.Owner:GodEnable()
	self.Owner:SetNoDraw(true)
	self.Owner:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.Owner:SetColor(Color(0, 0, 0, 0))
	self.Owner:SetNWBool("isCloakedSWEP", true)
end

function SWEP:GoVisible()
	self.Owner:GodDisable()
	self.Owner:SetNoDraw(false)
	self.Owner:SetMaterial("")
	self.Owner:SetRenderMode(RENDERMODE_NORMAL)
	self.Owner:SetColor(Color(255, 255, 255, 255))
	self.Owner:SetNWBool("isCloakedSWEP", false)
end
