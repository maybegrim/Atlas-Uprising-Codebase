-- Define the main STORE table and its sub-table for player-related functions.
STORE = STORE or {}
STORE.PLY = STORE.PLY or {}

-- Check if the code is being executed on the server.
if SERVER then
    -- Load shared roles definitions (both for server and client).
    include("store/sh_roles.lua")
    -- Make sure the roles definitions are also sent to and loaded on the client.
    AddCSLuaFile("store/sh_roles.lua")

    -- Load main server-side store functions.
    include("store/sv_main.lua")

    -- Load server-side player-related functions.
    include("store/player/sv_functions.lua")
    -- Load shared player-related functions (both for server and client).
    include("store/player/sh_functions.lua")
    -- Make sure the shared player functions are also sent to and loaded on the client.
    AddCSLuaFile("store/player/sh_functions.lua")
else
    -- If on client, load the shared roles definitions.
    include("store/sh_roles.lua")
    -- Load shared player-related functions.
    include("store/player/sh_functions.lua")
end
