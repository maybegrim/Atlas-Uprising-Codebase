util.AddNetworkString("BD.DeathCam")
RunConsoleCommand("ai_serverragdolls", 1)

local bdtab = {
    ["exp"] = {
        "deathrunning_09",
        "deathrunning_10",
        "deathrunning_11a",
        "deathrunning_11e",
        "deathrunning_11b",
        "deathrunning_11c",
        "DeathExplosion_01",
        "DeathExplosion_02",
        "DeathExplosion_03",
        "DeathExplosion_04",
        "DeathExplosion_05",
        "DeathExplosion_06",
        "DeathExplosion_07",
        "DeathExplosion_08",
    },
    ["club"] = {
        "club1",
        "club2",
        "club3",
        "club4",
        "bd_death_slasher_front",
        "bd_death_slasher_left",
        "bd_death_slasher_right",
        "bd_death_slasher_back",
    },
    ["moving"] = {
        "deathrunning_01",
        "deathrunning_03",
        "deathrunning_04",
        "deathrunning_05",
        "deathrunning_06",
        "deathrunning_07",
        "deathrunning_08",
        "deathrunning_11d",
        "deathrunning_11f",
        "deathrunning_11g",
        "deathrunning_12",
        "deathrunning_13",
        "deathrunning_14",
        "deathrunning_15",
        "deathrunning_16",
    },
    ["dying"] = {
        "death_01",
        "death_02a",
        "death_02c",
        "death_03",
        "death_05",
        "death_06",
        "death_07",
        "death_08",
        "death_08b",
        "death_09",
        "death_10ab",
        "death_10b",
        "death_10c",
        "death_11_01a",
        "death_11_01b",
        "death_11_02a",
        "death_11_02b",
        "death_11_02c",
        "death_11_02d",
        "death_11_03a",
        "death_11_03b",
        "death_11_03c",
        "dying1",
        "dying2",
        "dying3",
        "dying4",
        "dying5",
        "dying6",
        "dying7",
        "bd_death_leg_01",
        "bd_death_leg_02",
        "bd_death_leg_03",
        "bd_death_leg_04",
        "bd_death_leg_05",
        "bd_death_leg_06",
        "bd_death_leg_07",
        "bd_death_leg_08",
        "bd_death_legs_01",
    },
    ["bd_torso"] = {
        "bd_death_torso_long_01",
        "bd_death_torso_long_02",
        "bd_death_torso_long_03",
        "bd_death_torso_short_01",
        "bd_death_torso_short_02",
        "bd_death_torso_short_03",
        "bd_death_torso_short_04",
        "bd_death_torso_short_05",
        "bd_death_torso_short_06",
        "bd_death_torso_short_07",
        "bd_death_torso_short_08",
        "bd_death_torso_short_09",
        "bd_death_torso_short_10",
        "bd_death_torso_short_11",
        "bd_death_torso_short_12",
        "bd_death_torso_short_13",
        "bd_death_torso_short_14",
        "bd_death_torso_short_15",
        "bd_death_torso_short_16",
        "bd_death_torso_short_17",
        "bd_death_torso_short_18",
        "bd_death_torso_short_19",
        "bd_death_torso_short_20",
        "bd_death_torso_short_21",
        "bd_death_stomach_multi_01",
        "bd_death_stomach_single_01",
        "bd_death_stomach_single_02",
        "bd_death_stomach_short_01",
        "bd_death_stomach_short_02",
        "cod_1_torso_1",
        "cod_1_torso_2",
        "cod_1_torso_3",
        "cod_1_torso_4",
        "cod_1_torso_5",
        "cod_1_torso_6",
        "cod_1_torso_7",
    },
    ["bd_head"] = {
        "bd_death_head_01",
        "bd_death_head_02",
        "bd_death_head_03",
        "bd_death_head_04",
        "bd_death_head_05",
        "bd_death_head_07",
        "bd_death_head_08",
        "bd_death_head_multi_01",
        "bd_death_head_multi_02",
        "bd_death_head_multi_03",
        "bd_death_head_single_01",
        "bd_death_head_single_02",
        "bd_death_head_single_03",
        "bd_death_head_short_01",
        "bd_death_head_short_02",
        "bd_death_head_short_03",
    },
    ["bd_neck"] = {
        "bd_death_neck_short_01",
        "bd_death_neck_short_02",
        "bd_death_neck_short_03",
        "bd_death_neck_short_04",
    },
    ["bd_larm"] = {
        "bd_death_leftarm_multi_01",
        "bd_death_leftarm_multi_02",
        "bd_death_leftarm_multi_03",
        "bd_death_leftarm_multi_04",
        "bd_death_leftarm_single_01",
        "bd_death_leftarm_single_02",
        "bd_death_leftarm_single_03",
        "bd_death_leftarm_short_01",
        "bd_death_leftarm_short_02",
        "bd_death_leftarm_short_03",
    },
    ["bd_rarm"] = {
        "bd_death_rightarm_01",
        "bd_death_rightarm_02",
        "bd_death_rightarm_multi_01",
        "bd_death_rightarm_multi_02",
        "bd_death_rightarm_single_01",
        "bd_death_rightarm_single_02",
        "bd_death_rightarm_single_03",
        "bd_death_rightarm_single_04",  
    },
    ["bd_lleg"] = {
        "bd_death_leftleg_long_01",
        "bd_death_leftleg_long_02",
        "bd_death_leftleg_short_01",
        "bd_death_leftleg_short_02",
        "bd_death_leftleg_short_03",
        "bd_death_leftleg_short_04",
        "bd_death_leftleg_short_05",
        "bd_death_leftleg_short_06",
        "bd_death_leftleg_short_07",
        "bd_death_leftleg_short_08",
    },
    ["bd_rleg"] = {
        "bd_death_rightleg_multi_01",
        "bd_death_rightleg_multi_02",
        "bd_death_rightleg_multi_03",
        "bd_death_rightleg_short_01",
        "bd_death_rightleg_short_02",
        "bd_death_rightleg_single_01",
        "bd_death_rightleg_single_02",
        "bd_death_rightleg_single_03",
        "bd_death_rightleg_single_04",
        "bd_death_rightleg_single_05",
    },
}

