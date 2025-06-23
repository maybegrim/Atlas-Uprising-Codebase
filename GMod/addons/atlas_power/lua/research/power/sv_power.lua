RESEARCH.POWER = RESEARCH.POWER or {}
RESEARCH.POWER.ISPOWERDOWN = false


-- Function to cache light entities
function RESEARCH.POWER.Init()
    RESEARCH.POWER.LCZLights = ents.FindByName("lcz_light")
    RESEARCH.POWER.HCZLights = ents.FindByName("hcz_light")
    RESEARCH.POWER.EZLights = ents.FindByName("ez_light")
    RESEARCH.POWER.RedLights = ents.FindByName("red_light_emergency")

    RESEARCH.POWER.StartPowerTimer(true)
end
-- Cache light sequence from config
local flickerSequence = RESEARCH.CONFIG.LightSequence

-- Flicker Sequence Helper Function
local function flickerSequenceFunc(light, sequence, index)
    if index > #sequence then
        return
    end
    local state = sequence[index].state
    local delay = sequence[index].delay
    light:Fire(state, "", 0)
    timer.Simple(delay, function()
        flickerSequenceFunc(light, sequence, index + 1)
    end)
end

-- Function to flicker lights with more natural and random patterns
local function flickerLights(entities)
    if #entities > 0 then
        for _, light in pairs(entities) do
            flickerSequenceFunc(light, flickerSequence, 1)
        end
    else
        print("Light entity not found.")
    end
end

local emergencyLightsOn = false
local function emergencyLightsToggle(entities)
    if #entities > 0 then
        for _, light in pairs(entities) do
            if emergencyLightsOn then
                light:Fire("TurnOff", "", 0)
            else
                -- Flickering effect
                for i = 1, 5 do
                    light:Fire("TurnOn", "", 0)
                    timer.Simple(0.1, function() light:Fire("TurnOff", "", 0) end)
                    timer.Simple(0.2, function() light:Fire("TurnOn", "", 0) end)
                end
                -- Stabilize the light
                timer.Simple(1, function() light:Fire("TurnOn", "", 0) end)
            end
        end
        emergencyLightsOn = not emergencyLightsOn
    else
        print("Light entity not found.")
    end
end

-- Function to start power level timer
function RESEARCH.POWER.StartPowerTimer(isStartup)
    if isStartup then
        timer.Create("RESEARCH::POWER::TIMER", (RESEARCH.CONFIG.PowerTime + RESEARCH.CONFIG.OnBootExtraTime) * 60, 1, function()
            RESEARCH.POWER.GoDown()
        end)
        return
    end
    timer.Create("RESEARCH::POWER::TIMER", RESEARCH.CONFIG.PowerTime * 60, 1, function()
        RESEARCH.POWER.GoDown()
    end)
end

-- Function to reset the power level timer
function RESEARCH.POWER.ResetPowerTimer()
    timer.Remove("RESEARCH::POWER::TIMER")
    RESEARCH.POWER.StartPowerTimer()
end

-- Function to get the current time left on the power level timer
function RESEARCH.POWER.GetPowerTimeLeft()
    return timer.TimeLeft("RESEARCH::POWER::TIMER")
end

function RESEARCH.POWER.Restore()
    RESEARCH.POWER.ISPOWERDOWN = false
    for _, light in pairs(RESEARCH.POWER.LCZLights) do
        light:Fire("TurnOn", "", 0)
    end
    for _, light in pairs(RESEARCH.POWER.HCZLights) do
        light:Fire("TurnOn", "", 0)
    end
    for _, light in pairs(RESEARCH.POWER.EZLights) do
        light:Fire("TurnOn", "", 0)
    end
    emergencyLightsToggle(RESEARCH.POWER.RedLights)

    -- Remove the cover buttons
    local cover = ents.FindByClass("ent_cover_button")
    for _, ent in pairs(cover) do
        ent:Remove()
    end

    net.Start("RESEARCH::POWER::UP")
    net.Broadcast()

    RESEARCH.POWER.ResetPowerTimer()
end

-- Function to trigger off lights
function RESEARCH.POWER.GoDown()
    RESEARCH.POWER.ISPOWERDOWN = true
    RESEARCH.POWER.SpawnElecCovers()
    flickerLights(RESEARCH.POWER.LCZLights)
    flickerLights(RESEARCH.POWER.HCZLights)
    flickerLights(RESEARCH.POWER.EZLights)

    net.Start("RESEARCH::POWER::DOWN")
    net.Broadcast()

    timer.Simple(6, function()
        emergencyLightsToggle(RESEARCH.POWER.RedLights)
    end)
end

-- Function to load the elec cover
function RESEARCH.POWER.SpawnElecCovers()
    local data = file.Read("research_elec_cover.txt", "DATA")
    if not data then return end
    
    local covers = util.JSONToTable(data)
    for _, cover in pairs(covers) do
        local ent = ents.Create("ent_cover_button")
        ent:SetPos(cover.pos)
        ent:SetAngles(cover.ang)
        ent:Spawn()
        -- freeze
        local physObj = ent:GetPhysicsObject()
        if physObj:IsValid() then
            physObj:EnableMotion(false)
        end
    end
end

-- hook to check if an entity called ent_cover_button is created by a player and if so chat print them
hook.Add("PlayerSpawnedSENT", "RESEARCH.POWER.CheckElecCover", function(ply, ent)
    if ent:GetClass() == "ent_cover_button" then
        ply:ChatPrint("To save this ents location type `save_elec_cover` in console!")
        ent:SetMaterial("hunter/myplastic")
    end
end)

-- Dev console commands
--[[concommand.Add("flicker_lights", function(ply)
    if not ply:IsSuperAdmin() then return end
    RESEARCH.POWER.GoDown()
end)
concommand.Add("turn_on_lights", function(ply)
    if not ply:IsSuperAdmin() then return end
    for _, light in pairs(RESEARCH.POWER.LCZLights) do
        light:Fire("TurnOn", "", 0)
    end
    for _, light in pairs(RESEARCH.POWER.HCZLights) do
        light:Fire("TurnOn", "", 0)
    end
    for _, light in pairs(RESEARCH.POWER.EZLights) do
        light:Fire("TurnOn", "", 0)
    end
    for _, light in pairs(RESEARCH.POWER.RedLights) do
        light:Fire("TurnOff", "", 0)
    end
end)]]

-- Save position of ent_cover_button via console command
concommand.Add("save_elec_cover", function(ply)
    if not ply:IsSuperAdmin() then return end
    local cover = ents.FindByClass("ent_cover_button")
    local covers = {}
    for _, ent in pairs(cover) do
        table.insert(covers, {
            pos = ent:GetPos(),
            ang = ent:GetAngles()
        })
        ent:Remove()
    end
    ply:ChatPrint("Saved " .. #covers .. " elec covers!")
    file.Write("research_elec_cover.txt", util.TableToJSON(covers))
end)


-- Hook to initialize the light entities
hook.Add("InitPostEntity", "RESEARCH.POWER.CacheLights", RESEARCH.POWER.Init)