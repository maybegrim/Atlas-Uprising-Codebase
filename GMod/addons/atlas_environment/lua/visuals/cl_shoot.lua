local enabled = CreateConVar("cl_screenshake_enabled", "1", FCVAR_ARCHIVE)

local hook_compatibility = false

local fov_mult = 1
local shake_mult = 1
local shake_pitch_mult = 1
local default_shake_target = 1
local default_fov_push = 1

local motion_blur_enabled = CreateConVar("atlas_motionblur_enabled", "1", FCVAR_ARCHIVE)
local motion_blur_mult = 5

local vm_shake_enabled = CreateConVar("atlas_viewshoot_enabled", "1", FCVAR_ARCHIVE)
local vm_shake_mult = 1

local decay_mult = 0.5

local frac = 0

local flip_shake = 1
local target_flip_shake = 1

local flip_fov = 1
local target_flip_fov = 1

local shake_target = 2
local shake = Angle()
local last_shake = Angle()

local fov_push_target = 2
local fov_push = 0
local last_fov_push = 0
local fov_reset = false

local compatible = true

local previous_ammo = 0
local previous_weapon = NULL

local move_push = 0
local move_push_c = 0

USS_CALC = false

local function calculate_compatibility()
	local lp = LocalPlayer()

	local current_weapon = nil

	local _weapon = lp:GetActiveWeapon()
	if IsValid(_weapon) and isfunction(_weapon.GetClass) then
		current_weapon = _weapon:GetClass()
	end
	
	if not current_weapon or string.StartsWith(current_weapon, "mg_") then 
		compatible = false 
		return 
	end

	compatible = not hook_compatibility
end

local function elastic_quad_ease(f)
	return math.ease.InElastic(math.ease.InQuad(f))
end

local function unclamped_lerp(t, from, to)
	return from + (to - from) * t
end

hook.Add("InitPostEntity", "uss_load_mults", function()
	if not GetConVar("mat_motion_blur_enabled"):GetBool() then
		LocalPlayer():ConCommand("mat_motion_blur_enabled 1")
		LocalPlayer():ConCommand("mat_motion_blur_strength 0")
	end
end)

hook.Add("Think", "uss_calculate", function()
	if not enabled:GetBool() then return end
	
	local lp = LocalPlayer()

	calculate_compatibility()

	frac = math.Clamp(frac - FrameTime() * decay_mult, 0, 1)

	flip_shake = Lerp(FrameTime() * 60 * decay_mult, flip_shake, target_flip_shake)
	flip_fov = Lerp(FrameTime() * 60 * decay_mult, flip_fov, target_flip_fov)

	local f = elastic_quad_ease(frac)

	if compatible then
		shake.x = unclamped_lerp(f, 0, shake_target) * 0.5 * shake_pitch_mult
	end

	shake.z = unclamped_lerp(f, 0, shake_target) * flip_shake
	fov_push = unclamped_lerp(f, 0, fov_push_target) * flip_fov
	
	if not compatible then
		if frac <= 0 and not fov_reset then
			lp:SetFOV(0, 0.5)
			fov_reset = true
		end

		if frac > 0 then
			fov_reset = false
			lp:SetFOV(lp:GetFOV() + fov_push - last_fov_push)
			last_fov_push = fov_push
		end

		lp:SetEyeAngles(lp:EyeAngles() + shake - last_shake)
		last_shake.z = shake.z
	end

end)

local vm_shake_target = Angle()
local vm_shake = Angle()

hook.Add("CalcViewModelView", "uss_apply_vm", function(weapon, vm, old_pos, old_ang, pos, ang) 
	if not vm_shake_enabled:GetBool() or frac <= 0 then return end

	vm_shake_target = Angle(0, 0, shake.z * -5 * vm_shake_mult)
	vm_shake = LerpAngle(FrameTime() * 10, vm_shake, vm_shake_target)

	ang:Add(vm_shake)
end)

hook.Add("CalcView", "uss_apply_alt", function(ply, origin, angles, fov, znear, zfar)
	if USS_CALC or not enabled:GetBool() or not compatible or frac <= 0 then return end

	USS_CALC = true
	local base_view = hook.Run("CalcView", ply, origin, angles, fov, znear, zfar)
	if base_view then
		origin, angles, fov, znear, zfar, drawviewer = base_view.origin or origin, base_view.angles or angles, base_view.fov or fov, base_view.znear or znear, base_view.zfar or zfar, base_view.drawviewer or false
	end
	USS_CALC = false

	local view = {
		origin = origin,
		angles = angles + shake,
		fov = fov + fov_push,
		drawviewer = drawviewer
	}

	return view
end)

local function on_primary_attack(lp, weapon)
	if not vm_shake_enabled:GetBool() then return end
	local weapon_class = weapon:GetClass()

	shake_target = default_shake_target
	fov_push_target = default_fov_push

	if math.Rand(0, 1) > 0.7 then
		target_flip_shake = target_flip_shake * -1
	end
	
	if math.Rand(0, 1) > 0.7 then
		target_flip_fov = target_flip_fov * -1
	end

	local custom_shake = 1
	local custom_fov_push = 1

	shake_target = shake_target * shake_mult * custom_shake
	fov_push_target = fov_push_target * fov_mult * custom_fov_push

	move_push_c = move_push_c + 1

	frac = 1 // the part that actually starts the shake
end

hook.Add("Think", "uss_detect_fire", function()
	if not enabled:GetBool() then return end
	// We could very well use entityfirebullets in this one and do all the magic bullet sorting like in DWRV3 so we don't get more than 1 shot in 1-2 frames.
	// But I feel like it's too expensive for such a simple task.
	local lp = LocalPlayer()

	if not lp:Alive() then return end

	local weapon = lp:GetActiveWeapon()

	if not weapon then return end
	if not isfunction(weapon.Clip1) then return end

	local current_ammo = weapon:Clip1()
	if (previous_ammo - current_ammo < 2 or current_ammo != 0) and current_ammo < previous_ammo and not (weapon != previous_weapon) then
		on_primary_attack(lp, weapon)
	end
	
	previous_ammo = current_ammo
	previous_weapon = weapon
end)

hook.Add("GetMotionBlurValues", "uss_motion_blur", function( x, y, w, z)
	if not enabled:GetBool() or not motion_blur_enabled:GetBool() or frac <= 0 then return end

	w = math.abs(-fov_push / 80 * motion_blur_mult)

	return x, y, w, z
end)
