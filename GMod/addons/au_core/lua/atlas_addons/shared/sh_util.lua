--[[
	This file has been copyrighted by Atlas Uprising.
	Do not distribute or copy any files.
]]--

AtlasAddons.Util = AtlasAddons.Util or {}

function AtlasAddons.Util:RandomString( intMin, intMax )
	local s = ""

	if intMax then
		for i = 1, math.random( intMin, intMax ) do
			s = s.. string.char( math.random(48, 126) )
		end
	else
		for i = 1, intMin do
			s = s.. string.char( math.random(48, 126) )
		end
	end

	return s
end

function AtlasAddons.Util:WeightedRandom( m_tblChoices, m_tblWeights )
	math.randomseed(os.time())
	local totalWeight = 0
	for _, weight in pairs(m_tblWeights) do
	    totalWeight = totalWeight + weight
	end

	rand = math.random() * totalWeight
	local choice = nil

	for i, weight in pairs(m_tblWeights) do
	    if rand < weight then
	        choice = m_tblChoices[i]
	        break
	    else
	        rand = rand - weight
	    end
	end

	return choice
end

function AtlasAddons.Util:FYShuffle( m_tblInput )
	math.randomseed(os.time())
    local m_tblReturn = {}
    for i = #m_tblInput, 1, -1 do
        local j = math.random(i)
        m_tblInput[i], m_tblInput[j] = m_tblInput[j], m_tblInput[i]
        table.insert(m_tblReturn, m_tblInput[i])
    end
    return m_tblReturn
end

function AtlasAddons.Util:VectorInRange( vecCheck, vecMin, vecMax )
	if not vecCheck or not vecMin or not vecMax then return end

	local bOutBounds = false
	if vecCheck.x >= vecMin.x and vecCheck.x <= vecMax.x then else
		bOutBounds = true
	end

	if vecCheck.y >= vecMin.y and vecCheck.y <= vecMax.y then else
		bOutBounds = true
	end

	if vecCheck.z >= vecMin.z and vecCheck.z <= vecMax.z then else
		bOutBounds = true
	end

	return not bOutBounds
end

function AtlasAddons.Util:VectorInRangeSet( vecCheck, tblMinMax )
	for k, v in pairs( tblMinMax ) do
		if self:VectorInRange( vecCheck, v.Min, v.Max ) then
			return true
		end
	end

	return false
end

function AtlasAddons.Util:InsidePolygon(polygon, point)
	local oddNodes = false
	local j = #polygon
	for i = 1, #polygon do
		if (polygon[i].y < point.y and polygon[j].y >= point.y or polygon[j].y < point.y and polygon[i].y >= point.y) then
			if (polygon[i].x + ( point.y - polygon[i].y ) / (polygon[j].y - polygon[i].y) * (polygon[j].x - polygon[i].x) < point.x) then
				oddNodes = not oddNodes
			end
		end
		j = i
	end
	return oddNodes and point.z >= polygon.minZ and point.z <= polygon.maxZ
end

function AtlasAddons.Util:AngleInRange( angCheck, angMin, angMax )
	if not angCheck or not angMin or not angMax then return end

	local bOutBounds = false
	if angCheck.p >= angMin.p and angCheck.p <= angMax.p then else
		bOutBounds = true
	end

	if angCheck.y >= angMin.y and angCheck.y <= angMax.y then else
		bOutBounds = true
	end

	if angCheck.r >= angMin.r and angCheck.r <= angMax.r then else
		bOutBounds = true
	end

	return not bOutBounds
end

function AtlasAddons.Util:CartesianToSpherical( vecFrom )
	local rho = math.sqrt( vecFrom.x^2 +vecFrom.y^2 +vecFrom.z^2 )
	local theta = math.acos( vecFrom.z /rho )
	local phi = math.atan2( vecFrom.y, vecFrom.x )
	return rho, theta, phi
end

function AtlasAddons.Util:SphericalToCartesian( intRho, intTheta, intPhi )
	return Vector(
		intRho *math.sin(intTheta) *math.cos(intPhi),
		intRho *math.sin(intTheta) *math.sin(intPhi),
		intRho *math.cos(intTheta)
	)
end

function AtlasAddons.Util:ColorToByte( col )
	return bit.bor(
		bit.lshift( col.r, 16 ),
		bit.lshift( col.g, 8 ),
		col.b,
		bit.lshift( col.a, 24 )
	)
end

