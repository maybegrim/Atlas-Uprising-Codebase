local function CW20_PlayerEnteredVehicle(ply, vehicle, role)
	local wep = ply:GetActiveWeapon()
	
	if IsValid(wep) then
		if wep.CW20Weapon then
			wep.dt.State = CW_ACTION -- set the state to 'action' so that the player 'holsters' it
		end
	end
end

hook.Add("PlayerEnteredVehicle", "CW20_PlayerEnteredVehicle", CW20_PlayerEnteredVehicle)

local SP = game.SinglePlayer()

if SP and SERVER then	
	hook.Add("PlayerFootstep", "CW20_Footstep", function(ply, pos, foot, sound, volume)
		local wep = ply:GetActiveWeapon()
		
		if IsValid(wep) and wep.CW20Weapon then
			SendUserMessage("CW20_FOOTSTEP", wep.Owner)
		end
	end)
elseif CLIENT then
	hook.Add("PlayerFootstep", "CW20_Footstep", function(ply, pos, foot, sound, volume)
		if ply == LocalPlayer() then
			local wep = ply:GetActiveWeapon()
			
			if IsValid(wep) and wep.CW20Weapon then
				wep:addRunTime()
			end
		end
	end)
end