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
    SWT-CM - Autorun Loader
--]]-------------------------------------------------------------------

SWT_CM = SWT_CM or {}

-- Just for debugging purposes, a debugmode. Defaultly disabled for your convenience.
SWT_CM.DebugMode = SWT_CM.DebugMode or false

--[[
	Function: SWT_CM:Print(text: string, type: string) -> None

	Just a function to print something to console.
]]
function SWT_CM:Print(text, type, chatPrint)
	-- Set default values, when a param wasnt set.
	text = text or ""
	type = type or "debug"
	chatPrint = chatPrint or false

	INFO = Color(60, 220, 200)
	ERROR = Color(255, 0, 0)
	SUCCESS = Color(0, 255, 0)
	DEBUG = Color(50, 255, 200)
	NEUTRAL = Color(255, 255, 255)

	PREFIX = "[SWT-Cloaking] "
	CONSOLE_MESSAGE = (text .. "\n")
	CHAT_MESSAGE = text

	if type == "info" then
		MsgC(INFO, PREFIX, NEUTRAL, CONSOLE_MESSAGE)

		if CLIENT and chatPrint then
			chat.AddText(INFO, PREFIX, NEUTRAL, CHAT_MESSAGE)
		end
	elseif type == "error" then
		MsgC(ERROR, PREFIX, NEUTRAL, CONSOLE_MESSAGE)

		if CLIENT and chatPrint then
			chat.AddText(ERROR, PREFIX, NEUTRAL, CHAT_MESSAGE)
		end
	elseif type == "success" then
		MsgC(SUCCESS, PREFIX, NEUTRAL, CONSOLE_MESSAGE)

		if CLIENT and chatPrint then
			chat.AddText(SUCCESS, PREFIX, NEUTRAL, CHAT_MESSAGE)
		end
	elseif (type == "debug" and SWT_CM.DebugMode) then
		MsgC(DEBUG, PREFIX, NEUTRAL, CONSOLE_MESSAGE)

		if CLIENT and chatPrint then
			chat.AddText(DEBUG, PREFIX, NEUTRAL, CHAT_MESSAGE)
		end
	end
end

function SWT_CM:GetCustomConfig()
	local configPath = "swt_cm_config"
	local filePath = false

	for k, fileName in pairs(file.Find(configPath .. "/*.lua", "LUA")) do
		filePath = configPath .. "/" .. fileName
		break
	end

	return filePath
end

function SWT_CM:Load(time)
	time = time or SysTime()

	local folder = "swt_cloakingmodule"
	local customConfig = SWT_CM:GetCustomConfig()
	if not customConfig then
		SWT_CM:Print("Custom Config not found, using default config instead.")
	end

	if SERVER then
		-- First, load the default config, and then, the custom config.
		AddCSLuaFile(folder .. "/" .. "sh_config.lua")
		AddCSLuaFile(folder .. "/" .. "sh_init.lua")
		AddCSLuaFile(folder .. "/" .. "cl_init.lua")

		include(folder .. "/" .. "sh_config.lua")
		include(folder .. "/" .. "sh_init.lua")
		include(folder .. "/" .. "sv_init.lua")

		if customConfig then
			AddCSLuaFile(customConfig)
			include(customConfig)
		end
	end

	if CLIENT then
		-- First, load the default config, and then, the custom config.
		include(folder .. "/" .. "sh_config.lua")
		include(folder .. "/" .. "sh_init.lua")
		include(folder .. "/" .. "cl_init.lua")

		if customConfig then
			include(customConfig)
		end
	end

	SWT_CM:Print("Loaded! [" .. math.Round(SysTime() - time, 4) .. "s]")
	hook.Run("SWT_CM.Loaded")
end

local start_time = SysTime()
SWT_CM:Print("Loading... - [" .. math.Round(SysTime() - start_time, 4) .. "s]")
SWT_CM:Load(start_time)
