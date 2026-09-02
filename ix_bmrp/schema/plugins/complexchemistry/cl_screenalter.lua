-- Temp
local PLUGIN = PLUGIN

function PLUGIN:PreDrawHUD()
    local client = LocalPlayer()
    
    if (!IsValid(client)) then return end
    local character = client:GetCharacter()
    if (!character) then return end
    if (!client:Alive()) then return end
    
    if character:GetData("ChemSystem_Meth",0) > 0 then
        surface.SetDrawColor( 255, 255, 255, 255*(character:GetData("ChemSystem_Meth",0)/100)-50 )
        surface.SetMaterial( Material("gui/colors_dark.png", "noclamp smooth") )
        surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
    end
    
end
    