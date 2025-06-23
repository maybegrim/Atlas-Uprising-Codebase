AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "[AU] Ping Collar"
ENT.Spawnable = true

ENT.PrintName = "Collar Activate Screen"
ENT.Author = "Bilbo"

AU.PingCollar = AU.PingCollar or {}
AU.PingCollar.ActivationTime = 2 -- Set the activation time

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
        if phys:IsValid() then
            phys:Wake()
        end
    end

    function ENT:Use(activator, caller)
        if self:GetPos():DistToSqr(activator:GetPos()) > 15000 then return end

        self:EmitSound("buttons/button15.wav")

        -- Start sound timer for players with ping collars
        for _, p in ipairs(player.GetAll()) do
            if IsValid(p) and p:IsPlayer() and p:HasPingCollar() then
                self:StartSoundTimer(p)
            end
        end
    end

    function ENT:StartSoundTimer(player)
        timer.Create("AU.PingCollar.Activate_" .. player:UserID(), AU.PingCollar.ActivationTime, 1, function()
            if IsValid(player) and player:IsPlayer() and player:HasPingCollar() then
                player:SetNWFloat("AU.PingCollar.StartActivateTime", CurTime())
                player:StartCollar()
                self:StartLoopSound(player)
            end
        end)
    end

    function ENT:StartLoopSound(player)
        -- Create a unique timer for the player
        timer.Create("AU.PingCollar.LoopSound_" .. player:UserID(), 5, 0, function()

            -- Let 939's see person with beeping collar for 1 second after beep
            player:SetNWBool("BeepingCollarBeep", true)
            timer.Create("SendTempBeepTo939" .. player:UserID(), 1, 1, function()
                player:SetNWBool("BeepingCollarBeep", false)
            end)

            if IsValid(player) and player:IsPlayer() and player:HasPingCollar() then
                sound.Play("buttons/combine_button2.wav", player:GetPos(), 75, 100, 1)
            else
                -- Stop the loop sound for this player if they are no longer valid or have removed the collar
                timer.Remove("AU.PingCollar.LoopSound_" .. player:UserID())
            end
        end)
    end
end

if CLIENT then
    surface.CreateFont("AU.PingCollar.Screen", {
        font = "Courier New",
        size = 35,
        antialias = true,
        weight = 700
    })

    function ENT:Draw()
        local ply = LocalPlayer()
        
        self:DrawModel()

        local sqr_dist = ply:GetPos():DistToSqr(self:GetPos())
        local alpha = 255
        if sqr_dist > 90000 then 
            alpha = Lerp((sqr_dist - 90000) / 90000, 255, 0) 
        end 
        if alpha == 0 then return end

        cam.Start3D2D(self:LocalToWorld(Vector(-23.7, -47.5, 1.6)), self:LocalToWorldAngles(Angle(0, 90, 0)), 0.1)
            draw.DrawText("Activate", "AU.PingCollar.Screen", 1900 / 4, 200, Color(0, 200, 0, alpha), TEXT_ALIGN_CENTER)
            draw.DrawText("PING COLLARS", "AU.PingCollar.Screen", 1900 / 4, 240, Color(0, 200, 0, alpha), TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end