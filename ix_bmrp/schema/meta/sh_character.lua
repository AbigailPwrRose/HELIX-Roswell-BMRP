-- Pretty unused file

local CHAR = ix.meta.character

function CHAR:IsSecurity()
	return self:GetFaction() == FACTION_SECURITY
end
