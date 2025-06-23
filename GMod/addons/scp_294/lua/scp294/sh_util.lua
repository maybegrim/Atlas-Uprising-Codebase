
function SCP294Shared.createFastDrink( name, description, sound, col )
	local drinkTable = {
		drinkName = name,
		drinkDescription = description,
		drinkColor = col,
		selectedMethod = {}
	}
	return drinkTable
end

function SCP294Shared.repairDrink( data )
	local function MsgD( ... )
		if ( CLIENT ) then return end
		if ( SCP294Server.debug ) then
			MsgC( ... )
		end
	end

	local errorCount = 0
	MsgD( Color( 255, 255, 255 ), "=====================================\n" )
	MsgD( Color( 255, 255, 255 ), " Checking structure of drink (" .. data.drinkName .. ") \n" )
	MsgD( Color( 255, 255, 255 ), "=====================================\n\n" )
	
	for key , val in pairs ( data.selectedMethod ) do
		MsgD( Color( 255, 255, 255 ), "\n[SCP294] : Selected method <" .. key .. "> ...\n" )
		if ( SCP294Shared.methodList[key] ) then
			local method = SCP294Shared.methodList[key]
			local arguments = method.arguments
			local step = 1
			
			for argKey, argDATA in pairs ( arguments ) do
				MsgD( Color( 255, 255, 255 ), "\n	["..step.."] [SCP294] : Search for argument key named <" .. argKey .. "> ...\n" )
				if ( tostring(val[argKey]) ~= "nil" ) then
					MsgD( Color( 0, 255, 0 ), "	["..step.."] [SCP294] : <" .. argKey .. "> argument exist ! \n" )
				else
					MsgD( Color( 255, 0, 0 ), "	["..step.."] [SCP294] : <" .. argKey .. "> argument don't exist ! \n" )
					errorCount = errorCount + 1
				end
				MsgD( Color( 255, 255, 255 ), "	["..step.."] [SCP294] : <" .. argKey .. "> needed type is " .. argDATA.type .. " ...\n" )
				if ( type( val[argKey] ) == argDATA.type ) then
					MsgD( Color( 0, 255, 0 ), "	["..step.."] [SCP294] : <" .. argKey .. "> argument type ("..type( val[argKey] )..") is valid ...\n" )
				elseif ( type( val[argKey] ) == "table" ) then
					if ( argDATA.type == "color" ) then
						MsgD( Color( 0, 255, 0 ), "	["..step.."] [SCP294] : <" .. argKey .. "> argument type ("..type( val[argKey] )..") is valid ...\n" )
						MsgD( Color( 255, 255, 255 ), "	["..step.."] [SCP294] Color : r = " .. val[argKey].r .. ", g = " .. val[argKey].g .. ", b = " .. val[argKey].b .. ", a = " .. val[argKey].a .. "\n" )
					else
						MsgD( Color( 255, 0, 0 ), "	["..step.."] [SCP294] : Type is a table the type needed is not a table !!\n" )
					end
				else
					MsgD( Color( 255, 0, 0 ), "	["..step.."] [SCP294] : <" .. argKey .. "> argument type ("..type( val[argKey] )..") is not valid ...\n" )
					errorCount = errorCount + 1
					if ( argDATA.type == "number" ) then
						MsgD( Color( 255, 255, 0 ), "	["..step.."] [SCP294] : <" .. argKey .. "> converting type ("..type( val[argKey] )..") to (" .. argDATA.type .. ") ...\n" )
						data.selectedMethod[key][argKey] = tonumber( data.selectedMethod[key][argKey], 10 )
					elseif ( argDATA.type == "string" ) then
						MsgD( Color( 255, 255, 0 ), "	["..step.."] [SCP294] : <" .. argKey .. "> converting type ("..type( val[argKey] )..") to (" .. argDATA.type .. ") ...\n" )
						data.selectedMethod[key][argKey] = tostring( data.selectedMethod[key][argKey] )
					elseif ( argDATA.type == "boolean" ) then
						MsgD( Color( 255, 255, 0 ), "	["..step.."] [SCP294] : [NOT SECURE AT ALL] <" .. argKey .. "> trying to converting type ("..type( val[argKey] )..") to (" .. argDATA.type .. ") ...\n" )
						data.selectedMethod[key][argKey] = tobool( data.selectedMethod[key][argKey] )
						MsgD( Color( 255, 0, 255 ), "	["..step.."] [SCP294] : CONVERSION RESULT : " .. tostring( data.selectedMethod[key][argKey] ) .. "\n" )
					end
				end
				if ( type( val[argKey] ) == "number" ) then
					if ( argDATA.min ) then
						MsgD( Color( 255, 255, 255 ), "	["..step.."] [SCP294] : <" .. argKey .. "> have a minimum value = " .. argDATA.min .. " ...\n" )
						if ( val[argKey] < argDATA.min ) then
							MsgD( Color( 255, 0, 0 ), "	["..step.."] [SCP294] : <" .. argKey .. "> argument is less than the minimum value ! ( " .. val[argKey] .. " < " .. argDATA.min .. " ) ...\n" )
							data.selectedMethod[key][argKey] = argDATA.min
							MsgD( Color( 255, 255, 0 ), "	["..step.."] [SCP294] : Converted into : " .. tostring( data.selectedMethod[key][argKey] ) .. "\n" )
							errorCount = errorCount + 1
						else
							MsgD( Color( 0, 255, 0 ), "	["..step.."] [SCP294] : <" .. argKey .. "> argument is beyond the the minimum value ! ( " .. val[argKey] .. " > " .. argDATA.min .. " ) ...\n" )
						end
					end
					if ( argDATA.max ) then
						MsgD( Color( 255, 255, 255 ), "	["..step.."] [SCP294] : <" .. argKey .. "> have a maximum value = " .. argDATA.max .. " ...\n" )
						if ( val[argKey] > argDATA.max ) then
							MsgD( Color( 255, 0, 0 ), "	["..step.."] [SCP294] : <" .. argKey .. "> argument is beyond the maximum value ! ( " .. val[argKey] .. " > " .. argDATA.max .. " ) ...\n" )
							data.selectedMethod[key][argKey] = argDATA.max
							MsgD( Color( 255, 255, 0 ), "	["..step.."] [SCP294] : Converted into : " .. tostring( data.selectedMethod[key][argKey] ) .. "\n" )
							errorCount = errorCount + 1
						else
							MsgD( Color( 0, 255, 0 ), "	["..step.."] [SCP294] : <" .. argKey .. "> argument is less than the the minimum value ! ( " .. val[argKey] .. " < " .. argDATA.max .. " ) ...\n" )
						end
					end
				end
				step = step + 1
			end
		else
			MsgD( Color( 255, 0, 0 ), "[SCP294] : [CRITICAL ERROR] The method <" .. key .. "> don't exist !\n" )
			errorCount = errorCount + 1
			data.selectedMethod[key] = nil
			MsgD( Color( 255, 255, 0 ), "[SCP294] : Removing the key method from selectedMethod table\n" )
		end
	end
	MsgD( Color( 255, 255, 255 ), "\n[SCP294] : Verification finished ! " )
	if ( errorCount > 0 ) then
		MsgD( Color( 255, 0, 0 ),  "( Error : " .. errorCount .. " )\n", Color( 255, 255, 255 ) )
	else
		MsgD( Color( 0, 255, 0 ),  "( Error : NONE )\n", Color( 255, 255, 255 ) )
	end
end 
 
