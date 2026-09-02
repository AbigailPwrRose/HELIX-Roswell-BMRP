ENT.Type = "anim"
ENT.PrintName = "Crystal Cart"
ENT.Category = "Black Mesa: Xen Crystals"
ENT.Model = "models/props/bmrf/ams_cart.mdl"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.bNoPersist = true

if (SERVER) then
    function ENT:Initialize()
    	self:SetModel(self.Model)
    	self:PhysicsInit(SOLID_VPHYSICS)
    	self:PhysWake()
      	self:SetUseType(SIMPLE_USE)
    	self:SetName("sample_cart2")
    
        self.NextTick = 0
        self.Cooldown2use = 0
        self.HasCrystal = nil
        self.InTest = false
        self.CrystalTable = {}
        self.Crystal = nil
    end 
    
    function ENT:Use(client)
      if self.Cooldown2use != 0 then return end self.Cooldown2use = 3
      if self.HasCrystal and (self:GetPos().z < -1715 or self.CrystalTable["test"])  then 
        self.HasCrystal = false
        self:DropCrystal()
        client:Notify("Crystal removed from cart")
      else
        local PlyDir = client:GetPos() - self:GetPos()
        local MV = Vector(math.Clamp(PlyDir.x,-3,3),math.Clamp(PlyDir.y,-3,3),0.5)
        self:SetPos(self:GetPos()+MV)
      end
    end
  
    function ENT:DoCrystalCheck(Collider)
      local pos = self:GetPos()
      local Failed = false
      local FailCause = ""
      if (pos.z > -1715) then
        Failed = true 
        FailCause = "This cart can only be loaded in Lower AMS"
      elseif self.HasCrystal then
        Failed = true 
        FailCause = "This cart already has a crystal loaded."
      end
      if Failed then 
        self:NotifyInArea(FailCause)
      end
      return !Failed
    end
  
    function ENT:AttachCrystal(Collider)
      if self.Cooldown2use != 0 then return end self.Cooldown2use = 10
      if Collider:GetClass() == "xencrystal_overworld" then
        local CanPickUp = self:DoCrystalCheck(Collider)
        if CanPickUp then 
          if Collider:GetNW2Var("Analyzed",false) and !Collider:GetNW2Var("Tested",false) then 
            self:NotifyInArea("Crystal can be tested.")
            self.CrystalTable = {
            ["name"] = Collider:GetNW2Var("customName",nil),
            ["stab"] = Collider:GetNW2Var("stability",100),
            ["reso"] = Collider:GetNW2Var("resonanceFreq",50),
            ["test"] = Collider:GetNW2Var("Tested",false),
            ["anal"] = Collider:GetNW2Var("Analyzed",false),
            ["mode"] = Collider:GetModel(),
            }
            self:SetNW2String("CrystalTable",util.TableToJSON(self.CrystalTable))
            self.HasCrystal = true
            Collider:Remove()
            
          elseif Collider:GetNW2Var("Tested",false) then
            self:NotifyInArea("Crystal has already been tested.")
          elseif !Collider:GetNW2Var("Analyzed",false) then
            self:NotifyInArea("Crystal must be analyzed before it can be tested.")
          end
        end
      end
    
    end
  
    function ENT:DropCrystal()
      self.HasCrystal = false
    
      local ExitCrystal = ents.Create("xencrystal_overworld")
      ExitCrystal:SetPos(self:LocalToWorld(Vector(70,0,0))) 
      ExitCrystal:SetAngles(Angle(0.0, 90.0, 0.0))
      ExitCrystal:Spawn()
      ExitCrystal:SetModel(self.CrystalTable["mode"])
      ExitCrystal:SetCVars(self.CrystalTable["name"],true,self.CrystalTable["reso"],self.CrystalTable["stab"],self.CrystalTable["test"],self.CrystalTable["anal"]) 
    
    
      table.Empty(self.CrystalTable)
      self:EmitSound("phx/EpicMetal_Hard5.wav")
    end

    function ENT:NotifyInArea(message)
        nearbyents = ents.FindInSphere( self:GetPos(), 300 )
        for k,v in pairs(nearbyents) do
          if v:IsPlayer() then 
            v:Notify(message)
          end
        end
    end
  
    function ENT:DoDamageTest()
      if self.CrystalTable["stab"] < 50 then
        self.CrystalTable["stab"] = self.CrystalTable["stab"]-1
      else
        self.CrystalTable["stab"] = self.CrystalTable["stab"]-2
      end
      if self.CrystalTable["stab"] <= 1 then
        self:EmitSound("physics/glass/glass_largesheet_break3.wav")
        self:EmitSound("debris/beamstart4.wav")
        table.Empty(self.CrystalTable)
        self.HasCrystal = false
      
      end
    end
  
    function ENT:CrystalTestComp()
      self.CrystalTable["test"] = true
    end
  
    function ENT:PhysicsCollide(data)
    	self:AttachCrystal(data.HitEntity)
    end
  
    function ENT:Reset()
    	self:SetPos(Vector(-2003.074341, -283.320129, -1800))
    	self:SetAngles(Angle(0, 0, 0))
        self.HasCrystal = false
        table.Empty(self.CrystalTable)
    end
    
  function ENT:Think()
    if self.Cooldown2use != 0 then
      self.Cooldown2use = math.Clamp(self.Cooldown2use - 1,0,50)
    end
    if self.HasCrystal != self:GetNW2Var("HasCrystal",false) then
      self:SetNW2Var("HasCrystal",self.HasCrystal)
    end
    if util.TableToJSON(self.CrystalTable) != self:GetNW2String("CrystalTable","[]") then 
      self:SetNW2String("CrystalTable",util.TableToJSON(self.CrystalTable))
    end
  end
