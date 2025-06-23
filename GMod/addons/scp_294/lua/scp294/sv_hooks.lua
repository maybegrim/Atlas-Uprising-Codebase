


hook.Add( "PlayerDeath", "SCP294RPlayerDeath", function(ply)
	if ( ply ) then
		local SteamID = ply:SteamID()
		if ( SCP294Server.timers[SteamID] ) then
			for k, v in pairs ( SCP294Server.timers[SteamID] ) do
				if ( v.deathApply ) then
					v.func()
				end
			end
			SCP294Server.timers[SteamID] = nil
		end
		net.Start("netSCP294_syncPlayerDeath")
		net.Send( ply )
	end
end )

hook.Add( "PlayerSilentDeath", "SCP294RPlayerSilentDeath", function(ply)
	if ( ply ) then
		if ( SCP294Server.timers[ply:SteamID()] ) then
			SCP294Server.timers[ply:SteamID()] = nil
		end
		net.Start("netSCP294_syncPlayerDeath")
		net.Send( ply )
	end
end )

hook.Add( "Think", "SCP294RTimerUpdate", function()
	for key , plyTimers in pairs ( SCP294Server.timers ) do
		for timerKey, timer in pairs ( plyTimers ) do
			if ( CurTime() > ( timer.lastUse + timer.time ) ) then
				if ( timer.count > 0 ) then
					timer.func()
					timer.countLeft = timer.countLeft - 1
					if ( timer.countLeft <= 0 ) then
						plyTimers[timerKey] = nil
					else
						timer.lastUse = CurTime()
					end
				else
					timer.func()
					timer.lastUse = CurTime()
				end	
			end
		end
	end
end)


hook.Add( "Initialize", "SCP294RInitialize", function()
	SCP294Server.initializeSaveFolder()
	SCP294Server.loadDrinkDATA()
end )


-- Think hook that run the download system
hook.Add( "Think", "SCP294RThinkAntiSpam", function()
	if ( CurTime() > SCP294Server.nextThink ) then
		for k, v in pairs ( SCP294Server.playerDownload ) do
			coroutine.resume( v )
		end
		SCP294Server.nextThink = CurTime() + 0.02 -- Security avoid overflow
	end
end)


local function shutDown()
	SCP294Server.saveDrinkDATA()
end

hook.Add( "ShutDown", "SCP294RShutDown", shutDown )