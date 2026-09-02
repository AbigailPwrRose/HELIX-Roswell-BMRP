ITEM.name = "Small KMC Ammo Kit"
ITEM.model = "models/valk/halo3/unsc/props/military/ammo_box.mdl"
ITEM.description = "A universal ammo kit invented by UNISEC and mass-produced by the Kel-Morian Combine. Through some sort of tech wizardry it is capable of refilling any weapon's ammo. ...As long as it uses a standard ammo type."
ITEM.category = "Ammo"
ITEM.ammount = 30

if (CLIENT) then
	function ITEM:PopulateTooltip(tooltip)
		if (self:GetData("equip")) then
			local name = tooltip:GetRow("name")
			name:SetBackgroundColor(derma.GetColor("Success", tooltip))
		end
    	local tip = tooltip:AddRow("Rarity")
    	tip:SetBackgroundColor(Color(99,99,99,20))
    	tip:SetText("This kit contains "..self.ammount.." rounds.")
    	tip:SetFont("DermaDefault")
    	tip:SizeToContents()
    end
end

ITEM.functions.Load = {
	OnRun = function(itemTable)
		local client = itemTable.player
        local wepe = client:GetActiveWeapon()
        local wep = IsValid(wepe) and wepe.Primary and wepe.Primary.Ammo or -1
        if wep != -1 and wepe:GetClass()  != "ix_hands" and wepe:GetClass()  != "ix_keys" then
            local ammo = isnumber(wepe.Primary.Ammo) and game.GetAmmoName(wep) or wepe.Primary.Ammo
            local amount = itemTable.ammount
            --if wepe:GetClass() == "weapon_taucannon_wal" or wepe:GetClass() == "weapon_gluon_wal" or wepe:GetClass() == "weapon_taucannon_nch" or wepe:GetClass() == "weapon_gluon_nch" then
            --    amount = 20
            --else
                amount = math.min(itemTable.ammount, (wepe.Primary.AmmoSize or 360) - client:GetAmmoCount(ammo))
            --end
            if client:GetAmmoCount(ammo) >= (wepe.Primary.AmmoSize or 360) then
                client:Notify("You've reached max ammo!")
                return false
            end

            client:GiveAmmo(amount, ammo)
        else
            client:Notify("Please equip the weapon you wish to refill!")
            return false
        end
	end,
}

function ITEM:OnEntityCreated(entity)
    entity:GetPhysicsObject():SetMass(35)
end