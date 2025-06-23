local Surface_Ambience = "sound/atlas_audio/ambience/Surface_Ambience.wav"
local Mining_Ambience = "sound/atlas_audio/ambience/Mining_Ambience.wav"
local Medbay_Ambience = "sound/atlas_audio/ambience/Medbay_Ambience.wav"
local LCZ_Ambience = "sound/atlas_audio/ambience/LCZ_Ambience.wav"
local Garage_Ambience = "sound/atlas_audio/ambience/Garage_Ambience.wav"
local HCZ_Ambience = "sound/atlas_audio/ambience/HCZ_Ambience.wav"
local EZ_Ambience = "sound/atlas_audio/ambience/EZ_Ambience.wav"
local Entering_Facility_Ambience = "sound/atlas_audio/ambience/Entering_Facility_Ambience.wav"
local DBlock_Ambience = "sound/atlas_audio/ambience/DBlock_Ambience.wav"
local Command_Ambience = "sound/atlas_audio/ambience/Command_Ambience.wav"
local CI_Ambience = "sound/atlas_audio/ambience/CI_Ambience.wav"
local ClubMusic = "sound/atlas_audio/ambience/ClubMusic.wav"
local RILabs_Ambience = "sound/atlas_audio/ambience/RILabs_Ambience.mp3"
local Mcdonalds_Ambience = "sound/atlas_audio/ambience/MCDonalds_Ambience.wav"

AMBIENCE = AMBIENCE or {}

AMBIENCE.IsPaused = false
AMBIENCE.SoundIsPaused = false

local function isPlayerInBox(ply, topBox, bottomBox)
    local playerPos = ply:GetPos()
    local minX, minY, minZ = math.min(topBox.x, bottomBox.x), math.min(topBox.y, bottomBox.y), math.min(topBox.z, bottomBox.z)
    local maxX, maxY, maxZ = math.max(topBox.x, bottomBox.x), math.max(topBox.y, bottomBox.y), math.max(topBox.z, bottomBox.z)

    return playerPos.x >= minX and playerPos.x <= maxX and
           playerPos.y >= minY and playerPos.y <= maxY and
           playerPos.z >= minZ and playerPos.z <= maxZ
end

