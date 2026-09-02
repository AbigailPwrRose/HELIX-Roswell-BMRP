local PLUGIN = PLUGIN

PLUGIN.name = "Ranks"
PLUGIN.author = "GeFake"
PLUGIN.description = "The ranks for factions"

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")

--[[---------------------------------------------------------

-------------------------------
------------ USAGE ------------
-------------------------------

Add Ranks table into faction you need

FACTION.Ranks = {
    [1] = {"Private", "icon16/medal_bronze_1.png", CLASS_RECRUIT, true}
}

Let's look at the table in more detail:

"Recruit" ---> name of the rank
------------------------------------
"icon16/medal_bronze_1.png" ---> icon, used in PopulateCharacterInfo (tooltip). If you don't need this, just set nil
------------------------------------
CLASS_ELITE ---> class (you need put class index), sets when rank changed. If you don't need this, just set nil
------------------------------------
true ---> Boolean for high ranks. "true" means that a player can assign ranks to other players. If you don't need this, just don't set anything

The finished table looks like this:

FACTION.Ranks = {
    [1] = {"Private", nil, CLASS_RECRUIT},
    [2] = {"Corporal", nil, CLASS_RECRUIT},
    [3] = {"Specialist", nil, nil},
    [4] = {"Sergeant", "icon16/medal_bronze_1.png", CLASS_OFFICER},
    [5] = {"Master Sergeant", "icon16/medal_silver_1.png", CLASS_SENIOR, true},
    [6] = {"Sergeant Major", "icon16/medal_gold_1.png", CLASS_SENIOR, true}
}

----------------------------------
------------ COMMANDS ------------
----------------------------------

CharSetRank /// Chat command ONLY for admins. If you need set rank for any character, use this.

----------------------------------

CharRaise /// Chat command for everyone. Player may raise a character if:

    1. The client rank is lower than the target rank
    2. Client character rank has the fourth true expression in the rank table ( [6] = {"Sergeant Major", nil, nil, true} )
    3. Client faction == Target faction
    4. If client != target

-----------------------------------
------------ FUNCTIONS ------------
-----------------------------------

Plugin has function called when character rank changed

You need add this into your faction:

function FACTION:OnRankChanged(client, oldValue, value)
    --- Do something ---
end

-----------------------------------------------------------]]

ix.char.RegisterVar("rank", { 
    field = "rank",
    fieldType = ix.type.number,
    default = 1
})
ix.char.RegisterVar("rankTime", { 
    field = "rankTime",
    fieldType = ix.type.number,
    default = 0
})

if (SERVER) then 
  function PLUGIN:DoRankTick(Target) 
    local factionTable = ix.faction.Get(Target:Team())
    local rankTable = factionTable.Ranks
    local character = Target:GetCharacter()
    local rank = character:GetRank()
    
    local CurT = character:GetRankTime()
    character:SetRankTime(character:GetRankTime() + 1)
    
    if character:GetRankTime() >= rankTable[rank][5] then 
      character:SetRankTime(0)
      character:SetRank(rank+1)
      Target:Notify("You've ranked up!")
    end
    
  end
  
  timer.Create("GlobalRankTimer", 1, -1, function()
      for i, v in ipairs( player.GetAll() ) do
        local character = v:GetCharacter()
        local factionTable = ix.faction.Get(v:Team())
        if character and factionTable then
        local rankTable = factionTable.Ranks
        local rank = character:GetRank()
        if rankTable and rankTable[rank][5] then
            PLUGIN:DoRankTick(v)
        end end
      end
  end)
end

function PLUGIN:GetSalaryAmount(client, faction) 
  local pay = faction.pay
  local rankTable = faction.Ranks
  local character = client:GetCharacter()
  local rank = character:GetRank()
  
  if rankTable and rankTable[rank][6] then
      pay = pay + rankTable[rank][6]
  end
  
  return pay
end

