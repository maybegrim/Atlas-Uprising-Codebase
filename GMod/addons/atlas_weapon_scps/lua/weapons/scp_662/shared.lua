local swepVars = ATLASSCPSWEPS.SWEPVARS

SWEP.PrintName = "SCP-662 Swep"
SWEP.Author = swepVars.Author
SWEP.Category = swepVars.Category
SWEP.Instructions = "Left Mouse: Cloak Toggle\nRight Mouse: NoClip Toggle\nReload: Open Spawn Menu"

SWEP.Spawnable = true
SWEP.AdminOnly = false

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

SWEP.ViewModel			= ""
SWEP.WorldModel			= ""

SWEP.ShootSound = Sound("Metal.SawbladeStick")

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
function ATLAS662.PlayerCanSeePosition(ply,pos,fovCheck)
	if CLIENT and ply == LocalPlayer() then
		return select(3,VectorToScreen(pos)) == 1 and PosSeesPos(EyePos(),EyeAngles(),fovCheck or ply:GetFOV(),pos)
	end
	return PosSeesPos(ply:EyePos(),ply:EyeAngles(),fovCheck,pos)
end

function SWEP:IsSeen()
	local plyPos = self:GetOwner():WorldSpaceCenter()
	for k,v in ipairs(player.GetAll()) do
		if v != self:GetOwner() and v:Alive() and v:GetMoveType() == MOVETYPE_WALK and ATLAS662.PlayerCanSeePosition(v,plyPos,70) then
			return true
		end
	end
	return false
end