ATLASSCPSWEPS = ATLASSCPSWEPS or {}
SCP035 = SCP035 or {}
ATLAS662 = ATLAS662 or {}
if SERVER then
    -- Load Configurations
    include("atlas_scp_sweps/configuration/sh_swepvars.lua")
    AddCSLuaFile("atlas_scp_sweps/configuration/sh_swepvars.lua")

    -- Load SCP-106 code
    include("atlas_scp_sweps/scps/scp_106/sv_main.lua")
    AddCSLuaFile("atlas_scp_sweps/scps/scp_106/cl_main.lua")

    -- Load SCP-682 code
    include("atlas_scp_sweps/scps/scp_682/sv_main.lua")
    AddCSLuaFile("atlas_scp_sweps/scps/scp_682/cl_main.lua")

    -- Load SCP-035 code
    include("atlas_scp_sweps/scps/scp_035/sh_config.lua")
    include("atlas_scp_sweps/scps/scp_035/sv_035.lua")
    AddCSLuaFile("atlas_scp_sweps/scps/scp_035/sh_config.lua")
    AddCSLuaFile("atlas_scp_sweps/scps/scp_035/cl_035.lua")

    -- Load SCP-662 code
    include("atlas_scp_sweps/scps/scp_662/sh_config.lua")
    include("atlas_scp_sweps/scps/scp_662/sv_662.lua")
    AddCSLuaFile("atlas_scp_sweps/scps/scp_662/sh_config.lua")
    AddCSLuaFile("atlas_scp_sweps/scps/scp_662/cl_662.lua")
elseif CLIENT then
    -- Load Configurations
    include("atlas_scp_sweps/configuration/sh_swepvars.lua")

    -- Load SCP-106 code
    include("atlas_scp_sweps/scps/scp_106/cl_main.lua")

    -- Load SCP-682 code
    include("atlas_scp_sweps/scps/scp_682/cl_main.lua")

    -- Load SCP-035 code
    include("atlas_scp_sweps/scps/scp_035/sh_config.lua")
    include("atlas_scp_sweps/scps/scp_035/cl_035.lua")

    -- Load SCP-662 code
    include("atlas_scp_sweps/scps/scp_662/sh_config.lua")
    include("atlas_scp_sweps/scps/scp_662/cl_662.lua")
end