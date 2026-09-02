ENT.Type = "anim"
ENT.PrintName = "Troilite Meteor"
ENT.Category = "Winter's Chemistry"
ENT.Model = "models/props_foliage/rock_forest02.mdl"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.bNoPersist = true

ENT.MaxRenderDistance = math.pow(256, 2)
ENT.FakeHealthMax = 200
ENT.RefreshTime = 300

if (SERVER) then
    function ENT:Initialize()
        self:SetModel(self.Model) -- Sets the model for the Entity.
        self:PhysicsInit( SOLID_VPHYSICS ) -- Initializes physics for the Entity, making it solid and interactable.
        self:SetMoveType( MOVETYPE_VPHYSICS ) -- Sets how the Entity moves, using physics.
        self:SetSolid( SOLID_VPHYSICS ) -- Makes the Entity solid, allowing for collisions.
        self:SetName("Troilite Meteor")
        self:SetSkin(3)
        
        self.NextTick = 0
        self.FakeHealth = self.FakeHealthMax
        self.Refreshing = false
        self.Cooldown2use = 0
        self.RefreshProg = 0
        self.Exploded = false
    end 
    
    function ENT:OnTakeDamage(damageInfo)
        if  self.Exploded == true or self.Cooldown2use != 0 or self.RefreshProg != 0 then return end
        if !(damageInfo:GetAttacker():IsPlayer()) then
            return
        end
        self.Cooldown2use =1
        local Attacker = damageInfo:GetAttacker()
        if damageInfo:GetDamage() <= 10 then
            Attacker:Notify("The rock is too tough to damage.")
            return
        end
        if IsValid(damageInfo:GetWeapon()) then
        	local Wep = damageInfo:GetWeapon():GetClass()
            if (Wep=="tfa_nmrih_asaw" or Wep=="tfa_nmrih_chainsaw" or Wep=="tfa_nmrih_pickaxe" or Wep=="tfa_nmrih_sledge") then
                self:ProcessDamage(damageInfo:GetDamage())
            	return 
            end
        end
        
        self:Ignite( 300,40 )
        
    end
    
    function ENT:DoRefreshing()
        self.RefreshProg = self.RefreshTime
        self.FakeHealth = self.FakeHealthMax
        self:SetMaterial("Models/effects/vol_light001")
    end
    
    function ENT:ProcessDamage(Damage)
        self.FakeHealth =  math.Clamp(self.FakeHealth - Damage,0,9999)
        if self.FakeHealth <= 0 then
            self:GenerateShard()
            self:DoRefreshing()
        end
    end
    
    function ENT:Think()
        if self.Cooldown2use != 0 or self.RefreshProg != 0 then
            if self.NextTick <= CurTime() then
                self.NextTick = CurTime() + 0.5
                if self.Cooldown2use != 0 then
                    self.Cooldown2use = math.Clamp(self.Cooldown2use - 1,0,9000)
                end
                if self.RefreshProg != 0 then
                    self.RefreshProg = math.Clamp(self.RefreshProg - 1,0,9000)
                    if self.RefreshProg == 0 then 
            			self:SetMaterial()
                    end
                end
            end
        end
        if self:GetMaterial() == "Models/effects/vol_light001" and self.RefreshProg == 0 then
            self:SetMaterial()
        end
    end
    
    function ENT:GenerateShard()
        local position = self:GetPos() + Vector(0,0,45)
        local Shard = ents.Create("troiliteore_ore")
        Shard:SetPos(position) 
        Shard:SetAngles(Angle(0.0, 90.0, 0.0))
        Shard:Spawn()
        local position2 = self:GetPos() + Vector(20,0,45)
        local Shard2 = ents.Create("troiliteore_ore")
        Shard2:SetPos(position) 
        Shard2:SetAngles(Angle(0.0, 90.0, 0.0))
        Shard2:Spawn()
        local position3 = self:GetPos() + Vector(-20,0,45)
        local Shard3 = ents.Create("troiliteore_ore")
        Shard3:SetPos(position) 
        Shard3:SetAngles(Angle(0.0, 90.0, 0.0))
        Shard3:Spawn()
    end
else
  
    ENT.PopulateEntityInfo = true
	function ENT:OnPopulateEntityInfo(container)
		local name = container:AddRow("name")
		name:SetImportant()
		name:SetText("Troilite Meteor")
		name:SizeToContents()
		local description = container:AddRow("description")
		description:SetText("A space-born hunk of rock, lined with yellow sulfer lines.")
		description:SizeToContents()
	end
end