ENT.Base 			= "base_gmodentity"
ENT.Type 			= "anim"
ENT.PrintName	= "Laundry Basket"
ENT.Author		= "ThatCatGuy"
ENT.Category 	= "Simple Laundry"

ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "ClothesNumber")
end