AddCSLuaFile()

AU_Distortion = AU_Distortion or {}
AU_Distortion.Controllers = AU_Distortion.Controllers or {}
AU_Distortion.Config = AU_Distortion.Config or {}

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "AU Distortion"
ENT.Spawnable = false

ENT.PrintName = "Control Post"
ENT.Author = "Astral"
ENT.Contact = "astral0773"

if SERVER then
    function ENT:Initialize()
        self:SetModel( "models/ruggedserverlaptoptexture/ruggedserverlaptoptexture.mdl" )
        self:SetColor( Color( 255, 255, 200 ) )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS )
        self:PhysWake()
    end

    function ENT:OnRemove()
        local target = self:GetTarget()
        if not target or not target:IsValid() then return end
        if target.Stable then target.Stable = false end
    end
end

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "Target")
end
