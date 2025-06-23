SCP035.Ply = SCP035.Ply or false
SCP035.ConsumedPly = SCP035.ConsumedPly or false
SCP035.Mask = SCP035.Mask or false
SCP035.PreConsumedPly = SCP035.PreConsumedPly or {hp = false, armor = false, maxhp = false, maxarmor = false}
SCP035.Answeree = SCP035.Answeree or false
SCP035.CleanupPos = SCP035.CleanupPos or false
SCP035.Boxed = SCP035.Boxed or false
SCP035.BoxEnt = SCP035.BoxEnt or false
util.AddNetworkString("ATLAS.SCP035.Add")
util.AddNetworkString("ATLAS.SCP035.Del")
util.AddNetworkString("ATLAS.SCP035.SubjectAdd")
util.AddNetworkString("ATLAS.SCP035.SubjectDel")
util.AddNetworkString("ATLAS.SCP035.Consumed")
util.AddNetworkString("ATLAS.SCP035.StaffSitNotify")
util.AddNetworkString("ATLAS.SCP035.Kill")
--util.AddNetworkString("ATLAS.SCP035.Lure")
util.AddNetworkString("ATLAS.SCP035.Answer")
util.AddNetworkString("ATLAS.SCP035.Inform")
util.AddNetworkString("ATLAS.SCP035.EyeLock")
util.AddNetworkString("ATLAS.SCP035.UnEyeLock")
util.AddNetworkString("ATLAS.SCP035.Success")
util.AddNetworkString("ATLAS.SCP035.Failure")
util.AddNetworkString("ATLAS.SCP035.Left")
util.AddNetworkString("ATLAS.SCP035.DeConsumed")
util.AddNetworkString("ATLAS.SCP035.BroadcastTarget")
local function InformPly(ply, chatTextArgs)
    net.Start("ATLAS.SCP035.Inform")
    net.WriteTable(chatTextArgs)
    net.Send(ply)
end

function SCP035.Add(ply)
    SCP035.Ply = ply
    ply:StripWeapons()
    ply:Give(SCP035.HandsSwep)

    net.Start("ATLAS.SCP035.Add")
    net.Send(ply)
end
function SCP035.Del(ply)
    ply:UnSpectate()
    if SCP035.Boxed then
        SCP035.Unbox(SCP035.BoxEnt, true)
    end
    if SCP035.ConsumedPly then
        SCP035.DeConsume(SCP035.ConsumedPly)
    end
    SCP035.Ply = false
    if SCP035.Mask and SCP035.Mask ~= NULL and SCP035.Mask:GetClass() == "scp_035" then SCP035.Mask:Remove() end
    SCP035.Mask = false
    net.Start("ATLAS.SCP035.Del")
    net.Send(ply)
    if SCP035.ConsumedPly then
        net.Start("ATLAS.SCP035.Left")
        net.Send(SCP035.ConsumedPly)
        SCP035.DeConsume(SCP035.ConsumedPly)
    end
    timer.Simple(1, function() ply:Spawn() end)

    net.Start("ATLAS.SCP035.BroadcastTarget")
    net.Broadcast()
end
function SCP035.Redeploy(ply)
    ply:Spectate( OBS_MODE_CHASE )
    ply:SpectateEntity( SCP035.Mask )
    ply:StripWeapons()
    ply:Give(SCP035.HandsSwep)
end
function SCP035.Lure(ply, target)
    SCP035.Answeree = target
    --[[net.Start("ATLAS.SCP035.Lure")
    net.Send(target)]]
    ATLASQUIZ.QuizPly(target, _, function(pPly, result)
        print(result)
        if result then
            SCP035.Success(pPly)
        else
            SCP035.Failed(pPly)
        end
    end)
