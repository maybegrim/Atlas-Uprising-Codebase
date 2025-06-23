SCP294Client.postProcessCache = {}
SCP294Client.flashCache = {}
SCP294Client.notification = {}
SCP294Client.headMovement = nil

function SCP294Client.addPostProcess( ppName, data, time )
	SCP294Client.postProcessCache[ppName] = { 
		process = ppName,
		data = data,
		expireTime = CurTime() + time
	}
end

function SCP294Client.resetPostProcess()
	SCP294Client.postProcessCache = {}
end

function SCP294Client.addFlash( color, time )
	local flash = { col = color, time = time }
	flash.col.a = 255
	table.insert( SCP294Client.flashCache, flash )
end

function SCP294Client.addHeadMovement( speed, intensity, time )
	SCP294Client.headMovement = { 
		speed = speed,
		intensity = intensity,
		expire = CurTime() + time
	}
end

hook.Add( "CalcView", "SCP294RMyCalcView", function (ply, pos, angles, fov)
	if ( SCP294Client.headMovement ) then	
		local view = {}
		view.origin = pos
		view.angles = angles + Angle( 0, 0, math.cos( CurTime() * SCP294Client.headMovement.speed ) * SCP294Client.headMovement.intensity )
		view.fov = fov
		view.drawviewer = false
		if ( CurTime() > SCP294Client.headMovement.expire ) then
			SCP294Client.headMovement.intensity = SCP294Client.headMovement.intensity - ( 6 * RealFrameTime() )
			if ( SCP294Client.headMovement.intensity <= 0 ) then
				SCP294Client.headMovement = nil
			end
		end
		return view
	end
end )

local defaultColorModify =  {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 1,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}
 
hook.Add( "RenderScreenspaceEffects", "SCP294RRenderScreenspaceEffects", function()
	for k , v in pairs ( SCP294Client.postProcessCache ) do
	
		if ( v.process == "DrawMotionBlur" ) then
			-- Draw the motion blur
			DrawMotionBlur( v.data.addTransparency, v.data.drawTransparency, v.data.frameCaptureDelay )
			-- Check if the expireTime
			if ( CurTime() > v.expireTime ) then
				-- Substract drawTransparency by 0.5 * FrameTime
				SCP294Client.postProcessCache[k].data.drawTransparency = SCP294Client.postProcessCache[k].data.drawTransparency - ( 0.5 * RealFrameTime() )
				-- When the transparency is gone , remove the effect
				if ( v.data.drawTransparency <= 0 ) then
					SCP294Client.postProcessCache[k] = nil
				end
			end
		
		elseif ( v.process == "DrawSharpen" ) then
			DrawSharpen( v.data.contrast, v.data.distance )
			if ( CurTime() > v.expireTime ) then
				v.data.distance = math.Clamp( v.data.distance - ( 10 * RealFrameTime() ), 0, 100 )
				if ( v.data.distance <= 0 ) then
					SCP294Client.postProcessCache[k] = nil
				end				
			end
		elseif ( v.process == "DrawToyTown" ) then
			DrawToyTown( v.data.passes, ScrH() * ( v.data.height / 100 ) )
			
			if ( CurTime() > v.expireTime ) then
				v.data.height = math.Clamp( v.data.height - ( 35 * RealFrameTime() ), 0, 100 )
				if ( v.data.height <= 0 ) then
					SCP294Client.postProcessCache[k] = nil
				end				
			end			
		elseif ( v.process == "DrawColorModify" ) then
			DrawColorModify( v.data )
			-- Check if the expireTime
			if ( CurTime() > v.expireTime ) then
				local canExpire = true
				local rgb = { "r", "g", "b" }
				local operation = { "add", "mul" }
				local data = v.data
				
				
				for _, op in pairs ( operation ) do
					for __, col in pairs ( rgb ) do
						if ( data["$pp_colour_" .. op .. col] > 0 ) then
							if ( data["$pp_colour_" .. op .. col] > 0 ) then
								data["$pp_colour_" .. op .. col] = data["$pp_colour_" .. op .. col] - ( 0.5 * RealFrameTime() )
								canExpire = false
							end
						end
					end
				end
					
				if ( data["$pp_colour_contrast"] < 1 ) then
					data["$pp_colour_contrast"] = data["$pp_colour_contrast"] + ( 0.35 * RealFrameTime() )
					canExpire = false
					if ( data["$pp_colour_contrast"] > 0.9 ) then
						data["$pp_colour_contrast"] = 1
					end
				elseif ( data["$pp_colour_contrast"] > 1 ) then
					data["$pp_colour_contrast"] = data["$pp_colour_contrast"] - ( 0.35 * RealFrameTime() )
					canExpire = false
					if ( data["$pp_colour_contrast"] < 1.2 ) then
						data["$pp_colour_contrast"] = 1
					end
				end
				
				if ( data["$pp_colour_colour"] < 1 ) then
					data["$pp_colour_colour"] = data["$pp_colour_colour"] + ( 0.35 * RealFrameTime() )
					canExpire = false
					if ( data["$pp_colour_colour"] > 0.9 ) then
						data["$pp_colour_colour"] = 1
					end
				elseif ( data["$pp_colour_colour"] > 1 ) then
					data["$pp_colour_colour"] = data["$pp_colour_colour"] - ( 0.35 * RealFrameTime() )
					canExpire = false
					if ( data["$pp_colour_colour"] < 1.2 ) then
						data["$pp_colour_colour"] = 1
					end
				end
				
				if ( canExpire ) then
					SCP294Client.postProcessCache[k] = nil
				end
			end
			
		elseif ( v.process == "DrawSobel" ) then
			DrawSobel( v.data.threshold )
			-- Check if the expireTime
			if ( CurTime() > v.expireTime ) then
				-- Substract threshold by 0.5 * FrameTime
				SCP294Client.postProcessCache[k].data.threshold = SCP294Client.postProcessCache[k].data.threshold + ( 2 * RealFrameTime() )
				-- When the sobel is 'gone' , remove the effect
				if ( SCP294Client.postProcessCache[k].data.threshold > 8 ) then
					SCP294Client.postProcessCache[k] = nil
				end
			end		
		end
		
	end
end )

