AddCSLuaFile()

BaseDefense = BaseDefense or {}

local ClientInclude = SERVER and AddCSLuaFile or include

include("base_defense/sh_config.lua")
include("base_defense/sh_base_defense.lua")
