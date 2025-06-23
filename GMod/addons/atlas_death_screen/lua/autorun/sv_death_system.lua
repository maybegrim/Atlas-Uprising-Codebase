if SERVER then

	CreateConVar("sv_respawntime", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE} , "How long time a player has to wait until they respawn.")
	CreateConVar("sv_autorespawn_enabled", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE} , "Enable/disable auto respawn.")
	CreateConVar("sv_deathscreen_enabled", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Turn the addon on and off.")
	CreateConVar("sv_deathscreen_text", "You died!", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, "Edit the text that is displayed after death.")
	
	local DARKRP = false
	local function checkGamemode()
		if gmod.GetGamemode().Name ~= "DarkRP" then
			DARKRP = false
		else
			DARKRP = true
		end
	end
	hook.Add("Initialize", "checkGamemodeDrawHUD", checkGamemode)
	
	-- Local vars
	local maxdeathtime = 10
	local defaultString = "You died!"
	
	local deathsystem_autorespawn = false
	local deathsystem_instantrespawn = false

	local ActiveEMS = {}
	
	-- Network strings
	util.AddNetworkString("enableDrawBlurEffect")
	util.AddNetworkString("disableDrawBlurEffect")
	util.AddNetworkString("OpenRespawnPopup")
	
	-- get jobs from the JSON file
	local function GetsurfaceJob()
		local surfaceJob = file.Read("au_surface_respawn/surfacejobs.json", "LUA")
		if surfaceJob then
			return util.JSONToTable(surfaceJob)
		else
			return {}
		end
	end

	local function isEMSOnline()
		if table.Count(ActiveEMS) > 0 then
			return true
		else
			return false
		end
	end
	
	-- Hook for PlayerDeath
	hook.Add("PlayerDeath", "initializeCustomThinkDeath", function(victim, inflictor, attacker)
		local surfaceJob = GetsurfaceJob() 
		local victimJob = team.GetName(victim:Team())
		
		--[[if not table.HasValue(surfaceJob, victimJob) then
			initializeCustomThinkDeath(victim, inflictor, attacker)
			return
		end]]

		if not surfaceJob[victimJob] then
			initializeCustomThinkDeath(victim, inflictor, attacker)
			return
		end
	
		-- EMS Check 
		local respawnTime = 120  
		local freeRespawnTime = 300 
		local emsJob = "EMS", "EMS Lead" -- replace with actual EMS job name
		local hasEMS = false
		
		--[[for _, ply in ipairs(player.GetAll()) do
			if team.GetName(ply:Team()) == emsJob then
				hasEMS = true
				break
			end
		end]]

		if isEMSOnline() then
			hasEMS = true
		end
	
		--if table.HasValue(surfaceJob, victimJob) then
		if surfaceJob[victimJob] then
			victim:Lock()
		
			timer.Simple(respawnTime, function()
				if not IsValid(victim) then return end
		
				if hasEMS then
					DarkRP.notify(victim, 0, 4, "EMS are available. Respawn for $500.")
					net.Start("OpenRespawnPopup")
					net.WriteEntity(victim)
					net.WriteInt(500, 32)
					net.Send(victim)
				else
					DarkRP.notify(victim, 0, 4, "No EMS available, 3 minutes till free respawn.")
					timer.Simple(freeRespawnTime - respawnTime, function()
						if IsValid(victim) then
							DarkRP.notify(victim, 0, 4, "Free respawn available!")
							net.Start("OpenRespawnPopup")
							net.WriteEntity(victim)
							net.WriteInt(0, 32) 
							net.Send(victim)
						end
					end)
				end
			end)
		end
	end)
	
	-- Initialize death logic
	function initializeCustomThinkDeath(ply, wep, killer)
		if ConVarExists("sv_autorespawn_enabled") then
			deathsystem_autorespawn = GetConVar("sv_autorespawn_enabled"):GetBool()
		else
			deathsystem_autorespawn = false
		end
	
		local deathtime = 0
		if ConVarExists("sv_respawntime") then
			deathtime = GetConVar("sv_respawntime"):GetInt()
			if (GetConVar("sv_respawntime"):GetInt() == 0) then
				deathsystem_instantrespawn = true
			else
				deathsystem_instantrespawn = false
			end
		else
			deathtime = maxdeathtime
		end
		
		if (ConVarExists("sv_deathscreen_enabled")) then
			if (GetConVar("sv_deathscreen_enabled"):GetBool() == true) then
				net.Start("enableDrawBlurEffect")
				net.WriteType(true)
				net.WriteType(deathsystem_autorespawn)
				net.WriteType(deathsystem_instantrespawn)
				if (ConVarExists("sv_deathscreen_text")) then
					net.WriteString(GetConVar("sv_deathscreen_text"):GetString())
				else
					net.WriteString(defaultString)
				end
				net.Send(ply)
			end
		end
		
		ply.nextspawn = CurTime() + deathtime
	end
	
	local function initializeCustomThinkSilentDeath(ply, wep, killer)
		local deathtime = 0
		if ConVarExists("sv_respawntime") then
			deathtime = GetConVar("sv_respawntime"):GetInt()
		else
			deathtime = maxdeathtime
		end
		
		ply.nextspawn = CurTime() + deathtime
		ply.drp_jobswitch = true;
	end
	hook.Add("PlayerSilentDeath", "initializeCustomThinkSilentDeath", initializeCustomThinkSilentDeath)
	
	local function dev_customThinkDeath(ply)
		if (ConVarExists("sv_deathscreen_enabled")) then
			if (GetConVar("sv_deathscreen_enabled"):GetBool() == true) then
				if (deathsystem_instantrespawn == false and ply.drp_jobswitch == false) then
					ply:SetNWFloat("deathTimeLeft", ply.nextspawn - CurTime())
					if (CurTime() >= ply.nextspawn + 1) then
						if (deathsystem_autorespawn == true) then
							ply:Spawn()
							ply.nextspawn = math.huge
						end
					else
						return false
					end
				end
			end
		end
	end
	hook.Add("PlayerDeathThink", "dev_customThinkDeath", dev_customThinkDeath)
	
	-- Player spawn hook
	local function dev_customPlayerSpawn(ply)
		net.Start("disableDrawBlurEffect")
		net.WriteType(false)
		net.Send(ply)
	end
	hook.Add("PlayerSpawn", "dev_customPlayerSpawn", dev_customPlayerSpawn)
	

	hook.Add("PlayerChangedTeam", "ATLAS:DEATH:EMSTRACK", function(ply, oldTeam, newTeam)
		local teamNameNew = team.GetName(newTeam) 
		local teamNameOld = team.GetName(oldTeam)

		if teamNameNew == "EMS" or teamNameNew == "EMS Lead" then
			ActiveEMS[ply:SteamID64()] = true
		end

		if teamNameOld == "EMS" or teamNameOld == "EMS Lead" then
			ActiveEMS[ply:SteamID64()] = nil
		end
	end)

	hook.Add("PlayerDisconnected", "ATLAS:DEATH:EMSTRACK", function(ply)
		if ActiveEMS[ply:SteamID64()] then
			ActiveEMS[ply:SteamID64()] = nil
		end
	end)


	Msg("sv_deathsystem.lua initialized!\n")
	
end

	
