CLASS.name = "General Security"
CLASS.faction = FACTION_SECURITY
CLASS.isDefault = true

function CLASS:CanSwitchTo(client)
  local Can = false
  local chara = client:GetCharacter()
  local rank = chara:GetRank()
  if rank > 1 then Can = true end
  return Can
end

CLASS_SECURITY_GENERAL = CLASS.index