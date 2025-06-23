TOOL.Category = "Utility"
TOOL.Name = "Entity Info Logger"

if CLIENT then
    language.Add("tool.entity_info_logger.name", "Entity Info Logger")
    language.Add("tool.entity_info_logger.desc", "Logs entity position and angle to chat.")
    language.Add("tool.entity_info_logger.0", "Left-click to log entity info.")
end

function TOOL:LeftClick(trace)
    if not IsValid(trace.Entity) then return false end
    if CLIENT then return true end

    local ply = self:GetOwner()
    local ent = trace.Entity
    local pos = ent:GetPos()
    local ang = ent:GetAngles()

    ply:ChatPrint("[Entity Info]")
    ply:ChatPrint("Position: " .. tostring(pos))
    ply:ChatPrint("Angle: " .. tostring(ang))
    return true
end
