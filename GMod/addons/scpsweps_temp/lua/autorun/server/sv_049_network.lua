local scp049sounds = {
    ["sound1"] = {path = "049/detected.mp3", time = 6},
    ["sound2"] = {path = "049/do_not_be_afraid.mp3", time = 3},
    ["sound3"] = {path = "049/good.mp3", time = 9},
    ["sound4"] = {path = "049/greetings.mp3", time = 1},
    ["sound5"] = {path = "049/hello.mp3", time = 1},
    ["sound6"] = {path = "049/i_am_the_cure.mp3", time = 2},
    ["sound7"] = {path = "049/i_can_see_you.mp3", time = 5},
    ["sound8"] = {path = "049/i_hear_you_breathing.mp3", time = 2},
    ["sound9"] = {path = "049/i_know_you_are_in_here.mp3", time = 2},
    ["sound10"] = {path = "049/i_need_to_get_to_work.mp3", time = 6},
    ["sound11"] = {path = "049/i_sense_the_disease_in_you.mp3", time = 2},
    ["sound12"] = {path = "049/im_not_trying.mp3", time = 3},
    ["sound13"] = {path = "049/kidnap.mp3", time = 3},
    ["sound14"] = {path = "049/lets_get_this.mp3", time = 3},
    ["sound15"] = {path = "049/my_cure_is_most_effective.mp3", time = 4},
    ["sound16"] = {path = "049/not_doctor.mp3", time = 2},
    ["sound17"] = {path = "049/oh_my.mp3", time = 4},
    ["sound18"] = {path = "049/ringo_ringo_roses.mp3", time = 12},
    ["sound19"] = {path = "049/stop_resisting.mp3", time = 3},
    ["sound20"] = {path = "049/there_you_are.mp3", time = 1},
    ["sound21"] = {path = "049/theres_no_need_to_hide.mp3", time = 3},
}

net.Receive("049_sound",function(_,ply)
    if ply:GetActiveWeapon():GetClass() ~= "scp_049_scp" then return end
    if ply:Team() ~= TEAM_049 then return end
    local snd = net.ReadString()
    ply:EmitSound(scp049sounds[snd].path, 80, 100, 1, CHAN_AUTO)
    ply:SetNWFloat("ATLAS.049.SoundCooldown", CurTime() + scp049sounds[snd].time)
end)