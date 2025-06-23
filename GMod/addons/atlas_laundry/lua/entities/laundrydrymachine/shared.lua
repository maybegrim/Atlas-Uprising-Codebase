ENT.Base 					= "base_gmodentity"
ENT.Type 					= "anim"
ENT.PrintName			= "Dryer"
ENT.Author				= "ThatCatGuy"
ENT.Category 			= "Simple Laundry"

ENT.Spawnable 		= true
ENT.AdminOnly 		= true
ENT.maxCapacity 	= 4
ENT.lastTouchTime = 0
ENT.status 				= {}
ENT.percentage 		= 0
ENT.isWashing 		= false
ENT.DryingTime 		= 10

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Laundry1")
	self:NetworkVar("Int", 1, "Laundry2")
	self:NetworkVar("Int", 2, "Laundry3")
	self:NetworkVar("Int", 3, "Laundry4")
end