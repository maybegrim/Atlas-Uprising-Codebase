CHARACTER.CurChars = CHARACTER.CurChars or {}
CHARACTER.CharacterApplyQueue = CHARACTER.CharacterApplyQueue or {}

-- Load the utility module from the specified path, making various utility functions available through the 'Utility' variable.
-- This module is expected to be located at "character/functions/utility.lua".
local Utility = include("character/functions/utility.lua")

-- Include and execute the script from "character/data/init.lua", which contains functions and data necessary for character data initialization.
-- This will ensure that the initial setup related to character data is performed before we proceed with other operations.
include("character/data/init.lua")

-- Declare the SQL table name to be used for character data. Avoiding magic string.
local ATLAS_CHARACTERS_TABLE = CHARACTER.CONFIG.SQLTableName or "atlas_characters"

-- Declaring Net Strings
util.AddNetworkString("ATLAS::Characters::CreateChar")
util.AddNetworkString("ATLAS::Characters::RequestChars")
util.AddNetworkString("ATLAS::Characters::SendChars")
util.AddNetworkString("ATLAS::Characters::PlayChar")
util.AddNetworkString("ATLAS::Characters::EditChar")
util.AddNetworkString("ATLAS::Characters::DeleteChar")
util.AddNetworkString("ATLAS::Characters::OpenUI")

-- Helper function to send character data to the client
local function sendCharData(ply)
    CHARACTER.RetrieveChars(ply:SteamID64(), function(pResult, pData)
        if pResult then
            net.Start("ATLAS::Characters::SendChars")
            net.WriteTable(pData)
            net.Send(ply)
        end
    end)
end

-- Helper function to send creation status and optional error message
local function sendCreationStatus(ply, success, errMsg)
    net.Start("ATLAS::Characters::CreateChar")
    net.WriteBool(success)
    if errMsg then
        net.WriteString(errMsg)
    end
    net.Send(ply)
end

-- Helper function to validate character creation parameters
local function validateCharParams(pData)
    local isFirstNameValid, firstNameReason = ATLASCORE.UTIL:isValidName(pData.first_name)
    local isLastNameValid, lastNameReason = ATLASCORE.UTIL:isValidName(pData.last_name)
    if not isFirstNameValid then return "First Name Error - " .. firstNameReason end
    if not isLastNameValid then return "Last Name Error - " .. lastNameReason end
    if not Utility.isValidCharType(pData.type) then return "Invalid character type" end
    if not ATLASCORE.UTIL:isSafeDescription(pData.description) then return "Description contains invalid symbols" end
    local cleanResult, cleanReason = ATLASCORE.UTIL:isCleanText(pData.description)
    if not cleanResult then return cleanReason or "Description contains harmful words" end
    if not Utility.isValidCharHeight(pData.height) then return "Invalid height" end
    if not Utility.isValidTeam(pData.team) then return "Invalid team" end
    local faction = Utility.getFactionFromTeam(pData.team)
    if not Utility.isTypeExist(pData.type, faction) then return "Invalid type" end
    if not Utility.isValidCharMdl(pData.preferred_model, faction, pData.type, pData.team) then return "Invalid model" end 
    return nil
end

function CHARACTER.CreateChar(pData, ply)
    if not Utility.validatePlayer(ply) then return end
    if not pData then
        sendCreationStatus(ply, false, "Missing data was sent.")
        return
    end
    if not ATLASCORE.UTIL:rateLimiter(ply, "CHARACTER_CREATION", 5, 1) then 
        sendCreationStatus(ply, false, "Rate limit exceeded, please wait a moment.")
        return
    end

    local errMsg = validateCharParams(pData)
    if errMsg then
        sendCreationStatus(ply, false, errMsg)
        return
    end

    Utility.isNameInUse(pData.first_name, pData.last_name, function(pInUse)
        if pInUse then
            print("Name already in use")
            sendCreationStatus(ply, false, "Name already in use")
            return
        end

        local paramTable = {
            steamid = ply:SteamID64(),
            first_name = pData.first_name,
            last_name = pData.last_name,
            type = pData.type,
            description = pData.description,
            preferred_model = pData.preferred_model,
            height = pData.height,
            team = pData.team
        }

        ATLASDATA.CommitData(ATLAS_CHARACTERS_TABLE, paramTable, function(result, dataTable)
            if result then
                sendCharData(ply)
                sendCreationStatus(ply, true)
            else
                sendCreationStatus(ply, false, "Data commit failed")
            end
        end)
    end)
end


