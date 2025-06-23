

-- Create the base of the save structure ( reset function )
function SCP294Server.initializeSaveFolder()
	if ( not file.Exists( "scp294", "DATA" ) ) then
		MsgC( Color( 255, 255, 0 ), "[SCP 294] DATA folder don't exist , creating the folder\n" )
		file.CreateDir( "scp294" )
	end
	if ( not file.Exists( "scp294/data.txt", "DATA" ) ) then
		MsgC( Color( 255, 255, 0 ), "[SCP 294] DATA file don't exist , creating the default file\n" )
		SCP294Server.createDefaultDATA()
	end
end

-- Save the drink list table in data folder
function SCP294Server.saveDrinkDATA()
	if ( file.Exists( "scp294", "DATA" ) ) then
		MsgC( Color( 255, 255, 0 ), "[SCP 294] Saving the data file\n" )
		local data = util.TableToJSON( SCP294Server.drinkDATA )
		file.Write( "scp294/data.txt", data )
	else
		MsgC( Color( 255, 255, 0 ), "[SCP 294] The main folder don't exist !\n" )
	end
end

-- Load the JSON drink list
function SCP294Server.loadDrinkDATA()
	MsgC( Color( 255, 255, 0 ), "[SCP 294] Loading the data file\n" )
	local json = file.Read("scp294/data.txt", "DATA")
	if ( not json ) then
		MsgC( Color( 255, 0, 0 ), "[SCP 294] The DATA file don't exist!\n" )
		MsgC( Color( 255, 0, 0 ), "[SCP 294] Init creation of the DATA !\n" )
		SCP294Server.initializeSaveFolder()
		SCP294Server.loadDrinkDATA()
		return
	end
	local data = util.JSONToTable( json )
	if ( data ) then
		SCP294Server.drinkDATA = data
		MsgC( Color( 255, 255, 255 ), "[SCP 294] Loaded flavours :\n" )
		for k , v in pairs ( SCP294Server.drinkDATA ) do
			MsgC( Color( 255, 255, 255 ), "[" .. k .. "] " )
		end
		for k , v in pairs ( SCP294Server.drinkDATA ) do
			local allKey = { "drinkName", "drinkDescription", "drinkColor", "drinkSound", "creationSound", "selectedMethod" }
			for _, key in pairs ( allKey ) do
				if ( SCP294Server.drinkDATA[k] ) then
					if not ( SCP294Server.drinkDATA[k][key] ) then
						MsgC( Color( 255, 0, 0 ), "\n FLAVOUR [" .. k .. "] IS CORRUPTED " .. key .. " variable is missing !\nRemoving the flavour\n" )
						SCP294Server.drinkDATA[k] = nil
					end
				end
			end
		end
		MsgC( "\n" )
	else
		MsgC( Color( 255, 0, 0 ), "[SCP 294] Can't load the DATA !\n" )
		if ( file.Exists( "scp294/data.txt", "DATA" ) ) then
			MsgC( Color( 255, 0, 0 ), "[SCP 294] The DATA file must be corrupted!\n" )
			MsgC( Color( 255, 0, 0 ), "[SCP 294] Reset the DATA !\n" )
			SCP294Server.createDefaultDATA()
			SCP294Server.loadDrinkDATA()
		end
	end
end

local function createSimpleFlavour( key, col, creationSound, drinkSound, drinkDescription  )
	local data = { drinkName = string.lower(key), drinkDescription = ( drinkDescription or "Slurp" ), drinkColor = ( col or Color( 255, 255, 255 ) ),	drinkSound = (drinkSound or "normal"), creationSound = (creationSound or "normal"), selectedMethod = {} }
	return data
end

