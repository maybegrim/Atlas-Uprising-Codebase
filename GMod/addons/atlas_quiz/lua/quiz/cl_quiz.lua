local cfg_cache = ATLASQUIZ.CFG

ATLASQUIZ.Frames = ATLASQUIZ.Frames or {}

function ATLASQUIZ.HandleQuestion(question)
    local qData = cfg_cache.Questions[question]
    if not qData then return end
    qData.id = question
    ATLASQUIZ.PrepUI()
    timer.Create("ATLASQUIZ.PrepTimer", cfg_cache.DefaultPrepTime, 1, function()
        ATLASQUIZ.ClosePrepUI()
        -- Timer added because GMod moment
        timer.Simple(0.1, function()
            ATLASQUIZ.DeployUI(qData)
            timer.Create("ATLASQUIZ.AnswerTimer", cfg_cache.DefaultAnswerTime, 1, function()
                if not IsValid(ATLASQUIZ.Frames.QuizPanel) then return end
                ATLASQUIZ.CloseQuizUI()
                net.Start("ATLASQUIZ.Answer")
                    net.WriteBool(true)
                net.SendToServer()
            end)
        end)
    end)
end



-- for 1-40 create font for each size
for i = 1, 40 do
    surface.CreateFont("ATLASQUIZ.FONT:" .. i, {
        font = "Signika Negative",
        size = i,
        weight = 700,
        antialias = true,
        shadow = false
    })
end

local function shuffleTable(tbl)
    local tblCopy = table.Copy(tbl)
    local tblSize = #tblCopy
    for i = tblSize, 2, -1 do
        local rand = math.random(i)
        tblCopy[i], tblCopy[rand] = tblCopy[rand], tblCopy[i]
    end
    return tblCopy
end

local function shuffleTableWithSameKeys(tbl)
    local tblCopy = {}
    local keys = {}
    for k, _ in pairs(tbl) do
        table.insert(keys, k)
    end
    local shuffledKeys = shuffleTable(keys)
    for i, k in ipairs(shuffledKeys) do
        tblCopy[k] = tbl[k]
    end
    return tblCopy
end


-- PrepUI is going to appear during the prep period. Its just going to say "Are you ready?" and will track the timer coded above.
function ATLASQUIZ.PrepUI()
    local screen_width, screen_height = ScrW(), ScrH()

    local prepPanel = vgui.Create("EditablePanel")
    -- I want prep panel centered in the middle of the screen. Size is 1/3 of the screen.
    prepPanel:SetSize(screen_width / 4, screen_height / 5)
    prepPanel:Center()
    prepPanel:MakePopup()
    ATLASQUIZ.Frames.PrepPanel = prepPanel

    prepPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    local header = vgui.Create("Panel", prepPanel)
    header:SetSize(prepPanel:GetWide(), prepPanel:GetTall() * 0.1)
    header:SetPos(0, 0)
    header.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 33, 255))
    end

    local headerText = vgui.Create("DLabel", header)

    headerText:SetSize(header:GetWide(), header:GetTall())
    headerText:SetPos(2, 0)
    headerText:SetText("ATLAS QUIZ")
    headerText:SetFont("ATLASQUIZ.FONT:20")
    headerText:SetTextColor(Color(255, 255, 255))

    local prepText = vgui.Create("DLabel", prepPanel)
    prepText:SetSize(prepPanel:GetWide(), prepPanel:GetTall())
    prepText:SetPos(0, prepPanel:GetTall() * -0.1)
    prepText:SetText("Are you ready?")
    prepText:SetFont("ATLASQUIZ.FONT:32")
    prepText:SetTextColor(Color(255, 255, 255))
    prepText:SetContentAlignment(5)

    local prepTimer = vgui.Create("DLabel", prepPanel)
    prepTimer:SetSize(prepPanel:GetWide(), prepPanel:GetTall())
    prepTimer:SetPos(0, prepPanel:GetTall() * 0.1)
    prepTimer:SetText(cfg_cache.DefaultPrepTime)
    prepTimer:SetFont("ATLASQUIZ.FONT:32")
    prepTimer:SetTextColor(Color(255, 255, 255))
    prepTimer:SetContentAlignment(5)

    prepTimer.Think = function(self)
        if not timer.Exists("ATLASQUIZ.PrepTimer") then return end
        local timeLeft = math.Round(timer.TimeLeft("ATLASQUIZ.PrepTimer"))
        self:SetText(timeLeft)
    end
