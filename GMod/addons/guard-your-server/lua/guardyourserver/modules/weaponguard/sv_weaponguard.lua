--[[
    CREDITS:
    Atlas Uprising
]]
if not GYS.WeaponGuard then return end

--[[
    Hook: GYS.WeaponGuard
    Checks for a certain group of weapons to be not
    spawned unless by the whitelisted groups.
]]
hook.Add( "PlayerCanPickupWeapon", "GYS.WeaponGuard", function( ply, weapon )
    if ply:IsSuperAdmin() then return end
    if GYS.WGUserGroups[GYS.GetUserGroup(ply)] then return end
    if GYS.WeaponList[weapon:GetClass()] then
        return false
    end
end )
GYS.Log("WeaponGuard Loaded")