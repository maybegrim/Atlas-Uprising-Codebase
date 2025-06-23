INVENTORY.jobArmorModels = {}
local function convertWepToInv(className)
    local wep = weapons.GetStored(className)
    if not wep then return end
    if INVENTORY.CONFIG.DenyListSweps[wep.ClassName] then return end
    --INVENTORY.Item.CreateFromBase(itemName, baseItemName, params)
    local typeDefined = INVENTORY.CONFIG.WeaponSpecifics[wep.ClassName] or false
    INVENTORY.Item.CreateFromBase(className, "base_weapon", {
        name = wep.PrintName,
        description = wep.PrintName,
        model = wep.WorldModel,
        ent = className,
        slot = typeDefined and typeDefined.wepPos or "primary",
    })
end


local function cacheModels()
    for k, v in pairs(RPExtraTeams) do
        if v.model then
            local armV = v.armorValue
            if not armV then
                continue
            end
            -- If the model is a table, grab the first model
            if istable(v.model) then
                INVENTORY.jobArmorModels[v.team] = {mdl = v.model[1], armor = armV}
            else
                INVENTORY.jobArmorModels[v.team] = {mdl = v.model, armor = armV}
            end
        end
    end
end

function convertModelsToArmor()
    local confASplit = INVENTORY.CONFIG.ArmorSplit
    local totalArmorCreationCount = 0
    for k, v in pairs(INVENTORY.jobArmorModels) do
        local mdl = v.mdl
        local armor = v.armor
        local name = "Duty Vest"
        -- desc will be Job names armor
        local desc = team.GetName(k) .. " armor."
        -- Name format armor_chest_{TEAM_ID}
        local itemName = "armor_chest_" .. k

        local chestArmor = math.Round(armor * (confASplit["chest"] / 100))
        local helmetArmor = math.Round(armor * (confASplit["helmet"] / 100))
        local pantsArmor = math.Round(armor * (confASplit["pants"] / 100))
        local bootsArmor = math.Round(armor * (confASplit["boots"] / 100))

        INVENTORY.Item.CreateFromBase(itemName, "base_armor_chest", {
            name = name,
            description = desc,
            playermdl = mdl,
            armor = chestArmor,
        })

        local itemName = "armor_helmet_" .. k
        local name = "Duty Helmet"
        INVENTORY.Item.CreateFromBase(itemName, "base_armor_helmet", {
            name = name,
            description = desc,
            armor = helmetArmor,
        })

        local itemName = "armor_pants_" .. k
        local name = "Duty Pants"
        INVENTORY.Item.CreateFromBase(itemName, "base_armor_pants", {
            name = name,
            description = desc,
            armor = pantsArmor,
        })

        local itemName = "armor_boots_" .. k
        local name = "Duty Boots"
        INVENTORY.Item.CreateFromBase(itemName, "base_armor_boots", {
            name = name,
            description = desc,
            armor = bootsArmor,
        })
        totalArmorCreationCount = totalArmorCreationCount + 1
    end
    print("INVENTORY | Created " .. totalArmorCreationCount .. " jobs armor.")
    if CLIENT then
        INVENTORY.jobArmorModels = nil
    end
end

timer.Simple(1, function()
    for k,v in pairs(weapons.GetList()) do
        if v.ClassName then
            convertWepToInv(v.ClassName)
        end
    end
    cacheModels()
end)
timer.Simple(2, function()
    convertModelsToArmor()
end)