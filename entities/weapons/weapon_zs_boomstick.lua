AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "붐스틱"
	SWEP.Description = "이 샷건은 탄창 안에 있는 모든 탄환을 한번에 격발시킬 수 있다. 재장전 키를 누르고 있으면 더 빨리 장전된다."
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.HUD3DBone = "ValveBiped.Gun"
	SWEP.HUD3DPos = Vector(1.65, 0, -8)
	SWEP.HUD3DScale = 0.025
	
	SWEP.ViewModelFlip = false
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.ReloadDelay = 0.4

SWEP.Primary.Sound = Sound("weapons/shotgun/shotgun_dbl_fire.wav")
SWEP.Primary.Recoil = 88
SWEP.Primary.Damage = 36
SWEP.Primary.NumShots = 6
SWEP.Primary.Delay = 1.5
SWEP.Primary.Recoil = 50

SWEP.Primary.ClipSize = 6
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.DefaultClip = 28

SWEP.ConeMax = 2.999
SWEP.ConeMin = 1.646

SWEP.WalkSpeed = SPEED_SLOWER

function SWEP:SetIronsights()
end

SWEP.reloadtimer = 0
SWEP.nextreloadfinish = 0

function SWEP:Reload()
	self.ConeMul = 1
	
	if self.reloading then return end

	if self:GetNextReload() <= CurTime() and self:Clip1() < self.Primary.ClipSize and 0 < self.Owner:GetAmmoCount(self.Primary.Ammo) then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self.reloading = true
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
		self.Owner:DoReloadEvent()
		self:SetNextReload(CurTime() + self:SequenceDuration())
	end
end

function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:EmitSound(self.Primary.Sound)

		local clip = self:Clip1()

		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots * clip, self:GetCone())

		self:TakePrimaryAmmo(clip)
		self.Owner:ViewPunch(clip * 0.5 * self.Primary.Recoil * Angle(math.Rand(-0.1, -0.1), math.Rand(-0.1, 0.1), 0))

		self.Owner:SetGroundEntity(NULL)
		self.Owner:SetVelocity(-80 * clip * self.Owner:GetAimVector())

		self.IdleAnimation = CurTime() + self:SequenceDuration()
		
		self.LastFired = CurTime()
	end
end

function SWEP:Think()
	if self.reloading and self.reloadtimer < CurTime() then
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_VM_RELOAD)

		self.Owner:RemoveAmmo(1, self.Primary.Ammo, false)
		self:SetClip1(self:Clip1() + 1)
		self:EmitSound("Weapon_Shotgun.Reload")

		if self.Primary.ClipSize <= self:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 or not self.Owner:KeyDown(IN_RELOAD) then
			self.nextreloadfinish = CurTime() + self.ReloadDelay
			self.reloading = false
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		end
	end

	local nextreloadfinish = self.nextreloadfinish
	if nextreloadfinish ~= 0 and nextreloadfinish < CurTime() then
		self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
		self:EmitSound("Weapon_Shotgun.Special1")
		self.nextreloadfinish = 0
	end

	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	if self:GetIronsights() and not self.Owner:KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end
	if self.LastFired + self.ConeResetDelay > CurTime() then
		local multiplier = 1
		multiplier = multiplier + (self.ConeMax * 100) * ((self.LastFired + self.ConeResetDelay - CurTime()) / self.ConeResetDelay)
		self.ConeMul = math.min(multiplier, 1)
	end
end

function SWEP:CanPrimaryAttack()
	if self.Owner:IsHolding() or self.Owner:GetBarricadeGhosting() then return false end

	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Shotgun.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.25)
		return false
	end

	if self.reloading then
		if self:Clip1() < self.Primary.ClipSize then
			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
		else
			self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
			self:EmitSound("Weapon_Shotgun.Special1")
		end
		self.reloading = false
		self:SetNextPrimaryFire(CurTime() + 0.25)
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end
