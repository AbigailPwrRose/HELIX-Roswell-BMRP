
PLUGIN.name = "Basic Prop Protection Better"
PLUGIN.author = "Chessnut, edited by .lynn & Winter Rose"
PLUGIN.description = "Adds a simple prop protection system."

CAMI.RegisterPrivilege({
	Name = "Helix - Bypass Prop Protection",
	MinAccess = "admin"
})

local PROP_BLACKLIST = {
	["models/props_c17/oildrum001_explosive.mdl"] = true,
	["models/props_junk/gascan001a.mdl"] = true,
	["models/props_phx/mk-82.mdl"] = true,
	["models/props_phx/cannonball.mdl"] = true,
	["models/props_phx/ball.mdl"] = true,
	["models/props_phx/amraam.mdl"] = true,
	["models/props_phx/misc/flakshell_big.mdl"] = true,
	["models/props_phx/ww2bomb.mdl"] = true,
	["models/props_phx/torpedo.mdl"] = true,
	["models/props/de_train/biohazardtank.mdl"] = true,
	["models/props_phx/misc/potato_launcher_explosive.mdl"] = true,
	["models/props_phx/oildrum001_explosive.mdl"] = true,
	["models/props_junk/wood_crate01_explosive.mdl"] = true,
	["models/props_junk/propane_tank001a.mdl"] = true,
	["models/props_explosive/explosive_butane_can.mdl"] = true,
	["models/props_explosive/explosive_butane_can02.mdl"] = true,

	["models/lt_c/sci_fi/dm_container.mdl"] = true,
	["models/lt_c/sci_fi/dm_container_small.mdl"] = true,
	
}

