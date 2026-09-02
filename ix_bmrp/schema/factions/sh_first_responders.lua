
FACTION.name = "National Guard"
FACTION.description = "T B D later."
FACTION.isDefault = true
FACTION.color = Color(20, 190, 100)
FACTION.pay = 60
FACTION.teamRadio = "GOV.Guard"
FACTION.IsFacility = false
FACTION.isGloballyRecognized = true
FACTION.models = {
	"models/player/hlew/security/others/barney_first_response_extended.mdl", "models/player/hlew/security/others/barniel_first_response_extended.mdl", "models/player/hlew/security/others/bill_first_response_extended.mdl", "models/player/hlew/security/others/kate_first_response_extended.mdl", "models/player/hlew/security/others/phill_first_response_extended.mdl", "models/player/hlew/security/others/roger_first_response_extended.mdl", "models/player/hlew/security/others/steve_first_response_extended.mdl"
}

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()
    inventory:Add("radio", 1)
end

FACTION.Ranks = {
    [1] = {"Private", nil, nil},
    [2] = {"Private First Class", "icon16/medal_bronze_1.png", nil},
    [3] = {"Specialist", "icon16/medal_bronze_1.png", nil},
    [4] = {"Corporal", "icon16/medal_silver_1.png", nil},
    [5] = {"Sergeant", "icon16/medal_silver_1.png", nil},
    [6] = {"Lieutenant", "icon16/medal_gold_1.png", nil, true},
    [7] = {"Captain", "icon16/medal_gold_1.png", nil, true},
}
FACTION_FIRSTRESPONDERS= FACTION.index