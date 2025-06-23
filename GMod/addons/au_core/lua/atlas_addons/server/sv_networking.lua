--[[
	This file has been copyrighted by Atlas Uprising.
	Do not distribute or copy any files.
]]--

AtlasAddons.Net = AtlasAddons.Net or {}
AtlasAddons.Net.m_bVerbose = false
AtlasAddons.Net.m_tblProtocols = AtlasAddons.Net.m_tblProtocols or { Names = {}, IDs = {} }
AtlasAddons.Net.m_tblVarLookup = {
	Write = {
		["UInt4"] = { func = net.WriteUInt, size = 4 },
		["UInt8"] = { func = net.WriteUInt, size = 8 },
		["UInt16"] = { func = net.WriteUInt, size = 16 },
		["UInt32"] = { func = net.WriteUInt, size = 32 },
		["Int4"] = { func = net.WriteInt, size = 4 },
		["Int8"] = { func = net.WriteInt, size = 8 },
		["Int16"] = { func = net.WriteInt, size = 16 },
		["Int32"] = { func = net.WriteInt, size = 32 },
		["Angle"] = { func = net.WriteAngle },
		["Bit"] = { func = net.WriteBit },
		["Bool"] = { func = net.WriteBool },
		["Color"] = { func = net.WriteColor },
		["Double"] = { func = net.WriteDouble },
		["Entity"] = { func = net.WriteEntity },
		["Float"] = { func = net.WriteFloat },
		["Normal"] = { func = net.WriteNormal },
		["String"] = { func = net.WriteString },
		["Table"] = { func = net.WriteTable },
		["Vector"] = { func = net.WriteVector },
	},
	Read = {
		["UInt4"] = { func = net.ReadUInt, size = 4 },
		["UInt8"] = { func = net.ReadUInt, size = 8 },
		["UInt16"] = { func = net.ReadUInt, size = 16 },
		["UInt32"] = { func = net.ReadUInt, size = 32 },
		["Int4"] = { func = net.ReadInt, size = 4 },
		["Int8"] = { func = net.ReadInt, size = 8 },
		["Int16"] = { func = net.ReadInt, size = 16 },
		["Int32"] = { func = net.ReadInt, size = 32 },
		["Angle"] = { func = net.ReadAngle },
		["Bit"] = { func = net.ReadBit },
		["Bool"] = { func = net.ReadBool },
		["Color"] = { func = net.ReadColor },
		["Double"] = { func = net.ReadDouble },
		["Entity"] = { func = net.ReadEntity },
		["Float"] = { func = net.ReadFloat },
		["Normal"] = { func = net.ReadNormal },
		["String"] = { func = net.ReadString },
		["Table"] = { func = net.ReadTable },
		["Vector"] = { func = net.ReadVector },
	},
}

util.AddNetworkString "atlas_netmsg"

function AtlasAddons.Net:Initialize()
	net.Receive( "atlas_netmsg", function( intMsgLen, pPlayer, ... )
		local id, name = net.ReadUInt( 8 ), net.ReadString()
		if not id or not name then return end
		if self.m_bVerbose then print( pPlayer, id, name ) end

		local event_data = self:GetEventHandleByID( id, name )
		if not event_data then
			ErrorNoHalt( ("Invalid net message header sent by %s! Got protocol[%s]:id[%s]\n"):format(pPlayer:Nick(), id, name) )
			return
		end

		--lprof.PushScope()
		if event_data.meta then
			event_data.func( event_data.meta, intMsgLen, pPlayer, ... )
		else
			event_data.func( intMsgLen, pPlayer, ... )
		end
		--lprof.PopScope( "atlas_netmsg:(".. pPlayer:Nick().. ")[".. id.. "][".. name.. "]" )
	end )
end

function AtlasAddons.Net:AddProtocol( strProtocol, intNetID )
	if self.m_tblProtocols.Names[strProtocol] then return end
	self.m_tblProtocols.Names[strProtocol] = { ID = intNetID, Events = {} }
	self.m_tblProtocols.IDs[intNetID] = self.m_tblProtocols.Names[strProtocol]
end

function AtlasAddons.Net:IsProtocol( strProtocol )
	return self.m_tblProtocols.Names[strProtocol] and true or false
end

