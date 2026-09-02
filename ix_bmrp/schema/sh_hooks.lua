-- Here is where all of your shared hooks should go.

-- Disable entity driving.
function Schema:CanDrive(client, entity)
	return false
end

function Schema:CanCreateCharacterInfo(suppress)
    local rank = LocalPlayer():GetCharacter():GetRank()
    local factionTable = ix.faction.Get(LocalPlayer():Team())
    if (rank) and factionTable.Ranks and factionTable.Ranks[rank] then
        suppress.rank = false
    else
    	suppress.rank = true
    end
end

hook.Add( "EntityTakeDamage", "DoorBuster", function( target, dmginfo )
	if ( target:IsDoor() ) and (dmginfo:GetAttacker():IsPlayer()) then
            local Wep = dmginfo:GetAttacker():GetActiveWeapon():GetPrintName()
            if (Wep == "#HL2_Crowbar") then
                local DropChance = math.random(1,100)
                if DropChance >= 30 then
                	target:Fire("unlock") ix.log.AddRaw(dmginfo:GetAttacker():GetName().." has forcibly unlocked a door") end 
				end
    end
end )

function GLOBAL_BMRP_GlassBreakEffectFunction(Bounds1,Bounds2,Amount,AngleParticle)
  for I=1,Amount do
      local infoEffectTable = EffectData()
      infoEffectTable:SetOrigin(Vector(math.random(Bounds1.x,Bounds2.x),math.random(Bounds1.y,Bounds2.y),math.random(Bounds1.z,Bounds2.z)))
      infoEffectTable:SetAngles(AngleParticle)
      infoEffectTable:SetNormal( AngleParticle:Forward() )
      util.Effect( "GlassImpact", infoEffectTable)
  end
  
  local GlassBreakWindowSounds = {
      "physics/glass/glass_sheet_break2.wav",
      "physics/glass/glass_largesheet_break2.wav",
      "physics/glass/glass_sheet_break3.wav",
      "physics/glass/glass_sheet_break1.wav",
      "physics/glass/glass_pottery_break4.wav",
      "physics/glass/glass_largesheet_break3.wav",
      "physics/glass/crazy_box_break_01.wav",
      "physics/glass/glass_largesheet_break1.wav"
  }
  for I=1,math.ceil(Amount/15) do
      sound.Play( GlassBreakWindowSounds[ math.random( #GlassBreakWindowSounds ) ], Vector( math.random(Bounds1.x,Bounds2.x), math.random(Bounds1.y,Bounds2.y), math.random(Bounds1.z,Bounds2.z) ), 55 + Amount/30, math.random(125 - Amount/10,140 - Amount/10), 0.8 + Amount/28)
  end
end

function Schema:EntityTakeDamage(Victim,CDMGInfo)
    if !(IsValid(Victim) and Victim:GetClass() == "func_breakable" and Victim:GetName() == "") then return end
    Victim.BMRPGLASS_Broken = Victim.BMRPGLASS_Broken or false
    CDMGInfo:ScaleDamage( 0 )
    Victim:SetHealth(80000)
    --Entity(2):PrintMessage(HUD_PRINTTALK,tostring(CDMGInfo:GetInflictor()))
    if not Victim.BMRPGLASS_Broken then
        Victim:SetCollisionGroup( 10 )
        Victim.BMRPGLASS_OGCOLOR = Victim:GetColor()
        Victim:SetColor(Color(255,255,255,0))
        --Victim:EmitSound( "physics/glass/glass_sheet_break1.wav", 65, 85, 1.2, CHAN_AUTO, 0, 0, nil )
        Victim:PrecacheGibs()
        Victim:GibBreakClient( Vector(0,0,0) )
        Victim.BMRPGLASS_Broken = true
        local ParticleAngle = CDMGInfo:GetDamageForce():Angle() or Angle(0,0,0)
        if IsValid(CDMGInfo:GetInflictor()) and not CDMGInfo:GetInflictor():IsPlayer() and IsValid(CDMGInfo:GetInflictor():GetPhysicsObject()) then
            CDMGInfo:GetInflictor():GetPhysicsObject():SetVelocity(CDMGInfo:GetInflictor():GetPhysicsObject():GetVelocity())
        end
        local VicPos = Victim:GetPos()
        local Bounds1,Bounds2 = Victim:GetModelBounds()
        local SizeForStuff = math.ceil( (math.abs( Bounds1.x ) + math.abs( Bounds1.y ) + math.abs( Bounds1.z ) + math.abs( Bounds2.x ) + math.abs( Bounds2.y ) + math.abs( Bounds2.z ))/4 )
        local GlassScrapItemModels = {
            "models/props/cs_militia/skylight_glass_p13.mdl",
            "models/props/cs_militia/skylight_glass_p5.mdl",
            "models/props/cs_militia/skylight_glass_p6.mdl",
            "models/props/cs_militia/skylight_glass_p9.mdl"
        }
        for I=1,math.ceil(SizeForStuff/20) do
            if true then continue end -- Uhh flooding the helix item cache is a bad idea...
            if SizeForStuff/20 > 18 then continue end
        end
        --[[
        for I=1,SizeForStuff do
            local infoEffectTable = EffectData()
            infoEffectTable:SetOrigin(Victim:GetPos() + Vector(math.random(Bounds1.x,Bounds2.x),math.random(Bounds1.y,Bounds2.y),math.random(Bounds1.z,Bounds2.z)))
            util.Effect( "GlassImpact", infoEffectTable)
        end
        ]]
        for k,v in ipairs(player.GetAll()) do
            if not IsValid(v) then continue end
            v:SendLua("GLOBAL_BMRP_GlassBreakEffectFunction(Vector("..Bounds1.x + VicPos.x..","..Bounds1.y + VicPos.y..","..Bounds1.z + VicPos.z.."),Vector("..Bounds2.x + VicPos.x..","..Bounds2.y + VicPos.y..","..Bounds2.z + VicPos.z.."),"..SizeForStuff..",Angle("..ParticleAngle.x..","..ParticleAngle.y..","..ParticleAngle.z.."))")
        end
        timer.Create( "GLOBAL_BMRP_GlassRespawnTimer_ForEnt" .. Victim:EntIndex(), 90, 1, function()
            if not IsValid(Victim) then return end
            Victim:RemoveAllDecals()
            Victim:SetCollisionGroup( 0 )
            Victim:SetColor(Victim.BMRPGLASS_OGCOLOR)
            Victim.BMRPGLASS_Broken = false
        end)
        return
    end
end

ix.chat.Register("EvilPills", { -- Sets up and registers the radio chat
	format = "",
	indicator = "chatTalking",
	CanHear = function(self, speaker, listener)
        if (listener:IsAdmin()) then 
            return true 
        else
            return false
        end
    end,
	OnChatAdd = function(self, speaker, text)
		local character = speaker:GetCharacter()
		local name = character:GetName()
		chat.AddText(Color(30, 30, 255), ""..name.." has taken the pills that make you crazy")
        return true 
        end,})

function HEVCleanse(ply)
  local Character = ply:GetCharacter()
  if (Character) then
    Character:SetData("WearingHEVStuff",0)
    Character:SetData("WearingBallsyVest",0)
    Character:SetData("WearingHEVMK3",0)
    Character:SetData("WearingHEVMK4",0)
  end
end
function PlayerSpawnArmo(ply)
  local Character = ply:GetCharacter()
  if (Character) then
    local BaseMax = 25
    if Character:GetData("WearingHEVStuff",0) == 1 then
      if Character:GetData("WearingBallsyVest",0) == 1 then
        BaseMax = 75
      elseif Character:GetData("WearingHEVMK3",0) == 1 then
        BaseMax = 125
      elseif Character:GetData("WearingHEVMK4",0) == 1 then
        BaseMax = 100 
      end
    end
    timer.Simple( 1, function()
          ply:SetMaxArmor(BaseMax) 
          if BaseMax > 50 then
          ply:SetArmor(BaseMax) end end)
  end
end
hook.Add( "PlayerDeath", "PlayerArmorSet", HEVCleanse )
hook.Add( "PlayerSpawn", "PlayerArmorSet", PlayerSpawnArmo )

function CanTransferItem(itemObject, curInv, inventory)
	if (SERVER) then
		local client = itemObject.GetOwner and itemObject:GetOwner() or nil

		if (IsValid(client) and curInv.GetReceivers) then
			local bAuthorized = false

			for _, v in ipairs(curInv:GetReceivers()) do
				if (client == v) then
					bAuthorized = true
					break
				end
			end

			if (!bAuthorized) then
				return false
			end
		end
	end

	-- we can transfer anything that isn't a bag
	if (!itemObject or !itemObject.isBag) then
		return
	end

	-- don't allow bags to be put inside bags
	if (inventory.id != 0 and curInv.id != inventory.id) and !(inventory.vars and inventory.vars.isBag == "safebox") then
        if (inventory.vars and inventory.vars.isBag) then
			local owner = itemObject:GetOwner()

			if (IsValid(owner)) then
				owner:NotifyLocalized("nestedBags")
			end

			return false
		end
	elseif (inventory.id != 0 and curInv.id == inventory.id) then
		-- we are simply moving items around if we're transferring to the same inventory
		return
	end
  
	inventory = ix.item.inventories[itemObject:GetData("id")]

	-- don't allow transferring items that are in use
	if (inventory) then
		for k, _ in inventory:Iter() do
			if (k:GetData("equip") == true) then
				local owner = itemObject:GetOwner()

				if (owner and IsValid(owner)) then
					owner:NotifyLocalized("equippedBag")
				end

				return false
			end
		end
	end
end
hook.Add( "CanTransferItemUpdated", "CanTransferItemNyanCheck", CanTransferItem )