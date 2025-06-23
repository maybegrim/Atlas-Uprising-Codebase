include("shared.lua")

surface.CreateFont("LawBoardFont", {
    font = "Roboto Mono", 
    extended = false,
    size = 80,
    weight = 10, 
    blursize = 1, 
    scanlines = 3, 
    antialias = true,
    underline = false,
    italic = true, 
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = true, 
    shadowcolor = Color(0, 0, 0),
    additive = false,
    outline = true, 
    outlinecolor = Color(0, 0, 0),
})

local Laws = {
    "Atlas City Governing Board",
    "No Speeding",
    "No Loitering",
    "No Firearms",
    "No Illicit Substances",
    "The Speed Limit Within The Town of Atlas is 35 MPH",
    "Test line test line test",
    "Test line test linetest",
    "Test1",
    "Test2",
    "Test3",
    "This line is to test line wrap line wrap line wrap this line is to test line wrap all day long",
    "Test4",
}

local MAX_LINES = 7
local LINE_HEIGHT = 140
local BOX_WIDTH = 2280
local BOX_HEIGHT = (LINE_HEIGHT * MAX_LINES) + 300

function ENT:Initialize()
    self.scrollOffset = 0  
end

local function wrapText(text, font, maxWidth)
    surface.SetFont(font)
    local words = string.Split(text, " ")
    local lines = {}
    local currentLine = ""

    for _, word in ipairs(words) do
        local testLine = currentLine .. " " .. word
        local w, _ = surface.GetTextSize(testLine)

        if w > maxWidth then
            table.insert(lines, currentLine)
            currentLine = word
        else
            currentLine = testLine
        end
    end

    if currentLine ~= "" then
        table.insert(lines, currentLine)
    end

    return lines
end

function ENT:Draw()
    self:DrawModel()

    local ang = self:GetAngles()
    local pos = self:GetPos()

    -- Adjust the angles to ensure the UI is always aligned with the board
    local newAng = ang
    newAng:RotateAroundAxis(newAng:Right(), 270)
    newAng:RotateAroundAxis(newAng:Up(), 90)

    -- Calculate the position offset to place the UI on the board
    local screenOffset = Vector(1, 0, 1)
    local worldPos = self:LocalToWorld(screenOffset)

    cam.Start3D2D(worldPos, newAng, 0.1)

    draw.RoundedBox(100, -1150, -650, BOX_WIDTH, BOX_HEIGHT, Color(32, 32, 32))

    local yOffset = 10
    local visibleLaws = math.min(#Laws, MAX_LINES)

    for i = 1, visibleLaws do
        local lawIndex = (i - 1 + math.floor(self.scrollOffset / LINE_HEIGHT)) % #Laws + 1
        local law = Laws[lawIndex]
        local wrappedText = wrapText(law, "LawBoardFont", BOX_WIDTH - 80)

        for _, line in ipairs(wrappedText) do
            draw.DrawText(line, "LawBoardFont", -1100, yOffset - 500, Color(150, 144, 144), TEXT_ALIGN_LEFT)
            yOffset = yOffset + LINE_HEIGHT
        end
    end

    if #Laws > MAX_LINES then
        self.scrollOffset = (self.scrollOffset + .15) % (LINE_HEIGHT * (#Laws - MAX_LINES + 1))
    end

    cam.End3D2D()
end