end
function SCP035.Success(ply)
    SCP035.Answeree = false

    --[[net.Start("ATLAS.SCP035.Inform")
        net.WriteBool(true)
    net.Send(SCP035.Ply)]]
    InformPly(SCP035.Ply, {Color(255, 0, 0), "SCP-035 has failed lured ", Color(0, 255, 0), ply:Nick(), Color(255, 0, 0), " to the mask."})

    net.Start("ATLAS.SCP035.Success")
    net.Send(ply)
end
function SCP035.Failed(ply)
    SCP035.Answeree = false
    ply.Is035Lured = true

    --[[net.Start("ATLAS.SCP035.Inform")
    net.WriteBool(false)
    net.Send(SCP035.Ply)]]

    InformPly(SCP035.Ply, {Color(255, 0, 0), "SCP-035 has lured ", Color(0, 255, 0), ply:Nick(), Color(255, 0, 0), " to the mask."})

    net.Start("ATLAS.SCP035.EyeLock")
    net.WriteEntity(SCP035.Mask)
    net.Send(ply)

    net.Start("ATLAS.SCP035.Failure")
    net.Send(ply)

    timer.Create("035.ForcedPickup", SCP035.ForcedPickup, 1, function()
        if SCP035.ConsumedPly then return end
        if SCP035.BoxEnt and SCP035.BoxEnt ~= NULL then SCP035.Unbox(SCP035.BoxEnt) end
        SCP035.Consume(ply)
    end)
end
function SCP035.Consume(ply)
    SCP035.ConsumedPly = ply
    net.Start("ATLAS.SCP035.BroadcastTarget")
        net.WriteEntity(ply)
    net.Broadcast()

    net.Start("ATLAS.SCP035.Consumed")
    net.Send(ply)
    SCP035.Ply:Spectate( OBS_MODE_CHASE )
    SCP035.Ply:SpectateEntity( ply )
    if SCP035.Mask and SCP035.Mask ~= NULL and SCP035.Mask:GetClass() == "scp_035" then SCP035.Mask:Remove() end
    SCP035.Mask = false
    SCP035.PreConsumedPly.hp = ply:Health()
    SCP035.PreConsumedPly.armor = ply:Armor()
    SCP035.PreConsumedPly.maxhp = ply:GetMaxHealth()
    SCP035.PreConsumedPly.maxarmor = ply:GetMaxArmor()
    SCP035.SetHP(ply, SCP035.HP)
    SCP035.SetArmor(ply, SCP035.Armor)
    ply.Is035Lured = false
    net.Start("ATLAS.SCP035.SubjectAdd")
    net.Send(SCP035.Ply)
end

function SCP035.LostLure(ply)
    if timer.Exists("035.ForcedPickup") then
        timer.Remove("035.ForcedPickup")
    end
    ply.Is035Lured = false
    net.Start("ATLAS.SCP035.UnEyeLock")
    net.Send(ply)

    InformPly(SCP035.Ply, {Color(255, 0, 0), "SCP-035 has lost ", Color(0, 255, 0), ply:Nick(), Color(255, 0, 0), " from the mask."})
end

function SCP035.DeConsume(ply)
    SCP035.SetHP(ply, SCP035.PreConsumedPly.maxhp)
    SCP035.SetArmor(ply, SCP035.PreConsumedPly.armor)
    if SCP035.Ply and SCP035.Ply ~= NULL and SCP035.Ply:IsPlayer() then
        net.Start("ATLAS.SCP035.SubjectDel")
        net.Send(SCP035.Ply)
    end
    net.Start("ATLAS.SCP035.DeConsumed")
    net.Send(ply)
    net.Start("ATLAS.SCP035.BroadcastTarget")
    net.Broadcast()
    SCP035.ConsumedPly = false
end
function SCP035.Deploy(ply)
    SCP035.BuildMask(ply, SCP035.Pos)
    SCP035.Add(ply)
    timer.Simple(0.1, function()
        ply:Spawn()
    end)
