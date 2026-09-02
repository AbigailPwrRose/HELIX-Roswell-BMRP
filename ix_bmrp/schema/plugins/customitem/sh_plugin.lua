local PLUGIN = PLUGIN

PLUGIN.name = "Custom Items+"
PLUGIN.author = "Winters Rose"
PLUGIN.description = "Enables staff members to create custom items."
PLUGIN.readme = [[
Enables staff members to create custom items.

There is no support for this
]]

ix.command.Add("CreateCustomItem", {
	description = "@cmdCreateCustomItem",
	superAdminOnly = true,
	arguments = {
		ix.type.string,
		ix.type.string,
		ix.type.string,
        ix.type.number,
        ix.type.number
	},
	OnRun = function(self, client, name, model, description, width, height)
        if width == 1 then
                if height == 1 then
                    item_size = "customitem1_1" 
                elseif height == 2 then
                    item_size = "customitem1_2"
                elseif height == 3 then
                    item_size = "customitem1_3"
                elseif height == 4 then
                    item_size = "customitem1_4"
                elseif height == 5 then
                    item_size = "customitem1_5" 
                end
        elseif width == 2 then
                if height == 1 then
                    item_size = "customitem2_1"
                elseif height == 2 then
                    item_size = "customitem2_2"
                elseif height == 3 then
                    item_size = "customitem2_3"
                elseif height == 4 then
                    item_size = "customitem2_4"
                elseif height == 5 then
                    item_size = "customitem2_5" 
                end
        elseif width == 3 then
                if height == 1 then
                    item_size = "customitem3_1"
                elseif height == 2 then
                    item_size = "customitem3_2"
                elseif height == 3 then
                    item_size = "customitem3_3"
                elseif height == 4 then
                    item_size = "customitem3_4"
                elseif height == 5 then
                    item_size = "customitem3_5" 
                end
        elseif width == 4 then
                if height == 1 then
                    item_size = "customitem4_1"
                elseif height == 2 then
                    item_size = "customitem4_2"
                elseif height == 3 then
                    item_size = "customitem4_3"
                elseif height == 4 then
                    item_size = "customitem4_4"
                elseif height == 5 then
                    item_size = "customitem4_5" 
                end
        elseif width == 5 then
                if height == 1 then
                    item_size = "customitem5_1"
                elseif height == 2 then
                    item_size = "customitem5_2"
                elseif height == 3 then
                    item_size = "customitem5_3"
                elseif height == 4 then
                    item_size = "customitem5_4"
                elseif height == 5 then
                    item_size = "customitem5_5" 
                end
        else item_size = "customitem1_1" 
        end   
		client:GetCharacter():GetInventory():Add(item_size, 1, {
			name = name, 
			model = model,
			description = description
		})
	end
})
