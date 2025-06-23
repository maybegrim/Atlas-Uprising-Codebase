local meta = FindMetaTable("Player")

function meta:InPassiveMode()
    return self:GetNWBool("PassiveMode", false)
end

if SERVER then
    function meta:InPassiveMode()
        return self:GetNWBool("PassiveMode", false)
    end
    function meta:SetPassiveMode(passive_mode, death)
        self:SetNWBool("PassiveMode", passive_mode)
        if death then return end
        if passive_mode then
            local weps = {}
            weps.InvItems = {}
            weps.Weapons = {}
            local wepsBeforeDestroy = self:GetWeapons()
            INVENTORY:RemoveAllActiveWeapons(self)
            
            for _,weapon in pairs(wepsBeforeDestroy) do
                if weapon.Level then
                    self.keycardLevel = weapon:GetSublevel()
                end
                if weapon:GetClass() == "weapon_empty_hands" then
                    continue
                end
                if INVENTORY.Item.Exists(weapon:GetClass()) then
                    table.insert(weps.InvItems, weapon:GetClass())
                else
                    table.insert(weps.Weapons, weapon:GetClass())
                end
                if self:HasWeapon(weapon:GetClass()) then
                    self:StripWeapon(weapon:GetClass())
                end
            end
            
            self.PrePassiveWeapons = weps
            
        else
            
            if self.PrePassiveWeapons then
                for _,weapon in pairs(self.PrePassiveWeapons.InvItems) do
                    INVENTORY:AddItem(self, weapon)
                end
                for _,weapon in pairs(self.PrePassiveWeapons.Weapons) do
                    self:Give(weapon)
                end
                self.PrePassiveWeapons = nil
            end
            for _,weapon in pairs(self:GetWeapons()) do
                if weapon.Level then
                    weapon:SetSublevel(self.keycardLevel)
                end
            end
        end
    end

    hook.Add("PlayerDeath", "ATLAS.PASSIVE.Death", function(ply)
        ply:SetPassiveMode(false, true)
    end)

    hook.Add("PlayerChangedTeam", "ATLAS.PASSIVE.TeamChange", function(ply)
        ply:SetPassiveMode(false, true)
    end)

    hook.Add("PlayerCanPickupWeapon", "ATLAS.PASSIVE.Equip", function(weapon, ply)
        if ply:GetNWBool("PassiveMode", false) then
            return false
        end
    end)
end