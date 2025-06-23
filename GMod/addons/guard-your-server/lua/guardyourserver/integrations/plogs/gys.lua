if not GYS.EnablePLogs then return end
plogs.Register('GYS', true, Color(101, 191, 250))

plogs.AddHook('GYS.Detection', function(ply, method)
	plogs.PlayerLog(pl, 'GYS', ply:Nick() .. " was blocked by " .. method, {
		['SteamID']	= ply:SteamID()
	})
end)