ITEM.name = "Power Cell"
ITEM.description = "Invented by the folks in engineering, this battery quickly recharges your armor."
ITEM.category = "Electronics"
ITEM.rarity = "Sidereal"
ITEM.model = "models/halflife/items/battery.mdl"
ITEM.width = 1
ITEM.height = 2
ITEM.price = 300

ITEM.functions.Use = {
    name = "Use Cell",
    tip = "Activate the power cell and recharge!",
	OnRun = function(item)
		local client = item.player
		local character = client:GetCharacter()
        local Armor = client:Armor()
        if Armor < 100 then
			client:EmitSound("items/battery_pickup.wav", 40, 150)
			client:SetArmor( client:Armor() + 25 )
            if client:Armor() > 100 then client:SetArmor(100) end
            return true
        else 
			client:EmitSound("hl1/fvox/fuzz.wav", 40, 150)
            return false end
	end}