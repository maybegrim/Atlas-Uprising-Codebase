ATLASCORE.UTIL = ATLASCORE.UTIL or {}

function ATLASCORE.UTIL:isValidName(name)
    local len = #name

    -- Check if the name length is between 3 and 10 characters
    if len < 3 or len > 10 then
        return false, "Name must be between 3 and 10 characters long."
    end

    -- Check if name only contains letters A-Z, a-z
    if name:match("^[A-Za-z]+$") then
        return true, nil
    else
        return false, "Name can only contain alphabetic characters and no spaces."
    end
end

function ATLASCORE.UTIL:isSafeDescription(desc)
    -- Allowed characters: A-Z, a-z, 0-9, and specific special characters
    local allowed = "^[A-Za-z0-9 %.,;'\"/\\%[%]{}()%-%+=_:;]+$"
    if desc:match(allowed) then
        return true, nil
    else
        return false, "Description can contain alphabets, numbers, and special characters like . , ; ' \" / \\ [ ] { } ( ) - + = _ : only."
    end
end


-- You can fill in words here that will be blacklisted
-- and will be checked against the text
local blacklistedWords = {
    "redacted list",
}
-- You can fill in words here that will be whitelisted
-- and will be ignored in the blacklist check
-- This is useful for words that are part of the blacklist
-- but are allowed in certain contexts
-- For example, if "niger" is a blacklisted word, but "nigeria" is allowed
local whitelistedWords = {
    "nigeria",
    "homosapien",
}

-- Masked character replacements
local maskedChars = {
    ["!"] = "i",
    ["@"] = "a",
    ["$"] = "s",
    ["0"] = "o",
    ["1"] = "i",
    ["3"] = "e",
    ["4"] = "a",
    ["5"] = "s",
    ["7"] = "t",
    ["8"] = "b",
    ["9"] = "g",
}

function ATLASCORE.UTIL:isCleanText(text)
    if not text then
        return false
    end
    local normalizedText = text:lower()

    -- Remove spaces
    normalizedText = normalizedText:gsub("%s", "")

    -- Replace masked characters
    for mask, replacement in pairs(maskedChars) do
        normalizedText = normalizedText:gsub(mask, replacement)
    end

    -- Blacklist check
    for _, word in ipairs(blacklistedWords) do
        local startIdx, _ = normalizedText:find(word, 1, true)
        while startIdx do
            local isWhitelisted = false
            for _, whitelistWord in ipairs(whitelistedWords) do
                local whitelistStart, whitelistEnd = normalizedText:find(whitelistWord, 1, true)
                if whitelistStart and startIdx >= whitelistStart and startIdx <= whitelistEnd then
                    isWhitelisted = true
                    break
                end
            end

            if not isWhitelisted then
                return false, "Text contains blacklisted word: " .. word
            end

            startIdx = normalizedText:find(word, startIdx + 1, true)
        end
    end

    return true, nil
end


local function isSteamID(str)
    return string.match(str, "STEAM_%d:%d:%d+") ~= nil
end

-- Helper function to detect if the string is a SteamID64
local function isSteamID64(str)
    return #str == 17 and tonumber(str) ~= nil
end

-- Main function to get the SteamID64
function ATLASCORE.UTIL:getSteamID64(input)
    -- If input is a player object
    if type(input) == "Player" then
        return input:SteamID64()
    
    -- If input is a SteamID
    elseif isSteamID(input) then
        -- Convert SteamID to SteamID64 using built-in function
        return util.SteamIDTo64(input)
    
    -- If input is a SteamID64
    elseif isSteamID64(input) then
        return input
    
    else
        return nil, "Invalid input type"
    end
end

-- Main function to get the SteamID
function ATLASCORE.UTIL:getSteamID(input)
    -- If input is a player object
    if type(input) == "Player" then
        return input:SteamID()

    -- If input is a SteamID
    elseif isSteamID(input) then
        return input

    -- If input is a SteamID64
    elseif isSteamID64(input) then
        -- Convert SteamID64 to SteamID using built-in function
        return util.SteamIDFrom64(input)

    else
        return nil, "Invalid input type"
    end
end

local sidToPlayers = {}

local function addPlayerToSIDCache(ply)
    local sid = ply:SteamID()
    local sid64 = ply:SteamID64()

    sidToPlayers[sid] = ply
    sidToPlayers[sid64] = ply
end

local function removePlayerFromSIDCache(ply)
    local sid = ply:SteamID()
    local sid64 = ply:SteamID64()

    sidToPlayers[sid] = nil
    sidToPlayers[sid64] = nil
end

hook.Add("PlayerAuthed", "ATLASCORE.UTIL:PlayerInitialSpawn", function(ply)
    addPlayerToSIDCache(ply)
end)

hook.Add("PlayerDisconnected", "ATLASCORE.UTIL:PlayerDisconnected", function(ply)
    removePlayerFromSIDCache(ply)
end)

-- Accepts both SteamID and SteamID64
function ATLASCORE.UTIL:getPlayerBySteamID(sid)
    return sidToPlayers[sid] or false
end

-- Live Lua reloads can cause the cache to be out of sync
function ATLASCORE.UTIL.ReCacheSIDToPlayers()
    sidToPlayers = {}

    for _, ply in ipairs(player.GetAll()) do
        addPlayerToSIDCache(ply)
    end
end


function ATLASCORE.UTIL:IsSteamID(pSid)
    return isSteamID(pSid) or isSteamID64(pSid) or false
end



local rateLimits = {}

-- Create a rate limiter for an action
-- @param ply: Player
-- @param actionID: A unique identifier for the action (e.g., "MyAddon_Shoot", "AnotherAddon_Jump")
-- @param interval: The minimum time (in seconds) between allowed actions
-- @param times: The number of times an action is allowed in the duration
function ATLASCORE.UTIL:rateLimiter(ply, actionID, interval, times)
    if not ply or not ply:IsValid() then return end

    local uniqueID = ply:UserID() .. "_" .. actionID

    rateLimits[uniqueID] = rateLimits[uniqueID] or {
        lastTime = CurTime(),
        actions = 0
    }

    local rateLimitData = rateLimits[uniqueID]

    -- Check if enough time has passed since the last action
    if CurTime() - rateLimitData.lastTime > interval then
        rateLimitData.lastTime = CurTime()
        rateLimitData.actions = 0
    end

    rateLimitData.actions = rateLimitData.actions + 1

    -- Return true if the action should be allowed, false if it's rate limited
    return rateLimitData.actions <= times
end