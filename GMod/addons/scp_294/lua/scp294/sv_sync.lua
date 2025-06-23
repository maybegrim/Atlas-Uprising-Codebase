util.AddNetworkString( "netSCP294_clientMethod" )
-- Use to create new flavour from client
util.AddNetworkString( "netSCP294_clientSubmitDATA" )
-- Use to create new flavour from client
util.AddNetworkString( "netSCP294_clientRemoveDATA" )
-- Use to sync just one drink
util.AddNetworkString( "netSCP294_syncDrink" )
-- Use to sync all the drink data ( in one thread )
util.AddNetworkString( "netSCP294_syncFullDrinkDATA" )
-- Use to sync all the drink data ( but ONLY Key + color , in one thread )
util.AddNetworkString( "netSCP294_syncOnlyDrinkKey" )
-- Use to sync all the drink data ( one by one )
util.AddNetworkString( "netSCP294_syncAllDrinkDATAIndividually" )
-- Called when the player use the SCP 294
util.AddNetworkString( "netSCP294_openKeyboard" )
-- Called when the player use SCP 294 keyboard
util.AddNetworkString( "netSCP294_useSCP294" )
-- Called when the player die
util.AddNetworkString( "netSCP294_syncPlayerDeath" )
-- Called to save the server DATA
util.AddNetworkString( "netSCP294_sendTextToClient" )

-- wubba lubba dub dub
SCP294Server.playerDownload = {}
SCP294Server.nextThink = CurTime() + 1

-- Send the SCP 294 Entity to the client
function SCP294Server.sendOpenKeyboardFrame( ply, ent )
	net.Start( "netSCP294_openKeyboard" )
		net.WriteEntity( ent )
	net.Send( ply )
end

-- Called when player use the machine
function SCP294Server.receiveUseSCP294( len, ply )
	local NEnt = net.ReadEntity()
	local NStr = net.ReadString()
	if ( NEnt ) then
		if ( NEnt.SCP294 ) then
			if ( ply:GetPos():Distance( NEnt:GetPos() ) < 150 ) then
				NEnt:SpawnCup( NStr )
			end
		end
	end
end

function SCP294Server.sendTextToClient( ply, str )
	net.Start( "netSCP294_sendTextToClient" )
		net.WriteString( str or "?" )
	net.Send( ply )
end

-- Called when the player request the server drink DATA ( with ONLY key + color )
net.Receive( "netSCP294_useSCP294", SCP294Server.receiveUseSCP294 )

-- Alternative way to send drink DATA to client ( send only key and color , in one thread )
function SCP294Server.sendOnlyDrinkKey( ply )
	-- Create a loca table
	local tab = {}
	for k, v in pairs ( SCP294Server.drinkDATA ) do
		tab[k] = { drinkColor = v.drinkColor }
	end
	if ( ply:IsSuperAdmin() or ply:HasPermission("294_editconfig") ) then
		net.Start( "netSCP294_syncOnlyDrinkKey" )
			net.WriteTable( tab )
		net.Send( ply )
	end
end

-- Remove the flavour
function SCP294Server.removeDrink( ply, key )
	if ( ply:IsSuperAdmin() or ply:HasPermission("294_editconfig") ) then
		SCP294Server.drinkDATA[key] = nil
		net.Start( "netSCP294_clientRemoveDATA" )
			net.WriteString( key )
		net.Broadcast()
		SCP294Server.saveDrinkDATA()
	end
end

-- Send the data of a flavour to the player
function SCP294Server.syncDrink( ply, key )
	if ( ply:IsSuperAdmin() or ply:HasPermission("294_editconfig") ) then
		if ( SCP294Server.drinkDATA[key] ) then
			net.Start( "netSCP294_syncDrink" )
				net.WriteString( key )
				net.WriteTable( SCP294Server.drinkDATA[key] )
			net.Send( ply )
		end
	end
end

-- Send full flavour DATA to the player ( not efficient when DATA is to big )
function SCP294Server.syncFullDrink( ply )
	if ( ply:IsSuperAdmin() or ply:HasPermission("294_editconfig") ) then
		net.Start( "netSCP294_syncFullDrinkDATA" )
			net.WriteTable( SCP294Server.drinkDATA )
		net.Send( ply )
	end
end

-- Send the data of a flavour to the player
function SCP294Server.sendAllServerDATAIndividually( ply )
	if ( ply:IsSuperAdmin() or ply:HasPermission("294_editconfig") ) then
		SCP294Server.playerDownload[ply:SteamID()] = coroutine.create( function()
			for k, v in pairs ( SCP294Server.drinkDATA ) do
					net.Start("netSCP294_syncDrink")
					net.WriteString( k )
					net.WriteTable( v )
				net.Send( ply )
				coroutine.yield()
			end 
			-- Tell to the client that the download starts
			net.Start( "netSCP294_syncAllDrinkDATAIndividually" )
				net.WriteInt( 0, 32 )
				net.WriteInt( 0, 32 )
			net.Send( ply )
		end)
		-- Tell to the client that the download is over
		net.Start( "netSCP294_syncAllDrinkDATAIndividually" )
			net.WriteInt( 1, 32 )
			net.WriteInt( table.Count( SCP294Server.drinkDATA ), 32 )
		net.Send( ply )
	end
end

-- Register a flavour in server DATA and broadcast it to all allowed player
function SCP294Server.registerDrinkDATA( ply, data )
	if ( ply:IsSuperAdmin() or ply:HasPermission("294_editconfig") ) then
		SCP294Server.drinkDATA[data.drinkName] = data
		SCP294Shared.repairDrink( SCP294Server.drinkDATA[data.drinkName] )
		local plys = player.GetAll()
		local alloPly = {}
		for k , ply in pairs ( plys ) do
			if ( ply:IsSuperAdmin() or ply:HasPermission("294_editconfig") ) then
				alloPly[k] = ply
			end
		end		
		net.Start( "netSCP294_syncDrink" )
			net.WriteString( data.drinkName )
			net.WriteTable( SCP294Server.drinkDATA[data.drinkName] )
		net.Send( alloPly )
		SCP294Server.saveDrinkDATA()
	end 
end

-- Called when a player want to register a flavour
net.Receive( "netSCP294_clientSubmitDATA", function( len, ply )
	local NTab = net.ReadTable()
	SCP294Server.registerDrinkDATA( ply, NTab )
end)

-- Called when a player request to remove a flavour
net.Receive( "netSCP294_clientRemoveDATA", function( len, ply )
	local NStr = net.ReadString()
	SCP294Server.removeDrink( ply, NStr )
end )

-- Called when a player data of ONE flavour
net.Receive( "netSCP294_syncDrink", function( len, ply )
	local NStr = net.ReadString()
	SCP294Server.syncDrink( ply, NStr )
end ) 

net.Receive( "netSCP294_syncFullDrinkDATA", function( len, ply )
	SCP294Server.syncFullDrink( ply )
end )

-- Called when the player want all flavour, initialize individual download
net.Receive( "netSCP294_syncAllDrinkDATAIndividually", function( len, ply )
	SCP294Server.sendAllServerDATAIndividually( ply )
end ) 

-- Called when the player request the server drink DATA ( with ONLY key + color )
net.Receive( "netSCP294_syncOnlyDrinkKey", function( len, ply )
	SCP294Server.sendOnlyDrinkKey( ply )
end )

-- Send client method
function SCP294Server.sendClientMethod( ply, key, data )
	net.Start( "netSCP294_clientMethod" )
		net.WriteString( key )
		net.WriteTable( data )
	net.Send( ply )
end
