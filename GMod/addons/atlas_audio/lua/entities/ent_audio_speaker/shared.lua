
ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Audio Speaker"
ENT.Category = "Atlas Audio"
ENT.Author = "Biobolt"
ENT.Spawnable = true
ENT.AdminOnly = false

--[[function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "PAStatus")
    self:SetPAStatus(0)
end]]
