AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "구울"
end

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDamage = 12
SWEP.MeleeForceScale = 3.5
SWEP.SlowDownScale = 2
SWEP.MeleeDelay = 0.74
SWEP.Primary.Delay = 1.2
--SWEP.MeleeForceScale = 0.1
--SWEP.SlowDownScale = 2.25
SWEP.SlowDownImmunityTime = 2

function SWEP:ApplyMeleeDamage(ent, trace, damage)
	ent:PoisonDamage(damage, self.Owner, self, trace.HitPos)
	if SERVER and ent:IsPlayer() then
		ent:GiveStatus("ghoultouch", 10 + (self.Owner:GetPremium() and 3 or 0))
		if (ent:Team() == TEAM_HUMAN) then
			ent:SetJumpPower(1)
		
			timer.Simple(1, function()
				ent:ResetJumpPower()
			end)
			
			local rand = math.random(1, 10000)
			if (rand > 5000 && rand <= 6000) then
				ent:GiveStatus("knockdown", 1 * (self.buffStrong and 0.2 or 1))
			end
		end
	end
end

function SWEP:Reload()
	self.BaseClass.SecondaryAttack(self)
end

function SWEP:PlayAlertSound()
	self.Owner:EmitSound("npc/fast_zombie/fz_alert_close1.wav", 75, math.Rand(70, 80))
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:PlayAttackSound()
	self.Owner:EmitSound("npc/fast_zombie/leap1.wav", 74, math.Rand(110, 130))
end

local function DoFleshThrow(pl, wep)
	if pl:IsValid() and pl:Alive() and wep:IsValid() then
		pl:ResetSpeed()

		if SERVER then
			local startpos = pl:GetShootPos()
			local aimang = pl:EyeAngles()

			for i=1, 4 + (pl:GetPremium() and 3 or 0) do
				local ang = Angle(aimang.p, aimang.y, aimang.r)
				ang:RotateAroundAxis(ang:Up(), math.Rand(-8, 8))
				ang:RotateAroundAxis(ang:Right(), math.Rand(-8, 8))

				local ent = ents.Create("projectile_poisonflesh")
				if ent:IsValid() then
					ent:SetPos(startpos)
					ent:SetOwner(pl)
					ent:Spawn()

					local phys = ent:GetPhysicsObject()
					if phys:IsValid() then
						phys:SetVelocityInstantaneous(ang:Forward() * math.Rand(320, 380))
					end
				end
			end

			pl:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(85, 95))
		end

		if CurTime() >= (pl.GhoulImmunity or 0) then
			pl.GhoulImmunity = CurTime() + 2
			pl:RawCapLegDamage(CurTime() + 2)
		end
	end
end

function SWEP:SecondaryAttack()
	local owner = self.Owner
	if CurTime() < self:GetNextPrimaryFire() or CurTime() < self:GetNextSecondaryFire() or IsValid(owner.FeignDeath) then return end

	self:SetNextSecondaryFire(CurTime() + 3)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self.Owner:DoAttackEvent()
	self:EmitSound("npc/fast_zombie/leap1.wav", 74, math.Rand(110, 130))
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", 72, math.Rand(85, 95))
	self.Owner:RawCapLegDamage(CurTime() + 3)
	self:SendWeaponAnim(ACT_VM_HITCENTER)
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	timer.Simple(0.7, function() DoFleshThrow(owner, self) end)
end

if not CLIENT then return end

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
end

local matSheet = Material("models/weapons/v_zombiearms/ghoulsheet")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
end
