AddCSLuaFile()
AddCSLuaFile("sh_sounds.lua")
include("sh_sounds.lua")

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "AKM"
	SWEP.CSMuzzleFlashes = true
	
	SWEP.IronsightPos = Vector(-3.846, -3.109, 1.1)
	SWEP.IronsightAng = Vector(0.577, 0.079, 0)

	SWEP.AimpointPos = Vector(-3.873, -6.683, 0.351)
	SWEP.AimpointAng = Vector(0, 0, 0)

	SWEP.EoTechPos = Vector(-3.875, -4.528, -0.16)
	SWEP.EoTechAng = Vector(0, 0, 0)

	SWEP.KobraPos = Vector(-2.55, -3.224, -0.026)
	SWEP.KobraAng = Vector(0.717, -0.638, 0)
	
	SWEP.ShortenedPos = Vector(-2.428, -3.618, 0.842)
	SWEP.ShortenedAng = Vector(-0.098, -0.044, 0)

	SWEP.RPKPos = Vector(-2.418, -3.481, 0.93)
	SWEP.RPKAng = Vector(0.125, -0.25, 0)
	
	SWEP.PSOPos = Vector(-2.5, 0.65, -0.101)
	SWEP.PSOAng = Vector(0, 0, 0)
	
	SWEP.ACOGPos = Vector(-3.866, -8.995, 0.229)
	SWEP.ACOGAng = Vector(0, 0, 0)

	SWEP.ShortDotPos = Vector(-3.859, -8.905, 0.476)
	SWEP.ShortDotAng = Vector(0, 0, 0)

	SWEP.AlternativePos = Vector(-1, -2, -0.6)
	SWEP.AlternativeAng = Vector(0, 0, 0)
	
	SWEP.BackupSights = {
		["md_acog"] = {Vector(-3.862, -8.995, -0.676), Vector(0, 0, 0)},
	}

	SWEP.ViewModelMovementScale = 1.15
	
	SWEP.IconLetter = "b"
	killicon.AddFont("cw_ak74", "CW_KillIcons", SWEP.IconLetter, Color(255, 80, 0, 150))
	
	SWEP.MuzzleEffect = "muzzleflash_ak74"
	SWEP.PosBasedMuz = true
	SWEP.ShellScale = 0.7
	SWEP.ShellOffsetMul = 1
	SWEP.ShellPosOffset = {x = 0, y = 0, z = 3}
	SWEP.SightWithRail = true
	SWEP.ForeGripOffsetCycle_Draw = 0
	SWEP.ForeGripOffsetCycle_Reload = 0.52
	SWEP.ForeGripOffsetCycle_Reload_Empty = 0.76
	
	SWEP.BoltBone = "bolt"
	SWEP.BoltShootOffset = Vector(-4.81, 0, 0)
	SWEP.OffsetBoltOnBipodShoot = true

	SWEP.NXSPos = Vector(-2.442, -2.941, -0.823)
	SWEP.NXSAng = Vector(0, -0.429, 0)

	SWEP.AttachmentModelsVM = {
		["md_pbs1"] = { type = "Model", model = "models/cw2/attachments/pbs1.mdl", bone = "body", rel = "", pos = Vector(-0.031, 20.329, -0.635), angle = Angle(0, 180, 0), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["md_eotech"] = { type = "Model", model = "models/wystan/attachments/2otech557sight.mdl", bone = "body", rel = "", pos = Vector(0.319, -9.629, -11.506), angle = Angle(3.332, -90, 0), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["md_aimpoint"] = { type = "Model", model = "models/wystan/attachments/aimpoint.mdl", bone = "body", rel = "", pos = Vector(-0.232, -2.754, -3.096), angle = Angle(0, 0, 0), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["md_foregrip"] = { type = "Model", model = "models/wystan/attachments/foregrip1.mdl", bone = "body", rel = "", pos = Vector(-0.385, -3.379, -2.883), angle = Angle(0, 0, 0), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["md_schmidt_shortdot"] = { type = "Model", model = "models/cw2/attachments/schmidt.mdl", bone = "body", rel = "", pos = Vector(-0.292, -1.991, -2.57), angle = Angle(0, -90, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["md_acog"] = { type = "Model", model = "models/wystan/attachments/2cog.mdl", bone = "body", rel = "", pos = Vector(-0.297, -2.053, -2.57), angle = Angle(0, 0, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.ForeGripHoldPos = {
		["Bip01 L Finger02"] = {pos = Vector(0, 0, 0), angle = Angle(0, 83.181, 0) },
		["Bip01 L Finger41"] = {pos = Vector(0, 0, 0), angle = Angle(0, 34.194, 0) },
		["Bip01 L UpperArm"] = {pos = Vector(0.907, -0.471, -2.847), angle = Angle(0, 0, 0) },
		["Bip01 L Finger31"] = {pos = Vector(0, 0, 0), angle = Angle(0, 53.886, 0) },
		["Bip01 L Finger12"] = {pos = Vector(0, 0, 0), angle = Angle(0, 21.756, 0) },
		["Bip01 L ForeTwist"] = {pos = Vector(0, 0, 0), angle = Angle(0, 0, 44.928) },
		["Bip01 L Finger0"] = {pos = Vector(0, 0, 0), angle = Angle(11.442, 0, 0) },
		["Bip01 L Forearm"] = {pos = Vector(0, 0, 0), angle = Angle(0, 0, 72.1) },
		["Bip01 L Finger21"] = {pos = Vector(0, 0, 0), angle = Angle(-7.89, 53.339, 0) },
		["Bip01 L Finger11"] = {pos = Vector(0, 0, 0), angle = Angle(0, 67.512, 0) },
		["Bip01 L Finger01"] = {pos = Vector(0, 0, 0), angle = Angle(13.019, 30.686, 0) },
		["Bip01 L Hand"] = {pos = Vector(0, 0, 0), angle = Angle(0, 33.571, -11.86) }
	}
		
	--SWEP.PSO1AxisAlign = {right = 0, up = 0.4, forward = -90}
	--SWEP.SchmidtShortDotAxisAlign = {right = 0, up = -0.4, forward = 0}
	--SWEP.ACOGAxisAlign = {right = 0, up = -0.4, forward = 0}
end

SWEP.MuzzleVelocity = 880 -- in meter/s

SWEP.LuaViewmodelRecoil = true

SWEP.BarrelBGs = {main = 2, rpk = 1, short = 4, regular = 0}
SWEP.StockBGs = {main = 1, regular = 0, heavy = 1, foldable = 2}
SWEP.ReceiverBGs = {main = 3, rpk = 1, regular = 0}
SWEP.MagBGs = {main = 4, regular = 0, rpk = 1}

SWEP.Attachments = {
	{header = "Sight", offset = {950, -500},  atts = {"md_eotech", "md_aimpoint", "md_schmidt_shortdot", "md_acog"}},
	{header = "Barrel", offset = {0, -500}, atts = {"md_pbs1"}},
	{header = "Handguard", offset = {-400, 100}, atts = {"md_foregrip"}, exclusions = {bg_ak74_rpkbarrel = true}},
	["+reload"] = {header = "Ammo", offset = {950, 300}, atts = {"am_magnum", "am_matchgrade"}}}

SWEP.Animations = {fire = {"ak47_fire1", "ak47_fire2", "ak47_fire3"},
	reload = "ak47_reload",
	idle = "ak47_idle",
	draw = "ak47_draw"}
	
SWEP.Sounds = {	
	draw = {
		{time = 0, sound = "CW_FOLEY_MEDIUM"}
	},
	ak47_reload = {
		{time = 0.05, sound = "CW_FOLEY_MEDIUM"},
		{time = 0.3, sound = "CW_AKM_OFFICIAL_MAGOUT"},
		{time = 0.35, sound = "CW_AKM_OFFICIAL_MAGRELEASE"},
		{time = 0.8, sound = "CW_AKM_OFFICIAL_CLOTH"},
		{time = 1.15, sound = "CW_AKM_OFFICIAL_MAGIN"},
		{time = 1.92, sound = "CW_AKM_OFFICIAL_BOLTPULL"},
		{time = 2.08, sound = "CW_AKM_OFFICIAL_BOLTRELEASE"},
		{time = 2.2, sound = "CW_FOLEY_MEDIUM"}
	}
}

SWEP.SpeedDec = 30

SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto", "semi"}
SWEP.Base = "cw_base"
SWEP.Category = "CW 2.0"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/cw2/rifles/akm_official_v.mdl"
SWEP.WorldModel		= "models/weapons/w_rif_ak47.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "7.62x39MM"

SWEP.FireDelay = 60/600
SWEP.FireSound = "CW_AKM_OFFICIAL_FIRE"
SWEP.FireSoundSuppressed = "CW_AKM_OFFICIAL_FIRE_SUPPRESSED"
SWEP.Recoil = 1.2

SWEP.HipSpread = 0.043
SWEP.AimSpread = 0.0055
SWEP.VelocitySensitivity = 1.6
SWEP.MaxSpreadInc = 0.055
SWEP.SpreadPerShot = 0.0095
SWEP.SpreadCooldown = 0.15
SWEP.Shots = 1
SWEP.Damage = 34
SWEP.DeployTime = 0.6

SWEP.ReloadSpeed = 0.85
SWEP.ReloadTime = 1.65
SWEP.ReloadTime_Empty = 2.1
SWEP.ReloadHalt = 1.65
SWEP.ReloadHalt_Empty = 2.6
SWEP.SnapToIdlePostReload = true