//Thanks to hunted and Wrex for their Precision tool used as reference for this tool
//You can it at http://steamcommunity.com/sharedfiles/filedetails/?id=104482086

TOOL.Category		= "Construction"
TOOL.Name			= "Superfreeze"
TOOL.Command		= nil
TOOL.ConfigName		= ""

--TOOL.ClientConVar[ "physgun_freeze" ] = "0"

//Returns true if there's a valid entity and physobj and not player or world
local function VerifyEnt( ent )
	local ent = ent.Entity or ent //Allows to pass trace objects as well
	
	if IsValid(ent) then
		if (IsValid(ent:GetPhysicsObject()) or CLIENT) and !(ent:IsPlayer() or ent:IsWorld()) then 
			//Server absolutely needs to have a physobj, client can asume we're fine
			return true 
		end
	end
	return false
end

local function IsValidRagdoll(ent)
	if not IsValid(ent) then return false end
	if ent:GetClass() ~= "prop_ragdoll" then return false end
	local bones = ent:GetPhysicsObjectCount()
	if ( bones < 2 ) then return false end
	return true
end

//Helper to EnableMotion() on all ragdoll bones
local function FreezeRagdoll(ent,bool)
	local bones = ent:GetPhysicsObjectCount()
	for i = 0, bones-1 do
		local bone = ent:GetPhysicsObjectNum(i)
		bone:EnableMotion(not bool)
	end
	return true
end

//Helper to send fancy hints to the client
local function NotifyPly(ply,msg,type,delay)
	net.Start("superfreeze_clientnotify")
	net.WriteString(msg)
	net.WriteInt(type,4)
	net.WriteInt(delay,4)
	net.Send(ply)
end


//Checks if ai_serverragdolls aka "keep corpses" is enabled and notifies the client if its not
local function CheckAISetting(ply)
	local cvr = GetConVar("ai_serverragdolls")
	if not cvr:GetBool() then
		if ply:IsAdmin() then
			NotifyPly(ply,"\"Keep Corpses\" must be enabled!",1,4)
		else
			NotifyPly(ply,"\"Keep Corpses\" is disabled on this server",1,4)
		end
	end
end

//True freezes, false unfreezes
local function SuperFreeze( ent , bool )
	local phys = ent:GetPhysicsObject()
	
	phys:EnableMotion(!bool)
	ent:SetUnFreezable(bool)
	ent.PhysgunDisabled = bool
	
	if bool then
		ent:SetMoveType(MOVETYPE_NONE)
		duplicator.StoreEntityModifier( ent, "hunternl_superfrozen", {true})
		
	else
		ent:SetMoveType(MOVETYPE_VPHYSICS)
		//phys:Wake()
		duplicator.ClearEntityModifier( ent, "hunternl_superfrozen")
	end
	
	return true

end

//Loop over all constrainted ents and apply superfreeze
local function AllContrainedFreeze( ent, bool )
	local enttable = constraint.GetAllConstrainedEntities( ent )
	for _,v in pairs(enttable) do
		if VerifyEnt(v) then SuperFreeze(v,bool) end
	end
	return true 
end

//Loop over all constrained ents and sleep them
local function AllConstrainedSleep(ent)
	local enttable = constraint.GetAllConstrainedEntities( ent )
	for _,v in pairs(enttable) do
		if VerifyEnt(v) then v:GetPhysicsObject():Sleep() end
	end
	return true 
end

//Apply superfreeze after duplication
local function loaddata(ply,ent,data) 
	if data[1] then
		SuperFreeze(ent,true)
	end
end
duplicator.RegisterEntityModifier( "hunternl_superfrozen", loaddata )

local function applyEffects(trace,ply,bool)
	if not VerifyEnt(trace) then return false end
	
	if CLIENT then return true end
	
	local ent = trace.Entity
	
	if ent:IsNPC() then
		CheckAISetting(ply) 
		ent.hunternl_superfreeze_markedforstatue = bool
		return true
	elseif IsValidRagdoll(ent) then
		return FreezeRagdoll(ent,bool)
	else
		if ply:KeyDown(IN_SPEED) then
			return AllContrainedFreeze(ent, bool)
		else
			return SuperFreeze(ent,bool)
		end
	end
end



function TOOL:LeftClick( trace )
	if !IsFirstTimePredicted() then return end
	return applyEffects(trace,self:GetOwner(),true)
end

function TOOL:RightClick( trace )
	if !IsFirstTimePredicted() then return end
	return applyEffects(trace,self:GetOwner(),false)
end

function TOOL:Reload ( trace )
	if !IsFirstTimePredicted() then return end
	if not VerifyEnt(trace) then return false end
	
	if CLIENT then return true end
	
	if self:GetOwner():KeyDown(IN_SPEED) then
		return AllConstrainedSleep(trace.Entity)
	else
		trace.Entity:GetPhysicsObject():Sleep()
		return true
	end
end

function TOOL.BuildCPanel( CPanel )
	--[[CPanel:AddControl( "CheckBox",
	{ 
		Label = "Superfreeze on physgun freeze",
		Command = "superfreeze_physgun_freeze",
	})]]
end


if CLIENT then
	//Language stuff
	language.Add( "tool.superfreeze.name", "Superfreeze" )
	language.Add( "tool.superfreeze.desc", "Disables physics on objects, hit NPCs to mark for freezing on death" )
	language.Add( "tool.superfreeze.0", "Primary: Freeze | Secondary: Unfreeze | Reload: \"Sleep\" | Hold sprint to apply to all constrained" )
	
	//Receiver for notification
	net.Receive("superfreeze_clientnotify", function( length, client )
		notification.AddLegacy(net.ReadString(),net.ReadInt(4),net.ReadInt(4))
	end)
	
else
	util.AddNetworkString("superfreeze_clientnotify")
	
	//Freezing ragdolls when NPCs die
	hook.Add("CreateEntityRagdoll","superfreeze_freezenpcdeath",function(ent,doll)
		if ent.hunternl_superfreeze_markedforstatue and IsValidRagdoll(doll) then
		
			//Prop protection
			if CPPI then
				doll:CPPISetOwner(ent:CPPIGetOwner())
			end
			
			FreezeRagdoll(doll,true)
		end
	end)
	
	//Superfreezing on physgun freeze
	--[[hook.Add("OnPhysgunFreeze","superfreeze_onphysfreeze",function(wep,phys,ent,ply)
		if ply:GetInfoNum("superfreeze_physgun_freeze",0) > 0 and not IsValidRagdoll(ent) then
			SuperFreeze(ent,true)
		end
	end)]]
end
