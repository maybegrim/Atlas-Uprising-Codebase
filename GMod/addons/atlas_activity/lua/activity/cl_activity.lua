-- Function to open the activity tracker UI
local function OpenActivityTracker()
    -- Define the request data format for Atlas Data
    local requestData = {
        t = "player_job_activity", -- The table you are requesting data from
        p = {
            steamid = LocalPlayer():SteamID() -- Filter by the player's SteamID
        }
    }

    -- Retrieve data from Atlas Data
    ATLASDATA.RetrieveData(requestData, function(success, data)
        if success then
            --PrintTable(data) -- Print the retrieved data for debugging
            -- Create and show the job history UI
            ShowJobHistory(data)
        else
            print("Failed to retrieve job history data:", data)
        end
    end)
end

-- Receive the job history data and display it
function ShowJobHistory(data)
    -- Assuming you have a panel function to display the data
    local frame = vgui.Create("JobHistoryPanel")
    frame:PopulateData(data) -- Populate the panel with job history data
end

-- Bind a console command to open the activity tracker
concommand.Add("open_activity_tracker", function()
    OpenActivityTracker()
end)

-- Optional: Bind a key (e.g., F4) to open the activity tracker
local lastPressTime = 0
local cooldown = 1 -- Cooldown time in seconds

hook.Add("PlayerButtonDown", "OpenActivityTrackerKeyBind", function(ply, button)
    if button == KEY_F5 then
        local currentTime = CurTime()
        if currentTime - lastPressTime >= cooldown then
            OpenActivityTracker()
            lastPressTime = currentTime
        end
    end
end)