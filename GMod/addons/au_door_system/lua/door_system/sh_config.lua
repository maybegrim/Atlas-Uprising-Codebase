AddCSLuaFile()

AU = AU or {}

AU.DoorSystem = AU.DoorSystem or {}

AU.DoorSystem.Defaults = {
    -- Default door health. Set to 0 for invincible doors.
    DoorHealth = 1000,

    -- Default door break sound.
    -- Set to "" to disable the breaking sound.
    BreakSound = "physics/metal/metal_large_debris2.wav",

    -- Default door repair time (in seconds).
    -- Set to { min, max } to define a random repair time.
    RepairTime = 15,

    -- Default door repair sound.
    -- Set to "" to disable the repair sound.
    RepairSound = "doors/door_metal_large_chamber_close1.wav"
}

AU.DoorSystem.SpecificValues = {
    ["models/some_door_model.mdl"] = {
        DoorHealth = 5000,
        BreakSound = "physics/metal/metal_large_debris1.wav",
        RepairTime = 60,
        RepairSound = "doors/door_metal_gate_move1"
    },
    ["models/other_door.mdl"] = {
        DoorHealth = 600,
        BreakSound = "",
        RepairTime = { 20, 30 },
        RepairSound = ""
    },
    ["models/indestructible_door.mdl"] = {
        DoorHealth = 0
    }
}

--------------------------------------------------------------------------

function AU.DoorSystem.GetMaxDoorHealth(entity)
    local entry = AU.DoorSystem.SpecificValues[entity:GetModel()]
    return entry and entry.DoorHealth or AU.DoorSystem.Defaults.DoorHealth
end

function AU.DoorSystem.GetDoorBreakSound(entity)
    local entry = AU.DoorSystem.SpecificValues[entity:GetModel()]
    return entry and entry.BreakSound or AU.DoorSystem.Defaults.BreakSound
end

function AU.DoorSystem.GetDoorRepairTime(entity)
    local entry = AU.DoorSystem.SpecificValues[entity:GetModel()]
    local time = entry and entry.RepairTime or AU.DoorSystem.Defaults.RepairTime
    return istable(time) and math.Rand(time[1], time[2]) or time
end

function AU.DoorSystem.GetDoorRepairSound(entity)
    local entry = AU.DoorSystem.SpecificValues[entity:GetModel()]
    return entry and entry.RepairSound or AU.DoorSystem.Defaults.RepairSound
end