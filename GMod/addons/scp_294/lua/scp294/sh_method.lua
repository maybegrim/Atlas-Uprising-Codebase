SCP294Shared = ( SCP294Shared or {} )
SCP294Shared.methodList = {}
 
SCP294Shared.methodList["kill"] = {
	name = "Kill",
	description = "Kill the player.",
	arguments = {},
	side = "server",
	serverFunc = function( player )
		player:Kill()
	end
}

SCP294Shared.methodList["heal"] = {
	name = "Heal",
	description = "Heal the player.",
	arguments = { 
		amount = { type = "number", min = 0, max = nil, default = 0, description = "How much hp the flavour will heal. ( min = 0 )" },
		maxHeal = { type = "number", min = 0, max = nil, default = 100, description = "Max health the flavour can heal. ( min = 0 )" },
		defaultHealth = { type = "boolean", default = false, description = "Use the max health value as the default max health of the player" }
	},
	side = "server",
	serverFunc = function( player, data )
		local maxHeal
		if ( data.defaultHealth ) then
			maxHeal = player:GetMaxHealth()
		else
			maxHeal = data.maxHeal
		end
		local clampValue = math.Clamp( player:Health() + data.amount, 0, maxHeal )
		if ( player:Health() < clampValue ) then
			player:SetHealth( clampValue )
		end
	end
}

SCP294Shared.methodList["motionBlur"] = {
	name = "Motion Blur",
	description = "Set accumulation motion blur post process.",
	arguments = { 
		addTransparency = { type = "number", min = 0, max = 1, default = 0.20, description = "How much alpha to change per frame. ( min = 0, max = 1 )" },
		drawTransparency = { type = "number", min = 0, max = 1, default = 0.8, description = "How much alpha the frames will have. A value of 0 will not render the motion blur effect. ( min = 0, max = 1 )" },
		frameCaptureDelay = { type = "number", min = 0, max = 1, default = 0.01, description = "Determines the amount of time between frames to capture. ( min = 0, max = 1 )" },
		time = { type = "number", min = 0, max = 999999, default = 5, description = "How much time the effect will stay. ( min = 0 )" }
	},
	side = "client",
	clientFunc = function( player, data )
		local ppDATA = {
			addTransparency = data.addTransparency,
			drawTransparency = data.drawTransparency,
			frameCaptureDelay = data.frameCaptureDelay
		}
		SCP294Client.addPostProcess( "DrawMotionBlur", ppDATA, data.time )
	end
}

SCP294Shared.methodList["drawSobel"] = {
	name = "Sobel",
	description = "Set the Sobel post process.",
	arguments = { 
		threshold = { type = "number", min = 0, max = 2, default = 0.5, description = "Determines the threshold of edges. A value of 0 will make your screen completely black. ( min = 0, max = 2 )" },
		time = { type = "number", min = 0, max = 99999, default = 5, description = "How much time the effect will stay ( min = 0 )" }
		},
	side = "client",
	clientFunc = function( player, data )
		local ppDATA = { threshold = data.threshold	} 
		SCP294Client.addPostProcess( "DrawSobel", ppDATA, data.time )
	end
}

SCP294Shared.methodList["drawColorModify"] = {
	name = "Color Modification",
	description = "Draws the Color Modify shader, which can be used to adjust colors on screen.",
	arguments = { 
		pp_colour_brightness = { type = "number", min = -2, max = 2, default = 0, description = "This value will be added to every pixel's R, G, and B values. 0 means no change. ( min = -2, max = 2 )" },
		pp_colour_contrast = { type = "number", min = 0, max = 10, default = 1, description = "The saturation value. Setting this to 0 will turn the image to grey-scale. 1 means no change. ( min = 0, max = 10 )" },
		pp_colour_colour = { type = "number", min = 0, max = 10, default = 1, description = "Every pixel's R, G, and B values will each be multiplied by this number. 1 means no change. ( min = 0, max = 10 )" },
		pp_addColor = { type = "color", default = Color( 0, 0, 0 ), description = "The multiply color value." },
		pp_mulColor = { type = "color", default = Color( 0, 0, 0 ), description = "The add color value." },
		time = { type = "number", min = 0, max = 99999, default = 5, description = "How much time the effect will stay. ( min = 0 )" }
		},
	side = "client",
	clientFunc = function( player, data )
		local ppDATA = { 
			["$pp_colour_addr"] = data.pp_addColor.r/255,
			["$pp_colour_addg"] = data.pp_addColor.g/255,
			["$pp_colour_addb"] = data.pp_addColor.b/255,
			["$pp_colour_brightness"] = data.pp_colour_brightness,
			["$pp_colour_contrast"] = data.pp_colour_contrast,
			["$pp_colour_colour"] = data.pp_colour_colour,
			["$pp_colour_mulr"] = data.pp_mulColor.r/255,
			["$pp_colour_mulg"] = data.pp_mulColor.g/255,
			["$pp_colour_mulb"] = data.pp_mulColor.b/255		
		} 
		SCP294Client.addPostProcess( "DrawColorModify", ppDATA, data.time )
	end
}

