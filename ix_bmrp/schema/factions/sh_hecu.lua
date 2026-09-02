
FACTION.name = "Hazardous Enviroment Combat Unit"
FACTION.description = "... You have your orders, officer."
FACTION.isDefault = false
FACTION.color = Color(87, 199, 97)
FACTION.pay = 0
FACTION.teamRadio = "HECU Radio"
FACTION.IsFacility = false
FACTION.isGloballyRecognized = false
FACTION.models = {
	"models/player/Opposing Force/hgrunt_opfor_beret.mdl", "models/player/Opposing Force/hgrunt_opfor_mp.mdl", "models/player/Opposing Force/hgrunt_opfor_mask.mdl", "models/player/Opposing Force/hgrunt_medic.mdl", "models/player/Opposing Force/hgrunt_opfor_saw.mdl", "models/player/Opposing Force/hgrunt_opfor_shotgun.mdl", "models/player/Opposing Force/hgrunt_torch.mdl"
}

FACTION.Ranks = {
    [1] = {"Recruit", nil, nil},
    [2] = {"Officer", "icon16/medal_bronze_1.png", nil},
    [3] = {"Senior Officer", "icon16/medal_bronze_1.png", nil},
    [4] = {"Corporal", "icon16/medal_silver_1.png", nil},
    [5] = {"Sergeant", "icon16/medal_silver_1.png", nil},
    [6] = {"Major", "icon16/medal_gold_1.png", nil, true},
    [7] = {"General", "icon16/medal_gold_1.png", nil, true},
}
FACTION_HECUTEAM= FACTION.index