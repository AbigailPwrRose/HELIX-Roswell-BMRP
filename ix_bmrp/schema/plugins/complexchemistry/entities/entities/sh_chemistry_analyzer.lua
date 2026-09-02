ENT.Type = "anim"
ENT.Category = "Black Mesa - Chemistry"
ENT.PrintName = "Chemical Analyzer"
ENT.Author = "Winter"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Model = "models/winter_chemistry_props/temmicroscope.mdl"
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
        local phys = self:GetPhysicsObject() -- Retrieves the physics object of the Entity.
        -- Chemical ID & Volume | CanAdd | CanTake
        self.NewChemTable = {
            {{0,0}, true, true},
        }
        self:SetNW2String("ChemTable",util.TableToJSON(self.NewChemTable))
    end
end 

function ENT:Use(Client)
    if self.Cooldown <= 0 and self:GetNW2Var("Processing",false)  != true and !(CLIENT) then 
        self.Cooldown = self.Cooldown + 10
        local ChemTable = self.NewChemTable
        if ChemTable[1][1][1] != 0 then
            local Chem = ChemTable[1][1][1]
            local Vol = ChemTable[1][1][2]
            if Vol < 100 then
                Client:ChatNotify("There isn't enough "..ix.chemistry.List[Chem][1].." to analyze.")
                return
            end
            local Text = ""
            Text = Text.."                   Analysis of "..ix.chemistry.List[Chem][1].."\n\n"
            Text = Text..ix.chemistry.List[Chem][5].."\n\n"
            local RefineList = ""
            if ix.chemistry.Refine[Chem] then
                local v = ix.chemistry.Refine[Chem]
                local InRecipe = false
                local Displ = ""
                for l,x in pairs(v) do 
                    if Displ == "" then 
                        Displ = Displ..""..x[2].."% - "..x[3].."ml of "..ix.chemistry.List[x[1]][1].."\n"
                    else 
                        Displ = Displ..""..x[2].."% - "..x[3].."ml of "..ix.chemistry.List[x[1]][1].."\n"
                    end
                end
                RefineList = RefineList..Displ.."\n"
            end
            if RefineList != "" then 
                RefineList = "---Extracts into Chemicals:\n\n"..RefineList.."\n"
            end
            local ExtChemList = ""
            for k,v in pairs(ix.chemistry.Refine) do 
                local InRecipe = false
                local Displ = ""
                for l,x in pairs(v) do 
                    if x[1] == Chem then
                        ExtChemList = ExtChemList..ix.chemistry.List[k][1].."\n"
                    end
                end
            end
            for k,v in pairs(ix.chemistry.GrindList) do 
                local InRecipe = false
                local Displ = ""
                for l,x in pairs(v) do 
                    if x[1] == Chem then
                        ExtChemList = ExtChemList..ix.item.Get(k):GetName().."\n"
                    end
                end
            end
            if ExtChemList != "" then 
                ExtChemList = "---Can be extracted from:\n\n"..ExtChemList.."\n"
            end
            
            local ExtractItems = ""
            for k,v in pairs(ix.chemistry.GrindEntityList) do 
                for l,x in pairs(v) do 
                    if x[1] == Chem then
                        ExtractItems = ExtractItems..scripted_ents.Get(k).PrintName.."\n"
                    end
                end
            end
            if ExtractItems != "" then 
                ExtractItems = "---Can be extracted from objects:\n\n"..ExtractItems.."\n"
            end
            
            local MixChemList = ""
            for k,v in pairs(ix.chemistry.MixingList) do 
                local InRecipe = false
                local Displ = ""
                for l,x in pairs(ix.chemistry.MixingList[k][1]) do 
                    if x[1] == Chem then
                        InRecipe = true
                    end
                end
                if InRecipe == true then 
                    for l,x in pairs(ix.chemistry.MixingList[k][1]) do 
                        if Displ == "" then 
                            Displ = Displ.." "..ix.chemistry.List[x[1]][1].."["..x[2].."ml]"
                        else 
                            Displ = Displ.." + "..ix.chemistry.List[x[1]][1].."["..x[2].."ml]"
                        end
                    end
                    MixChemList = MixChemList..ix.chemistry.List[v[2]][1].." = "..Displ.."\n"
                end
            end
            if MixChemList != "" then 
                MixChemList = "---Possible Mixtures:\n\n"..MixChemList.."\n"
            end
            local CraftList = ""
            for k,v in pairs(ix.chemistry.ItemCraft) do 
                local InRecipe = false
                local Displ = ""
                for l,x in pairs(v[1]) do 
                    if x[1] == Chem then
                        InRecipe = true
                    end
                end
                if InRecipe == true then 
                    for l,x in pairs(v[1]) do 
                        if Displ == "" then 
                            Displ = Displ..ix.chemistry.List[x[1]][1].."["..x[2].."ml]"
                        else 
                            Displ = Displ.." + "..ix.chemistry.List[x[1]][1].."["..x[2].."ml]"
                        end
                    end
                    CraftList = CraftList..ix.item.Get(v[2]):GetName().." = "..Displ.."\n"
                end
            end
            if CraftList != "" then 
                CraftList = "---Possible Crafts:\n\n"..CraftList.."\n"
            end
            local Text = Text..RefineList..ExtractItems..ExtChemList..MixChemList..CraftList
            netstream.Start(Client, "Chemistry_ReadOut_Dyna", Text)
        end
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
if not CLIENT then return end
-- Client-side draw function for the Entity
ENT.PopulateEntityInfo = true
function ENT:OnPopulateEntityInfo(container)
    local ChemTable = util.JSONToTable(self:GetNW2String("ChemTable"))
    local name = container:AddRow("name")
    name:SetImportant()
    name:SetText("Chemical Analyzer")
    name:SetBackgroundColor(Color(230,230,230))
    name:SizeToContents()
    local description = container:AddRow("description")
    description:SetText("A complex aparatus that can analze unknown chemicals, and give a rough idea of its effects.")
    description:SizeToContents()
    local vol = container:AddRow("Contains")
    vol:SetBackgroundColor(Color(200,200,200,190))
    vol:SetFont("DermaDefault")
    if (ChemTable[1][1][1]!= 0) and (ix.chemistry.List[ChemTable[1][1][1]]) then
        vol:SetText("This analyzer contains ".. ChemTable[1][1][2] .."ml of "..ix.chemistry.List[ChemTable[1][1][1]][1])
    else
        vol:SetText("This analyzer is empty") 
    end
    vol:SizeToContents()
end