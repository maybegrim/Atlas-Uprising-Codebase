local LANG = {}

local function RegisterLang(NEW)
    if LANG[NEW] then return end

    local LIST = {}

    for k, v in pairs(LANG) do
        table.insert(LIST, k)
    end

    table.insert(LIST, NEW)
end

function NCS_INFILTRATOR.AddLang(lang, note)
    RegisterLang(lang)

    LANG[lang] = LANG[lang] or {}

    for k, v in pairs(note) do 
        LANG[lang][k] = v
    end
end

function NCS_INFILTRATOR.GetLang(lang, note, replacements)
    if !lang then
        lang = NCS_INFILTRATOR.CONFIG.language or "en"
    end
    
    if !LANG[lang] then
        if LANG["en"] then
            lang = "en"
        else
            return note
        end
    end

    if !LANG[lang][note] then
        return note
    else
        note = LANG[lang][note]
    end

    if replacements and istable(replacements) then
        note = note:format(unpack(replacements))
    end

    return (note or "NOT FOUND")
end

function NCS_INFILTRATOR.GetLangs()
    return LANG
end