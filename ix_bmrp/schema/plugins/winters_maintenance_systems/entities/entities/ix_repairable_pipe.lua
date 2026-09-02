ENT.Type = "anim"
ENT.PrintName = "Fluid Pressure Valve"
ENT.Category = "Maintenance System"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.DoesDecay = true
ENT.TaskName = "Pressure Failure"

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_pipes/valve003.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self.MaxDurability = 35
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
            netstream.Start(activator, 'clientStartMaintenance_TypeThree', self:EntIndex())
        	EmitSound( "buttons/lever2.wav", self:GetPos() )
        end
	end
    
    function ENT:DoDecay()
        self.Durability = math.Clamp(self.Durability - 1,0,self.MaxDurability)
        if self.Durability == 0 then
			timer.Create( "AutoRepairCycle"..self:EntIndex(), (ix.config.Get("ixAutoRepairTime")*60), 1, function() 
                    if IsValid(Entity(self:EntIndex())) and Entity(self:EntIndex()).DoDecay then
               	 	if self:GetNW2Bool("Broken",false) == true then 
                        self:DoRepair()
                    end end
                    timer.Remove("AutoRepairCycle"..self:EntIndex())
                end )
        	self:SetNW2Bool("Broken",true)
        	EmitSound( "ambient/materials/metal_stress3.wav", self:GetPos() )
        end
    end
    
    function ENT:DoRepair()
        self.Durability = math.floor(self.MaxDurability * math.random(0.5,1))
        self:SetNW2Bool("Broken",false)
        	EmitSound( "ambient/water/water_pump_drainin1.wav", self:GetPos() )
    end
    
    function ENT:Think()
        if self.Durability > 0  and ix.config.Get("ixDisableDecay") == false then
        	self:SetSkin(0)
            self.RunTime = self.RunTime + 1
            if self.RunTime >= ix.config.Get("ixDecayTickTime") then
                self:DoDecay()
                self.RunTime = 0
            end
        end
        self:NextThink( CurTime() + 1 )
        return true
    end
else
	ENT.PopulateEntityInfo = true
	function ENT:Think() 
        if self:GetNW2Bool("Broken",true) then 
            if self.DripDelay == nil then 
                self.DripDelay = 0
            end
        	self.DripDelay = self.DripDelay + math.random(1,2)
            if self.DripDelay > 35 then
                self.DripDelay = 0
                EmitSound( table.Random({"ambient/water/rain_drip1.wav","ambient/water/rain_drip2.wav","ambient/water/rain_drip3.wav","ambient/water/rain_drip4.wav"}), self:GetPos() )
                local pos = self:LocalToWorld(Vector(0,0,4))

                local emitter = ParticleEmitter( pos ) -- Particle emitter in this position

                local part = emitter:Add( "effects/energysplash", pos ) -- Create a new particle at pos
                if ( part ) then
                    part:SetDieTime( 1 ) -- How long the particle should "live"

                    part:SetStartAlpha( 255 ) -- Starting alpha of the particle
                    part:SetEndAlpha( 0 ) -- Particle size at the end if its lifetime

                    part:SetStartSize( 5 ) -- Starting size
                    part:SetEndSize( 0 ) -- Size when removed

                    part:SetGravity( Vector( 0, 0, -250 ) ) -- Gravity of the particle
                    part:SetVelocity( VectorRand() * 5 ) -- Initial velocity of the particle
                end

                emitter:Finish()
            end
        else
        	self.DripDelay = 0
        end
    end
	function ENT:OnPopulateEntityInfo(tooltip)
		local title = tooltip:AddRow("name")
		title:SetImportant()
		title:SetText(self.PrintName)
		title:SetBackgroundColor(ix.config.Get("color"))
		title:SizeToContents()

		local description = tooltip:AddRow("description")
		description:SetText("One of the pressure valves keeping things stable.")
		description:SizeToContents()
	end
end