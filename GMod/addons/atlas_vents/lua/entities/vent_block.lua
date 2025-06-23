AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "Atlas Uprising - Vents"
ENT.Spawnable = true
 
ENT.PrintName		= "Vent Block"
ENT.Author			= "Buckell"
ENT.Contact			= "Bucklet#8987"

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/hunter/blocks/cube1x1x1.mdl")
        self:SetAngles(self:GetAngles() + Angle(0, 90, 90))
        self:SetColor(Color(30, 30, 30))
        self:SetMaterial("models/debug/debugwhite")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    
        local phys = self:GetPhysicsObject()
        if (phys:IsValid()) then
            phys:Wake()
        end

        local ent = self
        timer.Simple(1, function ()
            ent:SetCollisionGroup(COLLISION_GROUP_NONE)
        end)
        
        local vent = self
        
        hook.Add("AU.Vents.Open", self, function ()
            vent:TriggerOpen()
        end)
        
        hook.Add("AU.Vents.Close", self, function ()
            vent:TriggerClose() 
        end)
        timer.Simple(1, function ()
            vent:TriggerClose()
        end)
    end
    
    function ENT:OnRemove()
        hook.Remove("AU.Vents.Open", self)
    end
    
    function ENT:TriggerClose()
        self:SetNWBool("Closed", true)
        self:SetCollisionGroup(COLLISION_GROUP_NONE)
    end
    
    function ENT:TriggerOpen() 
        self:SetNWBool("Closed", false)
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    end
elseif CLIENT then
    function ENT:Initialize()
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    end

    function ENT:Draw()
        local active_weapon = LocalPlayer():GetActiveWeapon()
        if self:IsClosed() or (IsValid(active_weapon) and active_weapon:GetClass() == "weapon_physgun") then
            self:DrawModel()
        end
    end
end

function ENT:IsClosed()
    return self:GetNWBool("Closed", false)
end