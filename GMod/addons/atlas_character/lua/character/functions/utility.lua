local Utility = {}

function Utility.isValidChar(char)
    print(istable(char))
    if not char or not istable(char) then return false end

    local requiredFields = {
        "steamid", "first_name", "last_name", "type", 
        "description", "preferred_model", "height", "team"
    }

    for _, field in ipairs(requiredFields) do
        if not char[field] then return false end
    end

    return true
end

function Utility.getTypeName(pTypeInt)
    return pTypeInt == 1 and "male" or "female"
end

function Utility.isValidCharType(pType)
    if not pType then return false end
    if pType == 1 or pType == 2 then return true end
    return false
end

function Utility.isTypeExist(pType, pFaction)
    if not pType or not pFaction then return false end
    local modelData = CHARACTER.CONFIG.ModelChoice[pFaction]
    if not modelData then return false end
    if not modelData[Utility.getTypeName(pType)] then return false end
    return true
end

-- TODO: Refactor this to ustilize future faction function as current method is not ideal
function Utility.isValidCharMdl(pMdl, pFaction, pType, pTeam)
    if not pMdl then return false end
    if CHARACTER.CONFIG.UseJobModels[RPExtraTeams[pTeam].category] then
        if not istable(RPExtraTeams[pTeam].model) then
            if RPExtraTeams[pTeam].model == pMdl then return true end
        end
        for _, mdl in ipairs(RPExtraTeams[pTeam].model) do
            local mdl = string.lower(mdl)
            local pMdl = string.lower(pMdl)
            if mdl == pMdl then return true end
        end
        return false
    end
    local modelData = CHARACTER.CONFIG.ModelChoice[pFaction]
    if not modelData then return false end
    if not modelData[Utility.getTypeName(pType)] then return false end
    for _, mdl in ipairs(modelData[Utility.getTypeName(pType)]) do
        if mdl == pMdl then return true end
    end
    return false
end

function Utility.isValidCharHeight(pHeight)
    if not pHeight then return false end
    if CHARACTER.CONFIG.Height[pHeight] then return true end
    return false
end

-- Laggy so we will probably change.
function Utility.getTeamIndexByName(name)
    for teamIndex = 0, #team.GetAllTeams() do
        if team.GetName(teamIndex) == name then
            return teamIndex
        end
    end
    return nil
end

function Utility.isValidTeam(pTeam)
    if not pTeam then return false end
    if not RPExtraTeams[pTeam] then return false end
    return true
end


function Utility.heightToScale(heightInInches)
    local REFERENCE_HEIGHT = 69
    local SCALE_PER_INCH = 0.02
    local difference = heightInInches - REFERENCE_HEIGHT
    return 1.0 + (difference * SCALE_PER_INCH)
end

function Utility.validatePlayer(ply)
    if not ply or not ply:IsValid() or not ply:IsPlayer() then
        return false
    end
    return true
end

function Utility.isNameInUse(first, last, callback)
    local paramTable = {
        first_name = first,
        last_name = last
    }
    ATLASDATA.RequestData(CHARACTER.CONFIG.SQLTableName or "atlas_characters", paramTable, function(result, data)
        if result then
            PrintTable(data)
            callback(#data.data >= 1 and true or false)
        end
    end)
end

function Utility.getFactionFromTeam(pTeam)
    return RPExtraTeams[pTeam].faction or false
end

function Utility.getDepartmentFromTeam(pTeam)
    return RPExtraTeams[pTeam].department or false
end

return Utility