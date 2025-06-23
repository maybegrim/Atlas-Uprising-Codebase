ENT.PlayerMines = {}
ENT.PlayerMineTimes = {}

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

function ENT:CanPlayerMine(ply)
    if not ply:IsValid() then return false end
    if not ply:Alive() then return false end
    if ply:GetPos():Distance(self:GetPos()) >= 250 then return false end

    return true
end

function ENT:Mined(ply)
    -- 90% chance you get the item
    if math.random(1, 10) <= 9 then
        INVENTORY:AddItem(ply, self.ItemName)
        INVENTORY.Mining.NotifyPly(ply, "Successfully mined the ore.")
        INVENTORY.Mining.UpdateEnt(self, ply, true)
    else
        INVENTORY.Mining.NotifyPly(ply, "Failed to recover ore.")
        INVENTORY.Mining.UpdateEnt(self, ply, true)
    end
    self.PlayerMines[ply] = nil
    self.PlayerMineTimes[ply] = nil
end

function ENT:Use(ply)
    if not self:CanPlayerMine(ply) then return end

    if not self.PlayerMines[ply] then
        self.PlayerMines[ply] = 1
    end

    if not self.PlayerMineTimes[ply] or self.PlayerMineTimes[ply] < CurTime() - 2 then
        if self.PlayerMines[ply] >= self.MineCount then
            self:Mined(ply)
            -- Make player go on 3 second cooldown
            self.PlayerMineTimes[ply] = CurTime() + 3
            return
        end

        self.PlayerMines[ply] = self.PlayerMines[ply] + 1
        self.PlayerMineTimes[ply] = CurTime()

        INVENTORY.Mining.HitEnt(ply, self)
    end
end


