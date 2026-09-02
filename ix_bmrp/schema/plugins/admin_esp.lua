PLUGIN.name = "Admin ESP"
PLUGIN.author = "Akiran, ZeMysticalTaco(Original ESP)"
PLUGIN.description = "A simple ESP admin that shows you the most used entities on Helix."

local EntitiesESPList = {
	["ix_item"] = Color(255, 255, 255, 255),
	["ix_money"] = Color(255, 251, 0, 255),
	["ix_shipment"] = Color(255, 255, 255, 255),
	["ix_container"] = Color(51, 255, 209, 255),
	["ix_vendor"] = Color(255, 185, 0, 255),
	["ix_vendor_new"] = Color(255, 185, 0, 255),

	["ix_safebox"] = Color(39, 160, 212, 255),
	["ix_npc"] = Color(151, 173, 201, 255),

	["sent_computerzanik"] = Color(114, 238, 72, 255),
	["sent_computercss"] = Color(114, 238, 72, 255),
	["sent_computer_projector"] = Color(114, 238, 72, 255),
	["sent_computer_tv"] = Color(114, 238, 72, 255),
	["sent_computerzanik_root"] = Color(80, 146, 58, 255),

	["chemistry_analyzer"] = Color(171, 68, 212, 255),
	["chemistry_extractor"] = Color(171, 68, 212, 255),
	["chemistry_station"] = Color(171, 68, 212, 255),
	["chemistry_storage_large"] = Color(171, 68, 212, 255),
	["chemistry_storage_small"] = Color(171, 68, 212, 255),

	["bmrp_crystal_evaluator"] = Color(218, 106, 25, 255),
	["ix_orenode"] = Color(218, 106, 25, 255),
}

local ItemCategoryColor = {
	["Weapons - Guns"] = Color(255,50,50),
	["Weapons - Melee"] = Color(255,50,50),
	["Weapons - Pistol"] = Color(255,50,50),
	["Weapons - Special"] = Color(255,50,50),
	["Bombs"] = Color(255,50,50),
	["Ammo"] = Color(155,50,50),
	["Consumables - Drinks"] = Color(100,255,100),
	["Consumables - Snacks"] = Color(100,255,100),
	["Tools"] = Color(150,200,50),
	["Bags"] = Color(65,200,150),
	["Papers"] = Color(50,255,175),
	["Medical"] = Color(50,255,175),
	["Electronics"] = Color(39, 160, 212, 255),
}

local dimDistance = -1
local aimLength = 128

ix.lang.AddTable("english", {
	optItemESP = "Item ESP",
	optdItemESP = "Shows the names and locations of each item in the server.",
})
ix.lang.AddTable("korean", {
	optItemESP = "아이템 ESP 켜기",
	optdItemESP = "서버에 있는 각각의 아이템의 이름과 위치를 표시합니다.",
})

