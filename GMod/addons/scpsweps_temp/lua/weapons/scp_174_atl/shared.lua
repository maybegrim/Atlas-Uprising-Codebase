-- Variables that are used on both client and server
SWEP.Gun = ("scp_174_atl") -- must be the name of your swep but NO CAPITALS!
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "bobs_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Category				= "Atlas Uprising - Temp SCP Sweps"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ("Left click to slash".."\n".."Right click to stab.".."\n".."Reload to find target.")
SWEP.PrintName				= "SCP-174-ATL"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 0				-- Slot in the weapon selection menu
SWEP.SlotPos				= 24			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= true		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "knife"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_knife_x.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_extreme_ratio.mdl"	-- Weapon world model
SWEP.ShowWorldModel			= true
SWEP.Base				= "bobs_gun_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.RPM			= 180			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 30		-- Size of a clip
SWEP.Primary.DefaultClip		= 60		-- Bullets you start with
SWEP.Primary.KickUp				= 0.4		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.3		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.3		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= ""			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.IronFOV			= 55		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.Damage		= 30	-- Base damage per bullet
SWEP.Primary.Spread		= .02	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .01 -- Ironsight accuracy, should be the same for shotguns

//Enter iron sight info and bone mod info below
-- SWEP.IronSightsPos = Vector(-2.652, 0.187, -0.003)
-- SWEP.IronSightsAng = Vector(2.565, 0.034, 0) 		//not for the knife
-- SWEP.SightsPos = Vector(-2.652, 0.187, -0.003)		//just lower it when running
-- SWEP.SightsAng = Vector(2.565, 0.034, 0)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-25.577, 0, 0)

SWEP.Slash = 1

-- SWEP.Primary.Sound	= Sound("Weapon_Knife.Slash") //woosh
-- SWEP.KnifeShink = ("Weapon_Knife.HitWall")
-- SWEP.KnifeSlash = ("Weapon_Knife.Hit")
-- SWEP.KnifeStab = ("Weapon_Knife.Stab")

SWEP.Primary.Sound	= Sound("weapons/blades/woosh.mp3") //woosh
SWEP.KnifeShink = Sound("weapons/blades/hitwall.mp3")
SWEP.KnifeSlash = Sound("weapons/blades/slash.mp3")
SWEP.KnifeStab = Sound("weapons/blades/nastystab.mp3")

if SERVER then
	util.AddNetworkString("AU.174.Stalk")
end

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Weapon:EmitSound("weapons/knife/knife_draw_x.mp3", 50, 100)
	return true
end

function SWEP:PrimaryAttack()
	vm = self:GetOwner():GetViewModel()
	if self:CanPrimaryAttack() and self:GetOwner():IsPlayer() then
	self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
		if !self:GetOwner():KeyDown(IN_SPEED) and !self:GetOwner():KeyDown(IN_RELOAD) then
			if self.Slash == 1 then
				vm:SetSequence(vm:LookupSequence("midslash1"))
				self.Slash = 2
			else
				vm:SetSequence(vm:LookupSequence("midslash2"))
				self.Slash = 1
			end --if it looks stupid but works, it aint stupid!
			self.Weapon:EmitSound(self.Primary.Sound)//slash in the wind sound here
			if CLIENT then return end
			timer.Create("cssslash", .15, 1, function() 
			if not IsValid(self) then return end
			if IsValid(self:GetOwner()) 
			
			and IsValid(self.Weapon) 
			
			then self:PrimarySlash() end end)

			self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
			self.Weapon:SetNextPrimaryFire(CurTime()+1/(self.Primary.RPM/60))
		end
	end
end

function SWEP:PrimarySlash()

	pos = self:GetOwner():GetShootPos()
	ang = self:GetOwner():GetAimVector()
	damagedice = math.Rand(.85,1.25)
	pain = self.Primary.Damage * damagedice
	self:GetOwner():LagCompensation(true)
	if IsValid(self:GetOwner()) and IsValid(self.Weapon) then
		if self:GetOwner():Alive() then if self:GetOwner():GetActiveWeapon():GetClass() == self.Gun then
			local slash = {}
			slash.start = pos
			slash.endpos = pos + (ang * 32)
			slash.filter = self:GetOwner()
			slash.mins = Vector(-10, -5, 0)
			slash.maxs = Vector(10, 5, 5)
			local slashtrace = util.TraceHull(slash)
			if slashtrace.Hit then
				targ = slashtrace.Entity
				if targ:IsPlayer() or targ:IsNPC() then
					//find a way to splash a little blood
					self.Weapon:EmitSound(self.KnifeSlash)//stab noise
					paininfo = DamageInfo()
					paininfo:SetDamage(pain)
					paininfo:SetDamageType(DMG_SLASH)
					paininfo:SetAttacker(self:GetOwner())
					paininfo:SetInflictor(self.Weapon)
					paininfo:SetDamageForce(slashtrace.Normal *35000)
					if SERVER then targ:TakeDamageInfo(paininfo) end
				else
					self.Weapon:EmitSound(self.KnifeShink)//SHINK!
					look = self:GetOwner():GetEyeTrace()
					util.Decal("ManhackCut", look.HitPos + look.HitNormal, look.HitPos - look.HitNormal )
				end
			end
		end end
	end
	self:GetOwner():LagCompensation(false)
