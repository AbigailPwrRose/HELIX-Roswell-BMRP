ENT.Type = "anim"
ENT.Category = "Winter's Chemistry"
ENT.PrintName = "Troilite Ore"
ENT.Author = "Winter"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Model = "models/props_mining/rock_caves01b.mdl"
ENT.bNoPersist = true

if (SERVER) then
    function ENT:Initialize()
        self:SetModel(self.Model) -- Sets the model for the Entity.
        self:PhysicsInit( SOLID_VPHYSICS ) -- Initializes physics for the Entity, making it solid and interactable.
        self:SetMoveType( MOVETYPE_VPHYSICS ) -- Sets how the Entity moves, using physics.
        self:SetSolid( SOLID_VPHYSICS ) -- Makes the Entity solid, allowing for collisions.
        self:SetName("Troilite Ore")
        
        local phys = self:GetPhysicsObject() -- Retrieves the physics object of the Entity.
        phys:SetMass(100)
        phys:EnableMotion(true)
        phys:Wake()
    end 
    
    function ENT:ActivatePhysicsRECALC(Mod)
        self:SetModel(Mod)
        self:PhysicsInit( SOLID_VPHYSICS ) -- Initializes physics for the Entity, making it solid and interactable.
        self:SetMoveType( MOVETYPE_VPHYSICS ) -- Sets how the Entity moves, using physics.
        self:SetSolid( SOLID_VPHYSICS ) -- Makes the Entity solid, allowing for collisions.
        self:SetName("Troilite Ore")
        
        local phys = self:GetPhysicsObject() -- Retrieves the physics object of the Entity.
        phys:SetMass(100)
        phys:EnableMotion(true)
        phys:Wake()
    end
    
    --[[function ENT:OnTakeDamage(damageInfo)
        if !(damageInfo:GetAttacker():IsPlayer()) then
            return
        end
        local newEffectData = EffectData() -- Creates a new EffectData to use in util.Effect.
        newEffectData:SetOrigin(self:GetPos())
        newEffectData:SetMagnitude(100)
        newEffectData:SetScale(1)

        -- Make the explosion effect!
        util.Effect("Explosion",newEffectData)

        -- Makes the entity split apart. (The vector adds force to the gibs upwards)
        self:GibBreakServer(Vector(0,0,10))

        -- Setting this to true prevents the entity from exploding again.
        self.HasExploded = true
        
        self:Remove()
        util.BlastDamage(self,self,self:GetPos(),self.ExplosionRadius,self.ExplosionDamage)
        self:Remove()
    end]]
else
  
    ENT.PopulateEntityInfo = true
	function ENT:OnPopulateEntityInfo(container)
		local name = container:AddRow("name")
		name:SetImportant()
		name:SetText("Troilite Ore")
		name:SizeToContents()
		local description = container:AddRow("description")
		description:SetText("A chunk of course stone, with yellow lines running across its surface.")
		description:SizeToContents()
	end
end