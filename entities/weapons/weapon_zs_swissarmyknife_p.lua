AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "스위스 육군 칼 *"
	SWEP.Description = "백스텝으로 두 배의 데미지!"

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 55
end

SWEP.Base = "weapon_zs_swissarmyknife"

SWEP.HoldType = "knife"

SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.UseHands = true

SWEP.MeleeDamage = 6
SWEP.MeleeRange = 64
SWEP.MeleeSize = 0.875

SWEP.WalkSpeed = SPEED_FASTEST

SWEP.ArmorThrough = 8

SWEP.Primary.Delay = 0.33