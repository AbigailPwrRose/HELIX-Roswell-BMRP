
ITEM.name = "Generic Item 2x1"
ITEM.description = "Generic Description"
ITEM.model = Model("models/maxofs2d/hover_rings.mdl")
ITEM.width = 3
ITEM.height = 1

function ITEM:GetName()
	return self:GetData("name", "Custom Item")
end

function ITEM:GetDescription()
	return self:GetData("description", "Custom item description.")
end

function ITEM:GetModel()
	return self:GetData("model", "models/Gibs/HGIBS.mdl")
end