function AtlasAddons.Util:ByteToColor( int )
	return Color(
		bit.band( bit.rshift(int, 16), 0xff ),
		bit.band( bit.rshift(int, 8), 0xff ),
		bit.band( int, 0xff ),
		bit.band( bit.rshift(int, 24), 0xff )
	)
end

function AtlasAddons.Util:EnumToKey( intKeyEnum, intOffset, bChar )
	intKeyEnum = intKeyEnum -intOffset
	if bChar then
		intKeyEnum = string.char( intOffset +intKeyEnum )
	end
	return intKeyEnum
end

function AtlasAddons.Util:FormatTime( intTime, bHours )
	local time = os.date( "!*t", intTime ) or { min = 0, sec = 0 }
	if time.sec < 10 then
		time.sec = "0".. time.sec
	end

	if not bHours then
		return ("%s:%s"):format( time.min, time.sec )
	else
		if time.min < 10 then
			time.min = "0".. time.min
		end
		return ("%s:%s:%s"):format( time.hour +(time.day >1 and (time.day-1) *24 or 0), time.min, time.sec )
	end
end

function AtlasAddons.Util:TimeToString( x )
	local r, years, months, weeks, days, hours, minutes, seconds
	r = x % 31536000
	years = ( x - r ) / 31536000
	r = x % 2628000
	months = ( x - r ) / 2628000
	r = x % 604800
	weeks = ( x - r ) / 604800
	r = x % 86400
	days = ( x - r ) / 86400
	r = x % 3600
	hours = ( x - r ) / 3600
	r = x % 60
	minutes = ( x - r ) / 60
	seconds = r

	if years > 0 then 	return years 	.. " Year"		.. ( years ~= 1 and "s" or "" ) end
	if months > 0 then 	return months 	.. " Month" 	.. ( months ~= 1 and "s" or "" ) end
	if weeks > 0 then 	return weeks 	.. " Week" 		.. ( weeks ~= 1 and "s" or "" ) end
	if days > 0 then 	return days 	.. " Day" 		.. ( days ~= 1 and "s" or "" ) end
	if hours > 0 then 	return hours 	.. " Hour" 		.. ( hours ~= 1 and "s" or "" ) end
	if minutes > 0 then return minutes 	.. " Minute" 	.. ( minutes ~= 1 and "s" or "" ) end
	if seconds > 0 then return seconds 	.. " Second" 	.. ( seconds ~= 1 and "s" or "" ) end

	return "0 Seconds"
end

function AtlasAddons.Util:ValidPlayerSkin( strModel, intSkin )
	local model = GAMEMODE.Config.BlockedModelSkins[strModel]
	if not model then return true end
	if table.HasValue( model, intSkin ) then return false end
	return true
end

function AtlasAddons.Util:FaceMatchPlayerModel( strModel, bIsMale, tblLookForMatch )
	local valid, matchedTo = false, strModel

	for k, v in pairs( tblLookForMatch[bIsMale and "Male" or "Female"] ) do
		if strModel:find( k ) then
			valid = true
			matchedTo = v

			break
		end
	end

	return valid, matchedTo
end

function AtlasAddons.Util:GetModelFaceID( strModel )
	strModel = strModel:lower()
	local id = strModel:match( "female_[0-9][0-9]" )
	if not id then id = strModel:match( "male_[0-9][0-9]" ) end
	return id
end

-- todo improve this.
function AtlasAddons.Util:FindSpawnPoint( tblSpawns, intRad, pPlayer )
	if pPlayer then
		local possibleLocations = {}

		for k, v in pairs( tblSpawns ) do
			local canPlaceHere = true

			for _, ent in pairs( ents.FindInSphere( v[1], intRad ) ) do
				if not self.m_tblIgnoreSpawnEnts[ent:GetClass()] then
					if ent:GetClass() == "prop_dynamic" and not ent.IsItem then continue end
					canPlaceHere = nil
					break
				end
			end

			if canPlaceHere then
				table.insert( possibleLocations, v )
			end
		end

		if possibleLocations == 0 then return end

		local closestLocation
		local closestDist = math.huge

		for _, v in pairs( possibleLocations ) do
			local dist = v[1]:DistToSqr( pPlayer:GetPos() )

			if dist < closestDist then
				closestLocation = v
				closestDist = dist
			end
		end

		if not closestLocation then return end

		return closestLocation[1], closestLocation[2]
	else
		for k, v in pairs( tblSpawns ) do
			local found = ents.FindInSphere( v[1], intRad )

			for idx, ent in pairs( found ) do
				if self.m_tblIgnoreSpawnEnts[ent:GetClass()] then
					found[idx] = nil
				end
			end

			if table.Count( found ) == 0 then return v[1], v[2] end
		end
	end
