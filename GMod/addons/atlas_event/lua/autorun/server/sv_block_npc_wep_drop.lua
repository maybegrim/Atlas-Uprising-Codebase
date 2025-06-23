hook.Add("PlayerSpawnNPC", "BLOCK::NPC::WEPDROP", function(ply, npc)
    npc:SetKeyValue("spawnflags", "8192")
end)