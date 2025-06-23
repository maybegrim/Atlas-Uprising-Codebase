--[[
	Name: sv_cp.lua
	By: Micro
]]--

util.AddNetworkString("CP_InitialSpawn")
util.AddNetworkString("CP_Progress")
util.AddNetworkString("CP_Owner")
util.AddNetworkString("CP_TeamProgress")

CP_CONFIG.NetworkPointsData = function(ply)
	local CP
	
	net.Start("CP_InitialSpawn")
		for i = 1,#CP_CONFIG.CapturePoints do
			CP = CP_CONFIG.CapturePoints[i]
			
			if !CP then continue end
			
			net.WriteUInt(CP.Owner,CP_CONFIG.BITCOUNT_OWNER)
			net.WriteUInt(CP.Progress,CP_CONFIG.BITCOUNT_PROGRESS)
			net.WriteUInt(CP.TeamProgress,CP_CONFIG.BITCOUNT_TEAMPROGRESS)
		end
	net.Send(ply)
end

hook.Add("PlayerInitialSpawn", "FullLoadSetup", function(ply)
    hook.Add("SetupMove", ply, function(self, ply, _, cmd)
        if self == ply and not cmd:IsForced() and CP_CONFIG.Initialized then hook.Run("PlayerFullLoad", self) hook.Remove("SetupMove", self) end
    end)
end)

hook.Add("PlayerFullLoad", "cp_network_PlayerFullLoad",function(ply)
	CP_CONFIG.NetworkPointsData(ply)
end)

local FindInSphere = ents.FindInSphere
local pairs = pairs
local min = math.min
local insert = table.insert
local HasValue = table.HasValue
local Empty = table.Empty
local RemoveByValue = table.RemoveByValue
local Copy = table.Copy
local CurTime = CurTime
local ct
local TickRate = 0.1
local NextTick = 0

local CapturePoint

