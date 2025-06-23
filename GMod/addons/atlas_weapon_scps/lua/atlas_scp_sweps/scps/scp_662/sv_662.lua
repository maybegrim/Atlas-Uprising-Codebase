ATLAS662.Ply = ATLAS662.Ply or false
ATLAS662.Ent = ATLAS662.Ent or false
ATLAS662.HolderPly = ATLAS662.HolderPly or false
ATLAS662.RingCooldown = ATLAS662.RingCooldown or false
ATLAS662.GrabEnt = ATLAS662.GrabEnt or false
util.AddNetworkString("ATLAS662.Pickup")
util.AddNetworkString("ATLAS662.Ring")
util.AddNetworkString("ATLAS662.Drop")
util.AddNetworkString("ATLAS662.Ringed")
util.AddNetworkString("ATLAS662.Notify.Seen")
util.AddNetworkString("ATLAS662.Notify.CloakNeeded")
util.AddNetworkString("ATLAS662.SpawnItem")
util.AddNetworkString("ATLAS662.Pickup.Notify")
util.AddNetworkString("ATLAS662.Pickup.Complete")
util.AddNetworkString("ATLAS662.Pickup.Time")
util.AddNetworkString("ATLAS662.Notify.ExitNoclip")
util.AddNetworkString("ATLAS662.Notify.ExitCloak")
function ATLAS662.Pickup(ply)
    ATLAS662.HolderPly = ply
    ATLAS662.Ent:Remove()
    ATLAS662.Ent = false
    net.Start("ATLAS662.Pickup")
    net.WriteBool(true)
    net.Send(ply)
end
function ATLAS662.Drop(ply)
    net.Start("ATLAS662.Pickup")
    net.WriteBool(false)
    net.Send(ply)
    ATLAS662.HolderPly = false
    ATLAS662.CreateEnt(ply:GetPos() + Vector(0,20,50))
end

function ATLAS662.CreateEnt(pos)
    ATLAS662.Ent = ents.Create( "scp_662_bell" )
    ATLAS662.Ent:SetModel( "models/662/props/bell.mdl" )
    ATLAS662.Ent:SetPos( pos )
    ATLAS662.Ent:Spawn()
end

function ATLAS662.Deploy(ply)
    ATLAS662.CreateEnt(ATLAS662.Pos)
    ATLAS662.Ply = ply
end

function ATLAS662.UnDeploy()
    ATLAS662.Ply = false
    ATLAS662.Ent:Remove()
    ATLAS662.Ent = false
    ATLAS662.HolderPly = false
    if ATLAS662.GrabEnt then
        ATLAS662.GrabEnt:Remove()
        ATLAS662.GrabEnt = false
    end
end

function ATLAS662.Ring(ply)
    if ply == ATLAS662.Ply then return end
    if isnumber(ATLAS662.RingCooldown) and ATLAS662.RingCooldown > CurTime() then return end
    ATLAS662.RingCooldown = CurTime() + ATLAS662.RingDelay
    net.Start("ATLAS662.Ringed")
    net.WriteEntity(ply)
    net.Send(ATLAS662.Ply)
    ply:EmitSound("hypex/662/bell.mp3")
    ATLAS662.Ply:EmitSound("hypex/662/bell.mp3")
end

function ATLAS662.SpawnGrabEnt(pos, item)
    ATLAS662.GrabEnt = ents.Create( "scp_662_item" )
    ATLAS662.GrabEnt:SetModel( "models/props_junk/cardboard_box003a.mdl" )
    ATLAS662.GrabEnt:SetPos( pos )
    ATLAS662.GrabEnt:Spawn()
    ATLAS662.GrabEnt:SetEnt(ATLAS662.Items[item].itemid, ATLAS662.Items[item].elixir)
    timer.Simple(1, function()
        net.Start("ATLAS662.Pickup.Notify")
        net.WriteVector(ATLAS662.GrabEnt:GetPos())
        net.Send(ATLAS662.Ply)
    end)
end

hook.Add("PlayerChangedTeam", "ATLAS.SCP662.Deploy", function(ply, old, new)
    if team.GetName(new) == ATLAS662.TeamName then
        ATLAS662.Deploy(ply)
    end
    if team.GetName(old) == ATLAS662.TeamName then
        ATLAS662.UnDeploy()
    end
end)
hook.Add("DoPlayerDeath", "ATLAS.SCP662.DropBellOnDeath", function(ply)
    if ply == ATLAS662.HolderPly then
        ATLAS662.Drop(ply)
    end
end)
hook.Add("canDropWeapon", "ATLAS.SCP662.Drop", function(ply, ent)
    if ply ~= ATLAS662.Ply then return end
    if ATLAS662.Items[ent:GetClass()] then
        return true
    end
end)
hook.Add("PlayerDisconnected", "ATLAS.SCP662.Disconnect", function(ply)
    if ply ~= ATLAS662.Ply then return end
    ATLAS662.UnDeploy()
end)

net.Receive("ATLAS662.Drop", function(_, ply)
    if ply ~= ATLAS662.HolderPly then return end
    ATLAS662.Drop(ply)
end)
net.Receive("ATLAS662.Ring", function(_, ply)
    if ply ~= ATLAS662.HolderPly then return end
    ATLAS662.Ring(ply)
end)
net.Receive("ATLAS662.SpawnItem", function(_, ply)
    if ply ~= ATLAS662.Ply then return end
    local item = net.ReadString()
    if ATLAS662.Items[item] and ply:GetNWFloat("ATLAS662.ItemCooldown."..item, 0) < CurTime() then
        ply:SetNWFloat("ATLAS662.ItemCooldown."..item, CurTime() + ATLAS662.ItemCooldown)
        ATLAS662.SpawnGrabEnt(ATLAS662.Items[item].pos, item)
    end
end)

-- SWEP CODE
function ATLAS662.Cloak(ply)
    ply:SetNWBool("ATLAS662.Cloaked", true)
    ply:SetNoDraw(true)
    ply:DrawWorldModel(false)
    ply:SetRenderMode(RENDERMODE_TRANSALPHA)
    ply:Fire("alpha", 0, 0)
end

function ATLAS662.UnCloak(ply)
    ply:SetNWBool("ATLAS662.Cloaked", false)
    ply:SetNoDraw(false)
    ply:DrawWorldModel(true)
    ply:SetRenderMode(RENDERMODE_NORMAL)
    ply:Fire("alpha", 255, 0)
    ATLAS662.UnNoclip(ply)
end

function ATLAS662.Noclip(ply)
    if not ply:GetNWBool("ATLAS662.Cloaked") then
        net.Start("ATLAS662.Notify.CloakNeeded")
        net.Send(ply)
        return
    end
    ply:SetMoveType( MOVETYPE_NOCLIP )
    ply:SetNWBool("ATLAS662.NoClipped", true)
end

function ATLAS662.UnNoclip(ply)
    ply:SetMoveType( MOVETYPE_WALK )
    ply:SetNWBool("ATLAS662.NoClipped", false)
end

hook.Add("PlayerDeath", "ATLAS.SCP662.Drop", function(ply)
    if ply == ATLAS662.Ply then
        ply:SetNWBool("ATLAS662.Cloaked", false)
        ply:SetNWBool("ATLAS662.NoClipped", false)
    end
end)