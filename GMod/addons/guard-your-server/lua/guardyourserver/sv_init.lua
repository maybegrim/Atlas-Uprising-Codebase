--[[
    CREDITS:
    Atlas Uprising
]]
GYS = {} -- Default GYS Var
GYS.AG = {} -- ActiveGuard GYS Var
GYS.GYP = {} -- GuardYourPlayer GYS Var
print("[GYS] Loading...")
-- Load Core
include("guardyourserver/sv_config.lua")
include("guardyourserver/sv_functions.lua")

-- Load Tables
include("guardyourserver/tables/sv_exploitlist.lua")

-- Load Modules
include("guardyourserver/modules/rootguard/sv_rootguard.lua")
include("guardyourserver/modules/npcguard/sv_npcguard.lua")
include("guardyourserver/modules/banevasion/sv_banevasion.lua")
include("guardyourserver/modules/antiexploit/sv_antiexploit.lua")
include("guardyourserver/modules/weaponguard/sv_weaponguard.lua")
include("guardyourserver/modules/ulx/sv_luarun.lua")
include("guardyourserver/modules/activeguard/sv_activeguard.lua")
include("guardyourserver/modules/sandbox/sv_sandbox.lua")
include("guardyourserver/modules/antiban/sv_antiban.lua")
include("guardyourserver/modules/netlogger/sv_netlogger.lua")
include("guardyourserver/modules/datalog/sv_datalog.lua")
include("guardyourserver/modules/awarn/sv_awarn.lua")
include("guardyourserver/modules/guardyourplayer/sv_ipguard.lua")
include("guardyourserver/modules/guardyourplayer/sv_luaguard.lua")
include("guardyourserver/modules/antioverload/sv_antioverload.lua")
AddCSLuaFile("guardyourserver/modules/guardyourplayer/cl_luaguard.lua")

-- Load Integrations
include("guardyourserver/integrations/trixter/sv_discord.lua")
include("guardyourserver/integrations/plogs/gys.lua")
include("guardyourserver/integrations/squish/squish.lua")

print("[GYS] Loaded!")