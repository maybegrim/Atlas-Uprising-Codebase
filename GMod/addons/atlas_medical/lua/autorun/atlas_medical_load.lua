ATLASMED = ATLASMED or {}
ATLASMED.BONES = ATLASMED.BONES or {}
if SERVER then
    -- CORE
    include("medical/defibs/sv_net.lua")

    -- BONE SYSTEM
    include("medical/systems/bones/sh_bones.lua")
    include("medical/systems/bones/sv_bones.lua")
    AddCSLuaFile("medical/systems/bones/cl_bones.lua")
    AddCSLuaFile("medical/systems/bones/sh_bones.lua")


    -- SECOND CHANCE SYSTEM
    include("medical/systems/second_chance/sv_sc.lua")
    AddCSLuaFile("medical/systems/second_chance/cl_sc.lua")
else
    
    include("medical/systems/second_chance/cl_sc.lua")
    include("medical/systems/bones/cl_bones.lua")
    include("medical/systems/bones/sh_bones.lua")
end