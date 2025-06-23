util.AddNetworkString("ATLAS.VENTS.UI")
util.AddNetworkString("ATLAS.VENTS.PinEntry")
util.AddNetworkString("ATLAS.VENTS.VentOpen")
util.AddNetworkString("ATLAS.VENTS.VentClose")

VENTS.HealthData = VENTS.HealthData or {}
VENTS.Status = VENTS.Status or true
VENTS.Code = VENTS.Code or 1234

VENTS.Blocks = {
    [1] = {vec = Vector(1,1,1)}
}

function VENTS.Off()
    VENTS.Status = false
    --[[for k,v in pairs(player.GetAll()) do
        timer.Simple(0.1 * k, function()
            VENTS.ReducePlayer(v)
        end)
    end]]
    VENTS.ChangePin()
    
    hook.Run("AU.Vents.Close")
    
    net.Start("ATLAS.VENTS.VentClose")
    net.Broadcast()
end

function VENTS.On()
    VENTS.Status = true
    --[[for k,v in pairs(player.GetAll()) do
        timer.Simple(0.1 * k, function()
            VENTS.ReinstatePlayer(v)
        end)
    end]]
    
    hook.Run("AU.Vents.Open")
    
    net.Start("ATLAS.VENTS.VentOpen")
    net.Broadcast()
end

--[[function VENTS.ReducePlayer(ply)
    if ply:GetFaction() ~= "FOUNDATION" then return end
    local hp = ply:Health()
    if hp < 21 then
        ply:Kill()
        return
    end
    local maxHP = ply:GetMaxHealth()
    VENTS.HealthData[ply] = maxHP
    ply:SetMaxHealth(maxHP - 20)
    ply:SetHealth(hp - 20)
end

function VENTS.ReinstatePlayer(ply)
    if ply:GetFaction() ~= "FOUNDATION" then return end
    if VENTS.HealthData[ply] then
        ply:SetMaxHealth(VENTS.HealthData[ply])
        VENTS.HealthData[ply] = nil
    end
end]]

function VENTS.ChangePin()
    VENTS.Code = math.random(1000,9999)
end

--[[hook.Add("PlayerChangedTeam", "ATLAS.VENTS.TEAMCHANGE", function(ply)
    if VENTS.Status then return end
    if ply:GetFaction() ~= "FOUNDATION" then return end
    timer.Simple(6, function() VENTS.ReducePlayer(ply) end)
end)]]

--[[hook.Add("PlayerSpawn", "ATLAS.VENTS.SPAWN", function(ply)
    if VENTS.Status then return end
    if ply:GetFaction() ~= "FOUNDATION" then return end
    timer.Simple(6, function() VENTS.ReducePlayer(ply) end)
end)]]

hook.Add("InitPostEntity", "ATLAS.VENTS.PIN", function()
    VENTS.Code = math.random(1000,9999)
    timer.Create("VENTS.CodeChanger", 1800, 0, function()
        VENTS.ChangePin()
    end)
    timer.Simple(5, function()
        VENTS.On()
    end)
end)

net.Receive("ATLAS.VENTS.PinEntry", function(_,ply)
    if not VENTS.Status then return end
    --if ply:GetFaction() ~= "CHAOS" then return end
    local pinEntry = net.ReadInt(15)
    if VENTS.Code == pinEntry then
        VENTS.Off()
    end
end)