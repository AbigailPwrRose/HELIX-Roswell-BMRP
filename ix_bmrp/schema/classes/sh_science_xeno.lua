CLASS.name = "Xenobiology"
CLASS.faction = FACTION_SCIENTIST
CLASS.isDefault = true

function CLASS:OnSpawn(client)
  local chara = client:GetCharacter()
  client:Give("sh_xenobio_stunstick")
  return false
end

function CLASS:OnLeave(client)
  local chara = client:GetCharacter()
  client:StripWeapon("sh_xenobio_stunstick")
  return false
end

function CLASS:OnSet(client)
  local chara = client:GetCharacter()
  client:Give("sh_xenobio_stunstick")
  return false
end

CLASS_SCIENCE_XENO = CLASS.index