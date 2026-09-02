local PLUGIN = PLUGIN

PLUGIN.name = "MoreDice"
PLUGIN.author = "Winter Rose"
PLUGIN.description = "Adds more ways to roll"

ix.command.Add("Roll", {
        description = "@cmdRoll",
        arguments = bit.bor(ix.type.number, ix.type.optional),
        OnRun = function(self, client, maximum)
            maximum = math.Clamp(maximum or 100, 0, 1000000)

            local value = math.random(0, maximum)

            ix.chat.Send(client, "roll", tostring(value), nil, nil, {
                    max = maximum
                })
            
            if value == maximum or value == 0 then 
                hook.Run("criticalDiceRollLogit", {
                        name = client:GetName(),
                        roll = value,
                        rollMax = maximum,
                    })
            end
            ix.log.Add(client, "roll", value, maximum)
        end
})

ix.chat.Register("rollWBonus", {
			format = "** %s has rolled %s+%s out of %s.",
			color = Color(155, 111, 176),
			CanHear = ix.config.Get("chatRange", 280),
			deadCanChat = true,
			OnChatAdd = function(self, speaker, text, bAnonymous, data)
				local max = data.max or 100
				local bonus = data.bonuse or 0
				local translated = L2(self.uniqueID.."Format", speaker:Name(), text, bonus, max)

				chat.AddText(self.color, translated and "** "..translated or string.format(self.format,
					speaker:Name(), text, bonus, max
				))
			end
})

ix.command.Add("RollB", {
        description = "Roll a dice, with a bonus",
        arguments = {bit.bor(ix.type.number, ix.type.optional),bit.bor(ix.type.number, ix.type.optional)},
        OnRun = function(self, client, maximum, bonus)
            maximum = math.Clamp(maximum or 100, 0, 1000000)
            bonus = math.Clamp(bonus or 0, 0, 20)

            local value = math.random(0, maximum)

            ix.chat.Send(client, "rollWBonus", tostring(value), nil, nil, {
                    max = maximum,
                    bonuse = bonus
                })

            ix.log.Add(client, "roll", value, maximum)
        end
    })

ix.command.Add("RollTechnical", {
	description = "Roll a dice, with a bonus from Technical skill.",
	arguments = bit.bor(ix.type.number, ix.type.optional),
	OnRun = function(self, client, maximum,bonus)
        local character = client:GetCharacter()
		maximum = math.Clamp(maximum or 100, 0, 1000000)
        local bonus = math.floor(character:GetAttribute("technical",0)/(maximum/2))

		local value = math.random(0, maximum) + bonus

		ix.chat.Send(client, "rollWSkillBonus", tostring(value), nil, nil, {
			max = maximum,
            skill = "Technical"
		})

		ix.log.Add(client, "roll", value, maximum)
	end
})
ix.command.Add("RollMedical", {
	description = "Roll a dice, with a bonus from Medical skill.",
	arguments = bit.bor(ix.type.number, ix.type.optional),
	OnRun = function(self, client, maximum,bonus)
        local character = client:GetCharacter()
		maximum = math.Clamp(maximum or 100, 0, 1000000)
        local bonus = math.floor(character:GetAttribute("medical",0)/(maximum/2))

		local value = math.random(0, maximum) + bonus

		ix.chat.Send(client, "rollWSkillBonus", tostring(value), nil, nil, {
			max = maximum,
            skill = "Medical"
		})

		ix.log.Add(client, "roll", value, maximum)
	end
})
ix.command.Add("RollCharisma", {
	description = "Roll a dice, with a bonus from Charisma skill.",
	arguments = bit.bor(ix.type.number, ix.type.optional),
	OnRun = function(self, client, maximum,bonus)
        local character = client:GetCharacter()
		maximum = math.Clamp(maximum or 100, 0, 1000000)
        local bonus = math.floor(character:GetAttribute("charisma",0)/(maximum/2))

		local value = math.random(0, maximum) + bonus

		ix.chat.Send(client, "rollWSkillBonus", tostring(value), nil, nil, {
			max = maximum,
            skill = "Charisma"
		})

		ix.log.Add(client, "roll", value, maximum)
	end
})
ix.command.Add("RollDexterity", {
	description = "Roll a dice, with a bonus from Dexterity skill.",
	arguments = bit.bor(ix.type.number, ix.type.optional),
	OnRun = function(self, client, maximum,bonus)
        local character = client:GetCharacter()
		maximum = math.Clamp(maximum or 100, 0, 1000000)
        local bonus = math.floor(character:GetAttribute("dexterity",0)/(maximum/2))

		local value = math.random(0, maximum) + bonus

		ix.chat.Send(client, "rollWSkillBonus", tostring(value), nil, nil, {
			max = maximum,
            skill = "Dexterity"
		})

		ix.log.Add(client, "roll", value, maximum)
	end
})
ix.command.Add("RollStrength", {
	description = "Roll a dice, with a bonus from Strength skill.",
	arguments = bit.bor(ix.type.number, ix.type.optional),
	OnRun = function(self, client, maximum,bonus)
        local character = client:GetCharacter()
		maximum = math.Clamp(maximum or 100, 0, 1000000)
        local bonus = math.floor(character:GetAttribute("strength",0)/(maximum/2))

		local value = math.random(0, maximum) + bonus

		ix.chat.Send(client, "rollWSkillBonus", tostring(value), nil, nil, {
			max = maximum,
            skill = "Strength"
		})

		ix.log.Add(client, "roll", value, maximum)
	end
})
ix.command.Add("RollIntelligence", {
	description = "Roll a dice, with a bonus from Intelligence skill.",
	arguments = bit.bor(ix.type.number, ix.type.optional),
	OnRun = function(self, client, maximum,bonus)
        local character = client:GetCharacter()
		maximum = math.Clamp(maximum or 100, 0, 1000000)
        local bonus = math.floor(character:GetAttribute("intelligence",0)/(maximum/2))

		local value = math.random(0, maximum) + bonus

		ix.chat.Send(client, "rollWSkillBonus", tostring(value), nil, nil, {
			max = maximum,
            skill = "Intelligence"
		})

		ix.log.Add(client, "roll", value, maximum)
	end
})
ix.command.Add("RollWisdom", {
	description = "Roll a dice, with a bonus from Wisdom skill.",
	arguments = bit.bor(ix.type.number, ix.type.optional),
	OnRun = function(self, client, maximum,bonus)
        local character = client:GetCharacter()
		maximum = math.Clamp(maximum or 100, 0, 1000000)
        local bonus = math.floor(character:GetAttribute("wisdom",0)/(maximum/2))

		local value = math.random(0, maximum) + bonus

		ix.chat.Send(client, "rollWSkillBonus", tostring(value), nil, nil, {
			max = maximum,
            skill = "Wisdom"
		})

		ix.log.Add(client, "roll", value, maximum)
	end
})
ix.command.Add("RollEndurance", {
	description = "Roll a dice, with a bonus from Endurance skill.",
	arguments = bit.bor(ix.type.number, ix.type.optional),
	OnRun = function(self, client, maximum,bonus)
        local character = client:GetCharacter()
		maximum = math.Clamp(maximum or 100, 0, 1000000)
        local bonus = math.floor(character:GetAttribute("endurance",0)/(maximum/2))

		local value = math.random(0, maximum) + bonus

		ix.chat.Send(client, "rollWSkillBonus", tostring(value), nil, nil, {
			max = maximum,
            skill = "Endurance"
		})

		ix.log.Add(client, "roll", value, maximum)
	end
})