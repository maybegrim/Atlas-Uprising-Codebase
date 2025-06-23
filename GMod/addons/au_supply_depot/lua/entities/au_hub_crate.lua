AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "[AU] Supply Depot"
ENT.Spawnable = true
 
ENT.PrintName		= "Hub Crate"
ENT.Author			= "Buckell"
ENT.Contact			= "Bucklet#8987"

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/items/ammocrate_smg1.mdl") --models/props_marines/ammocrate01_static.mdl
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)

        local phys = self:GetPhysicsObject()
        if (phys:IsValid()) then
            phys:Wake()
        end
        self.Delay = CurTime() + 5
    end

    --[[function ENT:Use(activator, caller)
        local active_weapon = caller:GetActiveWeapon()
        if IsValid(active_weapon) and active_weapon:GetClass() == "au_held_hub_crate" then return end
        if caller:GetEyeTrace().Entity ~= self then return end
        print("CALLED")
        self:Remove()
        local crate_weapon = caller:Give("au_held_hub_crate")
        caller:SetActiveWeapon(crate_weapon)
        crate_weapon:Deploy()

        caller:EmitSound("physics/metal/metal_barrel_impact_soft4.wav")
    end]]

    function ENT:AcceptInput( inputName, activator, caller, data )
        if inputName ~= "Use" then return end
        if self.Delay > CurTime() then return end
        local active_weapon = caller:GetActiveWeapon()
        if IsValid(active_weapon) and active_weapon:GetClass() == "au_held_hub_crate" then return end
        if caller:GetEyeTrace().Entity ~= self then return end
        caller:Freeze(true)
        timer.Simple(1, function()
            if caller:GetEyeTrace().Entity ~= self then caller:Freeze(false) return end
        self:Remove()
        local crate_weapon = caller:Give("au_held_hub_crate")
        caller:SetActiveWeapon(crate_weapon)
        crate_weapon:Deploy()

        caller:EmitSound("physics/metal/metal_barrel_impact_soft4.wav")
        caller:Freeze(false)
        end)
    end
    function ENT:OnRemove()
        return true
    end
end
