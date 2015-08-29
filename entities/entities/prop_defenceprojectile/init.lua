AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.Radius = 225
ENT.Gravity = 1500
ENT.MinGravity = ENT.Gravity / 5

ENT.Projectiles = {}

function ENT:Initialize()
	self:SetModel("models/roller.mdl")
	self:SetMaterial("models/effects/comball_sphere")
	self:PhysicsInit(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
		phys:Wake()
	end

	self:SetMaxObjectHealth(300)
	self:SetObjectHealth(self:GetMaxObjectHealth())
end

function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)

	local attacker = dmginfo:GetAttacker()
	if not (attacker:IsValid() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN) then
		self:ResetLastBarricadeAttacker(attacker, dmginfo)
		self:SetObjectHealth(self:GetObjectHealth() - dmginfo:GetDamage())
	end
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
	if health <= 0 and not self.Destroyed then
		self.Destroyed = true

		local e = EffectData()
		e:SetOrigin(self:GetPos())
		util.Effect("Explosion", e)
	end
end

function ENT:AltUse(activator, tr)
	self:PackUp(activator)
end

function ENT:OnPackedUp(pl)
	pl:GiveEmptyWeapon("weapon_zs_defenceprojectile")
	pl:GiveAmmo(1, "defenceprojectile")

	pl:PushPackedItem(self:GetClass(), self:GetObjectHealth())

	self:Remove()
end

function ENT:DefenceProjectiles()
	local center = self:LocalToWorld(self:OBBCenter())
	local allent = ents.FindInSphere(center, self.Radius)
	
	local td = {}
	td.start = center
	td.filter = {self}
	
	local sz = 7
	td.mins = Vector(-sz, -sz, -sz)
	td.maxs = Vector(sz, sz, sz)
	table.Add(td.filter, player.GetAll())
	table.Add(td.filter, game.GetWorld())
	td.mask = MASK_SHOT
	
	for _, v in pairs(allent) do
		if string.find(v:GetClass(), "^projectile_") then
			local projpos = v:GetPos()
			
			td.endpos = projpos
			
			local trace = util.TraceHull(td)
			
			if trace.Hit and trace.HitPos == td.endpos then
				trace.Hit = true
				trace.Entity = v
			end
			
			if trace.Entity == v then
				if !table.HasValue(self.Projectiles, v) then
					table.Add(self.Projectiles, {v})	
					self:SetObjectHealth(self:GetObjectHealth() - self:GetMaxObjectHealth() * 0.003)
				end
				if !table.HasValue(td.filter, v) then
					table.Add(td.filter, {v})
				end
				local e = EffectData()
					e:SetOrigin(self:GetPos())
					e:SetScale(v:GetPos():Distance(self:GetPos()))
				util.Effect("defenceprojectile", e)
			end
		end
	end
end

function ENT:PhysicsCollide(data, collider)
	local ent = data.HitEntity
	if IsValid(ent) and string.find(ent:GetClass(), "^projectile_") then
		local e = EffectData()
			e:SetOrigin(self:GetPos())
			e:SetScale(ent:GetPos():Distance(self:GetPos()))
		util.Effect("defenceprojectile", e)
		self:EmitSound("npc/scanner/scanner_electric" .. math.random(1, 2) .. ".wav", 100, 100)
		timer.Simple(0, function()
			ent:Remove()
		end)
	end
end

function ENT:ProcessProjectiles()
	local projectiles = self.Projectiles
	local start = self:LocalToWorld(self:OBBCenter())
	for i, v in pairs(projectiles) do
		if IsValid(v) then
			if IsValid(v:GetParent()) then
				v:SetParent(NULL)
			end
			
			local pos = v:GetPos()
			local dist = start:Distance(pos)
			local phys = v:GetPhysicsObject()
			if dist <= self.Radius then
				local mul = 1 - (dist / self.Radius)
				
				if IsValid(phys) then
					v:SetGravity(0)
					phys:EnableMotion(true)
					phys:EnableGravity(false)
					phys:AddVelocity((start - pos):GetNormal() * (math.max(self.Gravity * mul, self.MinGravity)))
				end
			else
				if IsValid(phys) then
					phys:EnableGravity(true)
				end
				table.remove(self.Projectiles, i)
			end
		else
			table.remove(self.Projectiles, i)
		end
	end
end

function ENT:Think()
	self:DefenceProjectiles()
	self:ProcessProjectiles()
	if self.Destroyed then
		for _, v in pairs(self.Projectiles) do
			local phys = v:GetPhysicsObject()
			
			if IsValid(phys) then
				v:SetGravity(1)
				phys:EnableGravity(true)
			end
		end
		self:Remove()
	end
	self:NextThink(CurTime())
end
