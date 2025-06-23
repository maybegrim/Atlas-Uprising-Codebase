--[[
	Name: sv_map.lua
	By: Micro
]]--

util.AddNetworkString("CapturePointMapOverview")
util.AddNetworkString("CP_MapStatus")

local villagecol = Color(255, 255, 255, 255)
local foundationhqcol = Color(255, 255, 255, 255)
local icelakecol = Color(255, 255, 255, 255)
local lennyslaircol = Color(255, 255, 255, 255)
local cihqcol = Color(255, 255, 255, 255)
local joesshackcol = Color(255, 255, 255, 255)
local lerockcol = Color(255, 255, 255, 255)

local owner
local color



--[[hook.Add("PlayerSay", "OpenCapPointMap", function(ply, text)
    if (string.sub(text, 1, 4) == "/map") then
		villagecol = CP_CONFIG.CapturePoints[7].PrevColor or CP_CONFIG.CapturePoints[7].CircleColor
		foundationhqcol = CP_CONFIG.CapturePoints[1].PrevColor or CP_CONFIG.CapturePoints[1].CircleColor
		icelakecol = CP_CONFIG.CapturePoints[4].PrevColor or CP_CONFIG.CapturePoints[4].CircleColor
		lennyslaircol = CP_CONFIG.CapturePoints[3].PrevColor or CP_CONFIG.CapturePoints[3].CircleColor
		cihqcol = CP_CONFIG.CapturePoints[2].PrevColor or CP_CONFIG.CapturePoints[2].CircleColor
		joesshackcol = CP_CONFIG.CapturePoints[5].PrevColor or CP_CONFIG.CapturePoints[5].CircleColor
		lerockcol = CP_CONFIG.CapturePoints[6].PrevColor or CP_CONFIG.CapturePoints[6].CircleColor
        net.Start("CapturePointMapOverview")
       		net.WriteColor(villagecol)
			net.WriteColor(foundationhqcol)
			net.WriteColor(icelakecol)
			net.WriteColor(lennyslaircol)
			net.WriteColor(cihqcol)
			net.WriteColor(joesshackcol)
			net.WriteColor(lerockcol)
        net.Send(ply)
        return ""
    end
end)]]