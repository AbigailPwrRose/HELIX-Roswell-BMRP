local PLUGIN = PLUGIN

PLUGIN.name = "Echirus Expirement"
PLUGIN.author = "Winter Rose!"
PLUGIN.description = "An expirement, don't pay much mind."

if (SERVER) then
    ix.allowedHoldableClasses["echiruscrystal_shard"] = true 
    ix.allowedHoldableClasses["troiliteore_ore"] = true 
  
	function PLUGIN:SaveData()
		local data = {}

		for _, entity in ipairs(ents.FindByClass("echiruscrystal_vein")) do
			data[#data + 1] = {
                type = "echiruscrystal_vein",
				pos = entity:GetPos(),
				angles = entity:GetAngles(),
				model = entity:GetModel(),
				skin = entity:GetSkin(),
			}
        end

		for _, entity in ipairs(ents.FindByClass("troiliteore_meteor")) do
			data[#data + 1] = {
                type = "troiliteore_meteor",
				pos = entity:GetPos(),
				angles = entity:GetAngles(),
				model = entity:GetModel(),
				skin = entity:GetSkin(),
			}
        end
		self:SetData(data)
	end
    
	function PLUGIN:LoadData()
		for _, v in ipairs(self:GetData() or {}) do
            if v.type == "echiruscrystal_vein" then
				local entity = ents.Create("echiruscrystal_vein")
				entity:SetPos(v.pos)
				entity:SetAngles(v.angles)
				entity:Spawn()
	
				entity:SetModel(v.model)
                entity:SetMaterial("")
				entity:SetSkin(v.skin or 0)
                entity:PhysicsInit(SOLID_VPHYSICS)
                entity:SetSolid(SOLID_VPHYSICS)
				local physics = entity:GetPhysicsObject()
                physics:EnableMotion(false)
                physics:Sleep()
            end
            if v.type == "troiliteore_meteor" then
				local entity = ents.Create("troiliteore_meteor")
				entity:SetPos(v.pos)
				entity:SetAngles(v.angles)
				entity:Spawn()
	
				entity:SetModel(v.model)
                entity:SetMaterial("")
				entity:SetSkin(v.skin or 0)
                entity:PhysicsInit(SOLID_VPHYSICS)
                entity:SetSolid(SOLID_VPHYSICS)
				local physics = entity:GetPhysicsObject()
                physics:EnableMotion(false)
                physics:Sleep()
            end
		end
    end 
end