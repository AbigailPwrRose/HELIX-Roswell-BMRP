PLUGIN.name = "Winters Simple Radio"
PLUGIN.author = "Winter Rose"
PLUGIN.description = "A simple, text-only Helix radio system!"

ix.config.Add("radioEnabled", true, "Wether or not the radio system should be active.", nil, {
	category = "Radio"
})

ix.command.Add("ToggleRadio", {
    description = "Toggles wether radios are active",
    adminOnly = true,
    arguments = {},
    OnRun = function(self, client)
        if ix.config.Get("radioEnabled", true) then
          ix.config.Set("radioEnabled", false)
          client:ChatNotify("You have set the radio state to FALSE")
        else
          ix.config.Set("radioEnabled", true) 
          client:ChatNotify("You have set the radio state to TRUE")
        end
    end
})

ix.chat.Register("radiochatter", {
	format = "%s says \"%s\"",
	color = Color(235,235,60),
	CanHear = ix.config.Get("chatRange", 280) * 2,
})
ix.chat.Register("radio", { -- Sets up and registers the radio chat.
	format = "[%s] %s: \"%s\"",
	indicator = "chatTalking",
	CanHear = function(self, speaker, listener)
        local HasPhone = listener:GetCharacter():GetInventory():HasItem("radio")
        local ListnFac = ix.faction.Get(listener:GetCharacter():GetFaction()).name
        if (HasPhone) then return true else
        return false
        end
    end,
	OnChatAdd = function(self, speaker, text)
		local character = speaker:GetCharacter()
		local name = character:GetName()
		chat.AddText(Color(79, 230, 247), "[General Radio] "..name..":",Color(220,220,220)," \""..text.."\"")
        return true 
        end,})
ix.chat.Register("radioTeam", { -- Sets up and registers the radio chat.
	format = "[%s] %s: \"%s\"",
	indicator = "chatTalking",
	CanHear = function(self, speaker, listener) 
        local TargFaction = ix.faction.Get(speaker:GetCharacter():GetFaction()).name
        local ListnFac = ix.faction.Get(listener:GetCharacter():GetFaction()).name
        local HasPhone = listener:GetCharacter():GetInventory():HasItem("radio")
        if (HasPhone) then
        	if (ListnFac == TargFaction) then
				return true
        	elseif (ListnFac == "Administration") then 
                	if ((TargFaction == "UPR Police") or (TargFaction == "UPR National Emergency Service") or (TargFaction == "UPR National Medical Service") or (TargFaction == "Mechanics Union")) then return true end
			else return false 
        	end 
        elseif (ListnFac == "Admin Character") then return true
        else return false
        end
    end,
	OnChatAdd = function(self, speaker, text)
		local character = speaker:GetCharacter()
		local name = character:GetName()
        local FactionRadio = ix.faction.Get(character:GetFaction()).teamRadio
        local FactionColor = ix.faction.Get(character:GetFaction()).color
		chat.AddText(FactionColor, "["..FactionRadio.."] "..name..":",Color(220,220,220)," \""..text.."\"")
        return true 
        end,})
--[[
	COMMAND: /r
	DESCRIPTION: Broadcasts a message over the equipped radio's primary frequency.
]]--
ix.command.Add("r", {
	description = "Use the Site Internet!",
	arguments = {
		ix.type.text},
    OnCheckAccess = function(self, client) 
        local HasPhone = client:GetCharacter():GetInventory():HasItem("radio") 
        if (HasPhone) then 
             return true
        end 
        return false 
        end,
	OnRun = function(self, client, text)
      if ix.config.Get("radioEnabled", true) then
		ix.chat.Send(client, "radio", text, false, nil)
        ix.chat.Send(client, "radiochatter", text, false, nil)
		client:EmitSound("npc/metropolice/vo/on" .. 1 .. ".wav", math.random(50, 60), math.random(80, 120))
      else 
        client:ChatNotify("You try to send a message but... It fails!")
      end
    end
    })
ix.command.Add("t", {
	description = "Use your team radio!",
	arguments = {
		ix.type.text},
    OnCheckAccess = function(self, client) 
        local HasPhone = client:GetCharacter():GetInventory():HasItem("radio") 
        local CanUseTeam = ix.faction.Get(client:GetCharacter():GetFaction()).teamRadio
        if (HasPhone) then 
             if !(CanUseTeam == "") then return true end
        end 
        return false 
        end,
	OnRun = function(self, client, text)
      if ix.config.Get("radioEnabled", true) then
		ix.chat.Send(client, "radioTeam", text, false, nil)
        ix.chat.Send(client, "radiochatter", text, false, nil)
		client:EmitSound("npc/metropolice/vo/on" .. 1 .. ".wav", math.random(50, 60), math.random(80, 120))
      else 
        client:ChatNotify("You try to send a message but... It fails!")
      end
    end
    })