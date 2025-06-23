--[[

-- The length of the timer in seconds. The timer creates an event over a certain amount of time.
timerlength = 600

-- Note currently, only entity events will work.

randomevent = {
    -- Note: Currently, any player that touches the entity will die instantly.
    -- I will change/remove it if asked.

    -- Template

    {
        audio = "",
        physicalevent = true, -- This is for if you want an action to be required 
        eventlocation = "", -- Location the entity will be spawned if physicalevent is true
        evententity = "", -- Entity to spawn if physicalevent is true
        eventsound = "", -- Sound to play for the entity (Will only play upon spawn. Use looped sounds for longer sounds.)
        requiredjob = "", -- Only this job can interact with the entity. Leave blank for all jobs.
    },
}

]]--