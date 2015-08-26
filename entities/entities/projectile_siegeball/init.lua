AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.LifeTime = 10

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Owner")
end

function ENT:Initialize()
	self:SetModel("models/weapons/w_bugbait.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetTrigger(true)
	self.DieTime = CurTime() + (self.LifeTime or 10)
end

function ENT:PhysicsCollide(data, phys)
	local ent = data.HitEntity
	
	if ent:GetClass() ~= self:GetClass() then
		self:Explode()
	end
end

function ENT:Think()
	local owner = self:GetOwner()
	
	if !IsValid(owner) or !owner:IsPlayer() or (owner:Team() == TEAM_HUMAN) then
		self:Explode()
	end
	
	if self:WaterLevel() >= 1 then
		self:Explode()
	end
end

function ENT:Explode()
	local humans = {}
	
	for _, v in pairs(player.GetAll()) do
		if v:Team() == TEAM_HUMAN then
			table.insert(humans, v)
		end
	end
	
	local td = {}
	td.start = self:LocalToWorld(self:OBBCenter())
	td.filter = {self, owner}
	
	local trace = nil
	
	local validlist = {}
	
	if #humans >= 1 then
		for i, v in pairs(humans) do
			td.endpos = v:LocalToWorld(v:OBBCenter())
			trace = util.TraceLine(td)

			if IsValid(trace.Entity) and trace.Entity == v then
				table.insert(validlist, v)
				table.insert(td.filter, v)
			end
		end
	end
	
	for _, v in pairs(validlist) do
		v:SetGroundEntity(NULL)
		v:SetLocalVelocity(((v:LocalToWorld(v:OBBCenter()) - self:LocalToWorld(self:OBBCenter())):GetNormal() * Vector(1, 1, 0) + Vector(0, 0, 0.35)) * 225)
		local dmg = math.ceil(8 * (1 - (v:GetPos():Distance(self:GetPos()) / 225)))
		v:TakeDamage(dmg, owner, self)
	end
	
	local ed = EffectData()
	ed:SetOrigin(self:LocalToWorld(self:OBBCenter()))
	ed:SetScale(100)
	ed:SetMagnitude(200)
	ed:SetNormal(VectorRand())
	util.Effect("siegeball", ed)
	
	self:EmitSound("weapons/bugbait/bugbait_impact" .. tostring(math.random(1, 2) == 1 and 1 or 3) .. ".wav")
	self:Remove()
end