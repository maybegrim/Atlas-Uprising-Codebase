util.AddNetworkString("npctool_relman_add")
util.AddNetworkString("npctool_relman_rem")
util.AddNetworkString("npctool_relman_up")
util.AddNetworkString("npctool_relman_en")
util.AddNetworkString("npctool_relman_clr")

local tRels = {}
local enabled = true
local function StoreDisposition(src,tgt,disp)
	src.m_tbRelsDef = src.m_tbRelsDef || {}
	src.m_tbRelsDef[tgt] = src.m_tbRelsDef[tgt] || src:Disposition(tgt)
end
local function RestoreRelationship(src,tgt)
	if(!src.m_tbRelsDef || !src.m_tbRelsDef[tgt]) then return end
	local disp = src.m_tbRelsDef[tgt]
	src:AddEntityRelationship(tgt,disp)
	src.m_tbRelsDef[tgt] = nil
end
local function ApplyRelationship(src,tgt,disp)
	for _,ent in ipairs(ents.FindByClass(src)) do
		if(ent:IsNPC()) then
			for _,entTgt in ipairs(ents.FindByClass(tgt)) do
				if(entTgt:IsNPC() || entTgt:IsPlayer()) then
					StoreDisposition(ent,entTgt)
					ent:AddEntityRelationship(entTgt,disp,100)
				end
			end
		end
	end
end
hook.Add("OnEntityCreated","npctool_relman_apply",function(ent)
	if(enabled && ent:IsValid() && ent:IsNPC()) then
		timer.Simple(0.1,function()
			if(ent:IsValid()) then
				local class = ent:GetClass()
				if(tRels[class]) then
					for tgt,disp in pairs(tRels[class]) do
						for _,entTgt in ipairs(ents.FindByClass(tgt)) do
							if(entTgt:IsNPC() || entTgt:IsPlayer()) then
								StoreDisposition(ent,entTgt)
								ent:AddEntityRelationship(entTgt,disp,100)
							end
						end
					end
				end
				for _,entTgt in ipairs(ents.GetAll()) do
					if(entTgt:IsNPC() && entTgt != ent) then
						local classTgt = entTgt:GetClass()
						if(tRels[classTgt] && tRels[classTgt][class]) then
							StoreDisposition(entTgt,ent)
							entTgt:AddEntityRelationship(ent,tRels[classTgt][class],100)
						end
					end
				end
			end
		end)
	end
end)

local function RestoreRelationships(src,tgt)
	for _,ent in ipairs(ents.FindByClass(src)) do
		if(ent:IsNPC()) then
			for _,entTgt in ipairs(ents.FindByClass(tgt)) do
				if(entTgt:IsNPC() || entTgt:IsPlayer()) then
					RestoreRelationship(ent,entTgt)
				end
			end
		end
	end
end

net.Receive("npctool_relman_add",function(len,pl)
	local src = net.ReadString()
	local tgt = net.ReadString()
	local disp = net.ReadUInt(3)
	tRels[src] = tRels[src] || {}
	tRels[src][tgt] = disp
	enabled = pl:GetInfoNum("npctool_relman_enabled",1) != 0
	if(enabled) then ApplyRelationship(src,tgt,disp) end
end)

net.Receive("npctool_relman_rem",function(len,pl)
	local src = net.ReadString()
	local tgt = net.ReadString()
	if(tRels[src]) then
		tRels[src][tgt] = nil
	end
	enabled = pl:GetInfoNum("npctool_relman_enabled",1) != 0
	if(enabled) then RestoreRelationships(src,tgt) end
end)

local function ClearRelationships(pl)
	enabled = pl:GetInfoNum("npctool_relman_enabled",1) != 0
	if(enabled) then
		for src,rels in pairs(tRels) do
			for tgt,disp in pairs(rels) do
				RestoreRelationships(src,tgt)
			end
		end
	end
	tRels = {}
end

net.Receive("npctool_relman_up",function(len,pl)
	if !pl:HasWeapon("gmod_tool") or pl:GetWeapon("gmod_tool").Mode != "npctool_relationships" then return end
	ClearRelationships(pl)
	local numRels = net.ReadUInt(12)
	enabled = pl:GetInfoNum("npctool_relman_enabled",1) != 0
	for i = 1,numRels do
		local src = net.ReadString()
		local numTgts = net.ReadUInt(12)
		tRels[src] = tRels[src] || {}
		for j = 1,numTgts do
			local tgt = net.ReadString()
			local disp = net.ReadUInt(3)
			tRels[src][tgt] = disp
			if(enabled) then ApplyRelationship(src,tgt,disp) end
		end
	end
end)

net.Receive("npctool_relman_en",function(len,pl)
	enabled = net.ReadUInt(1) == 1
	if(!enabled) then
		for src,rels in pairs(tRels) do
			for tgt,disp in pairs(rels) do
				RestoreRelationships(src,tgt)
			end
		end
		return
	end
	for src,rels in pairs(tRels) do
		for tgt,disp in pairs(rels) do
			ApplyRelationship(src,tgt,disp)
		end
	end
end)

net.Receive("npctool_relman_clr",function(len,pl)
	ClearRelationships(pl)
end)