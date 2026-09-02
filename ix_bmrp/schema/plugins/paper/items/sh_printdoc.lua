ITEM.name = "Printed Document"
ITEM.description = "A printed document that cannot be editted."
ITEM.model = "models/halflife/gibs/book/book1.mdl"
ITEM.category = "Papers"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 25
ITEM.isWeapon = true
ITEM.weaponCategory = "clipboard_unique"
ITEM.class = "clipboard"
ITEM.useSound = "player/pl_pain4.wav"

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("equip")) then
			surface.SetDrawColor(200, 200, 200, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
end

ITEM.functions.use = {
	name = "Read/Write",
	icon = "icon16/pencil.png",
	OnRun = function(item)
		local client = item.player
		local id = item:GetID()
		if (id) then
			netstream.Start(client, "receivePaper_static", id, item:GetData("PaperData") or "")
		end
		return false
	end
}