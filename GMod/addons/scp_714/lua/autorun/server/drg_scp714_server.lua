util.AddNetworkString("Wearing714")
util.AddNetworkString("AlreadyWearing714")
util.AddNetworkString("Drop714")
util.AddNetworkString("Dropped714")
util.AddNetworkString("714RunJumpFatigue")
util.AddNetworkString("714RunFatigue")
util.AddNetworkString("714JumpFatigue")
util.AddNetworkString("714FatigueKill")

resource.AddFile("materials/entities/drg_scp714.png")

function Drop714(ply, normal)
  ply:SetNWBool("Wearing714", false)
  ply:SetNWInt("714KillVal", 0)
  net.Start("Dropped714")
  net.WriteBool(normal)
  net.Send(ply)
  if GetConVar("scp714_disable_running"):GetBool() then
    ply:SetNWInt("DrGSlowRun", ply:GetNWInt("DrGSlowRun") - 1)
  end
  if GetConVar("scp714_disable_jumping"):GetBool() then
    ply:SetNWInt("DrGWeakJumps", ply:GetNWInt("DrGWeakJumps") - 1)
  end
  if ply:GetNWInt("DrGSlowRun") == 0 then
    ply:SetRunSpeed(ply:GetNWInt("DrGRunSpeed"))
  end
  if ply:GetNWInt("DrGWeakJumps") == 0 then
    ply:SetJumpPower(ply:GetNWInt("DrGJumpPower"))
  end
  local ring = ents.Create("drg_scp714")
  if not ring:IsValid() then return end
  ring:SetPos(ply:GetPos() + Vector(0, 0, 1))
  ring:Spawn()
	ring:Activate()
end

net.Receive("Drop714", function(len, ply)
  if not ply:GetNWBool("Wearing714") then return end
  Drop714(ply, true)
end)

hook.Add("PlayerDeath", "Drop714Death", function(ply)
  if (ply:GetNWBool("Wearing714")) then
    Drop714(ply, false)
  end
end)

hook.Add("PlayerSilentDeath", "Drop714SilentDeath", function(ply)
  if (ply:GetNWBool("Wearing714")) then
    Drop714(ply, false)
  end
end)

function Regen714()
  local players = player.GetAll()
  for _, ply in pairs(players) do
    if ply:GetNWBool("Wearing714") and GetConVar("scp714_regen") then
      local newHealth = ply:Health() + GetConVar("scp714_regen_amount"):GetInt()
      if newHealth < GetConVar("scp714_regen_maxhealth"):GetInt() then
        ply:SetHealth(newHealth)
      else
        ply:SetHealth(GetConVar("scp714_regen_maxhealth"):GetInt())
      end
    end
  end
  timer.Simple(1, Regen714)
end

Regen714()
