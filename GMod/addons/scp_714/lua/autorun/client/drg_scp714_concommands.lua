concommand.Add("drop714", function()
  if LocalPlayer():GetNWBool("Wearing714") then
    if not GetConVar("scp714_removable"):GetBool() then
      chat.AddText("The ring seems to be stuck to your finger.")
    else
      net.Start("Drop714")
      net.SendToServer()
    end
  else
    chat.AddText("You are not wearing SCP-714.")
  end
end)
