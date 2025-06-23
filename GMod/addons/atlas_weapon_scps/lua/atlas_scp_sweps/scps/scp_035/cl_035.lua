SCP035.IsMe = SCP035.IsMe or false
SCP035.Subject = SCP035.Subject or false
SCP035.Consumed = SCP035.Consumed or false
SCP035.Target = SCP035.Target or false
net.Receive("ATLAS.SCP035.Add", function()
    SCP035.IsMe = true
end)
net.Receive("ATLAS.SCP035.Del", function()
    SCP035.IsMe = false
end)
net.Receive("ATLAS.SCP035.SubjectAdd", function()
    SCP035.Subject = true
end)
net.Receive("ATLAS.SCP035.SubjectDel", function()
    SCP035.Subject = false
end)
net.Receive("ATLAS.SCP035.Consumed", function()
    chat.AddText(Color(255,185,56), "[SCP-035] ", Color(255,255,255), "A mask gets stuck to your face.")
    SCP035.Consumed = true
end)
net.Receive("ATLAS.SCP035.DeConsumed", function()
    SCP035.Consumed = false
end)
net.Receive("ATLAS.SCP035.StaffSitNotify", function()
    chat.AddText(Color(255,185,56), "[SCP-035] ", Color(255,255,255), "The SCP-035 player was pulled away by staff.")
end)
net.Receive("ATLAS.SCP035.Success", function()
    chat.AddText(Color(255,185,56), "[SCP-035] ", Color(255,255,255), "You successfully defeated SCP-035's lure.")
end)
net.Receive("ATLAS.SCP035.Failure", function()
    chat.AddText(Color(255,185,56), "[SCP-035] ", Color(255,255,255), "You failed to defeat SCP-035's lure.")
end)
net.Receive("ATLAS.SCP035.Left", function()
    chat.AddText(Color(255,185,56), "[SCP-035] ", Color(255,255,255), "SCP-035 has left the job.")
end)
net.Receive("ATLAS.SCP035.Inform", function()
    local bool = net.ReadBool()
    if bool then
        chat.AddText(Color(255,185,56), "[SCP-035] ", Color(255,255,255), "The lured player completed the quiz. Luring failed!")
    else
        chat.AddText(Color(255,185,56), "[SCP-035] ", Color(255,255,255), "Luring succeeded! They're now attracted to the mask.")
    end
end)
net.Receive("ATLAS.SCP035.EyeLock", function()
    local mask = net.ReadEntity()
    hook.Add("Think", "ATLAS.SCP035.EyeLock", function()
        if not IsValid(mask) then return end
        local vec1 = mask:GetPos()
        local vec2 = LocalPlayer():GetShootPos()
        LocalPlayer():SetEyeAngles( ( vec1 - vec2 ):Angle() )
    end)
    timer.Simple(20, function() hook.Remove("Think", "ATLAS.SCP035.EyeLock") end)
end)

net.Receive("ATLAS.SCP035.Inform", function()
    local chatTextArgs = net.ReadTable()
    chat.AddText(unpack(chatTextArgs))
end)

net.Receive("ATLAS.SCP035.UnEyeLock", function()
    hook.Remove("Think", "ATLAS.SCP035.EyeLock")
end)

net.Receive("ATLAS.SCP035.BroadcastTarget", function()
    SCP035.Target = net.ReadEntity() or false
end)

