CHARACTER.CurChar = false

net.Receive("ATLAS::Characters::SendChars", function()
    local chars = net.ReadTable()
    if not CHARACTER.MyCharacters then
        CHARACTER.MyCharacters = {}
    end
    if not chars or not istable(chars) then
        return
    end
    CHARACTER.MyCharacters = chars
end)

net.Receive("ATLAS::Characters::PlayChar", function()
    local result = net.ReadBool()
    local errMsg = net.ReadString()
    local char = net.ReadInt(20)
    if result then
        CHARACTER.CloseLoadingScreen()
        CHARACTER.CloseCharScreen()
        for k,v in pairs(CHARACTER.MyCharacters) do
            if v.id == char then
                CHARACTER.CurChar = v
                break
            end
        end
    else
        CHARACTER.CloseLoadingScreen()
        CHARACTER.WarningMsg("Failed to play character: " .. errMsg)
    end
end)

net.Receive("ATLAS::Characters::EditChar", function()
    local result = net.ReadBool()
    local errMsg = net.ReadString()
    if result then
        CHARACTER.CloseLoadingScreen()
    else
        CHARACTER.CloseLoadingScreen()
        CHARACTER.WarningMsg("Failed to edit character: " .. errMsg)
    end
end)

net.Receive("ATLAS::Characters::DeleteChar", function()
    local result = net.ReadBool()
    if result then
        timer.Simple(1, function()
            CHARACTER.CloseLoadingScreen()
            CHARACTER.OpenCharScreen()
        end)
    else
        CHARACTER.CloseLoadingScreen()
        CHARACTER.WarningMsg("Failed to delete character.")
    end
end)

net.Receive("ATLAS::Characters::CreateChar", function()
    local result = net.ReadBool()
    local errMsg = net.ReadString()
    if result then
        -- Waiting for the server to send the characters
        timer.Simple(1, function()
            CHARACTER.CloseLoadingScreen()
            CHARACTER.CloseCharCreation()
            CHARACTER.OpenCharScreen()
        end)
    else
        CHARACTER.WarningMsg("Failed to create character: " .. errMsg)
        CHARACTER.CloseLoadingScreen()
    end
end)

net.Receive("ATLAS::Characters::OpenUI", function()
    local job = net.ReadInt(16)
    CHARACTER.OpenCharScreen(job and job or nil)
end)

local firstNames = {
    "John", "Jane", "Bob", "Alice", "Charlie", "David", "Emily", "Frank", "Grace", "Henry",
    "Isabella", "Jackson", "Kaitlyn", "Liam", "Madison", "Nathan", "Olivia", "Peyton", "Quincy", "Rebecca",
    "Samuel", "Taylor", "Ulysses", "Victoria", "William", "Xander", "Yasmin", "Zachary", "Aiden", "Brooklyn",
    "Cameron", "Dakota", "Eleanor", "Fiona", "Gabriel", "Harper", "Ivy", "Jasper", "Kyle", "Layla",
    "Mason", "Nora", "Oscar", "Piper", "Quinn", "Riley", "Sebastian", "Tristan", "Uma", "Violet",
    "Wesley", "Xavier", "Yvonne", "Zane", "Avery", "Blake", "Carter", "Delaney", "Eli", "Finley",
    "Grayson", "Hunter", "Ian", "Jordan", "Kennedy", "Logan", "Morgan", "Noah", "Owen", "Parker",
    "Quentin", "Ryan", "Sydney", "Tyler", "Uriah", "Valeria", "Wyatt", "Xenia", "Yara", "Zoey"
}
local lastNames = {
    "Smith", "Johnson", "Brown", "Taylor", "Anderson", "Thomas", "Jackson", "White", "Harris", "Martin",
    "Thompson", "Garcia", "Martinez", "Robinson", "Clark", "Rodriguez", "Lewis", "Lee", "Walker", "Hall",
    "Allen", "Young", "Hernandez", "King", "Wright", "Lopez", "Hill", "Scott", "Green", "Adams",
    "Baker", "Gonzalez", "Nelson", "Carter", "Mitchell", "Perez", "Roberts", "Turner", "Phillips", "Campbell",
    "Parker", "Evans", "Edwards", "Collins", "Stewart", "Sanchez", "Morris", "Rogers", "Reed", "Cook",
    "Morgan", "Bell", "Murphy", "Bailey", "Rivera", "Cooper", "Richardson", "Cox", "Howard", "Ward",
    "Torres", "Peterson", "Gray", "Ramirez", "James", "Watson", "Brooks", "Kelly", "Sanders", "Price",
    "Bennett", "Wood", "Barnes", "Ross", "Henderson", "Coleman", "Jenkins", "Perry", "Powell", "Long",
    "Patterson", "Hughes", "Flores", "Washington", "Butler", "Simmons", "Foster", "Gonzales", "Bryant", "Alexander"
}


local lastNameSegments = {
    first = {"Al", "Bel", "Cor", "Dal", "Ero", "Fen", "Gir", "Hal", "Ilo", "Jen", "Kal", "Lom", "Min", "Nar", "Ori", "Pal", "Qir", "Ran", "Sen", "Tor"},
    middle = {"vi", "ka", "le", "mo", "na", "pi", "qu", "ri", "su", "to", "vu", "xa", "ze", "lo", "fu", "ge", "hi", "ju", "ko", "lu"},
    last = {"dar", "en", "fir", "gor", "har", "in", "jar", "kon", "lar", "mor", "nan", "por", "qur", "ron", "sun", "ton", "vin", "xan", "yen", "zor"}
}

