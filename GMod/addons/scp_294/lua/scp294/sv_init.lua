SCP294Server = ( SCP294Server or {} )
SCP294Server.drinkDATA = ( SCP294Server.drinkDATA or {} )
SCP294Server.debug = false
SCP294Server.timers = {}

function SCP294Server.applyDrink( ply, key )
	local drink = SCP294Server.drinkDATA[key]
	
	if not ( drink ) then MsgC( Color( 255,0,0 ), "The flavour " .. key .. " don't exist !\n" ) return end
	for key , data in pairs ( drink.selectedMethod ) do
		local method = SCP294Shared.methodList[key]
		local side = method.side
		if ( side == "server" ) then
			SCP294Shared.methodList[key].serverFunc( ply, data )	
		elseif ( side == "client" ) then
			SCP294Server.sendClientMethod( ply, key, data )
		elseif ( side == "shared" ) then
			SCP294Shared.methodList[key].serverFunc( ply, data )	
		end
	end
	
	-- Make sure timers are gone
	if not ( ply:Alive() ) then
		if ( SCP294Server.timers[ply:SteamID()] ) then
			SCP294Server.timers[ply:SteamID()] = nil
		end
		net.Start("netSCP294_syncPlayerDeath")
		net.Send( ply )
	end
	
end

function SCP294Server.createTimer( ply, key, time, count, overwrite, func, deathApply )
	SCP294Server.timers[ply:SteamID()] = ( SCP294Server.timers[ply:SteamID()] or {} )
	if ( SCP294Server.timers[ply:SteamID()][key] ) then
		if ( overwrite ) then
			SCP294Server.timers[ply:SteamID()][key] = {
				time = time,
				count = count,
				countLeft = count,
				lastUse = CurTime(),
				func = func,
				deathApply = ( deathApply or false )
			}
		end
	else
		SCP294Server.timers[ply:SteamID()][key] = {
			time = time,
			count = count,
			countLeft = count,
			lastUse = CurTime(),
			func = func,
			deathApply = ( deathApply or false )
		}
	end
end
 
