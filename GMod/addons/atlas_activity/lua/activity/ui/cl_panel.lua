-- lua/activity_tracker/vgui/cl_panel.lua

-- Define a flat dark theme color palette
local COLOR_BACKGROUND = Color(30, 30, 30, 255)
local COLOR_PANEL = Color(50, 50, 50, 255)
local COLOR_TEXT = Color(200, 200, 200, 255)
local COLOR_BUTTON = Color(70, 70, 70, 255)
local COLOR_BUTTON_HOVER = Color(100, 100, 100, 255)

-- Define the VGUI panel
local PANEL = {}

function PANEL:Init()
    self:SetSize(800, 600)
    self:SetTitle("")
    self:Center()
    self:MakePopup()
    self:SetDraggable(true)
    self:ShowCloseButton(false)

    -- Custom background
    self.Paint = function(self, w, h)
        surface.SetDrawColor(COLOR_BACKGROUND)
        surface.DrawRect(0, 0, w, h)
    end

    -- Header
    local header = vgui.Create("DLabel", self)
    header:SetText("Player Job Play History Dashboard")
    header:SetFont("Trebuchet24")
    header:SetTextColor(COLOR_TEXT)
    header:Dock(TOP)
    header:DockMargin(10, 10, 10, 10)
    header:SetContentAlignment(5) -- Center text

    -- Custom Close Button
    local closeButton = vgui.Create("DButton", self)
    closeButton:SetText("X")
    closeButton:SetSize(20, 20)
    closeButton:SetPos(self:GetWide() - 30, 10)
    closeButton:SetTextColor(COLOR_TEXT)
    closeButton.Paint = function(self, w, h)
        surface.SetDrawColor(COLOR_BUTTON)
        if self:IsHovered() then
            surface.SetDrawColor(COLOR_BUTTON_HOVER)
        end
        surface.DrawRect(0, 0, w, h)
    end
    closeButton.DoClick = function()
        self:Close() -- Close the panel
    end

    -- Search type dropdown
    self.searchType = vgui.Create("DComboBox", self)
    self.searchType:Dock(TOP)
    self.searchType:DockMargin(10, 5, 10, 5)
    self.searchType:SetValue("Select Option")
    self.searchType:AddChoice("View My Stats")
    self.searchType:AddChoice("Search by SteamID")

    -- SteamID search box
    self.searchBox = vgui.Create("DTextEntry", self)
    self.searchBox:SetPlaceholderText("SteamID EX: STEAM_0:1:111018925 or 76561198182303579")
    self.searchBox:Dock(TOP)
    self.searchBox:DockMargin(10, 5, 10, 5)
    self.searchBox:SetVisible(false) -- Initially hidden
    self.searchType.OnSelect = function(panel, index, value)
        if value == "Search by SteamID" then
            self.searchBox:SetVisible(true)
        else
            self.searchBox:SetVisible(false)
        end
    end

    -- Timeframe selection dropdown
    self.timeframeBox = vgui.Create("DComboBox", self)
    self.timeframeBox:Dock(TOP)
    self.timeframeBox:DockMargin(10, 5, 10, 5)
    self.timeframeBox:SetValue("Select Timeframe")
    self.timeframeBox:AddChoice("1 Day")
    self.timeframeBox:AddChoice("1 Week")
    self.timeframeBox:AddChoice("1 Month")
    self.timeframeBox:AddChoice("Custom")

    -- Custom Date Pickers for "Custom" timeframe
    self.customDatePanel = vgui.Create("DPanel", self)
    self.customDatePanel:Dock(TOP)
    self.customDatePanel:SetTall(80)
    self.customDatePanel:SetVisible(false)
    self.customDatePanel.Paint = function(self, w, h)
        surface.SetDrawColor(COLOR_BACKGROUND)
        surface.DrawRect(0, 0, w, h)
    end

    -- Start date label
    local startDateLabel = vgui.Create("DLabel", self.customDatePanel)
    startDateLabel:SetText("Start Date:")
    startDateLabel:SetTextColor(COLOR_TEXT)
    startDateLabel:Dock(LEFT)
    startDateLabel:SetWide(100)

    -- Start date day picker
    self.startDay = vgui.Create("DNumberWang", self.customDatePanel)
    self.startDay:Dock(LEFT)
    self.startDay:SetWide(50)
    self.startDay:SetMin(1)
    self.startDay:SetMax(31)
    self.startDay:SetValue(os.date("*t").day)

    -- Start date month picker
    self.startMonth = vgui.Create("DComboBox", self.customDatePanel)
    self.startMonth:Dock(LEFT)
    self.startMonth:SetWide(100)
    for i = 1, 12 do
        self.startMonth:AddChoice(os.date("%B", os.time({year = 2024, month = i, day = 1})), i)
    end
    self.startMonth:SetValue(os.date("%B"))

    -- Start date year picker
    self.startYear = vgui.Create("DNumberWang", self.customDatePanel)
    self.startYear:Dock(LEFT)
    self.startYear:SetWide(60)
    self.startYear:SetMin(2020)
    self.startYear:SetMax(2100)
    self.startYear:SetValue(os.date("*t").year)

    -- End date label
    local endDateLabel = vgui.Create("DLabel", self.customDatePanel)
    endDateLabel:SetText("End Date:")
    endDateLabel:SetTextColor(COLOR_TEXT)
    endDateLabel:Dock(RIGHT)
    endDateLabel:SetWide(100)

    -- End date day picker
    self.endDay = vgui.Create("DNumberWang", self.customDatePanel)
    self.endDay:Dock(RIGHT)
    self.endDay:SetWide(50)
    self.endDay:SetMin(1)
    self.endDay:SetMax(31)
    self.endDay:SetValue(os.date("*t").day)

    -- End date month picker
    self.endMonth = vgui.Create("DComboBox", self.customDatePanel)
    self.endMonth:Dock(RIGHT)
    self.endMonth:SetWide(100)
    for i = 1, 12 do
        self.endMonth:AddChoice(os.date("%B", os.time({year = 2024, month = i, day = 1})), i)
    end
    self.endMonth:SetValue(os.date("%B"))

    -- End date year picker
    self.endYear = vgui.Create("DNumberWang", self.customDatePanel)
    self.endYear:Dock(RIGHT)
    self.endYear:SetWide(60)
    self.endYear:SetMin(2020)
    self.endYear:SetMax(2100)
    self.endYear:SetValue(os.date("*t").year)

    -- Show or hide custom date pickers based on timeframe selection
    self.timeframeBox.OnSelect = function(panel, index, value)
        if value == "Custom" then
            self.customDatePanel:SetVisible(true)
        else
            self.customDatePanel:SetVisible(false)
        end
    end

    -- Job filter dropdown
    self.jobFilterBox = vgui.Create("DComboBox", self)
    self.jobFilterBox:Dock(TOP)
    self.jobFilterBox:DockMargin(10, 5, 10, 5)
    self.jobFilterBox:SetValue("Filter by Job")
    self.jobFilterBox:AddChoice("All Jobs") -- Default option to show all jobs
    self.jobFilterBox:SetValue("All Jobs") -- Default to show all jobs

    -- Populate the dropdown with available jobs
    for teamID, jobData in pairs(RPExtraTeams) do
        self.jobFilterBox:AddChoice(jobData.name)
    end

    -- Search button
    local searchButton = vgui.Create("DButton", self)
    searchButton:SetText("Search")
    searchButton:Dock(TOP)
    searchButton:DockMargin(10, 10, 10, 10)
    searchButton:SetTall(40)
    searchButton:SetTextColor(COLOR_TEXT)
    searchButton.Paint = function(self, w, h)
        surface.SetDrawColor(COLOR_BUTTON)
        if self:IsHovered() then
            surface.SetDrawColor(COLOR_BUTTON_HOVER)
        end
        surface.DrawRect(0, 0, w, h)
    end
    searchButton.DoClick = function()
        -- Request player stats based on selection
        if self.searchType:GetValue() == "View My Stats" then
            self:RequestPlayerData(LocalPlayer():SteamID())
        elseif self.searchType:GetValue() == "Search by SteamID" then
            local function isSteamID64(str)
                return #str == 17 and tonumber(str) ~= nil
            end
            local searchTerm = self.searchBox:GetValue()
            local sid = isSteamID64(searchTerm) and util.SteamIDFrom64(searchTerm) or searchTerm
            self:RequestPlayerData(sid)
        end
    end

    -- Scrollable job history panel
    self.scrollPanel = vgui.Create("DScrollPanel", self)
    self.scrollPanel:Dock(FILL)

    -- Refresh the data when Job Filter changes
    self.jobFilterBox.OnSelect = function(panel, index, value)
        self:PopulateData(self.currentData)
    end
