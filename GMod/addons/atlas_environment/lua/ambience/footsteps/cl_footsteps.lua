local nameLookup = {
    ["physics/"] = function(name) return string.Split(name,"/")[1] end,
    ["carpet"] = "carpet",
    ["cardboard"] = "carpet",
    ["plaster"] = "carpet",
    ["rubber"] = "carpet",
    ["dirt"] = "dirt",
    ["grass"] = "grass",
    ["metal"] = "steel",
    ["metalgrate"] = "embosedplate",
    ["chain"] = "metalcrate",
    ["ladder"] = "ladder",
    ["mud"] = "mud",
    ["sand"] = "sand",
    ["gravel"] = "gravel",
    ["snow"] = "sand",
    ["concrete"] = "concrete",
    ["stone"] = "concrete",
    ["tile"] = "tile",
    ["glass"] = "concrete",
    ["plastic"] = "lino",
    ["duct"] = "plate",
    ["wood"] = "wood",
    ["woodpanel"] = "woodplank",
}

local function GetName(player, strPath)
    local name = string.gsub(strPath, "player/footsteps/", "")
    name = string.gsub(name, "%d+.wav", "")

    -- Directly index the lookup table
    local matchedName = nameLookup[name]
    if matchedName then
        name = (type(matchedName) == "function") and matchedName(name) or matchedName
    end

    -- Special case for "physics/" since it's a partial match
    if not matchedName and string.match(name, "physics/") then
        name = string.Split(name, "/")[1]
    end

    if player:WaterLevel() >= 1 then
        name = "water"
    end

    return name
end


local function GetType(player, name)
    if player:KeyDown(IN_SPEED) then
        return "sprint"
    elseif player:KeyDown(IN_DUCK) or player:KeyDown(IN_WALK) then
        return "walk"
    end

    return "walk"
end


local function PlayerFootstep(player, vecOrigin, iFoot, strPath, nVolume, CRecipientFilter)
    hook.Run("PostPlayerFootstep", player)
    if player == LocalPlayer() then
        local wep = ply:GetActiveWeapon()

        if IsValid(wep) and wep.CW20Weapon then
            wep:addRunTime()
        end
    end


    local name = GetName(player, strPath)
    local type = GetType(player, name)

    player:EmitSound("player/presencearma2/footsteps/foot_" .. name .. math.random(1, 8) .. ".wav", 75, math.random(90, 110), 0.3, 0)
    player:EmitSound("player/presencearma2/gear/gearprim_" .. type .. math.random(1, 8) .. ".wav", 75, math.random(90, 110), 0.2, 0)
    player:EmitSound("player/presencearma2/gear/equipment_move" .. math.random(1, 8) .. ".wav", 75, math.random(90, 110), 0.2, 0)

    return true
end
hook.Add("PlayerFootstep", "ATLAS.PlayerFootstep", PlayerFootstep)
timer.Simple(1, function()
    hook.Remove("PlayerFootstep", "CW20_Footstep")
end)

local function FootstepDelay(ply, type, walking)
    local delay = 400

    if ply:IsSprinting() then
        delay = 280 -- sprint delay
    elseif ply:Crouching() or (ply:GetCanWalk() and ply:KeyDown(IN_WALK)) then
        delay = 500 -- crouching / walking delay
    end

    return delay
end
hook.Add("PlayerStepSoundTime", "ATLAS.FootstepDelay", FootstepDelay)
