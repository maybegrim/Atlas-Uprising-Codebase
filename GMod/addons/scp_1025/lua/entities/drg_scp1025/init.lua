AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:SpawnFunction(ply, tr, ClassName)
	if not tr.Hit then return end
	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y + 180
	local ent = ents.Create(ClassName)
	ent:SetPos(tr.HitPos + Vector(0, 0, 5))
	ent:SetAngles(SpawnAng)
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
  self:SetModel("models/mishka/models/scp1025.mdl")
  self:PhysicsInit(SOLID_VPHYSICS)
  self:SetMoveType(MOVETYPE_VPHYSICS)
  self:SetSolid(SOLID_VPHYSICS)
  local phys = self:GetPhysicsObject()
  if phys:IsValid() then
    phys:Wake()
  end
  self:SetUseType(SIMPLE_USE)
end

function ENT:Use(ply)
  if ply:GetNWInt("DrGRunSpeed") == 0 then
    ply:SetNWInt("DrGRunSpeed", ply:GetRunSpeed())
  end
  if ply:GetNWInt("DrGJumpPower") == 0 then
		ply:SetNWInt("DrGJumpPower", ply:GetJumpPower())
  end
	if not ply:GetNWBool("1025Blind") and not ply:GetNWBool("1025CantUse") then
	  local diseases = {}
	  local nb = 0
	  if GetConVar("scp1025_cardiac"):GetBool() and not ply:GetNWBool("1025Cardiac") and not ply:GetNWBool("1025Ignite") then
	    table.insert(diseases, "Cardiac Arrest")
	    nb = nb + 1
	  end
	  if GetConVar("scp1025_lungcancer"):GetBool() and not ply:GetNWBool("1025LungCancer") then
	    table.insert(diseases, "Lung Cancer")
	    nb = nb + 1
	  end
	  if GetConVar("scp1025_appendicitis"):GetBool() and not ply:GetNWBool("1025Appendicitis") then
	    table.insert(diseases, "Appendicitis")
	    nb = nb + 1
	  end
	  if GetConVar("scp1025_asthma"):GetBool() and not ply:GetNWBool("1025Asthma") then
	    table.insert(diseases, "Asthma")
	    nb = nb + 1
	  end
	  if GetConVar("scp1025_blindness"):GetBool() and not ply:GetNWBool("1025Blind") then
	    table.insert(diseases, "Blindness")
	    nb = nb + 1
	  end
	  if GetConVar("scp1025_fop"):GetBool() and not ply:GetNWBool("1025FOP") and not ply:GetNWBool("1025Cardiac") then
	    table.insert(diseases, "Fibrodysplasia Ossificans Progressiva")
	    nb = nb + 1
	  end
	  if GetConVar("scp1025_combustion"):GetBool() and not ply:GetNWBool("1025Cardiac") and not ply:GetNWBool("1025Ignite") then
	    table.insert(diseases, "Spontaneous Combustion")
	    nb = nb + 1
	  end
		if GetConVar("scp1025_regencancer"):GetBool() and not ply:GetNWBool("1025Regen") then
	    table.insert(diseases, "Regenerative Cancer")
	    nb = nb + 1
	  end
	  local disease = "None"
	  if nb ~= 0 then disease = diseases[math.random(1, nb)] end
	  if ply:GetNWBool("Wearing714") then
	    net.Start("PlayerUsed1025But714")
	    net.WriteString(disease)
	    net.Send(ply)
	  else
	    net.Start("PlayerUsed1025")
	    net.WriteString(disease)
	    net.Send(ply)

			-- giving the disease to the player
	    if disease == "Cardiac Arrest" then
				GiveCardiac(ply)
	    elseif disease == "Lung Cancer" then
				GiveLungCancer(ply)
	    elseif disease == "Appendicitis" then
				GiveAppendicitis(ply)
	    elseif disease == "Asthma" then
				GiveAsthma(ply)
	    elseif disease == "Blindness" then
				GiveBlindness(ply)
	    elseif disease == "Fibrodysplasia Ossificans Progressiva" then
				GiveFOP(ply)
	    elseif disease == "Spontaneous Combustion" then
				GiveIgnite(ply)
			elseif disease == "Regenerative Cancer" then
				GiveRegenCancer(ply)
	    end
	  end
	end
