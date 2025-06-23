--[[
	=================================================
	███████╗██╗    ██╗████████╗    ██████╗███╗   ███╗
	██╔════╝██║    ██║╚══██╔══╝   ██╔════╝████╗ ████║
	███████╗██║ █╗ ██║   ██║█████╗██║     ██╔████╔██║
	╚════██║██║███╗██║   ██║╚════╝██║     ██║╚██╔╝██║
	███████║╚███╔███╔╝   ██║      ╚██████╗██║ ╚═╝ ██║
	╚══════╝ ╚══╝╚══╝    ╚═╝       ╚═════╝╚═╝     ╚═╝
	=================================================
	-> Shadow-Trooper Cloaking Module

	_______________________________
	Created by
		- Speedcup (https://steamcommunity.com/id/speedcup/ - 76561198261053079)
		- Schmockwurst (https://steamcommunity.com/id/schmockwurst/ - 76561198197583550)
]]

--[[-------------------------------------------------------------------
    SWT-CM - Server
--]]-------------------------------------------------------------------

function SWT_CM:Cloak( ply, force )
	if not IsValid(ply) or (not ply:HasWeapon("swt_cloakingmodule") or ply:IsBot()) then
		return false
	end

	local isCloaked = ply:GetNWBool("SWT_CM.IsCloaked", false)

	-- If force is available and not nil, overwrite isCloaked with the force value.
	if force then
		isCloaked = force
	end

	if not isCloaked then
		-- Skip cancloak when its forced.
		if force == nil and not SWT_CM:CanCloak(ply) then
			return
		end

		ply.OldDraw = ply.Draw

		ply:RemoveAllDecals()
		ply:SetNoTarget(true)
		ply:DrawShadow(false)
		ply:Flashlight( false )
		ply:AllowFlashlight( false )
		ply:SetNWBool("SWT_CM.IsCloaked", true)

		ply:SendLua([[surface.PlaySound("swt_cm/cloak_activation.mp3")]])
	else
		ply:SetNoTarget(false)
		ply:DrawShadow(true)
		ply:AllowFlashlight( true )
		ply:SetNWBool("SWT_CM.IsCloaked", false)

		ply:SendLua([[surface.PlaySound("swt_cm/cloak_deactivation.mp3")]])
	end
end

function SWT_CM:ChangeESP( ply, force )
	if not IsValid(ply) or (not ply:HasWeapon("swt_cloakingmodule") or ply:IsBot()) then
		return false
	end

	local hasESPEnabled = ply:HasESPEnabled()

	-- If force is available and not nil, overwrite isCloaked with the force value.
	if force then
		hasESPEnabled = force
	end

	if not hasESPEnabled then
		if force == nil and not SWT_CM:CanESP(ply) then
			return
		end

		ply:SetNWBool("SWT_CM.HasESPEnabled", true)
		ply:SendLua([[surface.PlaySound("swt_cm/esp_activation.mp3")]])
	else
		ply:SetNWBool("SWT_CM.HasESPEnabled", false)
		ply:SendLua([[surface.PlaySound("swt_cm/esp_deactivation.mp3")]])
	end
end

util.AddNetworkString("SWT_CM.StartCamo")
net.Receive("SWT_CM.StartCamo", function(_, ply)
	local model = net.ReadString()

	if IsValid(ply) and SWT_CM.Config.EnableDisguiseMode and ply:HasWeapon("swt_cloakingmodule") then
		ply.OldModel = ply:GetModel()

		ply:SetMaterial("models/props_combine/com_shield001a")

		timer.Simple(2, function()
			if IsValid(ply) then
				ply:SetModel(model)

				timer.Simple(2, function()
					if IsValid(ply) then
						ply:SetNWBool("SWT_CM.HasActiveCamo", true)
						ply:SetMaterial("")
					end
				end)
			end
		end)
	end
end)

util.AddNetworkString("SWT_CM.StopCamo")
net.Receive("SWT_CM.StopCamo", function(_, ply)
	if IsValid(ply) and SWT_CM.Config.EnableDisguiseMode and ply:HasWeapon("swt_cloakingmodule") then
		ply:SetMaterial("models/props_combine/com_shield001a")

		timer.Simple(1, function()
			if IsValid(ply) then
				ply:SetModel(ply.OldModel)

				timer.Simple(1, function()
					ply:SetMaterial("")
					ply:SetNWBool("SWT_CM.HasActiveCamo", false)
				end)
			end
		end)
	end
end)

hook.Add("Think", "SWT_CM.BatterySystem", function()
	if SWT_CM.Config.EnableBatterySystem then
		for _, ply in pairs(player.GetHumans()) do
			if ply:HasWeapon("swt_cloakingmodule") then
				SWT_CM:CloakThink(ply)
			end
		end
	end
end)

hook.Add("PlayerSpawn", "SWT_CM.ResetCloakOnRespawn", function(ply)
	if ply:IsBot() then return end
	
	if ply:IsCloaked() then
		SWT_CM:Cloak(ply, false)
		ply.OldDraw = ply.Draw

		function ply:Draw(flags)
			if not ply:IsCloaked() then
				ply.OldDraw(flags)
			end
		end
	end

	if ply:GetNWBool("SWT_CM.HasActiveCamo", false) then
		ply:SetNWBool("SWT_CM.HasActiveCamo", false)
		ply:SetModel(ply.OldModel)
		ply:SetMaterial("")
	end
end)

hook.Add("EntityTakeDamage", "SWT_CM.UncloakOnDamage", function(ent, dmg)
	-- Check whether the damage is greater than 1 and "real". Damage random caused by bad maps are excluded by this method.
	if ent:IsPlayer() and ent:IsCloaked() and dmg:GetDamage() >= 1 then
		SWT_CM:Cloak(ent, false)
	end
end)

hook.Add("PlayerCanHearPlayersVoice", "SWT_CM.OnlyCloakedCanHearCloaked", function(rec, send)
	if SWT_CM.Config.OnlyCloakedCanHearCloaked then
		if send:IsCloaked() and rec:IsCloaked() then
			return true, true
		elseif send:IsCloaked() and not rec:IsCloaked() then
			return false
		end
	end
end)

-- InWater Check
hook.Add("Think", "SWT_CM.DisableWhileInWater", function()
	if SWT_CM.Config.DisableCloakInWater or SWT_CM.Config.DisableESPInWater then
		for k, ply in pairs(player.GetHumans()) do
			if ply:WaterLevel() == 1 and ply:IsCloaked() then -- WaterLevel => https://wiki.facepunch.com/gmod/Entity:WaterLevel => 1 = Slightly submerged (at least to the feet) // should be enough? If too less, change it the way you want.
				SWT_CM:Cloak(ply, false)
			end
		end
	end
end)