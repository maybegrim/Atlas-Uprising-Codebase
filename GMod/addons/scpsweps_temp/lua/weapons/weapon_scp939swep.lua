if (SERVER) then
	resource.AddFile("sound/weapons/scp939/bite.mp3") -- if you want to add bite sound - change it
	resource.AddFile("sound/weapons/scp939/chase.mp3")
	SWEP.Weight = 10
end
--              ^
-- don't touch /|\
--              |

SWEP.Author = "AmCande"
SWEP.Purpose = "Bite people, if they make noise."
SWEP.Instructions = "LMB to bite, RMB to play chase sound."
SWEP.Category = "Atlas Uprising - Temp SCP Sweps" -- Q menu category (weapons->SCP-939)
SWEP.PrintName = "SCP 939" -- Name we see in weapon selection
SWEP.AutoSwitchTo = true -- Auto switch to 
SWEP.AutoSwitchFrom	= false -- Auto switch from
SWEP.Spawnable = true -- Spawnable with Q menu
SWEP.AdminOnly = false -- Not only admin spawnable

SWEP.Slot = 0 -- Slot 
SWEP.SlotPos = 0 -- Position in slot
SWEP.DrawAmmo = false -- We don't need HUD here
SWEP.DrawCrosshair = true -- To see what we'll bite

SWEP.HoldType = "melee" -- Holding as melee (for animations)

SWEP.FiresUnderwater = true -- We can bite underwater

SWEP.Primary.ClipSize = -1 -- Removing ammo to make sure we have infinite bites
SWEP.Primary.DefaultClip = -1 -- We have our jaws

SWEP.Primary.NumberofShots = 1 -- We have 2 heads? No.. only 1.
SWEP.Primary.Force = 50 -- Just for fun
SWEP.Primary.Damage = 1000 -- Bite damage
SWEP.Primary.Recoil = 1 -- We can't perfectly hit same spot always.

SWEP.Primary.Automatic = false -- Auto bite

SWEP.Primary.Ammo = "" -- Type of our jaws ammo

SWEP.Primary.Sound = Sound("weapons/scp939/bite.mp3") -- Bite sound
SWEP.Secondary.Sound = Sound("weapons/scp939/chase.mp3") -- Chase sound

SWEP.Primary.Delay = 0.3 -- How fast we can bite (edit will cause nothing)
SWEP.Secondary.Delay = 4 -- Chase sound delay (edit will cause nothing)

SWEP.Secondary.ClipSize = -1 -- We don't need more than 1 sound
SWEP.Secondary.DefaultClip = -1 -- Same here
SWEP.Secondary.Automatic = false -- No automatic
SWEP.Secondary.Damage = 0 -- Sound damage
SWEP.Secondary.Ammo = "" -- Infinite sounds

SWEP.IsMelee = true -- If you want to animations work - don't touch this
SWEP.WorldModel = "" -- Removing revolver model floating in air
SWEP.MeleeDamage = 1000 -- Bite damage (another)
SWEP.MeleeRange = 70 -- Bite range (optimized for models from workshop)
SWEP.MeleeSize = 1.5 -- Size of attack area
SWEP.MeleeKnockBack = 0 -- No knockback (1 hit)
SWEP.ISSCP=!!1 -- if you look at SCP-173 he can move

