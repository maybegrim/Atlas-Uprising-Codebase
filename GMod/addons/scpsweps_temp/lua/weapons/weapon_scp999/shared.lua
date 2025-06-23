AddCSLuaFile()

SWEP.Base 					= "weapon_base"

SWEP.HoldType 				= "normal"
SWEP.ViewModel 				= ""
SWEP.WorldModel 			= ""

SWEP.PrintName 				= "SCP 999 SWEP"
SWEP.Author 				= "Edit by zgredinzyyy"
SWEP.Instructions 			= "Lewy Przycisk - Leczenie\nPrzeładowanie - Sound Effect\nPrawy Przycisk - Śmiech"
SWEP.Category 				= "Atlas Uprising - Temp SCP Sweps"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.AdminOnly				= false
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= true
SWEP.UseHands				= true
SWEP.Primary.ClipSize 		= -1
SWEP.Primary.DefaultClip 	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay			= 0.1
SWEP.Slot 					= 0
SWEP.SlotPos				= 0
SWEP.ShouldDropOnDie 		= false

function SWEP:Equip()
	self.Owner:SetHealth(99999)
end
	
function SWEP:PrimaryAttack()
  
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    local found
    local lastDot = -1
    self:GetOwner():LagCompensation(true)
    local aimVec = self:GetOwner():GetAimVector()
    local shootPos = self:GetOwner():GetShootPos()

    for _, v in ipairs(player.GetAll()) do
        local maxhealth = v:GetMaxHealth() or 100
        local targetShootPos = v:GetShootPos()
        if v == self:GetOwner() or targetShootPos:DistToSqr(shootPos) > 7225 or v:Health() >= maxhealth or not v:Alive() then continue end

        local direction = targetShootPos - shootPos
        direction:Normalize()
        local dot = direction:Dot(aimVec)

        if dot > lastDot then
            lastDot = dot
            found = v
        end
    end
    self:GetOwner():LagCompensation(false)

    if found then
        found:SetHealth(found:Health() + 1)
        self:EmitSound("buttons/blip1.wav", 65, found:Health() / found:GetMaxHealth() * 100, 0.2, CHAN_AUTO)
    end

end

function SWEP:SecondaryAttack()
  self:SetNextSecondaryFire(CurTime() + 3)
  self:EmitSound("weapons/999/rawr.wav", 65, math.random(80,150), 1, CHAN_AUTO)
end

function SWEP:Reload()
  self:EmitSound("weapons/999/squish.wav", 65, math.random(80,150), 1, CHAN_AUTO)	
end
