ITEM.name = "Fuel Canister"
ITEM.description = "A chemical canister designed specifically to hold fuel. When filled with Liquid Echirus or Energy, can be inserted into a reactor input in exchange for cash."
ITEM.category = "Tools"
ITEM.rarity = "Uncommon"
ITEM.model = "models/props_industrial/welder.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.IsFlask = true
ITEM.FlaskMax = 500
ITEM.price = 45

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
        	vol:SetText("This canister contains ".. self:GetData("Volume", 0) .."ml of "..ix.chemistry.List[self:GetData("Chemical")][1].." out of "..self.FlaskMax.."ml") 
        else
        	vol:SetText("This canister is empty") 
        end
    	vol:SizeToContents()
    end
end

function ITEM:GetName()
    local Chem = self:GetData("Chemical", 0)
    local Name = "Fuel Canister"
    if (Chem != 0) and (ix.chemistry.List[Chem]) then
      Name = "Fuel Canister of "..ix.chemistry.List[Chem][1] 
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

ITEM.functions.HPutIntoReactor = {
    name = "Connect to Intake",
    tip = "Add",
    icon = "icon16/arrow_up.png",
    OnRun = function(item)
        if !(CLIENT) then
            local client = item.player
            local character = client:GetCharacter()
            local trace = client:GetEyeTraceNoCursor()
            local targEnt = trace.Entity
            local Chem = item:GetData("Chemical", 0)
            local Vol = item:GetData("Volume", 0)
            if IsValid(targEnt) and targEnt:GetClass() == "echirus_reactor" then	
                if (Chem == 38 or Chem == 40 or Chem == 33) and Vol > 0 then
                    local CM = 0
                    if Chem == 38 then CM = 1
                    elseif Chem == 40 then CM = 2
                    elseif Chem == 33 then CM = 1.2 end
                    local CashAdd = Vol * CM
                    client:ChatNotify("You insert the canister into a plug. It drains of liquid before your notified of "..CashAdd.." credits being transferred into your account")
                    character:SetMoney(character:GetMoney() + CashAdd)
                    item:SetData("Chemical", 0)
                    item:SetData("Volume", 0)
                end
            end
        end
        return false
    end,
    OnCanRun = function(item)
        local ply = item.player 
        local trace = ply:GetEyeTraceNoCursor()
        local targEnt = trace.Entity
        local Chem = item:GetData("Chemical", 0)
        local Vol = item:GetData("Volume", 0)
        local targName = targEnt:GetVar("ClassName")
        if IsValid(targEnt) and targEnt:GetClass() == "echirus_reactor" then	
            if (Chem == 38 or Chem == 40 or Chem == 33) and Vol > 0 then
                return true
            end
        end
        return false
    end
}