
ITEM.name = "Brain Implosion Energy™ Soda Can"
ITEM.model = "models/halflife/props/can.mdl"
ITEM.description = "For zero thoughts! Crave head empty? Just drink and drink and drink 'til your heart stops!"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Consumables - Drinks"
ITEM.price = 350
ITEM.skin = 5
ITEM.rarity = "Rare"

ITEM.functions.Use = {
	OnRun = function(itemTable)
		local client = itemTable.player
		local clientie = client:EntIndex()
		client:EmitSound("npc/barnacle/barnacle_gulp1.wav",50)
		if timer.Exists( "BrainImplosion_Targetting" .. clientie ) then
			client.BIEKillTick = client.BIEKillTick/2
			return
		end
		client.BIEKillTick = 2
		timer.Create( "BrainImplosion_Targetting" .. clientie, 0.75, 500, function()
			client.BIEKillTick = client.BIEKillTick * 0.95
			if not IsValid(client) or not client:Alive() then timer.Remove("BrainImplosion_Targetting" .. clientie) end
			client.BMRPBodyProductionCustom = {
				["weaponUsed"] = "Caffeine induced seizure from neural overload, followed by total organ failure",
				["inflictorName"] = "ix_item_brainimplosion",
				["TimeUpdated"] = CurTime(),
				["killerTeam"] = -5500,
				["attackerName"] = "MissingNo",
				["handPrint"] = -5500,
				["SuppressCorpse"] = 3
			}
			client:TakeDamage( 1, client, game.GetWorld() )
			timer.Adjust( "BrainImplosion_Targetting" .. clientie, math.Clamp(client.BIEKillTick,0.08,2))
		end)
		hook.Add("PlayerDeath","BrainImplosion_DeathTarget" .. clientie,function(victim)
			if not IsValid(client) then hook.Remove("PlayerDeath","BrainImplosion_DeathTarget" .. clientie) end
			if victim == client then
				timer.Remove("BrainImplosion_Targetting" .. clientie)
				hook.Remove("PlayerDeath","BrainImplosion_DeathTarget" .. clientie)
			end
		end)
		hook.Add( "Tick", "BrainImplosion_SeizureLogic" .. clientie,function()
			if not IsValid(client) or not timer.Exists("BrainImplosion_Targetting" .. clientie) then
				return hook.Remove("Tick","BrainImplosion_SeizureLogic" .. clientie)
			end
		end)
	end
}


function ITEM:PopulateTooltip(tooltip)
	local tip = tooltip:AddRow("NutritionLabel")
	tip:SetBackgroundColor(Color(255,50,50,255))
	tip:SetText("Contains 10,000 grams of pure caffine, magically flavoured. Sister project of: Bonk! Atomic Punch™ Soda.")
	tip:SetFont("DermaDefault")
	tip:SizeToContents()
end