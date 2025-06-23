
-- Receive and store the server drink DATA into the client
function SCP294Client.receiveServerFullDATA( len )
	local NTab = net.ReadTable()
	SCP294Client.drinkDATA = NTab
	SCP294Client.applyDFrameCustom()
end

-- Receive and store the server drink (KEY ONLY) DATA into the client
function SCP294Client.receiveOnlyDrinkKeyServerDATA( len )
	local NTab = net.ReadTable()
	for k , v in pairs ( NTab ) do
		if ( type(v) ~= "table" ) then
			SCP294Client.requestDrink( k )
		else
			if ( not v.drinkColor ) then
				SCP294Client.requestDrink( k )
			else
				local r,g,b,a = v.drinkColor.r, v.drinkColor.g, v.drinkColor.b, v.drinkColor.a
				if not ( r and g and b and a ) then
					SCP294Client.requestDrink( k )
				end
			end
		end
	end
	
	SCP294Client.drinkDATA = NTab
	-- Launch custom function from DFrame
	SCP294Client.applyDFrameCustom()
end


function SCP294Client.useSCP294( str )
	if ( SCP294Client.usedEntity ) then
		net.Start( "netSCP294_useSCP294" )
			net.WriteEntity( SCP294Client.usedEntity ) 
			net.WriteString( str )
		net.SendToServer()
	end
end

-- Receive and store all server drink value one by one ( OOF!! )
function SCP294Client.receiveDrink( len )
	local NStr = net.ReadString()
	local NTab = net.ReadTable()
	SCP294Client.drinkDATA[NStr] = NTab
	if ( SCP294Client.downloadInfo ) then
		SCP294Client.lastDownload = CurTime()
	end
	SCP294Client.addNotification( "Receive the flavour : " .. NStr )
	-- Launch custom function from DFrame
	SCP294Client.applyDFrameCustom()
end

-- Receive and store all server drink value one by one ( OOF!! )
function SCP294Client.receiveText( len )
	local NStr = net.ReadString()
	print( "[SCP 296] From  Server : " .. NStr )
end

-- Get info on sync flow
function SCP294Client.receiveServerDATAIndividually()
	local NInt1 = net.ReadInt( 32 )
	local NInt2 = net.ReadInt( 32 )
	if ( NInt1 == 1 ) then
		SCP294Client.downloadInfo = NInt2
		SCP294Client.lastDownload = CurTime()
	else
		if ( SCP294Client.downloadInfo ) then
			SCP294Client.downloadInfo = nil
			SCP294Client.lastDownload = nil
		end
	end	
	SCP294Client.applyDFrameCustom()
end

-- Request to receive server drink (KEY ONLY) DATA
function SCP294Client.requestOnlyDrinkKeyServerDATA()
	net.Start( "netSCP294_syncOnlyDrinkKey" )
	net.SendToServer()
	SCP294Client.addNotification( "Request ALL flavours KEY ONLY" )
end

-- Request to receive server drink DATA
function SCP294Client.requestFullDrinkServerDATA()
	net.Start( "netSCP294_syncFullDrinkDATA" )
	net.SendToServer()
	SCP294Client.addNotification( "Request ALL flavours " )
end

-- Request to receive server drink DATA ( OOF )
function SCP294Client.requestAllServerDATAIndividually()
	net.Start( "netSCP294_syncAllDrinkDATAIndividually" )
	net.SendToServer()
	SCP294Client.addNotification( "Request ALL flavours individually" )
end

-- Receive when the local player die
function SCP294Client.receiveSyncPlayerDeath()
	SCP294Client.resetPostProcess()
	SCP294Client.headMovement = nil
end 

-- Request to receive server drink DATA ( OOF )
function SCP294Client.requestDrink( key )
	net.Start( "netSCP294_syncDrink" )
		net.WriteString( key )
	net.SendToServer()
	SCP294Client.addNotification( "Request to get flavour : " .. key )
end
 
-- Sync with the server table
function SCP294Client.submitDrinkDATA( data )
	net.Start( "netSCP294_clientSubmitDATA" )
		net.WriteTable( data )
	net.SendToServer()
	SCP294Client.addNotification( "Request to add flavour : " .. data.drinkName )
end

-- Request to remove a flavour
function SCP294Client.requestRemoveDrink( key )
	net.Start( "netSCP294_clientRemoveDATA" )
		net.WriteString( key )
	net.SendToServer()
	SCP294Client.addNotification( "Request to remove flavour : " .. key )
end

-- Remove the flavour
function SCP294Client.receiveRemoveDrinkDATA()
	local NStr = net.ReadString()
	SCP294Client.drinkDATA[NStr] = nil
	SCP294Client.addNotification( "Removing flavour : " .. NStr )
	SCP294Client.applyDFrameCustom()
end

-- Receive when drink have client function
net.Receive( "netSCP294_clientMethod", function( len )
	local NStr = net.ReadString()
	local NTab = net.ReadTable()
	SCP294Shared.methodList[NStr].clientFunc( LocalPlayer(), NTab )
end )

-- Receive and the store the SCP 294 we use
net.Receive( "netSCP294_openKeyboard", function()
	local NEnt = net.ReadEntity()
	SCP294Client.usedEntity = NEnt
	SCP294Client.openKeyboard()
end )

net.Receive( "netSCP294_syncDrink", SCP294Client.receiveDrink )
net.Receive( "netSCP294_syncFullDrinkDATA", SCP294Client.receiveServerFullDATA )
net.Receive( "netSCP294_syncOnlyDrinkKey", SCP294Client.receiveOnlyDrinkKeyServerDATA )
net.Receive( "netSCP294_syncAllDrinkDATAIndividually", SCP294Client.receiveServerDATAIndividually )
net.Receive( "netSCP294_clientRemoveDATA", SCP294Client.receiveRemoveDrinkDATA )
net.Receive( "netSCP294_syncPlayerDeath", SCP294Client.receiveSyncPlayerDeath )
net.Receive( "netSCP294_sendTextToClient", SCP294Client.receiveText )

-- Make sure the download is not stuck
hook.Add( "Think", "SCP294RAntiDownloadStuck", function()
	if ( SCP294Client.downloadInfo ) then
		if ( CurTime() - SCP294Client.lastDownload > 10 ) then
			SCP294Client.downloadInfo = nil
			SCP294Client.lastDownload = nil
			MsgC( Color(255,0,0), "[SCP294] : DATA Download timed out !\n" )
		end
	end
end)
