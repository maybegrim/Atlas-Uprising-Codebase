ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "SCP-096 Face"
ENT.Catagory = "AU 096"
ENT.Author = "Ninjapenguin16"
ENT.Spawnable = true

-- hook.Add("PhysgunPickup", "NoPhysFaceTracker", function( ply, ent )
--     if not(IsFirstTimePredicted()) then return end
--     if(ent:GetClass() == "scp096_face_tracker") then return false end
-- end)