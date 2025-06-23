AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Reactor"
ENT.Author			= "Astral"
ENT.Spawnable = true

ENT.Category = "AU Site Engineers"
ENT.DecayTime = 7200
ENT.MaxHP = 5000

function ENT:SetupDataTables()
    self:NetworkVar( "Float", 0, "HP" )
    self:NetworkVar( "Bool", 0, "Broken" )
end

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/props_combine/CombineThumper002.mdl")
        self:SetSolid(SOLID_VPHYSICS)
        if AU_Site_Engineer.Reactor and AU_Site_Engineer.Reactor:IsValid() then self:Remove() return end
        AU_Site_Engineer.Reactor = self
        self:SetHP(self.MaxHP)
    end

    function ENT:Use(activator, caller, useType, value)
        if (self:GetHP() == self.MaxHP) then return end
        if not (AU_Site_Engineer.Whitelisted_Jobs[activator:Team()]) then return end
        self:SetHP(self.MaxHP)
        self:SetBroken(false)
        activator:ChatPrint("The Device has been fixed!")
    end

    function ENT:OnTakeDamage(dmg)
        self:SetHP(math.max(self:GetHP() - dmg:GetDamage()), 0)
        if (self:GetHP() == 0) then
            self:SetBroken(true)
        end
     end

     function ENT:Think()
        if (self:GetHP() > 0) then
            local damagePerTick = (self.MaxHP / self.DecayTime)
            self:SetHP(math.max(self:GetHP() - damagePerTick, 0))
            if (self:GetHP() == 0) then
                self:SetHP(0)
                self:SetBroken(true)
            end
        end
        self:NextThink(CurTime() + 1)
        return true
    end
end