function SCP294Client.addNotification( txt )
	if not ( GetConVar( "scp294_debugHUD" ):GetString() == "1" ) then return end
	local data = {
		text = txt,
		pos = { x = -250, y = 0 },
		step = 1,
		timeLeft = 2
	}
	table.insert( SCP294Client.notification, data )
end
 

hook.Add( "HUDPaint", "SCP294RHUD", function( )
	for k, flash in pairs ( SCP294Client.flashCache ) do
		local subRatio = ( 255/flash.time )
		flash.col.a = math.Clamp( flash.col.a - ( subRatio * RealFrameTime() ), 0, 255 )
		surface.SetDrawColor( flash.col.r, flash.col.g, flash.col.b, flash.col.a )
		surface.DrawRect( 0, 0, ScrW(), ScrH() )
	end
end )

hook.Add( "HUDPaint", "SCP294RHUDDebug", function()
	if not ( GetConVar( "scp294_debugHUD" ):GetString() == "1" ) then return end
	surface.SetDrawColor( 0, 0, 0, 180 )
	surface.DrawRect( 0, 0, 300, 270 )
	
	if ( SCP294Client ) then
		draw.SimpleText( "SCP294Client ✓", "scpMenuFontLittle", 10, 10, Color( 0, 255, 0, 255 ) )
		if ( SCP294Client.drinkDATA ) then
			draw.SimpleText( "drinkDATA ✓", "scpMenuFontLittle", 10, 30, Color( 0, 255, 0, 255 ) )
			draw.SimpleText( "	> Size : " .. table.Count( SCP294Client.drinkDATA ), "scpMenuFontLittle", 10, 50, Color( 255, 255, 255, 255 ) )
		else
			draw.SimpleText( "drinkDATA ✗", "scpMenuFontLittle", 10, 30, Color( 255, 0, 0, 255 ) )
		end
		if ( SCP294Client.downloadInfo ) then
			draw.SimpleText( "downloadInfo ✓", "scpMenuFontLittle", 10, 70, Color( 0, 255, 0, 255 ) )
			draw.SimpleText( "	> LastSignal : " .. CurTime() - SCP294Client.lastDownload, "scpMenuFontLittle", 10, 90, Color( 255, 255, 255, 255 ) )
		else
			draw.SimpleText( "downloadInfo ✗", "scpMenuFontLittle", 10, 70, Color( 255, 0, 0, 255 ) )
		end
		if ( SCP294Client.usedEntity ) then
			draw.SimpleText( "used Entity ✓", "scpMenuFontLittle", 10, 110, Color( 0, 255, 0, 255 ) )
			draw.SimpleText( "	> Entity : " .. tostring( SCP294Client.usedEntity ), "scpMenuFontLittle", 10, 130, Color( 255, 255, 255, 255 ) )
		else
			draw.SimpleText( "used Entity ✗", "scpMenuFontLittle", 10, 110, Color( 255, 0, 0, 255 ) )
		end	
		if ( SCP294Client.keyboardFrame ) then
			draw.SimpleText( "keyboardFrame ✓", "scpMenuFontLittle", 10, 150, Color( 0, 255, 0, 255 ) )
			draw.SimpleText( "	> Frame : " .. tostring( SCP294Client.keyboardFrame ), "scpMenuFontLittle", 10, 170, Color( 255, 255, 255, 255 ) )
		else
			draw.SimpleText( "keyboardFrame ✗", "scpMenuFontLittle", 10, 150, Color( 255, 0, 0, 255 ) )
		end
		if ( SCP294Client.haveMaterials ) then
			draw.SimpleText( "haveMaterials ✓", "scpMenuFontLittle", 10, 190, Color( 0, 255, 0, 255 ) )
		else
			draw.SimpleText( "haveMaterials ✗", "scpMenuFontLittle", 10, 190, Color( 255, 0, 0, 255 ) )
		end		
		if ( SCP294Client.postProcessCache ) then
			draw.SimpleText( "postProcessCache ✓", "scpMenuFontLittle", 10, 210, Color( 0, 255, 0, 255 ) )
			draw.SimpleText( "	> Size : " .. tostring( table.Count( SCP294Client.postProcessCache ) ), "scpMenuFontLittle", 10, 230, Color( 255, 255, 255, 255 ) )
		else
			draw.SimpleText( "postProcessCache ✗", "scpMenuFontLittle", 10, 210, Color( 255, 0, 0, 255 ) )
		end
		if ( SCP294Client.headMovement ) then
			draw.SimpleText( "headMovement ✓", "scpMenuFontLittle", 10, 250, Color( 0, 255, 0, 255 ) )
		else
			draw.SimpleText( "headMovement ✗", "scpMenuFontLittle", 10, 250, Color( 255, 0, 0, 255 ) )
		end
	end
	
	local posY = 290
	for k , v in pairs ( SCP294Client.notification ) do
		v.timeLeft = v.timeLeft - RealFrameTime()
		if ( v.step == 1 ) then
			if ( v.pos.x < 0 ) then
				v.pos.x = math.Clamp( v.pos.x + ( 500 * RealFrameTime() ), -300, 0 )
			end
			if ( v.timeLeft < 0 ) then
				v.timeLeft = 5
				v.step = 2
			end
		elseif ( v.step == 2 ) then
			if ( v.timeLeft < 0 ) then
				v.timeLeft = 5
				v.step = 3
			end
		elseif ( v.step == 3 ) then
			if ( v.pos.x > -300 ) then
				v.pos.x = v.pos.x - ( 250 * RealFrameTime() )
			else
				SCP294Client.notification[k] = nil
			end
		end
		surface.SetDrawColor( 0, 0, 0, 150 )
		surface.DrawRect( v.pos.x, posY , 300, 25 )
		draw.SimpleText( v.text, "scpMenuFontLittle", v.pos.x + 15, posY + 13, Color( 255, 255, 255, 255 ), 0, 1 )
		posY = posY + 30
	end
	
end )


 
 