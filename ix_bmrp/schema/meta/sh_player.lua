
local PLAYER = FindMetaTable("Player")

function PLAYER:GetFactionName()
	return ix.faction.Get(self:GetCharacter():GetFaction()).name
end

function PLAYER:CanUseRadioSys()
    local client = self

    if (!IsValid(client)) then return false end
    local character = client:GetCharacter()
    
    if (!character) then return false end
    if (!client:Alive()) then return false end
    
    local ClientInv = character:GetInventory()
    local HasPhon = ClientInv:HasItem("radio")
    if HasPhon then 
        return true 
    else 
        return false 
    end
end