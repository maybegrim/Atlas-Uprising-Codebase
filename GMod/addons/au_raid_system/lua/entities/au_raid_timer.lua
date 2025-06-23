AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "[AU] Raid System"
ENT.Spawnable = true
 
ENT.PrintName		= "Raid Timer"
ENT.Author			= "Buckell"
ENT.Contact			= "Bucklet#8987"

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/hunter/plates/plate1x2.mdl")
        self:SetColor(Color(70, 70, 70, 255))
        self:SetMaterial("models/debug/debugwhite")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)

        local phys = self:GetPhysicsObject()
        if (phys:IsValid()) then
            phys:Wake()
        end
    end
end

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "Cleared")
    self:SetCleared(false)
end

if CLIENT then
    surface.CreateFont("AU.RaidSystem.Timer.Title", {
        font = "Courier New",
        size = 130,
        antialias = true,
        weight = 700
    })

    surface.CreateFont("AU.RaidSystem.Timer.Time", {
        font = "Courier New",
        size = 255,
        antialias = true,
        weight = 700
    })

    plyhasdiedinraid = false
    
    function ENT:Draw()
        local ply = LocalPlayer()

        self:DrawModel()

        if not self:GetCleared() and not AU.RaidSystem.DiedDuringRaid then return end

        local raid_time = AU.RaidSystem.GetRaidTime()

        if raid_time > 0 then
            local sqr_dist = ply:GetPos():DistToSqr(self:GetPos())
            local alpha = 255
            if sqr_dist > 90000 then alpha = Lerp((sqr_dist - 90000) / 90000, 255, 0) end 
            if alpha == 0 then return end
            
            local raid_time_minutes = raid_time / 60
            local raid_time_minutes_floor = math.floor(raid_time_minutes)
            local raid_time_seconds = math.floor((raid_time_minutes - raid_time_minutes_floor) * 60)

            local minutes_string = tostring(raid_time_minutes_floor)
            minutes_string = #minutes_string > 1 and minutes_string or "0" .. minutes_string

            local seconds_string = tostring(raid_time_seconds)
            seconds_string = #seconds_string > 1 and seconds_string or "0" .. seconds_string

            cam.Start3D2D(self:LocalToWorld(Vector(-23.7, -47.5, 1.6)), self:LocalToWorldAngles(Angle(0, 90, 0)), 0.1)
                draw.DrawText("RAID", "AU.RaidSystem.Timer.Title", 1900 / 4, 30, Color(200, 0, 0, alpha), TEXT_ALIGN_CENTER)
                draw.DrawText(":", "AU.RaidSystem.Timer.Time", 1900 / 4, 180, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
                draw.DrawText(minutes_string, "AU.RaidSystem.Timer.Time", 1900 / 4 - 20, 180, Color(255, 255, 255, alpha), TEXT_ALIGN_RIGHT)
                draw.DrawText(seconds_string, "AU.RaidSystem.Timer.Time", 1900 / 4 + 20, 180, Color(255, 255, 255, alpha), TEXT_ALIGN_LEFT)
            cam.End3D2D()
        end
    end
end