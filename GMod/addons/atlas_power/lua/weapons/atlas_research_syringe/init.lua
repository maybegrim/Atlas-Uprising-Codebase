
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local cooldown = 5 -- cooldown in seconds

function SWEP:PrimaryAttack()
    local ply = self:GetOwner()

    if not IsValid(ply) then return end

    if self:GetNextPrimaryFire() > CurTime() then return end -- check if the cooldown is active

    ply:LagCompensation(true)
    local target = self:GetOwner():GetEyeTrace().Entity
    ply:LagCompensation(false)

    if not IsValid(target) then return end

    if not target:IsPlayer() then return end

    if target:GetPos():Distance(ply:GetPos()) > 200 then return end

    if not RESEARCH.CONFIG.SCPToItems[target:Team()] then return end


    self:SetNextPrimaryFire(CurTime() + cooldown) -- set the cooldown

    -- animate slam primaryr attack
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

    self.ViewModel = "models/e7/gmod/renderhub/items/syringe/syringe_blood.mdl"

    local vm = ply:GetViewModel()
    if IsValid(vm) then
        vm:SetWeaponModel(self.ViewModel, self)
    end
    timer.Simple(1, function()
        if IsValid(self) then
            local result, itemID = RESEARCH.PHARMA.GiveInvItem(ply, RESEARCH.CONFIG.SCPToItems[target:Team()])

            if not result then return end

            local item, id = INVENTORY:HasItemFromName(ply, "atlas_research_syringe")
            INVENTORY:RemoveItem(ply, id, false)
        end
    end)
end

function SWEP:SecondaryAttack()

end