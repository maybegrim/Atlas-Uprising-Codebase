ENT.Item = false
ENT.Elixir = false
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
function ENT:Initialize()
    self:SetModel("models/props_junk/cardboard_box003a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local physObj = self:GetPhysicsObject()
    if not physObj:IsValid() then return end
    physObj:Wake()
end

function ENT:SetEnt(ent, elixir)
    if elixir then
        self.Item = ent
        self.Elixir = true
        return
    end
    self.Item = ent
end

function ENT:Use(ply)
    if ATLAS662.Ply ~= ply then return end
    if ply:GetMoveType() == MOVETYPE_NOCLIP then
        net.Start("ATLAS662.Notify.ExitNoclip")
        net.Send(ply)
        return
    end
    if ply:GetNoDraw() then
        net.Start("ATLAS662.Notify.ExitCloak")
        net.Send(ply)
        return
    end
    ply:Freeze(true)
    net.Start("ATLAS662.Pickup.Time")
    net.WriteFloat(CurTime())
    net.WriteFloat(CurTime() + ATLAS662.PickupTime)
    net.Send(ply)
    timer.Simple(ATLAS662.PickupTime, function()
        if self.Elixir then
            local itemData = {creation_time = os.time(), id = self.Item}

            local inventory = Elixir.GetInventory(ply)

            if #inventory + 1 > Elixir.InventoryCapacity then
                Elixir.Message(ply, "You cannot carry any more items.")
                net.Start("ATLAS662.Pickup.Complete")
                net.WriteBool(true)
                net.WriteBool(true)
                net.Send(ply)
                ply:Freeze(false)
                return
            end

            Elixir.AddInventoryItem(ply, itemData)

            net.Start("ATLAS662.Pickup.Complete")
            net.WriteBool(true)
            net.WriteBool(false)
            net.Send(ply)
            self:Remove()
            ATLAS662.GrabEnt = false
            ply:Freeze(false)
            return
        end
        ply:Freeze(false)
        ply:Give(self.Item)
        net.Start("ATLAS662.Pickup.Complete")
        net.WriteBool(false)
        net.WriteBool(false)
        net.Send(ply)
        self:Remove()
        ATLAS662.GrabEnt = false
    end)
end
