AddCSLuaFile()
SWEP.Author = "Bananowytasiemiec | Time"
SWEP.Contact = "acocieto3131@gmail.com"
SWEP.Purpose = "Smoke some SCP-420-J"
SWEP.Instructions = "LMB to smoke"
SWEP.Category = "Atlas Uprising - Temp SCP Sweps"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModelFOV  = 54
SWEP.ViewModel = ""
SWEP.WorldModel = "models/mishka/models/scp420.mdl"

SWEP.PrintName = "SCP-420-ATL"
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
self:SetHoldType("normal")
end

SWEP.SwingSound = ""
SWEP.HitSound = ""
SWEP.HoldType = "normal"
SWEP.AllowDrop = true
SWEP.Kind = WEAPON_MELEE

SWEP.Delay = 1
SWEP.Range = 60
SWEP.Damage = 0
SWEP.RemoveCan = true

if SERVER then 
	util.AddNetworkString("420ATLTimer")
end

function SWEP:PrimaryAttack()

	if ( CLIENT ) then return end

	if self:GetOwner():IsPlayer() and ( self.lastUsed or CurTime() ) <= CurTime() then
		self.lastUsed = CurTime() + 120
	    if self.Owner:GetActiveWeapon():GetClass() == "weapon_scp420_atl" then
			self.Owner:SetHealth(self.Owner:Health() + 25 )
			self.Owner:EmitSound('scp420/420_J.mp3')
		end
	else
		net.Start("420ATLTimer")
		net.Send(self:GetOwner())
	end

	
end

function SWEP:SecondaryAttack()

end

function SWEP:Reload()

end

if CLIENT then
	net.Receive("420ATLTimer", function()
		chat.AddText(Color(255,0,0), "You must wait 2 minutes between uses.")
	end)
end