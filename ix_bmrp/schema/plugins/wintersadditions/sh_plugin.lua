local PLUGIN = PLUGIN

PLUGIN.name = "Winters Advanced Additions"
PLUGIN.author = "Winter Rose"
PLUGIN.description = "Several notable additions"

ix.util.Include("cl_plugin.lua")

ix.char.RegisterVar("fakejob", {
		field = "fakejob",
		fieldType = ix.type.text,
		default = "",
		bNoDisplay = true
})

ix.command.Add("Discord", {
    arguments = {},
    description = "Get the discord link.",
    OnCheckAccess = function() return true end,
    OnRun = function(self, client)
        client:ChatNotify("Our Discord can be found at https://discord.gg/8VRn8h4UpQ")
    end}
)
ix.command.Add("ContentPack", {
    arguments = {},
    description = "Get the content pack.",
    OnCheckAccess = function() return true end,
    OnRun = function(self, client)
        client:ChatNotify("Link; https://steamcommunity.com/sharedfiles/filedetails/?id=3602294837")
    end}
)
ix.command.Add("GlobalClearDecals", {
    arguments = {},
    description = "Clears all decals",
    adminOnly = true,
    OnRun = function(self, client)
      for _, a in ipairs(player.GetAll()) do
        a:ConCommand( "r_cleardecals" ) 
      end
    end}
)
ix.command.Add("ClearDecals", {
    arguments = {},
    description = "Clears all decals",
    OnCheckAccess = function() return true end,
    OnRun = function(self, client)
      client:ConCommand( "r_cleardecals" ) 
    end}
)
ix.command.Add("Suicide", {
    arguments = {},
    description = "Kill yourself NOW.",
    OnCheckAccess = function() return true end,
    OnRun = function(self, client)
        client:Kill()
    end}
)
  
function PLUGIN:PopulateCharacterInfo(client, character, tooltip) 
    local rowClass = tooltip:AddRowAfter("name", "class")
    local class = ix.class.Get(character:GetClass())
    local classDisplay = ""
    if class == nil then
        classDisplay = "NoClassSet"
    else
        classDisplay = class.name
    end

    local fakeJob = character:GetFakejob()
    if fakeJob != "" then 
      fakeJob = " | " .. fakeJob
    end
  
    rowClass:SetText("| " .. classDisplay .. fakeJob .. " |") 
    rowClass:SetBackgroundColor(team.GetColor(client:Team()), rowRank)
    rowClass:SizeToContents()
end

