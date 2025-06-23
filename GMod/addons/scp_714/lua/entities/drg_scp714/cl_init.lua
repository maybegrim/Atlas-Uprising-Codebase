include("shared.lua")

function ENT:Draw()
  self:DrawModel()
end

net.Receive("Wearing714", function(len, ply)
  chat.AddText("You are wearing SCP-714.")
  LocalPlayer():EmitSound("scp714/pick.ogg")
end)

net.Receive("714RunJumpFatigue", function(len, ply)
  chat.AddText("You are feeling too tired to run or jump.")
end)

net.Receive("714RunFatigue", function(len, ply)
  chat.AddText("You are feeling too tired to run.")
end)

net.Receive("714JumpFatigue", function(len, ply)
  chat.AddText("You are feeling too tired to jump.")
end)

net.Receive("AlreadyWearing714", function(len, ply)
  chat.AddText("You can't wear another SCP-714.")
  LocalPlayer():EmitSound("scp714/pick.ogg")
end)

net.Receive("Dropped714", function(len, ply)
  if net.ReadBool() then
    chat.AddText("You dropped SCP-714.")
    LocalPlayer():EmitSound("scp714/drop.ogg")
  end
end)

net.Receive("714FatigueKill", function(len, ply)
  chat.AddText("The ring made you unable to stand up. You kept it for too long.")
end)
