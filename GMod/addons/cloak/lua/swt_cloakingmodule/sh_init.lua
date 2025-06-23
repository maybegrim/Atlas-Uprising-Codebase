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
    SWT-CM - Shared
--]]-------------------------------------------------------------------

local Player = FindMetaTable("Player")

--[[
	Function: SWT_CM:CanCloak( ply: user )

	Checks if a player can cloak.

	Returns:
		bool - canCloak
]]
function SWT_CM:CanCloak( ply )
	if not IsValid(ply) or ply:IsBot() then
		return false
	end

	-- Players should not be able to cloak themselves, when its disabled in water.
	if SWT_CM.Config.DisableCloakInWater then
		if ply:WaterLevel() >= 1 then
			return false
		end
	end

	if SWT_CM.Config.EnableBatterySystem then
		local battery = ply.CloakBattery or SWT_CM.Config.MaxBattery
		if battery < SWT_CM.Config.MinimumBattery then
			return false
		end
	end
	
	return true
end

--[[
	Function: SWT_CM:CanESP( ply: user )

	Checks if a player can use esp.

	Returns:
		bool - canESP
]]
function SWT_CM:CanESP( ply )
	if not (SWT_CM.Config.EnableESP or IsValid(ply)) then
		return false
	end

	-- Players should not be able to use esp under water.
	if SWT_CM.Config.DisableESPInWater then
		if ply:WaterLevel() >= 1 then
			return false
		end
	end

	return true
end

function SWT_CM:CloakThink(ply)
	if not (IsValid(ply) or ply:Alive() or ply:IsPlayer() or SWT_CM.Config.EnableBatterySystem) then
		return false
	end

	local maxBattery = SWT_CM.Config.MaxBattery
	local battery = ply.CloakBattery or maxBattery

	if ply:IsCloaked() and battery > 0 then
		ply.CloakBattery = math.max(0, battery - SWT_CM.Config.BatteryLoose * FrameTime())
	elseif ply:IsCloaked() and battery < 1 then
		if SERVER then
			SWT_CM:Cloak( ply, false )
		end
	elseif not ply:IsCloaked() then
		ply.CloakBattery = math.min(maxBattery, battery + SWT_CM.Config.BatteryRegeneration * FrameTime())
	end
end

--[[
	Function: Player:IsCloaked() -> bool
	Meta: Player

	Returns whether the player is currently cloaked by the swt cloaking module or not.

	Returns:
		bool - isCloaked
]]
function Player:IsCloaked()
	return self:GetNWBool("SWT_CM.IsCloaked", false)
end

--[[
	Function: Player:HasESPEnabled() -> bool
	Meta: Player

	Returns whether the player has esp enabled or not.

	Returns:
		bool - hasESPEnabled
]]
function Player:HasESPEnabled()
	return self:GetNWBool("SWT_CM.HasESPEnabled", false)
end

-- Disable footsteps while cloaked.
hook.Add( "PlayerFootstep", "SWT_CM.DisableFootstepsWhileCloaked", function(ply, pos, foot, sound, volume, filter)
	if ply:IsBot() then return end

	if SWT_CM.Config.DisableFootstepsWhileCloaked and ply:IsCloaked() then
		return true
	end
end)