end

local function shuffleTable(tbl)
    local tblSize = #tbl
    for i = tblSize, 2, -1 do
        local rand = math.random(i)
        tbl[i], tbl[rand] = tbl[rand], tbl[i]
    end
end

local function shuffleAnswers(data)
    shuffleTable(data.answers)
end

--[[
    UI Structure:
    Prep Time - cfg_cache.DefaultPrepTime, we ask "Are you ready?" and countdown from prep time var.
    Once prep time is over, we ask the question and give the player the options.
    Question must be answered by cfg_cache.DefaultAnswerTime, if not, we net back to server false.
]]
-- Use the shuffleAnswers function before deploying the UI
function ATLASQUIZ.DeployUI(data)
    local screen_width, screen_height = ScrW(), ScrH()

    local quizPanel = vgui.Create("EditablePanel")
    -- I want quiz panel centered in the middle of the screen. Size is 1/3 of the screen.
    quizPanel:SetSize(screen_width / 4, screen_height / 4.5)
    quizPanel:Center()
    quizPanel:MakePopup()

    ATLASQUIZ.Frames.QuizPanel = quizPanel

    quizPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
    end

    local header = vgui.Create("Panel", quizPanel)
    header:SetSize(quizPanel:GetWide(), quizPanel:GetTall() * 0.1)
    header:SetPos(0, 0)
    header.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 33, 255))
    end

    local headerText = vgui.Create("DLabel", header)
    headerText:SetSize(header:GetWide(), header:GetTall())
    headerText:SetPos(2, 0)
    headerText:SetText("ATLAS QUIZ")
    headerText:SetFont("ATLASQUIZ.FONT:20")
    headerText:SetTextColor(Color(255, 255, 255))

    local questionPanel = vgui.Create("Panel", quizPanel)
    questionPanel:SetSize(quizPanel:GetWide(), quizPanel:GetTall() * 0.94)
    questionPanel:SetPos(0, header:GetTall())
    questionPanel.Paint = function(self, w, h)
    end

    local questionText = vgui.Create("DLabel", questionPanel)
    questionText:SetSize(questionPanel:GetWide(), questionPanel:GetTall())
    questionText:SetPos(0, 0)
    local tempQuestion = data.question
    questionText:SetText(tempQuestion)
    questionText:SetFont("ATLASQUIZ.FONT:32")
    questionText:SetTextColor(Color(255, 255, 255))
    questionText:SetWrap(true)
    questionText:SetAutoStretchVertical(true)
    
    -- Measure the text
    surface.SetFont("ATLASQUIZ.FONT:32")
    local textWidth, textHeight = surface.GetTextSize(tempQuestion)
    
    -- Wait until the next frame so the label has time to resize itself
    timer.Simple(0, function()
        if not IsValid(questionText) then return end
    
        -- Center the label horizontally and vertically
        local panelWidth = questionPanel:GetWide()
        local panelHeight = questionPanel:GetTall()
        local labelWidth = math.min(panelWidth, textWidth) -- Make sure the label is not wider than the panel
        local labelHeight = questionText:GetTall()
    
        local textXPos = (panelWidth - labelWidth) * 0.5
        local textYPos = (panelHeight - labelHeight) * 0.5
    
        questionText:SetSize(labelWidth, labelHeight)
        questionText:SetPos(textXPos, textYPos)
    end)
    
    local answerPanel = vgui.Create("Panel", questionPanel)
    -- Make answer panel not go across panel and center under question
    answerPanel:SetSize(questionPanel:GetWide() / 1.5, questionPanel:GetTall() * 0.9)
    answerPanel:SetPos(questionPanel:GetWide() / 6, questionPanel:GetTall() * 0.05)
    answerPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(73, 210, 255, 0))
    end

    -- For loop for answers. Table is data.answers
    if not data then data = {} data.answers = {"A", "B", "C", "D"} end
    local originalIndices = {}
    for i, v in ipairs(data.answers) do
        originalIndices[v] = i
    end

    shuffleAnswers(data)
    
    for k, v in pairs(data.answers) do
        local answerButton = vgui.Create("DButton", answerPanel)
        answerButton:SetSize(answerPanel:GetWide(), answerPanel:GetTall() * 0.15)
        answerButton:SetPos(0, answerPanel:GetTall() * 0.17 * k)
        answerButton:SetText(v)
        answerButton:SetTextColor(Color(255,255,255))
        answerButton:SetFont("ATLASQUIZ.FONT:25")
        answerButton.Paint = function(self, w, h)
            -- Hollow white buttons
            local thickness = 2
            draw.RoundedBox(0, 0, 0, w, thickness, Color(255, 255, 255))
            draw.RoundedBox(0, 0, 0, thickness, h, Color(255, 255, 255))
            draw.RoundedBox(0, w - thickness, 0, thickness, h, Color(255, 255, 255))
            draw.RoundedBox(0, 0, h - thickness, w, thickness, Color(255, 255, 255))

            -- Hover
            if self:IsHovered() then
                draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 50))
                -- Draw a icon on the left side of the button
                surface.SetDrawColor(Color(255, 255, 255))
                surface.SetMaterial(Material("materials/atlas/quiz/btn_check.png"))
                -- Draw centered left
                surface.DrawTexturedRect(w * 0.02, h * 0.25, 16,16)
            end
        end
        answerButton.answerID = originalIndices[v]
        -- On hover player sound effect
        answerButton.OnCursorEntered = function()
            surface.PlaySound("main/btn_hover.mp3")
        end
        answerButton.DoClick = function(s)
            -- Send net message to server with answer
            net.Start("ATLASQUIZ.Answer")
                net.WriteBool(false)
                net.WriteString(v)
            net.SendToServer()
            quizPanel:Remove()
        end
    end


    -- Answer Timer panel, located at the bottom of the frame
    local answerTimerPanel = vgui.Create("Panel", quizPanel)
    answerTimerPanel:SetSize(quizPanel:GetWide(), quizPanel:GetTall() * 0.1)
    answerTimerPanel:SetPos(0, quizPanel:GetTall() * 0.9)
    answerTimerPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(228, 52, 52))
    end

    local answerTimerText = vgui.Create("DLabel", answerTimerPanel)
    answerTimerText:SetSize(answerTimerPanel:GetWide(), answerTimerPanel:GetTall())
    answerTimerText:SetPos(0, 0)
    answerTimerText:SetText(cfg_cache.DefaultAnswerTime and cfg_cache.DefaultAnswerTime .. " second(s)" or "1" .. " second(s)")
    answerTimerText:SetFont("ATLASQUIZ.FONT:25")
    answerTimerText:SetTextColor(Color(255, 255, 255))
    answerTimerText:SetContentAlignment(2)

    answerTimerText.Think = function(self)
        if not timer.Exists("ATLASQUIZ.AnswerTimer") then return end
        local timeLeft = math.Round(timer.TimeLeft("ATLASQUIZ.AnswerTimer"))
        self:SetText(timeLeft .. " second(s)")
    end
end

-- CLose functions
function ATLASQUIZ.ClosePrepUI()
    if not IsValid(ATLASQUIZ.Frames.PrepPanel) then return end
    ATLASQUIZ.Frames.PrepPanel:Remove()
end

function ATLASQUIZ.CloseQuizUI()
    if not IsValid(ATLASQUIZ.Frames.QuizPanel) then return end
    ATLASQUIZ.Frames.QuizPanel:Remove()
end


net.Receive("ATLASQUIZ.Send", function()
    local question = net.ReadInt(cfg_cache.IntSize)
    ATLASQUIZ.HandleQuestion(question)
end)