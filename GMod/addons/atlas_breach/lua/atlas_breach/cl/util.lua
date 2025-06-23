surface.CreateFont("SCP::BREACH::FONT", {
    font = "MADE Tommy Soft",
    size = 20,
    weight = 500,
    antialias = true,
    shadow = false
})

for i = 10, 50 do
    if i == 20 then continue end -- We have this font size already
    surface.CreateFont("SCP::BREACH::FONT::" .. tostring(i), {
        font = "MADE Tommy Soft",
        size = i,
        weight = 500,
        antialias = true,
        shadow = false,
    })
end