end
function SCP035.BuildMask(ply, pos)
    if SCP035.Mask and SCP035.Mask ~= NULL and SCP035.Mask:GetClass() == "scp_035" then SCP035.Mask:Remove() end
    SCP035.Mask = ents.Create( "scp_035" )
    SCP035.Mask:SetModel( SCP035.Model )
    SCP035.Mask:SetPos( pos )
    SCP035.Mask:Spawn()
    ply:Spectate( OBS_MODE_CHASE )
    ply:SpectateEntity( SCP035.Mask )
end
function SCP035.SetHP(ply, value)
    ply:SetHealth(value)
    ply:SetMaxHealth(value)
end
function SCP035.SetArmor(ply, value)
    ply:SetArmor(value)
    ply:SetMaxArmor(value)
end
function SCP035.Box(ent)
    if SCP035.Boxed then return end
    SCP035.Boxed = true
    SCP035.Ply:Spectate( OBS_MODE_CHASE )
    SCP035.Ply:SpectateEntity( ent )
    SCP035.Mask:Remove()
    SCP035.Mask = false
    ent:SetColor(Color(255,56,56))
    SCP035.BoxEnt = ent
    timer.Create("SCP035.BoxDeterioration." .. tostring(math.Round(math.random(1, 100))), SCP035.BoxDeterioration, 1, function()
        SCP035.Unbox(ent)
        ent:EmitSound( "physics/cardboard/cardboard_box_impact_soft5.wav" )
        local effectdata = EffectData()
        effectdata:SetOrigin( ent:GetPos() )
        util.Effect( "Explosion", effectdata )
        ent:Remove()
    end)
end
function SCP035.Unbox(ent, doNotBuildMask)
    if not SCP035.Boxed then return end
    if ent ~= SCP035.BoxEnt then return end
    SCP035.Boxed = false
    SCP035.BoxEnt = false
    ent:SetColor(Color(255,255,255))
    if doNotBuildMask then return end
    SCP035.BuildMask(SCP035.Ply, ent:GetPos() + Vector(0, 0, 10))
end
hook.Add("PlayerChangedTeam", "ATLAS.SCP035.Deploy", function(ply, old, new)
    if team.GetName(new) == SCP035.JobName then
        SCP035.Deploy(ply)
        return
    end

    if team.GetName(old) == SCP035.JobName then
        SCP035.Del(ply)
    end
    if ply == SCP035.ConsumedPly then
        SCP035.BuildMask(SCP035.Ply, ply:GetPos())
    end
    -- if boxed then remove
end)
hook.Add("PlayerSpawn", "ATLAS.SCP035.Respawn", function(ply)
    if ply == SCP035.Ply then
        timer.Simple(1, function()
            SCP035.Redeploy(ply)
        end)
    end
end)
hook.Add("PlayerDisconnected", "ATLAS.SCP035.Disconnect", function(ply)
    if ply == SCP035.Ply then
        SCP035.Del(ply)
    end
    if ply == SCP035.ConsumedPly then
        SCP035.BuildMask(SCP035.Ply, ply:GetPos())
    end
end)
hook.Add("DoPlayerDeath", "ATLAS.SCP035.ConsumedDeath", function(ply)
    if ply == SCP035.ConsumedPly then
        SCP035.BuildMask(SCP035.Ply, ply:GetPos())
        SCP035.DeConsume(ply)
        if timer.Exists("035.ForcedPickup") then
            timer.Remove("035.ForcedPickup")
        end
    end
end)
hook.Add("PlayerDeath", "ATLAS.SCP035.Death", function(ply)
    -- if lured player and isn't consumed then lets fix this
    if ply.Is035Lured then
        SCP035.LostLure(ply)
    end
end)
hook.Add( "PlayerUse", "ATLAS.SCP035.BlockUse", function( ply, ent )
    if ply == SCP035.Ply then
        return false
    end
end )
hook.Add("PlayerCanHearPlayersVoice", "ATLAS.SCP035.Voice", function(listener, talker)
    if SCP035.ConsumedPly and SCP035.ConsumedPly == listener and talker == SCP035.Ply then
        return true
    elseif SCP035.ConsumedPly and SCP035.Ply == talker and SCP035.ConsumedPly ~= listener then
        return false
    end

end)
SCP035.LastPos = false
hook.Add("SAM.RanCommand", "ATLAS.SCP035.SAM.Support", function(ply, cmd_name, args, cmd, result)
    if cmd_name == "bring" and sam.player.find_by_name(args[1]) == SCP035.Ply then
        if SCP035.ConsumedPly then
            SCP035.LastPos = SCP035.ConsumedPly:GetPos()
            SCP035.BuildMask(SCP035.Ply, ply:EyePos() + Vector(25, 1, 1))
            net.Start("ATLAS.SCP035.StaffSitNotify")
            net.Send(SCP035.ConsumedPly)
            SCP035.DeConsume(SCP035.ConsumedPly)
            net.Start("ATLAS.SCP035.SubjectDel")
            net.Send(SCP035.Ply)
            return
        end
        SCP035.LastPos = SCP035.Mask:GetPos()
        SCP035.Mask:SetPos( ply:EyePos() + Vector(25, 1, 1) )
    end
    if args[1] == nil then return end
    if cmd_name == "return" and sam.player.find_by_name(args[1]) == SCP035.Ply then
        SCP035.Mask:SetPos( SCP035.LastPos + Vector(0, 0, 5) )
    end
end)

