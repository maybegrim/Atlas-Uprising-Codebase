local _ = {
    _ = "Primary",
    a = "Secondary",
    b = "Owner",
    c = "Weapon"
}

SWEP.Primary.Damage = 45
SWEP[_._].ClipSize = -1
SWEP[_._].DefaultClip = -1
SWEP[_._].Delay = 2
SWEP[_._].Automatic = not not 1
SWEP[_._].Ammo = "None"
SWEP[_.a].ClipSize = -1
SWEP[_.a].DefaultClip = -1
SWEP[_.a].Automatic = not 1
SWEP[_.a].Ammo = "None"
SWEP.Weight = 3
SWEP.AutoSwitchTo = not 1
SWEP.AutoSwitchFrom = not 1
SWEP.DrawAmmo = not 1
SWEP.DrawCrosshair = not not 1
SWEP.IdleAnim = not not 1
SWEP.IconLetter = "w"
SWEP.UseHands = false
SWEP.Author = "Bananowytasiemiec"
SWEP.Purpose = "Kill people"
SWEP.Category = "Atlas Uprising - Temp SCP Sweps"
SWEP.Instructions = "LMB to attack"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = not 1
SWEP.ViewModel = "models/zombie/arms/v_zombiearms.mdl"
SWEP.WorldModel = ""
SWEP.PrintName = "Zombie claws"
SWEP.HoldType = "normal"
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.Spawnable = not not 1
SWEP.AdminSpawnable = not not 1
SWEP.AttackAnims    = { 
    ACT_VM_SECONDARYATTACK,
    ACT_VM_HITCENTER}
SWEP.WorldAnim      = {
    ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL,
    ACT_GMOD_GESTURE_RANGE_ZOMBIE
}
SWEP.HitSound   = {
    "npc/zombie/claw_strike1.wav",
    "npc/zombie/claw_strike2.wav",
    "npc/zombie/claw_strike3.wav"}
SWEP.MissSound  = {
    "npc/fast_zombie/claw_miss2.wav",
    "npc/fast_zombie/claw_miss1.wav"}
SWEP.FleshSound = {
    "physics/flesh/flesh_squishy_impact_hard1.wav",
    "physics/flesh/flesh_squishy_impact_hard2.wav",
    "physics/flesh/flesh_squishy_impact_hard3.wav",
    "physics/flesh/flesh_squishy_impact_hard4.wav"}
SWEP.AttackSound= {
    "npc/fast_zombie/leap1.wav"}
SWEP.SwingSound = {
    "npc/zombie/claw_miss1.wav",
    "npc/zombie/claw_miss2.wav"}
local panicmaterial = Material("materials/scps/049/pin.png")
local callColor = Color(255, 255, 255)
local scp049 = false
if SERVER then
util.AddNetworkString("HYPEX.049.Infected")
end
if CLIENT then
surface.CreateFont("049_DIST_FONT", {
	font = "DebugFixedSmall",
	size = 24,
	weight = 500,
	antialias = true,
})
end
function SWEP:Initialize()
    self:SetHoldType( "normal" )
end

function SWEP:Equip(ply)
    net.Start("HYPEX.049.Infected")
    net.WriteBool(false)
    net.Send(ply)
    ply.SCP049INFECTED = true
end

if CLIENT then
    net.Receive("HYPEX.049.Infected", function()
        if net.ReadBool() then hook.Remove("HUDPaint", "HYPEX.049.UI") return end
        for k,v in pairs(player.GetAll()) do
            if team.GetName(v:Team()) == team.GetName(TEAM_049) then
                scp049 = v
                break
            end
        end
        hook.Add("HUDPaint", "HYPEX.049.UI", function()
            if not scp049 then return end
            if not IsValid(scp049) then
                scp049 = false
                return
            end
            local player = LocalPlayer()
            local myPos = player:GetPos()
            if (myPos:DistToSqr(scp049:GetPos()) < 20000) then return end

            local callPos = scp049:GetPos():ToScreen()
            surface.SetDrawColor(color_white)
            surface.SetMaterial(panicmaterial)
            surface.DrawTexturedRect(callPos.x-10, callPos.y, 20, 20)
            draw.DrawText("SCP-049", "049_DIST_FONT", callPos.x, callPos.y-25, callColor, TEXT_ALIGN_CENTER)
            draw.DrawText(string.sub(math.Round(myPos:Distance(scp049:GetPos())), 1, -3) .."m", "049_DIST_FONT", callPos.x, callPos.y+20, callColor, TEXT_ALIGN_CENTER)
        end)
        
    end)
end

function SWEP:PrimaryAttack()
    self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
    
    if game.MaxPlayers() < 2 then self.AnimDelay = CurTime() + self.Primary.Delay
    else self.AnimDelay = SysTime() + self.Primary.Delay end
    
    local owner = self.Owner
    if !owner:IsValid() then return end
    if !owner:Alive() then return end
    
    self:PrimaryAttackZombie(owner)
end


function SWEP:PrimaryAttackZombie(owner)
    local tr, trace, anim
    
    --------------------------

    owner:DoAnimationEvent(table.Random(self.WorldAnim))
    if SERVER then
        owner:EmitSound(table.Random(self.SwingSound))
        owner:EmitSound("npc/zombie/zo_attack"..math.random(1,2)..".wav", 45)
        owner:EmitSound("npc/zombie/zombie_voice_idle"..math.random(1,14)..".wav", 45)
    end
    
    ------------------------
    
    tr = {}
    tr.start = owner:GetShootPos()
    tr.endpos = owner:GetShootPos() + ( owner:GetAimVector() * 95 )
    tr.filter = owner
    tr.mask = MASK_SHOT
    trace = util.TraceLine( tr )

    if ( trace.Hit ) then

        if trace.Entity:IsPlayer() 
        or string.find(trace.Entity:GetClass(),"npc") 
        or string.find(trace.Entity:GetClass(),"prop_ragdoll") then
            bullet = {}
            bullet.Num    = 1
            bullet.Src    = owner:GetShootPos()
            bullet.Dir    = owner:GetAimVector()
            bullet.Spread = Vector(0, 0, 0)
            bullet.Tracer = 0
            bullet.Force  = 1
            bullet.Damage = self.Primary.Damage
            owner:FireBullets(bullet)
        else
            bullet = {}
            bullet.Num    = 1
            bullet.Src    = owner:GetShootPos()
            bullet.Dir    = owner:GetAimVector()
            bullet.Spread = Vector(0, 0, 0)
            bullet.Tracer = 0
            bullet.Force  = 1
            bullet.Damage = self.Primary.Damage
            owner:FireBullets(bullet)   
            util.Decal("ManhackCut", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
            self.Weapon:EmitSound(table.Random(self.HitSound),75)
        end
    else
        self.Weapon:EmitSound(table.Random(self.MissSound),75)
    end
    
    self.Weapon:SendWeaponAnim(self.AttackAnims[ math.random( 1, 2 ) ])
    
    timer.Simple( 0.06, function() owner:ViewPunch( Angle( -2, -2,  0 ) ) end )
    timer.Simple( 0.23, function() owner:ViewPunch( Angle(  3,  1,  0 ) ) end )
end

function SWEP:Deploy()
    return not not 1
end

function SWEP:Holster()
    return not not 1
end

function SWEP:SecondaryAttack()
	return!1
end