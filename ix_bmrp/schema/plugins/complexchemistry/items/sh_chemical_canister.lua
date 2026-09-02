ITEM.name = "Chemical Canister"
ITEM.description = "A small canister that can contain upto 1 liter of a chemical.\n \n Due to its size, it cannot be used to move chemicals into stations or other containers, but can be used to store more chemicals in an inventory."
ITEM.category = "Tools"
ITEM.rarity = "Uncommon"
ITEM.model = "models/props_industrial/gascanister01.mdl"
ITEM.width = 2
ITEM.height = 3
ITEM.IsFlask = true
ITEM.FlaskMax = 1000
ITEM.price = 25
if (CLIENT) then
	function ITEM:Paint(item, w, h)
		if (item:GetData("Chemical",0) != 0) and (ix.chemistry.List[item:GetData("Chemical")]) then
        	surface.SetDrawColor(60, 60, 60, 85)
        	surface.DrawRect(2, 2, w - 4, h - 4) 
            local ChemColor = ix.chemistry.List[item:GetData("Chemical")][3]
        	surface.SetDrawColor(ChemColor,250)
        	surface.DrawRect(6, 6, w - 12, h - 12) 
		end
	end
	function ITEM:PopulateTooltip(tooltip)
		local name = tooltip:GetRow("name")
		name:SetBackgroundColor(Color(230,230,230))
        
    	local vol = tooltip:AddRow("Contains")
    	vol:SetBackgroundColor(Color(99,99,99,20))
    	vol:SetFont("DermaDefault")
        if (self:GetData("Chemical",0) != 0 ) and (ix.chemistry.List[self:GetData("Chemical")]) then
        	vol:SetText("This canister contains ".. self:GetData("Volume", 0) .."ml of "..ix.chemistry.List[self:GetData("Chemical")][1]) 
        else
        	vol:SetText("This canister is empty") 
        end
    	vol:SizeToContents()
    end
end

function ITEM:GetName()
    local Chem = self:GetData("Chemical", 0)
    local Name = "Chemical Canister"
    if (Chem != 0) and (ix.chemistry.List[Chem]) then
      Name = "Canister of "..ix.chemistry.List[Chem][1] 
    end
	return Name
end

ITEM.functions.combine = {
	OnRun = function(item, data)
    local item2 = ix.item.instances[data[1]]
    local TargOne = item:GetData("Volume",0) + item2:GetData("Volume",0)
    local TargTwo = TargOne - item.FlaskMax
    item:SetData("Volume",math.Clamp(TargOne,0,item.FlaskMax))
    item2:SetData("Volume",math.Clamp(TargTwo,0,item2.FlaskMax))
    item:SetData("Chemical",item2:GetData("Chemical",1))
    if item2:GetData("Volume",0) <= 0 then 
      item2:SetData("Chemical",0)
    end
		return false
	end,
	OnCanRun = function(item, data)
    local Item2Table = ix.item.instances[data[1]]
    if Item2Table.IsFlask == true then
      if item:GetData("Chemical",0) == 0 or item:GetData("Chemical",0) == Item2Table:GetData("Chemical",0) then
        if Item2Table:GetData("Volume",0) > 0 and item:GetData("Volume",0) < item.FlaskMax then 
		      return true
        end
      end
    end
    return false 
	end
}