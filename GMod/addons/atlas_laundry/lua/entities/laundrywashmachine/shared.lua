ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName	= "Washer"
ENT.Author		= "ThatCatGuy"
ENT.Category 	= "Simple Laundry"

ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Washing")
end