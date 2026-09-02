local PLUGIN = PLUGIN

PLUGIN.name = "Winters BMRP Entities"
PLUGIN.author = "Winter Rose"
PLUGIN.description = "A collection of entities that support BMRP gameplay."

ix.command.Add("QuickSave", {
    description = "Quickly save the resource nodes.",
    adminOnly = true,
    OnRun = function()
    PLUGIN:SaveData() end
    })

if (SERVER) then
	function PLUGIN:SaveData()
		local data = {}

		for _, entity in ipairs(ents.FindByClass("ix_orenode")) do
			data[#data + 1] = {
                type = "ix_orenode",
				pos = entity:GetPos(),
				angles = entity:GetAngles(),
				model = entity:GetModel(),
				skin = entity:GetSkin(),
			}
        end
        for _, entity in ipairs(ents.FindByClass("ix_charger")) do
			data[#data + 1] = {
                type = "ix_charger",
				pos = entity:GetPos(),
				angles = entity:GetAngles(),
				model = entity:GetModel(),
				skin = entity:GetSkin(),
			}
		end
        for _, entity in ipairs(ents.FindByClass("ix_scrappile")) do
			data[#data + 1] = {
                type = "ix_scrappile",
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
            if v.type == "ix_scrappile" then
				local entity = ents.Create("ix_scrappile")
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
            elseif v.type == "ix_charger" then
				local entity = ents.Create("ix_charger")
				entity:SetPos(v.pos)
				entity:SetAngles(v.angles)
				entity:Spawn()
	
				entity:SetModel(v.model)
				entity:SetSkin(v.skin or 0)
                entity:PhysicsInit(SOLID_VPHYSICS)
                entity:SetSolid(SOLID_VPHYSICS)
				local physics = entity:GetPhysicsObject()
                physics:EnableMotion(false)
                physics:Sleep()
			elseif v.type == "ix_orenode" then
				local entity = ents.Create("ix_orenode")
				entity:SetPos(v.pos)
				entity:SetAngles(v.angles)
				entity:Spawn()
	
				entity:SetModel(v.model)
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

hook.Add("PlayerDeath", "ix_winter_dropcrystals", function(client)
	for k,c in pairs(client:GetCharacter():GetInventory():GetItems(true)) do
		if (ix.item.instances[k]["uniqueID"] == "xen_template") or (ix.item.instances[k]["uniqueID"] == "weather_report") then
          ix.item.instances[k]:Transfer(nil, nil, nil, ix.item.instances[k].player)
		end
	end
end)