surface.CreateFont("MonoNotification20", {
	font = "Monofonto", 
	extended = false,
	size = 20,
	weight = 500,
} )

local ScreenPos = ScrH() - 200
local sw, sh = ScrW(), ScrH()

local ForegroundColor = Color( 230, 230, 230 )
local BackgroundColor = Color( 0, 0, 0, 235 )

local mainCol = Color(255, 255, 255, 255)
local backCol = Color(255, 255, 255, 10)
local barBackCol = Color(50, 50, 50, 100)

local Colors = {}
Colors[ NOTIFY_GENERIC ] = Color( 52, 73, 94 )
Colors[ NOTIFY_ERROR ] = Color( 192, 57, 43 )
Colors[ NOTIFY_UNDO ] = Color( 41, 128, 185 )
Colors[ NOTIFY_HINT ] = Color( 39, 174, 96 )
Colors[ NOTIFY_CLEANUP ] = Color( 243, 156, 18 )

local LoadingColor = Color( 22, 160, 133 )

local Icons = {}
Icons[ NOTIFY_GENERIC ] = Material( "notifications/generic.png" )
Icons[ NOTIFY_ERROR ] = Material( "notifications/error.png" )
Icons[ NOTIFY_UNDO ] = Material( "notifications/undo.png" )
Icons[ NOTIFY_HINT ] = Material( "notifications/hint.png" )
Icons[ NOTIFY_CLEANUP ] = Material( "notifications/cleanup.png" )

local LoadingIcon = Material( "notifications/loading.png" )
local gradientRight = Material("vgui/gradient-r.png")

local Notifications = {}

local function DrawNotification( x, y, w, h, text, icon, col, progress )

	local mat = Matrix()

	mat:Translate(Vector(sw/2, sh/2))
	mat:Rotate(Angle(0,1,0))
	mat:Scale(Vector(1,1,1))
	mat:Translate(-Vector(sw/2, sh/2))

	cam.PushModelMatrix(mat)

		surface.SetMaterial(gradientRight)
		surface.SetDrawColor(Color(255, 255, 255, 15))
		surface.DrawTexturedRect(x, y, w, h)

		if progress then
			draw.RoundedBox( 0, x + w - h, y, h + ( w - h ) * progress, h, col)
		else
			draw.RoundedBox( 0, x + w - h, y, h, h, col)
		end

		draw.SimpleText( text, "MonoNotification20", x + w - h - 10 + 5, y + h / 2 - 5, backCol,
		TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

		draw.SimpleText( text, "MonoNotification20", x + w - h - 10, y + h / 2, mainCol,
			TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )

		surface.SetDrawColor( ForegroundColor )
		surface.SetMaterial( icon )

		if progress then
			surface.DrawTexturedRectRotated( x + w - h + 16, y + h / 2, 16, 16, -CurTime() * 360 % 360 )
		else
			surface.DrawTexturedRect( x + w - h + 8, y + 8, 16, 16 )
		end

	cam.PopModelMatrix()
end

function notification.AddLegacy( text, type, time )
	surface.SetFont( "MonoNotification20" )

	local w = surface.GetTextSize( text ) + 20 + 32
	local h = 32
	local x = ScrW()
	local y = ScreenPos

	table.insert( Notifications, 1, {
		x = x,
		y = y,
		w = w,
		h = h,

		text = text,
		col = Colors[ type ],
		icon = Icons[ type ],
		time = CurTime() + time,

		progress = nil,
	} )
end

function notification.AddProgress( id, text, frac )
	for k, v in ipairs( Notifications ) do
		if v.id == id then
			v.text = text
			v.progress = frac
			
			return
		end
	end

	surface.SetFont( "MonoNotification20" )

	local w = surface.GetTextSize( text ) + 20 + 32 * 2
	local h = 32
	local x = ScrW()
	local y = ScreenPos

	table.insert( Notifications, 1, {
		x = x,
		y = y,
		w = w,
		h = h,

		id = id,
		text = text,
		col = LoadingColor,
		icon = LoadingIcon,
		time = math.huge,

		progress = math.Clamp( frac or 0, 0, 1 ),
	} )	
end

function notification.Kill( id )
	for k, v in ipairs( Notifications ) do
		if v.id == id then v.time = 0 end
	end
end

hook.Add( "HUDPaint", "DrawNotifications", function()
	for k, v in ipairs( Notifications ) do
		DrawNotification( math.floor( v.x ), math.floor( v.y ), v.w, v.h, v.text, v.icon, v.col, v.progress )

		v.x = Lerp( FrameTime() * 10, v.x, v.time > CurTime() and ScrW() - v.w - 10 or ScrW() + 1 )
		v.y = Lerp( FrameTime() * 10, v.y, ScreenPos - ( k - 1 ) * ( v.h + 5 ) )
	end

	for k, v in ipairs( Notifications ) do
		if v.x >= ScrW() and v.time < CurTime() then
			table.remove( Notifications, k )
		end
	end
end )

concommand.Add("addTestNotifications", function()
	for k, v in pairs(Colors) do
		notification.AddLegacy( "This is a " .. k .. " notification", k, 10 )
	end
end)