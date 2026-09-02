ITEM.name = "Xen Sample Storage"
ITEM.description = "A specialised barrel that can be strapped onto the back of a HEV suit, intended for storing xen crystal samples to keep them safe during dimensional travel."
ITEM.category = "Bags"
ITEM.model = "models/props/hl4props/boom.mdl"
ITEM.rarity = "Rare"
ITEM.width = 2
ITEM.height = 3
ITEM.MaxOre = 5
ITEM.OreType = "xencrystal_overworld"
ITEM.OreColor = Color(221,157,61,255)
ITEM.price = 300

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
        NewDesc = NewDesc.."\n\nThis crate currently contains "..self:GetData("oreFill",0).."/"..self.MaxOre.." Xen Crystals."
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
                local ExtraData = util.TableToJSON({
                    ["customName"] = targEnt:GetNW2Var("customName",""),
                    ["resonanceFreq"] = targEnt:GetNW2Var("resonanceFreq",100),
                    ["stability"] = targEnt:GetNW2Var("stability",50),
                    ["Tested"] = targEnt:GetNW2Var("Tested",false),
                    ["Analyzed"] = targEnt:GetNW2Var("Analyzed",false)
                })
        
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
            local entN = ents.Create(item.OreType)
            entN:SetPos(Pos+Vector(0,0,5)) 
            entN:SetAngles(Angle(0.0, 90.0, 0.0))
            entN:Spawn()
            entN:SetModel(LIQ["M"])
      
            local CData = util.JSONToTable(LIQ["E"])
            entN:SetCVars(CData["customName"],true,CData["resonanceFreq"],CData["stability"],CData["Tested"],CData["Analyzed"])
      
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