local firstNameSegments = {
    first = {"Ari", "Bela", "Cali", "Davi", "Eli", "Faye", "Gio", "Hali", "Isa", "Juli", "Kai", "Lila", "Mia", "Nina", "Oli", "Pia", "Quin", "Ria", "Sia", "Tia"},
    middle = {"ana", "elle", "ira", "ora", "una", "ila", "ela", "ina", "ona", "yla", "amo", "emi", "imo", "omo", "umo", "ali", "eli", "ili", "oli", "uli"},
    last = {"ra", "ta", "na", "la", "sa", "va", "xa", "ya", "za", "ca", "da", "fa", "ga", "ha", "ja", "ka", "ma", "pa", "ra", "wa"}
}

local function postProcessName(name)
    -- Avoid repetition of the same letter more than 2 times
    name = name:gsub("(.)%1%1+", "%1%1")

    -- Avoid more than 3 vowels or consonants in a row
    name = name:gsub("([aeiouAEIOU]{4,})", function(match)
        return match:sub(1, 3)
    end)
    name = name:gsub("([^aeiouAEIOU]{4,})", function(match)
        return match:sub(1, 3)
    end)

    return name
end


function CHARACTER.RandomName()
    
    local fRand, lRand = math.Rand(0, 1), math.Rand(0, 1)
    local lastName
    local firstName
    if fRand > 0.5 then
        firstName = firstNameSegments.first[math.random(#firstNameSegments.first)] ..
        firstNameSegments.middle[math.random(#firstNameSegments.middle)] .. 
        firstNameSegments.last[math.random(#firstNameSegments.last)]
    else
        firstName = firstNames[math.random(#firstNames)]
    end
    if lRand > 0.5 then
        lastName = lastNameSegments.first[math.random(#lastNameSegments.first)] ..
        lastNameSegments.middle[math.random(#lastNameSegments.middle)] ..
        lastNameSegments.last[math.random(#lastNameSegments.last)]
    else
        lastName = lastNames[math.random(#lastNames)]
    end

    firstName = postProcessName(firstName)
    lastName = postProcessName(lastName)

    return firstName, lastName
end



local hairColors = {"black", "brown", "blonde", "red", "gray"}
local eyeColors = {"blue", "green", "brown", "gray", "hazel"}
local heights = {"short", "average height", "tall"}
local personalities = {"kind", "curious", "brave", "intelligent", "graceful"}
local hobbies = {"reading", "painting", "hiking", "cooking", "gaming"}

local sentenceStructures = {
    "This individual, with their {hairColor} hair and {eyeColor} eyes, stands {height} and exudes a {personality} aura. They enjoy {hobby} during their free time.",
    "A person of {personality} nature, they are {height} with {hairColor} hair and {eyeColor} eyes. They have a penchant for {hobby}.",
    "With a {height} build and a {personality} personality, this character spends their time {hobby}. Their {hairColor} hair and {eyeColor} eyes are their distinguishing features.",
    "With a {personality} demeanor, this individual captivates others with their {eyeColor} eyes and {hairColor} hair. They stand {height} and enjoy {hobby} in their spare time.",
    "Known for their {personality} nature and {hairColor} hair that complements their {eyeColor} eyes. Standing at a {height} stature, they have a fondness for {hobby}.",
    "In their {height} frame, this character harbors a {personality} spirit, which is evident in their {eyeColor} eyes. They find solace in {hobby}, a hobby that complements their {hairColor} hair perfectly.",
    "A {height} figure with a {personality} personality, this individual has {hairColor} hair that pairs well with their {eyeColor} eyes. They often indulge in {hobby}, which brings them great joy.",
    "This character has a {personality} charm that is highlighted by their {hairColor} hair and {eyeColor} eyes. Their {height} stature and passion for {hobby} make them a remarkable individual.",
    "Built {height}, this character has {eyeColor} eyes that sparkle with a {personality} light. Their {hairColor} hair and love for {hobby} add to their intriguing personality.",
    "This {height} individual has a {personality} personality that shines through their {eyeColor} eyes. Their {hairColor} hair sways gracefully as they engage in their favorite hobby, {hobby}."
}

function CHARACTER.RandomDescription()
    local structure = sentenceStructures[math.random(#sentenceStructures)]

    local description = structure:gsub("{hairColor}", hairColors[math.random(#hairColors)])
                                :gsub("{eyeColor}", eyeColors[math.random(#eyeColors)])
                                :gsub("{height}", heights[math.random(#heights)])
                                :gsub("{personality}", personalities[math.random(#personalities)])
                                :gsub("{hobby}", hobbies[math.random(#hobbies)])

    return description
end





-- Character Functions for Client

function CHARACTER:GetHeight()
    local char = CHARACTER.CurChar

    if not char then
        return nil
    end

    return char.height
end

function CHARACTER:GetName()
    local char = CHARACTER.CurChar

    if not char then
        return LocalPlayer():Nick()
    end

    return char["first_name"] .. " " .. char["last_name"]
end

local cooldown = 0
hook.Add("ShowHelp", "ATLAS::Characters::OpenUI", function()
    if cooldown > CurTime() then
        return
    end
    cooldown = CurTime() + 1
    CHARACTER.OpenCharScreen(nil)
end)