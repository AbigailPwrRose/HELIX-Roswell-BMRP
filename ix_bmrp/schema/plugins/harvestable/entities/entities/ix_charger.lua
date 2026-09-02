AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Modile Recharge Station Care"
ENT.Category = "Winter's Stuff"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true

ENT.MaxRenderDistance = math.pow(256, 2)

if (SERVER) then
	function ENT:SpawnFunction(client, trace)
		local vendor = ents.Create("ix_charger")
		vendor:SetPos(trace.HitPos)
		vendor:SetAngles(trace.HitNormal:Angle())
		vendor:Spawn()
		vendor:Activate()
		return vendor
	end
    
	function ENT:Initialize()
		self:SetModel("models/props_equipment/portablebattery01.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self.canUse = true

		local physics = self:GetPhysicsObject()
		physics:EnableMotion(false)
		physics:Sleep()
	end
    
	function ENT:Use(client)
		local character = client:GetCharacter()
        local Armor = client:Armor()
        if Armor < client:GetMaxArmor() then
			client:EmitSound("scifi/hudbleep.mp3", 40, 150)
			client:SetArmor( client:Armor() + 5 )
            if client:Armor() > client:GetMaxArmor()  then client:SetArmor(client:GetMaxArmor()) end
            if client:Armor() == client:GetMaxArmor() then client:ChatNotify("Thank you for using Phalanx Care, have a nice day!") end
        else 
			client:EmitSound("scifi/hudobjectivecomplete.mp3", 40, 150)
            return end
        timer.Simple(1, function()end)
	end
else
    function ENT:Draw()
        self:DrawModel() 
    end
    
    ENT.PopulateEntityInfo = true
	function ENT:OnPopulateEntityInfo(container)
		local name = container:AddRow("name")
		name:SetImportant()
		name:SetText("Portable Charging Station")
		name:SizeToContents()
		local description = container:AddRow("description")
		description:SetText("???")
		description:SizeToContents()
	end
end