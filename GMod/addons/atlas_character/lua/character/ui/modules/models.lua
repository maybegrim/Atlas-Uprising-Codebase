local MODELUTIL = {}


function MODELUTIL:GetModelTable(job)
    local aTable, bTable = {}, {}
    if not istable(RPExtraTeams[job].model) then
        return {RPExtraTeams[job].model}, {RPExtraTeams[job].model}
    end
    for k,v in pairs(RPExtraTeams[job].model) do
        if string.find(v, "female") then
            table.insert(bTable, v)
        else
            table.insert(aTable, v)
        end
    end

    if #bTable == 0 then
        return aTable, aTable
    end
    return aTable, bTable
end

return MODELUTIL