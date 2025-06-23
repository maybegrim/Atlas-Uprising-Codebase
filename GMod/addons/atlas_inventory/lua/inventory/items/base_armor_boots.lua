local ITEM = {}

ITEM.Name = "Boots"
ITEM.Description = "Boots"
--[[ 
    ITEM Types
    - weapon
    - ammo
    - scp
    - item
    - armor
]]
ITEM.Type = "armor"
ITEM.ArmorType = "boots" -- Options: helmet, chest, pants, boots | Only used if Type is "armor"
ITEM.Model = "models/props_junk/watermelon01.mdl"
ITEM.Weight = 5
ITEM.Rare = 4 -- 0 = Common, 1 = Rare, 2 = Purchased Item, 3 = SCP, 4 = Job
ITEM.Can = { -- Can be used for anything, but is mainly used for weapons
    Equip = true,
    Destroy = true,
    Trade = true,
    Craft = false,
    Use = false
}
ITEM.Icon = "materials/inventory/items/equipment_boots_styled.png"

ITEM.ArmorValue = 15 -- Only used if Type is "armor"
ITEM.MaxArmorValue = ITEM.ArmorValue -- Do not touch, this is for code in the UI

-- Function Options
ITEM.RemoveOnUse = true

if SERVER then

    -- Called when the item is used
    function ITEM:Use(ply)
        print(ply:Name() .. " used " .. self.Name)
    end

    -- Called only on weapons or armor when equipped
    function ITEM:OnEquip(ply)
        ply:SetArmor(ply:Armor() + self.ArmorValue)
    end

    -- Called only on weapons or armor when unequipped
    function ITEM:OnUnequip(ply)
        ply:SetArmor(ply:Armor() - self.ArmorValue)
    end

    -- Called when the item is picked up
    function ITEM:OnPickup(ply)
        print(ply:Name() .. " picked up " .. self.Name)
    end

    function ITEM:OnTrade(ply, targetPly)
        -- Implement logic for when the item is traded
    end

end

return ITEM