local PUNCH_DAMPING = 9
local PUNCH_SPRING_CONSTANT = 65
local vp_is_calc = false

local vp_punch_angle = Angle()
local vp_punch_angle_velocity = Angle()
local vp_punch_angle_last = vp_punch_angle

hook.Add("Think", "viewpunch_think", function()
	if not vp_punch_angle:IsZero() or not vp_punch_angle_velocity:IsZero() then
		vp_punch_angle = vp_punch_angle + vp_punch_angle_velocity * FrameTime()
		local damping = 1 - (PUNCH_DAMPING * FrameTime())

		if damping < 0 then damping = 0 end

		vp_punch_angle_velocity = vp_punch_angle_velocity * damping
		
		local spring_force_magnitude = math.Clamp(PUNCH_SPRING_CONSTANT * FrameTime(), 0, 0.2 / FrameTime())
		
		vp_punch_angle_velocity = vp_punch_angle_velocity - vp_punch_angle * spring_force_magnitude
		
		local x, y, z = vp_punch_angle:Unpack()
		vp_punch_angle = Angle(math.Clamp(x, -89, 89), math.Clamp(y, -179, 179), math.Clamp(z, -89, 89))
	else
		vp_punch_angle = Angle()
		vp_punch_angle_velocity = Angle()
	end
	
	if vp_punch_angle:IsZero() and vp_punch_angle_velocity:IsZero() then return end
	
	if LocalPlayer():InVehicle() then return end
	
	LocalPlayer():SetEyeAngles(LocalPlayer():EyeAngles() + vp_punch_angle - vp_punch_angle_last)
	vp_punch_angle_last = vp_punch_angle
end)

function SetViewPunchAngles(angle)
	if not angle then return end

	vp_punch_angle = angle
end

function SetViewPunchVelocity(angle)
	if not angle then return end

	vp_punch_angle_velocity = angle * 20
end

function Viewpunch(angle)
	if not angle then return end
	
	vp_punch_angle_velocity = vp_punch_angle_velocity + angle * 20
end

function ViewPunch(angle)
	Viewpunch(angle)
end

function GetViewPunchAngles()
	return vp_punch_angle
end

function GetViewPunchVelocity()
	return vp_punch_angle_velocity
end

local vb_multipliers = {}
local vb_enabled = {}
for _, typee in ipairs({"slow", "normal", "run", "idle", "dmg", "land", "jump", "crouch", "uncrouch", "tilt"}) do
	vb_multipliers[typee] = 0.5
	vb_enabled[typee] = true
end
local atlas_visuals_bobbing = CreateConVar("atlas_viewbob_enabled", 1, FCVAR_ARCHIVE, "Toggle for visual bobbing.")

local tilt = 0
local tilt_limit = 20
local tilt_decay = 1.0

local function is_enabled(typee, ply)
	if not atlas_visuals_bobbing:GetBool() then
		return false
	end
	if not vb_enabled[typee] then return false end
	if ply:GetMoveType() == MOVETYPE_NOCLIP then return false end
	return true
end

function viewbob_main(ply, pos, foot, sound, volume, rf, jumped)
	if ply != LocalPlayer() then return end
	local speed = ply:GetMaxSpeed()
	local typee = "normal"
	local side = 0
	if ply:KeyDown(IN_WALK) then typee = "slow" end
	if ply:KeyDown(IN_SPEED) then typee = "run" end

	if foot == 0 then
		-- left foot
		side = 1
	elseif foot == 1 then
		-- right foot
		side = -1
	end

	local angle = Angle()
	local mult = vb_multipliers[typee]


	if typee == "slow" then mult = mult * 0.2 end
	if typee == "normal" then mult = mult * 0.3 end
	if typee == "run" then mult = mult * 0.5 end

	if ply:KeyDown(IN_FORWARD) then
		angle = angle + Angle(2, side, side)
	end

	if ply:KeyDown(IN_BACK) then
		angle = angle + Angle(-2, side, side)
	end

	if ply:KeyDown(IN_MOVELEFT) then
		angle = angle + Angle(side, side, -2)
	end

	if ply:KeyDown(IN_MOVERIGHT) then
		angle = angle + Angle(side, side, 2)
	end

	if not is_enabled(typee, ply) then mult = 0 end

	angle = angle * mult

	if (ply:KeyPressed(IN_JUMP) or jumped) and is_enabled("jump", ply) and vb_enabled["jump"] then
		angle = angle + Angle(vb_multipliers["jump"]*-3, 0, 0)
	end

	if angle:IsZero() then return end

	Viewpunch(angle)	
