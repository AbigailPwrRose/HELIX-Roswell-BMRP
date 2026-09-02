FACTION.name = "Visitors"
FACTION.description = "Wanderers, migrants, refugees, hobos, and more."
FACTION.isDefault = true
FACTION.color = Color(188, 62, 62)
FACTION.teamRadio = ""
FACTION.pay = 5
FACTION.IsFacility = false
FACTION.isGloballyRecognized = false
FACTION.models = {
    "models/player/hlew/others/bernard_visitor_alt_extended.mdl", "models/player/hlew/others/dan_visitor_alt_extended.mdl", "models/player/hlew/others/edwart_visitor_extended.mdl", "models/player/hlew/others/franklin_visitor_fat_extended.mdl", "models/player/hlew/others/harvey_visitor_fat_extended.mdl", "models/player/hlew/others/jack_visitor_fat_extended.mdl", "models/player/hlew/others/jay_visitor_extended.mdl", "models/player/hlew/others/marley_visitor_extended.mdl", "models/player/hlew/others/mike_visitor_alt_extended.mdl", "models/player/hlew/others/paul_visitor_extended.mdl", "models/player/hlew/others/poly_visitor_extended.mdl", "models/player/hlew/others/robin_visitor_extended.mdl", "models/player/hlew/others/ted_visitor_alt_extended.mdl", "models/player/hlew/others/tex_visitor_fat_extended.mdl", "models/player/hlew/others/tim_visitor_extended.mdl", "models/player/hlew/others/tommy_visitor_alt_extended.mdl", "models/player/hlew/others/tommy_visitor_alt_extended.mdl", "models/player/hlew/others/wallace_visitor_extended.mdl", "models/player/hlew/others/wexler_visitor_extended.mdl"
}

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()
end

FACTION_TRAVELLER = FACTION.index
