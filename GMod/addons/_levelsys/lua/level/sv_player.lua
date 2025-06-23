function LEVEL.SetLevel(ply, level)
    local LevelXPNeeded = LEVEL.GetConfigValue("XPPerLevel") * level
    local plyXP = LEVEL.GetXP(ply)
    if plyXP and plyXP < LevelXPNeeded then
        plyXP = LevelXPNeeded
    end

    if not plyXP then
        plyXP = LevelXPNeeded
    end
    LEVEL.DATA[ply:SteamID64()].xp = plyXP
    LEVEL.SetPlayerLevelXP(ply, level, plyXP)
    ply:SetNWInt("LEVEL.Level", level)

    print("[LEVEL] Set level for " .. ply:Nick() .. " to " .. level)
    ply:ChatPrint("{#eb6f36 LEVEL |} You have reached level " .. level .. "!")
end

function LEVEL.SetXP(ply, xp)
    local level = LEVEL.GetLevel(ply)
    local LevelXPNeeded = LEVEL.GetConfigValue("XPPerLevel") * (level == 1 and 1 or level + 1)
    --print(xp, LevelXPNeeded)
    if xp >= LevelXPNeeded then
        -- Delay the xp setting to prevent stack overflow
        timer.Simple(0.1, function()
            LEVEL.SetXP(ply, xp - LevelXPNeeded)
            LEVEL.SetLevel(ply, level + 1)
        end)
    else
        local minXPForLevel = LEVEL.GetConfigValue("XPPerLevel") * (level)
        --print(LEVEL.DATA[ply:SteamID64()].xp)
        --print(minXPForLevel)
        if LEVEL.DATA[ply:SteamID64()].xp < minXPForLevel then
            LEVEL.DATA[ply:SteamID64()].xp = minXPForLevel
            LEVEL.SetPlayerLevelXP(ply, level, minXPForLevel)
            LEVEL.SyncPlayer(ply)
            print("[LEVEL] [OUT OF SYNC] Set XP for " .. ply:Nick() .. " to " .. minXPForLevel)
            return
        end
        LEVEL.SetPlayerLevelXP(ply, level, xp)
        LEVEL.DATA[ply:SteamID64()].xp = xp
        LEVEL.SyncPlayer(ply)
    end

    -- Ensure XP is not below the minimum XP for the current level
    print("[LEVEL] Set XP for " .. ply:Nick() .. " to " .. LEVEL.DATA[ply:SteamID64()].xp)
end

function LEVEL.AddXP(ply, xp, reason)
    local currentXP = LEVEL.GetXP(ply)
    local ending = "!"
    if reason then ending = " for "..reason end
    if not currentXP then
        currentXP = 0
    end
    LEVEL.SetXP(ply, currentXP + xp)

    print("[LEVEL] Added " .. xp .. " XP to " .. ply:Nick())
    ply:ChatPrint("{#eb6f36 LEVEL |} You have gained " .. xp .. " XP"..ending)
end