local EnableNPCs = CreateConVar("bd_enable_npcs", 0,  FCVAR_ARCHIVE, "", 0, 1)
local EnablePlayers = CreateConVar("bd_enable_players", 1,  FCVAR_ARCHIVE, "", 0, 1)
local LifeScale = CreateConVar("bd_life_scale", 1,  FCVAR_ARCHIVE, "", 0)
local CrawlChance = CreateConVar("bd_crawl_chance", 10,  FCVAR_ARCHIVE, "", 0, 100)
local ClubAsDefault = CreateConVar("bd_club_as_default", 0,  FCVAR_ARCHIVE, "", 0, 1)
local OtherAsDefault = CreateConVar("bd_other_as_default", 0,  FCVAR_ARCHIVE, "", 0, 1)
local FaceExp = CreateConVar("bd_face_expression", 1,  FCVAR_ARCHIVE, "", 0, 1)
local DebugType = CreateConVar("bd_debug_force_type", "none",  FCVAR_ARCHIVE)

local function choose_bd_anims(type, data)
    local anim = "dying1"
    local model = "models/brutal_deaths/model_anim.mdl"
    if DebugType:GetString() != "none" then
        type = DebugType:GetString()
    end
    if type == "fire" then
        anim = "bd_death_fire"..math.random(1,2)
    elseif type == "explosion" then
        anim = table.Random(bdtab["exp"])
    elseif type == "club" then
        anim = table.Random(bdtab["club"])
    elseif type == "crawling" then
        anim = "crawling"..math.random(6,7)
    elseif type == "moving" then
        anim = table.Random(bdtab["moving"])
    else
        anim = table.Random(bdtab["dying"])
        -------------------------------------
        if data[1] == 1 then
            if data[2] then
                anim = table.Random(bdtab["bd_neck"]) 
            else
                anim = table.Random(bdtab["bd_head"]) 
            end
        elseif data[1] == 2 or data[1] == 3 then
            anim = table.Random(bdtab["bd_torso"])
        elseif data[1] == 4 then
            anim = table.Random(bdtab["bd_larm"]) 
        elseif data[1] == 5 then
            anim = table.Random(bdtab["bd_rarm"]) 
        elseif data[1] == 6 then
            anim = table.Random(bdtab["bd_lleg"]) 
        elseif data[1] == 7 then
            anim = table.Random(bdtab["bd_rleg"]) 
        end
    end
    return anim, model
end

