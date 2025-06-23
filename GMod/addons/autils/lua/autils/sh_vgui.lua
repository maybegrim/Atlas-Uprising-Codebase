AddCSLuaFile()

local ClientInclude = SERVER and AddCSLuaFile or include

for _,vgui_element in ipairs(file.Find("autils/vgui/*.lua", "LUA")) do
    ClientInclude("autils/vgui/" .. vgui_element)
end