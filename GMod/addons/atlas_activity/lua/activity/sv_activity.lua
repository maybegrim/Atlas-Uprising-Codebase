-- Table to store player job start times
local playerJobStartTimes = {}

-- Create the database table if it doesn't exist
local function CreateJobActivityTable()
    ATLASDATA.CreateTable("player_job_activity", {
        { name = "id", type = "INT AUTO_INCREMENT PRIMARY KEY" },
        { name = "steamid", type = "VARCHAR(255)" },
        { name = "rpname", type = "VARCHAR(255)" },
        { name = "job", type = "VARCHAR(255)" },
        { name = "start_time", type = "INT" },
        { name = "end_time", type = "INT" },
        { name = "duration", type = "INT" }
    }, function(result, body)
        if result then
            print("Created player_job_activity table")
        else
            print("Failed to create table: " .. tostring(body))
        end
    end)
end

-- Create the table when the server starts
hook.Add("ATLASDATA.Ready", "CreateJobActivityTable", CreateJobActivityTable)

-- Hook to track when a player spawns for the first time
hook.Add("PlayerInitialSpawn", "TrackPlayerInitialJob", function(ply)
    local steamid = ply:SteamID()
    local rpname = ply:Nick()
    local currentJob = team.GetName(ply:Team())
    local startTime = os.time()

    -- Start tracking the current job
    playerJobStartTimes[ply] = startTime
end)

-- Hook to track when a player changes jobs
hook.Add("OnPlayerChangedTeam", "TrackPlayerJobChange", function(ply, oldTeam, newTeam)
    local steamid = ply:SteamID()
    local rpname = ply:Nick()
    local oldJob = team.GetName(oldTeam)
    local newJob = team.GetName(newTeam)
    local changeTime = os.time()

    -- If the player had a previous job, record the time spent
    if playerJobStartTimes[ply] then
        local startTime = playerJobStartTimes[ply]
        local timeSpent = changeTime - startTime

        -- Commit the old job's playtime
        local paramTable = {
            steamid = steamid,
            rpname = rpname,
            job = oldJob,
            start_time = startTime,
            end_time = changeTime,
            duration = timeSpent
        }
        ATLASDATA.CommitData("player_job_activity", paramTable, function(result, data)
            if result then
                print("Old job data saved for " .. rpname)
            else
                print("Failed to save old job data for " .. rpname)
            end
        end)
    end

    -- Start tracking the new job
    playerJobStartTimes[ply] = changeTime
end)

-- Hook to track when a player disconnects
hook.Add("PlayerDisconnected", "TrackPlayerDisconnect", function(ply)
    local steamid = ply:SteamID()
    local rpname = ply:Nick()
    local currentJob = team.GetName(ply:Team())
    local endTime = os.time()

    -- If the player had a job start time recorded
    if playerJobStartTimes[ply] then
        local startTime = playerJobStartTimes[ply]
        local timeSpent = endTime - startTime

        -- Commit data for the last job before the player disconnects
        local paramTable = {
            steamid = steamid,
            rpname = rpname,
            job = currentJob,
            start_time = startTime,
            end_time = endTime,
            duration = timeSpent
        }
        ATLASDATA.CommitData("player_job_activity", paramTable, function(result, data)
            if result then
                print("Player's job activity saved on disconnect for " .. rpname)
            else
                print("Failed to save job activity on disconnect for " .. rpname)
            end
        end)
    end

    -- Remove the player from the tracking table
    playerJobStartTimes[ply] = nil
end)

-- Hook to track when the server is shutting down
local saveFilePath = "player_job_data_backup.txt" -- Path to the backup file

hook.Add("ShutDown", "SavePlayerJobsOnShutdown", function()
    local jobData = {}

    -- Iterate over all players in the job start times table
    for ply, startTime in pairs(playerJobStartTimes) do
        if IsValid(ply) then
            local steamid = ply:SteamID()
            local rpname = ply:Nick()
            local currentJob = team.GetName(ply:Team())
            local endTime = os.time()

            -- Calculate the time spent on the current job
            local timeSpent = endTime - startTime

            -- Store job data in the table
            table.insert(jobData, {
                steamid = steamid,
                rpname = rpname,
                job = currentJob,
                start_time = startTime,
                end_time = endTime,
                duration = timeSpent
            })
        end
    end

    -- Save job data to a file
    if #jobData > 0 then
        local jsonData = util.TableToJSON(jobData, true) -- Convert table to JSON format
        file.Write(saveFilePath, jsonData) -- Write to file in data directory
        print("Player job data saved to file.")
    end
end)

local function CommitSavedPlayerJobData()
    if file.Exists(saveFilePath, "DATA") then
        local jsonData = file.Read(saveFilePath, "DATA") -- Read the file
        local jobData = util.JSONToTable(jsonData) -- Convert JSON back to table

        if jobData and #jobData > 0 then
            -- Iterate over the saved job data and commit it to Atlas Data
            for _, data in ipairs(jobData) do
                ATLASDATA.CommitData("player_job_activity", data, function(result, commitData)
                    if result then
                        print("Committed saved job data for " .. data.rpname)
                    else
                        print("Failed to commit saved job data for " .. data.rpname)
                    end
                end)
            end

            -- After committing, remove the file
            file.Delete(saveFilePath)
            print("Player job data committed and file deleted.")
        else
            print("No valid job data found in the backup file.")
        end
    else
        print("No player job data backup file found.")
    end
end

-- Call the function to commit the saved data when the server starts
hook.Add("ATLASDATA.Ready", "CommitSavedPlayerJobData", CommitSavedPlayerJobData)




-- Networking setup to handle client requests
util.AddNetworkString("RequestJobHistory")
util.AddNetworkString("SendJobHistory")

-- Handle client requests for job history
net.Receive("RequestJobHistory", function(len, ply)
    local steamid = ply:SteamID()

    -- Retrieve the player's job history from the database
    local paramTable = {
        steamid = steamid
    }

    ATLASDATA.RequestData("player_job_activity", paramTable, function(result, data)
        if result then
            -- Send the data back to the client
            net.Start("SendJobHistory")
            net.WriteTable(data)
            net.Send(ply)
        else
            -- Send an empty table or an error message
            net.Start("SendJobHistory")
            net.WriteTable({})
            net.Send(ply)
        end
    end)
end)
