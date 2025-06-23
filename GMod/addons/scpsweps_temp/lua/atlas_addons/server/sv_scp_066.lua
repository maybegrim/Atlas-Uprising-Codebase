--[[
	This file has been copyrighted by Atlas Uprising.
	Do not distribute or copy any files.
]]--

resource.AddFile( "sound/scp_066/eric1.ogg" )
resource.AddFile( "sound/scp_066/beethoven.ogg" )
resource.AddFile( "sound/scp_066/ringing.wav" )

sound.Add( {
	name = "SCP066.Eric",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = {95, 110},
	sound = "scp_066/eric1.ogg"
} )

sound.Add( {
	name = "SCP066.Beethoven",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = 100,
	sound = "scp_066/beethoven.ogg"
} )

sound.Add( {
	name = "SCP066.Ring",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = 100,
	sound = "scp_066/ringing.wav"
} )