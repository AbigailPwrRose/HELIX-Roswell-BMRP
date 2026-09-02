local PLUGIN = PLUGIN

PLUGIN.name = "New Xen Crystals"
PLUGIN.author = "Winter Rose!"
PLUGIN.description = "All new, non-item Xen crystals."

ix.XenCrystalSystem = ix.XenCrystalSystem or {}
ix.XenCrystalSystem.AMSPayoutList = {
  ["administration"] = 750,
  ["first_responders"] = 250,
  ["maintenance"] = 500,
  ["scientist"] = 650,
  ["survey"] = 750,
}
ix.XenCrystalSystem.AMSAuth = false
ix.XenCrystalSystem.AMSActive = false
ix.XenCrystalSystem.AMSTestData = {
  ["Active"] = false,
  ["Stability"] = 0,
  ["TimeLeft"] = 0,
  ["CrysName"] = "Err",
}

ix.command.Add("ResetCart", {
    description = "Reset the cart to its proper position, and clean up the others.",
    adminOnly = true,
    arguments = {},
    OnRun = function(self, client)
        if !(SERVER) or (ix.XenCrystalSystem.AMSActive) then return end
        PLUGIN:ReplaceCart()
    end
})
ix.command.Add("RandomiseCrystal", {
    description = "Randomises & resets a crystals data.",
    adminOnly = true,
    arguments = {},
    OnRun = function(self, client)
        if !(SERVER) then return end
        local TheEnt = client:GetEyeTrace().Entity
        if TheEnt.PrintName == "Xen Crystal Sample" then 
            TheEnt:RandomiseVars()
        end
    end
})
ix.command.Add("SetCrystalData", {
    description = "Randomises & resets a crystals data.",
    adminOnly = true,
    arguments = {
      ix.type.number,
      ix.type.number,
      ix.type.bool,
      ix.type.bool},
    argumentNames = {"Freq(100-400)", "Stab(1-100)", "Tested", "Analyzed"},
    OnRun = function(self, client,CF,CS,CT,CA)
        if !(SERVER) then return end
        local TheEnt = client:GetEyeTrace().Entity
        if TheEnt.PrintName == "Xen Crystal Sample" then 
            TheEnt:SetCVars("",false,math.Clamp(CF,100,400),math.Clamp(CS,1,100),CT,CA)
        end
    end
})
ix.command.Add("GetCrystalData", {
    description = "Prints a crystals data in chat.",
    adminOnly = true,
    arguments = {},
    OnRun = function(self, client)
        if !(SERVER) then return end
        local TheEnt = client:GetEyeTrace().Entity
        if TheEnt.PrintName == "Xen Crystal Sample" then 
            client:ChatNotify("customeName: "..TheEnt:GetNW2Var("customName",nil))
            client:ChatNotify("resonanceFreq: "..TheEnt:GetNW2Var("resonanceFreq",100))
            client:ChatNotify("stability: "..TheEnt:GetNW2Var("stability",50))
            client:ChatNotify("cType: "..TheEnt:GetNW2Var("cType",0))
        
            client:ChatNotify("Tested: "..tostring(TheEnt:GetNW2Var("Tested",false)))
            client:ChatNotify("Analyzed: "..tostring(TheEnt:GetNW2Var("Analyzed",false)))
        end
    end
})
ix.command.Add("AuthoriseAMS", {
    description = "Authorise an AMS Test.",
    adminOnly = true,
    arguments = {},
    OnCheckAccess = function(self, client) 
      local Passed = false
      if client:IsAdmin() then Passed = false end
      local char = client:GetCharacter()
      if ix.faction.Get(char:GetFaction()).uniqueID == "administration" and char:GetRank() >= 5 then 
        Passed = true 
      end
      return Passed
    end,
    OnRun = function(self, client)
        if !(SERVER) then return end
        if ix.XenCrystalSystem.AMSAuth then
          if !ix.XenCrystalSystem.AMSActive then
            ix.XenCrystalSystem.AMSAuth = false 
            for i, v in ipairs( player.GetAll() ) do
              local team = ix.faction.Get(v:Team())
              if team and team.IsFacility then
                v:Notify("The AMS test has been cancelled.")
              end
            end 
          else
            client:Notify("You can't unauthorise a test thats in progress")
          end
        else
          ix.XenCrystalSystem.AMSAuth = true 
          for i, v in ipairs( player.GetAll() ) do
            local team = ix.faction.Get(v:Team())
            if team and team.IsFacility then
              v:Notify("An AMS test has been authorised")
            end
          end
        end
    end
})