function CHARACTER.DeleteChar(char, callback)
    local validChar = Utility.isValidChar(char)
    if not validChar then
        if callback then callback(false, "Invalid Table") end
        return
    end

    CHARACTER.RetrieveChar(char.first_name, char.last_name, char.steamid, function(result, pChar)
        if not result then
            if callback then callback(false, "Failed to retrieve character") end
            return
        end
        ATLASDATA.DeleteData(ATLAS_CHARACTERS_TABLE, "id", pChar[1].id, function(result, data)
            if result then
                local ply = ATLASCORE.UTIL:getPlayerBySteamID(pChar[1].steamid)
                if ply then
                    sendCharData(ply)
                end
                if callback then callback(true, data) end
            else
                if callback then callback(false, "Failed to delete data") end
            end
        end)
    end)
end

function CHARACTER.RetrieveChar(pFirstName, pLastName, sid, callback)
    -- TODO: Validate params
    if not ATLASCORE.UTIL:rateLimiter(ATLASCORE.UTIL:getPlayerBySteamID(sid), "CHARACTER_RETRIEVE", 5, 5) then
        if callback then callback(false, "Rate limit exceeded") end
        return
    end

    local sid64 = ATLASCORE.UTIL:getSteamID64(sid)
    local paramTable = {first_name = pFirstName, last_name = pLastName, steamid = sid64}
    ATLASDATA.RequestData(ATLAS_CHARACTERS_TABLE, paramTable, function(result, data)
        if result then
            if callback then callback(true, data.data) end
        else
            if callback then callback(false, "Failed to retrieve data") end
        end
    end)
end

function CHARACTER.RetrieveChars(sid, callback)
    -- TODO: Validate Params
    if not ATLASCORE.UTIL:rateLimiter(ATLASCORE.UTIL:getPlayerBySteamID(sid), "CHARACTER_RETRIEVE", 5, 5) then return end

    local sid64 = ATLASCORE.UTIL:getSteamID64(sid)
    local paramTable = {
        steamid = sid64
    }
    ATLASDATA.RequestData(ATLAS_CHARACTERS_TABLE, paramTable, function(result, data)
        if result then
            if callback then callback(true, data.data) end
        else
            if callback then callback(false, "Failed to retrieve data") end
        end
    end)
end

function CHARACTER.UpdateChar(pOldChar, pPly, pEditData, callback)
    -- Retrieve the character data from the database
    CHARACTER.RetrieveChar(pOldChar.first_name, pOldChar.last_name, pPly:SteamID64(), function(pResult, pData)
        if pResult then
            -- Character exists so lets update it
            local oldChar = pOldChar
            local char = pEditData
            char.steamid = pPly:SteamID64()
            oldChar.steamid = pPly:SteamID64()
            -- Validate the character data
            local errMsg = validateCharParams(oldChar)
            if errMsg then
                print(errMsg)
                if callback then callback(false, errMsg) end
                return
            end
            local errMsg = validateCharParams(char)
            if errMsg then
                if callback then callback(false, errMsg) end
                return
            end

            -- Delete the old character
            CHARACTER.DeleteChar(oldChar, function(pResult, pData)
                if pResult then
                    -- Create the new character
                    CHARACTER.CreateChar(char, pPly)
                else
                    if callback then callback(false, "Failed to delete character") end
                end
            end)
        else
            -- If the character data failed to retrieve, call the callback with a failure result
            if callback then callback(false) end
        end
    end)
end

function CHARACTER.GetCurrentCharacter(ply)
    if not ply then return end
    if ply and not ply:IsValid() then return end
    if not ply:IsPlayer() then return end

    return CHARACTER.CurChars[ply:SteamID64()] or nil
end

function CHARACTER.GetName(ply)
    if not ply then return end
    if ply and not ply:IsValid() then return end
    if not ply:IsPlayer() then return end

    local char = CHARACTER.GetCurrentCharacter(ply)
    if not char then return end

    return char.first_name, char.last_name
end

function CHARACTER.GetFaction(pTeam)
    if not pTeam then return nil end

    local jobData = RPExtraTeams[pTeam]
    if not jobData then return nil end

    local faction = jobData.faction
    if not faction then return nil end

    return faction
end

local function GetActivePlayersOnJob(pTeam)
    local activePlayers = 0
    local maxSlots = 0
    pTeam = tonumber(pTeam)
    if RPExtraTeams[pTeam] then
        local jobData = RPExtraTeams[pTeam]
        activePlayers = team.NumPlayers(pTeam)
        maxSlots = jobData.max
        return activePlayers, maxSlots
    end

    return false
