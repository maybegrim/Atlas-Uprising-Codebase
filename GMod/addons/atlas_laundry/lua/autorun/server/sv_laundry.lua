util.AddNetworkString("SimpleLaundry.Notify")
local function Notify(ply, msg)
	net.Start("SimpleLaundry.Notify")
		net.WriteString(msg)
	net.Send(ply)
end

CreateConVar( "simplelaundry_sellprice", 50, FCVAR_SERVER_CAN_EXECUTE )
CreateConVar( "simplelaundry_washingtime", 20, FCVAR_SERVER_CAN_EXECUTE )
CreateConVar( "simplelaundry_dryingtime", 10, FCVAR_SERVER_CAN_EXECUTE )
CreateConVar( "simplelaundry_removetime", 30, FCVAR_SERVER_CAN_EXECUTE )
CreateConVar( "simplelaundry_maxlaundry", 10, FCVAR_SERVER_CAN_EXECUTE )
CreateConVar( "simplelaundry_alljobs", 1, FCVAR_SERVER_CAN_EXECUTE )

local simplelaundry_alljobs = GetConVar( "simplelaundry_alljobs" )

function SimpleLaundryTeam(ply)
	if ply:Team() != TEAM_CITIZEN and !simplelaundry_alljobs:GetBool() then 
		Notify(ply, "Incorrect Job you must be a citizen!")
		return true
	else 
		return false
	end
end

function SimpleLaundryPay(ply, amount, money)
	Notify(ply, "You washed, dried and folded " .. amount .. " pieces of clothing you earned " .. DarkRP.formatMoney(money) .. "!")
end

// NPC Spawn Functions
local map = string.lower( game.GetMap() )
//##### Save the Ents ##############################################################
local function SimpleLaundryEntsSave(ply)
    if ply:IsSuperAdmin() then   
        local laundryents = {}
        for k,v in pairs( ents.FindByClass("laundry*") ) do
            laundryents[k] = { type = v:GetClass(), pos = v:GetPos(), ang = v:GetAngles() }
        end	
        local convert_data = util.TableToJSON( laundryents )		
        file.Write( "simplelaundry/laundryents_" .. map .. ".txt", convert_data )
        Notify(ply, "Laundry Entity Locations Saved for map " .. map)  
    end
end
concommand.Add("simplelaundry_saveents", SimpleLaundryEntsSave)
 
//##### Delete the Ents ##############################################################
local function SimpleLaundryEntsDelete(ply)
    if ply:IsSuperAdmin() then
    	for k,v in pairs( ents.FindByClass("laundry*") ) do
            v:Remove()
        end
        file.Delete( "simplelaundry/laundryents_" .. map .. ".txt" )
        Notify(ply, "Laundry Entity Locations Deleted from map " .. map)
    end    
end
concommand.Add("simplelaundry_removeents", SimpleLaundryEntsDelete)

//##### Load the Ents ##############################################################
local function SimpleLaundryEntsLoad(ply)
	if ply:IsSuperAdmin() then
		if not file.IsDir( "simplelaundry", "DATA" ) then
        	file.CreateDir( "simplelaundry", "DATA" )
    	end
		if not file.Exists("simplelaundry/laundryents_" .. map .. ".txt","DATA") then return end
		for k,v in pairs( ents.FindByClass("laundry*") ) do
            v:Remove()
        end	
		local ImportData = util.JSONToTable(file.Read("simplelaundry/laundryents_" .. map .. ".txt","DATA"))
	    	for k, v in pairs(ImportData) do
	        local ent = ents.Create( v.type )
	        ent:SetPos( v.pos )
	        ent:SetAngles( v.ang )
	        ent:Spawn()
		end
	end
end
concommand.Add("simplelaundry_respawnents", SimpleLaundryEntsLoad)

//##### Autospawn the Ents ##############################################################
local function SimpleLaundryEntsInit()
    if not file.IsDir( "simplelaundry", "DATA" ) then
        file.CreateDir( "simplelaundry", "DATA" )
    end
	if not file.Exists("simplelaundry/laundryents_" .. map .. ".txt","DATA") then return end
	local ImportData = util.JSONToTable(file.Read("simplelaundry/laundryents_" .. map .. ".txt","DATA"))
    	for k, v in pairs(ImportData) do
        local ent = ents.Create( v.type )
        ent:SetPos( v.pos )
        ent:SetAngles( v.ang )
        ent:Spawn()
	end
end
hook.Add( "InitPostEntity", "SimpleLaundryEntsInit", SimpleLaundryEntsInit )
