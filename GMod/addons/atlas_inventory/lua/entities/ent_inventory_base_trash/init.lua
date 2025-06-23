ENT.PlayerSearches = {}
ENT.Cooldown = {}

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel(self.PreferredModel)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local physObj = self:GetPhysicsObject()
    if not physObj:IsValid() then return end
    physObj:Wake()
end

function ENT:CanPlayerSearch(ply)
    if not ply:IsValid() then return false end
    if not ply:Alive() then return false end
    if ply:GetPos():Distance(self:GetPos()) >= 250 then return false end
    if not INVENTORY.Garbage.CanSearch(ply) then return false end
    return true
end

function ENT:Search(ply)
    if not self:CanPlayerSearch(ply) then return end
    if self.PlayerSearches[ply] then return end

    self.Cooldown[ply] = true
    timer.Simple(5, function()
        if not self:IsValid() then return end
        self.Cooldown[ply] = nil
    end)
    self.PlayerSearches[ply] = true
    timer.Simple(3, function()
        if not self:IsValid() then return end
        self.PlayerSearches[ply] = nil
    end)
    INVENTORY.Garbage.StartSearch(ply, self)
end

function ENT:CanUse(ply)
    if self.Cooldown[ply] then return false end

    return true
end

function ENT:Use(ply)
    if not self:CanUse(ply) then return end
    self:Search(ply)
end


