-- Here is where all of your clientside functions should go.
function Schema:ExampleFunction(text, ...)
	if (text:sub(1, 1) == "@") then
		text = L(text:sub(2), ...)
	end

	LocalPlayer():ChatPrint(text)
end

net.Receive("read_the_paper", function(len, ply)
    item = net.ReadTable()
    local frame = vgui.Create("DFrame")
    frame:SetSize(item[3], item[4])
    frame:Center()
    frame:MakePopup()
    frame:SetTitle(item[1])
    local richtext = vgui.Create( "RichText", frame )
    richtext:Dock(FILL)
    richtext:SetText(item[2])     
end)
