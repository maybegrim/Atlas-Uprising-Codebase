
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end
    self:SetNextPrimaryFire(CurTime() + 1)
    if self:GetOwner():GetNWBool("ATLAS662.Cloaked", false) then
        ATLAS662.UnCloak(self:GetOwner())
    else
        
        if self:IsSeen() then
            net.Start("ATLAS662.Notify.Seen")
            net.Send(self:GetOwner())
            return
        end
        ATLAS662.Cloak(self:GetOwner())
    end
end

function SWEP:SecondaryAttack()
    if not self:CanPrimaryAttack() then return end
    self:SetNextPrimaryFire(CurTime() + 1)

    
    if self:GetOwner():GetNWBool("ATLAS662.NoClipped", false) then
        ATLAS662.UnNoclip(self:GetOwner())
    else
        ATLAS662.Noclip(self:GetOwner())
    end

end
local reloadDelay = 0
function SWEP:Reload()
    if reloadDelay > CurTime() then return end
    reloadDelay = CurTime() + 1
    self:GetOwner():SendLua("ATLAS662.UI()")
end

function SWEP:CanPrimaryAttack()
    return self:GetNextPrimaryFire() < CurTime()
end