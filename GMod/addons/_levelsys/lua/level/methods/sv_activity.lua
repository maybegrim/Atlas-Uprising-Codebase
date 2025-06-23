local thinkCooldown = 0
local configCache = false



hook.Add("Think", "LEVEL::ActivityCheck", function()
    if thinkCooldown < CurTime() then
        thinkCooldown = CurTime() + 120
        local players = player.GetAll()
        if not configCache then
            configCache = {}
            for k, v in pairs(LEVEL.GetConfigValue()) do
                configCache[k] = v
            end
        end
        for k, v in ipairs(players) do
            -- ply.levelUninitialized
            if v.levelUninitialized ~= false then
                continue
            end
            timer.Simple(0.3 * k, function()
                if IsValid(v) and v:Alive() then
                    -- Ensure the player is ready to receive XP
                    if not v.LastActivityXP or CurTime() >= v.LastActivityXP + LEVEL.GetConfigValue("ActivityCooldown") then
                        LEVEL.AddXP(v, LEVEL.GetConfigValue("XPForActivity"))
                        v.LastActivityXP = CurTime()
                    end
                end
            end)
        end
    end
end)

hook.Add("LEVEL.ConfigUpdated", "LEVEL::ActivityCheck::ConfigUpdate", function()
    configCache = false
end)
