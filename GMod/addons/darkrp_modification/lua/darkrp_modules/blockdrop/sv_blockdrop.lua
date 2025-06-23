hook.Add("canDropWeapon", "DisableDropOverride", function(ply, weapon)
    return false -- Returning false prevents dropping
end)