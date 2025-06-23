function NCS_INFILTRATOR.AddText(receivers, ...)
    if SERVER then
        net.Start("NCS_INFILTRATOR.AddText")
            net.WriteTable({...})
        net.Send(receivers)
    else
        chat.AddText(...)

        surface.PlaySound("common/talk.wav")
    end
end

function NCS_INFILTRATOR.PlaySound(client, snd)
    if !IsValid(client) or !snd then
        return
    end
    
    if SERVER then
        net.Start("NCS_INFILTRATOR.PlaySound")
            net.WriteString(snd)
        net.Send(client)
    else
        surface.PlaySound(snd)
    end
end

if CLIENT then
    net.Receive("NCS_INFILTRATOR.PlaySound", function()
        local SND = net.ReadString()

        surface.PlaySound(SND)
    end)

    net.Receive("NCS_INFILTRATOR.AddText", function()
        chat.AddText(unpack(net.ReadTable()))

        surface.PlaySound("common/talk.wav")
    end)
else
    util.AddNetworkString("NCS_INFILTRATOR.PlaySound")
    util.AddNetworkString("NCS_INFILTRATOR.AddText")
end

local pMeta = FindMetaTable("Player")
local oldName = pMeta.Name
local oldTeam = pMeta.Team
local oldDarkRPVar = pMeta.getDarkRPVar

function pMeta:Name()
    if NCS_INFILTRATOR.INFILTRATORS[self] then
        return NCS_INFILTRATOR.INFILTRATORS[self].newName
    end

    return oldName(self)
end

function pMeta:Team()
    if NCS_INFILTRATOR.INFILTRATORS[self] then
        return NCS_INFILTRATOR.INFILTRATORS[self].newJob
    end

    return oldTeam(self)
end

function pMeta:getDarkRPVar(stringVar)
    if NCS_INFILTRATOR.INFILTRATORS[self] then
        if stringVar == "job" then
            return team.GetName(NCS_INFILTRATOR.INFILTRATORS[self].newJob)
        end
    end

    return oldDarkRPVar(self, stringVar)
end

if CLIENT then
    hook.Add( "InitPostEntity", "NCS_INFILTRATOR_PlayerReadyForNetworking", function()
        if !IsValid(LocalPlayer()) then return end

        net.Start( "NCS_INFILTRATOR_PlayerReadyForNetworking" )
        net.SendToServer()
    end )
else 
    local NETWORKED = {}

    util.AddNetworkString( "NCS_INFILTRATOR_PlayerReadyForNetworking" )

    net.Receive( "NCS_INFILTRATOR_PlayerReadyForNetworking", function( len, ply )
        if NETWORKED[ply] then
            ply:Kick()
            return
        end

        NETWORKED[ply] = true

        hook.Run("NCS_INFILTRATOR_PlayerReadyForNetworking", ply)
    end )
end

hook.Add( "PlayerFootstep", "NCS_INFILTRATOR_DisableFootstep", function( ply)
    if CLIENT then
        if ply:GetRenderMode() == RENDERMODE_TRANSALPHA and (ply ~= LocalPlayer()) then
            return true
        end
    else
        if ply:GetRenderMode() == RENDERMODE_TRANSALPHA then
            return true
        end
    end

end )