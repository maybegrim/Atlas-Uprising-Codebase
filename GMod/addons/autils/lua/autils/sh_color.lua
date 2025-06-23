AddCSLuaFile()

function autil.ShiftColor(color, value)
    return Color(color.r * value, color.g * value, color.b * value, color.a)
end