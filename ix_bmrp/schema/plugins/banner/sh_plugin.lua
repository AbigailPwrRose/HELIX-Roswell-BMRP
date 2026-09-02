PLUGIN.name = "FancyBanner"
PLUGIN.author = "Rowan From Roswell"
PLUGIN.description = "Displays the FancyBanner."

if (SERVER) then
    AddCSLuaFile("cl_plugin.lua")
    include("sv_plugin.lua")
end

if (CLIENT) then
    include("cl_plugin.lua")
end
  
ix.command.Add("banner", {
    description = "Set Banner",
    adminOnly = true,
    arguments = {
        ix.type.string,
        bit.bor(ix.type.text, ix.type.optional)
    },
    argumentNames = {"title/subtitle/clear", "Text"},
    OnRun = function(self, client, BannerConf, Text)
      if BannerConf == "title" then  
        net.Start("FancyHUD_SetTitle")
        net.WriteString(Text)
        net.Broadcast()
      elseif BannerConf == "subtitle" then
        net.Start("FancyHUD_SetSubtitle")
        net.WriteString(Text)
        net.Broadcast()
      elseif BannerConf == "clear" then
        net.Start("FancyHUD_Clear")
        net.Broadcast()
      end
    end,
})