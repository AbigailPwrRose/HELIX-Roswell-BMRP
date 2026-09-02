------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
------------------------------- NEW PANEL STARTS HERE ------------------------------------------------------
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
    local w = ScrW() * 0.65
    local h = ScrH() * 0.7
    self.TimeOfNextTick = 0
    self.tick = 0
    self.tickDelay = 0.05
    self.ValveRot = 0
    self.SelectHeight = 0
    self:ShowCloseButton(false)
    local BarPoses = {
        [1] = 0,
        [2] = 0,
        [3] = 0,
    }
    local BarActualPoses = {
        [1] = math.random(5,50),
        [2] = math.random(5,50),
        [3] = math.random(5,50),
    }
    self.GoingUp = False
    self.CurrentRow = 1 
    
	self:SetSize(w, h)	
	self:MakePopup()
	self:Center()
    self:IsDraggable(false)
    self:SetPaintBorderEnabled(false)

	self.controls = self:Add("DPanel")
	self.controls:Dock(BOTTOM)
	self.controls:SetTall(30)
    self.controls:DockMargin(0, 5, 0, 0)
    
    for i = 1,3 do
    	local PressureFrame = self:Add( "DPanel" )
        PressureFrame:SetSize( w * 0.2, h * 0.7 )
        PressureFrame:SetPos((w*0.1)+((i-1)*(w*0.2+w*0.1)), h*0.15)
        PressureFrame.Num = i
        
        PressureFrame.Paint = function(this, w, h) 
            draw.RoundedBox( 10, 0, 0, w, h, Color(175,175,175,210) )
            draw.RoundedBox( 0, 4, 4, 1, h -8, Color(0,0,0) )
            draw.RoundedBox( 0, w -5, 4 , 1, h -8, Color(0,0,0) )
            draw.RoundedBox( 0, 4, 4 , w -8, 1, Color(0,0,0) )
            draw.RoundedBox( 0, 4, h -5 , w -8, 1, Color(0,0,0) )
            draw.RoundedBox( 0, 5, 5, w -10, h -10, Color(255,255,255,210) )
            local HT = h - 10
            local H = HT/5
            for i = 1,5 do 
            	draw.RoundedBox( 0, 5, 10 + (H * i)*0.85, w -10, h*0.01, Color(0,0,0,50) )
            end
            
            draw.RoundedBox( 0, 5, 5 + (h/60 * BarActualPoses[i]), w -10, h*0.08, Color(0,200,0,170) )
            
        end
        
        
    end
    
    self.SelectionBar = self:Add("DPanel")
    self.SelectionBar:SetSize(w,h)
    self.SelectionBar.Paint = function(this) 
        draw.RoundedBox( 10,(w*0.1)+((self.CurrentRow - 1)*(w*0.2+w*0.1))+4, h*0.15+5+(self.SelectHeight * (h/60) * 0.65), w * 0.2 -10, h*0.035, Color(250,0,0) )
    if self.GoingUp == false then 
      self.ValveRot = self.ValveRot + 5
      if self.ValveRot > 360 then self.ValveRot = 0 end
    else
      self.ValveRot = self.ValveRot - 5
      if self.ValveRot < 0 then self.ValveRot = 360 end
    end
    if CurTime() >= self.TimeOfNextTick then
      if self.GoingUp == false then 
          self.SelectHeight = self.SelectHeight - 1
          if self.SelectHeight < 0 then 
              self.SelectHeight = 0
              self.GoingUp = true
          end
      else 
          self.SelectHeight = self.SelectHeight + 1
          if self.SelectHeight > 60 then 
              self.SelectHeight = 60
              self.GoingUp = false
          end
      end
      self.TimeOfNextTick = CurTime() + self.tickDelay
    end
        
    end
    
	self.test = self.controls:Add("DTextEntry")
	self.test:SetMultiline(true)
	self.test:SetSize(0,0)
	self.test:SetEditable(false)
    
	self.confirm = self:Add("DButton")
	self.confirm:SetPos(w*0.4,h*0.9)
	self.confirm:SetSize(w*0.2,h*0.05)
	self.confirm:SetDisabled(false)
	self.confirm:SetText(L("Adjust Pressure"))

	self.controls.Paint = function(this, w, h)
		draw.SimpleText(Format(--[["All content subject to change!"]]"", 25), "DermaDefault", 65, h/2, color_white, TEXT_ALIGN_LEFT, 1)
	end

	self.confirm.DoClick = function(this)
        BarPoses[self.CurrentRow] = self.SelectHeight
        self.CurrentRow = self.CurrentRow + 1
        if self.GoingUp == false then self.GoingUp = true else self.GoingUp = false end
        if self.CurrentRow == 4 then
            local Suc = true
            for k,v in pairs(BarPoses) do
                local ValidUpper = BarActualPoses[k] - 5
                local ValidLower = BarActualPoses[k] + 6
                local Mid = v
                print(ValidUpper.." < "..Mid.." < "..ValidLower)
                if ValidUpper > Mid or Mid > ValidLower then
                    Suc = false
                end
            end
      
            netstream.Start("clientEndMaintenance_Type3", ID, Suc)
			self:Close()
        end
	end
end

function PANEL:SetText(id)
	ID = id
	self:SetTitle(" ")
end

function PANEL:Paint(w, h)
    draw.RoundedBox( 12, 0, 0, w , h , Color(76,76,76,250) )
    surface.SetMaterial( Material( "expression 2/cog_prop" ) )
    surface.DrawTexturedRectRotated( w/2, h * 0.075, w*0.08, w*0.08, self.ValveRot, Color( 255, 255, 255,255) )
    draw.SimpleText(Format("High Pressure Configuration Valve - Liscenced Technicians Only", 25), "SiderealPanels", w/2, h*0.98, color_white, TEXT_ALIGN_CENTER, 1)
end

vgui.Register("MaintenancePanel_TypeThree", PANEL, "DFrame")