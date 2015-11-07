AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Militia' 저격 소총"
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	
	SWEP.Description = "좀비의 두꺼운 가죽을 관통하는 특수 탄환을 발사한다. (관통력 5)\n머리를 맞출 경우 확실히 파괴한다.(데미지 3배)"

	SWEP.HUD3DBone = "v_weapon.g3sg1_Clip"
	SWEP.HUD3DPos = Vector(-1.2, -2.75, 2)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = Model( "models/weapons/cstrike/c_snip_g3sg1.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_snip_g3sg1.mdl" )

SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_G3SG1.ClipOut")
SWEP.Primary.Sound = Sound( "Weapon_G3SG1.Single" )
SWEP.Primary.Damage = 18
SWEP.Primary.NumShots = 2
SWEP.Primary.Delay = 0.3
SWEP.Primary.Recoil = 10

SWEP.Primary.ClipSize = 10
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 30

SWEP.ArmorThrough = 5
SWEP.ArmorThroughRate = 0

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 0.452
SWEP.ConeMin = 0

SWEP.IronSightsPos = Vector(5.015, -4, 2.52)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.WalkSpeed = SPEED_SLOW

function SWEP:IsScoped()
	return self:GetIronsights() and self.fIronTime and self.fIronTime + 0.25 <= CurTime()
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 85, 100)
end

if CLIENT then
	SWEP.IronsightsMultiplier = 0.25

	function SWEP:GetViewModelPosition(pos, ang)
		if self:IsScoped() then
			return pos + ang:Up() * 256, ang
		end

		return self.BaseClass.GetViewModelPosition(self, pos, ang)
	end

	local matScope = Material("zombiesurvival/scope")
	function SWEP:DrawHUDBackground()
		if self:IsScoped() then
			local scrw, scrh = ScrW(), ScrH()
			local size = math.min(scrw, scrh)
			surface.SetMaterial(matScope)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect((scrw - size) * 0.5, (scrh - size) * 0.5, size, size)
			surface.SetDrawColor(0, 0, 0, 255)
			if scrw > size then
				local extra = (scrw - size) * 0.5
				surface.DrawRect(0, 0, extra, scrh)
				surface.DrawRect(scrw - extra, 0, extra, scrh)
			end
			if scrh > size then
				local extra = (scrh - size) * 0.5
				surface.DrawRect(0, 0, scrw, extra)
				surface.DrawRect(0, scrh - extra, scrw, extra)
			end
		end
	end
end

local function bulletcallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if ent:IsValid() then
		if ent:IsPlayer() then
			if ent:Team() == TEAM_UNDEAD and tempknockback then
				tempknockback[ent] = ent:GetVelocity()
			end
			
			if tr.HitGroup == HITGROUP_HEAD then
				dmginfo:ScaleDamage(3)
			end
		else
			local phys = ent:GetPhysicsObject()
			if ent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
				ent:SetPhysicsAttacker(attacker)
			end
		end
	end
end

SWEP.BulletCallback = bulletcallback