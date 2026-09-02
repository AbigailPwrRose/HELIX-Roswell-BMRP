ENT.Type = "anim"
ENT.Category = "Black Mesa - Chemistry"
ENT.PrintName = "Chemical Extractor"
ENT.Author = "Winter"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Model = "models/winter_chemistry_props/surgical_laser.mdl"
ENT.MaxVol = 200
ENT.IsChemicalSystem = true

if !(CLIENT) then
    function ENT:Initialize()
        -- Ensure code for the Server realm does not accidentally run on the Client
        self:SetModel(self.Model) -- Sets the model for the Entity.
        self:PhysicsInit( SOLID_VPHYSICS ) -- Initializes physics for the Entity, making it solid and interactable.
        self:SetMoveType( MOVETYPE_VPHYSICS ) -- Sets how the Entity moves, using physics.
        self:SetSolid( SOLID_VPHYSICS ) -- Makes the Entity solid, allowing for collisions.
        self:SetNW2Var("Processing",false)
        self:SetNW2Var("inputObj","")
        self:SetNW2Var("inputObjType")
        self.Cooldown = 10
        self.NextTime = CurTime()
        self.CookingTime = 0
        self.CookingTimed = 60
        self.StoredItemTable = {[1]="."} 
        local phys = self:GetPhysicsObject() -- Retrieves the physics object of the Entity.
        self:SetMaterial("models/sidereal_lab/surgical_laser")
        self.NewChemTable = {
            {{0,0}, false, true},
            {{0,0}, false, true},
            {{0,0}, false, true},
            {{0,0}, true, true},
        }
        self:SetNW2String("ChemTable",util.TableToJSON(self.NewChemTable))
    end 

    function ENT:Think() 
        self.Cooldown = math.Clamp(self.Cooldown-1,0,200)
        if self.NextTime == nil then
            self.NextTime = CurTime() end
        if self.CookingTime == nil then
            self.CookingTime =self.CookingTimed end
		if self.CookingTime != 0  and self.NextTime <= CurTime() then
            self.NextTime = CurTime() + 0.5
       	 	self.CookingTime = math.Clamp(self.CookingTime - 1,0,9000)
            self:SetNW2Int("ProgressToExtract",self.CookingTime)
            self:SetNW2Var("Processing",true)
            if self.CookingTime == 0 then
                EmitSound( "umojan_audio/buttons/button7.wav", self:GetPos() )
                self:SetNW2Var("Processing",false)
                self:ClearTable()
                self:EmitSound("scifi/hudobjectivecomplete.mp3", 120, 150)
            end
        end
        
        for k,v in pairs(self.NewChemTable) do 
            if (v[1][1] == 0 or v[1][2] <= 0)and v[1]!={0,0} then 
                self.NewChemTable[k][1] = {0,0}
            end
        end
        self:SetNW2String("ChemTable",util.TableToJSON(self.NewChemTable))

        if (self.NewChemTable[4][1][1] != 0 ) and (ix.chemistry.List[self.NewChemTable[4][1][1]]) then
            self.StoredItemTable = {[1]="."}
            self.StoredItemTable[1] = "Chemical"
        end
        
        if self.StoredItemTable[1] != "." then
            if self.StoredItemTable[1] == "Item" then
                if ix.item.instances[self.StoredItemTable[2]] == nil then
                    self.StoredItemTable = {[1]="."}
                else
                    self:SetNW2Var("inputObj",ix.item.instances[self.StoredItemTable[2]]:GetName())
                end
            elseif self.StoredItemTable[1] == "GeneralEntity" then
                self:SetNW2Var("inputObj",self.StoredItemTable[3])
            end
        else
            self:SetNW2Var("inputObj","")
        end
    end 

    function ENT:StartTouch(Toucher)
        if self.Cooldown == 0 and self:GetNW2Var("Processing",false)== false and IsValid(Toucher) then
            self.Cooldown = self.Cooldown + 5
            if Toucher:GetClass() == "ix_item" and self.StoredItemTable[1] == "." then
                local ItemID = ix.item.instances[Toucher.ixItemID]
                local ItemTable = Toucher:GetItemTable()
                local ItemType = ItemTable["uniqueID"]
                if (ix.chemistry.GrindList[ItemType]) then 
                    table.Empty(self.StoredItemTable)
                    self.StoredItemTable = {[1] = "Item", [2] = Toucher.ixItemID ,[3] = ItemTable}
                    Toucher:Remove()
                end
            elseif ix.chemistry.GrindEntityList[Toucher:GetClass()] and self.StoredItemTable[1] == "." then
				
                table.Empty(self.StoredItemTable)
                self.StoredItemTable = {[1] = "GeneralEntity", [2] = Toucher:GetClass(), [3] = Toucher.PrintName, [4] = Toucher:GetModel()}
                Toucher:Remove()

            end
        end
    end

    function ENT:Use(Client)
        if self.Cooldown <= 0 and self:GetNW2Var("Processing",false)== false then 
            self.Cooldown = self.Cooldown + 10
            if self.NewChemTable[1][1][1] == 0 and self.StoredItemTable[1] != "." then
                if self.StoredItemTable[1] == "Chemical" and self.NewChemTable[4][1][2] == 200 and ix.chemistry.Refine[self.NewChemTable[4][1][1]] then
                    self:EmitSound("scifi/hudobjectivecomplete.mp3", 80, 150)
                    self:SetNW2Var("Processing",true)
                    local RandMax = 0
                    for k,v in pairs(ix.chemistry.Refine[self.NewChemTable[4][1][1]]) do
                        RandMax = RandMax + v[2]
                    end
                    local Result = math.random(0,RandMax)
                    local ChemResult = 0
                    RandMax = 0
                    for k,v in pairs(ix.chemistry.Refine[self.NewChemTable[4][1][1]]) do
                        if Result > RandMax or Result == RandMax then
                            ChemResult = v[1]
                            ChemVol = v[3]
                        end
                        RandMax = RandMax + v[2]
                    end
                    
                    self.CookingTime = self.CookingTimed
                    self.NewChemTable[1][1][1] = ChemResult
                    self.NewChemTable[1][1][2] = ChemVol
                    self.NewChemTable[4][1][1] = 0
                    self.NewChemTable[4][1][2] = 0
                    return true
                elseif self.StoredItemTable[1] == "Item" and ix.chemistry.GrindList[self.StoredItemTable[3]["uniqueID"]] then
                    self:EmitSound("scifi/hudobjectivecomplete.mp3", 80, 150)
                    self:SetNW2Var("Processing",true)
                    local RandMax = 0
                    for k,v in pairs(ix.chemistry.GrindList[self.StoredItemTable[3]["uniqueID"]]) do
                        RandMax = RandMax + v[2]
                    end
                    local Result = math.random(0,RandMax)
                    local ChemResult = 0
                    RandMax = 0
                    for k,v in pairs(ix.chemistry.GrindList[self.StoredItemTable[3]["uniqueID"]]) do
                        if Result > RandMax or Result == RandMax then
                            ChemResult = v[1]
                            ChemVol = v[3]
                        end
                        RandMax = RandMax + v[2]
                    end
                    
                    self.CookingTime = self.CookingTimed
                    self.NewChemTable[1][1] = {ChemResult,ChemVol}
                    return true
                
                elseif self.StoredItemTable[1] == "GeneralEntity" and ix.chemistry.GrindEntityList[self.StoredItemTable[2]] then
                    self:EmitSound("scifi/hudobjectivecomplete.mp3", 80, 150)
                    self:SetNW2Var("Processing",true)
                    local RandMax = 0
                    for k,v in pairs(ix.chemistry.GrindEntityList[self.StoredItemTable[2]]) do
                        RandMax = RandMax + v[2]
                    end
                    local Result = math.random(0,RandMax)
                    local ChemResult = 0
                    RandMax = 0
                    for k,v in pairs(ix.chemistry.GrindEntityList[self.StoredItemTable[2]]) do
                        if Result > RandMax or Result == RandMax then
                            ChemResult = v[1]
                            ChemVol = v[3]
                        end
                        RandMax = RandMax + v[2]
                    end
                    
                    self.CookingTime = self.CookingTimed
                    self.NewChemTable[1][1] = {ChemResult,ChemVol}
                    return true
                end
            end
            self:EmitSound("scifi/hudgpsnotification2.mp3", 80, 150)
        end
    end

    function ENT:OnTakeDamage(DmgInfo)
        if (DmgInfo:GetAttacker():IsPlayer() and !(self:GetNW2Var("Processing",false))) and !(self.StoredItemTable[1] == "GeneralEntity") then
            self:DoEject()
        end
    end

    function ENT:OnRemove()
        if !(self.StoredItemTable[1] == "GeneralEntity") then
            self:DoEject() 
        end
    end
    
    function ENT:ClearTable()
        table.Empty(self.StoredItemTable)
        self.StoredItemTable = {[1]="."}
        self:SetNW2Var("inputObj","")
    end

    function ENT:DoEject()
        if self.StoredItemTable[1] == "Item" then 
            local position = self:GetPos() + self:GetUp() * 55 + self:GetForward() * 0 + self:GetRight() * 0
            ix.item.instances[self.StoredItemTable[2]]:Spawn(position,Angle(0,0,0))
        elseif self.StoredItemTable[1] == "GeneralEntity" then 
            local position = self:GetPos() + self:GetUp() * 55 + self:GetForward() * 0 + self:GetRight() * -30

            local ent = ents.Create(self.StoredItemTable[2])
            ent:SetPos(position) 
            ent:SetAngles(Angle(0.0, 90.0, 0.0))
            ent:SetModel(self.StoredItemTable[4])
            ent:PhysicsInit( SOLID_VPHYSICS ) -- Initializes physics for the Entity, making it solid and interactable.
            ent:SetMoveType( MOVETYPE_VPHYSICS ) -- Sets how the Entity moves, using physics.
            ent:SetSolid( SOLID_VPHYSICS ) -- Makes the Entity solid, allowing for collisions.

            local phys = ent:GetPhysicsObject() -- Retrieves the physics object of the Entity.
            phys:SetMass(100)
            phys:EnableMotion(true)
            phys:Wake()
            
            if self.StoredItemTable[2] != "echiruscrystal_shard" then
                ent:Spawn()
            end
        end
        self:ClearTable()
    end

