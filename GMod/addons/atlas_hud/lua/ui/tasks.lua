local gradientLeft = Material("vgui/gradient-l.png")
local statusCircle = Material("atlas/quiz/btn_circle.png")
local sw, sh = ScrW(), ScrH()   
local padding = sw * .025
local offset = sw * .01
local spacing = sw * .005      

local mainCol = Color(255, 255, 255, 255)
local backCol = Color(222, 85, 85, 10)
local barBackCol = Color(50, 50, 50, 100)
local agendaStartX, agendaStartY = sw * .01, sh * .035
local agendaWidth, agendaHeight = sw * .2, sh * .2

--[[local tbl = {
    "task 1 task 1 task 1 task 1 task 1 task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1task 1",
    "task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 task 2 "
}]]
function drawSCPHUDCustomAgenda()
    local mat = Matrix()
    mat:Translate(Vector(sw/2, sh/2))
    mat:Rotate(Angle(0,2,0))
    mat:Scale(Vector(1,1,1))
    mat:Translate(-Vector(sw/2, sh/2))

    local hudX, hudY = getHUDPositionXY()
    agendaStartX, agendaStartY = hudX - sw * .49, hudY - sh * .865

    cam.PushModelMatrix(mat)
        surface.SetMaterial(gradientLeft)
        surface.SetDrawColor(Color(255, 255, 255, 15))
        surface.DrawTexturedRect(agendaStartX + offset * .5, agendaStartY + offset * .5, agendaWidth, agendaHeight * .18)
        surface.SetDrawColor(Color(255, 255, 255, 55))
        surface.DrawTexturedRect(agendaStartX, agendaStartY, agendaWidth, agendaHeight * .18)
        if CODE_CONFIG and CODE_CONFIG.CanSeeJobs[LocalPlayer():Team()] then
            draw.SimpleText("Site Status - ", "Mono30", agendaStartX + padding * .3, agendaStartY + padding * .1, Color(255, 255, 255), 0, 0)
            draw.SimpleText(currentcode, "Mono30", agendaStartX + padding * .3 + surface.GetTextSize("Site Status - "), agendaStartY + padding * .1, codecolor, 0, 0)
            surface.SetMaterial(statusCircle)
            -- background low opacity circle
            surface.SetDrawColor(Color(codecolor.r, codecolor.g, codecolor.b, 150))
            surface.DrawTexturedRect(agendaStartX + padding * .5 + surface.GetTextSize("Site Status - ") + surface.GetTextSize(currentcode) - 3, agendaStartY + padding * .26 - 3, 16 + 6, 16 + 6)
            surface.SetDrawColor(codecolor)
            surface.DrawTexturedRect(agendaStartX + padding * .5 + surface.GetTextSize("Site Status - ") + surface.GetTextSize(currentcode), agendaStartY + padding * .26, 16, 16)
        else
            draw.SimpleText("System Offline", "Mono30", agendaStartX + padding * .3, agendaStartY + padding * .3, backCol, 0, 0)
            draw.SimpleText("System Offline", "Mono30", agendaStartX + padding * .1, agendaStartY + padding * .1, mainCol, 0, 0)
        end

        // Draw agenda.

        --[[if BK.Agendas then
            local agendas = BK.Agendas.GetFinalList()

            for i, agenda_data in ipairs(agendas) do
                local y_offset = agendaStartY - padding * 0.8 + padding * (i * 2)
                local x_offset = agendaStartX + padding * (i * 0.1)
                surface.SetMaterial(gradientLeft)
                surface.SetDrawColor(Color(255, 255, 255, 15))
                surface.DrawTexturedRect(x_offset + offset * .5, y_offset + offset * .5, agendaWidth * 1.2, agendaHeight * .37)
                surface.SetDrawColor(Color(255, 255, 255, 55))
                surface.DrawTexturedRect(x_offset, y_offset, agendaWidth * 1.2, agendaHeight * .37)    
    
                local agenda_pieces = string.Split(agenda_data.agenda, " ")
                local split_pos = 0

                for _, piece in ipairs(agenda_pieces) do
                    split_pos = split_pos + #piece + 1

                    if split_pos > 65 then
                        break
                    end
                end

                draw.SimpleTextOutlined(agenda_data.data.Name, "MonoBold25", x_offset + padding * .3, y_offset + padding * .1, agenda_data.data.Color or Color(255, 255, 255), 0, 0, 1, Color(0, 0, 0, 20))
                surface.SetDrawColor(Color(200, 200, 200))
                surface.DrawRect(x_offset + padding * .3, y_offset + padding * 0.68, agendaWidth * 0.5, agendaHeight * 0.005)
                draw.SimpleText(string.sub(agenda_data.agenda, 1, split_pos), "Mono18", x_offset + padding * .3, y_offset + padding * 0.8, Color(255, 255, 255), 0, 0)
                draw.SimpleText(string.TrimLeft(string.sub(agenda_data.agenda, split_pos + 1)), "Mono18", x_offset + padding * .3, y_offset + padding * 1.15, Color(255, 255, 255), 0, 0)
            end

        end]]
    cam.PopModelMatrix()
end

--[[local function createSCPHUDCustomTaskPanel()
    
end]]

hook.Add("InitPostEntity", "cl.scphud.tasks.create.task.select.panel", function()
    timer.Simple(1, createSCPHUDCustomWeaponSelectPanel)
end)

hook.Add("HUDPaint", "cl.scphud.agenda.hudpaint", drawSCPHUDCustomAgenda)
