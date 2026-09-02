ITEM.name = "Flask"
ITEM.description = "Replace"
ITEM.category = "Tools"
ITEM.rarity = "Uncommon"
ITEM.model = "models/winter_chemistry_props/beaker01b.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.IsFlask = true
ITEM.FlaskMax = 200
ITEM.price = 10

---- Inv Render

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
        if self:GetData("Volume",0) > 0 then 
            local VolShow = tooltip:AddRow("Rarity")
            VolShow:SetBackgroundColor(Color(99,99,99,20))
            VolShow:SetText(self:GetData("Volume",0).."ml of "..ix.chemistry.List[self:GetData("Chemical", 0)][1] )
            VolShow:SetFont("DermaDefault")
            VolShow:SizeToContents() 
        end
    end
end

function ITEM:GetName()
    local Chem = self:GetData("Chemical", 0)
    local Name = self.FlaskMax.."ml Flask"
    if (Chem != 0) and (ix.chemistry.List[Chem]) then
      Name = "Flask of "..ix.chemistry.List[Chem][1] 
    end
	return Name
end

function ITEM:GetDescription()
	return "This is a chemical flask, which can be used to store and transport upto ".. self.FlaskMax .."ml of chemicals."
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

---- Functions Galore!
ITEM.functions.AADrink = {
    name = "Drink",
    tip = "myFunctionDescription",
    icon = "icon16/user_go.png",
    OnRun = function(item)
        local client = item.player
        ix.chemistry.ApplyChem(client,item:GetData("Chemical", 0))
        item:SetData("Volume", item:GetData("Volume", 0)-100)
        if item:GetData("Volume", 0) <= 0 then
          item:SetData("Chemical", 0)
          item:SetData("Volume",0)
        end
        return false
    end,
    OnCanRun = function(item)
        local Chem = item:GetData("Chemical", 0)
        local Vol = item:GetData("Volume", 0)
        if Chem != 0 and Vol >= 100 then
            return true
        else
            return false
        end
    end
}
ITEM.functions.AddToStorage = {
  name = "Add to Container",
  tip = "Add",
  icon = "icon16/arrow_up.png",
  OnRun = function(item)
    if !(CLIENT) then
      local client = item.player
      local trace = client:GetEyeTraceNoCursor()
      local targEnt = trace.Entity
      local Chem = item:GetData("Chemical", 0)
      local Vol = item:GetData("Volume", 0)
      local STarg = 0
      if targEnt.IsChemicalSystem == true and ix.chemistry.List[Chem] and Chem != 0 and !targEnt:GetNW2Var("Processing",false) then
        local targChemTable = targEnt:GetVar("NewChemTable",{}) 
        if targChemTable != {} then
          for k,v in pairs(targChemTable) do
            if (v[1][1] == 0) and v[2] == true and STarg == 0 then
              STarg = k
            elseif (v[1][1] == Chem and v[1][2] < targEnt.MaxVol) and v[2] == true and STarg == 0 then
              STarg = k
            end
          end 
          if STarg != 0 then
            targChemTable[STarg][1][1] = Chem
            local targNewVolume = targChemTable[STarg][1][2] + item:GetData("Volume",0)
            local excess = targNewVolume - targEnt.MaxVol
            targChemTable[STarg][1][2] = math.Clamp(targNewVolume,0,targEnt.MaxVol)
            targEnt:SetVar("NewChemTable",targChemTable) 
            item:SetData("Volume",math.Clamp(excess,0,200))
            if item:GetData("Volume", 0) == 0 then 
              item:SetData("Chemical", 0)  
            end
          end
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
    local targName = targEnt:GetVar("ClassName")
    if targEnt:GetVar("IsChemicalSystem",false) == true and ix.chemistry.List[Chem] and Chem != 0 and !targEnt:GetNW2Var("Processing",false) then
      local targChemTable = util.JSONToTable(targEnt:GetNW2String("ChemTable"))
      if targChemTable != {} and targChemTable != nil then
        for k,v in pairs(targChemTable) do
          if (v[1][1] == 0) and v[2] == true then
            return true
          elseif (v[1][1] == Chem and v[1][2] < targEnt:GetVar("MaxVol",0)) and v[2] == true then
            return true
          end
        end 
      end 
    end
    return false
  end
}

