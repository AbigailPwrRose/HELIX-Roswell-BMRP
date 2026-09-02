ITEM.name = "Aiya-Aid Syringe"
ITEM.model = Model("models/warz/items/syringe.mdl")
ITEM.description = "A syringe containing a chemical mixture able to patch up most wounds."
ITEM.category = "Medical"
ITEM.width = 1 -- Width and height refer to how many grid spaces this item takes up.
ITEM.height = 1
ITEM.healval = 5
ITEM.stamval = 0
ITEM.MaxUses = 1
ITEM.price = 0
ITEM.grade = "Medical"

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
        if item.MaxUses > 1 then
            for i = 1,item:GetData("Uses",item.MaxUses) do
                surface.SetDrawColor(110, 255, 110, 100)
                surface.DrawRect(7 + ((i - 1) * (6+8)), h - 14, 8, 8)
            end 
        end
	end
    function ITEM:PopulateTooltip(tooltip)
        if self.healval != 0 then 
            local tip1 = tooltip:AddRow("Rarity")
            tip1:SetBackgroundColor(Color(220,99,99,20))
            tip1:SetText("This item modifies HP by "..self.healval)
            tip1:SetFont("DermaDefault")
            tip1:SizeToContents() 
        end
        if self.stamval != 0 then 
            local tip2 = tooltip:AddRow("Rarity")
            tip2:SetBackgroundColor(Color(99,99,220,20))
    		tip2:SetText("This item modifies Stamina by "..self.stamval)
            tip2:SetFont("DermaDefault")
            tip2:SizeToContents() 
        end
        if self.MaxUses > 1 then 
            local tip3 = tooltip:AddRow("Rarity")
            tip3:SetBackgroundColor(Color(99,99,99,20))
            tip3:SetText("There are "..self:GetData("Uses",self.MaxUses).." uses left.")
            tip3:SetFont("DermaDefault")
            tip3:SizeToContents() 
        end
    end
end

ITEM.functions.AApplyToSelf = {
    name = "Apply to Self",
	OnRun = function(item)
        
		local client = item.player
        local character = client:GetCharacter()
        local healTime = 5
        if item:GetData("InUse",false) then 
            client:Notify("Already using this item")
            return false 
        end
        if client:Health() < client:GetMaxHealth() then
            item:SetData("InUse",true,nil, true)
            client:SetAction("Applying...", healTime, function()
                    item:SetData("InUse",false,nil, true)
                    client:Notify("Finished!")
                    client:SetHealth(client:Health()+item.healval)
					client:SetLocalVar("stm", client:GetLocalVar("stm", 0)+item.stamval)
                    
                    if client:Health() > client:GetMaxHealth() then 
                        client:SetHealth(client:GetMaxHealth()) 
                    end
                    --character:UpdateAttrib("medical", 0.1)
                    item:DoUsageCountdown()
                end)
        else 
            client:Notify("Current Health too high!")
        end
        return false
	end
}
ITEM.functions.BApplyToOther= {
    name = "Apply to Other",
	OnRun = function(item)
        
		local client = item.player
        local target = client:GetEyeTrace().Entity
        local character = client:GetCharacter()
        local healTime = 5
        if item:GetData("InUse",false) then 
            client:Notify("Already using this item")
            return false 
        end
        if IsValid(target) and (target:IsPlayer() or target:IsNPC()) then
            if target:Health() < target:GetMaxHealth() then
                
                item:SetData("InUse",true,nil, true)
                client:SetAction("Tending...", healTime)
                if target:IsPlayer() then 
                target:SetAction("You're being tended to...", healTime)	end

                client:DoStaredAction(target, function()
                        item:SetData("InUse",false,nil, true)
                        client:Notify("You have tended "..target:GetName())
                        
                        target:SetHealth(target:Health()+item.healval)
                        if target:Health() > target:GetMaxHealth() then 
                            target:SetHealth(target:GetMaxHealth()) 
                        end
                        --character:UpdateAttrib("medical", 0.1)
                        
                        if target:IsPlayer() then 
                            target:NotifyLocalized("You have been tended by "..client:Name())
                            target:SetLocalVar("stm", target:GetLocalVar("stm", 0)+item.stamval)
                        end
                        item:DoUsageCountdown()
                        
                end, healTime, function()
                        client:SetAction()
                        item:SetData("InUse",false,nil, true)
                        if target:IsPlayer() then 
                    		target:SetAction() end	
                        
                end)
                
            else
                client:Notify("Target Health too high!")
            end
        else
            client:Notify("Invalid Target!")
        end
        return false
	end
}
function ITEM:DoUsageCountdown()
    self:SetData("Uses",self:GetData("Uses",self.MaxUses)-1)
    if self:GetData("Uses",self.MaxUses) <= 0 then 
        self:Remove()
    end
end