end

--DISEASES------------------------------------

function GiveCardiac(ply)
	ply:SetNWBool("1025Cardiac", true)
	timer.Simple(1.2, function()
		if ply:GetNWBool("1025Cardiac") and ply:Alive() then
			ply:Kill()
		end
	end)
end

function GiveLungCancer(ply)
	ply:SetNWBool("1025LungCancer", true)
	ply:SetRunSpeed(ply:GetWalkSpeed())
	ply:SetNWInt("DrGSlowRun", ply:GetNWInt("DrGSlowRun") + 1)
end

function GiveAppendicitis(ply)
	ply:SetNWBool("1025Appendicitis", true)
	ply:SetJumpPower(0)
	ply:SetNWInt("DrGWeakJumps", ply:GetNWInt("DrGWeakJumps") + 1)
end

function GiveAsthma(ply)
	ply:SetNWBool("1025Asthma", true)
	ply:SetRunSpeed(ply:GetWalkSpeed())
	ply:SetNWInt("DrGSlowRun", ply:GetNWInt("DrGSlowRun") + 1)
	ply:SetJumpPower(0)
	ply:SetNWInt("DrGWeakJumps", ply:GetNWInt("DrGWeakJumps") + 1)
	timer.Simple(math.random(GetConVar("scp1025_asthma_min"):GetInt(), GetConVar("scp1025_asthma_max"):GetInt()), function()
		if ply:GetNWBool("1025Asthma") and ply:Alive() then
			ply:SetNWBool("1025Asthma", false)
			if ply:GetNWInt("DrGSlowRun") == 0 then
				ply:SetRunSpeed(ply:GetNWInt("DrGRunSpeed"))
			end
			if ply:GetNWInt("DrGWeakJumps") == 0 then
				ply:SetJumpPower(ply:GetNWInt("DrGJumpPower"))
			end
			net.Start("AsthmaOver")
			net.Send(ply)
		end
	end)
end

function GiveBlindness(ply)
	ply:SetNWBool("1025Blind", true)
	ply:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255), 1, 86400)
end

function GiveFOP(ply)
	ply:SetNWBool("1025FOP", true)
	ply:Freeze(true)
end

function GiveIgnite(ply)
	ply:SetNWBool("1025Ignite", true)
	timer.Simple(1, function()
		if ply:GetNWBool("1025Ignite") and ply:Alive() then
			ply:Ignite(10, 1)
			local weapons = ply:GetWeapons()
			for _, weap in pairs(weapons) do
				weap:Ignite(10, 1)
			end
		end
	end)
end

function GiveRegenCancer(ply)
	ply:SetNWBool("1025Regen", true)
	local rcval = math.random(1, 10000)
	ply:SetNWInt("1025RegenVal", rcval)
	timer.Simple(math.random(GetConVar("scp1025_regen_min"):GetInt(), GetConVar("scp1025_regen_max"):GetInt()), function()
		if ply:GetNWBool("1025Regen") and ply:Alive() and ply:GetNWInt("1025RegenVal") == rcval then
			ply:SetNWBool("1025RegenDying", true)
			ply:SetRunSpeed(ply:GetWalkSpeed())
			ply:SetNWInt("DrGSlowRun", ply:GetNWInt("DrGSlowRun") + 1)
			ply:SetJumpPower(0)
			ply:SetNWInt("DrGWeakJumps", ply:GetNWInt("DrGWeakJumps") + 1)
			net.Start("RegenCancerDying")
			net.Send(ply)
			timer.Simple(GetConVar("scp1025_regen_left"):GetInt(), function()
				if ply:GetNWBool("1025Regen") and ply:Alive() and ply:GetNWInt("1025RegenVal") == rcval and ply:GetNWBool("1025RegenDying") then
					ply:Kill()
				end
			end)
		end
	end)
end
