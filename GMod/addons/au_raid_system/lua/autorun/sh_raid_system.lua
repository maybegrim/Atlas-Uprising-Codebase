AU = AU or {}
AU.RaidSystem = AU.RaidSystem or {}

include("raid_system/sh_config.lua")
include("raid_system/sh_raid_system.lua")

if SERVER then
    include("raid_system/sv_command.lua")
end