if (SERVER) then
    function PLUGIN:PlayerSpawnProp(ply, model )
		if (ply:IsAdmin() or ply:GetCharacter():HasFlags("B")) then
			return true
		end
		return false
    end
    function PLUGIN:PlayerSpawnRagdoll(ply,model)
		if (ply:IsAdmin() or ply:GetCharacter():HasFlags("B")) then
			return true
		end
		return false
    end
	function PLUGIN:PlayerSpawnObject(client, model, entity)
		--if ((
		--	client.ixNextSpawn = CurTime() + 0.75
		--else
		--	return false
		--end

		if (!client:IsAdmin() and PROP_BLACKLIST[model:lower()]) then
			return false
		end
	end

	function PLUGIN:PhysgunPickup(client, entity)
		if (client != entity:GetVar("FPPOwner", 0) and !CAMI.PlayerHasAccess(client, "Helix - Bypass Prop Protection", nil)) then
			return false
		end
        return true
	end

	function PLUGIN:OnPhysgunReload(weapon, client)
        local entity = client:GetEyeTraceNoCursor().entity
        if IsValid(entity) == false then return false end

		if (client != entity:GetVar("FPPOwner", 0) and !CAMI.PlayerHasAccess(client, "Helix - Bypass Prop Protection", nil)) then
			return false
		end
        return true
	end

	function PLUGIN:CanProperty(client, property, entity)

		if (client != entity:GetVar("FPPOwner", 0) and !CAMI.PlayerHasAccess(client, "Helix - Bypass Prop Protection", nil)) then
			return false
        else
          return true
        end
	end

	local SENT_WHITELIST = {
		--["EFFECT"] = true,
        ["sent_xdecf_pot"] = true,
        ["sent_xdecf_mug"] = true,
        ["sent_xdecf_beans"] = true,
        ["sent_xdecf_jug"] = true,
        ["sent_xdecf_kettle"] = true,
        ["sent_xdecf_instant"] = true,
        ["sent_xdecf_machine"] = true,
		--Propcore
        ["lvs_item_gauge"] = true,
		["ent_musical_keyboard"] = true,
		["sent_prop_coreball_effect"] = true,
		["gmt_instrument_piano"] = true,
		--Media Player
		["mediaplayer_tv"] = true,
		["mediaplayer_tv_huge_billboard"] = true,
		["mediaplayer_tv_small_tv"] = true,
		["mediaplayer_tv_ext"] = true,
		--Media Player Extended
		["mediaplayer_tv_ext"] = true,
        
		["chemistry_storage_small"] = true,
    
		["gmod_balloon"] = true,
		["gmod_button"] = true,
		["gmod_emitter"] = true,
		["gmod_hoverball"] = true,
		["gmod_lamp"] = true,
		["gmod_light"] = true,
		["gmod_thruster"] = true,
		["gmod_wheel"] = true,

		["gb_rp_sign"] = true,
		["gb_rp_sign_wire"] = true,
		["ffv_gate"] = true,
		["sent_streamradio"] = true,
		["starfall_processor"] = true,
		["starfall_screen"] = true,
        
		["lvs_wheeldrive_pugo106s16_police"] = true,
	}


    local TechsKit = {
		["sent_computerzanik"] = true,
		["sent_computercss"] = true,
		["sent_disk"] = true,
		["sent_pc_spk"] = true,
		["sent_computer_tv"] = true,
		["sent_iodevice"] = true,
		["sent_computer_projector"] = true,
    }

	local ADMIN_SENT_BLACKLIST = {
		["ammo_rpgclip"] = true,
	}

	local WIRE_BLACKLIST = {
		["gmod_wire_detonator"] = true,
		["gmod_wire_simple_explosive"] = true,
		["gmod_wire_explosive"] = true,
		["gmod_wire_turret"] = true,
	}
  
    local TOOL_BLACKLIST_HARD = {
		["permaprops"] = true,
		["simfphysduplicator"] = true,
		["duplicator"] = true,
		["cameras_hefas"] = true,
	}
    local TOOL_BLACKLIST_SOFT = {
		["dynamite"] = true,
		["wire_turret"] = true,
		["wire_teleporter"] = true,
	}
  local CHEMISTS_STUFF = {
		["chemistry_analyzer"] = true,
		["chemistry_synthesizer"] = true,
		["chemistry_extractor"] = true,
		["chemistry_station"] = true,
		["chemistry_storage_large"] = true,
		["chemistry_storage_small"] = true,
	}
    local ApprovedVehicles = {
      ["sim_fphys_couch"] = true,
      ["sim_fphys_dukes"] = true,
      ["Pod"] = true,
      ["Chair_Office1"] = true,
      ["Chair_Office2"] = true,
      ["Chair_Plastic"] = true,
      ["Seat_Airboat"] = true,
      ["Seat_Jeep"] = true,
      ["Seat_Jalopy"] = true,
      ["phx_seat3"] = true,
      ["phx_seat2"] = true,
      ["phx_seat"] = true,
      ["bandit"] = true,
      ["micromanana3"] = true,
      ["blistataxi3"] = true,
      ["cabbievanilla3"] = true,
      ["cabbievanillawagon3"] = true,
      ["Linerunnerlongbox3"] = true,
      ["Linerunnerdaycab3"] = true,
      ["sentinelfbi3"] = true,
      ["sentinellong3"] = true,
      ["stallionr3"] = true,
      ["unmarkedcar3"] = true,
      ["unmarkeddcar3"] = true,
      ["washington3"] = true,
      ["ambulance3"] = true,
      ["banshee3"] = true,
      ["barracks3"] = true,
      ["BFInjection3"] = true,
      ["blista3"] = true,
      ["bobcat3"] = true,
      ["Borgnine3"] = true,
      ["bus3"] = true,
      ["cabbie3"] = true,
      ["Cartel3"] = true,
      ["cheetah"] = true,
      ["coach3"] = true,
      ["diablostallion3"] = true,
      ["enforcer3"] = true,
      ["esperanto3"] = true,
      ["fbicar3"] = true,
      ["firetruck3"] = true,
      ["flatbed3"] = true,
      ["hoods3"] = true,
      ["idaho3"] = true,
      ["infernus3"] = true,
      ["kuruma3"] = true,
      ["landstal3"] = true,
      ["Linerunner3"] = true,
      ["mafia3"] = true,
      ["manana3"] = true,
      ["moonbeam3"] = true,
      ["wongs3"] = true,
      ["MrWhoopee3"] = true,
      ["mule3"] = true,
      ["panlantic3"] = true,
      ["patriot3"] = true,
      ["perennial3"] = true,
      ["police3"] = true,
      ["pony3"] = true,
      ["rumpo3"] = true,
      ["securicar3"] = true,
      ["sentinel3"] = true,
      ["stallion3"] = true,
      ["stinger3"] = true,
      ["stretch3"] = true,
      ["taxi3"] = true,
      ["toyz3"] = true,
      ["trashmaster3"] = true,
      ["bellyup3"] = true,
      ["yakuzastinger3"] = true,
      ["yankee3"] = true,
      ["lobo3"] = true,
      ["Jeep"] = true,
    }
   function PLUGIN:CanTool(client, trace, mode, tool, button )
		local entity = trace.Entity
        if client:IsAdmin() then 
            return true 
        end
		if (IsValid(entity) and !CAMI.PlayerHasAccess(client, "Helix - Bypass Prop Protection", nil) and client != entity:GetVar("FPPOwner", 0)) then
			return false 
		end
        if TOOL_BLACKLIST_SOFT[mode] then
          if !client:GetCharacter():HasFlags("W") then
            client:Notify("You do not have the flag for this tool")
            return false
          end
        end
        if TOOL_BLACKLIST_HARD[mode] then
          client:Notify("This tool is not allowed!")
          return false 
        end
        return true
	end
    function PLUGIN:PlayerSpawnEffect(client)
		if (client:IsAdmin() or client:GetCharacter():HasFlags("B")) then
			return true
		end
		return false
	end
	function PLUGIN:PlayerSpawnVehicle(client, model, name, data)
        if client:IsAdmin() then return true end
        if client:GetCharacter():HasFlags("V") then
            if ApprovedVehicles[name] then
                return true 
            end 
        end
		return false
	end	
    function PLUGIN:PlayerSpawnNPC(client, ent, weapon)
		if (client:IsAdmin() or client:GetCharacter():HasFlags("n")) then
			return true
		end
		return false
    end
    function PLUGIN:PlayerSpawnSENT(client, ent)
        if (client:IsAdmin() or client:GetCharacter():HasFlags("B")) then
    		if (!client:IsAdmin() and SENT_WHITELIST[ent]) then
    			if SENT_WHITELIST[ent] then
    				return true
    			end
    		end
            -- Admin Blacklist
    		if (client:IsAdmin()) then
    			if !ADMIN_SENT_BLACKLIST[ent] then
    				return true
    			else
    				client:ChatNotify("Naughty Naughty! You shouldn't be spawning this, "..client:Nick().."!")
    				return false
    			end
    		end
            -- Allow wire mod components
    		if string.find(ent, "gmod_wire_") then
    			if !WIRE_BLACKLIST[ent] then
    				return true
    			end
    		end
            if TechsKit[ent] then
                return true
            end
            if CHEMISTS_STUFF[ent] then 
                if ix.faction.Get(client:GetCharacter():GetFaction()).name == "Research & Development" then 
                    return true 
                else 
                    client:ChatNotify("Only Scientists can spawn chemistry equipment!")
                    return false
                end
            end
    		-- Return False
    		client:Notify("You can't spawn this! ("..tostring(ent)..")")
        end
		return false
	end
else
	function PLUGIN:PhysgunPickup(client, entity)
		if (client != entity:GetVar("FPPOwner", 0) and !CAMI.PlayerHasAccess(client, "Helix - Bypass Prop Protection", nil)) then
			return false
		end
        return true
	end

	function PLUGIN:CanProperty(client, property, entity)

		if (client != entity:GetVar("FPPOwner", 0) and !CAMI.PlayerHasAccess(client, "Helix - Bypass Prop Protection", nil)) then
			return false
		end
        return true
	end

	function PLUGIN:CanTool(client, trace, mode, tool, button)
        local entity = trace.Entity
        if client:IsAdmin() then 
            return true 
        end
		if (IsValid(entity) and !CAMI.PlayerHasAccess(client, "Helix - Bypass Prop Protection", nil) and client != entity:GetVar("FPPOwner", 0)) then
			return false 
		end
        return true
	end
end
