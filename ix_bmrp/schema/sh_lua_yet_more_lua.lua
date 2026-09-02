-- They call me Wing Ding Miku
-- Instead of hiding in your wifi I hide in your lua
-- Also I create dark fountains

ix.command.Add("Event", {
	description = "@cmdEvent",
	arguments = ix.type.text,
	superAdminOnly = true,
	OnRun = function(self, client, text)
            ix.chat.Send(client, "event", text)
            hook.Run("eventLogToRelay", {
                    text = text,
                })
	end
})
ix.command.Add("SiteIntercom", {
	description = "@cmdEvent",
	arguments = ix.type.text,
	AdminOnly = true,
	OnRun = function(self, client, text)
            ix.chat.Send(client, "intercomUse", text)
            for k, v in pairs(player.GetAll()) do
            	netstream.Start(v, "playIntercomBuzz")
            end
            hook.Run("event_IntercommUse", {
                    text = text,
                })
	end
})
ix.chat.Register("intercomUse", { -- Sets up and registers the radio chat.
        indicator = "chatTalking",
        CanHear = function(self, speaker, listener)
            return true
        end,
        OnChatAdd = function(self, speaker, text)
            chat.AddText(Color(225, 225, 225), "[A voice over the InterCom] ",Color(0, 155, 235)," \""..text.."\"")
            return true 
        end,
    })