hook.Add("PreCleanupMap", "ATLAS.SCP035.PreCleanup", function()
    if SCP035.ConsumedPly then return end
    SCP035.CleanupPos = SCP035.Mask:GetPos()
end)
hook.Add("PostCleanupMap", "ATLAS.SCP035.PostCleanup", function()
    if SCP035.ConsumedPly then return end
    if not SCP035.CleanupPos then return end
    SCP035.BuildMask(SCP035.Ply, SCP035.CleanupPos)
end)

net.Receive("ATLAS.SCP035.Kill", function(_, ply)
    if ply ~= SCP035.Ply then return end
    if not SCP035.ConsumedPly then return end
    SCP035.ConsumedPly:Kill()
end)
net.Receive("ATLAS.SCP035.Answer", function(_, ply)
    local answer = net.ReadString()
    local question = net.ReadString()
    if answer == "FAILED" then
        SCP035.Failed(ply)
        return
    end
    if SCP035.Math[question].answers[answer] then
        SCP035.Success(ply)
    else
        SCP035.Failed(ply)
    end
end)
net.Receive("ATLAS.SCP035.SubjectAdd", function(_, ply)
    if ply ~= SCP035.Ply then return end
    if SCP035.Answeree then return end
    if SCP035.Boxed then return end
    local target = net.ReadEntity()
    if target:GetPos():Distance(ply:GetPos()) < 600 and not SCP035.BlacklistedTeams[target:Team()] then
        SCP035.Lure(ply, target)
    end
    timer.Simple(SCP035.AnswerLimit + 1, function() SCP035.Answeree = false end)
end)

-- Make it so 035 box don't collide with doors
local DoorBlacklist = {
    ["models/foundation/doors/lcz_door.mdl"] = true,
}
local TriggerEnts = {
    ["prop_dynamic"] = true,
    ["prop_door_rotating"] = true,
    ["func_door"] = true,
    ["func_door_rotating"] = true,
}
-- hook to make it so this entity does not collide with doors
hook.Add("ShouldCollide", "SCP035ShouldCollide", function(ent1, ent2)
    if ent1:GetClass() == "scp_035_box" or ent2:GetClass() == "scp_035_box" then
        if TriggerEnts[ent1:GetClass()] or TriggerEnts[ent2:GetClass()] then
            return false
        end
        if DoorBlacklist[ent1:GetModel()] or DoorBlacklist[ent2:GetModel()] then
            return false
        end
    end
end)