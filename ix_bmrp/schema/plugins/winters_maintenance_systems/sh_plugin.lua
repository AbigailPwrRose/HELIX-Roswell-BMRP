local PLUGIN = PLUGIN

PLUGIN.name = "Winters Maintenance Systems"
PLUGIN.description = "Adds several features to make maintenance gameplay more entertaining."
PLUGIN.author = "Winter"

ix.config.Add("ixDecayTickTime", 60, "How many seconds between each tick of the repairables.",
	function(oldValue, newValue)
	end,
	{
		data = {min = 20, max = 120},
		category = "maintenanceSystems"
	}
)

ix.config.Add("ixAutoRepairTime", 20, "How many minutes before a repairable auto-fixes.",
	function(oldValue, newValue)
	end,
	{
		data = {min = 5, max = 60},
		category = "maintenanceSystems"
	}
)

ix.config.Add("ixDisableDecay", false, "Turn off the decay system",
	function(oldValue, newValue)
        	if newValue == true then
                for _, v in ents.Iterator() do
                    if v.DoesDecay == true and v:GetNW2Bool("Broken",false) then
                    	v:DoRepair()
                    end
                end 
            end
	end,
	{
		category = "maintenanceSystems"
	}
)

ix.lang.AddTable("english", {
	ShowMaintenanceTasks = "Show Maintenance Tasks",
})

ix.option.Add("showMaintenanceTasks", ix.type.bool, true, {
	category = "General",
    description = "Show on the HUD where active maintenance tasks are.",
})

if (CLIENT) then
	netstream.Hook("clientStartMaintenance_TypeOne", function(id)
		local Maintenance = vgui.Create("MaintenancePanel_TypeOne")
		Maintenance:SetText(id)
	end)
	netstream.Hook("clientStartMaintenance_TypeTwo", function(id)
		local Maintenance = vgui.Create("MaintenancePanel_TypeTwo")
		Maintenance:SetText(id)
	end)
	netstream.Hook("clientStartMaintenance_TypeThree", function(id)
		local Maintenance = vgui.Create("MaintenancePanel_TypeThree")
		Maintenance:SetText(id)
	end)
else
	netstream.Hook("clientEndMaintenance", function(client, id, Tpattern, Ipattern,Severity)
		local Checked = true
		for k,v in pairs(Tpattern) do
                if v != Ipattern[k] then
                    Checked = false
                end
		end
        if Checked == true then 
			client:Notify("You complete repairs on "..Entity(id).PrintName.."\nYou've recieved 55 dollars compensation.")
            client:GetCharacter():SetMoney(client:GetCharacter():GetMoney()+55)
            Entity(id):DoRepair()
        else
				client:Notify("You failed to repair "..Entity(id).PrintName)
				if Severity == 1 then
                    client:ChatNotify("You gasp in pain, an arc of electricity rising up and striking you.")
                    client:TakeDamage(35,Entity(id))
                end
        end
	end)
	netstream.Hook("clientEndMaintenance_Type3", function(client, id, Success)
        if Success == true then 
			client:Notify("You complete repairs on "..Entity(id).PrintName.."\nYou've recieved 100 dollars compensation.")
            client:GetCharacter():SetMoney(client:GetCharacter():GetMoney()+55)
            Entity(id):DoRepair()
        else
				client:Notify("You failed to repair"..Entity(id).PrintName)
            	if math.random(1,5) == 5 then 
                    client:ChatNotify("You gasp in pain, as a boiling liquid is sprayed onto your hands.")
                    client:TakeDamage(15,Entity(id))
                end
        end
	end)
end

---- Big ol Ccmmand stuff -------------------------------
ix.command.Add("InstantBreak", {
    description = "Instantly break any repairable the user is looking at",
    adminOnly = true,
    arguments = {},
    OnRun = function(self, client)
            if (SERVER) then
                local target = client:GetEyeTrace().Entity
                if IsValid(target) and target.DoesDecay == true then
                    for i = 1,target.Durability do 
                        target:DoDecay()
                    end
                end 
            end
    end
})
ix.command.Add("InstantRepair", {
    description = "Instantly repair any repairable the user is looking at",
    adminOnly = true,
    arguments = {},
    OnRun = function(self, client)
            if (SERVER) then
                local target = client:GetEyeTrace().Entity
                if IsValid(target) and target.DoesDecay == true then
                    target:DoRepair()
                end 
            end
    end
})
ix.command.Add("RepairAll", {
    description = "Instantly repair all repairables.",
    adminOnly = true,
    arguments = {},
    OnRun = function(self, client)
            if (SERVER) then
                for _, v in ents.Iterator() do
                    if v.DoesDecay then
                    	v:DoRepair()
                    end
                end 
            end
    end
})
ix.command.Add("BreakAll", {
    description = "Instantly repair all repairables.",
    adminOnly = true,
    arguments = {},
    OnRun = function(self, client)
            if (SERVER) then
                for _, v in ents.Iterator() do
                    if v.DoesDecay then
                    	for i = 1,v.Durability do 
                        	v:DoDecay()
                    	end
                    end
                end 
            end
    end
})
---- Big ol hud stuff -------------------------------
function PLUGIN:HUDPaint()
    local client = LocalPlayer()
    local scrW, scrH = ScrW(), ScrH()
	local dimDistance = -1
    if (!client:GetCharacter()) then return end
    if (!client:Alive()) then return end
    if (IsValid(ix.gui.menu)) then return end
    local IsMaintenance = ix.faction.Get(client:Team()).IsMaintenance or false
    if (ix.option.Get("showMaintenanceTasks") and IsMaintenance) then
        for _, v in ents.Iterator() do
            local Check=v.DoesDecay or false
            if (Check and v:GetNW2Bool("Broken",false)) then
                local entities = k2
                local entcolor = v2
                local screenPosition = v:GetPos():ToScreen()
                local marginX, marginY = scrH * .1, scrH * .1
                local x2, y2 = math.Clamp(screenPosition.x, marginX, scrW - marginX), math.Clamp(screenPosition.y, marginY, scrH - marginY)
                local distance = client:GetPos():Distance(v:GetPos())
                local factor = 1 - math.Clamp(distance / dimDistance, 0, 1)
                local size2 = math.max(10, 32 * factor)
                local alpha2 = math.max(255 * factor, 80)
                surface.SetMaterial(Material( "icon16/error.png", "noclamp smooth" ))
                surface.SetDrawColor( color_white )
                surface.DrawTexturedRect( x2, y2-size2, 32, 32 )
                --ix.util.DrawText("[Task - "..v.TaskName.."]", x2, y2 - size2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha2)
            end
        end
    end
end