else
    ENT.PopulateEntityInfo = true
    function ENT:Draw()
        local CT = util.JSONToTable(self:GetNW2String("CrystalTable","[]"))
        self:DrawModel()
        if self:GetNW2Var("HasCrystal",false) then
          if !IsValid(self.RenderCrystal) then 
            self.RenderCrystal = ClientsideModel( CT["mode"])
            self.RenderCrystal:SetNoDraw(true)
          end 
          if self.RenderCrystal:GetModel() != CT["mode"] then 
              self.RenderCrystal:SetModel(CT["mode"])
          end
          self.RenderCrystal:SetPos(self:LocalToWorld(Vector(-50,0,10)))
          self.RenderCrystal:SetAngles(self:LocalToWorldAngles(Angle(0,0,90)))
          self.RenderCrystal:SetParent(self)
          self.RenderCrystal:DrawModel()
        elseif self.RenderCrystal then
            self.RenderCrystal:Remove()
        end
    end
    
	function ENT:OnPopulateEntityInfo(container)
        local CT = util.JSONToTable(self:GetNW2String("CrystalTable","[]"))
		local name = container:AddRow("name")
		name:SetImportant()
		name:SetText("Sample Cart")
		name:SizeToContents()
        local desc = container:AddRow("Contains")
        desc:SetBackgroundColor(Color(255,255,255,220))
        desc:SetFont("CreditsText") 
        local Text = ""
        if self:GetNW2Var("HasCrystal",false) then
          Text = "This is an advanced mechanical cart used to safely insert Xen crystals into the Anti-Mass Spectrometer."
          if CT["name"] then
            Text = Text.." It currently contains a crystal named "..CT["name"].."."
          else
            Text = Text.." It currently contains an unnamed Xen crystal."
          end
          Text = Text.."\n\nThis crystal has a predicted resonance of "..CT["reso"].." and a stability of "..CT["stab"].."%."
          if CT["test"] then
            Text = Text.."\n\nThis crystal has been succesfully tested!"
          end
        else
          Text = "This is an advanced mechanical cart used to safely insert Xen crystals into the Anti-Mass Spectrometer."
        end
        desc:SetText(Text) 
        desc:SizeToContents() 
    end
end