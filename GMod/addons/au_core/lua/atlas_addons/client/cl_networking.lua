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

function AtlasAddons.Net:Initialize()
	net.Receive( "atlas_netmsg", function( intMsgLen, ... )
		local id, name = net.ReadUInt( 8 ), net.ReadString()
		if not id or not name then return end
		if self.m_bVerbose then print( intMsgLen, id, name ) end

		local event_data = self:GetEventHandleByID( id, name )
		if not event_data then return end
		if event_data.meta then
			event_data.func( event_data.meta, intMsgLen, ... )
		else
			event_data.func( intMsgLen, ... )
		end
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
	return self.m_tblProtocols.IDs[intNetID].Events[strMsgName]
end

function AtlasAddons.Net:GetProtocolIDByName( strProtocol )
	return self.m_tblProtocols.Names[strProtocol].ID
end

function AtlasAddons.Net:NewEvent( strProtocol, strMsgName )
	if self.m_bVerbose then print( "New outbound net message: ".. strProtocol.. ":".. strMsgName ) end
	net.Start( "atlas_netmsg" )
	net.WriteUInt( self:GetProtocolIDByName(strProtocol), 8 )
	net.WriteString( strMsgName )
end

function AtlasAddons.Net:FireEvent()
	if self.m_bVerbose then print( "Sending outbound net message to server." ) end
	net.SendToServer()
end


--[[ ----------------------------------------------------------------
-- Example Netcode
-- ----------------------------------------------------------------
AtlasAddons.Net:AddProtocol( "example", 0 )

-- Send a table to the server
function AtlasAddons.Net:SendNetcode( tblArgs )
	self:NewEvent( "example", "send" )
		net.WriteTable( tblArgs or {} )
	self:FireEvent()
end

-- Recieve a table from the server
AtlasAddons.Net:RegisterEventHandle( "example", "recieve", function( intMsgLen, pPlayer )
	local tblData = net.ReadTable()
end )
]]

-- ----------------------------------------------------------------
-- Playtime Netcode
-- ----------------------------------------------------------------
AtlasAddons.Net:AddProtocol( "playtime", 0 )

AtlasAddons.Net:RegisterEventHandle( "playtime", "upd", function( intMsgLen, pPlayer )
	local m_tblTimeTable = net.ReadTable()
	AtlasAddons.Time:UpdateTime( m_tblTimeTable )
end )

-- ----------------------------------------------------------------
-- Leveling Netcode
-- ----------------------------------------------------------------
AtlasAddons.Net:AddProtocol( "leveling", 1 )

AtlasAddons.Net:RegisterEventHandle( "leveling", "upd", function( intMsgLen, pPlayer )
	local m_tblLevelingTable = net.ReadTable()
	AtlasAddons.Leveling:UpdateLeveling( m_tblLevelingTable )
end )

-- ----------------------------------------------------------------
-- Crash Notification Netcode
-- ----------------------------------------------------------------
AtlasAddons.Net:AddProtocol( "crash", 2 )

AtlasAddons.Net:RegisterEventHandle( "crash", "pong", function( intMsgLen, pPlayer )
	AtlasAddons.CrashNotification:Pong()
end )

-- ----------------------------------------------------------------
-- SCP SWEP Netcode
-- ----------------------------------------------------------------
AtlasAddons.Net:AddProtocol( "scpswep", 3 )

AtlasAddons.Net:RegisterEventHandle( "scpswep", "upd066", function( intMsgLen, pPlayer )
	AtlasAddons.SCP066:SetAffected( net.ReadBool() )
end )