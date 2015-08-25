AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Breakout' 돌격 소총"
	SWEP.Slot = 2
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "v_weapon.sg552_Clip"
	SWEP.HUD3DPos = Vector(-1.2, -2.5, -3)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.019
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = Model( "models/weapons/cstrike/c_rif_sg552.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_rif_sg552.mdl" )
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("Weapon_AUG.Single")
SWEP.Primary.Damage = 25
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.09
SWEP.Primary.Recoil = 4.787

SWEP.Primary.ClipSize = 20
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.ConeMax = 0.3291
SWEP.ConeMin = 0.0787

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.IronSightsAng = Vector(-1, -1, 0)
SWEP.IronSightsPos = Vector(-3, 4, 3)
