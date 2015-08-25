include("shared.lua")

SWEP.PrintName = "수류탄"
SWEP.Description = "일반적인 파쇄 수류탄.\n적절한 조건 하에 사용한다면, 좀비들을 흔적도 없이 쓸어버릴 수 있다."

SWEP.ViewModelFOV = 60

SWEP.Slot = 4
SWEP.SlotPos = 0

--[[function SWEP:GetViewModelPosition(pos, ang)
	if self:GetPrimaryAmmoCount() <= 0 then
		return pos + ang:Forward() * -256, ang
	end

	return pos, ang
end]]

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end
