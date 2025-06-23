if CLIENT then return end
function makefx(ent1, pos, str, ent2, broadcast)
	net.Start("defibfx")
	net.WriteEntity(ent1)
	net.WriteVector(pos)
	net.WriteString(str)
	net.WriteEntity(ent2)
	if broadcast then net.Broadcast()
	else net.Send(ent2) end
end

function PlayerDied(ply)
	makefx(ply, Vector(0, 0, 0), "decharge", ply, false)
	local defib = weapons.GetStored("weapon_defibrillator")
	if defib.GiveWeaponsBack then
		ply.DefibWeps = {}
		for k,v in pairs(ply:GetWeapons()) do
			wepClass = v:GetClass()
			if wepClass == "au_held_hub_crate" then continue end
			table.insert(ply.DefibWeps, wepClass)
		end
	end
	if defib.DeathBeepEnabled then
		makefx(ply, Vector(0, 0, 0), "sound", ply, false)
	end
	ply.TimeDied = CurTime()
	makefx(ply, Vector(0, 0, 0), "timedied", ply, true)
end

function PlayerSpawned(ply)
	if ply.DefibRagdoll then
		ply.DefibWeps = {}
	end
	ply.DefibJustSpawned = true
	timer.Simple(5, function() 
		if (IsValid(ply)) then
			ply.DefibJustSpawned = nil
		end
	end)
end

hook.Add("DoPlayerDeath", "defibhandledeath", PlayerDied)

hook.Add("PlayerSpawn", "defibhandlespawn", PlayerSpawned)

hook.Add("PlayerDeathSound", "defibmakedeath", function() return !weapons.Get("weapon_defibrillator").DeathBeepEnabled end)

hook.Add("DoPlayerDeath", "playerDeadByExplosionAdvert", function(ply, attacker, dmg)
	if dmg:IsDamageType(DMG_BLAST) then
		ply:Say("/advert [RP] Has died due to explosives.")
	end
end)

net.Receive("defibgiveents", function(len, ply)
    local weapon = ply:GetActiveWeapon()
    local isRevive, otherPly, pos = net.ReadBool(), net.ReadEntity(), net.ReadVector()
    local eyetrace = ply:GetEyeTraceNoCursor()

    if not otherPly:IsPlayer() then otherPly = otherPly:GetOwner() end
    if not IsValid(ply) or not IsValid(otherPly) or not otherPly:IsPlayer() then return end
    if not IsValid(weapon) or weapon:GetClass() ~= "weapon_defibrillator" then return end
    if not pos or (pos:Distance(ply:GetShootPos()) > weapon.HitDistance) then return end

    if ply.LastDefibUse and ply.LastDefibUse > CurTime() then return end
    ply.LastDefibUse = CurTime() + 2

    weapon:EmitSound("weapons/physcannon/superphys_small_zap"..math.random(1,4)..".wav")
    weapon.CanUse = 0
    weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    weapon:SetNextSecondaryFire(CurTime() + 2)
    makefx(ply, Vector(0, 0, 0), "decharge", ply, false)
    hook.Call("customhq.defib.onPlayerInteraction", nil, ply, otherPly, isRevive, pos)

    if isRevive then
        if (otherPly.TimeDied + weapon.TimeToRevive) - CurTime() < 0 then
            makefx(ply, Vector(1, 1, 1), "toolongdead", ply, false)
            makefx(ply, Vector(0, 0, 0), "toolongdead", otherPly, false)
            return
        end

        makefx(otherPly, otherPly:GetPos(), "spark", otherPly, true)

        timer.Simple(0.3, function()
            if not IsValid(otherPly) or otherPly:Alive() then return end
            otherPly:SetNWBool("Defibed", true)
            ply:Say("/advert [RP] Has revived " .. otherPly:Nick())
            otherPly:Spawn()
            otherPly:SetCollisionGroup(COLLISION_GROUP_WEAPON)
            otherPly:SetPos(eyetrace.HitPos + eyetrace.HitNormal * 16)
            otherPly:SetHealth(weapon.HPAfterRespawn)

            if weapon.GiveWeaponsBack then
                for k, v in pairs(otherPly.DefibWeps) do otherPly:Give(v) end
            end

            otherPly:SetRenderMode(RENDERMODE_TRANSALPHA)
            otherPly:SetColor(Color(255, 255, 255, 125))
        end)

        timer.Simple(weapon.GhostTime, function()
            if not IsValid(otherPly) then return end
            otherPly:SetCollisionGroup(COLLISION_GROUP_NONE)
            otherPly:SetColor(Color(255, 255, 255, 255))
        end)
    else
        makefx(ply, ply:GetEyeTrace().HitPos, "spark", ply, true)
        otherPly:TakeDamage(weapon.Damage)
    end
    ply:SetAnimation(PLAYER_ATTACK1)
end)
