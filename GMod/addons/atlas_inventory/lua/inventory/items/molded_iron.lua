local ITEM = {}

ITEM.Name = "Molded Iron"
ITEM.Description = "Molded Iron used for crafting."
--[[ 
    ITEM Types
    - weapon
    - ammo
    - scp
    - item
    - armor
]]
ITEM.Type = "item"
--ITEM.ArmorType = "helmet" -- Options: helmet, chest, pants, boots | Only used if Type is "armor"
ITEM.Model = "models/props_junk/watermelon01.mdl"
ITEM.Weight = 15
ITEM.Rare = 1 -- 0 = Common, 1 = Rare, 2 = Purchased Item, 3 = SCP, 4 = Job
ITEM.Can = { -- Can be used for anything, but is mainly used for weapons
    Equip = false,
    Destroy = true,
    Trade = true,
    Craft = true,
    Use = false
}
ITEM.Icon = "materials/inventory/items/metal.png"

-- Function Options
ITEM.RemoveOnUse = true

if SERVER then

    -- Called when the item is used
    function ITEM:Use(ply)

    end

    -- Called only on weapons or armor when equipped
    function ITEM:OnEquip(ply)

    end

    -- Called only on weapons or armor when unequipped
    function ITEM:OnUnequip(ply)

    end

    -- Called when the item is picked up
    function ITEM:OnPickup(ply)

    end

    function ITEM:OnTrade(ply, targetPly)
        -- Implement logic for when the item is traded
    end

end

return ITEM