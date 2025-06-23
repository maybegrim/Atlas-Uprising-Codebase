if CLIENT then
	SWEP.PrintName = "SCP-966"
	SWEP.Author = "Atlas Uprising"
	SWEP.Slot = 2
	SWEP.SlotPos = 1
end

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.DrawAmmo = false

SWEP.HoldType = "normal"
SWEP.Category = "Atlas Uprising"
SWEP.UseHands = false

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.Automatic = false

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
if SERVER then
    local uncloakClr, cloakClr = Color(255,255,255,255), Color(255,255,255,100)
    util.AddNetworkString("ATLAS.966.Receive")
    util.AddNetworkString("ATLAS.966.Remove")
    function atlasCloak966(ply)
        ply:SetNWBool("ATLAS.966.Cloaked", true)
        --ply:SetNotSolid(true)
		--ply:AddEffects(32)
        ply:SetColor(cloakClr)
        ply:SetRenderMode(RENDERMODE_TRANSCOLOR)
		--ply:AddEffects(256)
		ply:SetNoTarget(true)
        net.Start("ATLAS.966.Receive")
        net.WriteEntity(ply)
        net.Broadcast()
    end
    function atlasUncloak966(ply)
        ply:SetNWBool("ATLAS.966.Cloaked", false)
		--ply:SetNotSolid(false)
        ply:SetColor(uncloakClr)
        ply:SetRenderMode(RENDERMODE_NORMAL)
		ply:SetNoTarget(false)
        net.Start("ATLAS.966.Remove")
        net.WriteEntity(ply)
        net.Broadcast()
    end
    function atlas966IsCloaked(ply)
        return ply:GetNWBool("ATLAS.966.Cloaked", false)
    end
    hook.Add("PlayerSpawn", "ATLAS.966.DoNotCloakPlayers", function(ply)
        atlasUncloak966(ply)
    end)
end
if CLIENT then
    local SCP966s = {}
    net.Receive("ATLAS.966.Receive", function()
        local scp966 = net.ReadEntity()
        SCP966s[scp966] = true
    end)
    net.Receive("ATLAS.966.Remove", function()
        local scp966 = net.ReadEntity()
        if SCP966s[scp966] then SCP966s[scp966] = nil scp966:SetNoDraw(false) end
    end)
    nextThinkSee = 0
    hook.Add("Think", "ATLAS.966.See", function()
        if CurTime() < nextThinkSee then return end
        nextThinkSee = CurTime() + 1
        if team.GetName(LocalPlayer():Team()) == "SCP-966 'The Sleep Demon'" then return end
        if LocalPlayer():GetNWBool("ActiveDrGNVG") then
            for k,v in pairs(SCP966s) do
                if not IsValid(k) then return end
                k:SetNoDraw(false)
            end
        else
            for k,v in pairs(SCP966s) do
                if not IsValid(k) then return end
                if LocalPlayer():GetMoveType() == MOVETYPE_NOCLIP then
                    k:SetNoDraw(false)
                    return
                end
                k:SetNoDraw(true)
            end
        end
    end)
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:SecondaryAttack()
    return
end

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Deploy()
    if SERVER then
    atlasCloak966(self:GetOwner())
    end
end

function SWEP:DrawWorldModel()
    return false
end

function SWEP:Reload()
    return
end