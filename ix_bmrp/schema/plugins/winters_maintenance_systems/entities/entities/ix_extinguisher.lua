ENT.Type = "anim"
ENT.Base = "base_gmodentity" 
ENT.PrintName = "Extinguisher" -- The name that will appear in the spawn menu.
ENT.Author = "Winter" -- The author's name for this Entity.
ENT.Category = "Maintenance System"
ENT.Spawnable = true -- Specifies whether this Entity can be spawned by players in the spawn menu.
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = true
ENT.ItemToEquip = "weapon_extinguisher"

if not(CLIENT) then
    function ENT:Initialize()
      -- Ensure code for the Server realm does not accidentally run on the Client
        self:SetModel( "Models/props/hl15props/firex.mdl" )
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)

        local phys = self:GetPhysicsObject() -- Retrieves the physics object of the Entity.
        self.Cooldown = 10
    end 
    function ENT:Use(client)
        if IsValid(client) and client:IsPlayer() then
            if self.Cooldown != 0 then return end
            if client:HasWeapon(self.ItemToEquip) then
                client:StripWeapon(self.ItemToEquip)
                client:SetAmmo(0,55)
                client:Notify("You return your extinguisher")
                client:SelectWeapon("ix_hands")
            else 
                client:Give(self.ItemToEquip)
                client:SetAmmo(250,55)
                client:SelectWeapon(self.ItemToEquip)
                client:Notify("You've taken an extinguisher")
            end
            self.Cooldown = 10
        end
    end

	function ENT:Think()
        self.Cooldown = math.Clamp(self.Cooldown - 1,0,10)
        self:NextThink( CurTime()+0.4 ) -- Set the next think to run as soon as possible, i.e. the next frame.
        return true -- Apply NextThink call 
    end
end

if not CLIENT then return end
-- Client-side draw function for the Entity
function ENT:Draw()
    self:DrawModel() -- Draws the model of the Entity. This function is called every frame.
end 
ENT.PopulateEntityInfo = true
function ENT:OnPopulateEntityInfo(container)
    local name = container:AddRow("name")
	name:SetImportant()
	name:SetText("Extinguisher Holder")
	name:SizeToContents()
	local description = container:AddRow("description")
	description:SetText("A wall-mounted cabinet containing a fire extinguisher. \nPress E to take one!")
	description:SizeToContents()
	end