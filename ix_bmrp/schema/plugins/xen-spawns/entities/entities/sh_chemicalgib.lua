ENT.Type = "anim"
ENT.Category = "Black Mesa - Chemistry"
ENT.PrintName = "Chemical Gib"
ENT.Author = "Winter"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Model = "models/vj_hlr/gibs/agib1.mdl"
ENT.MaxVol = 200
ENT.IsChemicalSystem = true

if (SERVER) then
  function ENT:Initialize()
    self:SetModel(self.Model) -- Sets the model for the Entity.
    self:PhysicsInit( SOLID_VPHYSICS ) -- Initializes physics for the Entity, making it solid and interactable.
    self:SetMoveType( MOVETYPE_VPHYSICS ) -- Sets how the Entity moves, using physics.
    self:SetSolid( SOLID_VPHYSICS ) -- Makes the Entity solid, allowing for collisions.
    self.Cooldown = 5
    self.Lifespan = 300
    self:PhysWake()
    local phys = self:GetPhysicsObject() -- Retrieves the physics object of the Entity.
    -- Chemical ID & Volume | CanAdd | CanTake
    self.NewChemTable = {
        {{0,0}, false, true},
    }
    self:SetNW2Var("Processing",false) 
    self:SetNW2String("ChemTable",util.TableToJSON(self.NewChemTable))
  end 

  function ENT:SetOrigin(typer)
    if typer == 0 then
      self:SetModel("models/vj_hlr/gibs/agib1.mdl")
      self.NewChemTable[1][1][1] = 9
      self.NewChemTable[1][1][2] = 100
    elseif typer == 1 then
      self:SetModel("models/vj_hlr/gibs/flesh2.mdl")
      self:SetPos(self:GetPos()-Vector(0,0,-35))
      self.NewChemTable[1][1][1] = 12
      self.NewChemTable[1][1][2] = 100
    elseif typer == 2 then
      self:SetModel("models/vj_hlr/gibs/agrunt_gib.mdl")
      self.NewChemTable[1][1][1] = 11
      self.NewChemTable[1][1][2] = 100
    elseif typer == 3 then
      self:SetModel("models/vj_hlr/gibs/flesh2.mdl")
      self.NewChemTable[1][1][1] = 2
      self.NewChemTable[1][1][2] = 100
    elseif typer == 4 then
      self:SetModel("models/vj_hlr/gibs/agib1.mdl")
      self.NewChemTable[1][1][1] = 10
      self.NewChemTable[1][1][2] = 100
    end
    self:SetNW2String("ChemTable",util.TableToJSON(self.NewChemTable))
  end
  
  function ENT:OnChemicalsTake()
    self:Remove()
  end

  function ENT:Think()
    self.Lifespan = self.Lifespan - 1
    if self.Lifespan <= 0 then 
      self:Remove()
    end
    self:NextThink( CurTime() + 1 )
    return true 
  end
else
    
    ENT.PopulateEntityInfo = true
	function ENT:OnPopulateEntityInfo(container)
		local name = container:AddRow("name")
		name:SetImportant()
		name:SetText("Xen Gib")
		name:SizeToContents()
		local description = container:AddRow("description")
		description:SetText("A gib from xen wildlife. Contains chemicals which can be extracted with a flask.")
		description:SizeToContents()
	end
end