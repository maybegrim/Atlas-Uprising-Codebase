---
-- Logs messages related to the store system with a specific color scheme.
-- @param pMessage The message string to be logged.
---
local function STORE_LOG(pMessage)
    MsgC(Color(226, 64, 237), "[STORE] ", Color(255, 255, 255), pMessage .. "\n")
end

---
-- Initializes the store system by creating the necessary database table.
-- This function is called when the game server starts.
---
local function STORE_INIT()
    STORE_LOG("Initializing...")
    local query = "CREATE TABLE IF NOT EXISTS store_roles(steamid TEXT PRIMARY KEY, role TEXT, assigner TEXT, timestamp INTEGER)"

    if sql.Query(query) ~= false then
        STORE_LOG("Table creation query successfully!")
    else
        STORE_LOG("[FATAL] Table creation query failed!")
        print(sql.LastError())
    end
end

---
-- Assigns a role to an in-game player based on their Steam ID.
-- @param pID The Steam ID of the player.
-- @param pRole The role to be assigned.
---
local function STORE_PLYASSIGN(pID, pRole)
    local ply = ATLASCORE.UTIL:getPlayerBySteamID(pID)
    if ply then
        STORE.PLY.AssignRole(ply, pRole)
        STORE_LOG("Assigned in-game player " .. ply:Nick() .. " to role " .. pRole .. ".")
    end
end

---
-- Removes role from an in-game player based on their Steam ID.
-- @param pID The Steam ID of the player.
---
local function STORE_PLYUNASSIGN(pID)
    local ply = ATLASCORE.UTIL:getPlayerBySteamID(pID)
    if ply then
        STORE.PLY.RemoveRole(ply)
        STORE_LOG("Unassigned in-game player " .. ply:Nick() .. " from their role.")
    end
end

---
-- Safely constructs an SQL query by escaping the input parameters.
-- Helps in preventing SQL injection attacks.
-- @param query The SQL query template with placeholders.
-- @param ... The input parameters to be escaped and inserted into the query.
-- @return The safely constructed SQL query.
---
local function SAFE_SQL(query, ...)
    local args = {...}
    for i=1, #args do
        if type(args[i]) != "string" then
            continue
        end
        args[i] = sql.SQLStr(args[i])
    end
    return string.format(query, unpack(args))
end

---
-- Assigns a role to a user in the store system.
-- @param pSteamID The Steam ID of the user.
-- @param pRole The role to be assigned.
-- @param pAssigner (Optional) The entity responsible for the role assignment. Defaults to "Console".
---
function STORE.AssignRole(pSteamID, pRole, pAssigner)

    local isSid = ATLASCORE.UTIL:IsSteamID(pSteamID)

    if not isSid then
        STORE_LOG("[ERROR] Invalid SteamID64!")
        return
    end

    if not STORE.Roles[pRole] then
        STORE_LOG("[ERROR] Invalid role!")
        return
    end

    if not pAssigner then
        pAssigner = "Console"
    elseif ATLASCORE.UTIL:IsSteamID(pAssigner) or type(pAssigner) == "Player" then
        pAssigner = ATLASCORE.UTIL:getSteamID64(pAssigner) or "Unknown"
    else
        pAssigner = "Console"
    end

    local pSid64 = util.SteamIDTo64(pSteamID) ~= "0" and util.SteamIDTo64(pSteamID) or pSteamID

    local query = SAFE_SQL("INSERT OR REPLACE INTO store_roles (steamid, role, assigner, timestamp) VALUES (%s, %s, %s, %d)", pSid64, pRole, pAssigner, os.time())

    if sql.Query(query) ~= false then
        STORE_LOG("Successfully added " .. pSteamID .. " to role " .. pRole .. ".")
        STORE_PLYASSIGN(pSteamID, pRole)
    else
        STORE_LOG("[FATAL] Role assignment query failed!")
    end
end

---
-- Removes role from a user in the store system.
-- @param pSteamID The Steam ID of the user.
---
function STORE.RemoveRole(pSteamID)

    local isSid = ATLASCORE.UTIL:IsSteamID(pSteamID)

    if not isSid then
        STORE_LOG("[ERROR] Invalid SteamID64!")
        return
    end

    local pSid64 = util.SteamIDTo64(pSteamID) ~= "0" and util.SteamIDTo64(pSteamID) or pSteamID

    if pSid64 == "0" then
        STORE_LOG("[ERROR] Invalid SteamID64!")
        return
    end

    local query = SAFE_SQL("DELETE FROM store_roles WHERE steamid = %s", pSid64)

    if sql.Query(query) ~= false then
        STORE_LOG("Successfully removed " .. pSteamID .. " from their role.")
        STORE_PLYUNASSIGN(pSteamID)
    else
        STORE_LOG("[FATAL] Role removal query failed!")
    end
end

---
-- Checks if a user has a role in the store system.
-- @param pSteamID The Steam ID of the user.
-- @return The role of the user if they have one, false otherwise.
---
function STORE.HasRole(pSteamID)

    local isSid = ATLASCORE.UTIL:IsSteamID(pSteamID)

    if not isSid then
        STORE_LOG("[ERROR] Invalid SteamID64!")
        return false
    end

    local pSid64 = util.SteamIDTo64(pSteamID) ~= "0" and util.SteamIDTo64(pSteamID) or pSteamID

    if pSid64 == "0" then
        STORE_LOG("[ERROR] Invalid SteamID64!")
        return false
    end

    local query = SAFE_SQL("SELECT role FROM store_roles WHERE steamid = %s", pSid64)

    local result = sql.Query(query)

    if result and result ~= false then
        return result[1].role
    else
        return false
    end
end

---
-- Initialization hook for the store system.
---
hook.Add("InitPostEntity", "STORE_INIT", STORE_INIT)


---
-- Console command for assigning a role to a user in the store system.
---
concommand.Add("store_assign", function(ply, cmd, args)
    if ply:IsPlayer() then
        return
    end

    if #args < 2 then
        STORE_LOG("[ERROR] Invalid arguments!")
        return
    end

    local pSteamID = args[1]
    local pRole = args[2]

    STORE.AssignRole(pSteamID, pRole, "Console")
end)

---
-- Console command for removing a role from a user in the store system.
---
concommand.Add("store_remove", function(ply, cmd, args)
    if ply:IsPlayer() then
        return
    end

    if #args < 1 then
        STORE_LOG("[ERROR] Invalid arguments!")
        return
    end

    local pSteamID = args[1]

    STORE.RemoveRole(pSteamID)
end)

---
-- Hook for assigning roles to players when they join the server.
---
hook.Add("ATLASCORE::PlayerNetReady", "STORE::NetReady", function(ply)
    local hasRole = STORE.HasRole(ply:SteamID64())
    if hasRole then
        STORE_PLYASSIGN(ply:SteamID64(), hasRole)
    end
end)