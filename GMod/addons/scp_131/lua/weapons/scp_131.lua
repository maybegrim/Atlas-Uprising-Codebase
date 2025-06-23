SWEP.PrimaryCooldown = 240
SWEP.LastPrimaryAttack = 0
SWEP.SecondaryCooldown = .5
SWEP.LastSecondaryFire = 0


SWEP.PrintName = "Quipid"
SWEP.Catagory = "SCP Testing"
SWEP.Author = "Bilbo"
SWEP.Instructions = "Left click play music | Right click fart and teleport"
SWEP.Spawnable = true
SWEP.AdminOnly = true 

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
SWEP.DrawCrosshair = false 

SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.HoldType = "passive"

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then
        return
    end

    local currentTime = CurTime()
    if currentTime - self.LastPrimaryAttack < self.PrimaryCooldown then
        return
    end
    self.LastPrimaryAttack = currentTime

    local sound131 = "wilbb.mp3"
    
    if SERVER then
        local ent = self:GetOwner()
        if IsValid(ent) then
            if file.Exists("sound/" .. sound131, "GAME") then
                ent:EmitSound(sound131, 65, 100, 1, CHAN_WEAPON)
            else
                print("Sound file not found: " .. sound131)
            end
        end
    end   
end

function SWEP:SecondaryAttack()
    if not IsFirstTimePredicted() then
        return
    end

    local currentTime = CurTime()
    if currentTime - self.LastSecondaryFire < self.SecondaryCooldown then
        return
    end
    self.LastSecondaryFire = currentTime

    local soundFart = "Fart.mp3"
    local teleportPosition = Vector(-8774.795898, 1.683857, 7678.041992)
    
    if SERVER then
        local ent = self:GetOwner()
        if IsValid(ent) then
            if file.Exists("sound/" .. soundFart, "GAME") then
                ent:EmitSound(soundFart, 65, 100, 1, CHAN_WEAPON)
            else
                print("Sound file not found: " .. soundFart)
            end

            local smoke = ents.Create("env_smoketrail")
            if IsValid(smoke) then
                smoke:SetPos(ent:GetPos())
                smoke:SetKeyValue("startsize", "100")
                smoke:SetKeyValue("endsize", "200")
                smoke:SetKeyValue("spawnrate", "10")
                smoke:SetKeyValue("lifetime", "10")
                smoke:SetKeyValue("rendermode", "5")
                smoke:SetKeyValue("rendercolor", "0 255 0")
                smoke:Spawn()
                smoke:Activate()

                timer.Simple(10, function()
                    if IsValid(smoke) then
                        smoke:Remove()
                    end
                end)
            end

            local success, err = pcall(function()
                ent:SetPos(teleportPosition)
            end)
            if not success then
                print("Teleport failed:", err)
            end
        end
    end
end