AMBIENCE.TriggerZones = {
    ["Surface"] = {
        ["Ambience"] = Surface_Ambience,
        ["Volume"] = 0.4,
        ["Loop"] = true,
        ["TopBox"] = Vector(-12182.545898, -15950.628906, 10220.515625),
        ["BottomBox"] = Vector(11269.051758, 15337.158203, 7390.939453),
        ["Trigger"] = function(ply)
            local topBox = Vector(-12182.545898, -15950.628906, 10220.515625)
            local bottomBox = Vector(11269.051758, 15337.158203, 7390.939453)
            return isPlayerInBox(ply, topBox, bottomBox)
        end,
        Priority = 9,
    },
    ["Entering"] = {
        ["Ambience"] = Entering_Facility_Ambience,
        ["Volume"] = 0.4,
        ["Loop"] = true,
        ["TopBox"] = Vector(7032.225586, 9756.684570, 7918.307129),
        ["BottomBox"] = Vector(9970.512695, 12032.789062, 7392.575684),
        ["Trigger"] = function(ply)
            local topBox = Vector(7032.225586, 9756.684570, 7918.307129)
            local bottomBox = Vector(9970.512695, 12032.789062, 7392.575684)
            return isPlayerInBox(ply, topBox, bottomBox)
        end,
        Priority = 10,
    },
    ["Garage"] = {
        ["Ambience"] = Garage_Ambience,
        ["Volume"] = 0.3,
        ["Loop"] = true,
        ["TopBox"] = Vector(7151.240234, 11362.020508, 7364.024414),
        ["BottomBox"] = Vector(11119.549805, 14910.980469, 6585.171387),
        ["Trigger"] = function(ply)
            local topBox = Vector(7151.240234, 11362.020508, 7364.024414)
            local bottomBox = Vector(11119.549805, 14910.980469, 6585.171387)
            return isPlayerInBox(ply, topBox, bottomBox)
        end,
        Priority = 10,
    },
    ["Entrance"] = {
        ["Ambience"] = EZ_Ambience,
        ["Volume"] = 0.2,
        ["Loop"] = true,
        ["TopBox"] = Vector(-4426.365234, 6415.742188, -3071.112305),
        ["BottomBox"] = Vector(-10199.629883, 11007.872070, -3739.265381),
        ["Trigger"] = function(ply)
            local topBox = Vector(-4426.365234, 6415.742188, -3071.112305)
            local bottomBox = Vector(-10199.629883, 11007.872070, -3739.265381)
            return isPlayerInBox(ply, topBox, bottomBox)
        end,
        Priority = 11,
    },
    ["HCZ"] = {
        ["Ambience"] = HCZ_Ambience,
        ["Volume"] = 0.2,
        ["Loop"] = true,
        ["TopBox"] = Vector(-1541.605591, 6884.701172, -5583.839844),
        ["BottomBox"] = Vector(-6846.347656, 1102.864258, -6360.899902),
        ["Trigger"] = function(ply)
            local topBox = Vector(-1541.605591, 6884.701172, -5583.839844)
            local bottomBox = Vector(-6846.347656, 1102.864258, -6360.899902)
            return isPlayerInBox(ply, topBox, bottomBox)
        end,
        Priority = 10,
    },
    ["LCZ"] = {
        ["Ambience"] = LCZ_Ambience,
        ["Volume"] = 0.3,
        ["Loop"] = true,
        ["TopBox"] = Vector(-4335.462402, 14119.611328, -2708.175537),
        ["BottomBox"] = Vector(603.696655, 6282.774902, -4514.923340),
        ["Trigger"] = function(ply)
            local topBox = Vector(-4335.462402, 14119.611328, -2708.175537)
            local bottomBox = Vector(603.696655, 6282.774902, -4514.923340)
            return isPlayerInBox(ply, topBox, bottomBox)
        end,
        Priority = 10,
    },
    ["DBlock"] = {
        ["Ambience"] = DBlock_Ambience,
        ["Volume"] = 0.2,
        ["Loop"] = true,
        ["TopBox"] = Vector(-3209.088379, 11253.143555, -2996.087158),
        ["BottomBox"] = Vector(-5641.533203, 14256.014648, -3636.505859),
        ["Trigger"] = function(ply)
            local topBox = Vector(-3209.088379, 11253.143555, -2996.087158)
            local bottomBox = Vector(-5641.533203, 14256.014648, -3636.505859)
            return isPlayerInBox(ply, topBox, bottomBox)
        end,
        Priority = 11,
    },
    ["Mining"] = {
        ["Ambience"] = Mining_Ambience,
        ["Volume"] = 0.4,
        ["Loop"] = true,
        ["TopBox"] = Vector(-5113.604004, 12916.281250, -3346.031006),
        ["BottomBox"] = Vector(-5607.774902, 13394.378906, -3608.147705),
        ["Trigger"] = function(ply)
            local topBox = Vector(-5113.604004, 12916.281250, -3346.031006)
            local bottomBox = Vector(-5607.774902, 13394.378906, -3608.147705)
            return isPlayerInBox(ply, topBox, bottomBox)

        end,
        Priority = 12,
    },
    ["Command"] = {
        ["Ambience"] = Command_Ambience,
        ["Volume"] = 0.2,
        ["Loop"] = true,
        ["TopBox"] = Vector(-2520.812744, 10345.041016, -3338.693848),
        ["BottomBox"] = Vector(-3097.242920, 9361.378906, -3614.165771),
        ["Trigger"] = function(ply)
            local topBox = Vector(-2520.812744, 10345.041016, -3338.693848)
            local bottomBox = Vector(-3097.242920, 9361.378906, -3614.165771)
            return isPlayerInBox(ply, topBox, bottomBox)
        end,
        Priority = 11,
    },
    ["Medbay"] = {
        ["Ambience"] = Medbay_Ambience,
        ["Volume"] = 0.6,
        ["Loop"] = true,
        ["TopBox"] = Vector(-1259.554688, 9737.803711, -3588.932373),
        ["BottomBox"] = Vector(521.548706, 11510.502930, -3779.119141),
        ["Trigger"] = function(ply)
            local topBox = Vector(-1259.554688, 9737.803711, -3588.932373)
            local bottomBox = Vector(521.548706, 11510.502930, -3779.119141)
            return isPlayerInBox(ply, topBox, bottomBox)
        end,
        Priority = 11,
    },
    ["CI"] = {
        ["Ambience"] = CI_Ambience,
        ["Volume"] = 0.4,
        ["Loop"] = true,
        ["TopBox"] = Vector(-4133.919434, -2633.744873, 7316.647949),
        ["BottomBox"] = Vector(-7861.178711, -6862.429199, 6062.036133),
        ["Trigger"] = function(ply)
            local topBox = Vector(-4133.919434, -2633.744873, 7316.647949)
            local bottomBox = Vector(-7861.178711, -6862.429199, 6062.036133)
            return isPlayerInBox(ply, topBox, bottomBox)
        end,
        Priority = 11,
    },
    --[[["Club"] = {
        ["Ambience"] = ClubMusic,
        ["Volume"] = 0.4,
        ["Loop"] = true,
        ["TopBox"] = Vector(-9917.004883, 949.282593, 94.158463),
        ["BottomBox"] = Vector(-8702.334961, 296.441864, -316.326477),
        ["Trigger"] = function(ply)
            local topBox = Vector(-9917.004883, 949.282593, 94.158463)
            local bottomBox = Vector(-8702.334961, 296.441864, -259.326477)
            return isPlayerInBox(ply, topBox, bottomBox)
        end,
        Priority = 12,
    },]]
    ["RILabs"] = {
        ["Ambience"] = RILabs_Ambience,
        ["Volume"] = 0.4,
        ["Loop"] = true,
        ["TopBox"] = Vector(-5575.585938, -3829.651123, 7034.471680),
        ["BottomBox"] = Vector(-7441.166016, -2208.240479, 6718.965332),
        ["Trigger"] = function(ply)
            local topBox = Vector(-5575.585938, -3829.651123, 7034.471680)
            local bottomBox = Vector(-7441.166016, -2208.240479, 6718.965332)
            return isPlayerInBox(ply, topBox, bottomBox)
        end,
        Priority = 12,
    },
    ["Mcdonalds"] = {
        ["Ambience"] = Mcdonalds_Ambience,
        ["Volume"] = 0.4,
        ["Loop"] = true,
        ["TopBox"] = Vector(-5108.183594, -1920.249878, 7645.248047),
        ["BottomBox"] = Vector(-4106.820312, -3176.153564, 7397.166016),
        ["Trigger"] = function(ply)
            local topBox = Vector(-5108.183594, -1920.249878, 7645.248047)
            local bottomBox = Vector(-4106.820312, -3176.153564, 7397.166016)
            return isPlayerInBox(ply, topBox, bottomBox)
        end,
        Priority = 12,
    },
}

