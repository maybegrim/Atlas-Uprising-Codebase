AddCSLuaFile()

local PROMPT_ACCEPT = "A"
local PROMPT_REJECT = "R"

if SERVER then
    util.AddNetworkString("AU.Amnestics.Prompt")

    net.Receive("AU.Amnestics.Prompt", function (len, ply)
        local option = net.ReadString()

        if option == PROMPT_ACCEPT then
            ply.AmnesticPromptCallback(ply, true)
        elseif option == PROMPT_REJECT then
            ply.AmnesticPromptCallback(ply, false)
        end
    end)

    function AU.Amnestics.Prompt(ply, callback)
        ply.AmnesticPromptCallback = callback

        net.Start("AU.Amnestics.Prompt")
        net.Send(ply)
    end
elseif CLIENT then
    function AU.Amnestics.ClientInitPrompt()
        Derma_Query(
            "You have the option of resisting or giving in. If you choose to accept you have a small chance of countering the effects. Be prepared.",
            "You are being amnesticized.",
            "Resist",
            function ()
                net.Start("AU.Amnestics.Prompt")
                    net.WriteString(PROMPT_ACCEPT)
                net.SendToServer()
            end,
            "Give In",
            function ()
                net.Start("AU.Amnestics.Prompt")
                    net.WriteString(PROMPT_REJECT)
                net.SendToServer()
            end
        )
    end

    net.Receive("AU.Amnestics.Prompt", function ()
        AU.Amnestics.ClientInitPrompt()
    end)
end