ITEM.functions.ATakeFromStorage = {
  name = "Take from Container",
  tip = "myFunctionDescription",
  icon = "icon16/arrow_down.png",
  OnRun = function(item)
    if !(CLIENT) then
      local client = item.player
      local trace = client:GetEyeTraceNoCursor()
      local targEnt = trace.Entity
      local Chem = item:GetData("Chemical", 0)
      local Vol = item:GetData("Volume", 0)
      local STarg = 0
      if targEnt.IsChemicalSystem == true and !targEnt:GetNW2Var("Processing",false) then
        local targChemTable = targEnt:GetVar("NewChemTable",{}) 
        if targChemTable != {} then
          for k,v in pairs(targChemTable) do
            if (v[1][1] != 0 and Chem == 0 and v[1][2] > 0)  and v[3] == true then
              STarg = k
            elseif (v[1][1] == Chem and v[1][2] > 0) and v[3] == true then
              STarg = k
            end
          end 
          if STarg != 0 then
            local TargetForItem = item:GetData("Volume",0) + targChemTable[STarg][1][2]
            local ExcessForItem = item.FlaskMax-TargetForItem
            item:SetData("Chemical", targChemTable[STarg][1][1])
            item:SetData("Volume",math.Clamp(TargetForItem,0,item.FlaskMax))
            targChemTable[STarg][1][2] = math.Clamp(0-ExcessForItem,0,targEnt:GetVar("MaxVol"))
            targEnt:SetVar("NewChemTable",targChemTable) 
            if targEnt.OnChemicalsTake then 
              targEnt:OnChemicalsTake()
            end
          end
        end
      end
    end
    return false
  end,
  OnCanRun = function(item)
    local ply = item.player 
    local ply = item.player 
    local trace = ply:GetEyeTraceNoCursor()
    local targEnt = trace.Entity
    local targName = targEnt:GetVar("ClassName")
    if targEnt:GetVar("IsChemicalSystem",false) == true and !targEnt:GetNW2Var("Processing",false) then
      local targChemTable = util.JSONToTable(targEnt:GetNW2String("ChemTable"))
      local Chem = item:GetData("Chemical",0)
      if targChemTable != {} and targChemTable != nil then
        local CanTake = false
        for k,v in pairs(targChemTable) do
          if (v[1][1] != 0 and Chem == 0 and v[1][2] > 0) and v[3] == true then
            CanTake =true
          elseif (v[1][1] == Chem and v[1][2] > 0) and v[3] == true then
            CanTake = true
          end
        end 
        if CanTake and (item:GetData("Volume",0)<item.FlaskMax) then
          return true
        end
      end 
    end
    return false 
  end
}
---------- GET WATER -------------------------------
ITEM.functions.GetWater = {
    name = "Fill with Water",
    tip = "Scoop up some water into your flask",
    icon = "icon16/arrow_turn_right.png",
    OnRun = function(item)
        local client = item.player
        local entity = item.entity
        item:SetData("Chemical", 1)
        item:SetData("Volume", item.FlaskMax)
        return false
    end,
    OnCanRun = function(item)
        local client = item.player
        local EyePos = client:GetEyeTraceNoCursor().HitPos
        if IsValid(client) then
          if (item:GetData("Chemical", 0) == 0 or (item:GetData("Chemical", 0) == 1 and item:GetData("Volume", 0) < item.FlaskMax)) then 
            local Area = client:GetArea()
            if ix.chemistry.CollectionZone["Water"][Area] then
              return true 
            end
          end
        end 
        return false
    end
}

ITEM.functions.GetXenWaterSafe = {
    name = "Fill with Xen Water",
    tip = "Scoop up some xen water into your flask",
    icon = "icon16/arrow_turn_right.png",
    OnRun = function(item)
        local client = item.player
        local entity = item.entity
        item:SetData("Chemical", 22)
        item:SetData("Volume", math.Clamp(item.FlaskMax,0,item.FlaskMax))
        return false
    end,
    OnCanRun = function(item)
        local client = item.player
        if IsValid(client) then
          if (item:GetData("Chemical", 0) == 0 or (item:GetData("Chemical", 0) == 22 and item:GetData("Volume", 0) < item.FlaskMax)) then 
            local Area = client:GetArea()
            if ix.chemistry.CollectionZone["XenWaterSafe"][Area] then 
              return true 
            end
          end
        end 
        return false
    end
}
ITEM.functions.GetAcid = {
    name = "Fill with Acid",
    tip = "Scoop up some acid into your flask",
    icon = "icon16/arrow_turn_right.png",
    OnRun = function(item)
        local client = item.player
        local entity = item.entity
        item:SetData("Chemical", 21)
        item:SetData("Volume", math.Clamp(item.FlaskMax,0,item.FlaskMax))
        return false
    end,
    OnCanRun = function(item)
        local client = item.player
        if IsValid(client) then
          if (item:GetData("Chemical", 0) == 0 or (item:GetData("Chemical", 0) == 21 and item:GetData("Volume", 0) < item.FlaskMax)) then 
            local Area = client:GetArea()
            if ix.chemistry.CollectionZone["ToxicSludge"][Area] then 
              return true 
            end
          end
        end 
        return false
    end
}
ITEM.functions.XEmptyFlask = {
    name = "Empty Flask",
    tip = "myFunctionDescription",
    icon = "icon16/arrow_inout.png",
    OnRun = function(item)
        local client = item.player
        local entity = item.entity
        item:SetData("Chemical", 0)
        item:SetData("Volume", 0)
        return false
    end,
    OnCanRun = function(item)
        local Chem = item:GetData("Chemical", 0)
        if Chem != 0 then
            return true
        else
            return false
        end
    end
}