AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "[AU] Bomb Collar"
ENT.Spawnable = true
 
ENT.PrintName		= "Equip Collar Screen"
ENT.Author			= "Buckell"
ENT.Contact			= "Bucklet#8987"

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/hunter/plates/plate025x05.mdl")
        self:SetColor(Color(30, 30, 30, 255))
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
        if self:GetPos():DistToSqr(activator:GetPos()) > 15000 then return end

        caller:SetBombCollar(true)
    end
end

if CLIENT then
    surface.CreateFont("AU.BombCollar.Screen", {
        font = "Courier New",
        size = 30,
        antialias = true,
        weight = 700
    })
    
    function ENT:Draw()
        local ply = LocalPlayer()
        
        self:DrawModel()

        local sqr_dist = ply:GetPos():DistToSqr(self:GetPos())
        local alpha = 255
        if sqr_dist > 90000 then alpha = Lerp((sqr_dist - 90000) / 90000, 255, 0) end 
        if alpha == 0 then return end
    
        cam.Start3D2D(self:LocalToWorld(Vector(-23.7, -47.5, 1.6)), self:LocalToWorldAngles(Angle(0, 90, 0)), 0.1)
            draw.DrawText("EQUIP", "AU.BombCollar.Screen", 1900 / 4, 200, Color(0, 200, 0, alpha), TEXT_ALIGN_CENTER)
            draw.DrawText("COLLAR", "AU.BombCollar.Screen", 1900 / 4, 240, Color(0, 200, 0, alpha), TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end