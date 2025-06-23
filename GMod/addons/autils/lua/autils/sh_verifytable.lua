AddCSLuaFile()

function autil.VerifyTable(table, verification_table)
    table = table or {}

    for index, entry in pairs(verification_table) do
        if not table[index] and not entry.optional then
            table[index] = entry.default
        else
            if (entry.type and not type(table[index]) == entry.type)
            or (entry.values and not table.HasValue(entry.values, table[index])) then 
                table[index] = entry.default
            end
        end
    end
end