AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "나이트메어"
end

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDamage = 49
SWEP.SlowDownScale = 2

function SWEP:Think()
	self.BaseClass.Think(self)
	if self.Owner:GetPremium() then
		self.Primary.OriginalDelay = self.Primary.OriginalDelay or self.Primary.Delay
		local mul = 0.85
		self.Primary.Delay = self.Primary.OriginalDelay * mul
		self.OriginalMeleeDelay = self.OriginalMeleeDelay or self.MeleeDelay * mul
		self.MeleeDelay = self.OriginalMeleeDelay * mul
	else
		self.Primary.Delay = self.BaseClass.Primary.Delay
		self.MeleeDelay = self.BaseClass.MeleeDelay
	end
end

function SWEP:Reload()
	self:SecondaryAttack()
end

function SWEP:PlayAlertSound()
	self.Owner:EmitSound("npc/barnacle/barnacle_tongue_pull"..math.random(3)..".wav")
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:PlayAttackSound()
	self.Owner:EmitSound("npc/barnacle/barnacle_bark"..math.random(2)..".wav")
end

if not CLIENT then return end

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
end

local matSheet = Material("Models/Charple/Charple1_sheet")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
end
