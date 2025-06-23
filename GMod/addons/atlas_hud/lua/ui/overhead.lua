local backGround = Material( "notifications/angryimg.png" )

local baseHeight = 72

local function isPlyInfiltractor(ply)
    return ply:Team() == TEAM_RIINFILTRATOR or ply:Team() == TEAM_RILEADINFILTRATOR or false
end
local FBITeams = {}
timer.Simple(1, function()
    FBITeams[TEAM_I10FBITRN or ""] = true
    FBITeams[TEAM_I10FBITRN or ""] = true
    FBITeams[TEAM_I10FBITRN or ""] = true
end)
local function canISeeThisPlayer(ply)
    if isPlyInfiltractor(ply) then
        return true
    end
    if isPlyInfiltractor(LocalPlayer()) then
        return true
    end

    local self_faction = LocalPlayer().getJobTable and LocalPlayer():getJobTable().faction or "1"
    local other_faction = ply.getJobTable and ply:getJobTable().faction or "2"

    if self_faction == "FOUNDATION" and other_faction == "CHAOS" then
        return false
    end
    
    if self_faction == "CHAOS" and other_faction == "FOUNDATION" then
        return false
    end

    if self_faction == "FOUNDATION" and other_faction == "CIVILIAN" then
        if FBITeams[LocalPlayer():Team()] then
            return true
        end
        return false
    end

    if self_faction == "CHAOS" and other_faction == "CIVILIAN" then
        return false
    end
    
    return true
end

