ATLASDATA.APIURL = "X.X.X.X:XXXX/API"


local errorMessages = {
    ["errCodes"] = {
        [10] = "Table name is not defined",
        [11] = "Params are not defined",
        [20] = "Table name cannot be empty",
        [21] = "Params cannot be empty",
        [30] = "Column is required",
        [31] = "Column cannot be empty",
        [32] = "Value is required",
        [33] = "Value cannot be empty",
    }
}

local function dataLog(msg)
    print("[ATLASDATA] " .. os.date("[%x|%I:%M:%S%p]") .. " " .. msg)
end

local function isError(jsonMsg)
    if jsonMsg.err then
        return true
    end

    if jsonMsg.errCode then
        return true
    end

    return false
end

-- Default headers for HTTP requests
local function getDefaultHeaders()
    return {
        ["Content-Type"] = "text/plain",
        ["Accept-Encoding"] = "gzip, deflate, br",
        ["Accept"] = "*/*",
        ["Connection"] = "keep-alive",
    }
end

-- Define error messages for API requests
local function defineRequestError(jsonMsg)
    -- Probably SQL error. Find message in errorMessages.sql
    if jsonMsg.err and jsonMsg.err.sql then
        return "SQL Error: " .. jsonMsg.err.sqlMessage .. "\n" .. "| SQL Query: " .. jsonMsg.err.sql .. "\n"
    end

    -- Probably API error. Find message in errorMessages.errCodes
    if jsonMsg.errCode and  errorMessages.errCodes[jsonMsg.errCode] then
        return errorMessages.errCodes[jsonMsg.errCode]
    end

    if jsonMsg.status and jsonMsg.status == "error" then
        return jsonMsg.message or jsonMsg.error or "Unknown Error."
    end

    if jsonMsg.error then
        return jsonMsg.error
    end

    return "Unknown Error."
end

local function handleResponse(code, body, headers, callback)
    local json = util.JSONToTable(body)

    if not json then
        callback(false, "Invalid JSON response")
        return
    end

    if isError(json) then
        local err = defineRequestError(json)
        dataLog("[Error] " .. err)
        callback(false, err)
        return
    end

    callback(true, json)
end

local function sendHTTPRequest(endpoint, method, data, callback, retries)
    local url = ATLASDATA.APIURL .. endpoint
    local startTime

    retries = retries or 5  -- Default retries to 5 if not provided

    local request = {
        failed = function(reason)
            dataLog("[ERROR] API Request Failed. Reason: " .. reason)
            if retries > 0 then
                dataLog("[RETRY] Retrying... Remaining retries: " .. (retries-1))
                sendHTTPRequest(endpoint, method, data, callback, retries - 1)  -- Recursive retry
            else
                dataLog("[FAIL] No more retries. Returning failure.")
                callback(false, reason)  -- No more retries, return failure
            end
        end,
        success = function(code, body, headers)
            local endTime = SysTime()
            local responseTime = math.Round( (endTime - startTime) * 1000)
            dataLog(endpoint .. " Successful. [" .. responseTime .. " ms]")
            handleResponse(code, body, headers, callback)
        end,
        method = method,
        url = url,
        headers = getDefaultHeaders(),
        body = util.TableToJSON(data),
    }

    startTime = SysTime()
    HTTP(request)
end


function ATLASDATA.RequestData(tableN, params, callback)
    local data = {
        tableName = tableN,
        params = params
    }

    sendHTTPRequest("requestdata", "POST", data, function(result, dataTable)
        callback(result, dataTable)
    end)
end

function ATLASDATA.CommitData(tableN, params, callback)
    local data = {
        tableName = tableN,
        data = params
    }

    sendHTTPRequest("commitdata", "POST", data, function(result, dataTable)
        callback(result, dataTable)
    end)
end

-- Create Table function
function ATLASDATA.CreateTable(tableName, tableParams, callback)
    local data = {
        tableName = tableName,
        columns = tableParams
    }

    sendHTTPRequest("createtable", "POST", data, function(result, dataTable)
        callback(result, dataTable)
    end)
end

function ATLASDATA.DeleteData(tableName, column, value, callback)
    local data = {
        tableName = tableName,
        column = column,
        value = value
    }

    sendHTTPRequest("deletedata", "POST", data, function(result, dataTable)
        callback(result, dataTable)
    end)
end

hook.Add("Initialize", "ATLASDATA.ReadyHook", function()
    timer.Simple(1, function()
        dataLog("Ready!")
        hook.Run("ATLASDATA.Ready")
    end)
end)
