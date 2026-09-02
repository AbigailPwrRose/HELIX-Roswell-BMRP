util.AddNetworkString("ixOpenDetailedDescriptions")
util.AddNetworkString("ixSetDetailedDescriptions")
util.AddNetworkString("ixEditDetailedDescriptions")

net.Receive("ixEditDetailedDescriptions", function()
	local textEntryURL = net.ReadString()
	local text = net.ReadString()
	local callingClientSteamName = net.ReadString()
	
	for key, client in pairs(player.GetAll()) do
		if client:SteamName() == callingClientSteamName then
			client:GetCharacter():SetData("textDetDescData", text)
			client:GetCharacter():SetData("textDetDescDataURL", textEntryURL)
			client:GetCharacter():SetDetDesc(text)
		end
	end
end)

function PLUGIN:CharacterLoaded(character)
	local detDesc = character:GetData("textDetDescData", "")
	character:SetDetDesc(detDesc)
end

function PLUGIN:KeyPress(ply,key)
	if key == IN_USE then
		local data = {}
			data.start = ply:GetShootPos()
			data.endpos = data.start + ply:GetAimVector() * 96
			data.filter = ply
		local traceEntity = util.TraceLine(data).Entity
		if IsValid(traceEntity) and traceEntity:IsPlayer() then
			local detDesc = traceEntity:GetCharacter():GetDetDesc()
			if string.find(detDesc,"%a") != nil then
				if traceEntity:IsPlayer() then
					ply:SetAction("Examining...", 1)
					ply:DoStaredAction(traceEntity,function()
						local textEntryData = traceEntity:GetCharacter():GetData("textDetDescData", nil) or "No detailed description found."
						local textEntryDataURL = traceEntity:GetCharacter():GetData("textDetDescDataURL", nil) or "No detailed description found."

						net.Start("ixOpenDetailedDescriptions")
							net.WriteEntity(traceEntity)
							net.WriteString(textEntryData)
							net.WriteString(textEntryDataURL)
						net.Send(ply)
					end,1,function()
						ply:SetAction()
					end)
				end
			else
				ply:Notify("This person does not have a Detailed Description.")
			end
		end
	end
end
--[[
function PLUGIN:OnPlayerOptionSelected(client, callingClient, option)
	if (option == "Examine") then
		local textEntryData = client:GetCharacter():GetData("textDetDescData", nil) or "No detailed description found."
		local textEntryDataURL = client:GetCharacter():GetData("textDetDescDataURL", nil) or "No detailed description found."

		net.Start("ixOpenDetailedDescriptions")
			net.WriteEntity(client)
			net.WriteString(textEntryData)
			net.WriteString(textEntryDataURL)
		net.Send(callingClient)
	end
end]]--