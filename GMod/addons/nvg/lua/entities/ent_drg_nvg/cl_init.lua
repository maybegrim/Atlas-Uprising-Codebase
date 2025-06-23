include("shared.lua")

function ENT:Draw()
  self:DrawModel()
end

local function GenDynLight(color)
  local dlight = DynamicLight(963001)
  if dlight then
    if color == 1 then --red
      dlight.r = 60
      dlight.g = 0
      dlight.b = 0
    elseif color == 2 then --blue
      dlight.r = 0
      dlight.g = 0
      dlight.b = 60
    elseif color == 3 then --purple
      dlight.r = 30
      dlight.g = 0
      dlight.b = 30
    elseif color == 4 then --yellow
      dlight.r = 30
      dlight.g = 30
      dlight.b = 0
    elseif color == 5 then --turquoise
      dlight.r = 0
      dlight.g = 30
      dlight.b = 30
    elseif color == 6 then --orange
      dlight.r = 45
      dlight.g = 15
      dlight.b = 0
    elseif color == 7 then --white
      dlight.r = 20
      dlight.g = 20
      dlight.b = 20
    else --green
      dlight.r = 0
      dlight.g = 60
      dlight.b = 0
    end
  end
  return dlight
end

local function GetColorTab(color)
  local tab = {
    ["$pp_colour_brightness"] = 0.75,
    ["$pp_colour_contrast"] = 1,
    ["$pp_colour_colour"] = 0.15,
    ["$pp_colour_mulr"] = 0,
    ["$pp_colour_mulg"] = 0,
    ["$pp_colour_mulb"] = 0
  }
  if color == 1 then --red
    tab["$pp_colour_addr"] = 0
    tab["$pp_colour_addg"] = -1
    tab["$pp_colour_addb"] = -1
  elseif color == 2 then --blue
    tab["$pp_colour_addr"] = -1
    tab["$pp_colour_addg"] = -1
    tab["$pp_colour_addb"] = 0
  elseif color == 3 then --purple
    tab["$pp_colour_addr"] = -0.5
    tab["$pp_colour_addg"] = -1
    tab["$pp_colour_addb"] = -0.5
  elseif color == 4 then --yellow
    tab["$pp_colour_addr"] = -0.5
    tab["$pp_colour_addg"] = -0.5
    tab["$pp_colour_addb"] = -1
  elseif color == 5 then --turquoise
    tab["$pp_colour_addr"] = -1
    tab["$pp_colour_addg"] = -0.5
    tab["$pp_colour_addb"] = -0.5
  elseif color == 6 then --orange
    tab["$pp_colour_addr"] = -0.25
    tab["$pp_colour_addg"] = -0.75
    tab["$pp_colour_addb"] = -1
  elseif color == 7 then --white
    tab["$pp_colour_addr"] = -0.66
    tab["$pp_colour_addg"] = -0.66
    tab["$pp_colour_addb"] = -0.66
  else --green
    tab["$pp_colour_addr"] = -1
    tab["$pp_colour_addg"] = 0
    tab["$pp_colour_addb"] = -1
  end
  return tab
end

hook.Add("RenderScreenspaceEffects", "DrGNVGFilter", function()
  local ply = LocalPlayer()
  if ply:GetNWBool("ActiveDrGNVG") then
    local tr = ply:GetEyeTraceNoCursor()
    DrawMaterialOverlay("drg_nvg/drg_nvg.vmt", 0)
    DrawMaterialOverlay("drg_nvg/drg_nvg2.vmt", 0)
    DrawColorModify(GetColorTab(GetConVar("nvg_color"):GetInt()))
    if GetConVar("nvg_refract"):GetBool() then
      DrawMaterialOverlay("models/props_c17/fisheyelens.vmt", GetConVar("nvg_refract_value"):GetFloat())
    end
    DrawSharpen(1, 1)
    if GetConVar("nvg_goggle"):GetBool() then
      DrawMaterialOverlay("drg_nvg/drg_nvg_goggle.vmt", 0)
    end
  end
end)

hook.Add("Think", "DrGNVGLight", function()
  local ply = LocalPlayer()
  if ply:GetNWBool("ActiveDrGNVG") then
    local tr = ply:GetEyeTraceNoCursor()
  	local dlight = GenDynLight(GetConVar("nvg_color"):GetInt())
    if dlight then
      dlight.pos = tr.StartPos - tr.Normal*15
  		dlight.brightness = 1
      dlight.size = 10000
  		dlight.decay = 10000
  		dlight.dieTime = CurTime() + 1
      dlight.style = 0
    end
  end
end)

net.Receive("DropDrGNVG", function(len)
  if net.ReadBool() then
    chat.AddText("You dropped your night vision goggles")
    LocalPlayer():EmitSound("drg_nvg/drop.ogg")
  end
end)

net.Receive("ToggleDrGNVG", function(len)
  local ply = LocalPlayer()
  ply:ScreenFade(1, color_black, 2, 0.2)
  if net.ReadBool() then
    if not ply:GetNWBool("ActiveDrGNVG") then
      ply:EmitSound("items/nvg_on.wav")
    else
      ply:EmitSound("items/nvg_off.wav")
    end
  end
end)

net.Receive("WearingDrGNVG", function(len)
  chat.AddText("You are wearing night vision goggles.")
  LocalPlayer():EmitSound("drg_nvg/drop.ogg")
end)

net.Receive("NotWearingDrGNVG", function(len)
  chat.AddText("You are not wearing night vision goggles.")
end)

net.Receive("AlreadyWearingDrGNVG", function(len)
  chat.AddText("You are already wearing night vision goggles.")
  LocalPlayer():EmitSound("drg_nvg/drop.ogg")
end)