function AtlasAddons.Net:RegisterEventHandle( strProtocol, strMsgName, funcHandle, tblHandleMeta )
	if not self:IsProtocol( strProtocol ) then
		return
	end

	self.m_tblProtocols.Names[strProtocol].Events[strMsgName] = { func = funcHandle, meta = tblHandleMeta }
end

function AtlasAddons.Net:GetEventHandle( strProtocol, strMsgName )
	if not self:IsProtocol( strProtocol ) then return end
	return self.m_tblProtocols.Names[strProtocol].Events[strMsgName]
end

function AtlasAddons.Net:GetEventHandleByID( intNetID, strMsgName )
	local tbl = self.m_tblProtocols.IDs[intNetID]
	if not tbl then return end

	return tbl.Events[strMsgName]
end

function AtlasAddons.Net:GetProtocolIDByName( strProtocol )
	return self.m_tblProtocols.Names[strProtocol].ID
end

function AtlasAddons.Net:NewEvent( strProtocol, strMsgName )
	if self.m_bVerbose then print( "New outbound net message: ".. strProtocol.. ":".. strMsgName ) end
	self.m_strCurProtocol = strProtocol
	self.m_strCurName = strMsgName

	net.Start( "atlas_netmsg" )
	net.WriteUInt( self:GetProtocolIDByName(strProtocol), 8 )
	net.WriteString( strMsgName )
end

function AtlasAddons.Net:FireEvent( pPlayer )
	if self.m_bVerbose and type(pPlayer) ~= "table" then print( ("Sending outbound net message to %s"):format(pPlayer:Nick()) ) end
	if DBugR then
		DBugR.Profilers.Net:AddNetData( "AtlasAddons.Net[".. self.m_strCurProtocol.. "][".. self.m_strCurName.. "]", net.BytesWritten() )
	end

	net.Send( pPlayer )
end

function AtlasAddons.Net:BroadcastEvent()
	if DBugR then
		DBugR.Profilers.Net:AddNetData( "AtlasAddons.Net[".. self.m_strCurProtocol.. "][".. self.m_strCurName.. "]", net.BytesWritten() )
	end
	net.Broadcast()
end

--[[ ----------------------------------------------------------------
-- Example Netcode
-- ----------------------------------------------------------------
AtlasAddons.Net:AddProtocol( "example", 0 )

-- Send a table to the player
function AtlasAddons.Net:SendNetcode( pPlayer, tblArgs )
	self:NewEvent( "example", "recieve" )
		net.WriteTable( tblArgs or {} )
	self:FireEvent( pPlayer )
end

-- Recieve a table from the player
AtlasAddons.Net:RegisterEventHandle( "example", "send", function( intMsgLen, pPlayer )
	local tblData = net.ReadTable()
end )
]]

-- ----------------------------------------------------------------
-- Playtime Netcode
-- ----------------------------------------------------------------
AtlasAddons.Net:AddProtocol( "playtime", 0 )

function AtlasAddons.Net:SendTimeData( pPlayer, tblArgs )
	self:NewEvent( "playtime", "upd" )
		net.WriteTable( tblArgs or {} )
	self:FireEvent( pPlayer )
end

-- ----------------------------------------------------------------
-- Leveling Netcode
-- ----------------------------------------------------------------
AtlasAddons.Net:AddProtocol( "leveling", 1 )

function AtlasAddons.Net:SendLevelingData( pPlayer, tblArgs )
	self:NewEvent( "leveling", "upd" )
		net.WriteTable( tblArgs or {} )
	self:FireEvent( pPlayer )
end

-- ----------------------------------------------------------------
-- Crash Notification Netcode
-- ----------------------------------------------------------------
AtlasAddons.Net:AddProtocol( "crash", 2 )

function AtlasAddons.Net:SendPong()
	self:NewEvent( "crash", "pong" )
	self:BroadcastEvent()
end

-- ----------------------------------------------------------------
-- SCP SWEP Netcode
-- ----------------------------------------------------------------
AtlasAddons.Net:AddProtocol( "scpswep", 3 )

function AtlasAddons.Net:UpdateSCP066Affected( pPlayer, bAffected )
	self:NewEvent( "scpswep", "upd066" )
		net.WriteBool( bAffected )
	self:FireEvent( pPlayer )
end