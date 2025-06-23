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
    SWT-CM - Custom Config
--]]-------------------------------------------------------------------
-- Just a "debug" print :3
SWT_CM:Print("Loading Custom Config...", "info")

-- Should footsteps be disabled while a player is cloaked?
SWT_CM.Config.DisableFootstepsWhileCloaked = true

-- Whether non-cloaked people cant hear cloaked people or not.
-- Means everyone whos cloaked can only talk to cloaked people.
-- Non-Cloaked people are hearable for non-cloaked people, but cloaked people cant speak with them.
SWT_CM.Config.OnlyCloakedCanHearCloaked = true

-- Whether the cloak should be deactivated in water. (Could cause performance issues, because we have to check the status of a player every second.)
SWT_CM.Config.DisableCloakInWater = true

-- Default cooldown between client swep interactions. (Leftclick, Rightclick, Reload) - Just should prevent spamming.
SWT_CM.Config.DefaultSWEPCooldown = 1

-- Here you can completely enable / disable the esp feature.
SWT_CM.Config.EnableESP = true

-- Whether the esp mode should be deactivated in water. (Could cause performance issues, because we have to check the status of a player every second.)
SWT_CM.Config.DisableESPInWater = true

-- The minimum distance to see player informations
SWT_CM.Config.ESPDistance = 500

-- Here you can enable/disable some information types, whether they should be shown or not.
SWT_CM.Config.ESPInformations = {
    ["health"] = true, -- Default: True
    ["armor"] = true, -- Default: True
}

-- A system that prevents player from using infinite cloak.
SWT_CM.Config.EnableBatterySystem = true

-- The Max Battery, here you could set a different value for each player. (For example Donator = 200?, normal players = 100, thats why i used a function.)
SWT_CM.Config.MaxBattery = 100 -- Default: 100

-- Battery Loose in seconds
SWT_CM.Config.BatteryLoose = 2 -- Default: 2

-- Battery Regeneration in seconds
SWT_CM.Config.BatteryRegeneration = 2 -- Default: 2

-- Minimum Battery to cloke / use holo
SWT_CM.Config.MinimumBattery = (SWT_CM.Config.MaxBattery / 10) -- Default: SWT_CM.Config.MaxBattery / 10

-- Here you can edit relationType related stuff. (e.g. name, color)
SWT_CM.Config.RelationTypes = {
	-- Every unknown object. Could be an unscanned player, a random npc etc.
	["unknown"] = {
		["name"] = "Unknown",
		["color"] = Color(255, 255, 255)
	},
	-- Every unpreffered known object. Everything that was scanned.
	["known"] = {
		["name"] = "Known",
		["color"] = Color(0, 255, 0)
	},
	-- Everything thats an ally?
	["ally"] = {
		["name"] = "Ally",
		["color"] = Color(0, 255, 0)
	},
	-- Everything thats an enemy?
	["enemy"] = {
		["name"] = "Enemy",
		["color"] = Color(255, 0, 0)
	},
}

SWT_CM.Config.RelationAlly = function(ent, localPlayer)
	-- Just a simple check whether both players are from the same category.
	-- Yes => Its an ally player.
	-- False => Not an ally.
	-- You can define your own ally checks here. Whether someone is an ally or not.
	if DarkRP then
		if ent:IsPlayer() and (ent:getJobTable().category == localPlayer:getJobTable().category) then
			return true
		end
	end

	return false -- dont remove this line
end

SWT_CM.Config.RelationEnemy = function(ent, localPlayer)
	-- Just a simple check whether the given ent is from a specific entity class.
	if ent:IsNPC() and (ent:GetClass() == "npc_combine_s") then
		return true
	end
	
	return false -- dont remove this line
end

-- Whether a player's relations should be deleted on disconnect. (They are always deleted on serverrestarts and map changes)
SWT_CM.Config.ResetRelationsOnDisconnect = true

-- Here you can completely enable / disable the disguise mode. (Middle Mouse)
SWT_CM.Config.EnableDisguiseMode = true -- Default: True

-- Every category that wont be shown in the disguise menu.
-- Please Note, you have to enter exact category names.
SWT_CM.Config.HiddenCategories = {}

-- Every job that wont be shown in the disguise menu.
-- You can either enter exact job names or job commands here! NOT TEAM_...
SWT_CM.Config.HiddenJobs = {}


-- TODO
-- The time in seconds it would need to scan a player.
SWT_CM.Config.ScanningTime = 5

-- Just another "debug" print :3
SWT_CM:Print("Custom Config successfully loaded!", "success")