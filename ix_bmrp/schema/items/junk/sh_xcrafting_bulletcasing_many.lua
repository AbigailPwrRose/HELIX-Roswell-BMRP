ITEM.name = "Many bullet casings"
ITEM.description = "A large number of bullet casings, ready to be loaded.\n\nCan be combined with bullet rounds."
ITEM.category = "Junk"
ITEM.rarity = "Uncommon"
ITEM.model = "models/props_lab/box01a.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 1

ITEM.functions.combine = {
	OnRun = function(item, data)
        local Item2Table = ix.item.instances[data[1]]
        if Item2Table.name == "Bullet Rounds" then
            local Client = item.player
            local Char = Client:GetCharacter()
            local Inv = Char:GetInventory()
            ix.item.instances[data[1]]:Remove()
            Inv:Add("largeammo", 1,nil)
        elseif Item2Table.name == "Enriched Bullet Rounds" then
            local Client = item.player
            local Char = Client:GetCharacter()
            local Inv = Char:GetInventory()
            ix.item.instances[data[1]]:Remove()
            Inv:Add("largeammo", 2,nil)
        end
		return true
	end,
	OnCanRun = function(item, data)
        local Item2Table = ix.item.instances[data[1]]
        if Item2Table.name == "Bullet Rounds" then
            return true
        elseif Item2Table.name == "Enriched Bullet Rounds" then
            return true
        end
        return false 
	end
}