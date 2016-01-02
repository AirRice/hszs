AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Chainsaw' M249"
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 50

	SWEP.HUD3DBone = "v_weapon.receiver"
	SWEP.HUD3DPos = Vector(1, 2, 0)
	SWEP.HUD3DAng = Angle(0, 90, -90)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "crossbow"

SWEP.ViewModel = "models/weapons/v_mach_m249para.mdl"
SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_m249.Single")
SWEP.Primary.Damage = 13
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.06
SWEP.Primary.Recoil = 10
SWEP.Primary.KnockbackScale = 20

SWEP.Primary.ClipSize = 170
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "m249"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.ConeMax = 0.353
SWEP.ConeMin = 0.181

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.IronSightsPos = Vector(-4.46, 15, 0)
SWEP.IronSightsAng = Vector(3.2, 0, 0)
