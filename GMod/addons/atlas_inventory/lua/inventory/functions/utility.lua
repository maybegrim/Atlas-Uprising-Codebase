local Utility = {}

-- Variables for the functions

-- Cache config variables [CHANGE THESE TO BE DYNAMIC IF WE ENABLE IN-GAME CONFIG]
local cRowSize = INVENTORY.CONFIG.Rows
local cColSize = INVENTORY.CONFIG.Columns
local invSize = cRowSize * cColSize

-- Local Functions to be used by the class
local function getItemSubType(item)
    item = istable(item) and item or INVENTORY.Item.GetScript(item)
    return item.SWEPSlot and item.SWEPSlot or item.ArmorType and item.ArmorType or false
end

-- Utility Functions
function Utility:isInventoryFull(inv)
    return table.Count(inv) >= invSize
end

function Utility:generateUniqueID()
    return math.random(1, 1000000)
end

function Utility:isLoadoutSlotTaken(pPly, pItem)
    local itemType = getItemSubType(pItem)
    return INVENTORY.PlayerLoadouts[pPly:SteamID64()][itemType] and true or false
end

function Utility:canEquipLoadoutSlot(pPly, pItem)
    return not INVENTORY.PlayerLoadouts[pPly:SteamID64()][getItemSubType(pItem)]
end

function Utility:equipLoadout(pPly, pItem)
    local itemType = getItemSubType(pItem)
    INVENTORY.PlayerLoadouts[pPly:SteamID64()][itemType] = pItem.UniqueName
end

function Utility:unequipLoadout(pPly, pItem)
    local itemType = getItemSubType(pItem)
    INVENTORY.PlayerLoadouts[pPly:SteamID64()][itemType] = false
end

function Utility:isItemEquipped(pPly, pItem)
    local itemType = getItemSubType(pItem)
    if not istable(pItem) then
        pItem = INVENTORY.Item.GetScript(pItem)
    end
    if not INVENTORY.PlayerLoadouts[pPly:SteamID64()][itemType] then return false end
    local activeItem =  INVENTORY.PlayerLoadouts[pPly:SteamID64()][itemType]
    if not istable(activeItem) then
        activeItem = INVENTORY.Item.GetScript(activeItem)
    end
    return activeItem.UniqueName == pItem.UniqueName
    --return INVENTORY.PlayerLoadouts[pPly:SteamID64()][itemType] and INVENTORY.PlayerLoadouts[pPly:SteamID64()][itemType].UniqueName == pItem.UniqueName or false
end

function Utility:getArmorCount(pPly)
    local armorCount = 0
    for k, v in pairs(INVENTORY.PlayerLoadouts[pPly:SteamID64()]) do
        if v and v.ArmorType then
            armorCount = armorCount + 1
        end
    end
    return armorCount
end

return Utility