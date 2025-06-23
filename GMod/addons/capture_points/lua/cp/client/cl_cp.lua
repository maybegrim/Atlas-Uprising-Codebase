--[[
	Name: cl_cp.lua
	By: Micro
]]--

surface.CreateFont("Cap_Point_Font", {
    font = "Roboto",
    size = 64,
    weight = 800,
})

local color_two = Color(255, 255, 255, 100)
local gold = Color(255, 215, 0, 255)

net.Receive("CP_InitialSpawn", function()
	for i = 1, #CP_CONFIG.CapturePoints do
		if !CP_CONFIG.CapturePoints[i] then continue end
		
		CP_CONFIG.CapturePoints[i].Owner = net.ReadUInt(CP_CONFIG.BITCOUNT_OWNER) or 0
		CP_CONFIG.CapturePoints[i].Progress = net.ReadUInt(CP_CONFIG.BITCOUNT_PROGRESS) or 0
		CP_CONFIG.CapturePoints[i].TeamProgress = net.ReadUInt(CP_CONFIG.BITCOUNT_TEAMPROGRESS) or 0
	
		CP_CONFIG.CapturePoints[i].OwnerColor = Color(CP_CONFIG.Teams[CP_CONFIG.CapturePoints[i].Owner].color.r, CP_CONFIG.Teams[CP_CONFIG.CapturePoints[i].Owner].color.g, CP_CONFIG.Teams[CP_CONFIG.CapturePoints[i].Owner].color.b, CP_CONFIG.Teams[CP_CONFIG.CapturePoints[i].Owner].color.a)
		CP_CONFIG.CapturePoints[i].OwnerName = CP_CONFIG.Teams[CP_CONFIG.CapturePoints[i].Owner].name
		
		if CP_CONFIG.CapturePoints[i].OwnerColor ~= color_two and CP_CONFIG.CapturePoints[i].OwnerName ~= "Unclaimed" then
			CP_CONFIG.CapturePoints[i].CircleColor.r = CP_CONFIG.CapturePoints[i].OwnerColor.r
			CP_CONFIG.CapturePoints[i].CircleColor.g = CP_CONFIG.CapturePoints[i].OwnerColor.g
			CP_CONFIG.CapturePoints[i].CircleColor.b = CP_CONFIG.CapturePoints[i].OwnerColor.b
		else
			CP_CONFIG.CapturePoints[i].CircleColor.r = color_two.r
			CP_CONFIG.CapturePoints[i].CircleColor.g = color_two.g
			CP_CONFIG.CapturePoints[i].CircleColor.b = color_two.b
		end
		
		CP_CONFIG.CapturePoints[i].OwnerColor = Color(CP_CONFIG.Teams[CP_CONFIG.CapturePoints[i].TeamProgress].color.r, CP_CONFIG.Teams[CP_CONFIG.CapturePoints[i].TeamProgress].color.g, CP_CONFIG.Teams[CP_CONFIG.CapturePoints[i].TeamProgress].color.b, CP_CONFIG.Teams[CP_CONFIG.CapturePoints[i].TeamProgress].color.a)
	end
end)

net.Receive("CP_Owner", function()
	local CPID = net.ReadUInt(CP_CONFIG.BITCOUNT_CPID)
	local owner = net.ReadUInt(CP_CONFIG.BITCOUNT_OWNER)
	local CP = CP_CONFIG.CapturePoints[CPID]
	
	if !CP then return end
	
	CP.Owner = owner
	
	CP.OwnerColor = Color(CP_CONFIG.Teams[owner].color.r, CP_CONFIG.Teams[owner].color.g, CP_CONFIG.Teams[owner].color.b, CP_CONFIG.Teams[owner].color.a)
	CP.OwnerName = CP_CONFIG.Teams[owner].name
	
	if CP.OwnerColor ~= color_two and CP.OwnerName ~= "Unclaimed" then
		CP.CircleColor.r = CP.OwnerColor.r
		CP.CircleColor.g = CP.OwnerColor.g
		CP.CircleColor.b = CP.OwnerColor.b
	else
		CP.CircleColor.r = color_two.r
		CP.CircleColor.g = color_two.g
		CP.CircleColor.b = color_two.b
	end
	
	--[[if owner ~= 0 then
		--chat.AddText(gold, CP.name, color_white, " was captured by the ", CP.OwnerColor, CP.OwnerName, color_white, "." )
		if CP.name == "Foundation HQ" and CP.OwnerName == "Chaos Insurgency" then
			net.Start("NLRTimerCIRaiding")
			net.SendToServer()
		end
	end]]

end)

