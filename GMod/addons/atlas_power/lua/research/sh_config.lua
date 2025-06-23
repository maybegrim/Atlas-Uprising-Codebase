RESEARCH.CONFIG = RESEARCH.CONFIG or {}

RESEARCH.CONFIG.LightSequence = {
    {state = "TurnOff", delay = 0.1},
    {state = "TurnOn", delay = 0.3},
    {state = "TurnOff", delay = math.random(0.9, 1.3)},
    {state = "TurnOn", delay = math.random(1.5, 2.0)},
    {state = "TurnOff", delay = math.random(2.2, 2.5)},
}

-- Timer added to delay the SCPToItems table creation so DarkRP can catch up
timer.Simple(1, function()
    RESEARCH.CONFIG.SCPToItems = {
        [TEAM_049] = "essence_049",
        [TEAM_682] = "essence_682",
        [TEAM_939] = "essence_939",
    }
end)

-- Time in minutes
RESEARCH.CONFIG.PowerTime = 240
RESEARCH.CONFIG.OnBootExtraTime = 60