end

do
	local mins, maxs = Vector( -18, -18, 0 ), Vector( 18, 18, 74 )

	function AtlasAddons.Util:IsPointEmpty( vecPos, tblIgnore )
		if not util.IsInWorld( vecPos ) then return false end
		local point = util.PointContents( vecPos )
		local a = point ~= CONTENTS_SOLID
			and point ~= CONTENTS_MOVEABLE
			and point ~= CONTENTS_LADDER
			and point ~= CONTENTS_PLAYERCLIP
			and point ~= CONTENTS_MONSTERCLIP

		if tblIgnore then
			local b = true
			for k, v in pairs( ents.FindInSphere(vecPos, 35) ) do
				if v:IsNPC() or v:IsPlayer() or v:IsVehicle() or v:GetClass() == "prop_physics" and not table.HasValue( tblIgnore, v ) then
					b = false
					break
				end
			end

			return a and b
		else
			return a
		end
	end

	function AtlasAddons.Util:MinMaxsStuck( vecPos, minBound, maxBound )
		if not self:IsPointEmpty( Vector(vecPos.x +minBound.x, vecPos.y +minBound.y, vecPos.z +minBound.z) ) then return true end
		if not self:IsPointEmpty( Vector(vecPos.x -minBound.x, vecPos.y +minBound.y, vecPos.z +minBound.z) ) then return true end
		if not self:IsPointEmpty( Vector(vecPos.x -minBound.x, vecPos.y -minBound.y, vecPos.z +minBound.z) ) then return true end
		if not self:IsPointEmpty( Vector(vecPos.x +minBound.x, vecPos.y -minBound.y, vecPos.z +minBound.z) ) then return true end

		if not self:IsPointEmpty( Vector(vecPos.x +maxBound.x, vecPos.y +maxBound.y, vecPos.z +maxBound.z) ) then return true end
		if not self:IsPointEmpty( Vector(vecPos.x -maxBound.x, vecPos.y +maxBound.y, vecPos.z +maxBound.z) ) then return true end
		if not self:IsPointEmpty( Vector(vecPos.x -maxBound.x, vecPos.y -maxBound.y, vecPos.z +maxBound.z) ) then return true end
		if not self:IsPointEmpty( Vector(vecPos.x +maxBound.x, vecPos.y -maxBound.y, vecPos.z +maxBound.z) ) then return true end

		return false
	end

	function AtlasAddons.Util:UnstuckPlayer( pPlayer, minDist )
		local curDist = minDist or 8
		local distance, maxIter = curDist, 48
		local count, newVec, tr, min, max

		while distance < 256 do
			count = maxIter

			while count > 0 do
				count = count -1
				newVec = pPlayer:GetPos() -Vector(
					math.Rand( -distance, distance ),
					math.Rand( -distance, distance ),
					math.Rand( -distance, distance )
				)

				if not util.TraceHull{
					start = newVec,
					endpos = newVec,
					filter = pPlayer,
					mins = mins,
					maxs = maxs
				}.StartSolid then
					min, max = pPlayer:GetCollisionBounds()
					if self:MinMaxsStuck( pPlayer:GetPos(), min, max ) then
						if self:MinMaxsStuck( pPlayer:GetPos(), mins, maxs ) then
							return true
						end
					end

					tr = util.TraceLine{
						start = newVec,
						endpos = newVec +Vector( 0, 0, 72 ),
						filter = pPlayer,
					}
					if not tr.HitWorld and not tr.StartSolid then
						pPlayer:SetPos( newVec )
						return true
					end
				end
			end

			distance = distance +curDist
		end

		return false
	end
end

function AtlasAddons.Util:DefinePolynomialCurveScalar( intF, intA, intB, intC, intD )
	return function( intX )
		return intA *intX ^4 +intB *intX ^3 + intC *intX ^2 + intD *intX +intF
	end
end

