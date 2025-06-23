---
-- Retrieves the role of an in-game player from the Networked String.
-- @param ply The player entity whose role is to be fetched.
-- @return The role string if set, or "none" if not set.
---
function STORE.PLY.GetRole(ply)
    return ply:GetNWString("ATLAS.STORE.ROLE", "none")
end