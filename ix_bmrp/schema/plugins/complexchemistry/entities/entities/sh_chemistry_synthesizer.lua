ENT.Type = "anim"
ENT.Category = "Black Mesa - Chemistry"
ENT.PrintName = "Chemical Requester"
ENT.Author = "Winter"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Model = "models/props_lab/reciever_cart.mdl"
ENT.MaxVol = 400
ENT.IsSynthesiser = true
ENT.IsChemicalSystem = true
ENT.CanSynthList = {
    {1,400,5},
    {21,200,10},
    {22,50,25},
    {23,50,25},
    {26,200,20},
    {27,200,20},
    {28,200,20},
    {29,200,20},
    {30,200,20},
    {31,200,20},
    {41,100,25},
    {42,200,20},
    {44,100,36},
    {49,200,25},
}

-- Ensure code for the Server realm does not accidentally run on the Client
if !(CLIENT) then
    function ENT:Initialize()
        self:SetModel(self.Model) -- Sets the model for the Entity.
        self:PhysicsInit( SOLID_VPHYSICS ) -- Initializes physics for the Entity, making it solid and interactable.
        self:SetMoveType( MOVETYPE_VPHYSICS ) -- Sets how the Entity moves, using physics.
        self:SetSolid( SOLID_VPHYSICS ) -- Makes the Entity solid, allowing for collisions.
        self.Cooldown = 10
        self.ProcessTime = 100
        self.Queued = ""
        local phys = self:GetPhysicsObject() -- Retrieves the physics object of the Entity.
        -- Chemical ID & Volume | CanAdd | CanTake
        self.NewChemTable = {
            {{0,0}, false, true},
        }
        
        self.Processing = 0
        self:SetNW2String("ChemTable",util.TableToJSON(self.NewChemTable))
    end 

    function ENT:Use(Client)
        if self.Cooldown <= 0 and self.Processing == 0 then 
            if !(ix.config.Get("IXW_CanUseRequester", true)) then 
                self.Cooldown = self.Cooldown + 2
                Client:ChatNotify("This is not available right now.")
                return
            end
            self.Cooldown = self.Cooldown + 10
            local ChemTable = self.NewChemTable
            if ChemTable[1][1][1] == 0 then
                netstream.Start(Client, "Chemistry_SynthMenu", util.TableToJSON(self.CanSynthList), self:EntIndex())
            else
                Client:ChatNotify("Synthesizer must be empty to function.")
                return
            end
        end 
    end
    
    function ENT:Think() 
        self.Cooldown = math.Clamp(self.Cooldown-1,0,60)
		if self.Processing != 0 then
       	 	self.Processing = math.Clamp(self.Processing-1,0,9000)
            self:SetNW2Int("ProgressToSynth",self.Processing)
            self:SetNW2Var("Processing",true)
            if self.Processing == 0 then
                EmitSound( "umojan_audio/buttons/button7.wav", self:GetPos() )
                self:SetNW2Var("Processing",false)
                local NewTable = util.JSONToTable(self.Queued)
                self.NewChemTable[1][1][1] = NewTable[1]
                self.NewChemTable[1][1][2] = NewTable[2]
            end
        end
        for k,v in pairs(self.NewChemTable) do 
            if (v[1][1] == 0 or v[1][2] <= 0) and v[1]!={0,0} then 
                self.NewChemTable[k][1] = {0,0}
            end	
        end

        self:SetNW2String("ChemTable",util.TableToJSON(self.NewChemTable))
    end
    
    function ENT:BeginSynthesis(CT)
        self.Processing = self.ProcessTime
        self.Queued = CT
    end
end

if not CLIENT then return end
-- Client-side draw function for the Entity
ENT.PopulateEntityInfo = true

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
function ENT:Draw(flagss)
	self:DrawModel(flags)

	local Prog = self:GetNW2Int("ProgressToSynth",0)
    
	if Prog > 0 then
        
        local mins, maxs = self:GetModelBounds()
        local pos = self:GetPos() + Vector( 0, 0, maxs.z + 7)

        local ang = Angle( 0, LocalPlayer():LocalEyeAngles()[2]-90, 90 )

        self:DrawWaitTime( pos, ang, 0.4, tostring(Prog), false )
    end
end

function ENT:OnPopulateEntityInfo(container)
  local ChemTable = util.JSONToTable(self:GetNW2String("ChemTable"))
  local name = container:AddRow("name")
	name:SetImportant()
	name:SetText("Chemical Requester")
  name:SetBackgroundColor(Color(230,230,230))
	name:SizeToContents()
	local description = container:AddRow("description")
	description:SetText("A relay station that connects to a system of chemical storage. When used, it requests various chemicals from its database.")
	description:SizeToContents()
  local vol = container:AddRow("Contains")
  vol:SetBackgroundColor(Color(200,200,200,190))
  vol:SetFont("DermaDefault")
  if (ChemTable[1][1][1]!= 0) and (ix.chemistry.List[ChemTable[1][1][1]]) then
    vol:SetText("This requester contains ".. ChemTable[1][1][2] .."ml of "..ix.chemistry.List[ChemTable[1][1][1]][1])
  else
    vol:SetText("This requester is empty") 
  end
  vol:SizeToContents()
end