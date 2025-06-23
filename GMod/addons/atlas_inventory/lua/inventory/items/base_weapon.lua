local ITEM = {}

ITEM.Name = "Weapon"
ITEM.Description = "This is a weapon."
--[[ 
    ITEM Types
    - weapon
    - ammo
    - scp
    - item
    - armor
]]
ITEM.Type = "weapon"
ITEM.SWEPSlot = "primary" -- Options: primary, secondary, belt | Only used if Type is "weapon"
--ITEM.ArmorType = "helmet" -- Options: helmet, chest, pants, boots | Only used if Type is "armor"
ITEM.Model = "models/props_junk/watermelon01.mdl"
ITEM.Weight = 5
ITEM.Rare = 0 -- 0 = Common, 1 = Rare, 2 = Purchased Item, 3 = SCP, 4 = Job
ITEM.Can = { -- Can be used for anything, but is mainly used for weapons
    Equip = true,
    Destroy = true,
    Trade = true,
    Craft = false,
    Use = false
}
ITEM.Icon = "materials/inventory/items/weapon_styled_ar.png"

ITEM.EntName = "weapon_pistol" -- The entity that will be spawned when the item is used

-- Function Options
ITEM.RemoveOnUse = true

if SERVER then

    -- Called when the item is used
    function ITEM:Use(ply)

    end

    -- Called only on weapons or armor when equipped
    function ITEM:OnEquip(ply)
        ply:Give(self.EntName)
    end

    -- Called only on weapons or armor when unequipped
    function ITEM:OnUnequip(ply)
        local weapon = ply:GetWeapon(self.EntName)
        if IsValid(weapon) then
            weapon:Remove()
        end
    end

    -- Called when the item is picked up
    function ITEM:OnPickup(ply)

    end

    function ITEM:OnTrade(ply, targetPly)
        -- Implement logic for when the item is traded
    end

end

return ITEM