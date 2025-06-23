local NLRPaused = false
local TotalNLRTime = 120

hook.Add("SAMLoaded", "AddNLRPauseCommand", function()
    sam.command.new("pausenlr")
        :SetPermission("admin", "admin") -- Adjust the permission level as needed
        :Help("Pauses or unpauses NLR logic.")
        :OnExecute(function(ply)
            NLRPaused = not NLRPaused -- Toggle the NLRPaused state
            local state = NLRPaused and "paused" or "resumed"
            sam.player.send_message(nil, "NLR has been " .. state .. " by " .. ply:Nick())
        end)
        :End()
end)

hook.Add("PlayerDeath", "ShowDeathTimerOnDeath", function(victim, inflictor, attacker)
    if NLRPaused then return end
        
    if victim == attacker then return end
    
    if IsValid(attacker) and attacker:IsPlayer() then
        if IsValid(victim) and victim:IsPlayer() then

            local attackerJob = attacker:getJobTable().isSCP
            if attackerJob then return end

            victim:SetNWInt("NLR", TotalNLRTime)
        end
    end
end)

local function getJobIndex(ply)
    local jobTable = ply:getJobTable()
    local jobName = jobTable.name
    local jobIndex = nil 

    for index, job in pairs(RPExtraTeams) do
        if job.name == jobName then
            jobIndex = index
            break
        end
    end

    return jobIndex
end

hook.Add("PlayerSpawn", "NLRRespawnCheckDefibs", function(ply)
    local SpawnPoints = team.GetSpawnPoints(getJobIndex(ply))
    local plyPos = ply:GetPos()
    local plyDefibed = ply:GetNWBool("Defibed", false)

    if SpawnPoints then
        for _, CurPoint in ipairs(SpawnPoints) do
            if plyPos:Distance(CurPoint) < 10 then
                plyDefibed = false
                break
            end
        end
    end

     if plyDefibed then
        ply:SetNWInt("NLR", 0)
        ply:SetNWBool("Defibed", false)
     end
end)

timer.Create("GlobalNLRTimer", 1, 0, function()
    for _, ply in ipairs(player.GetAll()) do
        local nlrTime = ply:GetNWInt("NLR", -1)
        if nlrTime and nlrTime > 0 then
            ply:SetNWInt("NLR", nlrTime - 1)
        elseif nlrTime == 0 then
            ply:SetNWInt("NLR", nil)
        end
    end
end)

if CLIENT then
    local function RealX(x)
        return (x / 3440) * ScrW()
    end

    local function RealY(y)
        return (y / 1440) * ScrH()
    end

    hook.Add("HUDPaint", "DrawDeathTimer", function()
        local nlrTime = LocalPlayer():GetNWInt("NLR", 0)
        if nlrTime > 0 then
            local fraction = math.Clamp(nlrTime / TotalNLRTime, 0, 1)
            local green_blue = 255 * (1 - fraction)

            local OuterRing = {
                { x = (ScrW() / 4) * 2.5, y = 0 },
                { x = ScrW() / 4 * 2.25, y = ScrH() / 16 },
                { x = ScrW() / 4 * 1.75, y = ScrH() / 16 },
                { x = (ScrW() / 4) * 1.5, y = 0 },
            }
            local InnerRing = {
                { x = (ScrW() / 4) * 2.47, y = RealY(3) },
                { x = ScrW() / 4 * 2.25, y = ScrH() / 17.7 },
                { x = ScrW() / 4 * 1.75, y = ScrH() / 17.7 },
                { x = (ScrW() / 4) * 1.53, y = RealY(3) },
            }

            surface.SetDrawColor(255, green_blue, green_blue, 255)
            draw.NoTexture()
            surface.DrawPoly(OuterRing)
            surface.SetDrawColor(90, 90, 90, 255)
            surface.DrawPoly(InnerRing)
            draw.SimpleText("NLR Time Remaining", "HudDefault", ScrW() / 2, ScrH() / 16 / 5, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(nlrTime, "HudDefault", ScrW() / 2, ScrH() / 26, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            surface.SetFont("HudDefault")
            local linew, _ = surface.GetTextSize("NLR Time Remaining")
            draw.RoundedBox(0, (ScrW() / 2) - (linew / 2), ScrH() / 16 / 2.5, linew, RealY(5), Color(255, green_blue, green_blue))
        end
    end)
end

local vectorpos = Vector(0, 0, 30)

local function DrawName(ply)
    if not IsValid(ply) or ply == LocalPlayer() or not ply:Alive() then return end 

    local Distance = LocalPlayer():GetPos():Distance(ply:GetPos())

    if Distance < 1250 then 
        local nlrTime = ply:GetNWInt("NLR", 0)
        if nlrTime > 0 then
            local boneIndex = ply:LookupBone("ValveBiped.Bip01_Head1")
            if boneIndex then
                local bonePos = ply:GetBonePosition(boneIndex)
                local pos = bonePos + vectorpos

                local ang = LocalPlayer():EyeAngles()
                ang:RotateAroundAxis(ang:Forward(), 90)
                ang:RotateAroundAxis(ang:Right(), 90)

                cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.25)
                    draw.SimpleText("NLR", "TargetID", 0, 0, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                cam.End3D2D()
            end
        end
    end
end

hook.Add("PostPlayerDraw", "DrawName", DrawName)