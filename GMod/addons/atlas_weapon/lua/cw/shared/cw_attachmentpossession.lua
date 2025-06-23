AddCSLuaFile()

if SERVER then
	CreateConVar("cw_keep_attachments_post_death", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Should players keep their attachments after they die?")
	
	util.AddNetworkString("CW20_OVERWRITEATTACHMENTS")
	util.AddNetworkString("CW20_NEWATTACHMENTS")
	util.AddNetworkString("CW20_NEWATTACHMENTS_NOTIFY")
	util.AddNetworkString("CW20_LOSTATTACHMENTS")
end

CustomizableWeaponry.useAttachmentPossessionSystem = true -- change this to false if you want to disable attachment possession restrictions (aka all attachments available regardless of whether the players have them or not)
CustomizableWeaponry.suppressOnSpawnAttachments = false

function CustomizableWeaponry:initCWVariables()
	if not self.CWAttachments then
		self.CWAttachments = {}
	end
end

local empty, space = "", " "

function CustomizableWeaponry:buildAttachmentString()
	local final = ""
	
	-- loop through the attachment table, find attachments that are given on spawn and concatenate a string that we'll network with them
	-- also add attachments to the serverside player attachment table to save a loop
	for k, v in ipairs(CustomizableWeaponry.registeredAttachments) do
		if GetConVarNumber(v.cvar) >= 1 then
			if not self.CWAttachments[v.name] then
				self.CWAttachments[v.name] = true
				
				if final == empty then
					final = v.name
				else
					final = final .. space .. v.name
				end
			end
		end
	end
	
	return final
end

function CustomizableWeaponry:decodeAttachmentString(str)
	self.CWAttachments = self.CWAttachments or {}
	
	local result = string.Explode(space, str)
	
	for k, v in pairs(result) do
		self.CWAttachments[v] = true
	end
end

-- Function to clear CW Attachments
local function clearCWAttachments(attachmentsTable)
	for k, v in pairs(attachmentsTable) do
	attachmentsTable[k] = nil
	end
end

-- Function to build and send attachment string
local function buildAndSendAttachmentString(self, message)
	local attachments = CustomizableWeaponry.buildAttachmentString(self)
	if attachments ~= empty then
		net.Start(message)
		net.WriteString(attachments)
		net.Send(self)
	else
		net.Start("CW20_LOSTATTACHMENTS")
		net.Send(self)
	end
end

function CustomizableWeaponry:postSpawn()
	-- Early exit if CWAttachments is not initialized
	if not self.CWAttachments then
		CustomizableWeaponry.initCWVariables(self)
		return
	end

	-- Early exit if attachment possession system is not used or suppressed on spawn
	if not CustomizableWeaponry.useAttachmentPossessionSystem or CustomizableWeaponry.suppressOnSpawnAttachments then
		return
	end

	if SERVER then
		local keepAttachments = GetConVarNumber("cw_keep_attachments_post_death") >= 1

		-- Clear attachments
		clearCWAttachments(self.CWAttachments)

		if not keepAttachments then
			buildAndSendAttachmentString(self, "CW20_OVERWRITEATTACHMENTS")
		else
			buildAndSendAttachmentString(self, "CW20_NEWATTACHMENTS")
		end
	else
		-- Clear attachments on client side
		clearCWAttachments(self.CWAttachments)
	end

	-- Process post spawn callbacks
	CustomizableWeaponry.callbacks.processCategory(self, "postSpawn")
end

function CustomizableWeaponry:hasAttachment(ply, att, lookIn)
	if not self.useAttachmentPossessionSystem then
		return true
	end
	
	lookIn = lookIn or ply.CWAttachments
	
	local has = hook.Call("CW20HasAttachment", nil, ply, att, lookIn)
	
	if lookIn[att] or has then
		return true
	end
	
	return false
end

-- this function checks whether the player has specified attachments in his inventory
-- accepts an array
function CustomizableWeaponry:hasSpecifiedAttachments(ply, tbl)
	-- failsafes, failsafes everywhere
	ply.CWAttachments = ply.CWAttachments or {}
	
	if not self.useAttachmentPossessionSystem then
		return true
	end
	
	for k, v in ipairs(tbl) do
		if not ply.CWAttachments[v] then
			return false
		end
	end
	
	return true
end

function CustomizableWeaponry:countMissingAttachments(ply, tbl)
	if not self.useAttachmentPossessionSystem then
		return 0
	end
	
	local count = 0
	
	for k, v in ipairs(tbl) do
		if not ply.CWAttachments[v] then
			count = count + 1
		end
	end
	
	return count
end

function CustomizableWeaponry:updateAdminCVars()
	for k, v in pairs(player.GetAll()) do
		if v:IsAdmin() then
			for k2, v2 in ipairs(CustomizableWeaponry.registeredAttachments) do
				v:ConCommand(v2.clcvar .. space .. GetConVarNumber(v2.cvar))
			end
		end
	end
end

function CustomizableWeaponry:giveAttachment(ply, att, noNetwork)
	if not att or not ply or not IsValid(ply) then
		return
	end
	
	ply.CWAttachments[att] = true
	
	if not noNetwork then
		umsg.Start("CW20_NEWATTACHMENT", ply)
			umsg.String(att)
		umsg.End()
	end
end

-- use this func when you want to send a certain amount of specific attachments to the client
function CustomizableWeaponry:giveAttachments(tbl, dontNotify, overwrite)
	CustomizableWeaponry.initCWVariables(self)
	
	-- add the attachments to the player's inventory
	for k, v in ipairs(tbl) do
		if CustomizableWeaponry.registeredAttachmentsSKey[v] then
			self.CWAttachments[v] = true
		end
	end
	
	-- concatenate the table into a string
	local result = table.concat(tbl, " ")
	
	if SERVER then
		-- send it to the client
		
		if overwrite then
			net.Start("CW20_OVERWRITEATTACHMENTS")
				net.WriteString(result)
			net.Send(self)
		else
			if dontNotify then
				net.Start("CW20_NEWATTACHMENTS")
					net.WriteString(result)
				net.Send(self)
			else
				net.Start("CW20_NEWATTACHMENTS_NOTIFY")
					net.WriteString(result)
				net.Send(self)
			end
		end
	end
end

function CustomizableWeaponry:giveAllAttachments(ply, att)
	if not att or not ply or not IsValid(ply) then
		return
	end
	
	for k, v in ipairs(CustomizableWeaponry.registeredAttachments) do
		ply.CWAttachments[v.name] = true
	end
	
	umsg.Start("CW20_ALLATTACHMENTS", ply)
		umsg.String(att)
	umsg.End()
end

function CustomizableWeaponry:removeAllAttachments(ply)
	net.Start("CW20_OVERWRITEATTACHMENTS")
		net.WriteString("")
	net.Send(ply)
	
	table.Empty(ply.CWAttachments)
end

function CustomizableWeaponry:removeAttachment(ply, att, noNetwork)
	if not att or not ply or not IsValid(ply) then
		return
	end
	
	ply.CWAttachments[att] = nil

	if not noNetwork then
		umsg.Start("CW20_REMOVEATTACHMENT", ply)
			umsg.String(att)
		umsg.End()
	end
end

-- builds attachment name strings for display on package entities
function CustomizableWeaponry:ent_buildAttachmentNameStrings(tbl)
	local result = {}
	
	for k, v in ipairs(tbl) do
		local att = CustomizableWeaponry.registeredAttachmentsSKey[v]
		
		if att then
			table.insert(result, {name = att.name, display = att.displayName})
		end
	end
	
	return result
end