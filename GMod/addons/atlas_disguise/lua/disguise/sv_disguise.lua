util.AddNetworkString("ADQ_OpenModelSelectUI")
util.AddNetworkString("ADQ_SetPlayerModel")
util.AddNetworkString("ADQ_ResetPlayerModel")
ADQ.CachedWeapons = ADQ.CachedWeapons or {}
ADQ.CachedModels = ADQ.CachedModels or {}
ADQ.CachedSpeeds = ADQ.CachedSpeeds or {}

function ADQ.CanUseLocker(ply)
    if not IsValid(ply) then return false end
    if ADQ.CONF.BlacklistedJobs[team.GetName(ply:Team())] then return false end
    local teamCached = RPExtraTeams[ply:Team()]
    if not teamCached then return false end
    if not ADQ.CONF.Factions[teamCached.faction] then return false end

    return true
end

function ADQ.ApplyDisguise(ply, model)
    local invCache = INVENTORY.Data[ply:SteamID64()]

    ADQ.CachedModels[ply:SteamID64()] = ply:GetModel()
    if not ADQ.CachedWeapons[ply:SteamID64()] then
        ADQ.CachedWeapons[ply:SteamID64()] = {}
    end

    local allowedweapons = {
        ["cw_rinic_1887"] = true,
        ["cw_m3super90"] = true,
        ["weapon_adv_keys_2"] = true,
        ["weapon_keycard_level1"] = true,
        ["weapon_keycard_level2"] = true,
        ["weapon_keycard_level3"] = true,
        ["weapon_keycard_level4"] = true,
        ["weapon_keycard_level5"] = true,
        ["weapon_keycard_omni"] = true,
        ["weapon_ciad"] = true,
        ["weapon_cuff_elastic"] = true,
        ["gravgun"] = true,
        ["weapon_physgun"] = true,
        ["weapon_physcannon"] = true,
        ["gmod_tool"] = true,
        ["weapon_rdo_radio"] = true,
        ["weapon_rpt_finebook"] = true,
        ["weapon_rpt_handcuff"] = true,
        ["door_ram"] = true,
        ["vc_spikestrip_wep"] = true,
        ["stungun"] = true,
        ["weapon_empty_hands"] = true
    }

    for k, v in pairs(invCache) do
        if INVENTORY.Item.IsWeapon(v["item"]) and not allowedweapons[v["item"]] then
            ADQ.CachedWeapons[ply:SteamID64()][v["item"]] = true
        end
    end

    -- Remove all weapons except for those in the table above
    for _, weapon in ipairs(ply:GetWeapons()) do
        local weaponClass = weapon:GetClass()
        local weaponCheck = allowedweapons[weaponClass]
        if not weaponCheck then
            ply:StripWeapon(weaponClass)
        end
    end
    
    ADQ.CachedSpeeds[ply:SteamID64()] = ply:GetRunSpeed()
    ply:SetRunSpeed(240)
    ply:SetModel(model)
    ply:SetNWBool("ADQ_Disguised", true)
end

function ADQ.RemoveDisguise(ply)
    ply:SetModel(ADQ.CachedModels[ply:SteamID64()])

    INVENTORY:UnequipActiveItems(ply)

    ply:SetNWBool("ADQ_Disguised", false)

    for k, v in pairs(ADQ.CachedWeapons[ply:SteamID64()]) do
        INVENTORY:AddItem(ply, k, true)
    end

    ply:SetRunSpeed(ADQ.CachedSpeeds[ply:SteamID64()])
end

local function isModelValid(model, ply)
    local job = ply:getJobTable()
    if not job then return false end
    
    if job.faction == "FOUNDATION" then
        return ADQ.CONF.FoundationModels[model] == true
    elseif job.faction == "CHAOS" then
        return ADQ.CONF.ChaosModels[model] == true
    end
    
    return false
end

net.Receive("ADQ_SetPlayerModel", function(len, ply)
    local lockerEnt = net.ReadEntity()
    local selectedModel = net.ReadString()

    if not ADQ.CanUseLocker(ply) then return end
    if not IsValid(lockerEnt) then return end
    if lockerEnt:GetClass() ~= "ent_adq_locker" then return end
    if lockerEnt:GetPos():Distance(ply:GetPos()) > 300 then return end

    -- Check if model is valid for this player's faction
    if isModelValid(selectedModel, ply) then
        ADQ.ApplyDisguise(ply, selectedModel)
    else
        ply:ChatPrint("Invalid model selection for your faction!")
    end
end)

net.Receive("ADQ_ResetPlayerModel", function(len, ply)
    local lockerEnt = net.ReadEntity()

    if not ADQ.CanUseLocker(ply) then return end

    if not IsValid(lockerEnt) then return end

    if lockerEnt:GetClass() ~= "ent_adq_locker" then return end

    if lockerEnt:GetPos():Distance(ply:GetPos()) > 300 then
        return
    end

    ADQ.RemoveDisguise(ply)
end)

hook.Add("PlayerDisconnected", "ADQ_CLEARCACHE", function(ply)
    ADQ.CachedModels[ply:SteamID64()] = nil
    ADQ.CachedWeapons[ply:SteamID64()] = nil
end)

hook.Add("PlayerDeath", "ADQ_CLEARCACHE", function(ply)
    ply:SetNWBool("ADQ_Disguised", false)
end)

hook.Add("PlayerChangedTeam", "ADQ_CLEARCACHE", function(ply)
    ADQ.CachedModels[ply:SteamID64()] = nil
    ADQ.CachedWeapons[ply:SteamID64()] = nil
    ply:SetNWBool("ADQ_Disguised", false)
end)