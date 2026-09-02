-- Since this faction is not a default, any player that wants to become part of this faction will need to be manually
-- whitelisted by an administrator.

FACTION.name = "Black Mesa Administration"
FACTION.description = "Black Mesa's administration, from clerks and accountants to the sites highest echelons."
FACTION.isDefault = true
FACTION.color = Color(87, 75, 97)
FACTION.pay = 75 -- How much money every member of the faction gets paid at regular intervals.
FACTION.isGloballyRecognized = true -- Makes it so that everyone knows the name of the characters in this faction.
FACTION.teamRadio = "BM.Admin"
FACTION.IsFacility = true

-- Note that FACTION.models is optional. If it is not defined, it will use all the standard HL2 citizen models.
FACTION.models = {
  "models/player/hlew/scientists/administrators/breen_administrator_extended.mdl", "models/player/hlew/scientists/administrators/ernston_administrator_extended.mdl", "models/player/hlew/scientists/administrators/lex_administrator_extended.mdl", "models/player/hlew/scientists/administrators/simon_administrator_extended.mdl", "models/player/hlew/scientists/administrators/wilson_administrator_extended.mdl", "models/player/hlew/scientists/colette_scientist_extended.mdl", "models/player/hlew/scientists/gina_scientist_extended.mdl", "models/player/hlew/scientists/yelene_scientist_extended.mdl", "models/player/hlew/scientists/lorena_scientist_extended.mdl"
}

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()
    inventory:Add("radio", 1)
end


FACTION.Ranks = {
	[1] = {"Clerk", nil, nil, nil, 600, -45},
	[2] = {"Archivist", nil, nil, nil, 3600, 0},
	[3] = {"Senior Archivist", nil, nil, nil, nil, 15},
	[4] = {"Site Overseer", "icon16/medal_silver_1.png", nil, true, nil, 25},
	[5] = {"Site Director", "icon16/medal_gold_1.png", nil, true, nil, 40},
	[6] = {"Board Member", "icon16/medal_gold_1.png", nil, true, nil, 70},
}
FACTION_ADMINISTRATION = FACTION.index