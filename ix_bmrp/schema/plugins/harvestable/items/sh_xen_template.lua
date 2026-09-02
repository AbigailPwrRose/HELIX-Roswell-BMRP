ITEM.name =  "Xennium Crystal Template"
ITEM.description = "To Be Replaced"
ITEM.category = "Ores"
ITEM.model = "models/props/xenprops/crystal3.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.price = 1000
ITEM.rarity = "Xen"

if (CLIENT) then
	function ITEM:PopulateTooltip(tooltip)
    end
end

function ITEM:GetName()
	return self:GetData("name", "Xennium Crystal Template")
end

function ITEM:GetModel()
	return self:GetData("model", "models/props/xenprops/crystal3.mdl")
end

function ITEM:GetDescription()
    local CN = self:GetData("customid","No Assigned Name")
    local R1 = self:GetData("xen_resonance_confirmed",false)
    local R2 = self:GetData("xen_full_confirmed",false)
    local purity = self:GetData("xenpurity",0)
    local stab = self:GetData("xenstability",0)
    local resonance = self:GetData("xenresonance",0)
    if R1 != true and R2 != true then
      resonance = "Unknown"
    else
      resonance = resonance.."Rf"
    end
    if R1 != true and R2 != true then
      purity = "Unknown"
      stab = "Unknown"
    else
      purity = purity.."%"
      stab = stab.."%"
    end
    if CN == "No Assigned Name" then
      CN = ""
    else
      CN = "Designation: "..CN.."\n " end
    local XenReport = "An orange xen crystal that hums with energy. \n \n "..CN.."Resonance: "..resonance.."\n Purity: "..purity.."\n Stability: "..stab
	return XenReport
end
