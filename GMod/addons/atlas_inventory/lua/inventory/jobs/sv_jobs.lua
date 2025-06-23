INVENTORY.Jobs = INVENTORY.Jobs or {}
-- Create a function that will go through all jobs, grab the weapon table and store it into table then remove the weapon from the job
--[[local]] jobWeapons = jobWeapons or {}
playerWeapons = playerWeapons or {}

local function removeJobWeapons()
    for k, v in pairs(RPExtraTeams) do
        if v.weapons then
            jobWeapons[v.name] = {}
            for _, weapon in pairs(v.weapons) do
                if INVENTORY.CONFIG.DenyListSweps[weapon] then continue end

                table.insert(jobWeapons[v.name], weapon)
                table.RemoveByValue(v.weapons, weapon)
            end
        end
    end
end


timer.Simple(2, function()
    if not table.IsEmpty(jobWeapons) then return end 
    removeJobWeapons()
end)

function INVENTORY.Jobs.OverridePrimaryWeapon(jobName, weapon)
    if not jobWeapons[jobName] then return false end

    for k,v in pairs(jobWeapons[jobName]) do
        local itemScript = INVENTORY.Item.GetScript(v)
        if itemScript and itemScript.Type == "weapon" and itemScript.SWEPSlot == "primary" then
            table.remove(jobWeapons[jobName], k)
            table.insert(jobWeapons[jobName], weapon)
            return true
        end
    end
    return false
end

function INVENTORY.Jobs.OverridePlayerPrimaryWeapon(pPly, weapon, teamIndex)
    local jobName = team.GetName(teamIndex)
    if not jobWeapons[jobName] then return false end

    if not playerWeapons[pPly:SteamID()] then playerWeapons[pPly:SteamID()] = {} end

    if not playerWeapons[pPly:SteamID()][jobName] then playerWeapons[pPly:SteamID()][jobName] = {} end

    for k,v in pairs(jobWeapons[jobName]) do
        local itemScript = INVENTORY.Item.GetScript(v)
        if itemScript and itemScript.Type == "weapon" and itemScript.SWEPSlot == "primary" then
            playerWeapons[pPly:SteamID()][jobName] = weapon
            return true
        end
    end
end

-- TODO: Instead of adding one item we need to add a function to batch add items
local function assignLoadoutToInv(pPly)
    local job = pPly:Team()
    local jobName = team.GetName(job)
    local primaryOverride = false
    if playerWeapons[pPly:SteamID()] and playerWeapons[pPly:SteamID()][jobName] then
        primaryOverride = true
        if INVENTORY.Item.Exists(playerWeapons[pPly:SteamID()][jobName]) then
            INVENTORY:AddItem(pPly, playerWeapons[pPly:SteamID()][jobName])
        end
    end
    if jobWeapons[jobName] then
        for _, weapon in pairs(jobWeapons[jobName]) do
            if primaryOverride then
                local itemScript = INVENTORY.Item.GetScript(weapon)
                if itemScript and itemScript.Type == "weapon" and itemScript.SWEPSlot == "primary" then
                    continue
                end
            end
            INVENTORY:AddItem(pPly, weapon)
        end
    end

    if INVENTORY.jobArmorModels[job] then
        local chestArmor = "armor_chest_" .. job
        local helmetArmor = "armor_helmet_" .. job
        local pantsArmor = "armor_pants_" .. job
        local bootsArmor = "armor_boots_" .. job

        --INVENTORY.Item.Exists(itemName)

        if INVENTORY.Item.Exists(chestArmor) then
            INVENTORY:AddItem(pPly, chestArmor)
        end

        if INVENTORY.Item.Exists(helmetArmor) then
            INVENTORY:AddItem(pPly, helmetArmor)
        end

        if INVENTORY.Item.Exists(pantsArmor) then
            INVENTORY:AddItem(pPly, pantsArmor)
        end

        if INVENTORY.Item.Exists(bootsArmor) then
            INVENTORY:AddItem(pPly, bootsArmor)
        end
    end

    local itemTable = INVENTORY.CONFIG.JobSpecificItems[jobName]
    if not itemTable then return end
    for _, item in pairs(itemTable) do
        INVENTORY:AddItem(pPly, item)
    end
end


hook.Add("PlayerSpawn", "INVENTORY.AssignInvForJob", function(pPly)
    assignLoadoutToInv(pPly)
end)