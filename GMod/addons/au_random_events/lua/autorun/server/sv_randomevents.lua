--[[

include("autorun/sh_randomevents.lua")

util.AddNetworkString("PA::notifyallplayers")

auprop = nil

timer.Create("randomeventtimer", timerlength, -1, function ()
    -- Pick a random event key (e.g., "gasleak").
    local randomeventchosen = math.random(1,#randomevent)
    local eventData = randomevent[randomeventchosen]
    
    -- Grabbing the events data
    local eventsoundAAudio = eventData.audio
    local physicalevent = eventData.physicalevent
    local eventLocation = eventData.eventlocation
    local eventEntity = eventData.evententity
    local eventjobrequirement = eventData.requiredjob -- This will be used in the future, currently doesn't do anything
    local eventEntitysound = eventData.eventsound

    -- Ensure audio is valid before sending it
    net.Start("PA::notifyallplayers")
    net.WriteString(eventsoundAAudio)  -- Sending the audio string
    net.Broadcast()

    -- Makes so that SMT can add physicalevents that require players to interact with in order to fix something.
    if physicalevent then
        auprop = ents.Create(eventEntity)
        auprop:SetPos(eventLocation)
        auprop:EmitSound(eventEntitysound)
        auprop:Spawn()

        -- Function called when something touches the prop.
        function auprop:Touch(ent)
            if ent:IsPlayer() then
                -- Kill the player instantly
                ent:Kill()
            end
        end

        local cooldown = 0
        -- Function so that players can fix the issue.
        function auprop:Use(activator)
            if cooldown <= CurTime() and activator:IsPlayer() then
                cooldown = CurTime() + 5
                if activator:Team() == eventjobrequirement or eventjobrequirement == nil then
                    local ply = activator
                    ATLASQUIZ.QuizPly(ply, nil, function(ply, success)
                        if success then
                            ply:ChatPrint("You have fixed the issue!")
                            auprop:Remove()
                        else
                            ply:ChatPrint("You failed to fix the issue!")
                        end
                    end)
                else
                    activator:ChatPrint("You are not the correct job to fix this issue.")
                end
            end
        end
    end
end)

]]--