end

if not CLIENT then return end
-- Client-side draw function for the Entity
function ENT:DrawWaitTime( pos, ang, scale, text, flipView )
	if ( flipView ) then
		-- Flip the angle 180 degrees around the UP axis
		ang:RotateAroundAxis( Vector( 0, 0, 1 ), 180 )
	end

	cam.Start3D2D( pos, ang, scale )
		-- Actually draw the text. Customize this to your liking.
		draw.DrawText( text, "Default", 0, 0, Color( 220, 220, 220, 255 ), TEXT_ALIGN_CENTER )
	cam.End3D2D()
end

function ENT:Draw()
    self:DrawModel()
    local ChemTable = util.JSONToTable(self:GetNW2String("ChemTable"))
    local glowMaterial = ix.util.GetMaterial("effects/blueflare1")
    local position = self:GetPos() + self:GetUp() * 45 + self:GetForward() *9 + self:GetRight() * -18

    render.SetMaterial(glowMaterial)
    if self:GetNW2Var("Processing",false) == true then
        render.DrawSprite(position, 10, 10,  Color( 255, 0, 0 ))
    elseif ChemTable[1][1][1] != 0 and ChemTable[1][1][2] != 0 then
        render.DrawSprite(position, 10, 10,  Color( 0, 255, 0 ))
    else
        render.DrawSprite(position, 10, 10,  Color( 0, 0, 255 ))
    end
    
    
	local Prog = self:GetNW2Int("ProgressToExtract",0)
    
	if Prog > 0 then
        
        local mins, maxs = self:GetModelBounds()
        local pos = self:GetPos() + Vector( 0, 0, maxs.z + 7)

        local ang = Angle( 0, LocalPlayer():LocalEyeAngles()[2]-90, 90 )

        self:DrawWaitTime( pos, ang, 0.4, tostring(Prog), false )
    end