end


function SWEP:SecondaryAttack()
	pos = self:GetOwner():GetShootPos()
	ang = self:GetOwner():GetAimVector()
	vm = self:GetOwner():GetViewModel()
	if self:CanPrimaryAttack() and self:GetOwner():IsPlayer() then
	self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
		if !self:GetOwner():KeyDown(IN_SPEED) and !self:GetOwner():KeyDown(IN_RELOAD) then
			local stab = {}
			stab.start = pos
			stab.endpos = pos + (ang * 24)
			stab.filter = self:GetOwner()
			stab.mins = Vector(-10,-5, 0)
			stab.maxs = Vector(10, 5, 5)
			local stabtrace = util.TraceHull(stab)
			if stabtrace.Hit then
				vm:SetSequence(vm:LookupSequence("stab"))
			else
				vm:SetSequence(vm:LookupSequence("stab_miss"))
			end
			
			timer.Create("cssstab", .33, 1 , function() if not IsValid(self) then return end
			if IsValid(self:GetOwner()) and IsValid(self.Weapon) then 
				if self:GetOwner():Alive() and self:GetOwner():GetActiveWeapon():GetClass() == self.Gun then 
					self:Stab() end
				end
			end)

			self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
			self.Weapon:SetNextPrimaryFire(CurTime()+1/(self.Primary.RPM/60))
			self.Weapon:SetNextSecondaryFire(CurTime()+1.25)
		end
	end
end

function SWEP:Stab()

	pos2 = self:GetOwner():GetShootPos()
	ang2 = self:GetOwner():GetAimVector()
	damagedice = math.Rand(.85,1.25)
	pain = 100 * damagedice
	self:GetOwner():LagCompensation(true)
	local stab2 = {}
	stab2.start = pos2
	stab2.endpos = pos2 + (ang2 * 24)
	stab2.filter = self:GetOwner()
	stab2.mins = Vector(-10,-5, 0)
	stab2.maxs = Vector(10, 5, 5)
	local stabtrace2 =  util.TraceHull(stab2)

	if IsValid(self:GetOwner()) and IsValid(self.Weapon) then
		if self:GetOwner():Alive() then if self:GetOwner():GetActiveWeapon():GetClass() == self.Gun then
			if stabtrace2.Hit then
			targ = stabtrace2.Entity
				if targ:IsPlayer() or targ:IsNPC() then
					paininfo = DamageInfo()
					paininfo:SetDamage(pain)
					paininfo:SetDamageType(DMG_SLASH)
					paininfo:SetAttacker(self:GetOwner())
					paininfo:SetInflictor(self.Weapon)
					paininfo:SetDamageForce(stabtrace2.Normal *75000)
					if SERVER then targ:TakeDamageInfo(paininfo) end
					self.Weapon:EmitSound(self.KnifeStab)//stab noise
				else
					self.Weapon:EmitSound(self.KnifeShink)//SHINK!
					look = self:GetOwner():GetEyeTrace()
					util.Decal("ManhackCut", look.HitPos + look.HitNormal, look.HitPos - look.HitNormal )
				end
			else
				self.Weapon:EmitSound(self.Primary.Sound)
			end
		end end
	end
	self:GetOwner():LagCompensation(false)
end

function SWEP:CanTargetPly(ply, scpPly)
	print("RAN")
	if ATLASCFG.SCPTeams[ply:Team()] then
		return false
	elseif team.GetName(ply:Team()) == "Staff On Duty" then
		return false
	elseif team.GetName(ply:Team()) == "Choosing..." then
		return false
	elseif ply:IsDClass() then
		return false
	elseif scpPly == ply then
		return false
	else
		return true
	end
end

function SWEP:IronSight()

	if !self:GetOwner():IsNPC() then
	if self.ResetSights and CurTime() >= self.ResetSights then
	self.ResetSights = nil
	self:SendWeaponAnim(ACT_VM_IDLE)
	end end
	if self:GetOwner():KeyDown(IN_SPEED) and not (self.Weapon:GetNWBool("Reloading")) then		-- If you are running
	self.Weapon:SetNextPrimaryFire(CurTime()+0.3)				-- Make it so you can't shoot for another quarter second
	self.IronSightsPos = self.RunSightsPos					-- Hold it down
	self.IronSightsAng = self.RunSightsAng					-- Hold it down
	self:SetIronsights(true, self:GetOwner())					-- Set the ironsight true
	self:GetOwner():SetFOV( 0, 0.3 )
	end								

	if self:GetOwner():KeyReleased (IN_SPEED) then	-- If you release run then
	self:SetIronsights(false, self:GetOwner())					-- Set the ironsight true
	self:GetOwner():SetFOV( 0, 0.3 )
	end								-- Shoulder the gun
	