surface.CreateFont( "ATLAS.SCP035.Font", {
	font = "Raleway",
	extended = false,
	size = 20,
	weight = 500,
} )
surface.CreateFont( "ATLAS.SCP035.Font.Consumed", {
	font = "Montserrat",
	extended = false,
	size = 20,
	weight = 500,
} )
hook.Add("HUDPaint", "ATLAS.SCP035.UI", function()
    if not SCP035.IsMe then return end
    local colorTable = {r = SCP035.Subject and 255 or 115, g = SCP035.Subject and 255 or 115, b = SCP035.Subject and 255 or 115}
    local colorTableLure = {r = SCP035.Subject and 115 or 255, g = SCP035.Subject and 115 or 255, b = SCP035.Subject and 115 or 255}
    surface.SetDrawColor(18,18,26, 230)
    surface.DrawRect(ScrW() * 0.1, ScrH() * 0.11, ScrW() * 0.1, ScrH() * 0.07)
    surface.SetTextColor( colorTable.r, colorTable.g, colorTable.b  )
    surface.SetTextPos( ScrW() * 0.107, ScrH() * 0.12 )
    surface.SetFont( "ATLAS.SCP035.Font" )
    surface.DrawText( "Press K to kill subject" )
    surface.SetTextColor( colorTableLure.r, colorTableLure.g, colorTableLure.b )
    surface.SetTextPos( ScrW() * 0.12, ScrH() * 0.15 )
    surface.SetFont( "ATLAS.SCP035.Font" )
    surface.DrawText( "Press L to lure" )
end)

hook.Add("HUDPaint", "ATLAS.SCP035.CONSUMED.UI", function()
    if not SCP035.Consumed then return end
    surface.SetDrawColor(255,85,85,200)
    surface.DrawRect(ScrW() * 0.359, ScrH() * 0, ScrW() * 0.28, ScrH() * 0.04)
    surface.SetTextColor( 255,255,255  )
    surface.SetTextPos( ScrW() * 0.385, ScrH() * 0.009 )
    surface.SetFont( "ATLAS.SCP035.Font.Consumed" )
    surface.DrawText( SCP035.Text )
end)

hook.Add("PostDrawOpaqueRenderables", "ATLAS.SCP035.Target", function()
    if IsValid(SCP035.Target) and SCP035.Target ~= LocalPlayer() then
        local bone_id = SCP035.Target:LookupBone("ValveBiped.Bip01_Head1")
        if not bone_id then return end

        local matrix = SCP035.Target:GetBoneMatrix(bone_id)
        if not matrix then return end

        local new_pos, new_ang = LocalToWorld(Vector(4, -8, 0), Angle(90, -75, 0), matrix:GetTranslation(), matrix:GetAngles())

        render.Model({
            model = SCP035.FaceMaskModel,
            pos = new_pos,
            angle = new_ang
        })
    end
end)

local cooldown = 0
hook.Add("Think", "ATLAS.SCP035.Hotkeys", function()
    if not SCP035.IsMe then return end
    if LocalPlayer():IsTyping() then return end

    if input.IsKeyDown( SCP035.KillKey ) and SCP035.Subject and not LocalPlayer():IsTyping() and not gui.IsConsoleVisible() then
        if cooldown > CurTime() then return end
        cooldown = CurTime() + 1
        net.Start("ATLAS.SCP035.Kill")
        net.SendToServer()
    end
    if input.IsKeyDown( SCP035.LureKey ) and not SCP035.Subject and not LocalPlayer():IsTyping() and not gui.IsConsoleVisible() then
        if cooldown > CurTime() then return end
        cooldown = CurTime() + SCP035.LureCooldown
        for k,v in pairs(ents.FindInSphere( LocalPlayer():GetPos(), 600 )) do
            if v:IsPlayer() and v ~= LocalPlayer() and v:Alive() then
                if SCP035.BlacklistedTeams[v:Team()] then continue end
                net.Start("ATLAS.SCP035.SubjectAdd")
                net.WriteEntity(v)
                net.SendToServer()
                break
            end
        end
    end
end)


