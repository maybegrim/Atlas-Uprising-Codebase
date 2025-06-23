--[[
    Atlas Data
    © 2023 Biobolt Interactive, LLC. All Rights Reserved.
]]

ATLASDATA.API_URL = "https://player_api.example.com/api/v1/"

-- Default headers for HTTP requests
local function getDefaultHeaders()
    return {
        ["Content-Type"] = "text/plain",
        ["Accept"] = "*/*",
    }
end

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
    local url = ATLASDATA.API_URL .. endpoint
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

function ATLASDATA.RetrieveData(data, callback_func)
    local request_table = {
        tableName = data.t,
        params = data.p,
    }
    sendHTTPRequest("requestdata", "POST", request_table, function(result, dataTable)
        callback_func(result, dataTable)
    end)
end