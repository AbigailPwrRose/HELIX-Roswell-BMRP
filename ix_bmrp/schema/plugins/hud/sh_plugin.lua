PLUGIN.name = "FancyHUD"
PLUGIN.author = "Rowan From Roswell"
PLUGIN.description = "Displays the FancyHUD."

if (SERVER) then
    AddCSLuaFile("cl_plugin.lua")
    resource.AddFile("materials/fancyhud_armor.png")
end

if (CLIENT) then
    include("cl_plugin.lua")
end