end

function CHARACTER.Apply(pCharData, ply, callback)
    CHARACTER.CharacterApplyQueue[ply] = true
    local teamName = pCharData.team
    local teamID = RPExtraTeams[tonumber(teamName)] and teamName or false
    if not teamID then
        callback(false)
        return
    end
    local tempOldChar = CHARACTER.GetCurrentCharacter(ply)

    CHARACTER.CurChars[ply:SteamID64()] = pCharData

    local jobChange = ply:changeTeam(tonumber(teamName), false, false)
    CHARACTER.CharacterApplyQueue[ply] = nil
    if not jobChange then
        print("JOB CHANGE FAILED")
        local activePlayers, maxSlots = GetActivePlayersOnJob(teamID)
        print(activePlayers, maxSlots)
        print(teamID)
        if activePlayers and activePlayers >= maxSlots then
            print("JOB IS FULLLLLLLLLLLLLLL")
            callback(false, "Job is full.")
            return
        end
        callback(false)
        CHARACTER.CurChars[ply:SteamID64()] = tempOldChar
        return
    end

    --ply:setRPName( pCharData.first_name .. " " .. pCharData.last_name, false )

    ply:Spawn()

    ply:SetNWString("ATLAS::Character::Description", pCharData.description)
    ply:SetNWInt("ATLAS::Character::ID", pCharData.id)
    
    ply:SetModel(pCharData.preferred_model)

    local scale = Utility.heightToScale(pCharData.height)
    ply:SetModelScale(scale, 0)

    local defaultViewHeight = Vector(0, 0, 64)
    local defaultDuckedHeight = Vector(0, 0, 28)
    ply:SetViewOffset(defaultViewHeight * scale)
    ply:SetViewOffsetDucked(defaultDuckedHeight * scale)

    local defaultJumpPower = 200
    ply:SetJumpPower(defaultJumpPower * scale)
    callback(true)
end

net.Receive("ATLAS::Characters::CreateChar", function(len, ply)
    local data = net.ReadTable()
    CHARACTER.CreateChar(data, ply)
    print("[MAL-C-DEBUG] HERE IS PAYLOAD FROM Characters::CreateChar")
    PrintTable(data)
end)

net.Receive("ATLAS::Characters::RequestChars", function(_, ply)
    sendCharData(ply)
end)

local function returnCharNet(ply, result, errMsg, cID)
    net.Start("ATLAS::Characters::PlayChar")
    net.WriteBool(result)
    net.WriteString(errMsg or "If you see this I have no clue why - Mal")
    if cID then
        net.WriteInt(cID, 20)
    end
    net.Send(ply)
end

net.Receive("ATLAS::Characters::PlayChar", function(_, ply)
    -- Add Rate Limiter
    if not ATLASCORE.UTIL:rateLimiter(ply, "CHARACTER_PLAY", 5, 1) then returnCharNet(ply, false, "Rate limit exceeded, please wait a moment.") return end

    local first, last = net.ReadString(), net.ReadString()

    print("[MAL-C-DEBUG] HERE IS PAYLOAD FROM Characters::PlayChar")
    print(first, last)
    -- TODO: Validate params
    if not ATLASCORE.UTIL:isValidName(first) or not ATLASCORE.UTIL:isValidName(last) then returnCharNet(ply, false, "Invalid Character Params") return end

    CHARACTER.RetrieveChar(first, last, ply:SteamID64(), function(pResult, pData)
        if pResult and pData then
            if #pData == 0 then
                returnCharNet(ply, false, "Character not found")
                return
            end
            local char = pData[1]
            CHARACTER.Apply(char, ply, function(pResult, pReason)
                if pResult then
                    returnCharNet(ply, true, false, char["id"])
                else
                    returnCharNet(ply, false, pReason and pReason or "Couldn't apply character")
                end
            end)
        else
            returnCharNet(ply, false, pData)
        end
    end)
end)

local function returnEditNet(ply, result, errMsg)
    net.Start("ATLAS::Characters::EditChar")
    net.WriteBool(result)
    if errMsg then
        net.WriteString(errMsg)
    end
    net.Send(ply)
end

