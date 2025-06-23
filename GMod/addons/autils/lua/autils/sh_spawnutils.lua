AddCSLuaFile()

function autil.TraceEntitySpawnPosition(ply, limit)
    local vector_start = ply:GetShootPos()
    local vector_forward = ply:GetAimVector()

    local trace_info = {
        start = vector_start,
        endpos = vector_start + (vector_forward * (limit or 1000)),
        filter = ply
    }

    local trace = util.TraceLine(trace_info)

    return trace.HitPos
end