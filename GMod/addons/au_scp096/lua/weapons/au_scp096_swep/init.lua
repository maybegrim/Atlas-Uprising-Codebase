AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("SCP096FaceSeen")

SWEP.IsEnraged = false

function SWEP:Initialize()
    self:SetHoldType("melee")
end

targetply096 = {}

local function Update096HitList(ply)
    if ply:HasWeapon("AU_scp096_swep") then 
        ply.diedas096 = true
        timer.Simple(10, function() if ply and ply:IsValid() then ply.diedas096 = false end end)
    end
    targetply096[ply] = nil
    ply:SetNWBool("SCP:096SAWFACE", false)
end


hook.Add("PlayerDeath", "Remove096TargetDeath", function(victim, inflictor, attacker)
    Update096HitList(victim)
end)

hook.Add("PlayerDisconnected", "Remove096TargetLeave", function(ply)
    Update096HitList(ply)
end)

function SWEP:OnRemove()
    if self.faceEntity and self.faceEntity:IsValid() then 
        self.faceEntity:Remove()
    end
    for ply, k in pairs(targetply096) do
        ply:SetNWBool("SCP:096SAWFACE", false)
        targetply096[ply] = nil
    end
    targetply096 = {}
    scp096currentplayer.swep = nil
    scp096currentplayer = nil
    if not self:GetOwner() then return end
    self:GetOwner():StopSound("scp096/SCP096ScreamFadein.wav")
    if self.ScreamSoundNumber then self:GetOwner():StopLoopingSound(self.ScreamSoundNumber) end
    if self.CrySoundNumber then self:GetOwner():StopLoopingSound(self.CrySoundNumber) end
end

SWEP.ScreamSoundNumber = nil
function SWEP:Enrage()
    local owner = self:GetOwner()
    if owner.bagged then return end

    self.IsEnraged = true

    owner:SetRunSpeed(50)
    owner:SetWalkSpeed(50)

    owner:EmitSound("scp096/SCP096ScreamFadein.wav")

    print("SCP-096 is Warming Up!")
    timer.Simple(8, function()
        if owner.diedas096 then owner.diedas096 = false return end
        owner:StopSound("scp096/SCP096ScreamFadein.wav")
        self.ScreamSoundNumber = owner:StartLoopingSound("scp096/SCP096ScreamLoop.wav")
        owner:SprintEnable()
        self:SetHoldType("melee")
        owner:SetRunSpeed(scp096config.RageRunSpeed)
        owner:SetWalkSpeed(scp096config.RageWalkSpeed)
    end)
    
end

function SWEP:Unenrage()
    local owner = self:GetOwner()

    owner:StopSound("scp096/SCP096ScreamLoop.wav")
    owner:StopLoopingSound(self.ScreamSoundNumber)
    owner:EmitSound("scp096/SCP096ScreamFadeOut.wav")
    self.IsEnraged = false
    owner:SprintDisable()
    self:SetHoldType("normal")
    owner:SetRunSpeed(scp096config.CalmRunSpeed)
    owner:SetWalkSpeed(scp096config.CalmWalkSpeed)
    owner:StopSound("scp096/SCP096ScreamFadeOut.wav")
end

-- Handle crying sound when crouchedadads
SWEP.CrySoundNumber = nil
function SWEP:Think()

    local owner = self:GetOwner()

    if not owner or not owner:IsValid() or not owner:Alive() then return end
    if not table.IsEmpty(targetply096) then
        if self.IsEnraged then return end
        self:Enrage()
    elseif self.IsEnraged then
        self:Unenrage()
    end

    -- Crouch & don't move means cry.
    if not self.IsEnraged and owner:Crouching() and (owner:GetVelocity() == Vector(0, 0, 0)) then
        if self.CrySoundNumber == nil then
            self.CrySoundNumber = owner:StartLoopingSound("scp096/SCP096CryLoop.wav")
            print("Started Crying Sound: " .. tostring(self.CrySoundNumber))
        end
    elseif self.CrySoundNumber ~= nil then
        owner:StopLoopingSound(self.CrySoundNumber)
        self.CrySoundNumber = nil
    end

    return true
end

function SWEP:PrimaryAttack()

    if not IsFirstTimePredicted() then return end
    if not self.IsEnraged then return end
    
    local owner = self:GetOwner()
    
    local traceData = {}
    traceData.start = owner:GetShootPos()
    traceData.endpos = traceData.start + owner:GetAimVector() * 150
    traceData.filter = owner
    traceData.mins = Vector(-16, -16, -16)
    traceData.maxs = Vector(16, 16, 16)

    local tr = util.TraceHull(traceData)
    
    if tr.Hit and IsValid(tr.Entity) and tr.HitPos:Distance(owner:GetPos()) <= 150 then
        if tr.Entity:IsPlayer() then
            local dmgInfo = DamageInfo()
            dmgInfo:SetAttacker(owner)
            dmgInfo:SetInflictor(self)
            dmgInfo:SetDamage(9999) 
            tr.Entity:TakeDamageInfo(dmgInfo)
        elseif not tr.Entity.Saw096 then
            return
        end
    end

    local VModel = owner:GetViewModel()
    local EnumToSeq = VModel:SelectWeightedSequence(ACT_VM_PRIMARYATTACK)
    VModel:SendViewModelMatchingSequence(EnumToSeq)

    timer.Simple(1, function()
        if IsValid(owner) then
            local VModel = owner:GetViewModel()
            local EnumToSeq = VModel:SelectWeightedSequence(ACT_RESET)
            VModel:SendViewModelMatchingSequence(EnumToSeq)
        end
    end)

    self:SetNextPrimaryFire(CurTime() + 0.5)
end


function SWEP:SecondaryAttack() end

scp096checkbone = "ValveBiped.Bip01_Head1"
 
function SWEP:Deploy()
    local owner = self:GetOwner()
    scp096currentplayer = owner
    owner.swep = self
    if not IsValid(owner) then return end
    owner:StripWeapon("weapon_empty_hands")
    timer.Simple(1, function()
        self.faceEntity = ents.Create("scp096_face_tracker") -- Create the entityadasd
        if not self.faceEntity or not self.faceEntity:IsValid() then print("096 face entity not able to spawn.") return end
        self.faceEntity:SetParent(owner) -- Set the entity's parent to the playeadadar
        self:DeleteOnRemove(self.faceEntity)
        local boneID = owner:LookupBone(scp096checkbone)
        if not boneID then print("Could not find the 096 head.") self.faceEntity:Remove() return end
        local bonepos, boneangle = owner:GetBonePosition(boneID)
        -- print(bonepos)
        -- self.faceEntity:SetLocalPos(Vector(19.5, 7.5, 37))
        -- self.faceEntity:SetLocalAngles(Angle(-5,0,-5))
        self.faceEntity:Spawn() -- Spawn the block onto the player's headasdasd
        self.faceEntity:Activate()
        self.faceEntity:FollowBone(owner, boneID)
        self.faceEntity:SetLocalPos(Vector(0.8, 2.9, 5.5)) -- Example offset (moasdasdify to fit properly)sdad
        self.faceEntity:SetLocalAngles(Angle(0, 45, -90)) 
        owner:SetModel("models/scp096anim/player/scp096pm_raf.mdl") 
    end)
    if owner:IsPlayer() then
        owner:Give("weapon_empty_hands")
    end
    return true
end
