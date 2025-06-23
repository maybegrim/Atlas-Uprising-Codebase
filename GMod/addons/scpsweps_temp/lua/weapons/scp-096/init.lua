AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

resource.AddFile("sound/scp_sweps/096-reload.mp3")
resource.AddFile("sound/scp_sweps/096-cry.mp3")

util.AddNetworkString("SCPSweps.PlaySound")
util.AddNetworkString("SCPSweps.AddGlow")

function SWEP:PrimaryAttack()
    if not self:CheckIfBeingLookedAt() then return end

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
        dmgInfo:SetDamage(300)

        tr.Entity:TakeDamageInfo(dmgInfo)
        self:SetNextPrimaryFire(CurTime() + 1)
    end
end

function SWEP:SecondaryAttack()
    if self.SoundIsPlaying then return end

    self.SoundIsPlaying = true
    timer.Simple(12, function() self.SoundIsPlaying = false end)

    net.Start("SCPSweps.PlaySound")
        net.WriteString("scp_sweps/096-cry.mp3")
    net.Send(self:GetOwner())
end

function SWEP:Reload()
    if self.SoundIsPlaying then return end

    self.SoundIsPlaying = true
    timer.Simple(34, function() self.SoundIsPlaying = false end)

    net.Start("SCPSweps.PlaySound")
        net.WriteString("scp_sweps/096-reload.mp3")
    net.Send(self:GetOwner())
end

function SWEP:CheckIfBeingLookedAt()
    for _, ply in ipairs(player.GetAll()) do
        local trace = ply:GetEyeTraceNoCursor()
        if IsValid(trace.Entity) and trace.Entity == self:GetOwner() then
            net.Start("SCPSweps.AddGlow")
            net.Send(trace.Entity)
            return true
        end
    end

    return false
end