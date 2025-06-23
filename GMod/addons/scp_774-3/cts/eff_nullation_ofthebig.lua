ocal mat3 = Material("sprites/light_glow02_add")
function EFFECT:Init(data)
	self.Origin = data:GetOrigin()
	self.Origin2 = self.Origin
	self.Normal = data:GetNormal()
	self.Time = 1
	self.LifeTime = CurTime() + self.Time

	self:SetRenderBoundsWS(self.Origin + Vector(256, 256,256), self.Origin - Vector(256, 256,256))

	local emitter = ParticleEmitter(self.Origin, false)

	for i = 1, math.random(40,80) do
		local part = emitter:Add("sprites/light_glow02_add", self.Origin)
		part:SetAngleVelocity(AngleRand(8, 15) * math.Rand(-1, 1))
		part:SetVelocity((self.Normal + VectorRand() * 0.5) * 500)
		part:SetDieTime(math.Rand(0.4, 1))
		part:SetMaterial( mat3 )

		part:SetStartSize(32)
		part:SetEndSize(0)

		part:SetColor(0, 128, 255)

		part:SetAirResistance(10)
		part:SetCollide(false)

		part:SetStartAlpha(255)
		part:SetEndAlpha(0)
	end

	emitter:Finish()

	self:EmitSound("weapons/mortar/mortar_explode" .. math.random(1,3) .. ".wav")
end

local mat = Material("effects/combinemuzzle2")
local mat2 = Material("sprites/strider_blackball")
local mat4 = Material("effects/ar2ground2")
mat2:SetFloat("$ignorez", "1")
function EFFECT:Render()
	local lerp = Lerp((self.LifeTime - CurTime()) / self.Time, 0, 1)
	local size1 = lerp * 512
	render.SetMaterial(mat)
	render.DrawQuadEasy(self.Origin + self.Normal * 2, self.Normal, size1, size1)
	render.SetMaterial(mat2)

	local size2 = math.sin(lerp * 3.14) * 128

	render.DrawSprite(self.Origin, size2, size2)

	render.SetMaterial(mat4)
	render.DrawBeam(self.Origin2 + self.Normal * 512 * lerp, self.Origin2, 256, 0, lerp)
end

function EFFECT:Think()
	if(self.LifeTime < CurTime()) then
		return false
	end

	return true
endf