-- Create the default drink list
function SCP294Server.createDefaultDATA()
	MsgC( Color( 255, 255, 0 ), "[SCP 294] Creating the default method list\n" )
	local defaultDATA = {}
	
	-- Strong alcohol
	local flavourList = { "Alcohol", "Ethanol", "Ethanol Liquid", "Spirit", "Vodka", "Rhum" }
	for _, v in pairs ( flavourList ) do
		local flavour = createSimpleFlavour( v, Color( 255, 255, 200 ), nil, nil, "Damn, that's strong" )
		flavour.selectedMethod = {
			headMovement = { speed = 2, intensity = 15, time = 16 },
			motionBlur = { addTransparency = 0.15, drawTransparency = 0.88, frameCaptureDelay = 0.02, time = 16 }
		}
		defaultDATA[flavour.drinkName] = flavour
	end
	
	-- Alcohol
	local flavourList = { "Beer", "Lager" }
	for _, v in pairs ( flavourList ) do
		local flavour = createSimpleFlavour( v, Color( 255, 150, 0, 150 ), nil, "good", "The drink tastes like a standard pale lager" )
		defaultDATA[flavour.drinkName] = flavour
	end
	
	-- SCP-106
	local flavourList = { "SCP 106", "106", "Black corrosive liquid", "Old Man" }
	for _, v in pairs ( flavourList ) do
		local flavour = createSimpleFlavour( v, Color( 0, 0, 0 ), nil, "cough", "I feel strange. It's as if there was something moving in my stomach" )
		flavour.selectedMethod = {
			headMovement = { speed = 2, intensity = 15, time = 18 },
			motionBlur = { addTransparency = 0.15, drawTransparency = 0.88, frameCaptureDelay = 0.02, time = 16 },
			bleed = { damage = 5, interval = 1, amount = 18 },
			toyTown = { passes = 15, heightSize = 100, time = 18 }
		}
		defaultDATA[flavour.drinkName] = flavour
	end
	
	-- Carrot
	local flavourList = { "Carrot", "Carrot Juice" }
	for _, v in pairs ( flavourList ) do
		local flavour = createSimpleFlavour( v, Color( 255, 150, 0 ), nil, nil, "Pretty good." )
		defaultDATA[flavour.drinkName] = flavour
	end
	
	-- My favorite flavour <3
	local flavourList = { "Sadness", "Unhappiness", "Mourning", "Grieving" }
	for _, v in pairs ( flavourList ) do
		local flavour = createSimpleFlavour( v, Color( 120, 120, 120, 120 ), nil, nil, "The warm liquid has a salty after-taste, almost like tears." )
		defaultDATA[flavour.drinkName] = flavour
	end
	
	-- All instant kill flavour
	local flavourList = { 
		["Strange Matter"] = Color( 170, 170, 170 ),
		["Sulfuric Acid"] = Color( 170, 170, 170, 120 ),
		["Superfluid Helium"] = Color( 255, 255, 255 ),
		["Superfluid"] = Color( 255, 255, 255 ),
		["Liquid Helium"] = Color( 255, 255, 255 ),
		["Radioactive"] = Color( 0, 255, 0 ),
		["Gold"] = Color( 255, 255, 0 ),
		["Death"] = Color( 0, 0, 0 ),
		["Carbon"] = Color( 0, 0, 0 ),
		["Stone"] = Color( 180, 180, 180 ),
		["Lava"] = Color( 255, 160, 0 ),
		["Magma"] = Color( 255, 160, 0 ),
		["Steel"] = Color( 180, 180, 180 ),
		["Iron"] = Color( 180, 180, 180 ),
		["Metal"] = Color( 180, 180, 180 ),
		["Strange matter"] = Color( 180, 180, 180 ),
	}
	for k, v in pairs ( flavourList ) do
		local flavour = createSimpleFlavour( k, v, "insane", "burn", "" ) 
		flavour.selectedMethod = {
			kill = {}
		}
		defaultDATA[flavour.drinkName] = flavour
	end
	
	-- Agony
	local flavourList = { "Pain", "Agony" }
	for _, v in pairs ( flavourList ) do
		local flavour = createSimpleFlavour( v, Color( 120, 120, 120, 120 ), nil, "cough", "" )
		flavour.selectedMethod = {
			headMovement = { speed = 2, intensity = 5, time = 10 },
			motionBlur = { addTransparency = 0.15, drawTransparency = 0.88, frameCaptureDelay = 0.02, time = 10 },
			bleed = { damage = 3, interval = 1, amount = 10 },
		}
		defaultDATA[flavour.drinkName] = flavour
	end
	
	local flavour = createSimpleFlavour( "Lemon fanta", Color( 255, 255, 0, 150 ), nil, "good", "Take that! In one gulp, without breathing." )
	defaultDATA[flavour.drinkName] = flavour	
	
	local data = util.TableToJSON( defaultDATA )
	file.Write( "scp294/data.txt", data )
	MsgC( Color( 255, 255, 0 ), "[SCP 294] Saving the data file\n" )
end
