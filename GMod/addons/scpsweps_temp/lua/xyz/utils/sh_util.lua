XYZ.util = XYZ.util or {}

local UTIL = XYZ.util

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
	
function UTIL.PlayerCanSeePosition(ply,pos,fovCheck)
	if CLIENT and ply == LocalPlayer() then
		return select(3,VectorToScreen(pos)) == 1 and PosSeesPos(EyePos(),EyeAngles(),fovCheck or ply:GetFOV(),pos)
	end
	return PosSeesPos(ply:EyePos(),ply:EyeAngles(),fovCheck,pos)
end