net.Receive("CP_TeamProgress", function()
	local CPID = net.ReadUInt(CP_CONFIG.BITCOUNT_CPID)
	local teamprogress = net.ReadUInt(CP_CONFIG.BITCOUNT_PROGRESS)
	
	if !CP_CONFIG.CapturePoints[CPID] then return end
	
	CP_CONFIG.CapturePoints[CPID].TeamProgress = teamprogress
	
	CP_CONFIG.CapturePoints[CPID].OwnerColor = Color(CP_CONFIG.Teams[teamprogress].color.r, CP_CONFIG.Teams[teamprogress].color.g, CP_CONFIG.Teams[teamprogress].color.b, CP_CONFIG.Teams[teamprogress].color.a)
end)

net.Receive("CP_Progress", function()
	local CPID = net.ReadUInt(CP_CONFIG.BITCOUNT_CPID)
	local progress = net.ReadUInt(CP_CONFIG.BITCOUNT_PROGRESS)
	
	if !CP_CONFIG.CapturePoints[CPID] then return end
	
	CP_CONFIG.CapturePoints[CPID].Progress = progress
end)

local function CopyVector(vec1, vec2)
	vec1.x = vec2.x
	vec1.y = vec2.y
	vec1.z = vec2.z
end

local abs = math.abs
local sin = math.sin
local sub = string.sub
local Vector = Vector
local CurTime = CurTime

local MaxDrawDist = 1000
local MaxSqrDrawDist = MaxDrawDist*MaxDrawDist
local CachedVector = Vector()
local CachedEyeAngle = Angle(0, 0, 90)
local angle_zero = Angle()
local sinCT
local CapturePoint
local ply
local plypos
local teamjob
local CacheDone
local text

hook.Add("PostDrawOpaqueRenderables", "DrawControlPoints", function()
	if !CP_CONFIG.Initialized then return end 
	
	ply = LocalPlayer()
	plypos = ply:GetPos()
	sinCT = nil
	CacheDone = nil
	teamjob = nil
	
	for i = 1, #CP_CONFIG.CapturePoints do
		CapturePoint = CP_CONFIG.CapturePoints[i]
		
		if !CapturePoint then continue end
		
		if plypos:DistToSqr(CapturePoint.GroundPos) < MaxSqrDrawDist then
			CachedEyeAngle.y = CacheDone and CachedEyeAngle.y or ply:EyeAngles().y-90
			sinCT = sinCT or abs(sin(CurTime()))
			CacheDone = true
		
			CopyVector(CachedVector, CapturePoint.GroundPos)
			CachedVector.z = CachedVector.z + 2
			
			cam.Start3D2D(CachedVector,angle_zero, 0.05)
				draw.RoundedBox(2400, -2400, -2400, 4800, 4800, CapturePoint.CircleColor)
			cam.End3D2D()
			
			CachedVector.z = CachedVector.z - sinCT + 4
			CachedVector.x = CachedVector.x - 2
			
			cam.Start3D2D(CachedVector, CachedEyeAngle, .05)
				surface.SetDrawColor(color_black)
				
				if CapturePoint.Requires and #CapturePoint.Requires > 0 then
					teamjob = teamjob or PlayerGetTeamJob(ply,team.GetName(ply:Team()))
					text = "Requires:"
					
					for k, v in pairs(CapturePoint.Requires) do
						if CP_CONFIG.CapturePoints[v].Owner ~= teamjob then
							text = text.." "..CP_CONFIG.CapturePoints[v].name..","
						end
					end
					
					if text ~= "Requires:" then
						draw.SimpleText(sub(text, 1, #text-1), "Cap_Point_Font", 0, -1105, color_white, TEXT_ALIGN_CENTER)
					end
				end
				
				draw.SimpleText(CapturePoint.name, "Cap_Point_Font", 0, -1000, gold, TEXT_ALIGN_CENTER)
				surface.SetDrawColor(color_black)
				surface.DrawRect(-250, -900, 500, 75)
				surface.SetDrawColor(CapturePoint.OwnerColor)
				surface.DrawRect(-250, -900, 500/30*CapturePoint.Progress, 75)
				surface.SetDrawColor(color_black)
				surface.DrawOutlinedRect(-250, -900, 500, 75)
				draw.SimpleText(CapturePoint.OwnerName, "Cap_Point_Font", 0, -895, color_white, TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end
	end
end)