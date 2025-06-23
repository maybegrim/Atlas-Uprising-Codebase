CHARACTER = {}

if SERVER then
    AddCSLuaFile("character/sh_char_config.lua")
    AddCSLuaFile("character/sh_character.lua")
    AddCSLuaFile("character/cl_character.lua")
    include("character/sh_char_config.lua")
    include("character/sv_character.lua")
    include("character/sh_character.lua")

    -- UI Load
    --AddCSLuaFile("character/ui/cl_ui_charscreen.lua")
    AddCSLuaFile("character/ui/cl_character_ui.lua")
    AddCSLuaFile("character/ui/cl_character_creation.lua")
    AddCSLuaFile("character/ui/cl_character_choice.lua")


    -- Load UI Modules
    AddCSLuaFile("character/ui/modules/fonts.lua")
    AddCSLuaFile("character/ui/modules/derma.lua")
    AddCSLuaFile("character/ui/modules/warning.lua")
    AddCSLuaFile("character/ui/modules/loading.lua")
    AddCSLuaFile("character/ui/modules/dialog.lua")
    AddCSLuaFile("character/ui/modules/models.lua")
elseif CLIENT then
    include("character/sh_char_config.lua")
    include("character/sh_character.lua")
    include("character/cl_character.lua")

    -- UI Load
    --include("character/ui/cl_ui_charscreen.lua")
    include("character/ui/cl_character_ui.lua")
    include("character/ui/cl_character_creation.lua")
    include("character/ui/cl_character_choice.lua")
end