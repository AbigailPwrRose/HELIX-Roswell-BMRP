AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Scrap Pile"
ENT.Category = "Winter's Stuff"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true

ENT.MaxRenderDistance = math.pow(256, 2)


if (SERVER) then
	function ENT:SpawnFunction(client, trace)
		local pile = ents.Create("ix_scrappile")
		pile:SetPos(trace.HitPos)
		pile:SetAngles(Angle(0,25,0))
		pile:Spawn()
		pile:Activate()
		return vendor
	end
    
	function ENT:Initialize()
		self:SetModel("models/sprops/rectangles/size_5/rect_48x48x3.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
        self:SetCollisionGroup(11)
        self:DrawShadow(false)
		local physics = self:GetPhysicsObject()
		physics:EnableMotion(false)
		physics:Sleep()
		self:SetUseType(SIMPLE_USE)
		self.canUse = true
		self:SetModel("models/props_junk/garbage128_composite001a.mdl")
		self:SetMaterial("")
	end
    
	function ENT:Use(client)
        if !(self:GetMaterial() == "Invisible") then
        client:SetAction("Searching...", 5) -- for displaying the progress bar
		client:DoStaredAction(self, function()
        local PoorLoot = {"singlebullet","tinyammo", "cigarette", "oldboot", "metalsheet1", "metalsheet2", "cheapbooze", "oldpaper", "pipe","syringe","deck_gamblin1","rawmeat","bread"}
        local PoorDebris = {"models/props_junk/garbage128_composite001a.mdl","models/props_junk/garbage128_composite001b.mdl","models/props_debris/concrete_debris128pile001b.mdl"}
			self:SetMaterial("Invisible")
            local inventory = client:GetCharacter():GetInventory()
            if table.HasValue(PoorDebris, self:GetModel()) then
            	inventory:Add(table.Random(PoorLoot),1)
            end
           	local Luck = math.random(0,100)
           	self:SetModel(table.Random(PoorDebris))
            ix.log.AddRaw(client:GetName().." has scavenged some scrap")
            timer.Simple( 45, function() self:SetMaterial("") end )
		end, 5, function()
            client:SetAction(" ", 0.01) end)
    end end
else
    function ENT:Draw()
        self:DrawModel() 
    end
    ENT.PopulateEntityInfo = true
	function ENT:OnPopulateEntityInfo(container)
		local name = container:AddRow("name")
		name:SetImportant()
		name:SetText("Junk")
		name:SizeToContents()
		local description = container:AddRow("description")
		description:SetText("Some bastard was too lazy to go all the way to the bin.")
		description:SizeToContents()
	end
end