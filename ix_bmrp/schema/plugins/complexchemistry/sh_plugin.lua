local PLUGIN = PLUGIN

PLUGIN.name = "Complex Chemistry"
PLUGIN.author = "Winter Rose"
PLUGIN.description = "An integrated complex chemical system originally made for BMRP, that introduces a vast array of chemical work that can be done!"

ix.chemistry = ix.chemistry or {}

ix.config.Add("IXW_DisableScience", false, "Turn ON to prevent players from being able to spawn science equipment.", nil, {
	category = "Winter's Chemistry"
})
ix.config.Add("IXW_CanUseRequester", true, "Turn OFF to prevent the requester from functioning.", nil, {
	category = "Winter's Chemistry"
})

ix.util.Include("sh_chemistry_tables.lua")
ix.util.Include("cl_screenalter.lua")

function ix.chemistry.GetChemName(ChemID)
    -- simple func to quickly get the name of the input ID  
    local InterMed = ix.chemistry.List[ChemID]
    if InterMed == nil then 
        InterMed = ix.chemistry.List[0]
    end
    return InterMed[1]
end

function ix.chemistry.CheckReaction(RecipeID,ContainedChemicals,Mode)
    -- Checks wether or not the recipe list matches the 2nd input 
    if Mode == 0 then
        local TargRecipe = ix.chemistry.MixingList[RecipeID]
        local NeededChemicals = TargRecipe[1]
        table.sort(NeededChemicals, function(a, b) return a[1] < b[1] end )
        table.sort(ContainedChemicals, function(a, b) return a[1] < b[1] end )
        if !(ix.chemistry.MixingList[RecipeID]) then 
            return false
        end
        if table.ToString(NeededChemicals) == table.ToString(ContainedChemicals) then
            return true 
        else 
            return false
        end
    else
        local TargRecipe = ix.chemistry.ItemCraft[RecipeID]
        local NeededChemicals = TargRecipe[1]
        table.sort(NeededChemicals, function(a, b) return a[1] < b[1] end )
        table.sort( ContainedChemicals, function(a, b) return a[1] < b[1] end )
        if !(ix.chemistry.ItemCraft[RecipeID]) then 
            return false
        end
        if table.ToString(NeededChemicals) == table.ToString(ContainedChemicals) then
            return true 
        else 
            return false
        end 
    end
    return false
end

function ix.chemistry.ExtractionProcessing(inputData)
    local CompletionChem = 1
    local CompletionVol = 200
    return {CompletionChem,CompletionVol}
end

