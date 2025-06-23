CreateConVar("scp096_crytime",31,FCVAR_ARCHIVE,"Set Crying time for scp 096")CreateConVar("scp096_ragetime",53,FCVAR_ARCHIVE,"Set Crying time for scp 096")resource.AddSingleFile"sound/scp096/crying.wav"resource.AddSingleFile"sound/scp096/scream.wav"hook.Add("PlayerDeath","Remove freeze after death SCP-173",function(_)if
_:IsFrozen()then
_:Freeze(!1)_:StopSound"scp096_crying"end
end)