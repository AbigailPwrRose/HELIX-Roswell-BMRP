local PLUGIN = PLUGIN

PLUGIN.name = "Description Limit Remover"
PLUGIN.author = ".alynn"
PLUGIN.description = "Removes the character description limit, allowing for longer descriptions."

if SERVER then return end

function PLUGIN:PopulateCharacterInfo(client, character, tooltip)
	GAMEMODE.PopulateCharacterInfo = nil --oh gee i hope this doesnt have unintended side effects later down the line
	-- description
	local descriptionText = character:GetDescription()

	if (descriptionText != "") then
		description = tooltip:AddRow("description")
		description:SetText(descriptionText)
		description:SizeToContents()
	end

    -- detailed description support
	local detDesc = client:GetCharacter():GetDetDesc()
	--maybe add it so it tells if they have an image?
	--if rank != 0 and client:GetModel() == "models/humans/pbmrp/extra/bms_hev.mdl" then
    if string.find(detDesc,"%a") != nil then
		local panel = tooltip:AddRowAfter("description","detDesc")
		panel:SetBackgroundColor(Color(255,255,255,255))
		--panel:SetText("Hold E to view this character's Detailed Description!".." debug: "..tostring(detDesc))
		panel:SetText("Hold E to view this character's Detailed Description!")
		panel:SizeToContents()
	--else
	--	local panel = tooltip:AddRowAfter("description","detDesc")
	--	panel:SetBackgroundColor(Color(255,255,255,255))
	--	panel:SetText("This character doesn't have a Detailed Description".." debug: "..tostring(detDesc))
	--	panel:SizeToContents()
	end
end