function Schema:CharacterLoaded(character)
	self:ExampleFunction("Welcome to Black Mesa, "..character:GetName()..".")
end

function Schema:PlayerFootstep(client, position, foot, soundName, volume)
	return
end
