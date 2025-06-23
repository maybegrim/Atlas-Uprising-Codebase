AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

resource.AddFile("sound/scp_sweps/4000-w-sec.wav")

function SWEP:Initialize()
    self:SetDrawMat(false)
end

function SWEP:PrimaryAttack()
    local tr = util.TraceLine({
        start = self:GetOwner():GetShootPos(),
        endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 48,
        filter = self:GetOwner(),
        mask = MASK_SHOT_HULL
    })

    if not IsValid(tr.Entity) then
        tr = util.TraceHull({
            start = self:GetOwner():GetShootPos(),
            endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 48,
            filter = self:GetOwner(),
            mask = MASK_SHOT_HULL,
            mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 )
        })
    end
    
    if IsValid(tr.Entity) then
        local dmgInfo = DamageInfo()
        local att = self:GetOwner()
        if not att then att = self end

        dmgInfo:SetAttacker(att)
        dmgInfo:SetInflictor(self)
        dmgInfo:SetDamage(25)

        tr.Entity:TakeDamageInfo(dmgInfo)

        if not self:GetOwner().is_infected then
            timer.Simple(60, function()
                tr.Entity:Give("scp-4000-w")
                tr.Entity.is_infected = true
            end)
        end

        self:SetNextPrimaryFire(CurTime() + 1)
    end
end

function SWEP:SecondaryAttack()
    if self.SoundIsPlaying then return end

    self.SoundIsPlaying = true
    timer.Simple(9, function() self.SoundIsPlaying = false end)

    net.Start("SCPSweps.PlaySound")
        net.WriteString("scp_sweps/4000-w-sec.wav")
    net.Send(self:GetOwner())
end

function SWEP:Reload()
    self.nextReload = self.nextReload or 0
    if self.nextReload > CurTime() then return end

    if self:GetDrawMat() then
        self:GetOwner():SetModel(self:GetOwner().oldModel)
        self:SetDrawMat(false)
    else
        self:GetOwner().oldModel = self:GetOwner():GetModel()
        self:GetOwner():SetModel("models/player/stenli/lycan_werewolf.mdl")
        self:SetDrawMat(true)
    end

    self.nextReload = CurTime() + 1
end

hook.Add("PlayerDeath", "DropBox_Death", function(ply, inflictor, attacker)
    if IsValid(ply) and ply.is_infected then
        ply.is_infected = false
    end
end)