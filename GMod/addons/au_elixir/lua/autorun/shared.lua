AddCSLuaFile()

Elixir = Elixir or {}

local ClientInclude = SERVER and AddCSLuaFile or include

include("elixir/sh_config.lua")
include("elixir/sh_elixir.lua")
include("elixir/sh_commands.lua")
include("elixir/sv_player.lua")

ClientInclude("elixir/cl_inventory.lua")
ClientInclude("elixir/cl_vgui.lua")

if SERVER then
    include("elixir/sv_recipes.lua")
end