
--[[---------------------------------------------------------------------------
Font Creation on this line
---------------------------------------------------------------------------]]

for i=1,100 do
    surface.CreateFont("Mono"..i, {
        font = "Monofonto",
        extended = false,
        size = ScreenScale(i * .3),
        weight = 500,
    })

    surface.CreateFont("MonoBold"..i, {
        font = "Monofonto",
        extended = false,
        size = ScreenScale(i * .3),
        weight = 700,
    })
end

--[[---------------------------------------------------------------------------
Including Files
---------------------------------------------------------------------------]]

local function includeDir(directory)
    local files, _ = file.Find(directory .. "/*.lua", "LUA")
    
    for _, filename in pairs(files) do
        local fullPath = directory .. "/" .. filename
        include(fullPath)
    end
end

-- Load UI files from the "myaddon/lua/ui" directory
includeDir("scprp_hud/lua/ui")