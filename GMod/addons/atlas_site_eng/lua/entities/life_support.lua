AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Life Support"
ENT.Author			= "Astral"
ENT.Spawnable = true

ENT.Category = "AU Site Engineers"
ENT.DecayTime = 7200
ENT.MaxHP = 2000

function ENT:SetupDataTables()
    self:NetworkVar( "Float", 0, "HP" )
    self:NetworkVar( "Bool", 0, "Broken" )
end

function ENT:Initialize()
    if AU_Site_Engineer.LifeSupport and AU_Site_Engineer.LifeSupport:IsValid() then self:Remove() return end
    AU_Site_Engineer.LifeSupport = self
    self:SetHP(self.MaxHP)
end

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/props_lab/servers.mdl")
        self:SetSolid(SOLID_VPHYSICS)
        if AU_Site_Engineer.LifeSupport and AU_Site_Engineer.LifeSupport:IsValid() then self:Remove() return end
        AU_Site_Engineer.LifeSupport = self
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
        if (self:GetHP() <= 0) then
            self:SetBroken(true)
        end
     end
end

if not CLIENT then return end

local darknessAlpha = 0

hook.Add("HUDPaint", "DarkenScreenEffect", function()
    if LocalPlayer():GetPos().y > -4387.194336 then return end
    if not AU_Site_Engineer.LifeSupport or not AU_Site_Engineer.LifeSupport:IsValid() or not AU_Site_Engineer.LifeSupport:GetBroken() then
        if darknessAlpha == 0 then return end
        darknessAlpha = math.Clamp(darknessAlpha - 1, 0, 200)

        surface.SetDrawColor(0, 0, 0, darknessAlpha)
        surface.DrawRect(0, 0, ScrW(), ScrH())
        return 
    end
    darknessAlpha = math.Clamp(darknessAlpha + 1, 0, 200)

    surface.SetDrawColor(0, 0, 0, darknessAlpha)
    surface.DrawRect(0, 0, ScrW(), ScrH())
end)