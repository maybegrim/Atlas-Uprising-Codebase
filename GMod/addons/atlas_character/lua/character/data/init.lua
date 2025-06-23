local ATLAS_CHARACTERS_TABLE = CHARACTER.CONFIG.SQLTableName or "atlas_characters"

local function atlasDataInit()
    -- Create the atlas_characters table if it doesn't exist
    ATLASDATA.CreateTable(ATLAS_CHARACTERS_TABLE, {
        {
            name = "id",
            type = "INT AUTO_INCREMENT PRIMARY KEY"
        },
        {
            name = "steamid",
            type = "VARCHAR(255)"
        },
        {
            name = "first_name",
            type = "VARCHAR(255)"
        },
        {
            name = "last_name",
            type = "VARCHAR(255)"
        },
        {
            name = "type",
            type = "INT"
        },
        {
            name = "description",
            type = "TEXT"
        },
        {
            name = "preferred_model",
            type = "VARCHAR(255)"
        },
        {
            name = "height",
            type = "INT"
        },
        {
            name = "team",
            type = "VARCHAR(255)"
        },
    }, function(result, body)
        if result then
            print("Created table " .. ATLAS_CHARACTERS_TABLE .. " successfully if it didn't exist.")
        else
            print("Failed to create table " .. ATLAS_CHARACTERS_TABLE)
            print(body)
        end
    end)

end

hook.Add("ATLASDATA.Ready", "ATLAS::Characters::DataInit", function()
    atlasDataInit()
end)

print("[CHARACTERS] Data Init Loaded.")