end

ENT.PopulateEntityInfo = true
function ENT:OnPopulateEntityInfo(container)
    local ChemTable = util.JSONToTable(self:GetNW2String("ChemTable"))
    local name = container:AddRow("name")
    name:SetImportant()
    name:SetText("Chemical Extractor")
    name:SetBackgroundColor(Color(230,230,230))
    name:SizeToContents()
    local description = container:AddRow("description")
    description:SetText("A complex aparatus that extracts raw chemicals from input items or chemicals.")
    description:SizeToContents()
    if self:GetNW2Var("Processing",false) != true then 
        if (self:GetNW2Var("inputObj","") != "" and self:GetNW2Var("inputObj","") != "Chemical") then
            local input = container:AddRow("Contains")
            input:SetBackgroundColor(Color(220,220,220,190))
            input:SetFont("DermaDefault")
            input:SetText("This extractor contains ".. self:GetNW2Var("inputObj",0) )
            input:SizeToContents()
        end
        if (ChemTable[1][1][1] != 0 ) and (ix.chemistry.List[ChemTable[1][1][1]]) then
            local vol1 = container:AddRow("Contains")
            vol1:SetBackgroundColor(Color(200,200,200,190))
            vol1:SetFont("DermaDefault")
            vol1:SetText("This extractor contains ".. ChemTable[1][1][2] .."ml of "..ix.chemistry.List[ChemTable[1][1][1]][1].." in Output 1")
            vol1:SizeToContents() 
        end
        if (ChemTable[2][1][1] != 0 ) and (ix.chemistry.List[ChemTable[2][1][1]]) then
            local vol2 = container:AddRow("Contains")
            vol2:SetBackgroundColor(Color(200,200,200,190))
            vol2:SetFont("DermaDefault")
            vol2:SetText("This extractor contains ".. ChemTable[2][1][2] .."ml of "..ix.chemistry.List[ChemTable[2][1][1]][1].." in Output 2")
            vol2:SizeToContents() 
        end
        if (ChemTable[3][1][1] != 0 ) and (ix.chemistry.List[ChemTable[3][1][1]]) then
            local vol3 = container:AddRow("Contains")
            vol3:SetBackgroundColor(Color(200,200,200,190))
            vol3:SetFont("DermaDefault")
            vol3:SetText("This extractor contains ".. ChemTable[3][1][2] .."ml of "..ix.chemistry.List[ChemTable[3][1][1]][1].." in Output 3")
            vol3:SizeToContents() 
        end
        if (ChemTable[4][1][1] != 0 ) and (ix.chemistry.List[ChemTable[4][1][1]]) then
            local chemInp = container:AddRow("Contains")
            chemInp:SetBackgroundColor(Color(200,200,200,190))
            chemInp:SetFont("DermaDefault")
            chemInp:SetText("This extractor contains ".. ChemTable[4][1][2] .."ml of "..ix.chemistry.List[ChemTable[4][1][1]][1].." in its chemical input")
            chemInp:SizeToContents() 
        end
    else
        local vol = container:AddRow("Contains")
        vol:SetImportant()
        vol:SetBackgroundColor(Color(255,255,255,220))
        vol:SetFont("CreditsText") 
        vol:SetText("This extractor is processing...") 
        vol:SizeToContents() 
    end
end