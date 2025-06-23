util.PrecacheSound("npc/attack_helicopter/aheli_mine_drop1.wav") -- diring shield deployer sound
util.PrecacheSound("buttons/combine_button_locked.wav") -- cooldown still active alert
util.PrecacheSound("npc/scanner/combat_scan5.wav") --cooldown over sound
game.AddParticles("vortigaunt_fx.pcf")
util.AddNetworkString("shieldnotifyau")
util.AddNetworkString("shieldnotifyau2")

util.AddNetworkString("SCP774:ActivateShield")

local function forceShieldDeploy(ply)
    if !IsValid(ply) then return end
    if team.GetName( ply:Team() ) == "SCP-774-ATL 'Aegis'" then
    ply.active_aug1_cooldown = ply.active_aug1_cooldown or CurTime()
    ply.emitSoundCooldown = ply.emitSoundCooldown or CurTime() 
    local augJustFired = false --This is required so it doesnt play the cooldown sound when firing
    if(CurTime() <= ply.active_aug1_cooldown) then
        net.Start("shieldnotifyau")
        net.Send(ply)
        return 
    end
    if(CurTime() >= ply.active_aug1_cooldown) then
        augJustFired = true --Were firing so the augment will have been fired at the end of this if block
        timer.Simple(.1,function()-- .1 seconds from this timer, set augJustFired back to false
            augJustFired = false
        end)
        ply.active_aug1_cooldown = CurTime() + 65
        timer.Simple(65, function() --Play a sound when cooldown is over
            ply:EmitSound("npc/scanner/combat_scan5.wav", 40) 
        end)
        ply:EmitSound("npc/attack_helicopter/aheli_mine_drop1.wav",35)

        if SERVER then
            local shieldDeployer = ents.Create("shield_deployer")
                local _shieldDeployAngleYaw = ply:GetEyeTrace().Normal:Angle().yaw
                shieldDeployer.shieldDeployAngleYaw = _shieldDeployAngleYaw
                shieldDeployer:SetPos(ply:GetPos() + Vector(0,0,48))
                shieldDeployer:SetAngles(ply:GetAngles())
                shieldDeployer:Spawn()
                local shieldDeployerPhys = shieldDeployer.phys -- GET THIS AFTER SPAWNING AND ACTIVATING NEXT TIME DICK ED
                shieldDeployer:Activate()
        
            if(shieldDeployer:GetPhysicsObject():IsValid() && ply:IsValid()) then 
                shieldDeployerPhys:SetVelocityInstantaneous(ply:EyeAngles():Forward() * 500)  
            end
        end
        
        ply:ViewPunch( Angle( -4, 0, 0 ) )
    end
    --if the augment had just fired, wed better not play the cooldown sound
    --in addition, if the the users emitsoundcooldown isn't dont, we better not play the sound
    if(!augJustFired and CurTime() >= ply.emitSoundCooldown) then 
        ply.emitSoundCooldown = CurTime() + 2.5
        ply:EmitSound("buttons/combine_button_locked.wav",35)
    end
    net.Start("shieldnotifyau2")
    net.Send(ply)
    end
end

net.Receive("SCP774:ActivateShield", function(len, ply)
    forceShieldDeploy(ply)
end)

hook.Add( "PlayerInitialSpawn", "ClearShieldCoolDown", function( ply, transition)
    if transition == true then
        ply.active_aug1_cooldown = 0
        ply.emitSoundCooldown = 0
    end
end )

hook.Add("CW_canPenetrate", "forceshieldpenetrate", function(ent, traceData, direction)
    if (ent:GetModel() == "models/ovr_load/force_shield.mdl") then
		return false
	end
end)