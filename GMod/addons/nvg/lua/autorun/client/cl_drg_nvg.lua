CreateClientConVar("nvg_color", "0")
CreateClientConVar("nvg_goggle", "1")
CreateClientConVar("nvg_refract", "0")
CreateClientConVar("nvg_refract_value", "0.03")

concommand.Add("dropnvg", function()
  net.Start("DropDrGNVG")
  net.SendToServer()
end)

concommand.Add("toggnvg", function()
  net.Start("ToggleDrGNVG")
  net.SendToServer()
end)