if (SERVER) then
    ix.allowedHoldableClasses["chemistry_storage_small"] = true

    function ix.chemistry.ApplyChem(Target,ChemID)
        if !(IsValid(Target) or table.HasValue(ix.chemistry.List[ChemID])) then 
            return false 
        end 
        if !(Target:IsPlayer() or Target:IsNPC()) then 
            return false 
        end
        local ChemEffectTab = ix.chemistry.List[ChemID][4]
        if ChemEffectTab == nil or ChemEffectTab == 0 then 
            if Target:IsPlayer() then Target:ChatNotify("You feel no effect after drinking") end
            return false 
        end
        if ChemEffectTab == 1 then
            Target:TakeDamage(5)
            if Target:IsPlayer() then Target:ChatNotify("You feel slightly rejuvinated")end
        elseif ChemEffectTab == 2 then
            if Target:IsPlayer() then Target:ChatNotify("You feel ill") end
            timer.Create( "KillLaKill"..Target:GetName(), 1, 10, function()
                    Target:TakeDamage(5)
                    Target:EmitSound("npc_citizen.pain0"..math.random(0,9))
                    if Target:Health() <= 0 then
                        timer.Remove("KillLaKill"..Target:GetName())
                    end
                end)
        elseif ChemEffectTab == 3 then
            if Target:IsPlayer() then Target:ChatNotify("You feel ill, and start coughing up blood")end
            timer.Create( "Death"..Target:GetName(), 1, 10, function()
                    if !IsValid(Target) then
                        timer.Remove("Death"..Target:GetName())
                    end
                    Target:TakeDamage(10)
                    if Target:Health() <= 0 then
                        timer.Remove("Death"..Target:GetName())
                    end
                    if Target:IsPlayer() then Target:GetCharacter():SetData("SpeedModifier",0.4)end
                    Target:EmitSound("npc_citizen.pain0"..math.random(0,9))
                end)
        elseif ChemEffectTab == 4 then
            if Target:IsPlayer() then Target:ChatNotify("You feel ill, and like your skin is bubbling")end
            timer.Create( "KillLaColor"..Target:GetName(), 2, 5, function()
                    Target:TakeDamage(5)
                    Target:SetMaxHealth(Target:GetMaxHealth()-5)  
                    Target:EmitSound("npc_citizen.pain0"..math.random(0,9))
                    if Target:Health() <= 0 then
                        timer.Remove("KillLaColor"..Target:GetName())
                    end
                    if timer.RepsLeft("KillLaColor"..Target:GetName()) == 0 then
                        if Target:IsPlayer() then Target:ChatNotify("You feel your breath become raspy, but the pain has stopped. Mostly.")end
                        Target:SetColor(Color(math.random(0,255),math.random(0,255),math.random(0,255),255))
                        timer.Create( "RestoreColor"..Target:GetName(), 1, 0, function()  
                                if Target:Health() <= 0 then
                                    Target:SetColor(Color(255,255,255,255))
                                    timer.Remove("RestoreColor"..Target:GetName())
                                end
                            end)
                    end
                end)
        elseif ChemEffectTab == 5 then
            if Target:IsPlayer() then Target:ChatNotify("The ooze is thick and horrible, but you start to feel a bit better") end
            timer.Create( "WeakHealOoze"..Target:GetName(), 1, 15, function()
                    Target:SetHealth(Target:Health()+1)  
                    if Target:Health() >= Target:GetMaxHealth() then
                        timer.Remove("WeakHealOoze"..Target:GetName())
                    end
                end)
        elseif ChemEffectTab == 6 then
            if Target:IsPlayer() then Target:ChatNotify("The chemicals act quick, and you start to feel more rejuvinated!")end
            timer.Create( "StrongHealOoze"..Target:GetName(), 1, 25, function()
                    Target:SetHealth(Target:Health()+2)  
                    if Target:Health() >= Target:GetMaxHealth()*2 then
                        timer.Remove("StrongHealOoze"..Target:GetName())
                    end
                end)
        elseif ChemEffectTab == 7 then
            if Target:IsPlayer() then Target:ChatNotify("The ooze is slick and thick, and you feel sick as it enters you, but after a few seconds you start to feel a bit more resistant!")end
            timer.Create( "WeakArmorOoze"..Target:GetName(), 1, 5, function()
                    Target:SetArmor(Target:Armor()+1)  
                    if Target:Armor() >= Target:GetMaxArmor() then
                        timer.Remove("WeakArmorOoze"..Target:GetName())
                    end
                end)
        elseif ChemEffectTab == 8 then
            if Target:IsPlayer() then Target:ChatNotify("You feel energy start to course through your system, and you start to feel more powerful!") end
            timer.Create( "StrongArmorOoze"..Target:GetName(), 1, 50, function()
                    Target:SetArmor(Target:Armor()+1)  
                    if Target:Armor() >= Target:GetMaxArmor()*1.5 then
                        timer.Remove("StrongArmorOoze"..Target:GetName())
                    end
                end)
        elseif ChemEffectTab == 9 then
            if Target:IsPlayer() then Target:ChatNotify("You feel sick and quezy... And like you could really go for some orange juice?") end
            Target:SetModelScale(Target:GetModelScale()*0.8,30)
        elseif ChemEffectTab == 10 then
            if Target:IsPlayer() then Target:ChatNotify("You feel sick and quezy... And like you could really go for some orange juice?") end
            Target:SetModelScale(Target:GetModelScale()*1.4,30)
        elseif ChemEffectTab == 11 then
            if Target:IsPlayer() then Target:ChatNotify("You cough, your lungs feel course as you cough up blood and your skin feels flaky") end
            timer.Create( "TiberiumFever"..Target:GetName(), 2, 5, function()
                    Target:TakeDamage(5)
                    Target:EmitSound("npc_citizen.pain0"..math.random(0,9))
                    if Target:Health() <= 0 then
                        timer.Remove("TiberiumFever"..Target:GetName())
                    end
                    if timer.RepsLeft("TiberiumFever"..Target:GetName()) == 0 then
                        if Target:IsPlayer() then Target:ChatNotify("You feel your breath become raspy as blood drips from your mouth, your skin is green and flaky and its hard to breath.")end
                        Target:SetColor(Color(math.random(52,62),math.random(170,220),math.random(25,38),255))
                        local ent = ents.Create("prop_physics")
                        ent:SetPos(Target:GetPos()+Vector(0,0,22))
                        ent:SetModel("models/props_xen/crystals/xen_crystals_orange_3_micro.mdl")
                        ent:Spawn()
                        if Target:IsPlayer() then ent:SetOwner(Target) end 
                        if Target:IsNPC() then Target:SetSchedule(SCHED_NPC_FREEZE) Target:SetCondition(COND.NPC_FREEZE) end
                        ent:SetColor( Color(math.random(52,62),math.random(170,220),math.random(25,38),math.random(200,220))) 
                        local phys = ent:GetPhysicsObject()
                        phys:EnableMotion( false )
                        Target:Freeze(true)
                        timer.Create( "TiberiumFeverCure"..Target:Nick(), 1, 0, function()  
                                if Target:Health() <= 0 then
                                    Target:Freeze(false)
                                    Target:Kill()
                                    Target:SetColor(Color(255,255,255,255))
                                    ent:SetOwner(nil)
                                    timer.Remove("TiberiumFeverCure"..Target:Nick())
                                end
                            end)
                    end
                end) 
        elseif ChemEffectTab == 12 then
            if Target:IsPlayer() then 
                Target:ChatNotify("You are now high. :)\nDo what your character would do if they were high.")
                Target:GetCharacter():SetData('ChemSystem_Meth',100)
                timer.Create( "RemMeth_"..Target:Nick(), 1, 0, function()  
                        Target:GetCharacter():SetData('ChemSystem_Meth',Target:GetCharacter():GetData('ChemSystem_Meth',100)-1)
                        if Target:GetCharacter():GetData('ChemSystem_Meth',0) == 0 then
                            Target:GetCharacter():SetData('ChemSystem_Meth',0)
                            Target:ChatNotify("You are no longer high.")
                            timer.Remove("RemMeth_"..ply:GetName())
                        end 
                    end)
            end
        elseif ChemEffectTab == 13 then
            if Target:IsPlayer() then Target:ChatNotify("As the chemical enters your system, you start to spasm in pain, as you feel like your insides are being burned and torn apart.")
                Target:SetRagdolled(true, 24, 24)
            end
            timer.Create( "AbnormalDeath"..Target:GetName(), 1, 0, function()
                    local d = DamageInfo()
                    d:SetDamage( 15 )
                    d:SetAttacker( Target )
                    d:SetDamageType( DMG_DISSOLVE ) 
                    Target:TakeDamageInfo( d )
                    if Target:Health() <= 0 then
                        timer.Remove("AbnormalDeath"..Target:GetName())
                    end
                end)
        elseif ChemEffectTab == 14 then 
            if Target:IsPlayer() then Target:ChatNotify("As the chemicals mix with your body, you go to let out a cough, as every pore on your skin bursts in flame.") end
            Target:Ignite(120)
        elseif ChemEffectTab == 15 then
            timer.Create( "MercuryPoison1_"..Target:GetName(), 30, math.random(3,10), function()
                    if Target:Health() <= 0 then
                        timer.Remove("MercuryPoison1_"..Target:GetName())
                    end
                    if timer.RepsLeft("MercuryPoison1_"..Target:GetName()) == 0 then
                        timer.Create( "MercuryPoison2_"..Target:GetName(), 30, 0, function()
                                if Target:IsPlayer() then ix.chat.Send(Target, "me", "coughs, spitting up some blood", false, nil) end
                                local d = DamageInfo()
                                d:SetDamage(2)
                                d:SetAttacker( Target )
                                d:SetDamageType( DMG_ACID ) 
                                Target:TakeDamageInfo( d )
                                if Target:Health() <= 0 then
                                    timer.Remove("MercuryPoison2_"..Target:GetName())
                                end
                            end)
                    end
                end)
        elseif ChemEffectTab == 16 then
            if timer.Exists("MercuryPoison1_"..Target:GetName())then 
                timer.Remove("MercuryPoison1_"..Target:GetName())
            end 
            if timer.Exists("MercuryPoison2_"..Target:GetName())then 
                timer.Remove("MercuryPoison2_"..Target:GetName())
            end 
            if timer.Exists("KillLaKill"..Target:GetName())then 
                timer.Remove("KillLaKill"..Target:GetName())
            end 
            if timer.Exists("Death"..Target:GetName())then 
                timer.Remove("Death"..Target:GetName())
            end 
            if timer.Exists("TiberiumFever"..Target:GetName())then 
                timer.Remove("TiberiumFever"..Target:GetName())
            end 
            if timer.Exists("RemMeth_"..ply:GetName())then 
                timer.Remove("RemMeth_"..ply:GetName())
                ply:GetCharacter():SetData('ChemSystem_Meth',0)
            end 
            Target:SetModelScale(1,10)
        end
        return true
    end

    function ChemicalPoison(Target,IntDamage)
        Target:SetHealth(Target:Health()-10)
    end

    function PLUGIN:PlayerDeath(ply)
        if timer.Exists("MercuryPoison1_"..ply:GetName())then 
            timer.Remove("MercuryPoison1_"..ply:GetName())
        end 
        if timer.Exists("MercuryPoison2_"..ply:GetName())then 
            timer.Remove("MercuryPoison2_"..ply:GetName())
        end 
        if timer.Exists("RemMeth_"..ply:GetName())then 
            timer.Remove("RemMeth_"..ply:GetName())
            ply:GetCharacter():SetData('ChemSystem_Meth',0)
        end 
    end
    function PLUGIN:PostPlayerLoadout(ply)
        local Modifier = ply:GetCharacter():GetData("SpeedModifier",1)
        ply:SetMaxHealth(100)
        ply:SetModelScale(1)
    end
