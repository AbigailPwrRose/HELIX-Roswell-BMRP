PLUGIN.name = "Remove Faction Scoreboard"
PLUGIN.author = "Mixed"
PLUGIN.desc = "Remove specific factions from scoreboard."


function PLUGIN:ShouldShowPlayerOnScoreboard(client)
	if (LocalPlayer() != client:Team() and !LocalPlayer():IsAdmin()) and ((client:Team() == FACTION_EVENT)or(client:Team() == FACTION_ASSASIN)) then
		return false
	end
end 