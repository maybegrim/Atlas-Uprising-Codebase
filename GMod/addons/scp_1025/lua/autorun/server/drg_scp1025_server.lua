util.AddNetworkString("PlayerUsed1025")
util.AddNetworkString("PlayerUsed1025But714")
util.AddNetworkString("AsthmaOver")
util.AddNetworkString("FOP")
util.AddNetworkString("RegenCancerDying")

resource.AddFile("materials/entities/drg_scp1025.png")

function Regen1025()
  if GetConVar("scp1025_regencancer"):GetBool() then
    local players = player.GetAll()
    for _, ply in pairs(players) do
      if ply:GetNWBool("1025Regen") and not ply:GetNWBool("1025RegenDying") then
        local newHealth = ply:Health() + GetConVar("scp1025_regen_amount"):GetInt()
        if newHealth < GetConVar("scp1025_regen_maxhealth"):GetInt() then
          ply:SetHealth(newHealth)
        else
          ply:SetHealth(GetConVar("scp1025_regen_maxhealth"):GetInt())
        end
      end
    end
  end
  timer.Simple(1, Regen1025)
end

Regen1025()

function Cure1025(ply)
	if ply:GetNWBool("1025FOP") then
    ply:Freeze(false)
  end
  if ply:GetNWBool("1025Asthma") then
    ply:SetNWInt("DrGSlowRun", ply:GetNWInt("DrGSlowRun") - 1)
    ply:SetNWInt("DrGWeakJumps", ply:GetNWInt("DrGWeakJumps") - 1)
  end
  if ply:GetNWBool("1025LungCancer") then
    ply:SetNWInt("DrGSlowRun", ply:GetNWInt("DrGSlowRun") - 1)
  end
  if ply:GetNWBool("1025Appendicitis") then
    ply:SetNWInt("DrGWeakJumps", ply:GetNWInt("DrGWeakJumps") - 1)
  end
  if ply:GetNWBool("1025RegenDying") then
    ply:SetNWInt("DrGSlowRun", ply:GetNWInt("DrGSlowRun") - 1)
    ply:SetNWInt("DrGWeakJumps", ply:GetNWInt("DrGWeakJumps") - 1)
  end
	ply:SetNWBool("1025FOP", false)
  ply:SetNWBool("1025LungCancer", false)
  ply:SetNWBool("1025Appendicitis", false)
  ply:SetNWBool("1025Blind", false)
  ply:SetNWBool("1025Asthma", false)
  ply:SetNWBool("1025Cardiac", false)
  ply:SetNWBool("1025Ignite", false)
	ply:SetNWBool("1025Regen", false)
  ply:SetNWBool("1025RegenDying", false)
  ply:SetNWInt("1025RegenVal", 0)
end

hook.Add("PlayerDeath", "1025Symptoms", function(ply)
  Cure1025(ply)
end)

hook.Add("PlayerSilentDeath", "1025SymptomsSilent", function(ply)
  Cure1025(ply)
end)
