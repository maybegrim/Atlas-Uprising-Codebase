
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_electric/electricalbox_002.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local physObj = self:GetPhysicsObject()
    if not physObj:IsValid() then return end
    physObj:Wake()
end


ENT.UseCooldown = 5 -- Cooldown in seconds

function ENT:Use(ply)
    local curTime = CurTime()
    if self.NextUseTime and curTime < self.NextUseTime then
        return
    end
    self.NextUseTime = curTime + self.UseCooldown

    local item, itemId = INVENTORY:HasItemFromName(ply, "essence_core")

    if not item then
        ply:ChatPrint("You need an essence core to use this!")
        return
    end

    local didDelete = INVENTORY:RemoveItem(ply, itemId, false)

    if not didDelete then
        ply:ChatPrint("Failed to deposit essence core!")
        return
    end

    ply:ChatPrint("You have deposited an essence core! Power levels have reset.")

    self:EmitSound("ambient/levels/labs/electric_explosion1.wav", 75, 100, 0.25, CHAN_AUTO)

    if RESEARCH.POWER.ISPOWERDOWN then
        RESEARCH.POWER.Restore()
    else
        RESEARCH.POWER.ResetPowerTimer()
    end
    timer.Simple(1, function()
        ply:ChatPrint("Power levels will expire in one hour.")
    end)
end