--THIS CODE IS FOR DEBUGGING ZONES
--[[surface.CreateFont("AmbienceFont", {
    font = "Arial",
    size = 20,
    weight = 500,
    antialias = true,
    shadow = false
})
local function drawTriggerZones(topBox, bottomBox, Name)
    local topBox = topBox
    local bottomBox = bottomBox
    local topLeft = Vector(topBox.x, topBox.y, topBox.z)
    local topRight = Vector(bottomBox.x, topBox.y, topBox.z)
    local bottomLeft = Vector(topBox.x, bottomBox.y, topBox.z)
    local bottomRight = Vector(bottomBox.x, bottomBox.y, topBox.z)
    local topBackLeft = Vector(topBox.x, topBox.y, bottomBox.z)
    local topBackRight = Vector(bottomBox.x, topBox.y, bottomBox.z)
    local bottomBackLeft = Vector(topBox.x, bottomBox.y, bottomBox.z)
    local bottomBackRight = Vector(bottomBox.x, bottomBox.y, bottomBox.z)
    render.DrawLine(topLeft, topRight, Color(255, 0, 0), false)
    render.DrawLine(topRight, bottomRight, Color(255, 0, 0), false)
    render.DrawLine(bottomRight, bottomLeft, Color(255, 0, 0), false)
    render.DrawLine(bottomLeft, topLeft, Color(255, 0, 0), false)
    render.DrawLine(topLeft, topBackLeft, Color(255, 0, 0), false)
    render.DrawLine(topRight, topBackRight, Color(255, 0, 0), false)
    render.DrawLine(bottomRight, bottomBackRight, Color(255, 0, 0), false)
    render.DrawLine(bottomLeft, bottomBackLeft, Color(255, 0, 0), false)
    render.DrawLine(topBackLeft, topBackRight, Color(255, 0, 0), false)
    render.DrawLine(topBackRight, bottomBackRight, Color(255, 0, 0), false)
    render.DrawLine(bottomBackRight, bottomBackLeft, Color(255, 0, 0), false)
    render.DrawLine(bottomBackLeft, topBackLeft, Color(255, 0, 0), false)
    -- Draw a name for it
    local center = (topBox + bottomBox) / 2
    local offset = Vector(0, 0, 50) -- Adjust this value to change the text position relative to the center of the zone
    local textPos = center + offset
    cam.Start3D2D(textPos, Angle(0, 0, 90), 1)
    draw.SimpleText(Name, "AmbienceFont", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end
hook.Add("PostDrawOpaqueRenderables", "DrawTriggerZones", function()
    for k, v in pairs(AMBIENCE.TriggerZones) do
        drawTriggerZones(v.TopBox, v.BottomBox, k)
    end
end)]]

local thinkDelay = 0.1
local lastThink = 0
local function FadeSound(key, fadeTime)
    if not IsValid(AMBIENCE.TriggerZones[key].Sound) then return end
    local fadeStep = thinkDelay / fadeTime
    coroutine.wrap(function()
        while AMBIENCE.TriggerZones[key].Sound and AMBIENCE.TriggerZones[key].Sound:GetVolume() > 0 do
            local newVolume = AMBIENCE.TriggerZones[key].Sound:GetVolume() - fadeStep
            if newVolume < 0 then newVolume = 0 end
            AMBIENCE.TriggerZones[key].Sound:SetVolume(newVolume)
            if newVolume == 0 then
                AMBIENCE.TriggerZones[key].Sound:Pause()
                AMBIENCE.TriggerZones[key].Sound = nil
            end
            coroutine.yield()
        end
    end)()
end

local currentAmbience = nil
function AMBIENCE:Think()
    if lastThink > CurTime() then return end
    lastThink = CurTime() + thinkDelay
    if AMBIENCE.SoundIsPaused then return end
    for k, v in pairs(self.TriggerZones) do
        if AMBIENCE.IsPaused then
            if v.Sound then
                v.Sound:Stop()
                AMBIENCE.SoundIsPaused = true
            end
            return
        end
        if v.Trigger(LocalPlayer()) then
            if currentAmbience and AMBIENCE.TriggerZones[currentAmbience].Priority > v.Priority then
                continue
            end
            if not IsValid(v.Sound) or (IsValid(v.Sound) and v.Sound:GetVolume() == 0) then
                if IsValid(v.Sound) and v.Sound:GetVolume() == 0 then
                    v.Sound:Stop()
                    v.Sound = nil
                end
                sound.PlayFile( v.Ambience, "noplay noblock", function( station, errCode, errStr )
                    if ( IsValid( station ) ) then
                        station:Play()
                        station:SetVolume(v.Volume)
                        station:SetPos(LocalPlayer():GetPos())
                        v.Sound = station
                        if v.Loop then
                            v.Sound:EnableLooping(true)
                        end
                    end
                end )
                if currentAmbience and currentAmbience ~= k then
                    local endingAmbience = currentAmbience
                    timer.Create("FADEOUTSPAM." .. currentAmbience, 0.1, 15, function()
                        FadeSound(endingAmbience, 2.5)
                    end)
                end
                currentAmbience = k
            end
        else
            if v.Sound then
                if currentAmbience == k then
                    currentAmbience = nil
                end
                FadeSound(k, 2.5)
            end
        end
    end
end

function AMBIENCE:Pause()
    AMBIENCE.IsPaused = true
    for k, v in pairs(self.TriggerZones) do
        if v.Sound and IsValid(v.Sound) then
            v.Sound:Stop()
        end
    end
end

function AMBIENCE:Unpause()
    AMBIENCE.IsPaused = false
    AMBIENCE.SoundIsPaused = false
end

timer.Simple(10, function()
    hook.Add("Think", "AmbienceThink", function()
        AMBIENCE:Think()
    end)
end)