SCP294Shared.methodList["setModel"] = {
	name = "Set World Model",
	description = "Set the world model of the player.",
	arguments = { 
		modelPath = { type = "string", description = "The '####.mdl' path you want to apply to the player" }
		},
	side = "server",
	serverFunc = function( player, data )
		player:SetModel( data.modelPath )
	end
}

SCP294Shared.methodList["flashScreen"] = {
	name = "Flash The Screen",
	description = "Flash the screen of the player.",
	arguments = { 
		flashColor = { type = "color", description = "Color of the flash" },
		time = { type = "number", min = 0, default = 1, description = "How much time the effect will stay ( min = 0 )" }
		},
	side = "client",
	clientFunc = function( player, data )
		SCP294Client.addFlash( data.flashColor, data.time )
	end
}

SCP294Shared.methodList["ignite"] = {
	name = "Ignite",
	description = "This player is ON FIIIIIRE",
	arguments = { 
		duration = { type = "number", min = 0, max = 9999, default = 5, description = "How long to keep the entity ignited. ( min = 0, max = 9999 )" },
		radius = { type = "number", min = 0, max = 1500, default = 0, description = "The radius of the ignition, will ignite everything around the entity that is in this radius. ( min = 0, max = 9999 )" }
		},
	side = "server",
	serverFunc = function( player, data )
		player:Ignite( data.duration, data.radius )
	end
}

SCP294Shared.methodList["killAfterTime"] = {
	name = "Kill After Time",
	description = "Kill the player after given time.",
	arguments = { 
		time = { type = "number", min = 0, max = 9999, default = 10, description = "When does the player die in sec" }
		},
	side = "server",
	serverFunc = function( player, data )
		local timeFunc = function()
			if ( player:Alive() ) then
				player:Kill()
			end
		end
		SCP294Server.createTimer( player, "killAfterTime", data.time, 1, false, timeFunc )
	end
}

SCP294Shared.methodList["healOverTime"] = {
    name = "Heal over time",
    description = "Heal the player over time.",
    arguments = { 
        healAmount = { type = "number", min = 0, max = nil, default = 0, description = "How much hp this drink will heal. ( min = 0 )" },
        maxHeal = { type = "number", min = 0, max = nil, default = 100, description = "Max health that drink can heal. ( min = 0 )" },
        countAmount = { type = "number", min = 1, max = 9999, default = false, description = "How many times it heals. ( min = 1, max = 9999 )" },
        intervalTime = { type = "number", min = 0.1, max = 9999, default = false, description = "Interval time between heals. ( min = 0.1 )" },
        defaultHealth = { type = "boolean", default = false, description = "Use the max health value as the default max health of the player" }
    },
    side = "server",
    serverFunc = function(player, data)
        local timeFunc = function()
            if not IsValid(player) then return end

            local maxHeal
            if data.defaultHealth then
                maxHeal = player:GetMaxHealth()
            else
                maxHeal = data.maxHeal
            end
            local clampValue = math.Clamp(player:Health() + data.healAmount, 0, maxHeal)
            if player:Health() < clampValue then
                player:SetHealth(clampValue)
            end
        end
        SCP294Server.createTimer(player, "healOverTime", data.intervalTime, data.countAmount, true, timeFunc)
    end
}