end

-- Add the RequestPlayerData method to the PANEL table
function PANEL:RequestPlayerData(steamidOrName)
    -- Automatically convert the SteamID or player name
    steamidOrName = self:ValidateSteamID(steamidOrName)

    -- Request all data for the player
    local requestData = {
        t = "player_job_activity", -- The table you are requesting data from
        p = {
            steamid = steamidOrName -- Filter by the player's SteamID
        }
    }

    -- Retrieve data from Atlas Data
    ATLASDATA.RetrieveData(requestData, function(success, data)
        if success then
            -- Filter data based on the timeframe before displaying it
            local filteredData = self:FilterDataByTimeframe(data["data"])
            self.currentData = filteredData -- Store the current data
            self:PopulateData(filteredData)
        else
            print("Failed to retrieve job history data:", data)
        end
    end)
end

-- Add a method to validate the SteamID
function PANEL:ValidateSteamID(steamidOrName)
    if not string.match(steamidOrName, "^STEAM_") then
        -- Convert player name to SteamID (mocked for this example)
        return "STEAM_0:1:12345678" -- Example conversion, replace with real lookup
    end
    return steamidOrName
end

-- Filter the retrieved data based on the selected timeframe
function PANEL:FilterDataByTimeframe(data)
    local timeframeStart, timeframeEnd = self:GetTimeframeStartEnd()

    -- Filter out jobs that fall outside of the selected timeframe
    local filteredData = {}
    for _, jobData in ipairs(data) do
        if jobData.start_time >= timeframeStart and jobData.start_time <= timeframeEnd then
            table.insert(filteredData, jobData)
        end
    end

    return filteredData
