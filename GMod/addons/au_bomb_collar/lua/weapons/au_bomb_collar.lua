AddCSLuaFile()

if CLIENT then
    SWEP.Slot = 5
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

SWEP.PrintName = "Bomb Collar"
SWEP.Author = "Buckell"

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Category = "[AU] Bomb Collar"

SWEP.Primary.ClipSize = -1      -- Size of a clip
SWEP.Primary.DefaultClip = 0        -- Default number of bullets in a clip
SWEP.Primary.Automatic = false      -- Automatic/Semi Auto
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1        -- Size of a clip
SWEP.Secondary.DefaultClip = -1     -- Default number of bullets in a clip
SWEP.Secondary.Automatic = false        -- Automatic/Semi Auto
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
            trace.Entity:SetBombCollar(true)
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