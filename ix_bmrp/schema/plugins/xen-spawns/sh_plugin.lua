local PLUGIN = PLUGIN

PLUGIN.name = "Xen Fauna Spawns"
PLUGIN.author = "Winter Rose!"
PLUGIN.description = "WIP System to handle naturally spawning xen fauna."
ix.XenSpawns = ix.XenSpawns or {}
ix.XenSpawns.ActiveXennians = ix.XenSpawns.ActiveXennians or 0
ix.XenSpawns.locations = ix.XenSpawns.locations or {}
ix.XenSpawns.SpawnTable = {
  [0] = "npc_vj_hlr1_headcrab",
  [1] = "npc_vj_hlr1_barnacle",
  [2] = "npc_vj_hlr1_houndeye",
  [3] = "npc_vj_hlr1_bullsquid",
}
ix.XenSpawns.XenChems = {
  ["npc_vj_hlr1_headcrab"] = 0,
  ["npc_vj_hlr1_barnacle"] = 1,
  ["npc_vj_hlr1_houndeye"] = 0,
  ["npc_vj_hlr1_bullsquid"] = 0,
  ["npc_vj_hlr1_headcrab_baby"] = 0,
  ["npc_vj_hlrdc_headcrab"] = 0,
  ["npc_vj_hlrdc_houndeye"] = 0,
  ["npc_vj_hlr1_ichthyosaur"] = 0,
  ["npc_vj_hlr1_kingpin"] = 0,
  ["npc_vj_hlr1_mrfriendly"] = 0,
  ["npc_vj_hlrdc_bullsquid"] = 0,
  ["npc_vj_hlr1_xen_tree"] = 1,
  ["npc_vj_hlrdc_xen_tree"] = 1,
  ["npc_vj_hlrof_gonome"] = 3,
  ["npc_vj_hlr1_zombie"] = 3,
  ["npc_vj_hlrdc_zombie"] = 3,
  ["npc_vj_hlrfi_blackopszombie"] = 3,
  ["npc_vj_hlrfi_zombie_hev"] = 3,
  ["npc_vj_hlrof_zombie_sec"] = 3,
  ["npc_vj_hlrof_zombie_soldier"] = 3,
  ["npc_vj_hlr1_aliengrunt"] = 2,
  ["npc_vj_hlrdc_aliengrunt"] = 2,
  ["npc_vj_hlr1_aliencontroller"] = 2,
  ["npc_vj_hlr1a_aliengrunt"] = 2,
  ["npc_vj_hlr1_alienslave"] = 4,
  ["npc_vj_hlrdc_alienslave"] = 4,
}

ix.config.Add("MaxWildXennians", 10, "Maximum number of wild xennians that can be spawned",
	function(oldValue, newValue)
	end,
	{
		data = {min = 5, max = 30},
		category = "Wild Xennians"
	}
)

function PLUGIN:LoadData()
  ix.XenSpawns.locations = self:GetData() or {}
  ix.XenSpawns.ActiveXennians = 0
  if !(CLIENT) then
      PLUGIN:StartXenSpawner()
  end
end
  
function PLUGIN:SaveSpawns()
  self:SetData(ix.XenSpawns.locations)
end

ix.command.Add("AddXenSpawn", {
	description = "@cmdSpawnAdd",
	privilege = "Manage Spawn Points",
	adminOnly = true,
	arguments = {
		ix.type.number,
	},
	OnRun = function(self, client, type)
      local TargetPos = client:GetEyeTrace().HitPos
      if ix.XenSpawns.SpawnTable[type] then
        table.Add(ix.XenSpawns.locations,{{type,TargetPos}})
        PLUGIN:SaveSpawns()
      end
	end
})

ix.command.Add("RemoveXenSpawn", {
	description = "@cmdSpawnRemove",
	privilege = "Manage Spawn Points",
	adminOnly = true,
	arguments = bit.bor(ix.type.number, ix.type.optional),
	OnRun = function(self, client, radius)
		radius = radius or 100

		local position = client:GetPos()
		local i = 0

		for K, v in pairs(ix.XenSpawns.locations) do
    		local c = v[2]
            if c.x > position.x-radius and c.x < position.x+radius and 
               c.y > position.y-radius and c.y < position.y+radius and 
               c.z > position.z-radius and c.z < position.z+radius then 
                i = i + 1
                table.remove( ix.XenSpawns.locations, K )
            end
		end

		if (i > 0) then
			PLUGIN:SaveSpawns()
		end

		return "@spawnDeleted", i
	end
})

if (SERVER) then 
  ix.allowedHoldableClasses["chemicalgib"] = true 
  function PLUGIN:StartXenSpawner()
    timer.Create("XennianTimer", 15, -1, function()
        if ix.XenSpawns.ActiveXennians < ix.config.Get("MaxWildXennians") and !table.IsEmpty(ix.XenSpawns.locations) then
          if math.random(0,100) <= 100-(50*(ix.XenSpawns.ActiveXennians/ix.config.Get("MaxWildXennians",10))) then
            local XennDate = table.Random(ix.XenSpawns.locations)
            local NewXennian = ents.Create( ix.XenSpawns.SpawnTable[XennDate[1]] )
            NewXennian:SetPos( XennDate[2] + Vector(0,0,5) )
            NewXennian:SetAngles(Angle(0,math.random(0,360),0))
            NewXennian:Spawn()
            NewXennian.IsWinterXennian = true
            ix.XenSpawns.ActiveXennians =ix.XenSpawns.ActiveXennians + 1
            ix.log.AddRaw("Wild Xennian has been spawned")
          end
          
        end
    end)
  end
  function PLUGIN:OnNPCKilled(ent,attacker)
    if ent.IsWinterXennian then
      ix.XenSpawns.ActiveXennians =ix.XenSpawns.ActiveXennians - 1
      ix.log.AddRaw("Wild Xennian has been slain by "..attacker:GetName())
    end
    if ix.XenSpawns.XenChems[ent:GetClass()] then 
      local Gib = ents.Create( "chemicalgib" )
      Gib:SetPos( ent:GetPos() + Vector(0,0,5) )
      Gib:SetAngles(Angle(0,math.random(0,360),0))
      Gib:Spawn()
      Gib:SetOrigin(ix.XenSpawns.XenChems[ent:GetClass()])
    end
  end
  
  function PLUGIN:EntityRemoved(ent)
  end
end