ix.command.Add("CharSetRank", {
    arguments = {
        ix.type.player,
        ix.type.number
    },
    description = "@cmdCharSetRank",
    adminOnly = true,
    OnRun = function(self, client, target, rank)
        local factionTable = ix.faction.Get(target:Team())
        local rankTable = factionTable.Ranks
        local character = target:GetCharacter()

        if not rankTable or not rankTable[rank] or not isnumber(rank) or (rank > #rankTable) then return client:NotifyLocalized("undefinedRank") end
      
        character:SetRankTime(0)
        character:SetRank(rank)
        client:NotifyLocalized("characterRaiseAdmin", target:Name(), rankTable[rank][1])
        target:NotifyLocalized("characterRaiseNotify", rankTable[rank][1])
    end
})

ix.command.Add("CharRaise", {
    arguments = {
        ix.type.player,
        ix.type.number
    },
    description = "@cmdCharRaise",
    OnRun = function(self, client, target, rank)
        local factionTable = ix.faction.Get(target:Team())
        local rankTable = factionTable.Ranks
        local character = target:GetCharacter()

        if (client:SteamID() == target:SteamID()) then return client:NotifyLocalized("cannotAllowRaiseYourself") end
        if not rankTable or not rankTable[rank] or not isnumber(rank) or (rank > #rankTable) then return client:NotifyLocalized("undefinedRank") end
        if (client:Team() ~= target:Team()) or !rankTable[client:GetCharacter():GetRank()][4] or (rank >= client:GetCharacter():GetRank()) then return client:NotifyLocalized("cannotAllowRaise") end

        character:SetRankTime(0)
        character:SetRank(rank)
        client:NotifyLocalized("characterRaisePlayer", target:Name(), rankTable[rank][1])
        target:NotifyLocalized("characterRaiseNotify", rankTable[rank][1])
    end
})

ix.command.Add("Promote", {
    arguments = {
        ix.type.player
    },
    description = "Promote a character by one level.",
    adminOnly = true,
    OnCheckAccess = function(self, client) 
      local factionTable = ix.faction.Get(client:Team())
      local rankTable = factionTable.Ranks
      local character = client:GetCharacter()
      local rank = character:GetRank()
      if rankTable == nil then return false end
      if rankTable[rank][4] == true then
        return true
      end
      return false
    end,
    OnRun = function(self, client, target)
      if client != target and client:Team()==target:Team() then
            local factionTable = ix.faction.Get(target:Team())
            local rankTable = factionTable.Ranks
            local character = target:GetCharacter()
         	local rank = character:GetRank()+1
  
          if not rankTable or not rankTable[rank] or not isnumber(rank) or (rank > #rankTable) then return client:NotifyLocalized("undefinedRank") end
  
          character:SetRankTime(0)
          character:SetRank(rank)
          client:NotifyLocalized("You promoted %s to the rank of %s", target:Name(), rankTable[rank][1])
          target:NotifyLocalized("You were promoted to the rank %s", rankTable[rank][1])
      else
        client:Notify("You cannot do this!") end
    end
})

ix.command.Add("Demote", {
    arguments = {
        ix.type.player
    },
    description = "Promote a character by one level.",
    adminOnly = true,
    OnCheckAccess = function(self, client) 
      local factionTable = ix.faction.Get(client:Team())
      local rankTable = factionTable.Ranks
      local character = client:GetCharacter()
      local rank = character:GetRank()
      if rankTable == nil then return false end
      if rankTable[rank][4] == true then
        return true
      end
      return false
    end,
    OnRun = function(self, client, target)
      if client != target and client:Team()==target:Team() then
            local factionTable = ix.faction.Get(target:Team())
            local rankTable = factionTable.Ranks
            local character = target:GetCharacter()
         	local rank = character:GetRank()-1
  
          if not rankTable or not rankTable[rank] or not isnumber(rank) or (rank > #rankTable) then return client:NotifyLocalized("undefinedRank") end
        
          character:SetRankTime(0)
          character:SetRank(rank)
          client:NotifyLocalized("You promoted %s to the rank of %s", target:Name(), rankTable[rank][1])
          target:NotifyLocalized("You were promoted to the rank %s", rankTable[rank][1])
      else
        client:Notify("You cannot do this!") end
    end
})