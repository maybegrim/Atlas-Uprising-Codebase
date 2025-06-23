-- Create convar
local debugUI = CreateConVar("debug_ui", "0", FCVAR_ARCHIVE, "Enable the debug UI")

-- Create the font
surface.CreateFont("DebugFont", {
    font = "Exo 2 Medium",
    size = 18,
    weight = 500,
})

local tickrate = 0
local tickrate2 = 0

hook.Add("Tick", "Tickrate", function()
    tickrate = tickrate + 1
end)

timer.Create("Tickrate", 1, 0, function()
    tickrate2 = tickrate
    tickrate = 0
end)

local mem = collectgarbage("count")
timer.Create("Memory", 1, 0, function()
    mem = collectgarbage("count")
end)

local function mapEnts()
    local mapEnts = {}
    for _, ent in pairs(ents.GetAll()) do
        if ent:CreatedByMap() then
            table.insert(mapEnts, ent)
        end
    end
    return mapEnts
end

local function edictCount()
    local edictCount = 0
    for _, ent in pairs(ents.GetAll()) do
        edictCount = edictCount + 1
    end
    return edictCount
end

-- Keys being pressed
local keys = {
    [KEY_0] = true,
    [KEY_1] = true,
    [KEY_2] = true,
    [KEY_3] = true,
    [KEY_4] = true,
    [KEY_5] = true,
    [KEY_6] = true,
    [KEY_7] = true,
    [KEY_8] = true,
    [KEY_9] = true,
    [KEY_A] = true,
    [KEY_B] = true,
    [KEY_C] = true,
    [KEY_D] = true,
    [KEY_E] = true,
    [KEY_F] = true,
    [KEY_G] = true,
    [KEY_H] = true,
    [KEY_I] = true,
    [KEY_J] = true,
    [KEY_K] = true,
    [KEY_L] = true,
    [KEY_M] = true,
    [KEY_N] = true,
    [KEY_O] = true,
    [KEY_P] = true,
    [KEY_Q] = true,
    [KEY_R] = true,
    [KEY_S] = true,
    [KEY_T] = true,
    [KEY_U] = true,
    [KEY_V] = true,
    [KEY_W] = true,
    [KEY_X] = true,
    [KEY_Y] = true,
    [KEY_Z] = true,
    [KEY_F1] = true,
    [KEY_F2] = true,
    [KEY_F3] = true,
    [KEY_F4] = true,
    [KEY_F5] = true,
    [KEY_F6] = true,
    [KEY_F7] = true,
    [KEY_F8] = true,
    [KEY_F9] = true,
    [KEY_F10] = true,
    [KEY_F11] = true,
    [KEY_F12] = true,
    [KEY_PAD_0] = true,
    [KEY_PAD_1] = true,
    [KEY_PAD_2] = true,
    [KEY_PAD_3] = true,
    [KEY_PAD_4] = true,
    [KEY_PAD_5] = true,
    [KEY_PAD_6] = true,
    [KEY_PAD_7] = true,
    [KEY_PAD_8] = true,
    [KEY_PAD_9] = true,
    [KEY_PAD_DIVIDE] = true,
    [KEY_PAD_MULTIPLY] = true,
    [KEY_PAD_MINUS] = true,
    [KEY_PAD_PLUS] = true,
    [KEY_PAD_ENTER] = true,
    [KEY_PAD_DECIMAL] = true,
    [KEY_LSHIFT] = true,
    [KEY_RSHIFT] = true,
    [KEY_LALT] = true,
    [KEY_RALT] = true,
    [KEY_LCONTROL] = true,
    [KEY_RCONTROL] = true,
    [KEY_SPACE] = true,
    [KEY_CAPSLOCK] = true,
    [KEY_NUMLOCK] = true,
    [KEY_SCROLLLOCK] = true,
    [KEY_ENTER] = true,
    [KEY_TAB] = true,
    [KEY_BACKSPACE] = true,
    [KEY_ESCAPE] = true,
    [KEY_INSERT] = true,
    [KEY_DELETE] = true,
    [KEY_HOME] = true,
    [KEY_END] = true,
    [KEY_PAGEUP] = true,
    [KEY_PAGEDOWN] = true,
    [KEY_BREAK] = true,
    [KEY_LWIN] = true,
    [KEY_RWIN] = true,
    [KEY_APP] = true,
    [KEY_UP] = true,
    [KEY_LEFT] = true,
    [KEY_DOWN] = true,
    [KEY_RIGHT] = true,
}