SCP294Shared.methodList["headMovement"] = {
	name = "Head Movement",
	description = "Make the view of the player shake.",
	arguments = { 
		speed = { type = "number", min = 0.1, max = 360, default = 1, description = "The speed of the movement. ( min = 0.1, max = 360 )" },
		intensity = { type = "number", min = 0, max = 360, default = 6, description = "Intensity of the movement. ( min = 0, max = 360 )" },
		time = { type = "number", min = 1, max = 9999, default = false, description = "How much time the effect will stay. ( min = 0 )" }
	},
	side = "client",
	clientFunc = function( player, data )
		SCP294Client.addHeadMovement( data.speed, data.intensity, data.time )
	end
}

SCP294Shared.methodList["explosion"] = {
	name = "Explosion",
	description = "Make the player explode.",
	arguments = { 
		damage = { type = "number", min = 0, max = 99999, default = 50, description = "Damage of the explosion ( min = 0 )" },
		radius = { type = "number", min = 0, max = 99999, default = 100, description = "Radius of the explosion ( min = 0 )" },
		soundExplosion = { type = "string", default = "BaseExplosionEffect.Sound", description = "Sound of the explosion ( change it only if you know how sound path work )" }
	},
	side = "server",
	serverFunc = function( player, data )
		local explode = ents.Create( "env_explosion" )
		explode:SetPos( player:GetPos() )
		explode:Spawn()
		explode:SetKeyValue( "iMagnitude", data.damage )
		explode:SetKeyValue( "iRadiusOverride", data.radius )
		explode:Fire( "Explode", 0, 0 )
		explode:EmitSound( data.soundExplosion, 400, 400 )
	end
}

SCP294Shared.methodList["killSilent"] = {
	name = "Kill Silent",
	description = "Kill the player ( silent mode ).",
	arguments = {},
	side = "server",
	serverFunc = function( player, data )
		player:KillSilent()
	end
}

SCP294Shared.methodList["bleed"] = {
	name = "Bleed",
	description = "Make the player bleed.",
	arguments = {
		damage = { type = "number", min = 0, default = 15, description = "Damage of the bleeding" },
		interval = { type = "number", min = 0, default = 2, description = "Interval in sec" },
		amount = { type = "number", min = -1, default = 5, description = "How many time the player is gonna bleed ( min = -1 ) ( INFO : -1 = infinite bleeding )" }
	},
	side = "server",
	serverFunc = function( player, data )
		local timeFunc = function()
			player:TakeDamage( data.damage, player, player )
			util.Decal( "Blood", player:GetPos() + Vector( 0, 0, 15 ),  player:GetPos() + Vector( 0, 0, -50 ), player )
			player:EmitSound( "scp_294_redux/bleed/bleed_"..math.random(1,3)..".wav" )
		end
		SCP294Server.createTimer( player, "bleed", data.interval, data.amount, true, timeFunc )
	end
}

SCP294Shared.methodList["toyTown"] = {
	name = "Toy Town",
	description = "Draws the toy town shader, which blurs the top and bottom of your screen.",
	arguments = {
		passes = { type = "number", min = 0, max = 100, default = 10, description = "An integer determining how many times to draw the effect. A higher number creates more blur. ( min = 0, max = 100 )" },
		heightSize = { type = "number", min = 0, max = 100, default = 50, description = "The amount of screen which should be blurred on the top and bottom. ( min = 0, max = 100 )" },
		time = { type = "number", min = 0, max = 100, default = 10, description = "How much time the effect will stay. ( min = 0 )" }
	},
	side = "client",
	clientFunc = function( player, data )
		local ppDATA = {
			passes = data.passes,
			height = data.heightSize
		}
		
		SCP294Client.addPostProcess( "DrawToyTown", ppDATA, data.time )
	end
}

