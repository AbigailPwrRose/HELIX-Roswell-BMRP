CLASS.name = "Medical Science"
CLASS.faction = FACTION_SCIENTIST
CLASS.isDefault = true

function CLASS:OnSpawn(client)
  local chara = client:GetCharacter()
  client:Give("weapon_hl1_healthkit")
  return false
end

function CLASS:OnLeave(client)
  local chara = client:GetCharacter()
  client:StripWeapon("weapon_hl1_healthkit")
  return false
end

function CLASS:OnSet(client)
  local chara = client:GetCharacter()
  client:Give("weapon_hl1_healthkit")
  return false
end

CLASS_SCIENCE_MEDICAL = CLASS.index