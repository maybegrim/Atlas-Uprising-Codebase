hook.Add("OnNPCKilled", "LEVEL::NPC::Killed", function(npc, attacker, inflictor)
    if IsValid(attacker) and attacker:IsPlayer() then
        LEVEL.AddXP(attacker, LEVEL.GetConfigValue("XPForNPCKill"))
        print("[LEVEL] Added xp to " .. attacker:Nick() .. " for killing NPC")
    end
end)