SCP294Shared.methodList["sharpen"] = {
	name = "Sharpen",
	description = "Draws the sharpen shader, which creates more contrast.",
	arguments = {
		contrast = { type = "number", min = 0, max = 20, default = 5, description = "How much contrast to create. ( min = 0, max = 20 )" },
		distance = { type = "number", min = 0, max = 100, default = 1, description = "How large the contrast effect will be in percent ( 0 - 100 %). ( min = 0, max = 100 )" },
		time = { type = "number", min = 0, max = 100, default = 10, description = "How much time the effect will stay. ( min = 0 )" }
	},
	side = "client",
	clientFunc = function( player, data )
		local ppDATA = {
			contrast = data.contrast,
			distance = data.distance
		}
		SCP294Client.addPostProcess( "DrawSharpen", ppDATA, data.time )
	end
}

SCP294Shared.methodList["setWalkSpeed"] = {
	name = "Walk Speed",
	description = "Sets the player's normal walking speed. Not sprinting.",
	arguments = {
		walkSpeed = { type = "number", min = 10, max = 9999, default = 120, description = "The new walk speed. ( min = 10, max = 9999 )" },
		time = { type = "number", min = 0, max = 9999, default = 10, description = "How much time the effect will stay. ( min = 0 )" }
	},
	side = "server",
	serverFunc = function( player, data )
		if not ( player.SCP294DefaultSpeed ) then
			player.SCP294DefaultSpeed = player:GetWalkSpeed()
		end
		local function timeFunc()
			if ( player.SCP294DefaultSpeed ) then
				player:SetWalkSpeed( player.SCP294DefaultSpeed )
				player.SCP294DefaultSpeed = nil
			end
		end
		player:SetWalkSpeed( data.walkSpeed )
		SCP294Server.createTimer( player, "setWalkSpeed", data.time, 1, true, timeFunc, true )
	end
}

SCP294Shared.methodList["setRunSpeed"] = {
	name = "Run Speed",
	description = "Sets the player's sprint speed.",
	arguments = {
		runSpeed = { type = "number", min = 10, max = 9999, default = 120, description = "The new sprint speed. ( min = 10, max = 9999 )" },
		time = { type = "number", min = 0, max = 9999, default = 10, description = "How much time the effect will stay. ( min = 0 )" }
	},
	side = "server",
	serverFunc = function( player, data )
		if not ( player.SCP294DefaultRunSpeed ) then
			player.SCP294DefaultRunSpeed = player:GetRunSpeed()
		end
		local function timeFunc()
			if ( player.SCP294DefaultRunSpeed ) then
				player:SetRunSpeed( player.SCP294DefaultRunSpeed )
				player.SCP294DefaultRunSpeed = nil
			end
		end
		player:SetRunSpeed( data.runSpeed )
		SCP294Server.createTimer( player, "setRunSpeed", data.time, 1, true, timeFunc, true )
	end
}

SCP294Shared.methodList["setColor"] = {
	name = "Set Color",
	description = "Sets the color of an player.",
	arguments = {
		color = { type = "color", description = "The color" },
		time = { type = "number", min = 0, default = 10, description = "How much time the effect will stay. ( min = 0 )" }
	},
	side = "server",
	serverFunc = function( player, data )
		if not ( player.SCP294DefaultColor ) then
			player.SCP294DefaultColor = player:GetColor()
		end
		local function timeFunc()
			if ( player.SCP294DefaultColor ) then
				player:SetColor( player.SCP294DefaultColor )
				player.SCP294DefaultColor = nil
			end
		end
		player:SetColor( data.color )
		SCP294Server.createTimer( player, "setColor", data.time, 1, true, timeFunc, true )
	end
}

SCP294Shared.methodList["takeDamage"] = {
	name = "Take Damage",
	description = "Applies the specified amount of damage to the player.",
	arguments = {
		damage = { type = "number", min = 0, default = 10, description = "Amount of damage" }
	},
	side = "server",
	serverFunc = function( player, data )
		player:TakeDamage( data.damage, player, player )
	end
}