local function play_anim_on_rag(rag, an, scale)
    if !IsValid(rag) then return end

    local tr2 = util.TraceLine( {
        start = rag:GetPos(),
        endpos = rag:GetPos()-Vector(0,0,50),
        mask = MASK_ALL,
        filter = function(ent) 
            return ent != rag.AnimModule and ent != rag
        end
    })
    local pos = tr2.HitPos+Vector(0,0,2)

    if IsValid(rag.AnimModule) then
        rag.AnimModule:Remove()
    end
    local anim, mod = choose_bd_anims(an)
    local anm = ents.Create("hari_ragdoll_animation")
    anm:SetPos(pos)
    anm:SetAngles(rag:GetAngles())
    if an == "crawling" then
        anm:SetAngles(rag:GetAngles()+Angle(0,math.random(-45,45),0))
        if FaceExp:GetBool() then
            rag:SetFlexScale( math.random( -2 , 2 ) )
            for i = 1, 32 do	
                rag:SetFlexWeight( i , math.Rand( 0 , 1 ) )
            end
        end
    end
    anm:Spawn()
    anm.Ragdoll = rag
    anm.Entity = nil
    anm:SetModel(mod)
    anm:ResetSequence(anim)
    anm.AnimString = anim
    anm.LerpScale = scale
    anm.FinishFunc = function()
        timer.Simple(0.01, function()
            if !IsValid(anm) then return end
            if an == "crawling" and math.random(1,4) >= 2 then
                play_anim_on_rag(rag, "crawling", 0.8)
            end
        end)
    end

    rag.IsDeathRagdoll = true
    rag.RagHealth = rag.MaxRagHealth
    rag.AnimModule = anm
end

local function make_death_anim(ent, rag, type)
    local data = {ent.LastDamageHitgroup, ent.LastDamageIsNeck}
    local anim, mod = choose_bd_anims(type, data)
    local anm = ents.Create("hari_ragdoll_animation")
    anm:SetPos(ent:GetPos())
    anm:SetAngles(ent:GetAngles())
    anm:Spawn()
    anm.Ragdoll = rag
    -- set owner of rag
    rag:SetOwner(ent)
    ent:SetNWEntity("DeathRagdoll", rag)
    anm.Entity = nil
    anm:SetModel(mod)
    anm:ResetSequence(anim)
    anm.FinishFunc = function()
        if !IsValid(rag) then return end
        if FaceExp:GetBool() then
            rag:SetFlexScale( math.random( -2 , 2 ) )
            for i = 1, 32 do	
                rag:SetFlexWeight( i , math.Rand( 0 , 1 ) )
            end
        end
    end
    local dur = select(2, anm:LookupSequence(anim))

    -- no collide ragdoll
    rag:SetCollisionGroup(COLLISION_GROUP_WORLD)

    if FaceExp:GetBool() then
        rag:SetFlexScale( math.random( -2 , 2 ) )	
        for i = 1, 32 do
            rag:SetFlexWeight( i , math.Rand( 0 , 1 ) )
        end
    end

    if type == "fire" then
        rag:Ignite(30)
    end
    if type == "bullet" or type == "slash" then
        timer.Simple(dur+math.Rand(2,8), function()
            if !IsValid(rag) or rag.RagHealth <= 0 or math.random(1,100) > CrawlChance:GetFloat() then return end
            play_anim_on_rag(rag, "crawling", 0.5)
        end)
    end
    rag.IsDeathRagdoll = true
    rag.NPCClass = ent.GetNPCClass and ent:GetNPCClass() or ent.Classify and ent:Classify() or CLASS_BULLSEYE
    rag.RagHealth = ent:GetMaxHealth()*LifeScale:GetFloat()
    rag.MaxRagHealth = rag.RagHealth
    rag.AnimModule = anm
    local physcount = rag:GetPhysicsObjectCount()
    for i = 0, physcount - 1 do
        local physObj = rag:GetPhysicsObjectNum(i)
        local pos, ang = ent:GetBonePosition(ent:TranslatePhysBoneToBone(i))
        if pos && ang then
            physObj:EnableMotion(true)
        end
    end
end

hook.Add("ScaleNPCDamage", "DeathAnimsBrutal", function(ent,hit, dmg)
	ent.LastDamageHitgroup = hit
    if ent:LookupBone("ValveBiped.Bip01_Head1") then
        ent.LastDamageIsNeck = dmg:GetDamagePosition().z < ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Head1")).z
    end
end)

