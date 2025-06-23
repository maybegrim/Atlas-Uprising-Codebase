ENT.Type 				= "anim"
ENT.Base 				= "base_anim"
ENT.Author 			= "ThatCatGuy"
ENT.Category 		= "Simple Laundry"
ENT.Spawnable 	= false
ENT.MaxCapacity = 6

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Stage")
	self:NetworkVar("Bool", 0, "CanFold")
end