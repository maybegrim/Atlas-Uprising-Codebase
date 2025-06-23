include("shared.lua")

function ENT:Draw()
  self:DrawModel()
end

function PlayerReading(disease, ply)
  LocalPlayer():EmitSound("scp1025/read.ogg")
  if disease == "None" then
    chat.AddText("Seems like you already read all pages...")
  else
    chat.AddText("You read information about a disease: "..disease)
  end
end

function cough()
  local sounds = {"cough1.ogg", "cough2.ogg", "cough3.ogg"}
  local sound = sounds[math.random(1, 3)]
  timer.Simple(math.random(1, 2.5), function()
    LocalPlayer():EmitSound("scp1025/"..sound)
  end)
end

net.Receive("PlayerUsed1025", function(len, ply)
  local disease = net.ReadString()
  PlayerReading(disease, ply)
  if disease == "Lung Cancer" then
    chat.AddText("You are coughing up blood and unable to run.")
    cough()
  elseif disease == "Asthma" then
    chat.AddText("Being out of breath prevents you for running or jumping for some time.")
    cough()
  elseif disease == "Appendicitis" then
    chat.AddText("You are feeling too much pain to jump.")
  elseif disease == "Blindness" then
    chat.AddText("Your vision gets darker and darker.")
  elseif disease == "Fibrodysplasia Ossificans Progressiva" then
    chat.AddText("You feel like you are made of stone.")
  elseif disease == "Regenerative Cancer" then
    chat.AddText("You feel like a new man.")
  elseif disease == "Cardiac Arrest" then
    local player = LocalPlayer()
    player:EmitSound("scp1025/heartbeat.ogg")
    timer.Simple(0.3, function()
      player:EmitSound("scp1025/heartbeat.ogg")
    end)
    timer.Simple(0.6, function()
      player:EmitSound("scp1025/heartbeat.ogg")
    end)
    timer.Simple(0.9, function()
      player:EmitSound("scp1025/heartbeat.ogg")
    end)
  end
end)

net.Receive("PlayerUsed1025But714", function(len, ply)
  PlayerReading(net.ReadString(), ply)
end)

net.Receive("AsthmaOver", function(len, ply)
  chat.AddText("Seems like your asthma no longer affects you.")
end)

net.Receive("RegenCancerDying", function(len, ply)
  chat.AddText("You are feeling weaker and weaker.")
end)
