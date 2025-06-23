util.AddNetworkString("ATLASQUIZ.Send")
util.AddNetworkString("ATLASQUIZ.Answer")
ATLASQUIZ.OngoingQuizzes = ATLASQUIZ.OngoingQuizzes or {}
local cfg = ATLASQUIZ.CFG

local function IsValidQuestion(question)
    if not question then return false end
    if not question.question then return false end
    if not question.answers then return false end
    if not question.correctAnswer then return false end
    return true
end

local function GetQuestion()
    local id = math.random(1, #cfg.Questions)
    local question = cfg.Questions[id]
    return question, id
end

local function GetValidQuestion()
    for i = 1, 10 do
        local question, qid = GetQuestion()

        if IsValidQuestion(question) then
            return qid
        end
    end
    return false
end


-- lua_run_sv ATLASQUIZ.QuizPly(Entity(1), _, function(p,s) print(p,s) end)

-- TODO: Implement customParams
function ATLASQUIZ.QuizPly(ply, numQuestions, callback)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end

    local question_id = GetValidQuestion()
    print("[ATLASQUIZ] Question ID: ", question_id)

    if not question_id then
        print("[ATLASQUIZ] Failed to locate a valid question!")
        return false
    end

    if not isnumber(numQuestions) then
        numQuestions = 1
    end

    if numQuestions < 1 then
        numQuestions = 1
    end

    ATLASQUIZ.OngoingQuizzes[ply:SteamID64()] = {
        questions = {},
        current = 1,
        total = numQuestions,
        callback_fnc = callback
    }

    for i = 1, numQuestions do
        table.insert(ATLASQUIZ.OngoingQuizzes[ply:SteamID64()].questions, GetValidQuestion())
    end

    ATLASQUIZ.SendQuestion(ply)
end

function ATLASQUIZ.SendQuestion(ply)
    local quiz = ATLASQUIZ.OngoingQuizzes[ply:SteamID64()]
    if not quiz then return end

    local question_id = quiz.questions[quiz.current]
    net.Start("ATLASQUIZ.Send")
        net.WriteInt(question_id, cfg.IntSize)
    net.Send(ply)
end

function ATLASQUIZ.ValidateAnswer(ply, response)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end

    if not response then return end
    if not isstring(response) then return end

    local quiz = ATLASQUIZ.OngoingQuizzes[ply:SteamID64()]
    if not quiz then return end

    local question = cfg.Questions[quiz.questions[quiz.current]]
    if not question then return end

    if question.answers[question.correctAnswer] == response then
        print("[ATLASQUIZ] " .. ply:Nick() .. " answered correctly.")
        quiz.current = quiz.current + 1
        if quiz.current > quiz.total then
            quiz.callback_fnc(ply, true)
            ATLASQUIZ.OngoingQuizzes[ply:SteamID64()] = nil
        else
            ATLASQUIZ.SendQuestion(ply)
        end
    else
        print("[ATLASQUIZ] " .. ply:Nick() .. " answered incorrectly.")
        quiz.callback_fnc(ply, false)
        ATLASQUIZ.OngoingQuizzes[ply:SteamID64()] = nil
    end
end

function ATLASQUIZ.OutOfTime(ply)
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end

    local quiz = ATLASQUIZ.OngoingQuizzes[ply:SteamID64()]
    if not quiz then return end

    quiz.callback_fnc(ply, false)
    ATLASQUIZ.OngoingQuizzes[ply:SteamID64()] = nil
end

net.Receive("ATLASQUIZ.Answer", function(_, ply)
    local result = net.ReadBool()
    local answer = net.ReadString()
    if result == true then
        print("[ATLASQUIZ] " .. ply:Nick() .. " ran out of time.")
        ATLASQUIZ.OutOfTime(ply)
        return
    end
    print("[ATLASQUIZ] " .. ply:Nick() .. " answered " .. answer)
    ATLASQUIZ.ValidateAnswer(ply, answer)
end)