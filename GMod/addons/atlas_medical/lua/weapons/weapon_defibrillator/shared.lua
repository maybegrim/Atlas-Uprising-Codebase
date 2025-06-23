 -----------------------------------------------------------------------------------------------------
-- Config section here
-- Features
SWEP.AllowDamage = true						-- Should a player be able to inflict damage at all?
SWEP.GiveWeaponsBack = true					-- Should the player get the weapons he had back after he is revived? (Will spawn with default weps)
SWEP.DeathBeepEnabled = true				-- Should a player hear a flat tone when they die?
SWEP.ReviveHeartMedicsOnly = true			-- Should only people with SWEP equipped see the heart or every player?

-- Settings (will not take effect if feature is disabled)
SWEP.DeathSound = "HL1/fvox/flatline.wav"	-- Sound the player hears when they die (DeathBeep)
SWEP.Damage = 20							-- Damage the swep does when using for self-defense
SWEP.HPAfterRespawn = 70					-- HP the revived player will have after being revived
SWEP.TimeToRevive = 200						-- How many seconds should players be dead for before they can not be revived?
SWEP.ChargeTime = 12						-- How many seconds should charging the paddle keep a charge for?
SWEP.GhostTime = 5							-- How long should players be ghosted for upon revival? (No collision with players)
SWEP.ReviveDistance = 80					-- How far should a medic be able to revive a player?
SWEP.ReviveHeartDistance = 2000 			-- How far should someone be from a ragdoll to see the revive heart picture?
SWEP.HitDistance = 100						-- How far should a medic be from a player to damage another player?
SWEP.reviveCashTimeout = 120				-- The amount of seconds a medic will not receive money for reviving the same player
local disableRespawnTime = 0				-- How long to disallow a player from respawning for, leave at 0 to disable
SWEP.respawnPlayerOnJobChange = false		-- Should the player respawn when they change job?
-- IMPORTANT: If the above setting is true, you MUST set GM.Config.norespawn to false inside of darkrpmodification/settings.lua
-- These are the settings for the text users will see if disableRespawnTime is not 0. 
SWEP.enableRespawnText = true
SWEP.respawnWaitText = "You must wait %d seconds or until a medic comes to revive you." -- This MUST have %d in it. %d is the time left for respawn.
SWEP.respawnFont = "Trebuchet24"				-- This is the font for the respawn text.
SWEP.textXPos = -1								-- X position for the respawn text. If -1, it will be in the middle of the screen.
SWEP.textYPos = -1								-- Y position for the respawn text. If -1, it will be in the middle of the screen.
SWEP.textColor = Color(255, 255, 255, 255)		-- The color for the respawn text.
-- END CONFIG
-----------------------------------------------------------------------------------------------------
SWEP.Instructions = "Left click to revive/attack!"
SWEP.UseHands = true
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Category = "CustomHQ"
SWEP.ViewModelFOV = 62
SWEP.AnimPrefix = "rpg"
SWEP.Primary.Damage = 0
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.WorldModel = Model("models/weapons/custom/w_defib.mdl")
SWEP.ViewModel = Model("models/weapons/custom/v_defib.mdl")
SWEP.PrintName = "Defibrillator (NLR System)"
SWEP.Author = "CustomHQ"
SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.CanUse = 0
SWEP.disableRespawnTime = disableRespawnTime
SWEP.FinishCharge = 0 -- Countdown to finish defibbing player

util.PrecacheModel("models/weapons/custom/defib2")

if SERVER then

	function makefx(ent, pos, fx, ply, broadcast)
		net.Start("defibfx")
		net.WriteEntity(ent)
		net.WriteVector(pos)
		net.WriteString(fx)
		net.WriteEntity(ply)
		if broadcast then net.Broadcast()
		else net.Send(ply) end
	end

	AddCSLuaFile("cl_init.lua")
	include("sv_init.lua")
	function SWEP:OnDrop() self:makefxN("decharge") end
	function SWEP:OnRemove() self:makefxN("decharge") end
	function DisableImmRespawn(ply)
	    if (ply.CustomHQSpawnTimer == nil) then return end
	    if (ply.CustomHQLastTeamChange == nil) then ply.CustomHQLastTeamChange = 0 end
	    if ply.CustomHQSpawnTimer+disableRespawnTime > CurTime() and ply.CustomHQLastTeamChange+15 < CurTime() then
	        return false
	    end
	end
	function SetPlayerTime(ply)
	    ply.CustomHQSpawnTimer = CurTime()
	end
	if disableRespawnTime != 0 then
	    hook.Add("PostPlayerDeath", "stopfalcosimmrespawn", SetPlayerTime)
	    hook.Add("PlayerDeathThink", "stopfalcozimmrespawn", DisableImmRespawn)
	end
end
function shouldveaddedthisbefore(ply, before, after)
	if SERVER then
		local globalwep = weapons.GetStored("weapon_defibrillator")
		ply.CustomHQLastTeamChange = CurTime()
		if globalwep != nil and globalwep.respawnPlayerOnJobChange then
			ply:Spawn()
		end
	end
	ply.TimeDied = CurTime()
end
hook.Add("OnPlayerChangedTeam", "defibfalcoteamchangegoddammit", shouldveaddedthisbefore)
function SWEP:makefxN(type) makefx(self:GetOwner(), Vector(0, 0, 0), type, self:GetOwner(), false) end
--it's clientside location, need to talk with client and gmod makes that a pain in ass (afaik)
function SWEP:PrimaryAttack()
	if CLIENT or CurTime() > self.CanUse then return end
	net.Start("defibgetents")
	net.Send(self:GetOwner())
	self:GetOwner():Freeze(true)
	timer.Simple(3, function()
		self:GetOwner():Freeze(false)
	end)
end
function SWEP:SecondaryAttack()
	if CLIENT or CurTime() <= self.CanUse then return end
	--double animation because GMod is broken and doesn't play anims properly, hack around it
	self:SendWeaponAnim(ACT_VM_IDLE)
	timer.Simple(0.16, function() if IsValid(self) then self:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end end)
	self:SetNextSecondaryFire(CurTime()+self.ChargeTime+2)
	timer.Simple(.9, function()
		if !IsValid(self:GetOwner()) or !IsValid(self) then return end
		self:GetOwner():EmitSound("buttons/button1.wav", 50)
		self.CanUse = CurTime() + self.ChargeTime
		self:makefxN("charge")
	end)
end
function SWEP:Initialize()
	self:SetHoldType("knife")
end
function SWEP:Deploy()
	self.CanUse = 0
	return true
end
function SWEP:Holster()
	if SERVER then self:makefxN("decharge") end
	return true
end
function SWEP:Reload() end