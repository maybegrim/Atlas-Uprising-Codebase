if CLIENT then
    include("atlas_breach/cl/util.lua")
    include("atlas_breach/cl/menu.lua")
    include("atlas_breach/cl/scp_edit_menu.lua")
    include("atlas_breach/cl/zone_edit_menu.lua")
end

if CLIENT then return end
-- Gameplay
util.AddNetworkString("Atlas_Breach::Interactions")
util.AddNetworkString("Atlas_Breach::PlaySound")
-- Config
util.AddNetworkString("Atlas_Breach::SCPConfig")
util.AddNetworkString("Atlas_Breach::Zones")

AddCSLuaFile("atlas_breach/cl/util.lua")
AddCSLuaFile("atlas_breach/cl/menu.lua")
AddCSLuaFile("atlas_breach/cl/scp_edit_menu.lua")
AddCSLuaFile("atlas_breach/cl/zone_edit_menu.lua")

include("atlas_breach/scp_config.lua")
include("atlas_breach/zone_config.lua")
include("atlas_breach/sv/core.lua")