hook.Add("ScalePlayerDamage", "DeathAnimsBrutal", function(ent,hit, dmg)
	ent.LastDamageHitgroup = hit
    if ent:LookupBone("ValveBiped.Bip01_Head1") then
        ent.LastDamageIsNeck = dmg:GetDamagePosition().z < ent:GetBonePosition(ent:LookupBone("ValveBiped.Bip01_Head1")).z
    end
end)
hook.Add("PlayerDeath", "DeathAnim::Suicide", function(victimPly, inflictor, attackerPly)
    if victimPly == attackerPly then
        victimPly.DeathAnimType = "slash"
    end
end)
hook.Add("EntityTakeDamage", "DeathAnimsBrutal", function(ent, dmg)
    if ent.IsDeathRagdoll then
        ent.RagHealth = ent.RagHealth - dmg:GetDamage()
        if ent.RagHealth <= 0 and IsValid(ent.AnimModule) then
            ent.AnimModule:Remove()
        end
    end

    if ent:IsNPC() or ent:IsPlayer() then
        if dmg:GetDamageType() == DMG_BURN or ent:IsOnFire() then
            ent.DeathAnimType = "fire"
        elseif (dmg:GetDamageType() == 0 and !OtherAsDefault:GetBool()) or isfunction(ent.IsDowned) and ent:IsDowned() then
            ent.DeathAnimType = "bullet"
        elseif dmg:IsExplosionDamage() or dmg:GetDamageType() == DMG_BLAST then
            ent.DeathAnimType = "explosion"
        elseif ent:IsOnGround() and (ent:IsPlayer() and ent:GetVelocity():Length() > ent:GetWalkSpeed() or ent:IsNPC() and ent:GetIdealMoveSpeed() > 200) then
            ent.DeathAnimType = "moving"
        elseif dmg:IsBulletDamage() then
            ent.DeathAnimType = "bullet"
        elseif (dmg:GetDamageType() == DMG_CLUB or dmg:GetDamageType() == DMG_CRUSH) and !ClubAsDefault:GetBool() then
            ent.DeathAnimType = "club"
        elseif dmg:GetDamageType() == DMG_SLASH or (dmg:GetDamageType() == DMG_CLUB or dmg:GetDamageType() == DMG_CRUSH) and ClubAsDefault:GetBool() then
            ent.DeathAnimType = "slash"
        else
            ent.DeathAnimType = "bullet"
        end
    end
end)

hook.Add("PlayerSpawn", "DeathAnimsBrutal", function(ply)
    if EnablePlayers:GetBool() then 
        ply:SetShouldServerRagdoll(true)
        ply.DeathAnimType = nil
        local deathRagdoll = ply:GetNWEntity("DeathRagdoll")
        if IsValid(deathRagdoll) then
            deathRagdoll:Remove()
        end
    end
end)

hook.Add("PostPlayerDeath","DeathAnimsBrutal", function(ply)
	local defaultRagdoll = ply:GetRagdollEntity()
	if ( defaultRagdoll && defaultRagdoll:IsValid() and EnablePlayers:GetBool() ) then defaultRagdoll:Remove() end
end)

local enabletime = true
--[[hook.Add("OnNPCKilled", "DeathAnimsBrutal", function(ent, att)
    if ent:IsNPC() and EnableNPCs:GetBool() and !GetConVar("ai_serverragdolls"):GetBool() and att:IsPlayer() and enabletime then
        att:ChatPrint("BETTER ENABLE KEEP CORPSES TO GET BEST WORKING ON NPC DEATH ANIMS")
        enabletime = false
    end
end)]]

hook.Add("PlayerDisconnected", "DeathAnimsBrutal:REMOVEDISCONNECT", function(ply)
    local deathRagdoll = ply:GetNWEntity("DeathRagdoll")
    if IsValid(deathRagdoll) then
        deathRagdoll:Remove()
    end
end)

hook.Add("CreateEntityRagdoll", "DeathAnimsBrutal", function(ent, rag)
    if ent:IsPlayer() then
        if !EnablePlayers:GetBool() then 
            ent:Remove() 
            return
        end
        net.Start("BD.DeathCam")
            net.WriteInt(rag:EntIndex(), 32)
        net.Send(ent)
    end
    if ent:IsNPC() then return end
    if ent.DeathAnimType then
        local physcount = rag:GetPhysicsObjectCount()
        for i = 0, physcount - 1 do
            local physObj = rag:GetPhysicsObjectNum(i)
            local pos, ang = ent:GetBonePosition(ent:TranslatePhysBoneToBone(i))
            if pos && ang then
                physObj:EnableMotion(false)
            end
        end
        make_death_anim(ent, rag, ent.DeathAnimType)
    end
end)