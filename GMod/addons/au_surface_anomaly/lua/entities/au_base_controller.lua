AddCSLuaFile()

AU_Distortion = AU_Distortion or {}
AU_Distortion.Controllers = AU_Distortion.Controllers or {}
AU_Distortion.Config = AU_Distortion.Config or {}

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "AU Distortion"
ENT.Spawnable = false

ENT.PrintName = "Base Controller"
ENT.Author = "Astral"
ENT.Contact = "astral0773"
ENT.TargetList = {}

-- Please do not touch this unless you absolutelly know what your doing. This is the base for all the surface event anomalies. 

if SERVER then
    function ENT:Initialize()
        self:SetCategory(1)

        if self.WorlModel then
            self:SetModel( self.WorlModel )
            self:SetColor( Color( 255, 255, 255 ) )
            self:SetSolid( SOLID_VPHYSICS )
        end

        if self.NewInitialize then
            self:NewInitialize()
        end
        
        timer.Simple(3, function() -- If not configured after 3 seconds remove.
            if not IsValid(self) then return end
            if self:GetCategory() == 0 then self:Remove() end
        end)
    end
    
    function ENT:OnRemove()
        if self.NewDestroy then
            self:NewDestroy()
        end
        AU_Distortion.Remove(self)
    end
end

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "Category")
    self:NetworkVar("String", 1, "Name")
    self:NetworkVar("Float", 2, "Rad")
    self:NetworkVar("Int", 3, "TargetAmmount")
end
