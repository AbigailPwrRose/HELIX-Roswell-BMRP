ENT.Type = "anim"
ENT.Category = "Black Mesa - Chemistry"
ENT.PrintName = "Chemical Beaker"
ENT.Author = "Winter"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Model = "models/props_lab/beaker01a.mdl"
ENT.PhysModel = "models/props_c17/canister02a.mdl"
ENT.MaxVol = 400
ENT.IsChemicalSystem = true

function ENT:Initialize()
  -- Ensure code for the Server realm does not accidentally run on the Client
  if not CLIENT then
    self:SetModel(self.Model) -- Sets the model for the Entity.
    self:PhysicsInit( SOLID_VPHYSICS ) -- Initializes physics for the Entity, making it solid and interactable.
    self:SetMoveType( MOVETYPE_VPHYSICS ) -- Sets how the Entity moves, using physics.
    self:SetSolid( SOLID_VPHYSICS ) -- Makes the Entity solid, allowing for collisions.
    self.Cooldown = 10
    local phys = self:GetPhysicsObject() -- Retrieves the physics object of the Entity. 
    self.NewChemTable = {
    {{0,0}, true, true},
    }
    self:SetNW2String("ChemTable",util.TableToJSON(self.NewChemTable))
  end
end 

function ENT:Think() 
  if !(CLIENT) then
    for k,v in pairs(self.NewChemTable) do 
      if (v[1][1] == 0 or v[1][2] <= 0)and v[1]!={0,0} then 
        self.NewChemTable[k][1] = {0,0}
      end
    end
    self:SetNW2String("ChemTable",util.TableToJSON(self.NewChemTable))
    
    if (self.NewChemTable[1][1][1] != 0) and (ix.chemistry.List[self.NewChemTable[1][1][1]]) then
      self:SetColor(ix.chemistry.List[self.NewChemTable[1][1][1]][3])
    else
      self:SetColor(Color(255,255,255,255))
    end
  end
end

if not CLIENT then return end
-- Client-side draw function for the Entity
function ENT:Draw()
    self:DrawModel() -- Draws the model of the Entity. This function is called every frame.
end 
ENT.PopulateEntityInfo = true
function ENT:OnPopulateEntityInfo(container)
  local ChemTable = util.JSONToTable(self:GetNW2String("ChemTable"))
  local name = container:AddRow("name")
	name:SetImportant()
	name:SetText("Beaker")
  if (ChemTable[1][1][1] != 0) and (ix.chemistry.List[ChemTable[1][1][1]]) then
    name:SetText("Beaker of "..ix.chemistry.List[ChemTable[1][1][1]][1])
  end
  name:SetBackgroundColor(Color(230,230,230))
	name:SizeToContents()
	local description = container:AddRow("description")
	description:SetText("A beaker, capable of holding 400ml of chemicals.")
	description:SizeToContents()
  local vol = container:AddRow("Contains")
  vol:SetBackgroundColor(Color(200,200,200,190))
  vol:SetFont("DermaDefault")
    if (ChemTable[1][1][1] != 0 ) and (ix.chemistry.List[ChemTable[1][1][1]]) then
      vol:SetText("This beaker contains ".. ChemTable[1][1][2] .."ml of "..ix.chemistry.List[ChemTable[1][1][1]][1])
    else
      vol:SetText("This beaker is empty") 
    end
  vol:SizeToContents()
end