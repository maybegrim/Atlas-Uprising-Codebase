AddCSLuaFile()

SWEP.Author			= "Atlas Uprising"
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 54
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= ""
SWEP.WorldModel		= ""

SWEP.PrintName		= "SCP-6750"
SWEP.Slot			= 01
SWEP.SlotPos		= 0
SWEP.Spawnable		= true
SWEP.AdminSpawnable	= true
SWEP.UseHands 		= true
SWEP.Category 		= "Atlas Uprising - Temp SCP Sweps"
SWEP.AttackDelay	= 0.25
SWEP.droppable		= false
SWEP.NextAttackW	= 0


function SWEP:Deploy()
	self.Owner:DrawViewModel(false)
end

function SWEP:DrawWorldModel()

end

function SWEP:Initialize()
    self:SetHoldType("normal")
end

hook.Add( "EntityTakeDamage", "NoDamage", function( ply, dmginfo )
  local dmg = DamageInfo()
  local attacker = dmginfo:GetAttacker()

  if not ply:IsPlayer() then return end
  if not ply:HasWeapon("scp_6750") then return end
  if not IsValid(attacker) then return end
  if attacker:Health() <= 0 then return end
  
  dmg:SetDamageType(dmginfo:GetDamageType())
  dmg:SetDamage(dmginfo:GetDamage())
  dmg:SetAttacker(ply)
  dmg:SetInflictor(ply)
  dmginfo:GetAttacker():TakeDamageInfo(dmg)
  return true
end)

function SWEP:PrimaryAttack()
    
end

function SWEP:SecondaryAttack()
    
end

function SWEP:Reload()
    
end