--Took a while to get the right algorithm for this..
--By The Maw
do
	local insert = table.insert
	local t, Ab, Points, Step, Point1_for, Point2_for, i

	function AtlasAddons.Util:BezierCurve( Point1, Ang1, Point2, Ang2, size, iter )
		local Points 	= {}
		local Step 		= 1 /iter
		local Point1_for = Point1 +Ang1:Forward() *size
		local Point2_for = Point2 +Ang2:Forward() *size

		for i = 0, iter do
			t = Step *i
			Ab = 1 -t
			insert( Points, Ab ^3 *Point1 +3 *Ab ^2 *t *Point1_for +3 *Ab *t ^2 *Point2_for +t ^3 *Point2 )
		end

		return Points
	end
end

if CLIENT then
	local tan = math.tan
	local rad = math.rad
	local MPos = mesh.Position
	local MNor = mesh.Normal
	local MAdv = mesh.AdvanceVertex

	local Step, BSiz, BHeight, LastAng
	local NextCurve, Ang, Ang2, Rig, Rig2, i
	function AtlasAddons.Util:CurveToMesh( Curve, Size, iter )
		Step = 360 /iter
		BSiz = tan( rad(Step /4) ) *Size
		BHeight = BSiz /iter *4
		LastAng = nil

		mesh.Begin( MATERIAL_QUADS, (#Curve -1) *iter )
			for k, v in pairs( Curve ) do
				NextCurve = Curve[k +1]

				if NextCurve then
					Ang = (NextCurve -v):Angle()
					Ang2 = LastAng or Ang *1

					for i = 1, iter do
						Rig = Ang:Right()
						Rig2 = Ang2:Right()

						MPos( v +Rig2 *BSiz )
						MNor( Rig2 )
						MAdv()

						MPos( NextCurve +Rig *BSiz )
						MNor( Rig )
						MAdv()

						Ang:RotateAroundAxis( Ang:Forward(), Step )
						Ang2:RotateAroundAxis( Ang2:Forward(), Step )

						Rig = Ang:Right()
						Rig2 = Ang2:Right()

						MPos( NextCurve +Rig *BSiz )
						MNor( Rig )
						MAdv()

						MPos( v +Rig2 *BSiz )
						MNor( Rig2 )
						MAdv()
					end

					LastAng = Ang
				end
			end
		mesh.End()
	end
end

--This bit was taken from one of my other projects. Converts source units to metric.
do
	local Measure = {
		M 	= 52.49344,
		KM 	= 52493.44,
		AU 	= 7852906865466.24,
		LY 	= 496626287418591869.952,
	}

	local abs = math.abs
	local floor = math.floor
	function AtlasAddons.Util:ConvertUnits( Number )
		Number = abs( Number )

		if Number *10 < Measure.M then
			return floor( Number *100 ) /100, "Units"
		elseif Number *10 < Measure.KM then
			return floor( Number /Measure.M *100 ) /100, "M"
		elseif Number *10 < Measure.AU then
			return floor( Number /Measure.KM *100 ) /100, "KM"
		elseif Number *10 < Measure.LY then
			return floor( Number /Measure.AU *100 ) /100, "AU"
		else
			return floor( Number /Measure.LY *100 ) /100, "LY"
		end
	end

	function AtlasAddons.Util:ConvertUnitsToKM( Number )
		Number = abs( Number )
		return floor( Number /Measure.KM *100 ) /100, "KM"
	end

	function AtlasAddons.Util:ConvertUnitsToM( intUnits )
		local inches = intUnits *0.75
		local meters = inches *0.0254
		local unit

		if meters >= 1000 then
			meters = math.Round( meters /1000, 2 )
			unit = "KM"
		else
			meters = math.Round( meters )
			unit = "M"
		end

		return meters, unit
	end
end

do
	local scope

	local function applyDebugHook()
		debug.sethook( function()
			if not scope then return end
			scope.ops = scope.ops +1
		end, "", 1 )
	end

	local function pushScope()
		scope = { start = SysTime(), ops = 0 }
		applyDebugHook()
	end

	local function popScope( strMsg )
		debug.sethook()
		Msg( strMsg.. "\n" )
		print( ("Time = %f, OpCount = %d"):format(SysTime() -scope.start, scope.ops) )
		scope = nil
	end

	lprof = {
		PushScope = pushScope,
		PopScope = popScope
	}
end

local emeta = debug.getregistry().Entity
emeta.ManipulateBoneScaleOld = emeta.ManipulateBoneScaleOld or emeta.ManipulateBoneScale

function emeta:ManipulateBoneScale( id, vec )
	if not id then return end

	return self:ManipulateBoneScaleOld( id, vec )
end