ENT.Type = "anim"
ENT.PrintName = "Area Breaker"
ENT.Category = "Maintenance System"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.DoesDecay = true
ENT.TaskName = "Fuze Blown"

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("Models/props/propshl2/switch02.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self.MaxDurability = 36
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
        if self.Durability <= 0 and !(self:IsOnFire()) then
            local IsMaintenance = ix.faction.Get(activator:Team()).IsMaintenance or false
            if IsMaintenance == false then 
                activator:Notify("You're not trained to repair this!")
                return false
            end
            netstream.Start(activator, "clientStartMaintenance_TypeTwo", self:EntIndex())
        	EmitSound( "buttons/button4.wav", self:GetPos() )
        elseif self:IsOnFire() then
            activator:Notify("You can't fix this while its burning!")
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
        	EmitSound( "ambient/fire/ignite.wav", self:GetPos() )
            self:Ignite(60,5)
        end
    end
    
    function ENT:DoRepair()
        self.Durability = math.floor(self.MaxDurability * math.random(0.5,1))
        self:SetNW2Bool("Broken",false)
        self:SetSkin(0)
        self:Extinguish()
        EmitSound( "ambient/machines/thumper_startup1.wav", self:GetPos() )
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
            if self.DripDelay > 60 then
                self.DripDelay = 0
                    EmitSound( table.Random({"ambient/energy/spark5.wav","ambient/energy/spark1.wav","ambient/energy/zap1.wav","ambient/energy/zap3.wav"}), self:GetPos() )
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
		description:SetText("A breaker box containing various wires and fuzes.")
		description:SizeToContents()
	end
end