FACTION.name = "Survey Team"
FACTION.description = "The survey team; highly train proffesionals who specialise in exploration of worlds unknown."
FACTION.isDefault = false -- Originally was whitelist only, however I changed it to be default - Bill
FACTION.color = Color(230, 81, 0)
FACTION.pay = 65 -- How much money every member of the faction gets paid at regular intervals.
FACTION.isGloballyRecognized = true -- Makes it so that everyone knows the name of the characters in this faction.
FACTION.teamRadio = "Survey Radio"
FACTION.IsFacility = true

-- Note that FACTION.models is optional. If it is not defined, it will use all the standard HL2 citizen models.
FACTION.models = {
  "models/player/hlew/scientists/alfred_scientist_extended.mdl", "models/player/hlew/scientists/ana_scientist_extended.mdl", "models/player/hlew/scientists/boris_scientist_extended.mdl", "models/player/hlew/scientists/colette_scientist_extended.mdl", "models/player/hlew/scientists/edwart_scientist_extended.mdl", "models/player/hlew/scientists/einstein_scientist_extended.mdl", "models/player/hlew/scientists/eli_scientist_extended.mdl", "models/player/hlew/scientists/gina_scientist_extended.mdl", "models/player/hlew/scientists/gordon_scientist_extended.mdl", "models/player/hlew/scientists/gus_scientist_extended.mdl", "models/player/hlew/scientists/gustavo_scientist_extended.mdl", "models/player/hlew/scientists/jay_scientist_extended.mdl", "models/player/hlew/scientists/jonny_scientist_extended.mdl", "models/player/hlew/scientists/kleiner_scientist_extended.mdl", "models/player/hlew/scientists/kyle_scientist_extended.mdl", "models/player/hlew/scientists/leonel_scientist_extended.mdl", "models/player/hlew/scientists/lorena_scientist_extended.mdl", "models/player/hlew/scientists/luther_scientist_extended.mdl", "models/player/hlew/scientists/magnusson_scientist_extended.mdl", "models/player/hlew/scientists/manuel_scientist_extended.mdl", "models/player/hlew/scientists/marissa_scientist_extended.mdl", "models/player/hlew/scientists/marley_scientist_extended.mdl", "models/player/hlew/scientists/marvin_scientist_extended.mdl", "models/player/hlew/scientists/michael_scientist_extended.mdl", "models/player/hlew/scientists/poly_scientist_extended.mdl", "models/player/hlew/scientists/rosenberg_scientist_extended.mdl", "models/player/hlew/scientists/silvia_scientist_extended.mdl", "models/player/hlew/scientists/slick_scientist_extended.mdl", "models/player/hlew/scientists/tim_scientist_extended.mdl", "models/player/hlew/scientists/yelene_scientist_extended.mdl", "models/player/hlew/scientists/walter_scientist_extended.mdl", "models/player/hlew/scientists/alphafemales/scientist_cross_extended.mdl", "models/player/hlew/scientists/alphafemales/scientist_esther_extended.mdl", "models/player/hlew/scientists/alphafemales/scientist_green_extended.mdl", "models/player/hlew/scientists/alphafemales/scientist_gwen_extended.mdl", "models/player/hlew/scientists/alphafemales/scientist_ptheresa_extended.mdl", "models/player/hlew/scientists/alphafemales/scientist_scarlet_extended.mdl", "models/player/hlew/scientists/fatsci/curtis_scientist_extended.mdl", "models/player/hlew/scientists/fatsci/dario_scientist_extended.mdl", "models/player/hlew/scientists/fatsci/franklin_scientist_extended.mdl", "models/player/hlew/scientists/fatsci/harvey_scientist_extended.mdl", "models/player/hlew/scientists/fatsci/ivan_scientist_extended.mdl", "models/player/hlew/scientists/fatsci/lenny_scientist_extended.mdl", "models/player/hlew/scientists/fatsci/murr_scientist_extended.mdl"
}

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()
    inventory:Add("radio", 1)
    character:JoinClass(21)
end
function FACTION:OnTransferred(character)
    character:JoinClass(21)
end

FACTION.Ranks = {
	[1] = {"Junior Surveyor", nil, nil, nil, 3600, -15},
	[2] = {"Surveyor", nil, nil, nil, 21600, 0},
	[3] = {"Senior Surveyor", nil, nil, nil, nil, 10},
	[4] = {"Expedition Lead", "icon16/medal_silver_1.png", nil, true, nil, 15},
	[5] = {"Survey Director", "icon16/medal_gold_1.png", nil, true, nil, 35},
}
FACTION_SURVEY = FACTION.index