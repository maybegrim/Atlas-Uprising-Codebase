ATLASQUIZ = ATLASQUIZ or {}
-- [SHARED]
include("quiz/sh_config.lua")

if SERVER then
    AddCSLuaFile("quiz/sh_config.lua")
    include("quiz/sv_quiz.lua")
    AddCSLuaFile("quiz/cl_quiz.lua")
else
    include("quiz/cl_quiz.lua")
end