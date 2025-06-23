AddCSLuaFile()

BINC = BINC or {}

function BINC.ClientInclude(input)
    if SERVER then
        AddCSLuaFile(input)
    else
        include(input)
    end    
end

function BINC.SharedInclude(input)
    if SERVER then
        AddCSLuaFile(input)
    end

    include(input)
end

function BINC.ServerInclude(input)
    if SERVER then
        include(input)
    end
end

function BINC.Include(dir, input)
    local prefix = string.sub(input, 1, 3)

    if prefix == "sh_" then
        BINC.SharedInclude(dir .. "/" .. input)
        return
    elseif prefix == "cl_" then
        BINC.ClientInclude(dir .. "/" .. input)
        return
    end

    BINC.ServerInclude(dir .. "/" .. input)
end

function BINC.IncludeDirectory(dir, type)
    local files = file.Find(dir .. "/*", "LUA")

    if not type then
        for _,f in ipairs(files) do
            BINC.Include(dir, f)
        end
    elseif type == "SHARED" then
        for _,f in ipairs(files) do
            BINC.SharedInclude(dir .. "/" .. f)
        end
    elseif type == "CLIENT" then
        for _,f in ipairs(files) do
            BINC.ClientInclude(dir .. "/" .. f)
        end
    elseif type == "SERVER" then
        for _,f in ipairs(files) do
            BINC.ServerInclude(dir .. "/" .. f)
        end
    end
end