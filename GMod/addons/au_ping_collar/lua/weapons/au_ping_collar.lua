AddCSLuaFile()

if CLIENT then
    SWEP.Slot = 5
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

SWEP.PrintName = "Ping Collar"
SWEP.Author = "Bilbo"

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Category = "[AU] Ping Collar"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.ViewModel = "models/weapons/v_slam.mdl"
SWEP.WorldModel = "models/hunter/tubes/tube2x2x025.mdl"

function SWEP:Initialize()
    self:SetHoldType("slam")

    if CLIENT then
        self.ModelInstance = ClientsideModel(self.WorldModel)
        self.ModelInstance:SetColor(Color(0, 0, 0))
        self.ModelInstance:SetMaterial("models/debug/debugwhite")
        self.ModelInstance:SetModelScale(0.1)
    end
end

function SWEP:SetupModel()
    if CLIENT then
        self.ModelInstance:SetNoDraw(false)
    end
end

function SWEP:CleanupModel()
    if CLIENT and self.ModelInstance then
        self.ModelInstance:SetNoDraw(true)
    end
end

function SWEP:OnRemove()
    self:CleanupModel()
end

function SWEP:Holster()
    self:CleanupModel()
    return true
end

function SWEP:Deploy()
    self:SetupModel()
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + 0.5)

    local trace = self:GetOwner():GetEyeTrace()

    if IsValid(trace.Entity) and trace.Entity:IsPlayer() and trace.Entity:GetPos():DistToSqr(self:GetOwner():GetPos()) <= 10000 then        
        if SERVER then
            trace.Entity:EmitSound("doors/door_latch1.wav")
            self:Remove()
            trace.Entity:SetPingCollar(true)
            net.Start("PingCollarApply")
            net.WriteEntity(trace.Entity)
            net.Broadcast()
        end
    end
end

function SWEP:DrawWorldModel()
    local owner = self:GetOwner()

    if not self.ModelInstance then return end

    if IsValid(owner) then
        local bone_id = owner:LookupBone("ValveBiped.Bip01_R_Hand")
        if not bone_id then return end

        local matrix = owner:GetBoneMatrix(bone_id)
        if not matrix then return end

        local new_pos, new_ang = LocalToWorld(Vector(7, -4, 0), Angle(0, -30, 100), matrix:GetTranslation(), matrix:GetAngles())

        self.ModelInstance:SetPos(new_pos)
        self.ModelInstance:SetAngles(new_ang)

        self.ModelInstance:SetupBones()
    else
        self.ModelInstance:SetPos(self:GetPos())
        self.ModelInstance:SetAngles(self:GetAngles())
    end

    self.ModelInstance:DrawModel()
end

if SERVER then
    util.AddNetworkString("PingCollarApply")
    util.AddNetworkString("SetPingCollarNoDraw")

    hook.Add("PlayerDeath", "SetPingCollarNoDrawOnDeath", function(victim, inflictor, attacker)
        if victim:GetNWBool("HasPingCollar", true) then
            victim:SetPingCollar(false)
            net.Start("SetPingCollarNoDraw")
            net.WriteEntity(victim)
            net.Broadcast()
        end
    end)
end

if CLIENT then
    local PingCollars = {}

    net.Receive("PingCollarApply", function()
        local victim = net.ReadEntity()
        if IsValid(victim) then
            -- Ensure we don't create multiple collars for the same player
            if IsValid(PingCollars[victim:EntIndex()]) then
                PingCollars[victim:EntIndex()]:Remove()
            end
            
            local collar = ClientsideModel("models/hunter/tubes/tube2x2x025.mdl")
            collar:SetModelScale(0.07)
            collar:SetColor(Color(0, 0, 0))
            collar:SetMaterial("models/debug/debugwhite")
            collar:SetNoDraw(true)
            victim:SetNWBool("HasPingCollar", true)

            PingCollars[victim:EntIndex()] = collar

            hook.Add("PostPlayerDraw", "DrawPingCollar_" .. victim:EntIndex(), function(ply)
                if ply == victim and IsValid(PingCollars[victim:EntIndex()]) then
                    local bone_id = ply:LookupBone("ValveBiped.Bip01_Neck1")
                    if not bone_id then return end

                    local matrix = ply:GetBoneMatrix(bone_id)
                    if not matrix then return end

                    local new_pos, new_ang = LocalToWorld(Vector(1, -2, 0), Angle(0, 100, 90), matrix:GetTranslation(), matrix:GetAngles())

                    PingCollars[victim:EntIndex()]:SetPos(new_pos)
                    PingCollars[victim:EntIndex()]:SetAngles(new_ang)
                    PingCollars[victim:EntIndex()]:SetNoDraw(false)
                    PingCollars[victim:EntIndex()]:DrawModel()
                end
            end)
        end
    end)

    net.Receive("SetPingCollarNoDraw", function()
        local victim = net.ReadEntity()
        if IsValid(victim) and IsValid(PingCollars[victim:EntIndex()]) then
            PingCollars[victim:EntIndex()]:Remove()
            PingCollars[victim:EntIndex()] = nil

            -- Remove the hook specific to this victim
            hook.Remove("PostPlayerDraw", "DrawPingCollar_" .. victim:EntIndex())
        end
    end)
end