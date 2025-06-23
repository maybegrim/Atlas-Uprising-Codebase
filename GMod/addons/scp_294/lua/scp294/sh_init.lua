SCP294Shared = ( SCP294Shared or {} )
SCP294Shared.IDVersion = "0006"
 
function SCP294Shared.checkVersion()
	local function Succes( body, size, headers, code )
		local IDVPos = string.find( body:lower(), "id_version" )
		if ( not IDVPos ) then print("error") return end
		local IDV = string.sub( body, IDVPos + 11, IDVPos + 14 )
		if ( IDV ~= tostring( SCP294Shared.IDVersion ) ) then
			if ( CLIENT ) then
				chat.AddText( Color( 255, 0, 0 ), "[SCP294R] New update for SCP 294 - Redux ( Editor Version ) available !" )
				chat.AddText( Color( 255, 255, 255 ), "[SCP294R] Actual Version : " .. SCP294Shared.IDVersion )
				chat.AddText( Color( 255, 255, 255 ), "[SCP294R] Workshop Version : " .. IDV )
			else
				MsgC( Color( 255, 0, 0 ), "[SCP294R] New update for SCP 294 - Redux ( Editor Version ) available !\n" )
				MsgC( Color( 255, 255, 255 ), "[SCP294R] Actual Version : " .. SCP294Shared.IDVersion ..  "\n" )
				MsgC( Color( 255, 255, 255 ), "[SCP294R] Workshop Version : " .. IDV ..  "\n" )
			end
		else
			if ( SERVER ) then
				MsgC( Color( 0, 255, 0 ), "[SCP294R] No update available for SCP 294 - Redux ( Editor Version )\n" )
			end
		end
	end
	http.Fetch( "https://steamcommunity.com/sharedfiles/filedetails/?id=1572489267", Succes, function() end, {} )
end

SCP294Shared.checkVersion()