AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.NextAura = 0
local Next = 0
function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	if self.NextAura <= CurTime() then
		self.NextAura = CurTime() + 2

		local origin = self.Owner:LocalToWorld(self.Owner:OBBCenter())
		for _, ent in pairs(ents.FindInSphere(origin, 40)) do
			if ent and ent:IsValid() and ent:IsPlayer() and ent:Team() ~= TEAM_UNDEAD and ent:Alive() and TrueVisible(origin, ent:NearestPoint(origin)) then
				ent:PoisonDamage(1, self.Owner, self)
			end
		end
	end
	
	-- local owner = self.Owner
	
	-- if Next <= CurTime() then
		-- local ent = ents.Create("projectile_rocket")
		-- ent:SetPos(owner:GetShootPos())
		-- ent:SetAngles((owner:GetAimVector()):Angle())
		-- ent.OriginalAngles = owner:GetAimVector():Angle()
		-- ent:SetOwner(owner)
		-- ent:SetInflictor(self)
		-- ent.Damage = 250
		-- ent:Spawn()
		-- Next = CurTime() + 0.5
	-- end
end

local function ChemDamage(inflictor, attacker, epicenter, radius, damage, noreduce)
	local filter = inflictor
	for _, ent in pairs(ents.FindInSphere(epicenter, radius)) do
		if ent and ent:IsValid() then
			local nearest = ent:NearestPoint(epicenter)
			if TrueVisibleFilters(epicenter, nearest, inflictor, ent) then
				if ent:IsNailed() then
					damage = damage * 3 / 5
					ent:TakeDamage(damage, attacker, self)
				else
					ent:PoisonDamage(((radius - nearest:Distance(epicenter)) / radius) * damage, attacker, inflictor, nil, noreduce)
				end
			end
		end
	end
end

local function ChemBomb(pl, pos)
	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
	util.Effect("chemzombieexplode", effectdata, true)

	if DUMMY_CHEMZOMBIE:IsValid() then
		DUMMY_CHEMZOMBIE:SetPos(pos)
	end
	ChemDamage(DUMMY_CHEMZOMBIE, pl, pos, 128, 25, true)

	pl:CheckRedeem()
end

function SWEP:PrimaryAttack()
	self.Owner:TakeDamage(self.Owner:Health() * 10, self.Owner, self)
	self.Owner:SetSpeed(1)
	self.Owner:EmitSound("NPC_PoisonZombie.ThrowWarn")
	self.Owner:EmitSound("NPC_PoisonZombie.ThrowWarn")
	self.Owner:EmitSound("NPC_PoisonZombie.ThrowWarn")
	self.Owner:EmitSound("NPC_PoisonZombie.ThrowWarn")
	timer.Simple(0.5, function()
		ChemBomb(self.Owner, self.Owner:LocalToWorld(self.Owner:OBBCenter()))
	end)
end
