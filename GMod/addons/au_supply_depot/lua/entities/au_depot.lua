AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "[AU] Supply Depot"
ENT.Spawnable = true
 
ENT.PrintName		= "Depot"
ENT.Author			= "Buckell"
ENT.Contact			= "Bucklet#8987"

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/hunter/plates/plate3x3.mdl")
        self:SetMaterial("models/debug/debugwhite")
        self:SetColor(Color(30, 30, 30))
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)

        local phys = self:GetPhysicsObject()
        if (phys:IsValid()) then
            phys:Wake()
        end
    end

    function ENT:SpawnCrate()
        local entity = ents.Create("au_depot_crate")
            
        local pos = self:GetPos() + Vector(0, 0, 2)
    
        entity:SetPos(pos)
        entity:Spawn()
        entity:GetPhysicsObject():EnableMotion(false)
    end
end