end
local SCPTeams = {
	["SCP-6286-ATL 'The Raven'"] = true,
	["SCP-4000-W 'Joseph'"] = true,
	["SCP-1048 'The Builder Bear'"] = true,
	["SCP-966 'The Sleep Demon'"] = true,
	["SCP-939 'With Many Voices'"] = true,
	["SCP-860-2 'The Forest Monster'"] = true,
	["SCP-682 'Indestructible Lizard'"] = true,
	["SCP-553-ATL 'The Friendly Giant'"] = true,
	["SCP-457 'The Burning Man'"] = true,
	["SCP-420-ATL 'El Chino'"] = true,
	["SCP-397 'Lola'"] = true,
	["SCP-174-ATL 'Stalking Clown'"] = true,
	["SCP-131-A 'Eyepods'"] = true,
	["SCP-106 'The Old Man'"] = true,
	["SCP-096 'Shy Guy'"] = true,
	["SCP-076-2 'Able'"] = true,
	["SCP-066 'Beethoven'"] = true,
	["SCP-049 'The Plague Doctor'"] = true,
	["SCP-131-A 'Eyepods'"] = true,
	["SCP-131-B 'Eyepods'"] = true,
	["SCP-343 'God'"] = true,
	["SCP-662 'Mr. Deeds'"] = true,
	["SCP-912 'Autonomous SWAT Armor'"] = true,
	["SCP-999 'The Tickle Monster'"] = true,
	["SCP-1048-A 'The Ear Bear'"] = true,
	["SCP-774-ATL 'Aegis'"] = true,
	["SCP-947-ATL '1-Inch Warrior'"] = true,
	["SCP-2451-ATL 'The Lost Lumberjacks'"] = true
}
local DClassTeam = {
    ["D-Class"] = true,
    ["Experienced D-Class"] = true,
    ["Expert D-Class"] = true,
    ["D-Class Chad"] = true,
    ["D-Class Cook"] = true,
    ["D-Class Kitchen Staff"] = true,
    ["D-Class Dealer"] = true,
    ["D-Class Commander"] = true,
}
function SWEP:Reload()
	if SERVER then
		if self:GetOwner():GetNWBool("AU.174.HasTarget", false) then return end
		if not isnumber(reloadDelay) then reloadDelay = CurTime() - 1 end
		if CurTime() < reloadDelay then return end
		local stalkees = {}
		for k,v in pairs(ents.FindInSphere( self:GetOwner():GetPos(), 1000 )) do
			if not v:IsPlayer() then continue end
			if self:CanTargetPly(v, self:GetOwner()) then
				stalkees[k] = v
			end
		end
		if table.IsEmpty(stalkees) then
			for k,v in pairs(player.GetAll()) do
				if self:CanTargetPly(v, self:GetOwner()) then
					stalkees[k] = v
				end
			end
		end
		if table.IsEmpty(stalkees) then
			self:GetOwner():SendLua("chat.AddText(Color(255,56,56),'[SCP.GG] ',Color(255,255,255),'There is no people to stalk.')")
			return
		end
		local stalkee = table.Random(stalkees)
		self:GetOwner():SetNWBool("AU.174.HasTarget", true)
		net.Start("AU.174.Stalk")
		net.WriteEntity(stalkee)
		net.Send(self:GetOwner())
		hook.Add( "PlayerDeath", "174.Death", function( victim, inflictor, attacker )
			if victim == stalkee and team.GetName(attacker:Team()) == "SCP-174-ATL 'Stalking Clown'" then
				attacker:SendLua("hook.Remove('PreDrawHalos', 'AU.174.Glow')")
				attacker:SetNWBool("AU.174.HasTarget", false)
			end
			if victim == attacker then
				attacker:SendLua("hook.Remove('PreDrawHalos', 'AU.174.Glow')")
				attacker:SetNWBool("AU.174.HasTarget", false)
			end
		end )
		local reloadDelay = CurTime() + 120
	end
end

if CLIENT then
	net.Receive("AU.174.Stalk", function()
		local highlightPly = net.ReadEntity()
		chat.AddText(Color(255,56,56), "[SCP.GG] ", Color(255,255,255), "Your targets name is ", highlightPly:Nick(), ".")
		hook.Add( "PreDrawHalos", "AU.174.Glow", function()
			if team.GetName(LocalPlayer():Team()) ~= "SCP-174-ATL 'Stalking Clown'" then return end
			halo.Add( {highlightPly}, Color(220,80,70), 1, 1, 20, true, true )
		end)
	end)
end




if GetConVar("M9KUniqueSlots") != nil then
	if not (GetConVar("M9KUniqueSlots"):GetBool()) then 
		SWEP.SlotPos = 2
	end
end