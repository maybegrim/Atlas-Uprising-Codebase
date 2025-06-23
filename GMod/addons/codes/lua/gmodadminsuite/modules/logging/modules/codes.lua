--[[
	Name: codes.lua
	By: Micro
]]--

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Player Events"
MODULE.Name     = "Code Changes"
MODULE.Colour   = Color(255,0,0)

MODULE:Setup(function()
	MODULE:Hook("playerChangedCode", "codeChanged", function(person, code)
		MODULE:Log("{1} changed code to "..tostring(code), GAS.Logging:FormatPlayer(person))
	end)
end)

GAS.Logging:AddModule(MODULE)
