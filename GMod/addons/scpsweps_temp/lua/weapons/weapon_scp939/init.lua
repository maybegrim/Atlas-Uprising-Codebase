AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:Deploy() self:SetHoldType( "normal" ) end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + 1)
    local trace = util.TraceHull( {
        start = self:GetOwner():GetShootPos(),
        endpos = self:GetOwner():GetShootPos() + ( self:GetOwner():GetAimVector() * 300 ),
        filter = self:GetOwner(),
        mins = Vector( -10, -10, -10 ),
        maxs = Vector( 10, 10, 10 ),
        mask = MASK_SHOT_HULL
    } )

    self.Owner:SetAnimation( PLAYER_ATTACK1 );
    self.Weapon:EmitSound( "" )
    if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 then
    	bullet = {}
        bullet.Num    = 1
        bullet.Src    = self.Owner:GetShootPos()
        bullet.Dir    = self.Owner:GetAimVector()
        bullet.Spread = Vector(0, 0, 0)
        bullet.Tracer = 0
        bullet.Force  = 25
        bullet.Damage = math.random(90, 130)
        self.Owner:FireBullets(bullet)
    end

end