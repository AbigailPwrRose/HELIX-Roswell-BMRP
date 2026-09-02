FACTION.name = "Site Maintenance"
FACTION.description = "From engineers and technicians, to chefs and janitors, Site Maintenance keep the facility running."
FACTION.isDefault = true
FACTION.color = Color(235, 167, 0)
FACTION.pay = 35 -- How much money every member of the faction gets paid at regular intervals.
FACTION.isGloballyRecognized = true -- Makes it so that everyone knows the name of the characters in this faction.
FACTION.teamRadio = "BM.SiMa"
FACTION.IsFacility = true
FACTION.weapons = {"cameras_wrench"}
FACTION.IsMaintenance = true

-- Note that FACTION.models is optional. If it is not defined, it will use all the standard HL2 citizen models.
FACTION.models = {
	"models/player/hlew/workers/boris_chef_extended.mdl", "models/player/hlew/workers/irons_chef_extended.mdl", "models/player/hlew/workers/jared_chef_extended.mdl", "models/player/hlew/workers/larry_chef_extended.mdl", "models/player/hlew/workers/lars_chef_extended.mdl", "models/player/hlew/workers/janitor_classic_extended.mdl", "models/player/hlew/workers/janitor_dan_extended.mdl", "models/player/hlew/workers/janitor_louis_extended.mdl", "models/player/hlew/workers/janitor_mike_extended.mdl", "models/player/hlew/workers/janitor_tremors_extended.mdl", "models/player/hlew/workers/edwart_worker_extended.mdl", "models/player/hlew/workers/gus_worker_extended.mdl", "models/player/hlew/workers/paul_worker_extended.mdl", "models/player/hlew/workers/robin_worker_extended.mdl", "models/player/hlew/workers/wallace_worker_extended.mdl", "models/player/hlew/workers/wexler_worker_extended.mdl"
}

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()
    inventory:Add("radio", 1)
end


FACTION.Ranks = {
	[1] = {"Junior Staffer", nil, nil, nil, 600,-15},
	[2] = {"Staffer", nil, nil, nil, 3600,0},
	[3] = {"Senior Staffer", nil, nil,nil,nil,25},
	[4] = {"Sector Staff Supervisor", "icon16/medal_silver_1.png", nil, true,nil,65},
	[5] = {"Maintenance Director", "icon16/medal_gold_1.png", nil, true,nil,85},
}
FACTION_MAINTENANCE = FACTION.index