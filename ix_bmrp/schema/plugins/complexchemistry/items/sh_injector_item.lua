ITEM.name = "Injector Syringe"
ITEM.description = "An injector syringe that can be used to inject chemicals into... willing, victims."
ITEM.model = "models/player/hlew/extras/accessories/needle.mdl"
ITEM.category = "Tools"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 25
ITEM.isWeapon = true
ITEM.weaponCategory = "injector_unique"
ITEM.class = "injector"
ITEM.useSound = "player/pl_pain4.wav"
ITEM.FlaskMax = 200
ITEM.IsFlask = true

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("equip")) then
			surface.SetDrawColor(29, 200, 20, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
	function ITEM:Paint(item, w, h)
		if (item:GetData("Chemical",0) != 0) and (ix.chemistry.List[item:GetData("Chemical")]) then
        	surface.SetDrawColor(60, 60, 60, 85)
        	surface.DrawRect(2, 2, w - 4, h - 4) 
            local ChemColor = ix.chemistry.List[item:GetData("Chemical")][3]
        	surface.SetDrawColor(ChemColor,250)
        	surface.DrawRect(6, 6, w - 12, h - 12) 
		end
	end
	function ITEM:PopulateTooltip(tooltip)
		local name = tooltip:GetRow("name")
		name:SetBackgroundColor(Color(230,230,230))
        
    	local vol = tooltip:AddRow("Contains")
    	vol:SetBackgroundColor(Color(99,99,99,20))
    	vol:SetFont("DermaDefault")
        if (self:GetData("Chemical",0) != 0 ) and (ix.chemistry.List[self:GetData("Chemical")]) then
        	vol:SetText("This syringe contains ".. self:GetData("Volume", 0) .."ml of "..ix.chemistry.List[self:GetData("Chemical")][1]) 
        else
        	vol:SetText("This syringe is empty") 
        end
    	vol:SizeToContents()
    end
end

function ITEM:GetName()
    local Chem = self:GetData("Chemical", 0)
    local Name = "Injector Syringe"
    if (Chem != 0) and (ix.chemistry.List[Chem]) then
      Name = "Syringe of "..ix.chemistry.List[Chem][1] 
    end
	return Name
end

ITEM.functions.combine = {
	OnRun = function(item, data)
    local item2 = ix.item.instances[data[1]]
    local TargOne = item:GetData("Volume",0) + item2:GetData("Volume",0)
    local TargTwo = TargOne - item.FlaskMax
    item:SetData("Volume",math.Clamp(TargOne,0,item.FlaskMax))
    item2:SetData("Volume",math.Clamp(TargTwo,0,item2.FlaskMax))
    item:SetData("Chemical",item2:GetData("Chemical",1))
    if item2:GetData("Volume",0) <= 0 then 
      item2:SetData("Chemical",0)
    end
		return false
	end,
	OnCanRun = function(item, data)
    local Item2Table = ix.item.instances[data[1]]
    if Item2Table.IsFlask == true then
      if item:GetData("Chemical",0) == 0 or item:GetData("Chemical",0) == Item2Table:GetData("Chemical",0) then
        if Item2Table:GetData("Volume",0) > 0 and item:GetData("Volume",0) < item.FlaskMax then 
		      return true
        end
      end
    end
    return false 
	end
}

ITEM:Hook("drop", function(item)
	local inventory = ix.item.inventories[item.invID]

	if (!inventory) then
		return
	end

	-- the item could have been dropped by someone else (i.e someone searching this player), so we find the real owner
	local owner

	for client, character in ix.util.GetCharacters() do
		if (character:GetID() == inventory.owner) then
			owner = client
			break
		end
	end

	if (!IsValid(owner)) then
		return
	end

	if (item:GetData("equip")) then
		item:SetData("equip", nil)

		owner.carryWeapons = owner.carryWeapons or {}

		local weapon = owner.carryWeapons[item.weaponCategory]

		if (!IsValid(weapon)) then
			weapon = owner:GetWeapon(item.class)
		end

		if (IsValid(weapon)) then
			item:SetData("ammo", weapon:Clip1())

			owner:StripWeapon(item.class)
			owner.carryWeapons[item.weaponCategory] = nil
			owner:EmitSound(item.useSound, 80)
		end

		item:RemovePAC(owner)
	end
end)

-- On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.EquipUn = { -- sorry, for name order.
	name = "unequip",
	tip = "unequipTip",
	icon = "icon16/cross.png",
	OnRun = function(item)
		item:Unequip(item.player, true)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true and
			hook.Run("CanPlayerUnequipItem", client, item) != false
	end
}

-- On player eqipped the item, Gives a weapon to player and load the ammo data from the item.
ITEM.functions.Equip = {
	name = "equip",
	tip = "equipTip",
	icon = "icon16/tick.png",
	OnRun = function(item)
		item:Equip(item.player)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") != true and
			hook.Run("CanPlayerEquipItem", client, item) != false
	end
}

function ITEM:WearPAC(client)
	if (ix.pac and self.pacData) then
		client:AddPart(self.uniqueID, self)
	end
end

function ITEM:RemovePAC(client)
	if (ix.pac and self.pacData) then
		client:RemovePart(self.uniqueID)
	end
end

function ITEM:Equip(client, bNoSelect, bNoSound)
	client.carryWeapons = client.carryWeapons or {}

	for k, _ in client:GetCharacter():GetInventory():Iter() do
		if (k.id != self.id) then
			local itemTable = ix.item.instances[k.id]

			if (!itemTable) then
				client:NotifyLocalized("tellAdmin", "wid!xt")

				return false
			else
				if (itemTable.isWeapon and client.carryWeapons[self.weaponCategory] and itemTable:GetData("equip")) then
					client:NotifyLocalized("weaponSlotFilled", self.weaponCategory)

					return false
				end
			end
		end
	end

	if (client:HasWeapon(self.class)) then
		client:StripWeapon(self.class)
	end

	local weapon = client:Give(self.class, !self.isGrenade)

	if (IsValid(weapon)) then
		local ammoType = weapon:GetPrimaryAmmoType()

		client.carryWeapons[self.weaponCategory] = weapon

		if (!bNoSelect) then
			client:SelectWeapon(weapon:GetClass())
		end

		if (!bNoSound) then
			client:EmitSound(self.useSound, 80)
		end

		-- Remove default given ammo.
		if (client:GetAmmoCount(ammoType) == weapon:Clip1() and self:GetData("ammo", 0) == 0) then
			client:RemoveAmmo(weapon:Clip1(), ammoType)
		end

		-- assume that a weapon with -1 clip1 and clip2 would be a throwable (i.e hl2 grenade)
		-- TODO: figure out if this interferes with any other weapons
		if (weapon:GetMaxClip1() == -1 and weapon:GetMaxClip2() == -1 and client:GetAmmoCount(ammoType) == 0) then
			client:SetAmmo(1, ammoType)
		end

		self:SetData("equip", true)

		if (self.isGrenade) then
			weapon:SetClip1(1)
			client:SetAmmo(6, ammoType)
		else
			weapon:SetClip1(self:GetData("ammo", 0))
		end

		weapon.ixItem = self

		if (self.OnEquipWeapon) then
			self:OnEquipWeapon(client, weapon)
		end
	else
		print(Format("[Helix] Cannot equip weapon - %s does not exist!", self.class))
	end
end

function ITEM:Unequip(client, bPlaySound, bRemoveItem)
	client.carryWeapons = client.carryWeapons or {}

	local weapon = client.carryWeapons[self.weaponCategory]

	if (!IsValid(weapon)) then
		weapon = client:GetWeapon(self.class)
	end

	if (IsValid(weapon)) then
		weapon.ixItem = nil

		self:SetData("ammo", weapon:Clip1())
		client:StripWeapon(self.class)
	else
		print(Format("[Helix] Cannot unequip weapon - %s does not exist!", self.class))
	end

	if (bPlaySound) then
		client:EmitSound(self.useSound, 80)
	end

	client.carryWeapons[self.weaponCategory] = nil
	self:SetData("equip", nil)
	self:RemovePAC(client)

	if (self.OnUnequipWeapon) then
		self:OnUnequipWeapon(client, weapon)
	end

	if (bRemoveItem) then
		self:Remove()
	end
end

function ITEM:CanTransfer(oldInventory, newInventory)
	if (newInventory and self:GetData("equip")) then
		local owner = self:GetOwner()

		if (IsValid(owner)) then
			owner:NotifyLocalized("equippedWeapon")
		end

		return false
	end

	return true
end

function ITEM:OnLoadout()
	if (self:GetData("equip")) then
		local client = self.player
		client.carryWeapons = client.carryWeapons or {}

		local weapon = client:Give(self.class, true)

		if (IsValid(weapon)) then
			client:RemoveAmmo(weapon:Clip1(), weapon:GetPrimaryAmmoType())
			client.carryWeapons[self.weaponCategory] = weapon

			weapon.ixItem = self
			weapon:SetClip1(self:GetData("ammo", 0))

			if (self.OnEquipWeapon) then
				self:OnEquipWeapon(client, weapon)
			end
		else
			print(Format("[Helix] Cannot give weapon - %s does not exist!", self.class))
		end
	end
end

function ITEM:OnSave()
	local weapon = self.player:GetWeapon(self.class)

	if (IsValid(weapon) and weapon.ixItem == self and self:GetData("equip")) then
		self:SetData("ammo", weapon:Clip1())
	end
end

function ITEM:OnRemoved()
	local inventory = ix.item.inventories[self.invID]
	local owner = inventory.GetOwner and inventory:GetOwner()

	if (IsValid(owner) and owner:IsPlayer()) then
		local weapon = owner:GetWeapon(self.class)

		if (IsValid(weapon)) then
			weapon:Remove()
		end

		self:RemovePAC(owner)
	end
end

function ITEM:OnEquipWeapon(client, weapon) 
  weapon:SetItemReference(self["id"])
end

hook.Add("PlayerDeath", "ixStripClip", function(client)
	client.carryWeapons = {}

	for k, _ in client:GetCharacter():GetInventory():Iter() do
		if (k.isWeapon and k:GetData("equip")) then
			k:SetData("ammo", nil)
			k:SetData("equip", nil)

			if (k.pacData) then
				k:RemovePAC(client)
			end
		end
	end
end)

hook.Add("EntityRemoved", "ixRemoveGrenade", function(entity)
	-- hack to remove hl2 grenades after they've all been thrown
	if (entity:GetClass() == "weapon_frag") then
		local client = entity:GetOwner()

		if (IsValid(client) and client:IsPlayer() and client:GetCharacter()) then
			local ammoName = game.GetAmmoName(entity:GetPrimaryAmmoType())

			if (isstring(ammoName) and ammoName:lower() == "grenade" and client:GetAmmoCount(ammoName) < 1
			and entity.ixItem and entity.ixItem.Unequip) then
				entity.ixItem:Unequip(client, false, true)
			end
		end
	end
end)