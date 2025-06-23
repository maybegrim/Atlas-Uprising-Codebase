ATLASPROPS = ATLASPROPS or {}


include("props/sh_config.lua")
if SERVER then
    AddCSLuaFile("props/sh_config.lua")
    AddCSLuaFile("props/modules/prop_count/cl_propcount.lua")
    include("props/modules/prop_count/sv_propcount.lua")
    include("props/modules/prop_ghost/sv_propghost.lua")
    include("props/modules/prop_givephysgun/sv_givephysgun.lua")
else
    include("props/modules/prop_count/cl_propcount.lua")
end