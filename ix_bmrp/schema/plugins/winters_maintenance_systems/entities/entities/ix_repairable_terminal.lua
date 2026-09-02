ENT.Type = "anim"
ENT.PrintName = "Area Enviromental Control Terminal"
ENT.Category = "Maintenance System"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.DoesDecay = true
ENT.TaskName = "AECT Recalibration"

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props/propshl2/supercomputer04.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self.MaxDurability = 30
		self.Durability = self.MaxDurability
        self.RunTime = 0
        self:SetNW2Bool("Broken",false)
        
		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(true)
			physObj:Wake()
		end
	end
    
	function ENT:Use(activator)
        if self.Durability <= 0 then
            local IsMaintenance = ix.faction.Get(activator:Team()).IsMaintenance or false
            if IsMaintenance == false then 
                activator:Notify("You're not trained to repair this!")
                return false
            end
            netstream.Start(activator, "clientStartMaintenance_TypeOne", self:EntIndex())
        	EmitSound( "vj_neotokyo/therm_on.wav", self:GetPos() )
        end
	end
    
    function ENT:DoDecay()
        self.Durability = math.Clamp(self.Durability - 1,0,self.MaxDurability)
        if self.Durability == 0 then
        	self:SetNW2Bool("Broken",true)
        	self:SetSkin(1)
			timer.Create( "AutoRepairCycle"..self:EntIndex(), (ix.config.Get("ixAutoRepairTime")*60), 1, function() 
                    if IsValid(Entity(self:EntIndex())) and Entity(self:EntIndex()).DoDecay then
               	 	if self:GetNW2Bool("Broken",false) == true then 
                        self:DoRepair()
                    end end
                    timer.Remove("AutoRepairCycle"..self:EntIndex())
                end )
        	EmitSound( "jmod/snd_jack_arcgunwarn.wav", self:GetPos() )
        end
    end
    
    function ENT:DoRepair()
        self.Durability = math.floor(self.MaxDurability * math.random(0.5,1))
        self:SetNW2Bool("Broken",false)
        self:SetSkin(0)
        EmitSound( "mvcr_sounds/misc/powerup2.mp3", self:GetPos() )
    end
    
    function ENT:Think()
        if self.Durability > 0  and ix.config.Get("ixDisableDecay") == false then
        	self:SetSkin(0)
            self.RunTime = self.RunTime + 1
            if self.RunTime >= ix.config.Get("ixDecayTickTime") then
                self:DoDecay()
                self.RunTime = 0
            end
            self:NextThink( CurTime() + 1 )
            return true
        end
    end
else
	ENT.PopulateEntityInfo = true

    ENT.DripDelay = 0

	function ENT:Think() 
        if self:GetNW2Bool("Broken",true) then 
            if self.DripDelay == nil then 
                self.DripDelay = 0
            end
        	self.DripDelay = self.DripDelay + 1
            if self.DripDelay > 30 then
                self.DripDelay = 0
                    EmitSound( "bms_objects/clickbeep/beep12.wav", self:GetPos() )
            end
        end
    end
  
	function ENT:OnPopulateEntityInfo(tooltip)
		local title = tooltip:AddRow("name")
		title:SetImportant()
		title:SetText(self.PrintName)
		title:SetBackgroundColor(ix.config.Get("color"))
		title:SizeToContents()

		local description = tooltip:AddRow("description")
		description:SetText("A large panel displaying various graphs of enviromental and system data.")
		description:SizeToContents()
	end
end