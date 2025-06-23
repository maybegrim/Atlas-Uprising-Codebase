if SERVER then
	concommand.Add("scp106_settppoint",function(ply)
		if IsValid(ply) and not ply:IsSuperAdmin() then return end
		local tppoints = file.Read("scp_106.txt","DATA")
		if not tppoints or string.len(tppoints) <= 0 then tppoints = "" end
		local tpTable = util.JSONToTable(tppoints)
		if not tpTable then tpTable = {} end

		tpTable[game.GetMap()] = ply:GetPos()
		file.Write("scp_106.txt",util.TableToJSON(tpTable))
	end)

	function SCP106GetTPPos()
		local fl = file.Read("scp_106.txt","DATA")
		if not fl or string.len(fl) <= 0 then return end
		local tpTable = util.JSONToTable(fl)
		if not tpTable then return end
		if not tpTable[game.GetMap()] then return end

		return tpTable[game.GetMap()]
	end
end

AddCSLuaFile()

SWEP.Author 		= "War.exe"
SWEP.Purpose		= "SCP 106"
SWEP.Category	    = "Atlas Uprising - Temp SCP Sweps"
SWEP.Instructions	= "LMB Teleports\nRMB Go through doors\nR Laugh"

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false

SWEP.PrintName		= "SCP 106"
SWEP.Slot			= 0
SWEP.SlotPos		= 0
SWEP.HoldType		= "normal"
SWEP.Spawnable		= true
SWEP.AdminSpawnable	= true

SWEP.AttackDelay	= 0.25
SWEP.ISSCP 			= true
SWEP.droppable		= false
SWEP.NextAttackW	= 0

function SWEP:Deploy()
    self.Owner:SetRunSpeed(145)
    self.Owner:SetWalkSpeed(145)
	self.Owner:DrawViewModel( false )
	self.Owner:SetCustomCollisionCheck(false)
end
function SWEP:DrawWorldModel()
end
function SWEP:Initialize()
	self:SetHoldType("normal")
end
function SWEP:Holster()
	return true
end
function SWEP:CanPrimaryAttack()
	return true
end
function SWEP:HUDShouldDraw( element )
	local hide = {
		CHudAmmo = true,
		CHudSecondaryAmmo = true,
	}
	if hide[element] then return false end
	return true
end
--[[]
hook.Add("ShouldCollide", "weapon_scp106swep", function(ent1, ent2)
    if !SERVER then return end
    
	if IsValid(ent1) and IsValid(ent2) then
		if ent1:IsPlayer() then
			if ent1:IsPlayer() and IsValid(ent1:GetActiveWeapon()) and ent1:GetActiveWeapon():GetClass() == "weapon_scp106swep" then
			    return false
			elseif ent2:IsPlayer() and IsValid(ent2:GetActiveWeapon()) and ent2:GetActiveWeapon():GetClass() == "weapon_scp106swep" then
				return false
			end
		end
	end
end)]]

function SWEP:SecondaryAttack()
    if self.Owner:GetPos():WithinAABox(Vector(-3271.963379, -8664.150391, -11074.268555), Vector(-2984.408691, -8951.709961, -11298.331055)) then
        return self.Owner:ChatPrint("You cannot use this SWEP while in containment!")
    end
    
    local Owner = self.Owner
    Owner:EmitSound("scp106sounds/corrosion"..math.random(1, 3)..".mp3", 100, 85)
    Owner:SetRunSpeed(120)
    Owner:SetWalkSpeed(120)
    Owner:SetRenderMode(RENDERMODE_TRANSALPHA)
    Owner:SetCollisionGroup(COLLISION_GROUP_WORLD)
    Owner:SetCustomCollisionCheck(true)
    
    timer.Simple( 2, function()
    	Owner:SetRunSpeed(145)
        Owner:SetWalkSpeed(145)
    	Owner:SetRenderMode(RENDERMODE_NORMAL)
    	Owner:SetCollisionGroup(COLLISION_GROUP_PLAYER)
    	Owner:SetCustomCollisionCheck(false)
	end )
end

function SWEP:Reload()
    self.Owner:EmitSound("scp106sounds/laugh.mp3", 75, 100,0.5)
end

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end
	if self.NextAttackW > CurTime() then return end
	self.NextAttackW = CurTime() + self.AttackDelay
	if SERVER then
		local ent = self.Owner:GetEyeTrace().Entity
		if not (ent:GetPos():Distance(self.Owner:GetPos()) < 150) then return end
		if not ent:IsPlayer() then return end
		local weapon = ent:GetActiveWeapon()
		if weapon and weapon.ISSCP then return end

		local tppos = SCP106GetTPPos()
		if not tppos then return end
		ent:SetPos(tppos)
	end
end