local LocalRagdollID = 0
local LastRagdollEntity = nil

CreateConVar("bd_firstperson", 0, {FCVAR_ARCHIVE, FCVAR_USERINFO}, "", 0, 1)
CreateConVar("bd_customcamdisable", 0, {FCVAR_ARCHIVE, FCVAR_USERINFO}, "", 0, 1)

net.Receive("BD.DeathCam", function()
    local id = net.ReadInt(32)
    LocalRagdollID = id
end)

hook.Add("CalcView","RagDeath_Cam",function(ply, pos, angles, fov)
    if !GetConVar("bd_customcamdisable"):GetBool() then
        local LocalRagdoll = Entity(LocalRagdollID)
        if LocalPlayer():Alive() then
            if IsValid(LocalRagdoll) and LocalRagdoll:LookupBone("ValveBiped.Bip01_Head1") != nil and LocalRagdoll:LookupBone("ValveBiped.Bip01_Head1") > 0 then
                LocalRagdoll:ManipulateBoneScale(LocalRagdoll:LookupBone("ValveBiped.Bip01_Head1"), Vector(1,1,1))
            end
            return 
        end
        if not IsValid(LocalRagdoll) then return end
        local ent = GetViewEntity()
        if ent != LocalPlayer() then return end

        if GetConVar("bd_firstperson"):GetBool() then
            LocalRagdoll:ManipulateBoneScale(LocalRagdoll:LookupBone("ValveBiped.Bip01_Head1"), Vector(0,0,0))
            
            local att = LocalRagdoll:GetAttachment(LocalRagdoll:LookupAttachment('eyes'))
            local pos = att.Pos
            local ang = att.Ang
            return {
                origin=pos,
                angles=ang,
                fov=fov,
                znear=0.5
            }
        else
            LocalRagdoll:ManipulateBoneScale(LocalRagdoll:LookupBone("ValveBiped.Bip01_Head1"), Vector(1,1,1))

            local rd = util.TraceLine(
                {start=LocalRagdoll:GetPos(),
                endpos=LocalRagdoll:GetPos()-angles:Forward()*106,
                filter={LocalRagdoll,LocalPlayer()}
            })

            return {
                origin=LocalRagdoll:GetPos()-angles:Forward()*(100*rd.Fraction),
                angles=angles,
                fov=fov,
                znear=0.5
            }
        end
    end
end)

local function divider(panel, title)
    local divider = vgui.Create("DHorizontalDivider", panel)
    function divider:Paint(w, h)
        if (title != nil) then
            surface.SetFont("GModToolHelp")
            local widthOfText = surface.GetTextSize(title)
            
            surface.SetDrawColor(200, 200, 200, 255)
            surface.DrawLine(0, h * 0.5, w * 0.5 - widthOfText, h * 0.5)
            surface.DrawLine(w * 0.5 + widthOfText, h * 0.5, w, h * 0.5)

            draw.SimpleTextOutlined(title, "GModToolHelp", w * 0.5, h * 0.5, Color(245, 245, 245, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 45))
        else
            surface.SetDrawColor(200, 200, 200, 255)
            surface.DrawLine(0, h * 0.5, w, h * 0.5)
        end
    end
    panel:AddItem(divider)
end

hook.Add("PopulateToolMenu", "BrutalDeathsBD", function()
    spawnmenu.AddToolMenuOption("Options", "Complex Death Animations", "CDA_BD", "Settings", "", "", function(panel)
        panel:ClearControls()
        if LocalPlayer():IsSuperAdmin() then
            divider(panel, "Server Settings")
            panel:CheckBox("Enable on Players?", "bd_enable_players")
            panel:ControlHelp("Enabling work of the system on players.")
            panel:CheckBox("Enable on NPCs?", "bd_enable_npcs")
            panel:ControlHelp("Enabling work of the system on players.")
            panel:CheckBox("Change Club damage to Bullet?", "bd_club_as_default")
            panel:ControlHelp("Changing club damage animations to bullet animations.")
            panel:CheckBox("Change Other damage to Bullet?", "bd_other_as_default")
            panel:ControlHelp("Changing other damage to bullet animations.")
            panel:CheckBox("Enable Face Expression?", "bd_face_expression")
            panel:ControlHelp("Changing face on death.")
            panel:NumSlider("Life Scale", "bd_life_scale", 0, 10, 2)
            panel:ControlHelp("Scaling health of ragdoll, because ragdoll can be killed.")
            panel:NumSlider("Crawl Chance", "bd_crawl_chance", 0, 100, 0)
            panel:ControlHelp("Changing chance of crawling state after bullet or slash damage.")
        end
        divider(panel, "Client Settings")
        panel:CheckBox("Enable Firstperson?", "bd_firstperson")
        panel:ControlHelp("Enabling firstperson when you dead.")
        panel:CheckBox("Disable Custom Camera?", "bd_customcamdisable")
        panel:ControlHelp("Fixing camera for spectate mode and other things.")
    end)
end)