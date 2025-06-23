SWEP.PrintName = "SCP 4793"
SWEP.Author = "Marbles"
SWEP.Instructions = "Press left click to attack, press right click to block. Has passive healing"
SWEP.Spawnable = true
SWEP.ViewModel = "models/weapons/v_romansword.mdl"
SWEP.WorldModel = "models/weapons/w_roman_sword_1_reference.mdl"
SWEP.Category = "SCP-4793"

SWEP.Slash = 1
SWEP.Blocking = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

-- Configurables
SWEP.Primary.AttackSpeed = 2 -- Bigger number means more attacks per second
SWEP.Primary.Damage = 25
SWEP.Primary.HitDistance = 75
SWEP.HealTimer = 10
SWEP.HealAmount = 30
SWEP.BlockMoveSpeed = 2 -- Bigger number means slower movement
SWEP.BlockCooldown = 2

-- Sounds
SWEP.SwingSound = "weapons/blades/woosh.mp3"
SWEP.HitSound = "weapons/blades/nastystab.mp3"
SWEP.HitProp = "weapons/blades/impact.mp3"
SWEP.HitWorld = "weapons/blades/hitwall.mp3"


local playersToHeal = {}
local defaultWalkSpeed = 0
local defaultRunSpeed = 0

function SWEP:Initialize()
    self:SetHoldType("melee2")

    if not timer.Exists("SCP4793_PassiveHealth") then
        timer.Create("SCP4793_PassiveHealth", self.HealTimer, 0, function()
            if table.Count(playersToHeal) == 0 then
                timer.Pause("SCP4793_PassiveHealth")
                return
            end
        
            for _, ply in pairs(playersToHeal) do
                if IsValid(ply) and ply:IsPlayer() then
                    local wep = ply:GetWeapon("scp4793")
                    if IsValid(wep) then
                        local healAmount = wep.HealAmount
                        local currentHealth = ply:Health()
                        local maxHealth = ply:GetMaxHealth()
        
                        if currentHealth < maxHealth then
                            local newHealth = math.min(currentHealth + healAmount, maxHealth)
                            ply:SetHealth(newHealth)
                        end
                    else
                        playersToHeal[ply:SteamID()] = nil
                    end
                end
            end
        end)
    end
end

function SWEP:Equip(ply)
    playersToHeal[ply:SteamID()] = ply

    timer.UnPause("SCP4793_PassiveHealth")

    if defaultWalkSpeed == 0 then
        defaultWalkSpeed = ply:GetWalkSpeed()
    end
    if defaultRunSpeed == 0 then
        defaultRunSpeed = ply:GetRunSpeed()
    end
end

function SWEP:PrimaryAttack()
    if not self.Owner:IsPlayer() then return end
    if self.Blocking then return end

    local wep = self.Owner:GetViewModel()
    self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
    if self.Slash == 1 then
        wep:SetSequence(wep:LookupSequence("midslash1"))
        self.Slash = 2
    else
        wep:SetSequence(wep:LookupSequence("midslash2"))
        self.Slash = 1
    end
    self.Weapon:EmitSound(self.SwingSound)

    local owner = self.Owner
    local startPos = owner:GetShootPos()
    local endPos = startPos + (owner:GetAimVector() * self.Primary.HitDistance)   

    local hullMins = Vector(-15, -5, 0)
    local hullMaxs = Vector(15, 5, 5)
    local trace = util.TraceHull({
        start = startPos,
        endpos = endPos,
        filter = owner,
        mins = hullMins,
        maxs = hullMaxs,
        mask = MASK_SHOT_HULL
    })
            
    if trace.Hit then
        local hitEntity = trace.Entity
        if trace.HitWorld then
            self.Weapon:EmitSound(self.HitWorld)
        elseif IsValid(hitEntity) then
            if not hitEntity:IsPlayer() and not hitEntity:IsNPC() then
                self.Weapon:EmitSound(self.HitProp)
            else
                self.Weapon:EmitSound(self.HitSound)
                local dmgInfo = DamageInfo()
                if self.Blocking then
                    dmgInfo:SetDamage(self.Primary.Damage * .6)
                else
                    dmgInfo:SetDamage(self.Primary.Damage)
                end
                dmgInfo:SetDamage(self.Primary.Damage)
                dmgInfo:SetAttacker(owner)
                dmgInfo:SetInflictor(self)
                dmgInfo:SetDamageType(DMG_SLASH)
                hitEntity:TakeDamageInfo(dmgInfo)
            end
        end
    else
        self.Weapon:EmitSound(self.SwingSound)
    end

    self.Owner:SetAnimation(PLAYER_ATTACK1)
    self:SetNextPrimaryFire(CurTime() + 1 / self.Primary.AttackSpeed)
end

function SWEP:SecondaryAttack()
    if not self.Owner:IsPlayer() then return end
    self.Blocking = not self.Blocking

    local owner = self.Owner
    
    if self.Blocking then
        owner:SetWalkSpeed(owner:GetWalkSpeed() / self.BlockMoveSpeed)
        owner:SetRunSpeed(owner:GetWalkSpeed() / self.BlockMoveSpeed)
    else
        owner:SetWalkSpeed(defaultWalkSpeed)
        owner:SetRunSpeed(defaultRunSpeed)
    end

    self:SetNextSecondaryFire(CurTime() + 1 * self.BlockCooldown)
end

hook.Add("PlayerDisconnected", "SCP4793_RemoveOnDisconnect", function(ply)
    playersToHeal[ply:SteamID()] = nil
    if table.Count(playersToHeal) == 0 then
        timer.Pause("SCP4793_PassiveHealth")
        return
    end
end)

hook.Add("PlayerSpawn", "SCP4793_JobChange", function(ply) 
    if ply:HasWeapon("scp4793") then
        playersToHeal[ply:SteamID()] = ply
    else
        playersToHeal[ply:SteamID()] = nil
    end

    if table.Count(playersToHeal) > 0 then
        timer.UnPause("SCP4793_PassiveHealth")
        return
    end
end)

hook.Add("HUDPaint", "SCP4793_BlockHUD", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local wep = ply:GetActiveWeapon()
    if not IsValid(wep) then return end

    if wep.Blocking then
        local text = "Blocking"
        local font = "DermaLarge"
        local x, y = ScrW() / 2, 30
        draw.SimpleText(text, font, x, y, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end)