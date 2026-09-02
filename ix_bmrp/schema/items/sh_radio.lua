ITEM.name = "Plexus-3 Phone"
ITEM.description = "Compact, Durable and long-lasting, this phone is produced by Sidereal Plexus, and sold to Black Mesa for a low price as part of a long-term deal."
ITEM.category = "Electronics"
ITEM.rarity = "Sidereal"
ITEM.model = "models/cellphone.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.forceRender = true
ITEM.price = 100
ITEM.iconCam = {
	pos = Vector(292.34, 160.13, 654.02),
	ang = Angle(62.99, 208.72, 180),
	fov = 0.49
}

if (CLIENT) then
	function ITEM:PopulateTooltip(tooltip)
		if (self:GetData("equip")) then
			local name = tooltip:GetRow("name")
			name:SetBackgroundColor(derma.GetColor("Success", tooltip))
		end
    	local tip = tooltip:AddRow("Rarity")
    	tip:SetBackgroundColor(Color(99,99,99,20))
    	tip:SetText("A software update is allegedly coming soon.")
    	tip:SetFont("DermaDefault")
    	tip:SizeToContents()
    end
end