end

-- Get the start and end of the timeframe based on the dropdown selection
function PANEL:GetTimeframeStartEnd()
    local timeframe = self.timeframeBox:GetValue()
    local currentTime = os.time()

    if timeframe == "1 Day" then
        return currentTime - 86400, currentTime -- 1 day in seconds
    elseif timeframe == "1 Week" then
        return currentTime - (86400 * 7), currentTime -- 1 week in seconds
    elseif timeframe == "1 Month" then
        return currentTime - (86400 * 30), currentTime -- 1 month in seconds
    elseif timeframe == "Custom" then
        -- Convert the start and end date into timestamps
        local startDay = self.startDay:GetValue()
        local startMonth = self.startMonth:GetSelectedID() or os.date("*t").month
        local startYear = self.startYear:GetValue()

        local endDay = self.endDay:GetValue()
        local endMonth = self.endMonth:GetSelectedID() or os.date("*t").month
        local endYear = self.endYear:GetValue()

        local startDate = os.time({year = startYear, month = startMonth, day = startDay})
        local endDate = os.time({year = endYear, month = endMonth, day = endDay})

        return startDate, endDate
    else
        return currentTime - (86400 * 7), currentTime -- Default to 1 week
    end
end

local function jNameToID(jobName)
    for teamID, jobData in pairs(RPExtraTeams) do
        if jobData.name == jobName then
            return teamID
        end
    end
    return false -- Return nil if the job is not found
