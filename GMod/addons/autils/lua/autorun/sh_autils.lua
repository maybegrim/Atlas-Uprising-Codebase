AddCSLuaFile()

local ClientInclude = SERVER and AddCSLuaFile or include

autil = autil or {}

include("autils/sh_spawnutils.lua")
include("autils/sh_color.lua")
include("autils/sh_nwtable.lua")
include("autils/sh_verifytable.lua")
include("autils/sh_formatmessage.lua")
include("autils/sh_vgui.lua")

if CLIENT then
    hook.Add("InitPostEntity", "AUtils.NWTableReady", function ()
        net.Start("AUtils.NetworkReady")
        net.SendToServer()
    end)
else
    util.AddNetworkString("AUtils.NetworkReady", function (len, ply)
        hook.Run("AUtilClientNetworkReady", ply)
    end)
end

hook.Run("AUtilFinishLoad")