function drawSCPHUDPlayerOverHead(p)
    local localply = LocalPlayer()
    local localpos, ang
    p.RenderGroup = 9

    if p:GetColor().a < 255 then return end

    -- if player is cloaked then return
    if p:GetNoDraw() then return end

    if SCP035 and SCP035.IsMe and SCP035.Target then return end

    if p:GetNWBool("SWT_CM.IsCloaked", false) then return end

    if not canISeeThisPlayer(p) then return end

    if not p:Alive() and IsValid(p:GetActiveWeapon()) and IsValid(localply:GetActiveWeapon()) and localply:GetActiveWeapon():GetClass() == "weapon_scp939" and p:GetActiveWeapon():GetClass() ~= "weapon_scp939" then return end


    if localply:InVehicle() then
        ang = localply:GetAimVector():Angle()
        localpos = localply:GetPos()
    elseif localply:GetViewEntity() or localply:GetObserverTarget() then
        local viewent = localply:GetViewEntity() or localply:GetObserverTarget()
        if p == localply and viewent == localply then
            return
        end		
        if viewent and viewent:IsValid() then
            ang = viewent:GetAngles()
            localpos = viewent:GetPos()
        end	
        spectating = true
    else
        if p == localply then
            return
        end
        ang = localply:EyeAngles()
        localpos = localply:GetPos()
    end
    
    local pos = p:GetPos()
    local dist = localpos:Distance( pos )
    
    local maxdistAction = 1400
    local maxdistInfo = 600
    if dist > maxdistAction then return end                                                   -- normal max draw distance check

    local ratio = math.min( 1, dist / maxdistInfo )
    local alpha = math.max( 0, 1 - 1 * (( ratio ^ 2 ) * 2) ) ^ 2

    local ratioAction = math.min( 1, dist / maxdistAction )
    local alphaAction = math.max( 0, 1 - 1 * (( ratioAction ^ 2 ) * 2) ) ^ 2
    
    local modelHeight = p:OBBMaxs().z - p:OBBMins().z
    local scaleFactor = modelHeight / baseHeight
    local isCrouching = p:Crouching()

    local crouchOffset = isCrouching and modelHeight * 1.6 or 0 
    local offset = Vector( 0, 0, (76 + 15 * ratio + crouchOffset) * scaleFactor)
    local posdraw = p:GetPos() + offset + ang:Up()

    local w, h = 150 * scaleFactor, 5 * scaleFactor

    ang:RotateAroundAxis( ang:Forward(), 90 )
    ang:RotateAroundAxis( ang:Right(), 90 )

    local w, h = 150, 5

    local name = IsValid(p) and p:getDarkRPVar("rpname") or ""
    surface.SetFont("Mono20")
    local nWidth, nHeight = surface.GetTextSize(name)

    local job = IsValid(p) and p:getDarkRPVar("job") or ""
    surface.SetFont("Mono18")
    local jWidth, jHeight = surface.GetTextSize(job)

    if nWidth > 150 and nWidth > jWidth then
        w = nWidth
    elseif jWidth > 150 and jWidth > nWidth then
        w = jWidth 
    end



    local maxHealth = p:GetMaxHealth()
    local health = math.Clamp(p:Health(), 0, maxHealth)
    local triangle = Material("notifications/play.png")

    cam.Start3D2D( posdraw, Angle( 0, ang.y, 90), (isCrouching and 0.2 or 0.06 + ratio * 0.40) * scaleFactor )

        if alphaAction > 0.01 then

            if p:GetNWFloat("SCPHUDFloatForActionsTimer") >= CurTime() then

                local rpMessage = p:GetNWString("SCPHUDNWStringForActions")
                surface.SetFont("Mono16")
                local mWidth, mHeight = surface.GetTextSize(rpMessage)

                surface.SetMaterial(backGround)
                surface.SetDrawColor(Color(0, 0, 0, 155 * alphaAction))
                surface.DrawTexturedRect(-mWidth * .75 , -85, mWidth * 1.5, 75)

                surface.SetMaterial(triangle)
                surface.SetDrawColor(255, 255, 255, 255 * alphaAction)
                surface.DrawTexturedRect(-7.5, -46, 15, 15)

                draw.RoundedBox(0, -mWidth*.5, -47.5, mWidth, h * .5, Color(255, 255, 255, 255 * alphaAction) )

                local bool = p:GetNWBool("SCPHUDNWStringIsMe")
                local overHeadCol = bool and Color(255, 185, 116, 255 * alphaAction) or Color(255, 255, 255, 255 * alphaAction)
                
                draw.SimpleText(rpMessage, "Mono16", 0, -46, overHeadCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            end

            if alpha > 0.01 then

                surface.SetMaterial(backGround)
                surface.SetDrawColor(Color(0, 0, 0, 125 * alpha))
                surface.DrawTexturedRect(-w , -h * 10, w * 2, h * 20)
    
                draw.RoundedBox(0, -w*.5, 0, w, h, Color(255, 255, 255, 255 * alpha) )
                draw.RoundedBox(0, -w*.5, h*.75, w, h*.5, Color(55, 55, 55, 255 * alpha) )
                draw.RoundedBox(0, -w*.5, h*.75, w/maxHealth * health, h*.5, Color(205, 25, 25, 255 * alpha) )
                draw.SimpleText(name, "Mono20", -w*.5, h - 18, Color(255, 255, 255, 255 * alpha), 4, 1)
                draw.SimpleText(job, "Mono18", -w*.5, h + 12, Color(255, 255, 255, 255 * alpha), 4, 1)
                -- Draw description get from NWString ATLAS::Character::Description
                local desc = p:GetNWString("ATLAS::Character::Description", "Invalid")
                if desc != "" and input.IsKeyDown(KEY_G) then  -- Check if G key is being held down
                    surface.SetFont("Mono16")
                    local dWidth, dHeight = surface.GetTextSize(desc)
            
                    -- Split the description into words
                    local words = string.Explode(" ", desc)
            
                    -- Define the maximum number of words per line
                    local maxWordsPerLine = 13  -- Adjust this value as needed
            
                    -- Split the words into lines
                    local lines = {}
                    for i = 1, #words, maxWordsPerLine do
                        table.insert(lines, table.concat(words, " ", i, math.min(i + maxWordsPerLine - 1, #words)))
                    end

                    if #lines == 1 then
                        dWidth = dWidth * 1.7
                    end
            
                    -- Draw each line
                    for i, line in ipairs(lines) do
                        local lineY = h + 23 + (i - 1) * dHeight
                        -- if first line add overhead and if last line add underhead
                        
                        draw.RoundedBox(0, -dWidth*.3, lineY, dWidth * 0.6, dHeight, Color(0, 0, 0, 255 * alpha))
                        draw.SimpleText(line, "Mono16", 0, lineY + 7, Color(255, 255, 255, 255 * alpha), 1, 1)
                    end

                    
                end

            end

        end

	cam.End3D2D()
end

hook.Add("PostDrawTranslucentRenderables", "cl.scphud.main.PostDrawTranslucentRenderables", function()
	for k, v in pairs(player.GetAll()) do
        if not IsValid(v) then continue end
        if LocalPlayer():GetPos():Distance(v:GetPos()) > 1400 then continue end
		drawSCPHUDPlayerOverHead(v)
	end
end)