function SWEP:Initialize()	-- When we get our weapon we need to precache sounds to work
	util.PrecacheSound("sound/weapons/scp939/bite.mp3")
	util.PrecacheSound("sound/weapons/scp939/chase.mp3")
	self:SetWeaponHoldType(self.HoldType) -- Hold type (animations won't work without this)
	if (SERVER) then
	
		self:SetWeaponHoldType(self.HoldType) -- Hold type (animations won't work without this)
		self.Weapon:SetMoveType( MOVETYPE_WALK ) -- Move type (animations won't work without this)
	end
end

function SWEP:Deploy() -- What happens when we deploy weapon
	if SERVER then
		self:GetOwner():DrawViewModel(false) -- Hiding viewmodel (we bite, we don't slash)
		self:GetOwner():DrawWorldModel(false) -- We don't need weapon model (usually it floating in air)
	end
		if self:GetOwner():IsValid() then -- Speed (Default walk speed - 255)
		    local FOV = 80
	self:GetOwner():SetRunSpeed(400)
	self:GetOwner():SetFOV(FOV + 20, 0.2) 
	end
end

function SWEP:FindHullIntersection(VecSrc, tr, Mins, Maxs, pEntity) -- Don't touch this please

  local VecHullEnd = VecSrc + ((tr.HitPos - VecSrc) * 2)

  local tracedata = {}

  tracedata.start  = VecSrc  
  tracedata.endpos = VecHullEnd
  tracedata.filter = pEntity
  tracedata.mask   = MASK_SOLID
  tracedata.mins   = Mins
  tracedata.maxs   = Maxs

  local tmpTrace = util.TraceLine( tracedata )

  if tmpTrace.Hit then
    tr = tmpTrace
    return tr
  end

  local Distance = 999999

  for i = 0, 1 do
    for j = 0, 1 do
      for k = 0, 1 do

        local VecEnd = Vector()

        VecEnd.x = VecHullEnd.x + (i>0 and Maxs.x or Mins.x)
        VecEnd.y = VecHullEnd.y + (j>0 and Maxs.y or Mins.y)
        VecEnd.z = VecHullEnd.z + (k>0 and Maxs.z or Mins.z)

        tracedata.endpos = VecEnd

        tmpTrace = util.TraceLine( tracedata )

        if tmpTrace.Hit then
          ThisDistance = (tmpTrace.HitPos - VecSrc):Length()
          if (ThisDistance < Distance) then
            tr = tmpTrace
            Distance = ThisDistance
          end
        end
      end -- for k
    end -- for j
  end --for i

  return tr
end

function SWEP:PrimaryAttack() -- When we press M1    (range of bite here)
	if not self:CanPrimaryAttack() then return end
	self.Weapon:SetNextPrimaryFire(CurTime()+self.Primary.Delay) -- If we bite, create delay for next bite
	self.Weapon:SetNextSecondaryFire(CurTime()+self.Primary.Delay) -- If we bite, create delay for next sound

	local weapon = self.Weapon -- Don't touch!
	local biter = self:GetOwner() -- Don't touch!
	local range = 70 -- Bite range. (optimized for models from workshop)
	local aimvec = biter:GetAimVector() -- Don't touch!
	local biteSrc = biter:GetShootPos() -- Don't touch!
	local biteRng = biteSrc+aimvec*range -- Don't touch!
	local trace = self:GetOwner():GetEyeTrace() -- Don't touch!
	local tracedata = {} -- Don't touch!
	
	tracedata.start = biteSrc -- Don't touch!
	tracedata.endpos = biteRng -- Don't touch!
	tracedata.filter = biter -- Don't touch!
	tracedata.mask = MASK_SOLID -- Don't touch!
	tracedata.mins = Vector(-20, -20, -20) -- Don't touch!
	tracedata.maxs = Vector(20, 20, 20) -- Don't touch!
	
	local tr = util.TraceLine(tracedata) -- Don't touch!
	if not tr.Hit then tr = util.TraceHull(tracedata) end -- Don't touch!
	if tr.Hit and (not (IsValid(tr.Entity) and tr.Entity) or tr.HitWorld) then  -- Don't touch!
		local hullDuckMins, hullDuckMaxs = biter:GetHullDuck()
		tr = self:FindHullIntersection(biteSrc, tr, hullDuckMins, hullDuckMaxs, biter)
		biteRng = tr.HitPos -- This is the point on the actual surface (the hull could have hit space)
	end
	
	local HitEntity = IsValid(tr.Entity) and tr.Entity or Entity(0) -- Don't touch!
	local damage = self.Primary.Damage -- Don't touch!
	local force = aimvec:GetNormalized() * 200 * self.Primary.Force -- Don't touch!
	local damageinfo = DamageInfo() -- Don't touch!
	damageinfo:SetAttacker(biter) -- Don't touch!
	damageinfo:SetInflictor(self) -- Don't touch!
	damageinfo:SetDamage(damage) -- Don't touch!
	damageinfo:SetDamageType(bit.bor(DMG_BULLET,DMG_NEVERGIB)) -- Don't touch!
	damageinfo:SetDamageForce(force) -- Don't touch!
	damageinfo:SetDamagePosition(biteRng) -- Don't touch!
	
	HitEntity:DispatchTraceAttack(damageinfo, tr, aimvec) -- Don't touch!
	
	if tr.HitWorld and not tr.HitSky then -- Don't touch!
		local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos + tr.HitNormal)
		effectdata:SetStart(tr.StartPos)
		effectdata:SetSurfaceProp(tr.SurfaceProps)
		effectdata:SetDamageType(DMG_SLASH)
		effectdata:SetHitBox(tr.HitBox)
		effectdata:SetNormal(tr.HitNormal)
		effectdata:SetEntity(tr.Entity)
		effectdata:SetAngles(aimvec:Angle())
		util.Effect("biteImpact", effectdata)
		util.Decal("ManhackCut", biteSrc - aimvec, biteRng + aimvec, true)
		--weapon:EmitSound(Sound("Weapon_Crowbar.Melee_Hit"))
	elseif trace.Entity:IsPlayer() or trace.Entity:IsNPC() or trace.Entity:GetClass() == "prop_ragdoll" then
		local effectdata = EffectData()
		util.Effect( "BloodImpact", effectdata )
		--weapon:EmitSound(Sound("Weapon_Crowbar.Melee_Hit"))
	end
	
	self:GetOwner():ViewPunch(Angle(rnda, rndb, rnda)) -- Don't touch!
end

function SWEP:CanPrimaryAttack() -- If we can bite, we can make next bite
	if (self.Weapon.Primary.ClipSize <= 0) then
		return true
	end
end

function SWEP:SecondaryAttack() -- When we press M2
	self:CanSecondaryAttack() -- If we can M2
	self:GetOwner():EmitSound("weapons/scp939/chase.mp3", 100, 100, 1) -- M2 sound
	self:SetNextSecondaryFire(CurTime()+7) -- Delay Between sounds (touch this only if you know what youre doing)
	if self:GetOwner():Alive() then
		self:GetOwner():ViewPunch(Angle(rnda, rndb, rnda))
	end
end

function SWEP:CanSecondaryAttack() -- If we can make sound, we can make next sound
	if (self.Weapon.Secondary.ClipSize <= 0) then
		return true
	end
end

function SWEP:Reload() -- Add something here if you want
end
-- END of code, thanks for reading!  Now go and check out some new & cool addons from AmCande

if SERVER then
	hook.Add("PlayerChangedTeam", "AU.939.SpeedGlitchFix", function(ply, prev)
		if team.GetName(prev) == "SCP-939 'With Many Voices'" then
			ply:SetRunSpeed(240)
		end
	end)
end