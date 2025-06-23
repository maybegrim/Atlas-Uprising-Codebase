if not GYS.DataLog then return end


if not file.Exists( "GYS", "DATA" ) then
    file.CreateDir("gys")
end

local logFileName = "gys/" .. "gys-" .. os.date("%d-%m-%Y") .. ".txt"
if not file.Exists( logFileName, "DATA" ) then
    file.Write(logFileName, "[GYS] Data Log Started!")
end


GYS.Log = function(message)
    local frmtMsg = "[GYS] " .. message .. "\n"
    print(frmtMsg)
    file.Append(logFileName, frmtMsg)
end

GYS.Log("Loaded DataLog")