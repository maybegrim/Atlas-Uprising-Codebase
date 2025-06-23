CP_CONFIG = {}
CP_CONFIG.Teams = {}; -- Do not touch

CP_CONFIG.Teams[0] = {
	name = "Unclaimed",
	color = Color(255, 0, 212),
	jobs = {},
	count = 0
};

timer.Simple(3, function()
	CP_CONFIG.Teams[1] = {
		name = "Foundation",
		color = Color(0, 0, 255),
		jobs = {
			["GENSEC Cadet"] = true,
			["IST Guard"] = true,
			["IST Senior Guard"] = true,
			["GENSEC Trainee"] = true,
			["GENSEC Trooper"] = true,
			["GENSEC Senior Trooper"] = true,
			["GENSEC NCO"] = true,
			["GENSEC Officer"] = true,
			["Lead GENSEC Officer"] = true,
			["GENSEC Captain"] = true,
			["GENSEC Heavy"] = true,
			["GENSEC Heavy Lead"] = true,
			["GENSEC K9"] = true,
			["GENSEC Warden"] = true,
			["GENSEC Chief Warden"] = true,
			["GENSEC Defensive Specialist"] = true,
			["GENSEC D-S LEAD"] = true,
			["NTF Trainee"] = true,
			["NTF Operative"] = true,
			["NTF Senior Operative"] = true,
			["NTF NCO"] = true,
			["NTF Officer"] = true,
			["NTF Lead Containment Officer"] = true,
			["NTF Captain"] = true,
			["NTF Cloaking Unit"] = true,
			["NTF C-U Lead"] = true,
			["NTF Containment Engineer"] = true,
			["NTF C-E Lead"] = true,
			["U11 Trainee"] = true,
			["U11 Operative"] = true,
			["U11 NCO"] = true,
			["U11 Officer"] = true,
			["U11 Lead Counter-Insurgency Officer"] = true,
			["U11 Captain"] = true,
			["U11 Heavy"] = true,
			["U11 Heavy Lead"] = true,
			["U11 Marksman"] = true,
			["U11 Marksman Lead"] = true,
			["U11 Explosive Specialist"] = true,
			["U11 ES Lead"] = true,
			["U11 Medic"] = true,
			["U11 Medic Lead"] = true,
			["U11 K9"] = true,
			["XI-13 Trainee"] = true,
			["XI-13 Operative"] = true,
			["XI-13 NCO"] = true,
			["XI-13 Officer"] = true,
			["XI-13 Forward Operations Officer"] = true,
			["XI-13 Captain"] = true,
			["XI-13 Mech"] = true,
			["XI-13 Mech Lead"] = true
		},
		count = 1
	};

	CP_CONFIG.Teams[2] = {
		name = "Chaos Insurgency",
		color = Color(0, 128, 0),
		jobs = {
			["AI: Operative"] = true,
			["AI: Senior Operative"] = true,
			["AI: NCO"] = true,
			["AI: Officer"] = true,
			["AI: Captain"] = true,
			["AI: Sniper"] = true,
			["AI: Lead Sniper"] = true,
			["AI: Medic"] = true,
			["AI: Lead Medic"] = true,
			["AI: Heavy"] = true,
			["AI: Lead Heavy"] = true,
			["AI: Demo Specialist"] = true,
			["AI: Lead Demo Specialist"] = true,
			["RI: Initiate"] = true,
			["RI: Researcher"] = true,
			["RI: Senior Researcher"] = true,
			["RI: Officer"] = true,
			["RI: Infiltrator"] = true,
			["RI: Lead Infiltrator"] = true,
			["RI: Thaumaturgist"] = true,
			["RI: Lead Thaumaturgist"] = true,
			["SI: Operative"] = true,
			["SI: Senior Operative"] = true,
			["SI: Fireteam Lead"] = true,
			["SI: Captain"] = true,
			["SI: K9"] = true,
			["CI: Lead Research Insurgent"] = true,
			["CI: Supervisors"] = true,
			["CI: Vice-Commander"] = true,
			["CI: Commander"] = true
		},
		count = 2
	};
end)

CP_CONFIG.Teams[4] = {
	name = "D-Class",
	color = Color(255, 165, 0),
	jobs = {
		["D-Class"] = true,
		["Experienced D-Class"] = true,
		["Medical D-Class"] = true,
		["D-Class Chad"] = true,
		["D-Class Cook"] = true,
		["D-Class Dealer"] = true,
		["D-Class Commander"] = true
	},
	count = 4
};

--------------------
-- Capture Points --
--------------------

CP_CONFIG.CapturePoints = {}; -- Do not touch

CP_CONFIG.CapturePoints[ 1 ] = {
	name = "Foundation HQ",
	position = Vector(9844.317383, -4101.922363, 7637.834473),
	reward = 150,
	Requires = {3,4,5,6}
};

CP_CONFIG.CapturePoints[ 2 ] = {
	name = "CI HQ",
	position = Vector(-10079.985352, -11717.166016, 5556.084473),
	reward = 150,
	Requires = {3,4,5,6}
};

CP_CONFIG.CapturePoints[ 3 ] = {
	name = "Lennys Lair",
	position = Vector(19.146328, -15165.763672, 7870.733398),
	reward = 75
};

CP_CONFIG.CapturePoints[ 4 ] = {
	name = "Snipers Lookout",
	position = Vector(-8116.362305, -2649.559814, 5817.177734),
	reward = 75
};

CP_CONFIG.CapturePoints[ 5 ] = {
	name = "Joe's Shack",
	position = Vector(-242.062119, -5631.917969, 6528.836914),
	reward = 75
};

CP_CONFIG.CapturePoints[ 6 ] = {
	name = "Mt. Ham",
	position = Vector(5481.657227, 2551.694092, 8532.509766),
	reward = 75
};


-----------------------------
-- Other (DO NOT GO BELOW) --
-----------------------------

local Ground = Vector(0, 0, -9999999)

CP_CONFIG.Initialize = function()
    CP_CONFIG.Initialized = true
    
    for k, v in pairs(CP_CONFIG.CapturePoints) do
        v.Owner = 0
        v.Progress = 0
        v.TeamProgress = 0
        
        v.GroundPos = util.QuickTrace(v.position, Ground).HitPos
        
        v.OwnerName = "Unclaimed"
        
        v.CircleColor = Color(255, 255, 255, 100)
        v.OwnerColor = Color(255, 255, 255, 100)
        
        v.Teams = {}
        v._Teams = {}
        v.Players = {}
        v.PrevPlayers = {}
    end
end
hook.Add("InitPostEntity", "cp_InitPostEntity", CP_CONFIG.Initialize)

CP_CONFIG.BITCOUNT_OWNER 		= 6;
CP_CONFIG.BITCOUNT_PROGRESS 	= 6;
CP_CONFIG.BITCOUNT_TEAMPROGRESS = 6;
CP_CONFIG.BITCOUNT_CPID			= 6;

function PlayerGetTeamJob(ply, job)
	if ply._LastJobCheck ~= job then
		ply._LastCPJobID = nil
		
		for k, v in pairs(CP_CONFIG.Teams) do
			for JobName,_ in pairs(v.jobs) do
				ply._LastCPJobID = JobName == job and k
				
				if ply._LastCPJobID then break end
			end
			
			if ply._LastCPJobID then break end
		end
	end
	
	ply._LastJobCheck = job
	
	return ply._LastCPJobID
end
