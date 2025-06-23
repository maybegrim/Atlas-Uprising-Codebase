local AudioUtil = {}

local audioTypeToFile = {
    ["open"] = "inventory/open.wav",
    ["pickup_normal"] = "inventory/grab.wav",
    ["pickup_gun"] = "inventory/grab.wav",
    ["pickup_armor"] = "inventory/grab.wav",
    ["release_normal"] = "inventory/place.wav",
    ["release_gun"] = "inventory/gun_equip.wav",
    ["release_armor"] = "inventory/armor_equip.wav"
}

function AudioUtil.PlayInvSound(pType)
    local f = audioTypeToFile[pType]
    --print(not f and "No sound for " .. pType or "Playing " .. f)
    if f then
        sound.Play(f, LocalPlayer():GetPos(), 75, 100, 1)
    end
end

return AudioUtil