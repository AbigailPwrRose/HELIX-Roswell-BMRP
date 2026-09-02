ENT.Type = "anim"
ENT.Category = "Black Mesa - Chemistry"
ENT.PrintName = "Chemical Mixer"
ENT.Author = "Winter"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Model = "models/props_lab/sterilizer.mdl"
ENT.MaxVol = 200
ENT.IsChemicalSystem = true

function ENT:Initialize()
  -- Ensure code for the Server realm does not accidentally run on the Client
  if !(CLIENT) then
    self:SetModel(self.Model) -- Sets the model for the Entity.
    self:PhysicsInit( SOLID_VPHYSICS ) -- Initializes physics for the Entity, making it solid and interactable.
    self:SetMoveType( MOVETYPE_VPHYSICS ) -- Sets how the Entity moves, using physics.
    self:SetSolid( SOLID_VPHYSICS ) -- Makes the Entity solid, allowing for collisions.
    self.Cooldown = 10
    self:SetNW2Var("Mode", 0) 
    self:SetNW2Var("Processing",false) 
    self:SetNW2Var("Chemical",0)
    self:SetNW2Var("Volume",0)
    self:SetMaterial("models/sidereal_lab/sterilizer")
    local phys = self:GetPhysicsObject() -- Retrieves the physics object of the Entity.

    -- ChemID, ChemVolume, CanAdd, CanTake
    self.NewChemTable = {
      {{0,0}, false, true},
      {{0,0}, true, true},
      {{0,0}, true, true},
      {{0,0}, true, true},
      {{0,0}, true, true},
    }
    self:SetNW2String("ChemTable",util.TableToJSON(self.NewChemTable)) 
  end
end 

function ENT:Think() 
  if not CLIENT then
    self.Cooldown = math.Clamp(self.Cooldown-1,0,60)

    for k,v in pairs(self.NewChemTable) do 
      if (v[1][1] == 0 or v[1][2] <= 0)and v[1]!={0,0} then 
        self.NewChemTable[k][1] = {0,0}
      end
    end

    self:SetNW2String("ChemTable",util.TableToJSON(self.NewChemTable))
  end
end

function ENT:Use(Client)
  if self.Cooldown <= 0 and self:GetNW2Var("Processing",false)  != true and !(CLIENT) then 
    self.Cooldown = self.Cooldown + 10
    local ChemTable = self.NewChemTable
    if Client:KeyDown(8192) then
      if self:GetNW2Var("Mode", 0) == 0 then
        self:SetNW2Var("Mode", 1) 
      else 
        self:SetNW2Var("Mode", 0) 
      end
      self:EmitSound("scifi/hudnewitemimpact.mp3", 80, 150)
    elseif ChemTable[1][1][1] == 0 then
      local InputChemTable = {}
      local RecipeID = nil
      for k,v in pairs(ChemTable) do 
        if v[2] == true and v[1][1] != 0 and v[1][2] > 0 then 
          table.Add(InputChemTable,{{v[1][1],v[1][2]}})
        end
      end
      if self:GetNW2Var("Mode", 0) != 1 then
        -- Check for if the given chemicals match to any of the defined chemical mixtures
        for k,z in pairs(ix.chemistry.MixingList) do 
          local CanRecipe = ix.chemistry.CheckReaction(k,InputChemTable,0)
          if CanRecipe then
            RecipeID = k
          end
        end
        -- Now it check
        if RecipeID != nil then
          local RecipeTable = ix.chemistry.MixingList[RecipeID]
          local EntityID = self:EntIndex()
          self:SetNW2Var("Processing",true)
          self:EmitSound("scifi/hudobjectivecomplete.mp3", 80, 150)
          timer.Create("ChemMixer_"..tostring(EntityID), ix.chemistry.MixingList[RecipeID][4], 1, function()
            self:SetNW2Var("Processing",false) 
            if Entity(EntityID):GetVar("ClassName") != "chemistry_station" then
              return false
            else
              self.NewChemTable[1][1] = {RecipeTable[2],RecipeTable[3]}
              for k,v in pairs(ChemTable) do 
                if v[2] == true then 
                  self.NewChemTable[k][1] = {0,0}
                end
              end
            end
            self:EmitSound("scifi/hudobjectivecomplete.mp3", 80, 150)
            timer.Remove("ChemMixer_"..RecipeID.."_"..EntityID)
          end )
        else
          self:EmitSound("scifi/hudgpsnotification2.mp3", 80, 150)
        end
      elseif self:GetNW2Var("Mode", 0) == 1 then
        -- Check for if the given chemicals match to any of the defined chemical mixtures
        for k,z in pairs(ix.chemistry.ItemCraft) do 
          local CanRecipe = ix.chemistry.CheckReaction(k,InputChemTable,1)
          if CanRecipe then
            RecipeID = k
          end
        end
        -- Now it check
        if RecipeID != nil then
          local RecipeTable = ix.chemistry.ItemCraft[RecipeID]
          local EntityID = self:EntIndex()
          self:SetNW2Var("Processing",true)
          self:EmitSound("scifi/hudobjectivecomplete.mp3", 80, 150)
          timer.Create("ChemMixer_"..tostring(EntityID), ix.chemistry.ItemCraft[RecipeID][4], 1, function()
            self:SetNW2Var("Processing",false) 
            if Entity(EntityID):GetVar("ClassName") != "chemistry_station" then
              return false
            else
              local SpawnPos = self:GetPos()+Vector(0,0,20)
              for k,v in pairs(ChemTable) do 
                if v[2] == true then 
                  self.NewChemTable[k][1] = {0,0}
                end
              end
              timer.Create("ChemMixer_"..tostring(EntityID).."_Spawns",1,ix.chemistry.ItemCraft[RecipeID][3], function()
              ix.item.Spawn(ix.chemistry.ItemCraft[RecipeID][2], SpawnPos, nil, Angle(0,0,0))end)
            end
            self:EmitSound("scifi/hudobjectivecomplete.mp3", 80, 150)
            timer.Remove("ChemMixer_"..RecipeID.."_"..EntityID)
          end )
        else
          self:EmitSound("scifi/hudgpsnotification2.mp3", 80, 150)
        end
      else 
        self:EmitSound("scifi/hudgpsnotification2.mp3", 80, 150)
      end
    else
      self:EmitSound("scifi/hudgpsnotification2.mp3", 80, 150)
      Client:ChatNotify("This mixer still has chemicals in its output")
    end
    self:EmitSound("scifi/hudgpsnotification2.mp3", 80, 150)
  end
