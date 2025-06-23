hook.Add("EntityTakeDamage", "PassiveMode.DamageModifier", function (target, damage_info)
    if not IsValid(target) or not target:IsPlayer() then return end
    if target:InPassiveMode() and IsValid(damage_info:GetAttacker()) then
        return true
    end
end)