end

-- Populate job data in the panel
-- Populate job data in the panel
function PANEL:PopulateData(data)
    self.scrollPanel:Clear()

    local selectedJob = self.jobFilterBox:GetValue() -- Get the selected job
    local filteredData = {}

    -- Filter data based on the selected job, show all if "All Jobs" is selected
    if selectedJob == "All Jobs" or selectedJob == "" then
        filteredData = data -- Show all jobs if "All Jobs" is selected or nothing is selected
    else
        for _, jobData in ipairs(data) do
            if jobData.job == selectedJob then
                table.insert(filteredData, jobData)
            end
        end
    end

    -- Reverse the order of the filteredData to show latest entries first
    for i = #filteredData, 1, -1 do
        local jobData = filteredData[i]
        
        local job = jobData.job or "Unknown"
        local startTime = os.date("%Y-%m-%d %I:%M:%S %p", jobData.start_time or 0)
        local endTime = jobData.end_time and os.date("%Y-%m-%d %I:%M:%S %p", jobData.end_time) or "In Progress"
        local duration = jobData.duration or (jobData.end_time and (jobData.end_time - jobData.start_time) or (os.time() - jobData.start_time))
        local hours = math.floor(duration / 3600)
        local minutes = math.floor((duration % 3600) / 60)
        local durationStr = string.format("%02d hours %02d minutes", hours, minutes)

        local jID = jNameToID(job)
        local jobColor = jID and RPExtraTeams[jID].color or COLOR_PANEL

        local jobPanel = vgui.Create("DPanel", self.scrollPanel)
        jobPanel:SetTall(50)
        jobPanel:Dock(TOP)
        jobPanel:DockMargin(10, 10, 10, 0)
        jobPanel.Paint = function(self, w, h)
            surface.SetDrawColor(COLOR_PANEL)
            surface.DrawRect(0, 0, w, h)
        end

        local jobContainer = vgui.Create("DPanel", jobPanel)
        jobContainer:Dock(LEFT)
        jobContainer:SetWide(200)
        jobContainer.Paint = function(self, w, h) end

        local jobLabelText = vgui.Create("DLabel", jobContainer)
        jobLabelText:SetText("Job: ")
        jobLabelText:SetTextColor(COLOR_TEXT)
        jobLabelText:Dock(LEFT)
        jobLabelText:SetWide(30)

        local jobLabelName = vgui.Create("DLabel", jobContainer)
        jobLabelName:SetText(job)
        jobLabelName:SetTextColor(jobColor)
        jobLabelName:Dock(LEFT)
        jobLabelName:SetWide(200)

        local timeLabel = vgui.Create("DLabel", jobPanel)
        timeLabel:SetText("Start: " .. startTime .. " | End: " .. endTime)
        timeLabel:SetTextColor(COLOR_TEXT)
        timeLabel:Dock(LEFT)
        timeLabel:SetWide(350)

        local durationLabel = vgui.Create("DLabel", jobPanel)
        durationLabel:SetText("Duration: " .. durationStr)
        durationLabel:SetTextColor(COLOR_TEXT)
        durationLabel:Dock(FILL)
    end

    if #filteredData == 0 then
        local errorLabel = vgui.Create("DLabel", self.scrollPanel)
        errorLabel:SetText("No data available for the selected job or timeframe.")
        errorLabel:SetTextColor(Color(255, 0, 0))
        errorLabel:Dock(TOP)
    end
end

vgui.Register("JobHistoryPanel", PANEL, "DFrame")

-- Function to create and show the job history UI
function ShowJobHistory(data)
    local frame = vgui.Create("JobHistoryPanel")
    frame:PopulateData(data)
end
