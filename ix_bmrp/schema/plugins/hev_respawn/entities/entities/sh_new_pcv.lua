ENT.Type = "anim" -- Sets the Entity type to 'anim', indicating it's an animated Entity.
ENT.Base = "base_gmodentity" -- Specifies that this Entity is based on the 'base_gmodentity', inheriting its functionality.
ENT.PrintName = "Ballistic Security Vest" -- The name that will appear in the spawn menu.
ENT.Author = "Winter" -- The author's name for this Entity.
ENT.Category = "Black Mesa" -- The category for this Entity in the spawn menu.
ENT.Spawnable = true -- Specifies whether this Entity can be spawned by players in the spawn menu.
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = true

function ENT:Initialize()
  -- Ensure code for the Server realm does not accidentally run on the Client
  self:SetModel( "models/player/hlew/extras/accessories/barney_vest.mdl" ) -- Sets the model for the Entity.
  self:PhysicsInit( SOLID_VPHYSICS ) -- Initializes physics for the Entity, making it solid and interactable.
  self:SetMoveType( MOVETYPE_VPHYSICS ) -- Sets how the Entity moves, using physics.
  self:SetSolid( SOLID_VPHYSICS ) -- Makes the Entity solid, allowing for collisions.
  self.Cooldown = 5
  local phys = self:GetPhysicsObject() -- Retrieves the physics object of the Entity.
end 
function ENT:StartTouch(client)
  if IsValid(client) and client:IsPlayer() then
    local Character = client:GetCharacter()
    if self.Cooldown != 0 then return end
    local PreWear = Character:GetData("WearingHEVStuff",0)
    if PreWear == 0 then
      if !(self:GetMaterial() == "models/props_combine/stasisshield_sheet") then
          client:SetArmor(75)
          client:SetMaxArmor(75)
          Character:SetData("WearingHEVStuff",1)
          Character:SetData("WearingBallsyVest",1)
          client:ChatNotify("You have equipped a Ballistic Vest")
          self:SetMaterial("models/props_combine/stasisshield_sheet")
          timer.Simple( 45, function() 
              self:SetMaterial("") end )
      end 
    else
      local KitType = Character:GetData("WearingBallsyVest",0)
      if KitType == 1 then
        self:SetMaterial("")
        client:ChatNotify("You return your vest")
        client:SetArmor(0)
        client:SetMaxArmor(50)
        Character:SetData("WearingHEVStuff",0)
        Character:SetData("WearingBallsyVest",0)
      else 
        client:ChatNotify("You cannot equip this right now.")
      end
    end
    self.Cooldown = 10
  end
end

function ENT:Think()
  self.Cooldown = math.Clamp(self.Cooldown - 1,0,1)
  self:NextThink( CurTime()+0.4 ) -- Set the next think to run as soon as possible, i.e. the next frame.
  return true -- Apply NextThink call
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
	name:SetText("Security Ballistic Vest")
	name:SizeToContents()
	local description = container:AddRow("description")
	description:SetText("A ballistic vest which protects against some attacks.")
	description:SizeToContents()
	end