ix.option.Add("itemESP", ix.type.bool, true, {
	category = "observer",
	hidden = function()
		return !CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Observer", nil)
	end
})

	function PLUGIN:HUDPaint()
		local client = LocalPlayer()

		if (CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Observer", nil) and client:GetMoveType() == MOVETYPE_NOCLIP and not client:InVehicle() and ix.option.Get("observerESP", true)) then
			local scrW, scrH = ScrW(), ScrH()

			if ix.option.Get("itemESP") then
				for k, v in pairs(ents.GetAll()) do
					if IsValid(v) and v:IsWeapon() and v:GetPhysicsObject() and v:GetOwner() == NULL then
						local entcolor = Color(255,50,50)
						local screenPosition = v:GetPos():ToScreen()
						local marginX, marginY = scrH * .1, scrH * .1
						local x2, y2 = math.Clamp(screenPosition.x, marginX, scrW - marginX), math.Clamp(screenPosition.y, marginY, scrH - marginY)
						local distance = client:GetPos():Distance(v:GetPos())
						local factor = 1 - math.Clamp(distance / dimDistance, 0, 1)
						local size2 = math.max(10, 32 * factor)
						local alpha2 = math.max(255 * factor, 80)
						local weaponName = v:GetPrintName()
						if v.wasBodyLoot then
							ix.util.DrawText("[Dropped Loot]" ..weaponName, x2, y2 - size2, entcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha2)
						else
							ix.util.DrawText("[Dropped Weapon]" ..weaponName, x2, y2 - size2, entcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha2)
						end
					else
						for k2, v2 in pairs(EntitiesESPList) do 
							if string.find(k2, v:GetClass()) then
								local entities = k2
								local entcolor = v2
								local screenPosition = v:GetPos():ToScreen()
								local marginX, marginY = scrH * .1, scrH * .1
								local x2, y2 = math.Clamp(screenPosition.x, marginX, scrW - marginX), math.Clamp(screenPosition.y, marginY, scrH - marginY)
								local distance = client:GetPos():Distance(v:GetPos())
								local factor = 1 - math.Clamp(distance / dimDistance, 0, 1)
								local size2 = math.max(10, 32 * factor)
								local alpha2 = math.max(255 * factor, 80)

								if entities == "ix_item" then
									local itemName = v:GetItemTable()

									for k3, v3 in pairs(ItemCategoryColor) do
										if itemName.category == k3 then
											entcolor = v3
										end
									end
									ix.util.DrawText("[Item]" ..itemName.name, x2, y2 - size2, entcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha2)
								elseif EntitiesESPList[entities] then
                                    local ToFormat = v:GetClass()
                                    if string.StartsWith(ToFormat,"ix_") then
                                        ToFormat = string.sub(ToFormat, 4 )
                                    end
                                    if string.StartsWith(ToFormat,"sent_") then
                                        ToFormat = string.sub(ToFormat, 6 )
                                    end
									ix.util.DrawText("["..string.NiceName(ToFormat).."]", x2, y2 - size2, entcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha2)
								end
							end
						end
					end
				end
			end

			for _, v in ipairs(player.GetAll()) do
				if (v == client or not v:GetCharacter()) then continue end
				local screenPosition = v:GetPos():ToScreen()
				local marginX, marginY = scrH * .1, scrH * .1
				local x, y = math.Clamp(screenPosition.x, marginX, scrW - marginX), math.Clamp(screenPosition.y, marginY, scrH - marginY)
				local teamColor = team.GetColor(v:Team())
				local distance = client:GetPos():Distance(v:GetPos())
				local factor = 1 - math.Clamp(distance / dimDistance, 0, 1)
				local size = math.max(10, 32 * factor)
				local alpha = math.max(255 * factor, 80)
				surface.SetDrawColor(teamColor.r, teamColor.g, teamColor.b, alpha)
				surface.SetFont("ixGenericFont")
				local text = v:Name()

				--tables are for faggots.
				if not v.status then
					v.status = "user"
				elseif v:IsUserGroup("superadmin") then
					v.status = "SA"
				elseif v:IsUserGroup("admin") then
					v.status = "Admin"
				elseif v:IsUserGroup("operator") then
					v.status = "Oper"
				elseif v:IsUserGroup("user") then
					v.status = "user"
				elseif v:IsUserGroup("TrialAdmin") then
					v.status = "T.A."
				elseif v:IsUserGroup("TrialGM") then
					v.status = "T.GM"
				else
					v.status = v:GetUserGroup()
				end

				local text2 = v:SteamName() .. "[" .. v.status .. "]"
				local text3 = "H: " .. v:Health() .. " A: " .. v:Armor()
				local text4 = v:GetActiveWeapon().PrintName
				surface.SetDrawColor(teamColor.r * 1.6, teamColor.g * 1.6, teamColor.b * 1.6, alpha)
				local col = Color(255, 255, 255, 255)

				if v:IsWepRaised() then
					col = Color(255, 100, 100, 255)
				end

				ix.util.DrawText(text, x, y - size, ColorAlpha(teamColor, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
				ix.util.DrawText(text2, x, y - size + 20, Color(200, 200, 200, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
				ix.util.DrawText(text3, x, y - size + 40, Color(200, 200, 200, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
				ix.util.DrawText(text4, x, y - size + 60, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
			end
		end
	end

local playerMeta = FindMetaTable("Player")