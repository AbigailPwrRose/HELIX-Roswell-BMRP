ITEM.name =  "Weather Report Template"
ITEM.description = "To Be Replaced"
ITEM.category = "misc"
ITEM.model = "models/halflife/gibs/food/envelope1.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 150
ITEM.rarity = "Xen"

if (CLIENT) then
	function ITEM:PopulateTooltip(tooltip)
    end
end

function ITEM:GetName()
	return self:GetData("name", "Xen Weather Report")
end

function ITEM:GetDescription()
    local pressure = self:GetData("pressure","100").." kPa"
    local oxygen = self:GetData("oxygen",227)/10
    local nitrogen = self:GetData("nitrogen",558)/10
    local argon = self:GetData("argon",87)/10
    local Bacterial = self:GetData("airbornBacteria",0)
    local Electrical = self:GetData("staticElectricity",0)
    local Temperature = self:GetData("temper",30)/10
    local Humidity = self:GetData("watercontents",60)/10
    local WindSpeed = self:GetData("windysped", 65)
    local WindDir = self:GetData("windydirection","Station North")
    if Bacterial == 0 then
      Bacterial = "Low"
    elseif Bacterial == 1 then
      Bacterial = "Median"
    elseif Bacterial == 2 then
      Bacterial = "High" end
    if Electrical == 0 then
      Electrical = "Low"
    elseif Electrical == 1 then
      Electrical = "Median"
    elseif Electrical == 2 then
      Electrical = "High" end
    -- Text Compiling
    local report = "A report with data regarding Xen's atmosphere printed onto it.\n \n Pressure; "..pressure.."    Nitrogen%; "..nitrogen.."\n Oxygen%; "..oxygen.."   Argon%; "..argon.."\n Airborn Bacterial Presence; "..Bacterial.."\n Static Electricity in air; "..Electrical
    -- Batch one break  
    report = report.."\n Temp; "..Temperature.."C     Humidity; "..Humidity.."%\n Wind Speed; "..WindSpeed.."kmh\n Wind Direction; "..WindDir
	return report
end
