AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "[AU] Supply Depot"
ENT.Spawnable = true
 
ENT.PrintName		= "Hub"
ENT.Author			= "Buckell"
ENT.Contact			= "Bucklet#8987"

local SUPPLY_DEPOT_HUB_COOLDOWN = 10

if SERVER then
    util.AddNetworkString("AU.SupplyDepot.HubFetch")
    util.AddNetworkString("AU.SupplyDepot.HubCancel")

    net.Receive("AU.SupplyDepot.HubCancel", function (len, ply)
        local hub = net.ReadEntity()

        if not IsValid(hub) or hub:GetClass() ~= "au_dep_hub" then return end

        if hub:GetNWEntity("Target") ~= ply then return end

        hub:CancelFetch()
    end)

    function ENT:Initialize()
        self:SetModel("models/hunter/blocks/cube2x2x2.mdl")
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
        if Cooldown("USE au_dep_hub", 1) then return end

        if self:GetRetrievalProgress() < 1 or self:GetSupplyCount() <= 0 then return end

        local active_weapon = caller:GetActiveWeapon()

        if IsValid(active_weapon) and active_weapon:GetClass() == "au_held_hub_crate" then return end

        -- IST & D-Class Check
        if caller:getJobTable().category ~= "Initial Security Team" and caller:getJobTable().category ~= "D-Class" and caller:getJobTable().category ~= "SITE STAFF" and caller:getJobTable().faction ~= "CHAOS" then return end

        self:SetNWFloat("StartTime", CurTime())
        self:SetNWFloat("EndTime", CurTime() + SUPPLY_DEPOT_HUB_COOLDOWN)
        self:SetNWEntity("Target", caller)

        net.Start("AU.SupplyDepot.HubFetch")
            net.WriteEntity(self)
        net.Send(caller)

        local hub = self
        timer.Create("AU.SupplyDepot.FetchHubCrate." .. tostring(self:EntIndex()), SUPPLY_DEPOT_HUB_COOLDOWN, 1, function ()
            caller:SetActiveWeapon(caller:Give("au_held_hub_crate"))
            --caller:GetActiveWeapon():Deploy()
            hub:SetSupplyCount(hub:GetSupplyCount() - 1)
        end)
    end

    function ENT:CancelFetch()
        self:SetNWEntity("Target", Entity(0))

        local cur_time = CurTime()
        self:SetNWFloat("StartTime", cur_time)
        self:SetNWFloat("EndTime", cur_time)    

        timer.Remove("AU.SupplyDepot.FetchHubCrate." .. tostring(self:EntIndex()))
    end
elseif CLIENT then
    function ENT:Draw()
        local pos = self:GetPos()
        local ang = self:GetAngles()

        local supplies = self:GetSupplyCount()

        if supplies > 0 then
            render.Model({
                model = "models/props_blackmesa/bms_metalcrate_64x96.mdl",
                pos = self:LocalToWorld(Vector(20, 20, -48)),
                angle = ang
            })

            render.Model({
                model = "models/items/ammocrate_smg1.mdl", -- models/props_marines/ammocrate01_static.mdl
                pos = self:LocalToWorld(Vector(30, -30, -35)),
                angle = ang
            })

            if supplies < 2 then return end

            render.Model({
                model = "models/items/ammocrate_smg1.mdl",
                pos = self:LocalToWorld(Vector(-22, -21, -35)),
                angle = self:LocalToWorldAngles(Angle(0, -45, 0))
            })

            if supplies < 3 then return end

            render.Model({
                model = "models/items/ammocrate_smg1.mdl",
                pos = self:LocalToWorld(Vector(-33, 30, -35)),
                angle = self:LocalToWorldAngles(Angle(0, -90, 0))
            })
        else
            render.Model({
                model = "models/props_junk/cardboard_box001b.mdl",
                pos = self:LocalToWorld(Vector(-10, -23, -25)),
                angle = self:LocalToWorldAngles(Angle(0, 0, 45))
            })

            render.Model({
                model = "models/props_junk/cardboard_box003a.mdl",
                pos = self:LocalToWorld(Vector(30, 30, -34)),
                angle = ang
            })

            render.Model({
                model = "models/props_junk/wood_crate001a.mdl",
                pos = self:LocalToWorld(Vector(-10, 20, -28)),
                angle = ang
            })

            render.Model({
                model = "models/props_junk/cardboard_box002a.mdl",
                pos = self:LocalToWorld(Vector(30, -10, -34)),
                angle = ang
            })

            render.Model({
                model = "models/props_junk/cardboard_box004a.mdl",
                pos = self:LocalToWorld(Vector(-10, 20, -4)),
                angle = ang
            })

            render.Model({
                model = "models/props_junk/MetalBucket01a.mdl",
                pos = self:LocalToWorld(Vector(-35, -20, -39)),
                angle = ang
            })
        end
    end

    hook.Add("PostDrawHUD", "AU.SupplyDepot.HubHUD", function ()
        local trace = LocalPlayer():GetEyeTrace()

        if not IsValid(trace.Entity) or trace.Entity:GetClass() ~= "au_dep_hub" then return end
    
        if trace.Entity:GetPos():DistToSqr(LocalPlayer():GetPos()) > 14000 then return end

        local progress = trace.Entity:GetRetrievalProgress()
    
        if progress < 1 and trace.Entity:GetNWEntity("Target") == LocalPlayer() then
            draw.RoundedBox(7, (ScrW() - 60) / 2, (ScrH() - 60) / 2 - 70, 60, 60, Color(40, 30, 30))
            draw.SimpleTextOutlined(tostring(trace.Entity:GetSupplyCount()), "DermaLarge", ScrW() / 2, ScrH() / 2 - 70, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))

            draw.RoundedBox(7, (ScrW() - 300) / 2, (ScrH() - 60) / 2, 300, 60, Color(40, 30, 30))
            draw.RoundedBox(7, (ScrW() - 300) / 2 + 7, (ScrH() - 60) / 2 + 7, Lerp(progress, 0, 286), 46, Color(80, 0, 0))    
        else
            draw.RoundedBox(7, (ScrW() - 60) / 2, (ScrH() - 60) / 2, 60, 60, Color(40, 30, 30))
            draw.SimpleTextOutlined(tostring(trace.Entity:GetSupplyCount()), "DermaLarge", ScrW() / 2, ScrH() / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
        end
    end)

    net.Receive("AU.SupplyDepot.HubFetch", function ()
        local hub = net.ReadEntity()
        
        hook.Add("Think", "AU.SupplyDepot.HubFetch", function ()
            local trace = LocalPlayer():GetEyeTrace()

            if (IsValid(trace.Entity) and trace.Entity:GetClass() == "au_dep_hub" and trace.Entity:GetPos():DistToSqr(LocalPlayer():GetPos()) < 14000) then return end

            net.Start("AU.SupplyDepot.HubCancel")
                net.WriteEntity(hub)
            net.SendToServer()

            hook.Remove("Think", "AU.SupplyDepot.HubFetch")
        end)

        timer.Create("AU.SupplyDepot.HubFetch", SUPPLY_DEPOT_HUB_COOLDOWN, 1, function ()
            hook.Remove("Think", "AU.SupplyDepot.HubFetch")
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