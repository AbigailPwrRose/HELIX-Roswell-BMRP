local PLUGIN = PLUGIN
PLUGIN.name = "Paper"
PLUGIN.author = "Subleader"
PLUGIN.desc = "Adds paper into the game that you can write on and edit. Reworked completely working without entity."
PAPERLIMIT = 3000

ix.lang.AddTable("english", {
	paperDesc = "A paper which one you can write on.",
})
ix.lang.AddTable("korean", {
	["Paper"] = "종이",
	paperDesc = "글씨를 쓸 수 있는 종이입니다.",
	["Read/Write"] = "읽기",
})

if (CLIENT) then
	netstream.Hook("receivePaper", function(id, contents)
		local paper = vgui.Create("paperRead")
		paper:setText(contents, id)
	end)
	netstream.Hook("receivePaper_static", function(id, contents)
		local paper = vgui.Create("paperRead_staticV")
		paper:setText(contents, id)
        paper.creator = "Test"
	end)
else
	netstream.Hook("paperSendText", function(client, id, contents)
		if (string.len(contents) <= PAPERLIMIT) then
			local item = ix.item.instances[id]
			client:Notify("You have written something!")
			item:SetData("PaperData", contents)
		end
	end)
end