hook.Add("Tick", "CP_Think", function()
	ct = CurTime()
	
	if NextTick > ct or !CP_CONFIG.Initialized then return end
	
	NextTick = ct + TickRate
	
	for I = 1, #CP_CONFIG.CapturePoints do
		CapturePoint = CP_CONFIG.CapturePoints[I]
		
		if !CapturePoint then continue end
		
		local Progress = CapturePoint.Progress
		local Owner = CapturePoint.Owner
		local job = "none"
		local TeamProgress
		local ConfigTeamID
		local ConfigTeam
		
		Empty(CapturePoint.Players)
		
		for k, v in pairs(FindInSphere(CapturePoint.GroundPos, 125)) do
			if v:IsPlayer() and v:Alive() then
				CapturePoint.Players[k] = v
				
				job = team.GetName(v:Team())
				
				ConfigTeamID = PlayerGetTeamJob(v, job)
				
				if ConfigTeamID then
					ConfigTeam = CP_CONFIG.Teams[ConfigTeamID]
					
					local CanCap = true
					
					if CapturePoint.Requires then
						for k, v in pairs(CapturePoint.Requires) do
							CanCap = CP_CONFIG.CapturePoints[v].Owner == ConfigTeamID
							
							if !CanCap then break end
						end
					end
					
					if ConfigTeam.jobs[job] and (Owner ~= ConfigTeamID and Owner ~= 0) then
						if CanCap then
							Progress = 0
							Owner = 0
							TeamProgress = 0
						end
					end
					
					if not CapturePoint._Teams[ConfigTeam.name] then
						if CanCap then
							CapturePoint._Teams[ConfigTeam.name] = ConfigTeam.count
							insert(CapturePoint.Teams, ConfigTeam.name)
						end
					end
					
					if (#CapturePoint.Teams > 1 or CapturePoint.PrevColor ~= ConfigTeam.color) then
						if CanCap then
							Progress = 0
							CapturePoint.LastReward = nil
						end
					else
						if CanCap then
							TeamProgress = ConfigTeamID
							Progress = min(Progress + 1, 30)
						end
					end
					
					if Progress < 30 then
						if CapturePoint.PrevColor ~= ConfigTeam.color and not CapturePoint.Capturing then
							if CanCap then
								Progress = 0
								CapturePoint.PrevColor = ConfigTeam.color
								CapturePoint.Capturing = true
							end
						else
							CapturePoint.PrevColor = ConfigTeam.color
							CapturePoint.Capturing = true
						end						
					elseif Progress == 30 then
						if (Owner == ConfigTeamID or Owner == 0) and CapturePoint.LastReward ~= ConfigTeamID then
							CapturePoint.JustCapped = true
							CapturePoint.LastReward = ConfigTeamID
							Owner = ConfigTeamID
						end
					end
					
					CapturePoint.Progress = Progress
					CapturePoint.Owner = Owner
				end
				
			end
		end
		
		if TeamProgress then
			CapturePoint.TeamProgress = TeamProgress
		end
		
		for k, v in pairs(CapturePoint.Players) do
			RemoveByValue(CapturePoint.PrevPlayers, v)
		end
		
		for k, v in pairs(CapturePoint.PrevPlayers) do
			if IsValid(v) then
				CapturePoint.Capturing = false
				
				job = team.GetName(v:Team())
				ConfigTeamID = PlayerGetTeamJob(v, job)
				ConfigTeam = CP_CONFIG.Teams[ConfigTeamID]
				
				if !ConfigTeam then continue end
				
				if ConfigTeam.jobs[job] then
					RemoveByValue(CapturePoint.Teams, ConfigTeam.name)
					CapturePoint._Teams[ConfigTeam.name] = nil
				end
			end
		end
		
		CapturePoint.PrevPlayers = Copy(CapturePoint.Players)
		
		if CapturePoint.JustCapped then
			CapturePoint.JustCapped = false
			local FormattedMoney = DarkRP.formatMoney(CP_CONFIG.CapturePoints[I].reward or 0)
			
			for k, v in pairs(CapturePoint.Players) do
				v:addMoney(CP_CONFIG.CapturePoints[I].reward or 0)
				DarkRP.notify(v, 0, 4, "You've been awarded " ..FormattedMoney .." for capturing the point!")
			end
			
			CapturePoint.Owner = CapturePoint.LastReward
		end
		
		if CapturePoint.Progress ~= CapturePoint.OldProgress then
			net.Start("CP_Progress")
				net.WriteUInt(I, CP_CONFIG.BITCOUNT_CPID)
				net.WriteUInt(CapturePoint.Progress, CP_CONFIG.BITCOUNT_PROGRESS)
			net.Broadcast()
		end
		
		if CapturePoint.Owner ~= CapturePoint.OldOwner then
			net.Start("CP_Owner")
				net.WriteUInt(I,CP_CONFIG.BITCOUNT_CPID)
				net.WriteUInt(CapturePoint.Owner,CP_CONFIG.BITCOUNT_OWNER)
			net.Broadcast()
			--hook.Call("ATLAS.PointCaptured", nil, CapturePoint.Owner, CapturePoint.OldOwner, CapturePoint.Players, CapturePoint.name)
			if CapturePoint.name == "Foundation HQ" and CapturePoint.Owner == "Chaos Insurgency" then
				raidactive = true
				raidtime = 1740
				timer.Create("NLRRaidTimer", 1, 0, function()
					if raidtime > 1 then
						raidtime = raidtime-1
					else
						if timer.Exists("NLRRaidTimer") then
							timer.Remove("NLRRaidTimer")
							raidactive = false
						end
					end
				end)
			end
		end
		
		if CapturePoint.TeamProgress ~= CapturePoint.OldTeamProgress then
			net.Start("CP_TeamProgress")
				net.WriteUInt(I,CP_CONFIG.BITCOUNT_CPID)
				net.WriteUInt(CapturePoint.TeamProgress, CP_CONFIG.BITCOUNT_TEAMPROGRESS)
			net.Broadcast()
		end
		
		CapturePoint.OldTeamProgress = CapturePoint.TeamProgress
		CapturePoint.OldProgress = CapturePoint.Progress
		CapturePoint.OldOwner = CapturePoint.Owner
	end
end)

hook.Remove("InitPostEntity", "Spawn_Capture_Points")

hook.Remove("PostCleanupMap", "Spawn_Capture_Points_After_Cleanup")