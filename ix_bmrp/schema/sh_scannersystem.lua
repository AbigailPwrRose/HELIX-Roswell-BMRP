local PLUGIN = Schema

-- By Winters Rose

ix.EvilScanners = {}

ix.config.Add("ixToggleWintersScanners", true, "Turn on and off the scanner system", function(oldValue, newValue) end,
	{
		category = "Scanner System"
	}
)

ix.command.Add("GetMapEntityName", {
	description = "@cmdEvent",
	AdminOnly = true,
	OnRun = function(self, client)
            client:ChatNotify("Ent Name: "..client:GetEyeTrace().Entity:GetName())
	end
})


function ix.EvilScanners:RedefineTables()
 	ix.EvilScanners.ScannerTiers = {
        -- Use this to define the ranks
        [0] = "This is the debug rank. It should not be possible to see this message. Report to Winter.", -- Debug
        [1] = "Access Denied - Invalid Credentials", -- All factions internal
        [2] = "Access Denied - Survey Team", -- Survey only[Rank 2+]
        [3] = "Access Denied - Research Staff", -- Survey & Scientists only[Rank 2+]
        [4] = "Access Denied - Qualified Security", -- Security only[Rank 3+]
        [5] = "Access Denied - Security Access", -- Security only[All Ranks]
        [6] = "Access Denied - Military Access", -- Military only[All Ranks]
        [7] = "Access Denied - Qualified Maintenance", -- Military only[Rank 2+]
        [8] = "This can only be operated by trained Survey staff while a test has been authorised.", -- Survey only[Rank 2+]
    }
 	ix.EvilScanners.ScannerList = {
        -- Map button entity names.
        -- Use number to define which tier it is
        ["bmrf_entrancescanner12"] = 3,
        ["bmrf_entrancescanner9"] = 3,
        ["bmrf_entrancescanner8"] = 4,
        ["bmrf_entrancescanner4"] = 5,
        ["dorms_tramdd_scanner"] = 1,
        ["ba_security2_Scanner"] = 4,
        ["keypad1"] = 3,
        ["de_contron_btn"] = 2,
        ["de_power_switch"] = 8,
        ["lambda_entrance"] = 2,
        ["bmrf_lcscanner"] = 3,
        ["bmrf_power_button"] = 7,
        ["bmrf_entrancescanner10"] = 1,
        ["f_tramlinescanner"] = 1,
        ["bmrf_entrancescanner1"] = 1,
        ["bmrf_entrancescanner15"] = 1,
        ["bmrf_area2_scanner1"] = 1,
        ["e_airlock4_scanner"] = 1,
        ["e_airlock3_scanner"] = 4,
        ["e_airlock1_scanner"] = 4,
    }
end

ix.EvilScanners:RedefineTables()

if (CLIENT) then return end

function ix.EvilScanners:ScannerLogics(entity,client)
    local PassedCheck = false
    local ScannerLevel = ix.EvilScanners.ScannerList[entity:GetName()] or 0

    local UserFac = client:Team()
    local UserRank = client:GetCharacter():GetRank()
    local FacTable = ix.faction.Get(UserFac)

    if (FacTable["uniqueID"] == "OBSOLETE") or !(ix.config.Get("ixToggleWintersScanners",true)) then 
    	PassedCheck = true
    end

    if ScannerLevel == 1 then 
        if FacTable["IsFacility"] then 
            PassedCheck = true
        end
    elseif ScannerLevel == 2 then 
        if (FacTable["uniqueID"] == "survey") and UserRank >= 2 then 
            PassedCheck = true
        end
    elseif ScannerLevel == 3 then 
        if ((FacTable["uniqueID"] == "survey") or (FacTable["uniqueID"] == "scientist")) and UserRank >= 2 then 
            PassedCheck = true
        end
    elseif ScannerLevel == 4 then 
        if (FacTable["uniqueID"] == "security") and UserRank >= 3 then 
            PassedCheck = true
        end
    elseif ScannerLevel == 5 then 
        if (FacTable["uniqueID"] == "security") then 
            PassedCheck = true
        end
    elseif ScannerLevel == 6 then 
        if (FacTable["uniqueID"] == "hecu") or (FacTable["uniqueID"] == "first_responders") or (FacTable["uniqueID"] == "blackops") then 
            PassedCheck = true
        end
    elseif ScannerLevel == 7 then 
        if (FacTable["uniqueID"] == "maintenance") and UserRank >= 2 then 
            PassedCheck = true
        end
    elseif ScannerLevel == 8 then 
        if ix.XenCrystalSystem.AMSAuth or entity:GetInternalVariable("m_toggle_state") == 0 then
            if (FacTable["uniqueID"] == "survey") and UserRank >= 2 then 
                PassedCheck = true
            end
        end
    end
   
    if PassedCheck != true then
        client:ChatNotify(ix.EvilScanners.ScannerTiers[ScannerLevel])
        return false
    else
        return true
    end
end

function PLUGIN:PlayerUse(ply, ent)
    if not ix.EvilScanners.ScannerList[ent:GetName()] then return end
    if !isnumber(ent.AntiSpam) then ent.AntiSpam = CurTime() end
    if isnumber(ent.AntiSpam) and ent.AntiSpam > CurTime() then return false end
    ent.AntiSpam = CurTime() + 4
    local CheckPassed = ix.EvilScanners:ScannerLogics(ent, ply) 
    
    if CheckPassed then
        ent:EmitSound("bms_objects/doors/retinal_scanner_access_granted01.wav", 90, 100)
        ent:Use( ply, ply, USE_ON, 0 )
        return
    else
        ent:EmitSound("bms_objects/doors/retinalscanner_access_denied01.wav", 90, 100)
        return false
    end
end

function ix.EvilScanners:BypassLogic() 
end