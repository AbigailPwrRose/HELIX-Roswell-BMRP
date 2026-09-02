ITEM.name = "Troilite Crate"
ITEM.description = "A large crate with a padded interior. Perfect for storing troilite ore."
ITEM.category = "Tools"
ITEM.rarity = "Rare"
ITEM.model = "models/props_marines/ammocrate01_static.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.MaxOre = 25
ITEM.OreType = "troiliteore_ore"
ITEM.OreColor = Color(79,79,79,255)
ITEM.price = 200

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
        local MaxWide = w - 16
        surface.SetDrawColor(240,240,240, 255)
        surface.DrawRect(6, h - 16, MaxWide+4, 12)
        
		if (item:GetData("oreFill",0) > 0) then
            local ActualWide = MaxWide * (item:GetData("oreFill",0)/item.MaxOre)
            
			surface.SetDrawColor(item.OreColor)
			surface.DrawRect(8, h - 14, ActualWide, 8)
		end
	end
end

function ITEM:GetDescription()
    local NewDesc = self.description 

    if (self:GetData("oreFill",0) > 0) then
        NewDesc = NewDesc.."\n\nThis crate currently contains "..self:GetData("oreFill",0).."/"..self.MaxOre.." troilite ore."
    end
    
    return NewDesc
end

ITEM.functions.aapickupore = {
    name = "Collect Ore",
    icon = "icon16/ruby_add.png",
    OnRun = function(item)
        local ply = item.player 
        local trace = ply:GetEyeTraceNoCursor()
        local targEnt = trace.Entity
        local targName = targEnt:GetVar("ClassName")
        local TableOfOre = util.JSONToTable(item:GetData("StoredTable",util.TableToJSON({})))
        
		if (CLIENT) then return end
        
        if IsValid(targEnt) and targEnt:GetClass() == item.OreType then	
            if item:GetData("oreFill",0) < item.MaxOre then
                local Model = targEnt:GetModel()
                local ExtraData = targEnt:GetNW2String("CrystalData",util.TableToJSON({}))
				table.Add(TableOfOre, {{["M"]=Model,["E"]=ExtraData}})
                
				targEnt:Remove()
                
                item:SetData("StoredTable",util.TableToJSON(TableOfOre))
                item:SetData("oreFill",math.Clamp(item:GetData("oreFill",0)+1,0,item.MaxOre))
            end
        end

        return false
	end,
    OnCanRun = function(item)
        local ply = item.player 
        local trace = ply:GetEyeTraceNoCursor()
        local targEnt = trace.Entity
        local targName = targEnt:GetVar("ClassName")
        if IsValid(targEnt) and targEnt:GetClass() == item.OreType then	
            if item:GetData("oreFill",0) < item.MaxOre then
                return true
            end
        end
        
        return false
    end
}
ITEM.functions.abdepositore = {
    name = "Remove Ore",
    icon = "icon16/ruby_add.png",
    OnRun = function(item)
        local ply = item.player 
        local trace = ply:GetEyeTraceNoCursor()
        local targEnt = trace.Entity
        local targName = targEnt:GetVar("ClassName")
        local TableOfOre = util.JSONToTable(item:GetData("StoredTable",util.TableToJSON({})))
        
        if !(IsValid(ply) and item:GetData("oreFill",0) > 0) then return false end
        
		local data = {}
			data.start = ply:GetShootPos()
			data.endpos = data.start + ply:GetAimVector()*100
			data.filter = ply
		local trace = util.TraceLine(data)
        
        local Pos = trace["HitPos"]
        local LIQ = TableOfOre[#TableOfOre]
        if util.IsInWorld(Pos) then 
            local ent = ents.Create(item.OreType)
            ent:SetPos(Pos) 
            ent:SetAngles(Angle(0.0, 90.0, 0.0))
            ent:SetModel(LIQ["M"])
            ent:PhysicsInit( SOLID_VPHYSICS ) -- Initializes physics for the Entity, making it solid and interactable.
            ent:SetMoveType( MOVETYPE_VPHYSICS ) -- Sets how the Entity moves, using physics.
            ent:SetSolid( SOLID_VPHYSICS ) -- Makes the Entity solid, allowing for collisions.

            local phys = ent:GetPhysicsObject() -- Retrieves the physics object of the Entity.
            phys:SetMass(100)
            phys:EnableMotion(true)
            phys:Wake()
            
            if LIQ["E"] != "[]" then 
                ent:SetNW2String("CrystalData",util.JSONToTable(LIQ["E"]))
            end
            
            item:SetData("oreFill",math.Clamp(item:GetData("oreFill",0)-1,0,item.MaxOre))
            table.remove(TableOfOre)
            item:SetData("StoredTable",util.TableToJSON(TableOfOre))
        end
        
        return false
	end,
    OnCanRun = function(item)
        local ply = item.player 
        local trace = ply:GetEyeTraceNoCursor()
        local targEnt = trace.Entity
        local targName = targEnt:GetVar("ClassName")
        if IsValid(ply) and item:GetData("oreFill",0) > 0 then	
            return true
        end
        
        return false
    end
}
ITEM.functions.use = {
	name = "GetSecret",
	icon = "icon16/pencil.png",
	OnRun = function(item)
        
        PrintTable(util.JSONToTable(item:GetData("StoredTable",util.TableToJSON({}))))
        
		return false
	end,
    OnCanRun = function(item)
        if item.player:IsAdmin() then
    		return true
        end
        return false
    end
}