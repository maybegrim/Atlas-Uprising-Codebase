CHAT_CMDS = CHAT_CMDS or {}

if SERVER then
    AddCSLuaFile("chatcmds/cl_commands.lua")
end
if CLIENT then
    include("chatcmds/cl_commands.lua")
end