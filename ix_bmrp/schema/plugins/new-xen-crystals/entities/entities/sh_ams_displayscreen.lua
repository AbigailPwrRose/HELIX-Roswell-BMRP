ENT.Type = "anim"
ENT.PrintName = "Display Screen"
ENT.Category = "Black Mesa: Xen Crystals"
ENT.Model = "models/sprops/rectangles/size_4/rect_36x78x3.mdl"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.bNoPersist = true

if (SERVER) then
  function ENT:Initialize()
      self:SetModel(self.Model)
      self:PhysicsInit(SOLID_VPHYSICS)
      self:PhysWake()
      self:SetUseType(SIMPLE_USE)
  end 
  
  function ENT:Think()
    if ix.XenCrystalSystem.AMSTestData["Active"] then
      self:SetNW2Var("DisplayActive",true) 
      self:SetNW2Var("StabDisp",ix.XenCrystalSystem.AMSTestData["Stability"]) 
      self:SetNW2Var("TimeC",ix.XenCrystalSystem.AMSTestData["TimeLeft"]) 
      self:SetNW2Var("CrystalName",ix.XenCrystalSystem.AMSTestData["CrysName"])
    else
      self:SetNW2Var("DisplayActive",false) 
    end
  end
  
else
    function ENT:Draw()
        self:DrawModel()
        if self:GetNW2Var("DisplayActive",false) then
          cam.Start3D2D( self:LocalToWorld(Vector(-38,17,2)), self:LocalToWorldAngles(Angle(0,0,0)), 0.25 )
              -- Get the size of the text we are about to draw
      
              surface.SetFont( "CenterPrintText" )
              local tW, tH = surface.GetTextSize( "Test" )
              surface.SetDrawColor( 200, 200, 200, 250 )
              surface.DrawRect( 0, 0, 302, 135 )
      
              draw.DrawText( "Anti-Mass Spectrometer Online", "TargetID", 4, 1, color_white, TEXT_ALIGN_LEFT )
              draw.DrawText( "Current Crystal: "..self:GetNW2Var("CrystalName","Err"), "TargetID", 4, 30, color_white, TEXT_ALIGN_LEFT )
              draw.DrawText( "Xen Crystal Stability: "..self:GetNW2Var("StabDisp",0).."%", "TargetID", 4, 50, color_white, TEXT_ALIGN_LEFT )
              draw.DrawText( "Time left to completion: "..self:GetNW2Var("TimeC",0).." Seconds", "TargetID", 4,70, color_white, TEXT_ALIGN_LEFT )
          cam.End3D2D()
        else
          cam.Start3D2D( self:LocalToWorld(Vector(-38,17,2)), self:LocalToWorldAngles(Angle(0,0,0)), 0.25 )
              -- Get the size of the text we are about to draw
      
              surface.SetFont( "CenterPrintText" )
              local tW, tH = surface.GetTextSize( "Test" )
              surface.SetDrawColor( 0, 0, 0, 255 )
              surface.DrawRect( 0, 0, 302, 135 )
          cam.End3D2D()
        end
    end
end