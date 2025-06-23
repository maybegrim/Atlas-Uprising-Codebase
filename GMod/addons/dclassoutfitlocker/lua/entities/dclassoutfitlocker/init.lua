AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize() 

	-- Re-reads locker config when entity spawned
	DClassLockerConfig = ReadConfigFile()

	-- Gets all players at entity spawn
	-- The table it checks is global so this should only be ran once
	if (table.IsEmpty(DClassOutfitLockerHasChanged)) then

		local AllPlayers = player.GetAll()

		for _, ply in ipairs(AllPlayers) do
			
			DClassOutfitLockerHasChanged[ply:SteamID()] = false

		end

	end

	-- Set up physics
	self:SetModel(DClassLockerConfig.LockerModel)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)

	-- Get and start physics object
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Wake()
	end

	-- Run ENT:Use only once per interaction key press
	self:SetUseType(SIMPLE_USE)

end

function ENT:Use(activator)

	-- Check activator is D-Class
	if (activator:getJobTable().faction ~= "D-CLASS") then
		return
	end

	-- Return if player is not allowed to change outfit
	-- Passes check if value is nil but that is wanted
	if (DClassOutfitLockerHasChanged[activator:SteamID()]) then
		-- Send notification to client about having changed already
		net.Start("DClassOutfitLockerAlreadyChanged")
		net.Send(activator)
		return
	end

	DClassOutfitLockerHasChanged[activator:SteamID()] = true

	net.Start("DClassOutfitLockerClientEffects")
	net.Send(activator)

	-- Gets character first and last name
	local FName, LName = CHARACTER.GetName(activator)

	-- Sets RP name to just first and last name
	activator:setRPName(FName .. " " .. LName)

	-- Lock movement during animation
	activator:Lock()

	-- Sets player still so they don't run in place while locked
	activator:SetVelocity(-activator:GetVelocity())

	-- Default to male 
	local CurPlyIsMale = true

	-- Get character data to check gender
	CHARACTER.RetrieveChar(FName, LName, activator:SteamID(), function(success, data)

		if (success) then
			if (data.type == 2) then
				-- Female
				CurPlyIsMale = false
			end
		end

	end)

	-- Waits till user's screen is black to change model
	timer.Simple(2, function()

		if (CurPlyIsMale) then
			activator:SetModel(DClassLockerConfig.MaleModels[math.random(1, #DClassLockerConfig.MaleModels)])
		else
			activator:SetModel(DClassLockerConfig.FemaleModels[math.random(1, #DClassLockerConfig.FemaleModels)])
		end

		activator:SetArmor(activator:Armor() + DClassLockerConfig.ArmorToAdd)
		activator:SetMaxArmor(activator:GetMaxArmor() + DClassLockerConfig.ArmorToAdd)

	end)

		-- Unlock movement after client effects finished
		timer.Simple(4, function()
		
			activator:UnLock()
		
		end)

	return
end