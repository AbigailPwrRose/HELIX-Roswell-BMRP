local PLUGIN = PLUGIN

PLUGIN.name = "Expanded Help Menu"
PLUGIN.author = "Winter Rose"
PLUGIN.description = "Adds language tab to help menu."

hook.Add("PopulateHelpMenu", "ixHelpMenu", function(tabs)
	tabs["flags"] = function(container)
		-- info text
		local info = container:Add("DLabel")
		info:SetFont("ixSmallFont")
		info:SetText(L("helpFlags"))
		info:SetContentAlignment(5)
		info:SetTextColor(color_white)
		info:SetExpensiveShadow(1, color_black)
		info:Dock(TOP)
		info:DockMargin(0, 0, 0, 8)
		info:SizeToContents()
		info:SetTall(info:GetTall() + 16)

		info.Paint = function(_, width, height)
			surface.SetDrawColor(ColorAlpha(derma.GetColor("Info", info), 160))
			surface.DrawRect(0, 0, width, height)
		end

		-- flags
		for k, v in SortedPairs(ix.flag.list) do
			local background = ColorAlpha(
				LocalPlayer():GetCharacter():HasFlags(k) and derma.GetColor("Success", info) or derma.GetColor("Error", info), 88
			)

			local panel = container:Add("Panel")
			panel:Dock(TOP)
			panel:DockMargin(0, 0, 0, 8)
			panel:DockPadding(4, 4, 4, 4)
			panel.Paint = function(_, width, height)
				derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, background)
			end

			local flag = panel:Add("DLabel")
			flag:SetFont("ixMonoMediumFont")
			flag:SetText(string.format("[%s]", k))
			flag:Dock(LEFT)
			flag:SetTextColor(color_white)
			flag:SetExpensiveShadow(1, color_black)
			flag:SetTextInset(4, 0)
			flag:SizeToContents()
			flag:SetTall(flag:GetTall() + 8)

			local description = panel:Add("DLabel")
			description:SetFont("ixMediumLightFont")
			description:SetText(v.description)
			description:Dock(FILL)
			description:SetTextColor(color_white)
			description:SetExpensiveShadow(1, color_black)
			description:SetTextInset(8, 0)
			description:SizeToContents()
			description:SetTall(description:GetTall() + 8)

			panel:SizeToChildren(false, true)
		end
	end
	tabs["languages"] = function(container)
		-- info text
		local info = container:Add("DLabel")
		info:SetFont("ixSmallFont")
		info:SetText("Languages! Ask an admin about getting some")
		info:SetContentAlignment(5)
		info:SetTextColor(color_white)
		info:SetExpensiveShadow(1, color_black)
		info:Dock(TOP)
		info:DockMargin(0, 0, 0, 8)
		info:SizeToContents()
		info:SetTall(info:GetTall() + 16)

		info.Paint = function(_, width, height)
			surface.SetDrawColor(ColorAlpha(derma.GetColor("Info", info), 160))
			surface.DrawRect(0, 0, width, height)
		end
		
		local LangList = ix.languages:GetAll()
		for Lang in SortedPairs(LangList) do
            local background = ColorAlpha(
				LocalPlayer():GetCharacter():CanSpeakLanguage(Lang) and derma.GetColor("Success", info) or derma.GetColor("Error", info), 88
			)
			local panel = container:Add("Panel")
			panel:Dock(TOP)
			panel:DockMargin(0, 0, 0, 8)
			panel:DockPadding(4, 4, 4, 4)
			panel.Paint = function(_, width, height)
				derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, background)
			end
                
			local icon = panel:Add("DImage")
			icon:SetImage(ix.languages:GetAll()[Lang].chatIcon)
			icon:Dock(LEFT)
			icon:SetExpensiveShadow(1, color_black)
            icon:SetSize(32, 7)
                
			local language = panel:Add("DLabel")
			language:SetFont("ixMonoMediumFont")
			language:SetText(string.format("%s", ix.languages:GetAll()[Lang].name))
			language:Dock(LEFT)
			language:SetTextColor(color_white)
			language:SetExpensiveShadow(1, color_black)
			language:SetTextInset(4, 0)
			language:SizeToContents()
			language:SetTall(language:GetTall() + 8)
                
                
			local description = panel:Add("DLabel")
			description:SetFont("ixMediumLightFont")
			description:SetText(Lang)
			description:Dock(RIGHT)
			description:SetTextColor(color_white)
			description:SetExpensiveShadow(1, color_black)
			description:SetTextInset(8, 0)
			description:SizeToContents()
			description:SetTall(description:GetTall() + 8)
			panel:SizeToChildren(false, true)
                
			local category = panel:Add("DLabel")
			category:SetFont("ixMonoMediumFont")
			category:SetText(string.format("%s", ix.languages:GetAll()[Lang].category))
			category:Dock(FILL)
			category:SetTextInset(300, 0)
			category:SetTextColor(color_white)
			category:SetExpensiveShadow(1, color_black)
			category:SizeToContents()
			category:SetTall(category:GetTall() + 8)
                
		end
	end
	tabs["commands"] = function(container)
		-- info text
		local info = container:Add("DLabel")
		info:SetFont("ixSmallFont")
		info:SetText(L("helpCommands"))
		info:SetContentAlignment(5)
		info:SetTextColor(color_white)
		info:SetExpensiveShadow(1, color_black)
		info:Dock(TOP)
		info:DockMargin(0, 0, 0, 8)
		info:SizeToContents()
		info:SetTall(info:GetTall() + 16)

		info.Paint = function(_, width, height)
			surface.SetDrawColor(ColorAlpha(derma.GetColor("Info", info), 160))
			surface.DrawRect(0, 0, width, height)
		end

		-- commands
		for uniqueID, command in SortedPairs(ix.command.list) do
			if (command.OnCheckAccess and !command:OnCheckAccess(LocalPlayer())) then
				continue
			end

			local bIsAlias = false
			local aliasText = ""

			-- we want to show aliases in the same entry for better readability
			if (command.alias) then
				local alias = istable(command.alias) and command.alias or {command.alias}

				for _, v in ipairs(alias) do
					if (v:lower() == uniqueID) then
						bIsAlias = true
						break
					end

					aliasText = aliasText .. ", /" .. v
				end

				if (bIsAlias) then
					continue
				end
			end

			-- command name
			local title = container:Add("DLabel")
			title:SetFont("ixMediumLightFont")
			title:SetText("/" .. command.name .. aliasText)
			title:Dock(TOP)
			title:SetTextColor(ix.config.Get("color"))
			title:SetExpensiveShadow(1, color_black)
			title:SizeToContents()

			-- syntax
			local syntaxText = command.syntax
			local syntax

			if (syntaxText != "" and syntaxText != "[none]") then
				syntax = container:Add("DLabel")
				syntax:SetFont("ixMediumLightFont")
				syntax:SetText(syntaxText)
				syntax:Dock(TOP)
				syntax:SetTextColor(color_white)
				syntax:SetExpensiveShadow(1, color_black)
				syntax:SetWrap(true)
				syntax:SetAutoStretchVertical(true)
				syntax:SizeToContents()
			end

			-- description
			local descriptionText = command:GetDescription()

			if (descriptionText != "") then
				local description = container:Add("DLabel")
				description:SetFont("ixSmallFont")
				description:SetText(descriptionText)
				description:Dock(TOP)
				description:SetTextColor(color_white)
				description:SetExpensiveShadow(1, color_black)
				description:SetWrap(true)
				description:SetAutoStretchVertical(true)
				description:SizeToContents()
				description:DockMargin(0, 0, 0, 8)
			elseif (syntax) then
				syntax:DockMargin(0, 0, 0, 8)
			else
				title:DockMargin(0, 0, 0, 8)
			end
		end
	end
	tabs["plugins"] = function(container)
		for _, v in SortedPairsByMemberValue(ix.plugin.list, "name") do
			-- name
			local title = container:Add("DLabel")
			title:SetFont("ixMediumLightFont")
			title:SetText(v.name or "Unknown")
			title:Dock(TOP)
			title:SetTextColor(ix.config.Get("color"))
			title:SetExpensiveShadow(1, color_black)
			title:SizeToContents()

			-- author
			local author = container:Add("DLabel")
			author:SetFont("ixSmallFont")
			author:SetText(string.format("%s: %s", L("author"), v.author))
			author:Dock(TOP)
			author:SetTextColor(color_white)
			author:SetExpensiveShadow(1, color_black)
			author:SetWrap(true)
			author:SetAutoStretchVertical(true)
			author:SizeToContents()

			-- description
			local descriptionText = v.description

			if (descriptionText != "") then
				local description = container:Add("DLabel")
				description:SetFont("ixSmallFont")
				description:SetText(descriptionText)
				description:Dock(TOP)
				description:SetTextColor(color_white)
				description:SetExpensiveShadow(1, color_black)
				description:SetWrap(true)
				description:SetAutoStretchVertical(true)
				description:SizeToContents()
				description:DockMargin(0, 0, 0, 8)
			else
				author:DockMargin(0, 0, 0, 8)
			end
		end
	end
end)