local activeKeys = {}

-- Key press
hook.Add( "Think", "KeyDetection", function()
    for k, v in pairs( keys ) do
        if input.IsKeyDown( k ) then
            activeKeys[k] = true
        else
            activeKeys[k] = nil
        end
    end
end )

-- Key press
local function KeysPressed()
    local str = ""
    for k, v in pairs( activeKeys ) do
        str = str .. " " .. string.upper(input.GetKeyName( k ))
    end
    return string.len(str) > 0 and str or "None"
end

-- Create the debug UI
local function DrawDebugUI()
    -- If the debug UI is disabled, don't draw it
    if not debugUI:GetBool() then return end
    -- Get the screen size
    local scrW, scrH = ScrW(), ScrH()
    
    -- Set up the drawing color and font
    surface.SetFont("DebugFont")
    surface.SetTextColor(255, 255, 255, 255)  -- White text

    -- Get the player's position, angle, and velocity
    local pos = LocalPlayer():GetPos()
    local ang = LocalPlayer():GetAngles()
    local vel = LocalPlayer():GetVelocity()

    -- Get the number of hooks
    local hookCount = 0
    for _ in pairs(hook.GetTable()) do
        hookCount = hookCount + 1
    end


    -- Function to get the information text
    local infoText = {
        "Biobolt Debug UI",
        "FPS: " .. math.Round(1 / FrameTime()),
        "Ping: " .. LocalPlayer():Ping(),
        "Server: " .. GetHostName(),
        "Map: " .. game.GetMap(),
        "Players: " .. #player.GetAll(),
        "Entities: " .. #ents.GetAll(),
        "Map Entities: " .. #mapEnts(),
        "Edicts: " .. edictCount() .. " (CLIENTSIDE)",
        "Gamemode: " .. GAMEMODE.Name,
        "Tickrate: " .. tickrate2,
        "Tick: " .. tickrate,
        --"Memory: " .. math.Round(mem) .. " KB",
        "LUA Memory: " .. math.Round(mem / 1024) .. " MB",
        "Hooks: " .. hookCount,  -- Note: hookCount needs to be calculated beforehand
        "Position: " .. math.Round(pos.x) .. ", " .. math.Round(pos.y) .. ", " .. math.Round(pos.z),
        "Angle: " .. math.Round(ang.x) .. ", " .. math.Round(ang.y) .. ", " .. math.Round(ang.z),
        "Velocity: " .. math.Round(vel.x) .. ", " .. math.Round(vel.y) .. ", " .. math.Round(vel.z),
        "SteamID: " .. LocalPlayer():SteamID(),
        "Keys: " .. KeysPressed(),
    }
    
    -- Calculate the height of the background based on the text
    local textHeight = #infoText * 20  -- Assuming each line of text is 20 pixels tall
    
    -- Draw background that scales with info
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(scrW - 300, 15, 300, textHeight + 10)
    
    -- Draw text information
    local y = 20
    for _, text in ipairs(infoText) do
        surface.SetTextPos(scrW - 290, y)
        surface.DrawText(text)
        y = y + 20  -- Increment the y position for the next line
    end
    
    -- ... Add more information as needed
end

-- Hook the DrawDebugUI function to the HUDPaint hook so it draws every frame
hook.Add("HUDPaint", "DebugUI", DrawDebugUI)
