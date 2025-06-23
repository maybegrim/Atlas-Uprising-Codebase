
include("shared.lua")

function SWEP:PrimaryAttack()

end

function SWEP:SecondaryAttack()
end


--[[function SWEP:CalcViewModelView(ViewModel, oldPos, oldAng, pos, ang)
    -- Offset the view model position
    local newPos = pos + ang:Forward() * 15 + ang:Right() * 5 + ang:Up() * -5

    -- Preserve pitch and roll, adjust yaw with smooth transition
    local targetYaw = ang.y + 280
    local currentYaw = ang.y

    -- Smoothly interpolate yaw (optional, for smoother movement)
    local newYaw = Lerp(0.7, currentYaw, targetYaw)
    local newAng = Angle(ang.p / 10, newYaw, ang.r)

    return newPos, newAng
end]]