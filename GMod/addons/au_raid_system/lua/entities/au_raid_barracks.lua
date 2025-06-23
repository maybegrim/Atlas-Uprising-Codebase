AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "[AU] Raid System"
ENT.Spawnable = true
 
ENT.PrintName		= "Barracks Clearing Screen"
ENT.Author			= "Buckell"
ENT.Contact			= "Bucklet#8987"

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/hunter/plates/plate1x1.mdl")
        self:SetColor(Color(70, 70, 70, 255))
        self:SetMaterial("models/debug/debugwhite")
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
        if AU.RaidSystem.GetPlayerFaction(caller) == AU.RaidSystem.CurrentRaid.Faction then return end
        
        if self:GetPos():DistToSqr(activator:GetPos()) > 15000 then return end
        self:SetCleared(true)
        local closest = 1000000
        local closestentity
        for _,v in pairs(ents.FindByClass("au_raid_timer")) do
            local distance = v:GetPos():DistToSqr(self:GetPos())
            if distance > closest then continue end
            closestentity = v
            closest = distance
        end
        
        if not closestentity or not closestentity:IsValid() then return end
        closestentity:SetCleared(true)
    end
    hook.Add("AU.RaidSystem.RaidEnd", "AU.RaidSystem.BarracksReset", function ()
        for _,v in pairs(ents.FindByClass("au_raid_barracks")) do
            v:SetCleared(false)
        end
        for _,v in pairs(ents.FindByClass("au_raid_timer")) do
            v:SetCleared(false)
        end
    end)
end

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "Cleared")
    self:SetCleared(false)
end

if CLIENT then
    surface.CreateFont("AU.RaidSystem.Barracks.Clear", {
        font = "Courier New",
        size = 130,
        antialias = true,
        weight = 700
    })
    surface.CreateFont("AU.RaidSystem.Barracks.Cleared.Title", {
        font = "Courier New",
        size = 100,
        antialias = true,
        weight = 700
    })
    surface.CreateFont("AU.RaidSystem.Barracks.Cleared.Sub", {
        font = "Courier New",
        size = 30,
        antialias = true,
        weight = 700
    })
    
    function ENT:Draw()
        self:DrawModel()
        local raid_time = AU.RaidSystem.GetRaidTime()
        if raid_time > 0 then
            local sqr_dist = ply:GetPos():DistToSqr(self:GetPos())
            local alpha = 255
            if sqr_dist > 90000 then alpha = Lerp((sqr_dist - 90000) / 90000, 255, 0) end 
            if alpha == 0 then return end
        
            cam.Start3D2D(self:LocalToWorld(Vector(-23.7, -47.5, 1.6)), self:LocalToWorldAngles(Angle(0, 90, 0)), 0.1)
                if not self:GetCleared() then
                    if AU.RaidSystem.GetPlayerFaction(LocalPlayer()) == AU.RaidSystem.CurrentRaid.Faction then return end
                    draw.DrawText("CLEAR", "AU.RaidSystem.Barracks.Clear", 1900 / 4, 90, Color(0, 200, 0, alpha), TEXT_ALIGN_CENTER)
                    draw.DrawText("BUNKS", "AU.RaidSystem.Barracks.Clear", 1900 / 4, 210, Color(0, 200, 0, alpha), TEXT_ALIGN_CENTER)
                else
                    draw.DrawText("CLEARED", "AU.RaidSystem.Barracks.Cleared.Title", 1900 / 4, 90, Color(200, 0, 0, alpha), TEXT_ALIGN_CENTER)
                    draw.DrawText("Your barracks have been", "AU.RaidSystem.Barracks.Cleared.Sub", 1900 / 4, 200, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
                    draw.DrawText("cleared. You may no longer", "AU.RaidSystem.Barracks.Cleared.Sub", 1900 / 4, 240, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
                    draw.DrawText("participate in the raid.", "AU.RaidSystem.Barracks.Cleared.Sub", 1900 / 4, 280, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
                end
            cam.End3D2D()
        end
    end
end