AddCSLuaFile()
SWEP.Author = "BananowyTasiemiec"
SWEP.Purpose = "Cure people"
SWEP.Instructions = "Left Click to cure Right Click to open sound menu."
SWEP.Category = "Atlas Uprising - Temp SCP Sweps"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModelFOV = 54
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.PrintName = "SCP 049"
SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
    self:SetHoldType("normal")
end

SWEP.SwingSound = ""
SWEP.HitSound = ""
SWEP.HoldType = "normal"
SWEP.AllowDrop = true
SWEP.Kind = WEAPON_MELEE
SWEP.Delay = 1
SWEP.Range = 60
SWEP.Damage = 0
SWEP.RemoveCan = true
SWEP.DocAndResearch = {} ---- jobs for special sound
SWEP.MTF = {} ---- jobs for special models
SWEP.MTFModel = ""
SWEP.InfectedModel = "models/player/zombie_classic.mdl"
SWEP.infectedTime = 300
SWEP.cooldown = 5
SWEP.currentInfectionCount = 0
SWEP.available = true
SWEP.soundnext = 0

function SWEP:Deploy()
    if timer.Exists("049cooldown_" .. self.Owner:EntIndex()) then
        self.available = false
    end
end

function SWEP:infectPlayer(ent)
    local ply = self.Owner
    if ( CLIENT ) then return end
    if ent:IsPlayer() and ent ~= ply and ent:GetModel() ~= self.InfectedModel then
        ent.EntModel = ent:GetModel()
        ent.IsInfected = true

        if self.available == true and timer.Exists("049cooldown_" .. ply:EntIndex()) == true then
            timer.Remove("049cooldown_" .. ply:EntIndex())
        end

        self.available = false

        if CLIENT then
            if timer.Exists("049cooldown_" .. ply:EntIndex()) then
                timer.Remove("049cooldown_" .. ply:EntIndex())
            end
        end

        timer.Create("049cooldown_" .. ply:EntIndex(), self.cooldown, 1, function()
            self.available = true

            if timer.Exists("049cooldown_" .. ply:EntIndex()) then
                timer.Remove("049cooldown_" .. ply:EntIndex())
            end
        end)

        if SERVER then
            ply:SendLua("chat.AddText( Color(255, 0, 0, 255), 'You have cured the plague on this person!')")
        end

        if table.HasValue(self.DocAndResearch, ent:Team()) then
            ply:EmitSound("049/not_doctor.mp3")
        else
            ply:EmitSound("049/i_am_the_cure.mp3")
        end

            if SERVER then
                if table.HasValue(self.MTF, ent:Team()) then
                    ent:SetModel(self.MTFModel)
                else
                    ent:SetModel(self.InfectedModel)
                end

            util.AddNetworkString("049_sendinfected_effects")
            util.AddNetworkString("049_cancelall")
            net.Start("049_sendinfected_effects")
            net.WriteString(tostring(self.infectedTime))
            net.Send(ent)
            ent:StripWeapons()
            ent:Give("zombie_claws")

            hook.Add("PlayerDeath", "Revert_To_Model", function(pl)
                if pl == ent and ent.IsInfected then
                    ent:SetModel(ent.EntModel)
                    net.Start("049_cancelall")
                    net.Send(pl)

                    if timer.Exists("049_killing_" .. ent:EntIndex()) then
                        timer.Remove("049_killing_" .. ent:EntIndex())
                    end

                    if timer.Exists("049_killing_" .. ent:EntIndex()) then
                        timer.Remove("049_killing_dc_" .. ent:EntIndex())
                    end

                    ent.IsInfected = false
                end
            end)
            ent:SetHealth(750)
        end
    end
end

function SWEP:PrimaryAttack()
    
    local ply = self:GetOwner()
    if ply.SCP049SwepCooldown and ply.SCP049SwepCooldown > CurTime() then
        return
    end
    ply.SCP049SwepCooldown = CurTime() + 5

    local tr = util.TraceHull{
        start = ply:GetShootPos(),
        endpos = ply:GetShootPos() + ply:GetAimVector() * 1500,
        filter = ply,
        mins = Vector(-10, -10, -10),
        maxs = Vector(10, 10, 10)
    }

    if not tr.Entity then return end
    local ent = tr.Entity
    if not IsValid(ply) then return end
    ply:SetAnimation(PLAYER_ATTACK1)

    if tr.StartPos:Distance(tr.HitPos) < 100 then
        self:EmitSound(self.HitSound)
    else
        self:EmitSound(self.SwingSound)
    end

    local vm = self:GetOwner():GetViewModel()
    if not IsValid(vm) then return end
    vm:SendViewModelMatchingSequence(vm:LookupSequence("attackch"))
    vm:SetPlaybackRate(1 + 2)
    local duration = vm:SequenceDuration() / vm:GetPlaybackRate()
    local time = CurTime() + duration
    self:SetNextPrimaryFire(time)

    if ent:IsPlayer() and SERVER then
        if ent:GetModel() ~= "models/aperturehz/aphaztechs/u4labtech_01.mdl" or ent:Health() < 30 then
            if ent:IsPlayer() and ent:Alive() then
                if ply:GetPos():Distance(ent:GetPos()) <= 100 then
                    if ent:GetModel() ~= self.InfectedModel then
                        local pest = math.random(1, 100)
                        if pest >= 90 then
                            ply:SendLua("chat.AddText( Color(117, 67, 242), 'This person does not have the pestilence.')")
                            return
                        end
                        if self.available == true then
                            ply:SendLua("chat.AddText( Color(117, 67, 242), 'You have infected this person!')")
                            self:infectPlayer(ent)
                        else
                            if not timer.Exists("049cooldown_" .. ply:EntIndex()) then
                                self.available = true
                                self:PrimaryAttack()
                            end

                            if SERVER then
                                ply:SendLua("chat.AddText( Color(255, 0, 0, 255), 'Time for " .. string.FormattedTime(timer.TimeLeft("049cooldown_" .. ply:EntIndex()), "%02i:%02i") .. " left on your cool down!')")
                            end
                        end
                    else
                        if SERVER then
                            ply:SendLua("chat.AddText( Color(255, 0, 0, 255), 'Already infected!')")
                        end
                    end
                end
            end
        end
    end
end

function SWEP:SecondaryAttack()

    if ( CLIENT ) then return end

    if self:GetOwner():GetNWFloat("ATLAS.049.SoundCooldown", 0) <= CurTime() then
        local ply = self.Owner
        net.Start("049_open")
            net.WriteEntity( self )
        net.Send(ply)
    else
        local ply = self.Owner
        net.Start("049_msg")
            net.WriteString("Already playing sound.")
        net.Send(ply)
    end
end

function SWEP:Reload()
    if ( CLIENT ) then return end
end