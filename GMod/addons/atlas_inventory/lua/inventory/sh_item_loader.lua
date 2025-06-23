INVENTORY.Item = INVENTORY.Item or {}

if SERVER then
    local files = file.Find("inventory/items/*.lua", "LUA")
    for _, f in ipairs(files) do
        AddCSLuaFile("inventory/items/" .. f)
    end
end

INVENTORY.Item.Files = INVENTORY.Item.Files or {}

-- Load items
local itemFiles = file.Find("inventory/items/*.lua", "LUA")
for _, fileName in ipairs(itemFiles) do
    local itemName = string.sub(fileName, 1, -5)  -- Remove the '.lua' extension to get the item name
    INVENTORY.Item.Files[itemName] = "inventory/items/" .. fileName
    print("[INVENTORY] Loaded item '" .. itemName .. "'")
end


-- Function to get item script by item name
function INVENTORY.Item.GetScript(itemName)
    local value = INVENTORY.Item.Files[itemName]
    if value then
        local ITEM = istable(value) and value or include(value)
        ITEM.UniqueName = itemName
        return ITEM
    end

    return nil
end

function INVENTORY.Item.IsWeapon(itemName)
    local item = INVENTORY.Item.GetScript(itemName)
    return item.Type == "weapon"
end

function INVENTORY.Item.IsArmor(itemName)
    local item = INVENTORY.Item.GetScript(itemName)
    return item.Type == "armor"
end

function INVENTORY.Item.IsSCP(itemName)
    local item = INVENTORY.Item.GetScript(itemName)
    return item.Type == "scp"
end

function INVENTORY.Item.Exists(itemName)
    return INVENTORY.Item.Files[itemName] ~= nil
end

function INVENTORY.Item.GetName(itemName)
    if INVENTORY.Item.Exists(itemName) then
        return INVENTORY.Item.GetScript(itemName).Name
    end

    return nil
end

-- TODO: Create a comment explaining this entire function usability,
--[[
]]
function INVENTORY.Item.CreateFromBase(itemName, baseItemName, params)
    if not INVENTORY.Item.Exists(baseItemName) then
        return nil
    end

    local baseItem = INVENTORY.Item.GetScript(baseItemName)
    local item = table.Copy(baseItem)
    -- Global Vars
    item.Name = params.name or baseItem.Name
    item.Rare = params.rare or baseItem.Rare
    item.Model = params.model or baseItem.Model
    item.Description = params.description or baseItem.Description
    item.Icon = params.icon or baseItem.Icon
    item.Weight = params.weight or baseItem.Weight

    -- Item Specific Vars

    -- Armor
    item.ArmorValue = params.armor and params.armor or baseItem.ArmorValue and baseItem.ArmorValue or nil
    item.MaxArmorValue = params.armor or baseItem.ArmorValue or nil
    item.ArmorType = params.armorType or baseItem.ArmorType or nil
    item.PlayerModel = params.playermdl or baseItem.PlayerModel or nil

    -- Swep
    item.SWEPSlot = params.slot or baseItem.SWEPSlot or nil
    item.EntName = params.ent or baseItem.EntName or nil


    INVENTORY.Item.Files[itemName] = item

    return item
end


-- Create Items here
INVENTORY.Item.CreateFromBase("juggernaut_mk1", "base_armor_chest", {name = "Juggernaut MK1", description = "Escape the Cave!", armor = 1000, icon = "materials/inventory/items/iron_man.png", weight = 110, armorType = "chest", playermdl = "models/pirangunter21/BoxKnight.mdl"})
INVENTORY.Item.CreateFromBase("cardboard_suit", "base_armor_chest", {name = "CardBoard Suit", description = "Escape the Cave!", armor = 100, icon = "materials/inventory/items/vr_2.png", weight = 50, armorType = "chest", playermdl = "models/cardboardman2/cardboardman.mdl"})
INVENTORY.Item.CreateFromBase("cardboard_shell", "base_armor_chest", {name = "CardBoard Shell", description = "Escape the Cave!", armor = 50, icon = "materials/inventory/items/vr_2.png", weight = 50, armorType = "chest", playermdl = "models/cardboardman2/cardboardman.mdl"})


timer.Simple(1, function()
    hook.Run("INVENTORY.Items.Loaded")
end)