--[[SCP035.SelectedQuestion = false
SCP035.SelectedAnswer = false
surface.CreateFont( "ATLAS.SCP035.Quiz.Header", {
	font = "Raleway",
	extended = false,
	size = 20,
	weight = 500,
} )
local function submitAnswer(value, question)
    timer.Remove("SCP035")
    net.Start("ATLAS.SCP035.Answer")
    net.WriteString(value)
    net.WriteString(question)
    net.SendToServer()
end


local function buildQuizUI()
    local preRoll, value = math.random(1, table.Count(SCP035.Math)), 0
    for k,v in pairs(SCP035.Math) do
        if value == preRoll then
            SCP035.SelectedQuestion = k
            break
        end
        value = value + 1
    end
    local answerTable = table.GetKeys(SCP035.Math[SCP035.SelectedQuestion].answers)
    textOne = table.Random(answerTable)
    table.RemoveByValue(answerTable, textOne)
    local function setTwo()
        textTwo = table.Random(answerTable)
        table.RemoveByValue(answerTable, textTwo)
    end
    setTwo()
    local function setThree()
        textThree = table.Random(answerTable)
        table.RemoveByValue(answerTable, textThree)
    end
    setThree()
    local w, h = ScrW(), ScrH()
    local Frame = vgui.Create( "DFrame" )
    Frame:SetTitle( "" )
    Frame:SetSize( w * 0.13,h * 0.25 )
    Frame:Center()
    Frame:MakePopup()
    Frame:ShowCloseButton( false )
    Frame.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 23, 22, 27, 255) )
    end
    local Header = vgui.Create( "DLabel", Frame )
    Header:SetPos( w * 0.05, h * 0.01 )
    Header:SetSize( 70, 60 )
    Header:SetWrap( true )
    Header:SetFont("ATLAS.SCP035.Quiz.Header")
    Header:SetText( SCP035.SelectedQuestion )

    local Timer = vgui.Create( "DLabel", Frame )
    Timer:SetPos( w * 0.045, h * 0.2 )
    Timer:SetSize( 90, 50 )
    Timer:SetWrap( true )
    Timer:SetFont("ATLAS.SCP035.Quiz.Header")

    local AnswerOne = vgui.Create("DButton", Frame)
    AnswerOne:SetText( tostring(textOne) )
    AnswerOne:SetTextColor( Color(255,255,255) )
    AnswerOne:SetPos( w * 0.03, h * 0.07 )
    AnswerOne:SetSize( w * 0.07, h * 0.03 )
    AnswerOne.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 184, 74, 74, 250) )
    end
    AnswerOne.DoClick = function()
        submitAnswer(tostring(textOne), SCP035.SelectedQuestion)
        Frame:Close()
    end
    local AnswerTwo = vgui.Create("DButton", Frame)
    AnswerTwo:SetText( tostring(textTwo) )
    AnswerTwo:SetTextColor( Color(255,255,255) )
    AnswerTwo:SetPos( w * 0.03, h * 0.12 )
    AnswerTwo:SetSize( w * 0.07, h * 0.03 )
    AnswerTwo.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 184, 74, 74, 250) )
    end
    AnswerTwo.DoClick = function()
        submitAnswer(tostring(textTwo), SCP035.SelectedQuestion)
        Frame:Close()
    end
    local AnswerThree = vgui.Create("DButton", Frame)
    AnswerThree:SetText( tostring(textThree) )
    AnswerThree:SetTextColor( Color(255,255,255) )
    AnswerThree:SetPos( w * 0.03, h * 0.17 )
    AnswerThree:SetSize( w * 0.07, h * 0.03 )
    AnswerThree.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 184, 74, 74, 250) )
    end
    AnswerThree.DoClick = function()
        submitAnswer(tostring(textThree), SCP035.SelectedQuestion)
        Frame:Close()
    end

    timer.Create("SCP035", SCP035.AnswerLimit, 1, function()
        Frame:Close()
        -- This net may seem exploitable however serverside validation exists to ensure its not.
        net.Start("ATLAS.SCP035.Answer")
        net.WriteString("FAILED")
        net.SendToServer()
        
    end)
    Timer:SetText( tostring(math.Round(timer.TimeLeft("SCP035"))).." seconds" )
    timer.Create("UPDATETEXT", 1, SCP035.AnswerLimit, function()
        if not IsValid(Frame) then return end
        Timer:SetText( tostring(math.Round(timer.TimeLeft("SCP035"))).." seconds" )
    end)
end

-- concommand.Add("SCP035_DEBUGUI", buildQuizUI)

net.Receive("ATLAS.SCP035.Lure", function()
    buildQuizUI()
end)]]