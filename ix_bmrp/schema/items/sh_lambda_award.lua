ITEM.name = "The lambdy Award"
ITEM.description = "A symbol of presitge and honour, these awards are rarely given out to scientists of remarkable merit."
ITEM.category = "Awards"
ITEM.model = "models/props/portedprops3/lambda.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.rarity = "Legendary"
ITEM.price = 500

if (CLIENT) then
	function ITEM:PopulateTooltip(tooltip)
		if (self:GetData("equip")) then
			local name = tooltip:GetRow("name")
			name:SetBackgroundColor(derma.GetColor("Success", tooltip))
		end
    	local tip = tooltip:AddRow("Rarity")
    	tip:SetBackgroundColor(Color(99,99,99,20))
    	tip:SetText("A most prestigous reward")
    	tip:SetFont("DermaDefault")
    	tip:SizeToContents()
    end
end