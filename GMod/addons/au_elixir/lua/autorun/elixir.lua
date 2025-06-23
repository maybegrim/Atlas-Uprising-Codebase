AddCSLuaFile()

Elixir = Elixir or {}

local ClientInclude = SERVER and AddCSLuaFile or include

function Elixir.RegisterItem(id, data)
    Elixir.Items = Elixir.Items or {}
    Elixir.Items[id] = data
end

function Elixir.AddRecipe(data)
    Elixir.Recipes = Elixir.Recipes or {}
    table.insert(Elixir.Recipes, data)
end

include("elixir/sh_config.lua")
include("elixir/sh_elixir.lua")
include("elixir/sh_commands.lua")
include("elixir/sv_player.lua")

ClientInclude("elixir/cl_inventory.lua")
ClientInclude("elixir/cl_vgui.lua")

if SERVER then
    include("elixir/sv_recipes.lua")

    hook.Add("PlayerDeath", "Atlas.Elixirs.RemoveInv", function(ply)
        Elixir.ClearInventory(ply)
    end)
end

hook.Add("InitPostEntity", "AU.Elixir.Ready", function ()
    hook.Run("Elixir.FinishLoad")
end)

local files = file.Find("elixir/ext/*.lua", "LUA")

for _,f in ipairs(files) do
    AddCSLuaFile("elixir/ext/" .. f)
    include("elixir/ext/" .. f)
end