if not GYS.EnableSLogs then return end

hook.Add("GYS.Detection", "SquishLogs:Log:GYS", function(ply, method)
    SquishLog:New()
        :SetCategory("GYS | Detections")
        :AddFragment(ply)
        :AddFragment(" was detected using " .. method .. ".")
        :Send()
end)