if (SERVER) then
    ix.allowedHoldableClasses["xencrystal_overworld"] = true 
    netstream.Hook("SVV_NameXenSample", function(client,text,id)
        if Entity(id) and Entity(id).PrintName == "Xen Crystal Sample" then 
            Entity(id):SetNW2Var("customName",text)
        end
    end)
  
	function PLUGIN:SaveData()
		local data = {}

		for _, entity in ipairs(ents.FindByClass("xencrystal_vein")) do
			data[#data + 1] = {
                type = "xencrystal_vein",
				pos = entity:GetPos(),
				angles = entity:GetAngles(),
				model = entity:GetModel(),
				skin = entity:GetSkin(),
			}
        end
		for _, entity in ipairs(ents.FindByClass("ams_displayscreen")) do
			data[#data + 1] = {
                type = "ams_displayscreen",
				pos = entity:GetPos(),
				angles = entity:GetAngles(),
				model = entity:GetModel(),
				skin = entity:GetSkin(),
                material = entity:GetMaterial(),
			}
        end
		self:SetData(data)
	end

    function PLUGIN:ReplaceCart()
      for _, entity in ipairs(ents.FindByName("sample_cart2")) do
          local CartPos = entity:GetPos()
          local CartAngle = entity:GetAngles()
          entity:Remove()
      end
      local newCart = ents.Create( "crystalcart" )
      newCart:SetPos(Vector(-2003.074341, -283.320129, -1800))
      newCart:SetAngles(Angle(0, 0, 0))
      newCart:Spawn()
    end
    
	function PLUGIN:LoadData()
        self:ReplaceCart()
		for _, v in ipairs(self:GetData() or {}) do
            if v.type == "xencrystal_vein" then
				local entity = ents.Create("xencrystal_vein")
				entity:SetPos(v.pos)
				entity:SetAngles(v.angles)
				entity:Spawn()
	
				entity:SetModel(v.model)
                entity:SetMaterial("")
				entity:SetSkin(v.skin or 0)
                entity:PhysicsInit(SOLID_VPHYSICS)
                entity:SetSolid(SOLID_VPHYSICS)
				local physics = entity:GetPhysicsObject()
                physics:EnableMotion(false)
                physics:Sleep()
            elseif v.type == "ams_displayscreen" then
				local entity = ents.Create("ams_displayscreen")
				entity:SetPos(v.pos)
				entity:SetAngles(v.angles)
				entity:Spawn()
	
				entity:SetModel(v.model)
                entity:SetMaterial(v.material)
				entity:SetSkin(v.skin or 0)
                entity:PhysicsInit(SOLID_VPHYSICS)
                entity:SetSolid(SOLID_VPHYSICS)
				local physics = entity:GetPhysicsObject()
                physics:EnableMotion(false)
                physics:Sleep()
            end
		end
	end
  
    function PLUGIN:PlayerUse(ply, ent)
    if ent:GetName() == "secondbutton" and ent:GetInternalVariable("m_toggle_state") == 1 then
      local EntTab = ents.FindInBox(Vector(-2208.353760,-365.406921,-1076.201416),Vector(-2379.952393,-171.808594,-946.780701))
      local Cart = nil
      for k,v in pairs(EntTab) do
        if v:GetClass() == "crystalcart" then 
          Cart = v
        end
      end
      if Entity(1954):GetInternalVariable("m_toggle_state") == 0 and Cart and Cart.HasCrystal then
        ix.XenCrystalSystem.CartScanning() 
      else
        return false
        
      end 
    end
    end
    function ix.XenCrystalSystem:AMSConditions()
        local EntTab = ents.FindInBox(Vector(-2208.353760,-365.406921,-1076.201416),Vector(-2379.952393,-171.808594,-946.780701))
        local ConditionMet = false
        local Cart = nil
        for k,v in pairs(EntTab) do
          if v:GetClass() == "crystalcart" then
            Cart = v
          end
        end
        if IsValid(Cart) then 
            if Entity(2105):GetInternalVariable("m_toggle_state") == 0 then TestFailed() end
            if Cart.HasCrystal and Entity(2105):GetInternalVariable("m_toggle_state") == 1 then
            ConditionMet = true end
        end
        return ConditionMet,Cart
    end
    function ix.XenCrystalSystem.CartScanning()
      timer.Create( "WAMSS_P1", 1, 0, function()
        local ShouldStart,Cart = ix.XenCrystalSystem:AMSConditions()
        
        if Entity(1955):GetInternalVariable("m_toggle_state") == 1 then timer.Remove( "WAMSS_P1" ) end
        if ShouldStart and Entity(1955):GetInternalVariable("m_toggle_state") == 0 then 
          timer.Remove( "WAMSS_P1" )
          timer.Create( "WAMSS_P2", 1, math.Round(Cart.CrystalTable["reso"]/3,1), function()
            ix.XenCrystalSystem.AMSActive  = true
            local EntTab = ents.FindInBox(Vector(-2208.353760,-365.406921,-1076.201416),Vector(-2379.952393,-171.808594,-946.780701))
            local ShouldKeepActive,Cart = ix.XenCrystalSystem:AMSConditions()
            ix.XenCrystalSystem.AMSTestData["Active"] = true
            ix.XenCrystalSystem.AMSTestData["Stability"] = Cart.CrystalTable["stab"]
            ix.XenCrystalSystem.AMSTestData["TimeLeft"] = timer.RepsLeft("WAMSS_P2")
            ix.XenCrystalSystem.AMSTestData["CrysName"] = Cart.CrystalTable["name"] or "Unnamed"
            if math.random(1,100) > 80 then 
                Cart:DoDamageTest()
                if !Cart.HasCrystal then 
                  ix.XenCrystalSystem.AMSTestData["Active"] = false
                  ents.FindByName("secondbutton")[1]:Use(Entity(0))
                  ix.XenCrystalSystem.AMSActive  = false
                  TestFailed()
                  timer.Remove("WAMSS_P2")
                end
            end
            if !ShouldKeepActive then 
              ix.XenCrystalSystem.AMSTestData["Active"] = false
              ents.FindByName("secondbutton")[1]:Use(Entity(0))
              ix.XenCrystalSystem.AMSActive  = false
              timer.Remove("WAMSS_P2") 
            elseif Entity(1955):GetInternalVariable("m_toggle_state") == 1 then
              ix.XenCrystalSystem.AMSTestData["Active"] = false
              ix.XenCrystalSystem.AMSActive  = false
              timer.Remove("WAMSS_P2")
            elseif timer.RepsLeft("WAMSS_P2") <= 1 then
                ix.XenCrystalSystem.AMSTestData["Active"] = false
                ents.FindByName("motor_button")[1]:Use(Entity(0))
                AMSComplete(Cart)
                ix.XenCrystalSystem.AMSActive  = false
                timer.Remove("WAMSS_P2")
            end
          end) 
        end 
      end) 
    end
  
  function AMSComplete(Cart)
    Cart:CrystalTestComp()
    ix.XenCrystalSystem.AMSAuth = false
    for i, v in ipairs( player.GetAll() ) do
      local team = ix.faction.Get(v:Team())
      if team and team.IsFacility then
        v:Notify("An AMS Test has concluded.")
        if ix.XenCrystalSystem.AMSPayoutList[ix.faction.Get(v:Team()).uniqueID] != nil then
          local Pay = ix.XenCrystalSystem.AMSPayoutList[ix.faction.Get(v:Team()).uniqueID]
          v:Notify("You have recieved "..Pay.." for this AMS test.")
          v:GetCharacter():SetMoney(v:GetCharacter():GetMoney()+Pay)
        end
      end
    end
  end
  function TestFailed()
    ix.XenCrystalSystem.AMSAuth = false
    for i, v in ipairs( player.GetAll() ) do
      local team = ix.faction.Get(v:Team())
      if team and team.IsFacility then
        v:Notify("An AMS Test has failed")
      end
    end
  end
else
  netstream.Hook("CLV_NameXenSample", function(TargID)
      local ReqP = Derma_StringRequest(
          " ", 
          "Name this crystal?",
          "",
          function(text) netstream.Start("SVV_NameXenSample", text, TargID) end,
          function(text)  end
      )
  end)
end
