SWEP.PrintName = "966 Cure"
SWEP.Author = "Bilbo"
SWEP.Instructions = "Use this to cure the SCP-966 effect."
SWEP.Spawnable = true
SWEP.Category = "SCP"
SWEP.AdminSpawnable = false

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.ViewModel = "models/weapons/darky_m/c_syringe_v2.mdl"
SWEP.WorldModel = "models/weapons/darky_m/w_syringe_v2.mdl"

if CLIENT then return end

function SWEP:PrimaryAttack()
    local ply = self.Owner
    local traceData = {
        start = ply:GetShootPos(),
        endpos = ply:GetShootPos() + ply:GetAimVector() * 150,
        filter = ply
    }
    local tr = util.TraceLine(traceData) --asdasd
    local target = tr.Entity
    print(HasCondition966(target, "SCP966Effect"))
    if not IsValid(target) or not target:IsPlayer() or not HasCondition966(target, "SCP966Effect") then ply:ChatPrint("No valid target found.") return end
    RemoveCondition966(target, "SCP966Effect")
    target:ChatPrint("You feel the effects of SCP-966 fade away.")
    ply:ChatPrint("You have cured " .. target:Nick() .. " of the SCP-966 effect.")

    if SERVER then
        net.Start("SCP966_RemoveEffect")
        net.Send(target)
    end

    self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:SecondaryAttack() end
