AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "티클 몬스터"
end

SWEP.Base = "weapon_zs_zombie"

SWEP.Primary.Delay = 1.2
SWEP.MeleeDelay = 0.74
SWEP.MeleeDamage = 22
SWEP.MeleeReach = 160
SWEP.MeleeSize = 5

function SWEP:Reload()
	self:SecondaryAttack()
end

function SWEP:Think()
	self.BaseClass.Think(self)
	if self.Owner:GetPremium() then
		self.MeleeReach = 180
	else
		self.MeleeReach = 160
	end
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
