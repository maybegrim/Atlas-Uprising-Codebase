AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

-- on weapon equip strip weapon_empty_hands and make all speeds the same as walking
function SWEP:Equip()
    self:GetOwner():StripWeapon("weapon_empty_hands")
    self.PrevOwner = self:GetOwner()
    self.PrevOwnerWSpeed = self.PrevOwner:GetWalkSpeed()
    self.PrevOwnerRSpeed = self.PrevOwner:GetRunSpeed()
    self:GetOwner():SetWalkSpeed(150)
    self:GetOwner():SetRunSpeed(150)
    self:GetOwner():SetCustomCollisionCheck(true)
end

-- on weapon unequip set walk and run speed back to normal
function SWEP:OnRemove()
    self.PrevOwner:SetWalkSpeed(self.PrevOwnerWSpeed)
    self.PrevOwner:SetRunSpeed(self.PrevOwnerRSpeed)
    self.PrevOwner:SetCustomCollisionCheck(false)
end

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:PrimaryAttack()
    if ( self:GetOwner():IsPlayer() ) then
        self:GetOwner():LagCompensation( true )
    end
    local trace = self:GetOwner():GetEyeTrace()
    if ( self:GetOwner():IsPlayer() ) then
        self:GetOwner():LagCompensation( false )
    end
    
    local targetPlayer = trace.Entity

    local maxRange = 125

    if targetPlayer:IsPlayer() then
        local distance = self:GetOwner():GetPos():Distance(targetPlayer:GetPos())
        print(distance)
        if distance <= maxRange then
            --targetPlayer:EmitSound("path/to/your/sound.wav")

            timer.Create("sink_timer_" .. tostring(targetPlayer:UserID()), 0.1, 15, function()
                if not IsValid(targetPlayer) then return end

                targetPlayer:SetPos(targetPlayer:GetPos() + Vector(0, 0, -3))
            end)

            timer.Simple(1.5, function() 
                if not IsValid(targetPlayer) then return end
                targetPlayer:SetPos(ATLASSCPSWEPS.SCP106.PocketDimension)
            end)
        end
    end

    self:SetNextPrimaryFire(CurTime() + 0.5)
end




function SWEP:SecondaryAttack()

end