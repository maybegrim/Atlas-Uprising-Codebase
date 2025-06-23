-- sv_bones.lua

util.AddNetworkString("PlayerBreakLegs")

function ATLASMED.BONES.BreakLegs(player)
    if player:getJobTable().isSCP then return end
    if not ATLASMED.BONES.AreLegsBroken(player) then
        player:SetNWBool("LegsBroken", true)
        player:ChatPrint("Your legs are broken!")
        net.Start("PlayerBreakLegs")
        net.Send(player)

        timer.Simple(0.1, function()
            player:SetMaxHealth(player:GetMaxHealth() * ATLASMED.BONES.HEALTH_REDUCTION_RATE)
            if player:Health() > player:GetMaxHealth() then
                player:SetHealth(player:GetMaxHealth())
            end
        end)
    end
end


function ATLASMED.BONES.UnBreakLegs(player)
    if ATLASMED.BONES.AreLegsBroken(player) then
        player:SetNWBool("LegsBroken", false)
    end
end

function ATLASMED.BONES.HandleFallDamage(player, dmginfo)
    if dmginfo:IsFallDamage() then
        if math.random() < ATLASMED.BONES.BONE_BREAK_RATE then
            ATLASMED.BONES.BreakLegs(player)
        end
    end
end

function ATLASMED.BONES.HandleBulletDamage(player, hitgroup, dmginfo)
    if hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
        if math.random() < ATLASMED.BONES.BONE_BREAK_RATE then
            ATLASMED.BONES.BreakLegs(player)
        end
    end
end

hook.Add("EntityTakeDamage", "ATLASMED.BONES.CheckLegsBreakFallDamage", function(target, dmginfo)
    if target:IsPlayer() then
        ATLASMED.BONES.HandleFallDamage(target, dmginfo)
    end
end)

hook.Add("ScalePlayerDamage", "ATLASMED.BONES.CheckLegsBreakBulletDamage", function(player, hitgroup, dmginfo)
    ATLASMED.BONES.HandleBulletDamage(player, hitgroup, dmginfo)
end)

hook.Add("PlayerDeath", "ATLASMED.BONES.ResetLegs", function(player)
    ATLASMED.BONES.UnBreakLegs(player)
end)

hook.Add("PlayerSpawn", "ATLASMED.BONES.ResetLegs", function(player)
    ATLASMED.BONES.UnBreakLegs(player)
end)