SCP294Shared.methodList["takeDamageOverTime"] = {
	name = "Take Damage Over Time",
	description = "Applies the specified amount of damage to the player over time.",
	arguments = {
		damage = { type = "number", min = 0, default = 15, description = "Amount of damage" },
		interval = { type = "number", min = 0, default = 2, description = "Interval in sec" },
		amount = { type = "number", min = -1, default = 5, description = "How many time the player is gonna take damage ( min = -1 ) ( INFO : -1 = infinite damage )" }
	},
	side = "server",
	serverFunc = function( player, data )
		local timeFunc = function()
			player:TakeDamage( data.damage, player, player )
		end
		SCP294Server.createTimer( player, "takeDamageOverTime", data.interval, data.amount, true, timeFunc )
	end
}

SCP294Shared.methodList["godMode"] = {
	name = "God Mode",
	description = "Enable the god mode",
	arguments = {
		timer = { type = "number", min = 0, max = 99999, default = 60, description = "How much time the god mode stay" }
	},
	side = "server",
	serverFunc = function( player, data )
		local timeFunc = function()
			player:GodDisable()
		end
		player:GodEnable()

		SCP294Server.createTimer( player, "godMode", data.timer, 1, true, timeFunc, true )
	end
}

SCP294Shared.methodList["invisibility"] = {
	name = "Invisibility",
	description = "Make the player invisible",
	arguments = {
		alpha = { type = "number", min = 0, max = 255, default = 0, description = "The Alpha color" },
		timer = { type = "number", min = 0, default = 2, description = "How much time the invisibility stay" }
	},
	side = "server",
	serverFunc = function( player, data )
		if not ( player.SCP294RenderMode ) then
			player.SCP294DefaultSpeed = player:GetRenderMode()
		end
		if not ( player.SCP294Color ) then
			player.SCP294Color = player:GetColor()
		end
		local timeFunc = function()
			if ( player.SCP294RenderMode ) then
				player:SetRenderMode( player.SCP294RenderMode )
				player.SCP294RenderMode = nil
			end
			if ( player.SCP294Color ) then
				player:SetColor( player.SCP294Color )
				player.SCP294Color = nil
			end
		end
		player:SetRenderMode( RENDERMODE_TRANSALPHA )
		local col = player:GetColor()
		col.a = data.alpha
		player:SetColor( col )
		SCP294Server.createTimer( player, "invisibility", data.timer, 1, true, timeFunc, true )
	end
}

SCP294Shared.methodList["teleportCoordinates"] = {
	name = "Teleport To Coordinates",
	description = "Make the player teleport to a location in the specified maps.",
	arguments = {
		positionAndMap = { type = "string", default = "", description = "The X Y Z coordinates of the maps that should be teleported to. ( Separate with ; e.g. 0 0 0,gm_construct;10 0 10,gm_flatgrass; )"},
		delay = { type = "number", min = 0, max = 9999, default = 0.6, description = "The delay in seconds after using the drink, until the teleportation starts."}
	},
	side = "server",
	serverFunc = function( player, data )
		local dataTeleport = string.Split(data.positionAndMap, ";")
		local dataTable = {}
		local currentMap = game.GetMap()
		local mapFound = false
		
		local teleportPos
		
		for k,v in pairs(dataTeleport) do
			table.insert(dataTable, string.Split(v, ","))
		end
		
		for k,v in pairs(dataTable) do
			local mapValue = string.gsub(v[2], "%s+", "") -- remove spaces from typed in mapname.
			if (currentMap == mapValue) then
				teleportPos = v[1]
				mapFound = true
				break
			end
		end
		
		-- When the map was found in the settings data.
		if (mapFound == true) then
			local timerOverFunc = function()
				player:SetPos(util.StringToType(teleportPos, "Vector"))
			end
			
			SCP294Server.createTimer( player, "teleportCoordinates", data.delay, 1, true, timerOverFunc)
		end
	end
}

SCP294Shared.methodListOrder = {
	"heal",
	"healOverTime",
	"ignite",
	"invisibility",
	"explosion",
	"bleed",
	"godMode",
	"takeDamage",
	"takeDamageOverTime",
	"kill",
	"killAfterTime",
	"killSilent",
	"setModel"
}

for key, value in pairs ( SCP294Shared.methodList ) do
	if not ( table.HasValue( SCP294Shared.methodListOrder, key ) ) then
		table.insert( SCP294Shared.methodListOrder, key )
	end
end