end

if (CLIENT) then 
    netstream.Hook("Chemistry_ReadOut_Dyna", function(contents)
            local paper = vgui.Create("Chemistry_ReadOut")
            paper:setText(contents)
        end)
    netstream.Hook("Chemistry_SynthMenu", function(contents, id)
            local paper = vgui.Create("Chemistry_SynthPanel")
            paper:setText(contents, id)
        end)
else 
    netstream.Hook("GetChemTable", function(client,id)
            PrintTable(Entity(id).NewChemTable)
            return Entity(id).NewChemTable
        end)
    netstream.Hook("SynthManufacture", function(client,CT,MachineID)
            if Entity(MachineID).IsSynthesiser then
                local char = client:GetCharacter()
                local cash = char:GetMoney()
                local ChemT = util.JSONToTable(CT)
                if cash >= ChemT[3] then
                Entity(MachineID):BeginSynthesis(CT)
                client:ChatNotify("You have ordered "..ChemT[2].."ml of "..ix.chemistry.GetChemName(ChemT[1]).." for "..ChemT[3].." credits.")
                char:SetMoney(char:GetMoney() - ChemT[3])
                else
                    client:ChatNotify("Insufficient Funds")
                end
            else
                print("ERROR IN SYNTHESIS")
            end
        end)
end