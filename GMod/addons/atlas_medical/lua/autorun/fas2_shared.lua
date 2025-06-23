
function AddAmmoType(name, text)
	game.AddAmmoType({name = name,
	dmgtype = DMG_BULLET})
	
	if CLIENT then
		language.Add(name .. "_ammo", text)
	end
end

AddAmmoType("Bandages", "Bandages")
AddAmmoType("Quikclots", "Quikclots")
AddAmmoType("Hemostats", "Hemostats")

local FAS_RS = {}

FAS_RS["FAS2_Bandage.Retrieve"] = "weapons/ifak/bandage_retrieve.wav"
FAS_RS["FAS2_Bandage.Open"] = "weapons/ifak/bandage_open.wav"
FAS_RS["FAS2_Hemostat.Retrieve"] = "weapons/ifak/hemostat_retrieve.wav"
FAS_RS["FAS2_Hemostat.Close"] = "weapons/ifak/hemostat_close.wav"
FAS_RS["FAS2_QuikClot.Loosen"] = "weapons/ifak/quikclot_loosen.wav"
FAS_RS["FAS2_QuikClot.Open"] = "weapons/ifak/quikclot_open.wav"
FAS_RS["FAS2_QuikClot.Retrieve"] = "weapons/ifak/quikclot_retrieve.wav"

local tbl = {channel = CHAN_STATIC,
	volume = 1,
	soundlevel = 50,
	pitchstart = 100,
	pitchend = 100}

for k, v in pairs(FAS_RS) do
	tbl.name = k
	tbl.sound = v
		
	sound.Add(tbl)
	
	if type(v) == "table" then
		for k2, v2 in pairs(v) do
			Sound(v2)
		end
	else
		Sound(v)
	end
end	

if CLIENT then FAS2AttOnMe = {} end

local ply, vm

function FAS2_PlayAnim(wep, anim, speed, cyc, time)
	speed = speed and speed or 1
	cyc = cyc and cyc or 0
	time = time or 0

	if type(anim) == "table" then
		anim = table.Random(anim)
	end

	if wep.Sounds[anim] then
		wep.CurSoundTable = wep.Sounds[anim]
		wep.CurSoundEntry = 1
		wep.SoundSpeed = speed
		wep.SoundTime = CurTime() + time
	end
		
	if CLIENT then
		vm = wep.Wep
		
		wep.CurAnim = string.lower(anim)
		
		if vm then
			vm:SetCycle(cyc)
			vm:SetSequence(anim)
			vm:SetPlaybackRate(speed)
		end
	end
end