net.Receive("ATLAS::Characters::EditChar", function(_, ply)
    if not ATLASCORE.UTIL:rateLimiter(ply, "CHARACTER_EDIT", 5, 1) then returnEditNet(ply, false, "Rate limit exceeded, please wait a moment.") return end

    local oldCharData = net.ReadTable()
    local charData = net.ReadTable()

    print("[MAL-C-DEBUG] HERE IS PAYLOAD FROM Characters::EditChar")
    print("oldCharData:")
    PrintTable(oldCharData)
    print("charData:")
    PrintTable(charData)
    CHARACTER.UpdateChar(oldCharData, ply, charData, function(pResult, pErrMsg)
        if pResult then
            returnEditNet(ply, true)
        else
            returnEditNet(ply, false, pErrMsg)
        end
    end)
end)

local function returnDeleteNet(ply, result)
    net.Start("ATLAS::Characters::DeleteChar")
    net.WriteBool(result)
    net.Send(ply)
end

net.Receive("ATLAS::Characters::DeleteChar", function(_, ply)
    if not ATLASCORE.UTIL:rateLimiter(ply, "CHARACTER_DELETE", 5, 1) then returnDeleteNet(ply, false) return end

    local first, last = net.ReadString(), net.ReadString()

    print("[MAL-C-DEBUG] HERE IS PAYLOAD FROM Characters::DeleteChar")
    print(first, last)
    CHARACTER.RetrieveChar(first, last, ply:SteamID64(), function(pSuccess, pData)
        if pSuccess then
            if #pData == 0 then
                returnDeleteNet(ply, false)
                return
            end
            local char = pData[1]
            CHARACTER.DeleteChar(char, function(pSuccess, pData)
                if pSuccess then
                    returnDeleteNet(ply, true)
                else
                    returnDeleteNet(ply, false)
                end
            end)
        else
            returnDeleteNet(ply, false)
        end
    end)
end)

hook.Add("ATLASCORE::PlayerNetReady", "ATLAS::Characters::SendChars", function(ply)
    sendCharData(ply)
end)

hook.Add("PlayerChangedTeam", "ATLAS::Characters::NameFormat", function(ply, oldTeam, newTeam)
    if not CHARACTER.GetCurrentCharacter(ply) then return end

    local jobData = RPExtraTeams[newTeam]

    if jobData and jobData.nameFormat then
        timer.Simple(0.5, function()
            local fn, ln = CHARACTER.GetName(ply)
            local bValue = Utility.getDepartmentFromTeam(newTeam)
            local bName = bValue and bValue or "BRANCH"

            local MRSgroup = MRS.GetNWdata(ply, "Group")
            local MRSrank = MRS.GetNWdata(ply, "Rank")

            local bRank = MRS.Ranks[MRSgroup] and MRS.Ranks[MRSgroup].ranks[MRSrank] or {srt_name = "RANK"}

            local replacements = {
                RANK = bRank.srt_name,
                FIRST = fn,
                LAST = ln,
                DCLASS = "D-" .. math.random(1000, 9999),
                BRANCH = bName
            }
            local formattedName = jobData.nameFormat:gsub("{(%w+)}", function(w)
                return replacements[w] or "{" .. w .. "}"
            end)

            -- Set the player's RP name to the formatted name
            ply:setRPName(formattedName)
        end)
    end
end)

local function openUI(ply, team)
    net.Start("ATLAS::Characters::OpenUI")
    net.WriteInt(team, 16)
    net.Send(ply)
end

-- This hook will block players from changing to a job that requires a character without using the character menu.
hook.Add("playerCanChangeTeam", "ATLAS::Characters::CanChangeTeam", function(ply, team, force)
    if not CHARACTER.CharacterApplyQueue[ply] and not RPExtraTeams[team].noChar and not force then
        openUI(ply, team)
        return false, "Jobs that require a character must be switched to via Character Menu."
    end
end)

hook.Add("PlayerSpawn", "ATLAS::Characters::Spawn", function(ply)
    if not CHARACTER.GetCurrentCharacter(ply) then return end

    local char = CHARACTER.GetCurrentCharacter(ply)
    ply:SetNWString("ATLAS::Character::Description", char.description)

    ply:SetModel(char.preferred_model)

    timer.Simple(0.1, function()
        if not IsValid(ply) then return end
        local scale = Utility.heightToScale(char.height)
        ply:SetModelScale(scale, 0)


        local defaultViewHeight = Vector(0, 0, 64)
        local defaultDuckedHeight = Vector(0, 0, 28)
        ply:SetViewOffset(defaultViewHeight * scale)
        ply:SetViewOffsetDucked(defaultDuckedHeight * scale)

        local defaultJumpPower = 200
        ply:SetJumpPower(defaultJumpPower * scale)
    end)

end)