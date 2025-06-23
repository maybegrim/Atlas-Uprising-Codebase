if not GYS.EnableBLogs then return end

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "GYS"
MODULE.Name     = "Detections"
MODULE.Colour   = Color(101, 191, 250)

MODULE:Setup(function()
	MODULE:Hook("GYS.Detection","GYS.Blogs",function(ply, method)
		MODULE:LogPhrase("{1} was caught violating {2}", GAS.Logging:FormatPlayer(ply), method)
	end)
end)

GAS.Logging:AddModule(MODULE)
