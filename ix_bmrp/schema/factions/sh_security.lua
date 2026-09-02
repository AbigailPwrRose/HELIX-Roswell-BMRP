
FACTION.name = "Black Mesa Security"
FACTION.description = "Black Mesa's security force, used to keep the site safe."
FACTION.isDefault = true
FACTION.color = Color(20, 100, 190)
FACTION.pay = 30
FACTION.teamRadio = "BM.Security"
FACTION.IsFacility = true 
FACTION.weapons = {"sh_stunstick"}
FACTION.isGloballyRecognized = true
FACTION.models = {
	"models/player/hlew/security/barney_security_extended.mdl", "models/player/hlew/security/barniel_security_extended.mdl" ,"models/player/hlew/security/bernard_security_extended.mdl" ,"models/player/hlew/security/bill_security_extended.mdl" ,"models/player/hlew/security/calhoun_security_extended.mdl" ,"models/player/hlew/security/clint_security_extended.mdl", "models/player/hlew/security/dan_security_extended.mdl", "models/player/hlew/security/jack_security_extended.mdl","models/player/hlew/security/jonny_security_extended.mdl" ,"models/player/hlew/security/kate_security_extended.mdl", "models/player/hlew/security/leonel_security_extended.mdl", "models/player/hlew/security/louis_security_extended.mdl" ,"models/player/hlew/security/marley_security_extended.mdl", "models/player/hlew/security/mike_security_extended.mdl" ,"models/player/hlew/security/otis_security_extended.mdl"  ,"models/player/hlew/security/phill_security_extended.mdl" ,"models/player/hlew/security/roger_security_extended.mdl" ,"models/player/hlew/security/steve_security_extended.mdl" ,"models/player/hlew/security/susanne_security_extended.mdl", "models/player/hlew/security/ted_security_extended.mdl", "models/player/hlew/security/tex_security_extended.mdl", "models/player/hlew/security/tommy_security_extended.mdl", "models/player/hlew/security/tremors_security_extended.mdl", "models/player/hlew/security/survivors/barney_survivor_extended.mdl"
}

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()
    inventory:Add("radio", 1)
end

function FACTION:OnRankChanged(client, oldValue, value)
    local character = client:GetCharacter()
    if oldValue == 1 and value != 1 then
        client:ChatNotify("You can now select a class, and get a pistol from the armory!")
        character:KickClass() end
    if oldValue != 1 and value == 1 then
        character:KickClass() end
end

FACTION.Ranks = {
    [1] = {"Recruit", nil, CLASS_SECURITY_NEWBIES,nil,nil,-30},
    [2] = {"Cadet", nil, CLASS_SECURITY_NEWBIES, nil, 1800,-20},
    [3] = {"Officer", "icon16/medal_bronze_1.png", nil, nil, 3600,0},
    [4] = {"Senior Officer", "icon16/medal_bronze_1.png", nil,nil,nil,15},
    [5] = {"Corporal", "icon16/medal_silver_1.png", nil,nil,nil,25},
    [6] = {"Sergeant", "icon16/medal_silver_1.png", nil, true,nil,40},
    [7] = {"Major", "icon16/medal_gold_1.png", nil, true,nil,55},
    [8] = {"Security Chief", "icon16/medal_gold_1.png", nil, true,nil,70},
}
FACTION_SECURITY = FACTION.index