end
hook.Add("PlayerFootstep", "viewbob_main", viewbob_main)

function viewbob_land(ply, inWater, onFloater, speed)
	if ply != LocalPlayer() then return end
	if not is_enabled("land", ply) then return end


	if ply:KeyDown(IN_DUCK) then
		Viewpunch(Angle(speed / 80 * vb_multipliers["land"] * 0.5, 0, 0))
	else
		Viewpunch(Angle(speed / 40 * vb_multipliers["land"] * 0.5, 0, 0))
	end
end
hook.Add("OnPlayerHitGround", "viewbob_land", viewbob_land)

function viewbob_dmg(target, dmginfo)
	if target != LocalPlayer() then return end
	if not is_enabled("dmg", target) then return end
	local mult = vb_multipliers["dmg"] * 0.5


	Viewpunch(Angle(math.random(-3,3) * mult, math.random(-3,3) * mult, math.random(-3,3) * mult))
end
hook.Add("EntityTakeDamage", "viewbob_dmg", viewbob_dmg)

local function viewbob_crouch() 
	local ply = LocalPlayer()
	if not ply.KeyDown then return end
	if not ply.vb_crouching then ply.vb_crouching = false end
	ply.vb_crouched_before = ply.vb_crouching
	ply.vb_crouching = ply:KeyDown(IN_DUCK)

	if ply.vb_crouched_before != ply.vb_crouching and ply.vb_crouching then
		if not is_enabled("crouch", ply) then return end
		local mult = vb_multipliers["crouch"]
		Viewpunch(Angle(4 * mult, 
							math.random(-1, 1) * mult, 
							math.random(-1, 1) * mult))
	end

	if ply.vb_crouched_before != ply.vb_crouching and not ply.vb_crouching then
		if not is_enabled("uncrouch", ply) then return end
		local mult = vb_multipliers["uncrouch"]
		Viewpunch(Angle(-4 * mult, 
							math.random(-1, 1) * mult, 
							math.random(-1, 1) * mult))
	end
end
hook.Add("Tick", "viewbob_crouch", viewbob_crouch)

local drunk_view = Angle()
local drunk_view_last = Angle()
local function viewbob_idle()
	if not is_enabled("idle", LocalPlayer()) then return end
	if LocalPlayer():InVehicle() then return end

	local mult = vb_multipliers["idle"]

	drunk_view = Angle(math.cos(CurTime() / 0.9) / 3 * mult,
						math.sin(CurTime() / 0.8) / 3.6 * mult,
						math.cos(CurTime() / 0.5) / 3.3 * mult)
	
	LocalPlayer():SetEyeAngles(LocalPlayer():EyeAngles() + drunk_view - drunk_view_last)
	drunk_view_last = drunk_view
end
hook.Add("Think", "viewbob_idle", viewbob_idle)

local tilt = Angle()
local tilt_last = Angle()
local gx = 0
hook.Add("InputMouseApply", "viewpunch_mouse", function(cmd, x, y, ang)
	gx = x
end)

local function viewbob_tilt()
	if not is_enabled("tilt", LocalPlayer()) then return end
	if LocalPlayer():InVehicle() then return end

	tilt = Angle(0,0,Lerp(FrameTime() * tilt_decay, tilt.z, math.Clamp(gx / 20, -tilt_limit, tilt_limit)))
	
	LocalPlayer():SetEyeAngles(LocalPlayer():EyeAngles() + tilt - tilt_last)
	tilt_last = tilt
end
hook.Add("Think", "viewbob_tilt", viewbob_tilt)