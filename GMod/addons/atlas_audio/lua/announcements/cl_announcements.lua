AAUDIO.ANNOUNCEMENTS.CurrentlyPlaying = false
AAUDIO.ANNOUNCEMENTS.Queue = {}

local function findNearestSpeaker()
    local speakers = ents.FindByClass("ent_audio_speaker")
    local nearestSpeaker = nil
    local shortestDistance = math.huge
    for _, speaker in ipairs(speakers) do
        if not IsValid(speaker) then continue end
        local distance = speaker:GetPos():Distance(LocalPlayer():GetPos())
        if distance < shortestDistance then
            nearestSpeaker = speaker
            shortestDistance = distance
        end
    end
    return nearestSpeaker
end

function AAUDIO.ANNOUNCEMENTS.QueueThink()
    if not AAUDIO.ANNOUNCEMENTS.CurrentlyPlaying and #AAUDIO.ANNOUNCEMENTS.Queue > 0 then
        local sndFile = table.remove(AAUDIO.ANNOUNCEMENTS.Queue, 1)
        AAUDIO.ANNOUNCEMENTS.Play(sndFile)
    end
end
hook.Add("Think", "AAUDIO.ANNOUNCEMENTS.QueueThink", AAUDIO.ANNOUNCEMENTS.QueueThink)

function AAUDIO.ANNOUNCEMENTS.Play(sndFile)
    if AAUDIO.ANNOUNCEMENTS.CurrentlyPlaying then
        table.insert(AAUDIO.ANNOUNCEMENTS.Queue, sndFile)
        return
    end

    local nearestSpeaker = findNearestSpeaker()
    if not IsValid(nearestSpeaker) then return end

    local volume = 1
    local pitch = 100
    local soundLevel = 380 -- Sound level in decibels
    local soundChannel = CHAN_AUTO -- Use automatic channel selection


    -- Play the sound in 3D space
    nearestSpeaker:EmitSound(sndFile, soundLevel, pitch, volume, soundChannel)
    AAUDIO.ANNOUNCEMENTS.CurrentlyPlaying = true

    -- Delay the next sound in the queue
    timer.Simple(SoundDuration(sndFile) + 1, function()
        AAUDIO.ANNOUNCEMENTS.CurrentlyPlaying = false
    end)
end
