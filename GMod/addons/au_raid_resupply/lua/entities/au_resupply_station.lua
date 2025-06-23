AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "[AU] Raid System"
ENT.Spawnable = true
 
ENT.PrintName		= "Resupply Station"
ENT.Author			= "Buckell"
ENT.Contact			= "Bucklet#8987"

local RESUPPLY_STATION_COOLDOWN = 5

local RESUPPLY_STATION = function (ply)
    ply:SetHealth(100)
    ply:SetArmor(100)
end

if SERVER then
    util.AddNetworkString("AU.ResupplyStation.Fetch")
    util.AddNetworkString("AU.ResupplyStation.Cancel")

    net.Receive("AU.ResupplyStation.Cancel", function (len, ply)
        local hub = net.ReadEntity()

        if not IsValid(hub) or hub:GetClass() ~= "au_resupply_station" then return end

        if hub:GetNWEntity("Target") ~= ply then return end

        hub:CancelFetch()
    end)

    function ENT:Initialize()
        self:SetModel("models/props_wasteland/controlroom_storagecloset001a.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)

        local phys = self:GetPhysicsObject()
        if (phys:IsValid()) then
            phys:Wake()
        end
    end

    function ENT:Use(activator, caller)
        if Cooldown("USE au_resupply_station", 1) then return end

        if self:GetRetrievalProgress() < 1 then return end

        if caller:getJobTable().faction ~= "CHAOS" then return end

        self:SetNWFloat("StartTime", CurTime())
        self:SetNWFloat("EndTime", CurTime() + RESUPPLY_STATION_COOLDOWN)
        self:SetNWEntity("Target", caller)

        net.Start("AU.ResupplyStation.Fetch")
            net.WriteEntity(self)
        net.Send(caller)

        local hub = self
        timer.Create("AU.ResupplyStation.Fetch." .. tostring(self:EntIndex()), RESUPPLY_STATION_COOLDOWN, 1, function ()
            RESUPPLY_STATION(caller)
            self:CancelFetch()
        end)
    end

    function ENT:CancelFetch()
        self:SetNWEntity("Target", Entity(0))

        local cur_time = CurTime()
        self:SetNWFloat("StartTime", cur_time)
        self:SetNWFloat("EndTime", cur_time)    

        timer.Remove("AU.ResupplyStation.Fetch." .. tostring(self:EntIndex()))
    end
elseif CLIENT then
    hook.Add("PostDrawHUD", "AU.ResupplyStation.HubHUD", function ()
        local trace = LocalPlayer():GetEyeTrace()

        if not IsValid(trace.Entity) or trace.Entity:GetClass() ~= "au_resupply_station" then return end
    
        if trace.Entity:GetPos():DistToSqr(LocalPlayer():GetPos()) > 14000 then return end

        local progress = trace.Entity:GetRetrievalProgress()
    
        if progress < 1 and trace.Entity:GetNWEntity("Target") == LocalPlayer() then
            draw.RoundedBox(0, (ScrW() - 300) / 2, (ScrH() - 60) / 2, 300, 60, Color(40, 30, 30))
            draw.RoundedBox(0, (ScrW() - 300) / 2 + 7, (ScrH() - 60) / 2 + 7, Lerp(progress, 0, 286), 46, Color(80, 0, 0))    
        end
    end)

    net.Receive("AU.ResupplyStation.Fetch", function ()
        local hub = net.ReadEntity()
        
        hook.Add("Think", "AU.ResupplyStation.Fetch", function ()
            local trace = LocalPlayer():GetEyeTrace()

            if (IsValid(trace.Entity) and trace.Entity:GetClass() == "au_resupply_station" and trace.Entity:GetPos():DistToSqr(LocalPlayer():GetPos()) < 14000) then return end

            net.Start("AU.ResupplyStation.Cancel")
                net.WriteEntity(hub)
            net.SendToServer()

            hook.Remove("Think", "AU.ResupplyStation.Fetch")
        end)

        timer.Create("AU.ResupplyStation.Fetch", RESUPPLY_STATION_COOLDOWN, 1, function ()
            hook.Remove("Think", "AU.ResupplyStation.Fetch")
        end)
    end)
end

function ENT:GetRetrievalProgress()
    local cur_time = CurTime()
    local start_time = self:GetNWFloat("StartTime", cur_time)
    local end_time = self:GetNWFloat("EndTime", cur_time)

    return (cur_time - start_time) / (end_time - start_time)
end

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "SupplyCount")

    self:SetSupplyCount(5)
end