ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "QRT Exo-Suit"
ENT.Author = "Ninjapenguin16"
ENT.Category = "[AU] Exo-Suit"
ENT.Spawnable = true

function ENT:SetupDataTables()
	
	self:NetworkVar( "Entity", 1, "Equiper", { 
		KeyName = "Equiper", 
		Edit = { type = "Entity", order = 1 } 
	} )
	
	self:NetworkVar( "Int", 1, "Percent", { 
		KeyName = "Percent", 
		Edit = { type = "Int", min = 0, max = 100, order = 1 } 
	} )
	
end	