ix.command.Add("CharPromote", {
    arguments = {
        ix.type.player
    },
    description = "Promote a character by one level.",
    adminOnly = true,
    OnRun = function(self, client, target)
        local factionTable = ix.faction.Get(target:Team())
        local rankTable = factionTable.Ranks
        local character = target:GetCharacter()
   		local rank = character:GetRank()+1

        if not rankTable or not rankTable[rank] or not isnumber(rank) or (rank > #rankTable) then return client:NotifyLocalized("undefinedRank") end

        if rankTable[rank][3] then
            local class = ix.class.list[rankTable[rank][3]]
            character:SetClass(class.index)
        end

        character:SetRank(rank)
        client:NotifyLocalized("You promoted %s to the rank of %s", target:Name(), rankTable[rank][1])
        target:NotifyLocalized("You were promoted to the rank %s", rankTable[rank][1])
    end
})

ix.command.Add("CharGiveMoney", {
    arguments = {
        ix.type.character,
        ix.type.number
    },
    description = "Adds the given number to a .",
    adminOnly = true,
    OnRun = function(self, client, target, amount)
        target:GiveMoney(amount)
        client:NotifyLocalized("You gave %s %s dollars", target:GetName(), amount)
        target:NotifyLocalized("You have gained %s dollars", amount)
    end
})

ix.command.Add("CharDemote", {
    arguments = {
        ix.type.player
    },
    description = "Demote a character by one level.",
    adminOnly = true,
    OnRun = function(self, client, target)
        local factionTable = ix.faction.Get(target:Team())
        local rankTable = factionTable.Ranks
        local character = target:GetCharacter()
   		local rank = character:GetRank()-1

        if not rankTable or not rankTable[rank] or not isnumber(rank) or (rank > #rankTable) then return client:NotifyLocalized("undefinedRank") end

        if rankTable[rank][3] then
            local class = ix.class.list[rankTable[rank][3]]
            character:SetClass(class.index)
        end

        character:SetRank(rank)
        client:NotifyLocalized("You demoted %s to the rank of %s", target:Name(), rankTable[rank][1])
        target:NotifyLocalized("You were demoted to the rank %s", rankTable[rank][1])
    end
})

ix.command.Add("Inform", {
    arguments = {
        ix.type.player,
        ix.type.text
    },
	argumentNames = {"The Target", "Message"},
    description = "Give a character a subtle message",
    adminOnly = true,
    OnRun = function(self, client, target, message)
            target:ChatNotify(message)
            client:ChatNotify("You inform " .. target:GetName() .. ": " .. message)
            end
})

ix.command.Add("Name", {
    arguments = {
        ix.type.text
    },
	argumentNames = {"New Name"},
    OnCheckAccess = function() return true end,
    description = "Change your name!",
    OnRun = function(self, client, name)
      if string.len(name) < 3 then
        client:ChatNotify("Your name must be atleast 3 characters long")
        return false
      else 
        client:GetCharacter():SetName(name)
      end 
    end
})

ix.command.Add("Job", {
    arguments = {
        ix.type.text
    },
	argumentNames = {"Job title"},
    OnCheckAccess = function() return true end,
    description = "Give yourself a custom job title",
    OnRun = function(self, client, Inputt)
      if string.len(Inputt) == 0 then
        client:GetCharacter():SetFakejob("")
        client:ChatNotify("You have removed your job title")
      elseif string.len(Inputt) < 3 then
        client:ChatNotify("Input must be atleast 3 characters long")
        return false
      elseif string.len(Inputt) > 25 then
        client:ChatNotify("Input cannot be longer than 25 characters")
        return false
      else 
        client:GetCharacter():SetFakejob(Inputt)
        client:ChatNotify("Your title has been set!")
      end 
    end
})

ix.command.Add("ClearJob", {
    arguments = {
    },
	argumentNames = {},
    OnCheckAccess = function() return true end,
    description = "Clear your job title.",
    OnRun = function(self, client)
        client:GetCharacter():SetFakejob("")
        client:ChatNotify("You have removed your job title")
    end
})

ix.command.Add("CharClearJob", {
    arguments = {
      ix.type.character
    },
	argumentNames = {"Target"},
    adminOnly = true,
    description = "Clear someones job title.",
    OnRun = function(self, client, target)
        target:SetFakejob("")
        target:GetPlayer():Notify("You have had your job title removed")
        client:Notify("You have removed "..target:GetName().."'s your job title")
    end
})

ix.command.Add("Job", {
    arguments = {
        ix.type.text
    },
	argumentNames = {"Job title"},
    OnCheckAccess = function() return true end,
    description = "Give yourself a custom job title",
    OnRun = function(self, client, Inputt)
      if string.len(Inputt) == 0 then
        client:GetCharacter():SetFakejob("")
        client:ChatNotify("You have removed your job title")
      elseif string.len(Inputt) < 3 then
        client:ChatNotify("Input must be atleast 3 characters long")
        return false
      elseif string.len(Inputt) > 25 then
        client:ChatNotify("Input cannot be longer than 25 characters")
        return false
      else 
        client:GetCharacter():SetFakejob(Inputt)
        client:ChatNotify("Your title has been set!")
      end 
    end
})

ix.chat.Register("globalme", {
	format = "** %s %s",
	color = ix.config.Get("chatColor"),
	CanHear = function(self, speaker, listener) return true end,
	prefix = {"/GlobalMe", "/GMe"},
	description = "A /me that can be seen by everyone on the map. Abuse will be punished!",
	indicator = "chatPerforming",
	deadCanChat = true
})

ix.chat.Register("globalit", {
        OnChatAdd = function(self, speaker, text)
            chat.AddText(ix.config.Get("chatColor"), "* "..text)
        end,
		CanHear = function(self, speaker, listener) return true end,
        prefix = {"/GlobalIt","/GIt"},
        description = "A /it that can be seen by everyone on the map. Abuse will be punished!",
        indicator = "chatPerforming",
        deadCanChat = true,
})

ix.command.Add("CharTransfer", {
    description = "@cmdPlyTransfer",
    adminOnly = true,
    arguments = {
        ix.type.character,
        ix.type.text
    },
    OnRun = function(self, client, target, name)
        local faction = ix.faction.teams[name]

        if (!faction) then
            for _, v in pairs(ix.faction.indices) do
                if (ix.util.StringMatches(L(v.name, client), name)) then
                    faction = v

                    break
                end
            end
        end

        if (faction) then
            target.vars.faction = faction.uniqueID
            target:SetFaction(faction.index)

            if (faction.OnTransferred) then
                faction:OnTransferred(target)
            end

            for _, v in ipairs(player.GetAll()) do
                if (self:OnCheckAccess(v) or v == target:GetPlayer()) then
                    v:NotifyLocalized("cChangeFaction", client:GetName(), target:GetName(), L(faction.name, v))
                end
            end
        else
            return "@invalidFaction"
        end
    end
})