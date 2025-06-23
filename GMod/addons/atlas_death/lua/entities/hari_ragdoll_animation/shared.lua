AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Ragdoll"
ENT.AutomaticFrameAdvance = true

if CLIENT then

end

local tab = file.Find("addons/brutal_deaths/1/rise_animations_anims/*", "GAME")
local str = ""
for _, v in pairs(tab) do
    str = str..[[
$sequence "]]..v..[[" {
    "rise_animations_anims\]]..v..[["
    fadein 0.5
    fadeout 0.5
    fps 30
}
        

]]
end
file.Write("fqwdq.txt", str)