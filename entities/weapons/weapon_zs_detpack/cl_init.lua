include("shared.lua")

SWEP.PrintName = "원격 폭발물 팩"
SWEP.Description = "원격으로 폭파시킬 수 있는 폭발물 만땅 패키지.\n주 공격 버튼: 설치\n보조 공격 버튼: 폭파!\n달리기 버튼: 회수"
SWEP.DrawCrosshair = false

SWEP.Slot = 4
SWEP.SlotPos = 0

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self.Owner, self)

	return true
end

function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end

function SWEP:PrimaryAttack()
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end
