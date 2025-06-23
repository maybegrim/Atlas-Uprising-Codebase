if SERVER then
    util.AddNetworkString("AU.BombCollar.Tamper")
    util.AddNetworkString("AU.BombCollar.EndTamper")
    util.AddNetworkString("AU.BombCollar.Trigger")
    util.AddNetworkString("AU.BombCollar.Toggle")

    net.Receive("AU.BombCollar.Tamper", function (len, ply)
        local collared_ply = net.ReadEntity()

        if not IsValid(collared_ply) or not collared_ply:IsPlayer() or not collared_ply:HasBombCollar() or not collared_ply:IsCollarDiffusible() then return end

        if not ply:Alive() then return end

        --[[ALGEBRA.MultiQuiz(ply, 6, 10, function (_, success)
            if not success then
                collared_ply:ExplodeCollar()
            else
                collared_ply:EmitSound("doors/vent_open1.wav")
            end

            collared_ply:SetBombCollar(false)

            net.Start("AU.BombCollar.EndTamper")
            net.Send(ply)
        end)]]
        -- ATLASQUIZ.QuizPly(ply, customParams, callback)
        ATLASQUIZ.QuizPly(ply, _, function (ply, success)
            if not success then
                collared_ply:ExplodeCollar()
            else
                collared_ply:EmitSound("doors/vent_open1.wav")
            end

            collared_ply:SetBombCollar(false)

            net.Start("AU.BombCollar.EndTamper")
            net.Send(ply)
        end)
    end)

    net.Receive("AU.BombCollar.Trigger", function (len, ply)
        local collared_ply = net.ReadEntity()

        if not IsValid(collared_ply) or not collared_ply:IsPlayer() or not collared_ply:HasBombCollar() then return end
        
        if collared_ply:HasBombCollar() then
            collared_ply:ExplodeCollar()
            collared_ply:SetBombCollar(false)
        end

        net.Start("AU.BombCollar.EndTamper")
        net.Send(ply)

        ATLASQUIZ.OutOfTime(ply)
    end)

    net.Receive("AU.BombCollar.Toggle", function (len, ply)
        ply:SetCollarDiffusible(not ply:IsCollarDiffusible())
    end)

    function AU.BombCollar.ExplodeCollar(ply)
        local effect_data = EffectData()
        effect_data:SetScale(2)
        effect_data:SetMagnitude(512)
        effect_data:SetOrigin(ply:EyePos())

        util.Effect("Explosion", effect_data)

        local targets = ents.FindInSphere(ply:EyePos(), AU.BombCollar.ExplosionRadius)

        for _,target in ipairs(targets) do
            if IsValid(target) and target:IsPlayer() then
                local damage_info = DamageInfo()
                damage_info:SetDamage(AU.BombCollar.DamageCurve(target:GetPos():Distance(ply:GetPos())))
                damage_info:SetDamageType(DMG_BLAST)
                damage_info:SetReportedPosition(ply:GetPos())
                damage_info:SetAttacker(ply)
                damage_info:SetInflictor(ply)

                target:TakeDamageInfo(damage_info)
            end
        end
    end
end

if CLIENT then
    local next_tamper = CurTime()
    local tampering = false
    local collared = Entity(0)

    hook.Add("KeyPress", "AU.BombCollar.Tamper", function (ply, key)
        if next_tamper > CurTime() then return end
        next_tamper = CurTime() + 1.0

        if key == IN_USE then
            local trace = ply:GetEyeTrace()

            if not IsValid(trace.Entity) or not trace.Entity:IsPlayer() or not trace.Entity:HasBombCollar() or not trace.Entity:IsCollarDiffusible() or trace.HitPos:DistToSqr(ply:EyePos()) > 10000 then return end

            net.Start("AU.BombCollar.Tamper")
                net.WriteEntity(trace.Entity)
            net.SendToServer()
            
            tampering = true
            collared = trace.Entity
        elseif key == IN_RELOAD then
            local ply = LocalPlayer()

            if ply:HasBombCollar() then
                net.Start("AU.BombCollar.Toggle")
                net.SendToServer()
            end
        end
    end)

    net.Receive("AU.BombCollar.EndTamper", function ()
        tampering = false
    end)

    hook.Add("Think", "AU.BombCollar.DistanceTrigger", function ()
        if tampering then
            if LocalPlayer():GetPos():DistToSqr(collared:GetPos()) > 12000 then
                net.Start("AU.BombCollar.Trigger")
                    net.WriteEntity(collared)
                net.SendToServer()
                
                tampering = false
            end
        end
    end)
end