end

if not CLIENT then return end
function ENT:Draw()
  local ChemTable = util.JSONToTable(self:GetNW2String("ChemTable"))
  local glowMaterial = ix.util.GetMaterial("effects/softglow")
  self:DrawModel() 
  local position = self:GetPos() + self:GetUp() * 5.2 + self:GetForward() *4.2 + self:GetRight() * -6

  render.SetMaterial(glowMaterial)
  if self:GetNW2Var("Processing",false) == true then
    render.DrawSprite(position, 10, 10,  Color( 255, 0, 0 ))
  elseif ChemTable[1][1][1] != 0 and ChemTable[1][1][2] != 0 then
    render.DrawSprite(position, 10, 10,  Color( 0, 255, 0 ))
  else
    if self:GetNW2Var("Mode", 0) != 1 then
      render.DrawSprite(position, 10, 10,  Color( 0, 0, 255 ))
    else 
      render.DrawSprite(position, 10, 10,  Color( 0, 255, 255 )) 
    end
  end
end
ENT.PopulateEntityInfo = true
function ENT:OnPopulateEntityInfo(container)
  local ChemTable = util.JSONToTable(self:GetNW2String("ChemTable"))
  local name = container:AddRow("name")
	name:SetImportant()
	name:SetText("Chemical Mixer")
  name:SetBackgroundColor(Color(230,230,230))
	name:SizeToContents()
	local description = container:AddRow("description")
  if self:GetNW2Var("Mode",0) != 1 then
    description:SetText("A fancy new device that mixes and combines chemicals.\nIts currently set to mix chemicals into new ones.") 
  else
	  description:SetText("A fancy new device that mixes and combines chemicals.\nIts currently set to combine chemicals into items.") 
  end
	description:SizeToContents()
  local RowColor = Color(255,255,255,200)
  for k,v in pairs(ChemTable) do 
    if v[2] == false and v[1][1] != 0 then
      local Output = container:AddRow("Contains")
      Output:SetBackgroundColor(RowColor)
      Output:SetFont("DermaDefault")
      Output:SetImportant()
      Output:SetBackgroundColor(Color(255,255,255,220))
      Output:SetFont("CreditsText") 
      Output:SetText("This mixer contains ".. v[1][2] .."ml of "..ix.chemistry.List[v[1][1]][1].." in its output")
      Output:SizeToContents()
    end
  end
  if self:GetNW2Var("Processing",false) then
    local Prosessing = container:AddRow("Contains")
    Prosessing:SetBackgroundColor(RowColor)
    Prosessing:SetFont("DermaDefault")
    Prosessing:SetImportant()
    Prosessing:SetBackgroundColor(Color(255,255,255,220))
    Prosessing:SetFont("CreditsText") 
    Prosessing:SetText("This mixer is processing...")
    Prosessing:SizeToContents()
  end
  local SlotN = 0
  for k,v in pairs(ChemTable) do 
    if v[2] == true then
      SlotN = SlotN + 1
      local Input = container:AddRow("Contains")
      Input:SetBackgroundColor(RowColor)
      Input:SetFont("DermaDefault")
      if v[1][1] == 0 then 
        Input:SetText("This mixer has nothing in slot "..SlotN) 
      else
        Input:SetText("Slot "..SlotN.." has "..v[1][2].."ml of "..ix.chemistry.List[v[1][1]][1])
      end
      Input:SizeToContents()
    end
  end
end