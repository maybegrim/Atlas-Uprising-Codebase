AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "[AU] Supply Depot"
ENT.Spawnable = true
 
ENT.PrintName		= "Depot Crate"
ENT.Author			= "Buckell"
ENT.Contact			= "Bucklet#8987"

if SERVER then
    ENT.PickupCooldown = CurTime() + 1
    function ENT:Initialize()
        self:SetModel("models/props_blackmesa/bms_metalcrate_64x96.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)

        local phys = self:GetPhysicsObject()
        if (phys:IsValid()) then
            phys:Wake()
        end
        self.PickupCooldown = CurTime() + 1
    end

    function ENT:Use(activator, caller)
        print(self.PickupCooldown)
        print(CurTime())
        if self.PickupCooldown > CurTime() then return end
        local active_weapon = caller:GetActiveWeapon()
        if IsValid(active_weapon) and active_weapon:GetClass() == "au_held_depot_crate" then return end

        local crate_weapon = caller:Give("au_held_depot_crate")
        caller:SetActiveWeapon(crate_weapon)
        crate_weapon:Deploy()

        self:Remove()

        caller:EmitSound("physics/metal/metal_barrel_impact_soft4.wav")
    end
end