ATLASCORE = ATLASCORE or {}
if SERVER then
    include("atlascore/server/sv_playernetworking.lua")
    AddCSLuaFile("atlascore/client/cl_playernetworking.lua")

    include("atlascore/shared/sh_util.lua")
    AddCSLuaFile("atlascore/shared/sh_util.lua")

    include("atlascore/shared/sh_sendchat.lua")
    AddCSLuaFile("atlascore/shared/sh_sendchat.lua")

    include("atlascore/server/sv_errordetection.lua")

    include("atlascore/shared/sh_default_terms.lua")
    AddCSLuaFile("atlascore/shared/sh_default_terms.lua")
elseif CLIENT then
    include("atlascore/client/cl_playernetworking.lua")

    include("atlascore/shared/sh_util.lua")

    include("atlascore/shared/sh_sendchat.lua")

    include("atlascore/shared/sh_default_terms.lua")
end