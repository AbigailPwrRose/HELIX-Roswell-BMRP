ENT.Type = "anim"
ENT.Category = "Black Mesa: Xen Crystals"
ENT.PrintName = "Xen Crystal Sample"
ENT.Author = "Winter"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Model = "models/props/xenprops/crystal3.mdl"
ENT.bNoPersist = true

ENT.ExplosionDamage = 20
ENT.ExplosionRadius = 150

if (SERVER) then
    function ENT:Initialize()
        self:SetModel("models/props/xenprops/crystal3.mdl") -- Sets the model for the Entity.
        self:PhysicsInit( SOLID_VPHYSICS ) -- Initializes physics for the Entity, making it solid and interactable.
        self:SetMoveType( MOVETYPE_VPHYSICS ) -- Sets how the Entity moves, using physics.
        self:SetSolid( SOLID_VPHYSICS ) -- Makes the Entity solid, allowing for collisions.
        self:SetUseType( SIMPLE_USE )
        
        local phys = self:GetPhysicsObject() -- Retrieves the physics object of the Entity.
        phys:SetMass(100)
        phys:EnableMotion(true)
        phys:Wake()
    end 
  
    function ENT:Use(Client)
        if self:GetNW2Var("useCooldown",0) <= 0 then
            self:SetNW2Var("useCooldown",10)
            netstream.Start(Client,"CLV_NameXenSample", self:EntIndex())
  
        end
    end

    function ENT:Think() 
        if self:GetNW2Var("useCooldown",0) != 0 then
            self:SetNW2Var("useCooldown",math.Clamp( self:GetNW2Var("useCooldown",0) - 1, 0, 100 ))
        end
    end
  
    function ENT:RandomiseVars() 
        local modelTable = {"models/props/xenprops/crystal3.mdl","models/props/xenprops/crystal2.mdl","models/props/xenprops/crystal1.mdl","models/props/xenprops/crystal.mdl"}
        local StabRand = math.random( 25, 100 )
        local ResRand = math.random( 100, 400 )
    
        self:SetNW2Var("stability",StabRand)
        self:SetNW2Var("resonanceFreq",ResRand)
        self:SetModel(table.Random(modelTable)) -- Sets the model for the Entity.
    end
    function ENT:OnTakeDamage(damageInfo)
      self:SetNW2Var("stability",math.Round(self:GetNW2Var("stability",100)-damageInfo:GetDamage(),1))
      if self:GetNW2Var("stability",100) <= 0 then
        self:EmitSound("physics/glass/glass_largesheet_break3.wav")
        self:EmitSound("debris/beamstart4.wav")
        self:Remove()
      end
  end
  
    function ENT:SetCVars(Name,NOver,Res,Stab,Test,Anal) 
        if NOver then
            self:SetNW2Var("customName",Name)
        end
        self:SetNW2Var("stability",Stab)
        self:SetNW2Var("resonanceFreq",Res)
    
        self:SetNW2Var("Tested",Test)
        self:SetNW2Var("Analyzed",Anal)
        self.UseCooldown = 0 
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
		name:SetText("Xen Crystal Sample")
        if self:GetNW2Var("customName","") != "" then 
            name:SetText(self:GetNW2Var("customName","ErrorSuccess"))
        end
		name:SizeToContents()
		local description = container:AddRow("description")
        local DescText = ""
        if self:GetNW2Var("Tested",false) and self:GetNW2Var("Analyzed",false) then
    		DescText = "A tested Xen Crystal. It cannot be tested again, but could be used for chemistry, crafting or just kept around to look nice."
        elseif self:GetNW2Var("Tested",false) then
    		DescText = "This crystal has been tested, but not analyzed. This should not be posible!"
        elseif self:GetNW2Var("Analyzed",false) then
    		DescText = "An analyzed Xen Crystal sample, which can now be tested in the AMS with administrations approval."
        else
    		DescText = "An untested Xen Crystal sample. Its properties are unknown."
        end
        if self:GetNW2Var("Analyzed",false) then 
            DescText = DescText.."\n\nResonant Frequency: "..self:GetNW2Var("resonanceFreq",50).."\nStability: "..self:GetNW2Var("stability",100).."%"
        end
        description:SetText(DescText)
        description:SizeToContents()
	end
end