-- cl_bones.lua
local typeToSound = {
    [1] = "vo/npc/male01/imhurt02.wav",
    [2] = "vo/npc/female01/imhurt01.wav"
}
function ATLASMED.BONES.BreakLegs()
    -- Add visual effect or screen shake
    if not CHARACTER.CurChar then
        sound.Play( "vo/npc/male01/imhurt02.wav", LocalPlayer():GetPos() )
        return
    end

    local charType = CHARACTER.CurChar["type"]
    if charType then
        sound.Play( typeToSound[charType], LocalPlayer():GetPos() )
    end
end

net.Receive("PlayerBreakLegs", function()
    ATLASMED.BONES.BreakLegs()
end)
