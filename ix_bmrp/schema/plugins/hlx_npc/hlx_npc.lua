------------ MINIMUM TEMPLATE -------------
HLXNPC["template"] = {
    startdialog = function(ply,ent)
        return 1
    end,
    onTakeDamage = function(ent)
    end,
    dialogs = {
        [1] = {
            ["Text"] = [[
Hello, I am JOHN TEMPLATE, and I am an NPC!]],
            ["Args"] = function(ply, ent)
                return {}
            end,
            ["Condition"] = function(ply, ent)
                return true
            end,            
            ["Answers"] = {
                [1] = {
                    ["Condition"] = function(ply, ent)
                        return true
                    end,
                    ["Text"] = "I love you, John Template",
                    ["Args"] = function(ply, ent)
                        return {}
                    end,
                    ["CallBack"] = function(ply, ent)
                        ply:CloseNPCDialog()
                    end,
                },
                [2] = {
                    ["Condition"] = function(ply, ent)
                        return true
                    end,
                    ["Text"] = "Kill yourself, NOW.",
                    ["Args"] = function(ply, ent)
                        return {}
                    end,
                    ["CallBack"] = function(ply, ent)
                        ply:CloseNPCDialog()
                    end,
                },
            },
        },
    },
}
--------------------------------------
HLXNPC["SecurityArmory"] = {
    startdialog = function(ply,ent)
        return 1
    end,
    onTakeDamage = function(ent)
    end,
    dialogs = {
        [1] = {
            ["Text"] = [[
"Hey there, what can I do for you?"]],
            ["Args"] = function(ply, ent)
                return {}
            end,
            ["Condition"] = function(ply, ent)
                return true
            end,            
            ["Answers"] = {
                [1] = {
                    ["Condition"] = function(ply, ent)
                        return true
                    end,
                    ["Text"] = "Nothing, thanks",
                    ["Args"] = function(ply, ent)
                        return {}
                    end,
                    ["CallBack"] = function(ply, ent)
                        ply:CloseNPCDialog()
                    end,
                },
                [2] = {
                    ["Condition"] = function(ply, ent)
                        return true
                    end,
                    ["Text"] = "Where can I get guns?",
                    ["Args"] = function(ply, ent)
                        return {}
                    end,
                    ["CallBack"] = function(ply, ent)
                        ply:OpenNPCDialog(ent,2)
                    end,
                },
                [3] = {
                    ["Condition"] = function(ply, ent)
                        if ix.faction.Get(ply:GetCharacter():GetFaction()).name == "Black Mesa Security" then
                        local inventory = ply:GetCharacter():GetInventory()
                        local rank = ply:GetCharacter():GetRank()
                          if inventory:CanItemFit(0, 0, 2, 1) and !inventory:HasItem("pistol_nine") and rank > 1 then
                        	return true end end
                        return false
                    end,
                    ["Text"] = "Can I get my standard issue weapon?",
                    ["Args"] = function(ply, ent)
                        return {}
                    end,
                    ["CallBack"] = function(ply, ent)
                        local inventory = ply:GetCharacter():GetInventory()
                        inventory:Add("pistol_nine", 1)
                        ply:OpenNPCDialog(ent,3)
                    end,
                },
            },
        },
        [2] = {
            ["Text"] = [[
"Security get their guns either from me, or that locker behind 
me. Anyone else gets their guns from who-knows where.""]],
            ["Args"] = function(ply, ent)
                return {}
            end,
            ["Condition"] = function(ply, ent)
                return true
            end,            
            ["Answers"] = {
                [1] = {
                    ["Condition"] = function(ply, ent)
                        return true
                    end,
                    ["Text"] = "Alright",
                    ["Args"] = function(ply, ent)
                        return {}
                    end,
                    ["CallBack"] = function(ply, ent)
                        ply:OpenNPCDialog(ent,1)
                    end,
                },
            },
        },
        [3] = {
            ["Text"] = [[
"Here you go. Keep it safe now."]],
            ["Args"] = function(ply, ent)
                return {}
            end,
            ["Condition"] = function(ply, ent)
                return true
            end,            
            ["Answers"] = {
                [1] = {
                    ["Condition"] = function(ply, ent)
                        return true
                    end,
                    ["Text"] = "Thanks",
                    ["Args"] = function(ply, ent)
                        return {}
                    end,
                    ["CallBack"] = function(ply, ent)
                        ply:CloseNPCDialog()
                    end,
                },
            },
        },
    },
}
----------------------------------
HLXNPC["CrystalSubmit"] = {
    startdialog = function(ply,ent)
        return 1
    end,
    onTakeDamage = function(ent)
    end,
    dialogs = {
        [1] = {
            ["Text"] = [[
The woman stands by her desk, fidelling with her clipboard as you 
approach. She looks up at you, "Ah! Hello, how can I be of assistance?"]],
            ["Args"] = function(ply, ent)
                return {}
            end,
            ["Condition"] = function(ply, ent)
                return true
            end,            
            ["Answers"] = {
                [1] = {
                    ["Condition"] = function(ply, ent)
                        return true
                    end,
                    ["Text"] = "Nothing, bye",
                    ["Args"] = function(ply, ent)
                        return {}
                    end,
                    ["CallBack"] = function(ply, ent)
                        ply:CloseNPCDialog()
                    end,
                },
                [2] = {
                    ["Condition"] = function(ply, ent)
                        return true
                    end,
                    ["Text"] = "How do I submit Xen Crystals?",
                    ["Args"] = function(ply, ent)
                        return {}
                    end,
                    ["CallBack"] = function(ply, ent)
                        ply:OpenNPCDialog(ent,2)
                    end,
                },
                [3] = {
                    ["Condition"] = function(ply, ent)
                        local EntTab = ents.FindInBox(Vector(3620.674072,1010.543091,-1641.968750),Vector(3557.031250,1121.136353,-1584.245728))
                        local Count = 0
                        for k,v in pairs(EntTab) do
                        local c = v:GetClass()
                          if c == "xencrystal_overworld" or c == "troiliteore_ore" or c == "echiruscrystal_shard" then
                            Count = Count +1 
                          end
                        end
                        if Count > 0 then
                        	return true 
                        end 
                        return false
                    end,
                    ["Text"] = "I'd like to submit a crystal",
                    ["Args"] = function(ply, ent)
                        return {}
                    end,
                    ["CallBack"] = function(ply, ent)
                        ply:OpenNPCDialog(ent,3)
                    end,
                },
                [4] = {
                    ["Condition"] = function(ply, ent)
                        local inventory = ply:GetCharacter():GetInventory()
                        if inventory:HasItem("weather_report") then
                        	return true 
                        end return false
                    end,
                    ["Text"] = "I'd like to submit a report",
                    ["Args"] = function(ply, ent)
                        return {}
                    end,
                    ["CallBack"] = function(ply, ent)
                        ply:OpenNPCDialog(ent,4)
                    end,
                },
            },
        },
        [2] = {
            ["Text"] = [[
"Ah! Xen crystals need to be tested at the Analyzer in Lambda's Generator. Once
thats done, I can purchase them on behalf of the facility if you just place them 
on this table. Additionally, you can sell them to individual scientists, if they're
willing to buy.
I won't pay as much for them, but I can also buy Troilite and Echirus."]],
            ["Args"] = function(ply, ent)
                return {}
            end,
            ["Condition"] = function(ply, ent)
                return true
            end,            
            ["Answers"] = {
                [1] = {
                    ["Condition"] = function(ply, ent)
                        return true
                    end,
                    ["Text"] = "Thanks",
                    ["Args"] = function(ply, ent)
                        return {}
                    end,
                    ["CallBack"] = function(ply, ent)
                        ply:CloseNPCDialog()
                    end,
                },
            },
        },
        [3] = {
            ["Text"] = [[
"One moment... Lets see, you have %s analyzed Xen crystals,
%s so that'll come out to %s dollars.
Have a nice day!"]],
            ["Args"] = function(ply, ent)
                local EntTab = ents.FindInBox(Vector(3620.674072,1010.543091,-1641.968750),Vector(3557.031250,1121.136353,-1584.245728))
                local CountXen = 0
                local CountEchirus = 0
                local CountTroilite = 0
                local bonusT = ""
                for k,v in pairs(EntTab) do
                  local c = v:GetClass()
                  if c == "xencrystal_overworld" and v:GetNW2Var("Analyzed",false) then
                    CountXen = CountXen +1 
                    v:Remove()
                  end
                  if c == "troiliteore_ore"  then
                    CountTroilite = CountTroilite +1 
                    v:Remove()
                  end
                  if c == "echiruscrystal_shard"  then
                    CountEchirus = CountEchirus +1 
                    v:Remove()
                  end
                  
                end
                if CountTroilite > 0 then 
                  bonusT = bonusT.." "..CountTroilite.." Troilite,"
                end
                if CountEchirus > 0 then 
                  bonusT = bonusT.." "..CountEchirus.." Echirus,"
                end
                local Payout = (CountXen*200)+(CountTroilite*50)+(CountEchirus*100)
                ply:GetCharacter():SetMoney(ply:GetCharacter():GetMoney()+Payout)
                return {CountXen,bonusT,Payout}
            end,
            ["Condition"] = function(ply, ent)
                return true
            end,            
            ["Answers"] = {
                [1] = {
                    ["Condition"] = function(ply, ent)
                        return true
                    end,
                    ["Text"] = "Thanks",
                    ["Args"] = function(ply, ent)
                        return {}
                    end,
                    ["CallBack"] = function(ply, ent)
                        ply:CloseNPCDialog()
                    end,
                },
            },
        },
        [4] = {
            ["Text"] = [[
"One moment... Lets see, you have %s reports, so that'll come out to 
%s dollars. Thank you for your work!"]],
            ["Args"] = function(ply, ent)
                local invent = ply:GetCharacter():GetInventory()
                local count = 0
                local bonus = 0
                for _, v in pairs(invent:GetItems(true)) do
            		if (v.uniqueID == "weather_report") then
            			count = count+1
                        invent:Remove(v:GetID())
            		end
            	end
                ply:GetCharacter():SetMoney(ply:GetCharacter():GetMoney()+(count*300)+bonus)
                return {count,(count*300)+bonus}
            end,
            ["Condition"] = function(ply, ent)
                return true
            end,            
            ["Answers"] = {
                [1] = {
                    ["Condition"] = function(ply, ent)
                        return true
                    end,
                    ["Text"] = "Thanks",
                    ["Args"] = function(ply, ent)
                        return {}
                    end,
                    ["CallBack"] = function(ply, ent)
                        ply:CloseNPCDialog()
                    end,
                },
            },
        },
    },
}