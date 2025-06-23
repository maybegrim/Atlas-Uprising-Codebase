AddCSLuaFile()

function AU.Amnestics.RegisterAmnestic(class, data)
    local display_name = "Class-" .. string.upper(class) .. " Amnestic"
    local c_name = "amnestic_" .. string.lower(class)

    local swep_table = {
        Base = "au_amnestic_base",
        Spawnable = true,
        PrintName = display_name,
        Category = "[AU] Amnestics",
        AmnesticClass = string.lower(class),
        AmnesticEffects = data.Effects,
        AlgebraDifficulty = {
            QuestionCount = data.QuestionCount,
            QuestionTime = data.QuestionTime
        }
    }

    weapons.Register(swep_table, "au_" .. c_name)

    hook.Add("AU.Amnestics.ElixirRegister", string.upper(class), function ()
        Elixir.RegisterItem(c_name, {
            name = display_name,
            on_consume = function (ply)
                ply:Give("au_" .. c_name)
            end,
            expiration_time = 0
        })
    end)
end

AU.Amnestics.RegisterAmnestic("A", {
    Effects = [[You have lost random memories, but mostly those formed within the last 5-6 hours. You have lost any "highly unique episodic memories," such as any encounters with anomalous activity or otherwise notable events.]],
    QuestionCount = 10,
    QuestionTime = 2.5
})

AU.Amnestics.RegisterAmnestic("B", {
    Effects = [[You have lost all memories and knowledge formed within the last 24 hours (unless specified otherwise).]],
    QuestionCount = 10,
    QuestionTime = 2.5
})

AU.Amnestics.RegisterAmnestic("C", {
    Effects = [[You have lost all memories related to the specified event.]],
    QuestionCount = 10,
    QuestionTime = 2.5
})

AU.Amnestics.RegisterAmnestic("D", {
    Effects = [[You have lost a portion of your memories starting from the earliest point in your life (within a specified amount of time). General skills (language, speech, motor control, etc.) are intact, but specific memories relating to your identity within that time period have been expunged.]],
    QuestionCount = 10,
    QuestionTime = 2.5
})

AU.Amnestics.RegisterAmnestic("E", {
    Effects = [[All memories regarding significant events (anomalous activity, Foundation activities, etc.) have been altered to seem normal. These memories fade into the background and become more-or-less forgotten, but still technically present.]],
    QuestionCount = 10,
    QuestionTime = 2.5
})

AU.Amnestics.RegisterAmnestic("F", {
    Effects = [[You have forgotten all memories related to your current identity. General skills (language, speech, motor control, etc.) are intact, but specific memories about your current identity are expunged. You may be assigned a new identity by the person who has amnesticized you or left to redevelop your identity on your own.]],
    QuestionCount = 10,
    QuestionTime = 2.5
})

AU.Amnestics.RegisterAmnestic("G", {
    Effects = [[All memories regarding previous anomalous experiences have been made to seem fake, almost as if they were a dream. You have been made to doubt the authenticity of those memories.]],
    QuestionCount = 10,
    QuestionTime = 2.5
})

AU.Amnestics.RegisterAmnestic("H", {
    Effects = [[The creation of new memories has been blocked within your brain for the next hour (unless specified otherwise). All new experiences within this time frame will be immediately forgotten.]],
    QuestionCount = 10,
    QuestionTime = 2.5
})

AU.Amnestics.RegisterAmnestic("I", {
    Effects = [[You are blocked from recalling past memories for the next hour (unless specified otherwise).]],
    QuestionCount = 10,
    QuestionTime = 2.5
})

AU.Amnestics.RegisterAmnestic("W", {
    Effects = [[In addition to an enhanced memory, you have been allowed to perceive and retain memories of any antimemes for the next hour (unless specified otherwise).]],
    QuestionCount = 10,
    QuestionTime = 2.5
})

AU.Amnestics.RegisterAmnestic("X", {
    Effects = [[You have regained knowledge of the specified suppressed memories or perceived antimemes.]],
    QuestionCount = 10,
    QuestionTime = 2.5
})

AU.Amnestics.RegisterAmnestic("Y", {
    Effects = [[You have gained the ability to perfectly recall any memories gained within the next hour (unless specified otherwise).]],
    QuestionCount = 10,
    QuestionTime = 2.5
})

AU.Amnestics.RegisterAmnestic("Z", {
    Effects = [[You are now biochemically incapable of forgetting anything. You will inevitably die within the next few hours.]],
    QuestionCount = 10,
    QuestionTime = 2.5
})