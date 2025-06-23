AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "CC Controll"
ENT.Author			= "Astral"
ENT.Spawnable = true

ENT.Category = "AU Site Engineers"
ENT.DecayTime = 7200
ENT.DecayTimeNoReactor = 1800
ENT.MaxHP = 1000

function ENT:SetupDataTables()
    self:NetworkVar( "Float", 0, "HP" )
    self:NetworkVar( "Bool", 0, "Broken" )
end

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/props_lab/securitybank.mdl")
        self:SetSolid(SOLID_VPHYSICS)
        if AU_Site_Engineer.CCControll and AU_Site_Engineer.CCControll:IsValid() then self:Remove() return end
        AU_Site_Engineer.CCControll = self
        self:SetHP(self.MaxHP)
    end

    function ENT:Use(activator, caller, useType, value)
        if (self:GetHP() == self.MaxHP) then return end
        if not (AU_Site_Engineer.Whitelisted_Jobs[activator:Team()]) then return end
        if AU_Site_Engineer.Reactor:GetBroken() then activator:ChatPrint("The Reactor needs to be fixed first!") return end
        self:SetHP(self.MaxHP)
        self:SetBroken(false)
        activator:ChatPrint("The Device has been fixed!")
    end

    function ENT:OnTakeDamage(dmg) end

     function ENT:Think()
        if (self:GetHP() > 0) then
            local damagePerTick = 0
            if AU_Site_Engineer.Reactor and AU_Site_Engineer.Reactor:IsValid() and AU_Site_Engineer.Reactor:GetBroken() then
                damagePerTick = (self.MaxHP / self.DecayTimeNoReactor)
            else
                damagePerTick = (self.MaxHP / self.DecayTime)
            end
            self:SetHP(math.max(self:GetHP() - damagePerTick, 0))
        end

        if (self:GetHP() == 0) then
            self:SetHP(0)
            self:SetBroken(true)
            for _, ply in ipairs(SCP.PlayerQueue) do
                SCP.Breach(ply)
            end
        end
        self:NextThink(CurTime() + 1)
        return true
    end
end

