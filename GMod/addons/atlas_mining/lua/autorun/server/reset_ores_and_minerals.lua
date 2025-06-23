-- ### Begin STSettings v2 code ###
ST_CONFIGS = ST_CONFIGS or {}
local this_addon = "STMining"
local this_defaults = [[PlatinumValue=29
RhodiumValue=92
GoldValue=174
DiamondValue=900]]
ST_CONFIGS[ this_addon ] = ST_CONFIGS[ this_addon ] or {}

local function ParseSTSettings( str )
    local boolishValues = {
        [ "true" ] = { true },
        [ "false" ] = { false },
        [ "t" ] = { true },
        [ "f" ] = { false },
        [ "yes" ] = { true },
        [ "no" ] = { false },
        [ "y" ] = { true },
        [ "n" ] = { false },
        [ "on" ] = { true },
        [ "off" ] = { false }
    }

    str = str:Trim()
    str = str .. "\n"

    local startPos = 1

    repeat
        local splitPos = str:find( "=", startPos, true )
        local settingName = str:sub( startPos, splitPos - 1 )
        local settingValue = str:sub( splitPos + 1, str:find( "\n", splitPos, true ) - 1 )
        startPos = str:find( "\n", splitPos, true ) + 1

        -- type guess
        local commaTrimmedValue = settingValue:Replace( ",", "" )
        commaTrimmedValue = commaTrimmedValue:Replace( "'", "" )
        commaTrimmedValue = commaTrimmedValue:Replace( "_", "" )
        if type( tonumber( commaTrimmedValue ) ) == "number" then -- numbers
            settingValue = tonumber( commaTrimmedValue )
        elseif boolishValues[ settingValue:lower() ] then -- booleans
            settingValue = boolishValues[ settingValue:lower() ][ 1 ]
        end
        -- i don't use any other types

        ST_CONFIGS[ this_addon ][ settingName ] = settingValue
    until not str:find( "\n", startPos, true )
end

hook.Add( "Initialize", "STSettings." .. this_addon, function()

    local this_addon = this_addon:lower()
    file.CreateDir( "sweptthrone_addons" )
    -- find old files from throneco_addons
    if file.Exists( "throneco_addons/" .. this_addon .. ".txt", "DATA" ) then
        -- write them to sweptthrone_addons
        file.Write( "sweptthrone_addons/" .. this_addon .. ".txt", file.Read( "throneco_addons/" .. this_addon .. ".txt", "DATA" ) )
        -- delete the old file
        file.Delete( "throneco_addons/" .. this_addon .. ".txt" )
        -- if the folder is empty, delete it too
        -- wiki says it will only delete an EMPTY folder
        file.Delete( "throneco_addons" )
    else
        if !file.Exists( "sweptthrone_addons/" .. this_addon .. ".txt", "DATA") then
            file.Write( "sweptthrone_addons/" .. this_addon .. ".txt", this_defaults )
        end
    end
    -- parse the new file to a table
    local settingsStr = file.Read( "sweptthrone_addons/" .. this_addon .. ".txt", "DATA" )

    ParseSTSettings( settingsStr )

end )
-- ### End STSettings v2 code ###

hook.Add( "PlayerDeath", "ResetOresAndMinerals", function( ply )

	ply:SetNWInt( "HeldOres", 0 )
	ply:SetNWInt( "HeldDiam", 0 )
	ply:SetNWInt( "HeldGold", 0 )
	ply:SetNWInt( "HeldRhod", 0 )
	ply:SetNWInt( "HeldPlat", 0 )

end )