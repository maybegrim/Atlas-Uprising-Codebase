
SWEP.PrintName = "Syringe"
SWEP.Author = "Atlas Uprising"
SWEP.Category = "Atlas Uprising - Research"
SWEP.Instructions = ""
SWEP.Base = "atlas_research_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "slam"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/e7/gmod/renderhub/items/syringe/syringe_close.mdl"
SWEP.WorldModel = "models/e7/gmod/renderhub/items/syringe/syringe_close.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {
	["syringe_root"] = { scale = Vector(1, 1, 1), pos = Vector(9.444, -2.037, -3.149), angle = Angle(-172.223, -10, 10) },
	["syringe_liquid"] = { scale = Vector(1, 1, 1), pos = Vector(14.63, -1.668, -2.779), angle = Angle(-180, -10, 10) }
}
SWEP.VElements = {
}
SWEP.IronSightsPos = Vector(0.72, 0, -0.08)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.WElements = {
	["Syringe"] = { type = "Model", model = "models/e7/gmod/renderhub/items/syringe/syringe_close.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.714, 2.596, -0.519), angle = Angle(-8.183, -180, 71.299), size = Vector(1.08, 1.08, 1.08), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.ShootSound = Sound("Metal.SawbladeStick")

SWEP.ItemsToActivate = {
    "essence_049",
    "essence_682",
    "essence_939",
}

-- Custom Vars
SWEP.RelatedSampleID = false

--[[function SWEP:Deploy()
    self:SetWeaponHoldType(self.HoldType)

    timer.Simple(3, function()
        if not IsValid(self) or not IsValid(self.Owner) or self.Owner:GetActiveWeapon() ~= self then return end

        self.ViewModel = "models/e7/gmod/renderhub/items/syringe/syringe_blood.mdl"

        local vm = self.Owner:GetViewModel()
        if IsValid(vm) then
            vm:SetWeaponModel(self.ViewModel, self)
        end
    end)
	return
end]]


function SWEP:Deploy()
	self:SetHoldType("slam")
end

--[[function SWEP:Think()
    self:NextThink(CurTime())
    local ply = self:GetOwner()

    for k,v in pairs(self.ItemsToActivate) do
        if CLIENT and INVENTORY.HaveItem(v) or SERVER and INVENTORY.HasItemFromName(self.Owner, v) then
            self.RelatedSampleID = v

            self.ViewModel = "models/e7/gmod/renderhub/items/syringe/syringe_blood.mdl"
            print("NEW VM")

            local vm = ply:GetViewModel()
            if IsValid(vm) then
                vm:SetWeaponModel(self.ViewModel, self)
            end
            break
        else
            self.RelatedSampleID = false
        end
    end
end]]