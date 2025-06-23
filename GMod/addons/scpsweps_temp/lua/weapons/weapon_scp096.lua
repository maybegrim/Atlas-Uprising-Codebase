SWEP.Category 			    = "Atlas Uprising - Temp SCP Sweps"
SWEP.PrintName				= "SCP 096"			
SWEP.Author					= "Vinrax/David Ralphsky/Xyz"
SWEP.Instructions			= "Kill those who see your face.\nRight Click to play passive sounds. \nR to cry."
SWEP.ViewModelFOV			= 56
SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Delay          = 2
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "None"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "None"
SWEP.ReloadDelay  			= 36
SWEP.Weight					= 3
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false
SWEP.Slot					= 0
SWEP.SlotPos				= 4
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= true
SWEP.IdleAnim				= true
SWEP.ViewModel				= "models/weapons/v_arms_scp096.mdl"
SWEP.WorldModel				= ""
SWEP.IconLetter				= "w"
SWEP.HoldType 				= "normal"

if (CLIENT) then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/entities/weapon_scp096")
	
	killicon.Add("kill_icon_scp096", "vgui/icons/kill_icon_scp096", Color(255, 255, 255, 255))
	
	hook.Add("PreDrawHalos","SCP096DrawTargetHalo",function()
		local wep = LocalPlayer():GetActiveWeapon()
		if !wep:IsValid() or wep:GetClass() != "weapon_scp096" then return end
		
		local viewers = {}
		for k,v in pairs(player.GetAll()) do
			if v:GetNWBool("saw096face",false) and v:Alive() then
				viewers[#viewers+1] = v
			end
		end
		
		halo.Add(viewers,Color(255,0,0),1,1,10,true,true)
	end)
	
	local function LOSPossible(lookPos,targPos,filter)
		return util.TraceLine({
			start = lookPos,
			endpos = targPos,
			mask = CONTENTS_SOLID+CONTENTS_MOVEABLE,
			filter = filter,
		}).Fraction >= .96
	end

	local function PosSeesPos(lookPos,lookAngle,lookFOV,checkPos)
		if LOSPossible(lookPos,checkPos) then
			if (math.acos((checkPos-lookPos):GetNormalized():Dot(lookAngle:Forward()))) < math.rad(lookFOV or 50) then
				return true
			end
			return false
		end
		return false
	end

	local function VectorToScreen(pos)
		local iScreenW,iScreenH,angCamRot,fFoV = ScrW(),ScrH(),EyeAngles(),LocalPlayer():GetFOV() * math.pi/180
		local vDir = pos-EyePos()
		local d = 4 * iScreenH / (6 * math.tan(0.5 * fFoV))
		local fdp = angCamRot:Forward():Dot(vDir)
		
		if fdp == 0 then
			return 0,0,-1
		end
	 
		local vProj = (d / fdp) * vDir
		
		local x = 0.5 * iScreenW + angCamRot:Right():Dot(vProj)
		local y = 0.5 * iScreenH - angCamRot:Up():Dot(vProj)
		
		local visible
		if fdp < 0 then
			visible = -1
		elseif x < 0 || x > iScreenW || y < 0 || y > iScreenH then
			visible = 0
		else
			visible = 1
		end
		
		return x,y,visible
	end
		
	local function PlayerCanSeePosition(self,pos,fovCheck)
		if CLIENT and self == LocalPlayer() then
			return select(3,VectorToScreen(pos)) == 1 and PosSeesPos(EyePos(),EyeAngles(),fovCheck or self:GetFOV(),pos)
		end
		return PosSeesPos(self:EyePos(),self:EyeAngles(),fovCheck,pos)
	end
	
	hook.Add("PostPlayerDraw","XRP.Detect096FaceViewing",function(ply)
		if ply:GetActiveWeapon():IsValid() and ply:GetActiveWeapon():GetClass() == "weapon_scp096" and !LocalPlayer():HasWeapon("weapon_scp096") and !LocalPlayer():GetNWBool("saw096face",false) then
			if util.TraceLine({
		start = LocalPlayer():EyePos()+LocalPlayer():EyeAngles():Forward()*10,
		endpos = ply:EyePos(),
		filter = {LocalPlayer(),ply},
		--mask = MASK_SHOT_PORTAL
	}).Fraction >= .96 and PlayerCanSeePosition(LocalPlayer(),ply:EyePos(),75) and PlayerCanSeePosition(ply,LocalPlayer():EyePos(),50) then
				net.Start("XYZ_Saw096Face")
				net.SendToServer()
				LocalPlayer():SetNWBool("saw096face",true)
			end
		end
	end)
else
	util.AddNetworkString("XYZ_Saw096Face")
	
	local function ResetFace(ply)
		if ply:GetNWBool("saw096face",false) then
			ply:SetNWBool("saw096face",false)
		end
	end
	hook.Add("PlayerDeath","XYZ_SCP096ResetFace",ResetFace)
	hook.Add("PlayerSpawn","XYZ_SCP096ResetFace",ResetFace)

		local viewers = {}
	net.Receive("XYZ_Saw096Face",function(len,ply)
		if !ply:GetNWBool("saw096face",false) then
			ply:SetNWBool("saw096face",true)
			for k,v in ipairs(player.GetAll()) do
				if v:HasWeapon("weapon_scp096") then
					v:ChatPrint(ply:GetName().." saw your face!")
					v:EmitSound("weapons/scp96/096_3.mp3")
					v:SetRunSpeed(500)
					timer.Create("Speedboost", 15, 1, function() v:SetRunSpeed(250) end)
				end
			end
		end
	end)
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.3)
	self.Weapon:EmitSound("weapons/scp96/attack"..math.random(1,4)..".wav")
	self:DealDamage()
end

function SWEP:DealDamage()
	local tr = util.TraceLine({
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 90,
		filter = self.Owner
	})
	
	if (!IsValid(tr.Entity)) then 
		tr = util.TraceHull({
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 90,
			filter = self.Owner,
			mins = Vector(-10, -10, -8),
			maxs = Vector(10, 10, 8)
		})
	end
	
	if (tr.Hit and !(game.SinglePlayer() and CLIENT)) then
		self:EmitSound("physics/body/body_medium_break"..math.random(2,3)..".wav")
	end
	
	if SERVER and IsValid(tr.Entity) then
		if (tr.Entity:IsNPC() or tr.Entity:IsPlayer() or tr.Entity:Health() > 0) then
			local dmgInfo = DamageInfo()
			
			local attacker = self.Owner
			if (!IsValid(attacker)) then attacker = self end
			dmgInfo:SetAttacker(attacker)
			dmgInfo:SetInflictor(self)
			dmgInfo:SetDamage(100)
			tr.Entity:TakeDamageInfo(dmgInfo)
		end
	end
end

function SWEP:Deploy()
	if self.Owner:IsValid() then
		self.Weapon:EmitSound("weapons/scp96/096_idle"..math.random(1,3)..".wav")	
		self:SendWeaponAnim(ACT_VM_DRAW)
	end
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:Reload()
	self:EmitSound("weapons/scp96/096_cry.ogg")
end 

function SWEP:SecondaryAttack()
    self:EmitSound("weapons/scp96/096_idle"..math.random(1,3)..".wav")
end