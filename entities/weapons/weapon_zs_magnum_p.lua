AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Ricochete' 매그넘 *"
	SWEP.Description = "이 총의 총알은 벽에 부딪치면 튀어나와 또 다른 데미지를 가한다."
	SWEP.Slot = 1
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "Python"
	SWEP.HUD3DPos = Vector(0.85, 0, -2.5)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("Weapon_357.Single")
SWEP.Primary.Delay = 0.58
SWEP.Primary.Damage = 36
SWEP.Primary.NumShots = 1
SWEP.Primary.Recoil = 7

SWEP.Primary.ClipSize = 16
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "357_premium"
SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
SWEP.Primary.DefaultClip = 9999
-- GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ConeMax = 0.095
SWEP.ConeMin = 0.025

SWEP.IronSightsPos = Vector(-4.65, 4, 0.25)
SWEP.IronSightsAng = Vector(0, 0, 1)

function SWEP:Think()
	self.BaseClass.Think(self)
	if !self.Owner:GetPremium() then
		self:Remove()
	end
	self.Owner:SetAmmo(9999, "357_premium")
end

-- local function DoRicochet(attacker, hitpos, hitnormal, normal, damage)
	-- attacker.RicochetBullet = true
	-- attacker:FireBullets({Num = 1, Src = hitpos, Dir = 2 * hitnormal * hitnormal:Dot(normal * -1) + normal, Spread = Vector(0, 0, 0), Tracer = 1, TracerName = "rico_trace", Force = damage * 0.15, Damage = damage, Callback = GenericBulletCallback})
	-- attacker.RicochetBullet = nil
-- end
-- function SWEP.BulletCallback(attacker, tr, dmginfo)
	-- if SERVER and tr.HitWorld and not tr.HitSky then
		-- local hitpos, hitnormal, normal, dmg = tr.HitPos, tr.HitNormal, tr.Normal, dmginfo:GetDamage() * 1.3
		-- timer.Simple(0, function() DoRicochet(attacker, hitpos, hitnormal, normal, dmg) end)
	-- end

	-- GenericBulletCallback(attacker, tr, dmginfo)
-- end
