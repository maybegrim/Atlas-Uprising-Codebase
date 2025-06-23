SWEP.Category               = "SCP-939 SWEP"
SWEP.PrintName              = "AU edit SCP-939"        
SWEP.Author                 = "Matius"
SWEP.Instructions           = "Working 939 Swep"
SWEP.ViewModelFOV           = 56
SWEP.Spawnable              = true
SWEP.AdminOnly              = false
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Delay          = 2
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "None"
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "None"
SWEP.Weight                 = 3
SWEP.AutoSwitchTo           = false
SWEP.AutoSwitchFrom         = false
SWEP.Slot                   = 0
SWEP.SlotPos                = 4
SWEP.DrawAmmo               = false
SWEP.DrawCrosshair          = true
SWEP.droppable              = false
SWEP.Primary.Distance       = 200
SWEP.IdleAnim               = true
SWEP.ViewModel              = ""
SWEP.WorldModel             = ""
SWEP.IconLetter             = "w"
SWEP.Primary.Sound          = ("weapons/939/bite.wav")
SWEP.HoldType               = "knife"
local SwepOwner				= nil
local Voice = {"talk1.mp3", "talk2.mp3", "talk3.mp3", "talk4.mp3", "talk5.mp3"}

function SWEP:Deploy() self:SetHoldType( "normal" ) end


function SWEP:PrimaryAttack()
    self.Weapon:SetNextPrimaryFire( CurTime() + 1 )
    self:EmitSound('weapons/scp939/bite.wav')
end


function SWEP:SecondaryAttack()

    local ply = self.Owner
    if not ply:Alive() then return end

    self:EmitSound("weapons/scp939/" .. Voice[math.random(1, #Voice)])
    self:SetNextSecondaryFire(CurTime() + 3)

end