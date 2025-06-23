SWEP.PrintName = "SCP-1048-A"
SWEP.Category = "SCP"
SWEP.Author = "Ninjapenguin16 & Bilbo"
SWEP.Instructions = "Left click to scream"
SWEP.Spawnable = true
SWEP.AdminOnly = false

-- Basic SWEP setup
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.ViewModel = ""
SWEP.WorldModel = ""

-- Cache all players on the server 
scp1048AllPlayers = scp1048AllPlayers or {}

-- Add player to list when connecting
hook.Add("PlayerInitialSpawn", "scp1048plyjoin", function(ply)
	scp1048AllPlayers[ply:SteamID64()] = ply
end)

-- Remove player from list when disconnecting
hook.Add("PlayerDisconnected", "scp1048plyleave", function(ply)
	scp1048AllPlayers[ply:SteamID64()] = nil
end)

-- Gets all players in a given radius of the source player excluding themselves
function SWEP:GetPlayersInRadius(SourcePlayer, Radius)
    local PlayersInRadius = {}
    local SourcePos = SourcePlayer:GetPos()

    for _, player in pairs(scp1048AllPlayers) do
        if(player ~= SourcePlayer and SourcePos:Distance(player:GetPos()) <= Radius) then
            table.insert(PlayersInRadius, player)
        end
    end

    return PlayersInRadius
end

-- Apply a given damage to a player over the given time
function SWEP:ApplyDamageOverTime(Inflictor, Players, Damage, Duration)
    local DamageInterval = 1 -- Apply damage every second
    local DamagePerTick = Damage / Duration -- Damage to apply per tick

    for _, player in ipairs(Players) do
        timer.Create("SCP1048DamageTimer" .. player:SteamID64(), DamageInterval, Duration, function()
            if(IsValid(player)) then
                local dmgInfo = DamageInfo()
                dmgInfo:SetDamage(DamagePerTick)
                dmgInfo:SetAttacker(Inflictor)
                dmgInfo:SetInflictor(Inflictor)
                dmgInfo:SetDamageType(DMG_RADIATION)

                player:TakeDamageInfo(dmgInfo)
            end
        end)
    end
end

-- Run when SWEP is first initialized at server start
function SWEP:Initialize()

	-- Default stance when holding SWEP
	self:SetHoldType("passive")

end

-- Run when SWEP is deployed
function SWEP:Deploy()

	local Owner = self:GetOwner()

	-- Only set health once per life
	if(Owner:GetMaxHealth() ~= scp1048config.SCP1048AHealth) then

		Owner:SetMaxHealth(scp1048config.SCP1048AHealth)

		Owner:SetHealth(scp1048config.SCP1048AHealth)
		
	end

end

-- Called when the left mouse button is pressed
function SWEP:PrimaryAttack()

	-- Stops from being called multiple times per use
	if not(IsFirstTimePredicted()) then
		return
	end

	-- Server side takes precedent over this but function won't be called without it
	if(CLIENT) then
		self:SetNextPrimaryFire(CurTime() + 5)
	end

	if(SERVER) then

		-- Can use only after set cooldown
		self:SetNextPrimaryFire(CurTime() + scp1048config.ScreamCooldown)

		local Owner = self:GetOwner()

		local OwnerPos = Owner:GetPos()

		local AffectedPlayers = self:GetPlayersInRadius(Owner, scp1048config.ScreamRadius)

		-- Have user hear scream without being part of detection list
		net.Start("scp1048:playscream")
		net.WriteEntity(Owner)
		net.WriteString(scp1048config.ScreamSoundFile)
		net.Send(Owner)

		-- Have each player in range hear the scream
		for _, player in ipairs(AffectedPlayers) do
			net.Start("scp1048:playscream")
			net.WriteEntity(Owner)
			net.WriteString(scp1048config.ScreamSoundFile)
			net.Send(player)
		end

		-- Apply ticking damage to all players in range of scream
		self:ApplyDamageOverTime(Owner, AffectedPlayers, scp1048config.TotalScreamDamage, scp1048config.ScreamDamageDuration)

	end

end