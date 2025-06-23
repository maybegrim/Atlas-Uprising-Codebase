AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

local excludedTeams = {}

local function SaveExcludedTeams()
	if not file then return end  
	local data = util.TableToJSON({excludedTeams = excludedTeams, teamConstantNames = teamConstantNames})
	file.Write("excludedTeams.txt", data)
end

local function LoadExcludedTeams()
	if not file or not file.Exists("excludedTeams.txt", "DATA") then 
		excludedTeams = {} 
		teamConstantNames = {} 

		
		for teamIndex, teamData in pairs(team.GetAllTeams()) do
			table.insert(excludedTeams, teamIndex)
			teamConstantNames[teamIndex] = teamData.Name
		end

		return 
	end  

	local data = file.Read("excludedTeams.txt", "DATA")
	local tables = util.JSONToTable(data)
	excludedTeams = tables.excludedTeams
	teamConstantNames = tables.teamConstantNames
end

local function AddTeam(teamConstant, teamName)
	if not excludedTeams then excludedTeams = {} end 
	if not teamConstantNames then teamConstantNames = {} end 
	if not teamConstant then 
		print("The team you're trying to add does not exist.")
		return 
	end
	table.insert(excludedTeams, teamConstant)
	teamConstantNames[teamConstant] = teamName 
	SaveExcludedTeams()
end

local function DeleteTeam(teamConstant)
	if not excludedTeams then excludedTeams = {} end 
	if not teamConstantNames then teamConstantNames = {} end 
	local teamIndex = table.KeyFromValue(excludedTeams, teamConstant)
	if teamIndex then
		table.remove(excludedTeams, teamIndex)
		SaveExcludedTeams()
	end
end

local function ListTeams()
	if not excludedTeams or not teamConstantNames then 
		LoadExcludedTeams() 
	end
	return excludedTeams
end

hook.Add("Initialize", "LoadExcludedTeams", function()
	LoadExcludedTeams()
end)

SWEP_OWNER = nil

function SWEP:Initialize()
	SWEP_OWNER = self.Owner
end

concommand.Add("ADDTEAM457", function(ply, cmd, args)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	if not ply:IsAdmin() then 
		ply:ChatPrint("You do not have permission to use this command.")
		return 
	end
	if not args[1] then return end

	local teamConstant = _G[args[1]]
	if not teamConstant then 
		ply:ChatPrint("The team you're trying to add does not exist.")
		return 
	end

	AddTeam(teamConstant, args[1])
	ply:ChatPrint("Team '" .. args[1] .. "' successfully added, it was saved correctly.")
end)

concommand.Add("DELETETEAM457", function(ply, cmd, args)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	if not ply:IsAdmin() then 
		ply:ChatPrint("You do not have permission to use this command.")
		return 
	end
	if not args[1] then return end 

	local teamConstant = _G[args[1]]

	DeleteTeam(teamConstant)
	ply:ChatPrint("Team '" .. args[1] .. "' successfully removed, it was saved correctly.")
end)

concommand.Add("LISTTEAMS", function(ply, cmd, args)
	if not IsValid(ply) or not ply:IsPlayer() then return end 
	if not ply:IsAdmin() then 
		ply:ChatPrint("You do not have permission to use this command.")
		return 
	end

	if not excludedTeams or not teamConstantNames then 
		LoadExcludedTeams()  
	end

	local teams = ListTeams()
	for i, teamIndex in ipairs(teams) do
		local teamConstantName = teamConstantNames[teamIndex] 
		if teamConstantName then
			ply:ChatPrint("Team name " .. i .. ": " .. teamConstantName)
		else
			ply:ChatPrint("Team name " .. i .. ": Unknown")
		end
	end
end)

hook.Add("EntityTakeDamage", "NoFireDamageToOwner", function(target, dmginfo)
	if target == SWEP_OWNER then
		if dmginfo:IsDamageType(DMG_BURN) and dmginfo:GetAttacker() == SWEP_OWNER then
			dmginfo:SetDamage(0)
		end
	end
end)

hook.Add("EntityTakeDamage", "NoFireDamageToExcludedTeams", function(target, dmginfo)
	if target:IsPlayer() then
		local teamConstant = target:Team()
		if table.HasValue(excludedTeams, teamConstant) then
			if dmginfo:IsDamageType(DMG_BURN) and dmginfo:GetAttacker() == SWEP_OWNER then
				local weaponOwnerPos = SWEP_OWNER:GetPos()
				local targetPos = target:GetPos()
				local distance = weaponOwnerPos:Distance(targetPos)
				if distance <= 200 then
					dmginfo:SetDamage(0)
				end
			end
		end
	end
end)

function SWEP:Think()
	local weaponOwner = self.Owner
	if SERVER then
		local weaponOwnerPos = weaponOwner:GetPos()
		for k,v in pairs(ents.FindInSphere(weaponOwnerPos, 200)) do
			if v:IsPlayer() and v ~= weaponOwner and not table.HasValue(excludedTeams, v:Team()) then
				if not v:IsOnFire() then
					v:Ignite(2,250)
					local vIndex = v:EntIndex()
					timer.Create("ExtraFireDamage"..vIndex, 0.5, 4, function()
						if IsValid(v) then
							local dmginfo = DamageInfo()
							dmginfo:SetDamage(3) 
							dmginfo:SetDamageType(DMG_BURN)
							dmginfo:SetAttacker(weaponOwner)
							dmginfo:SetInflictor(self)
							v:TakeDamageInfo(dmginfo)
						end
					end)
				end
				weaponOwner.nextexp = CurTime() + 1
			end
		end
		if weaponOwner:IsOnFire() then
			timer.Simple(0, function() if IsValid(weaponOwner) then weaponOwner:Extinguish() end end)
		end
	end
end