surface.CreateFont( "SiderealPanels", {
        font = "TargetIDSmall",
        extended = false,
        size = 25,
        weight = 1,
        italic = true,
    	outline = true} 
)

local PANEL = {}

function PANEL:Init()
    local w = ScrW() * 0.65
    local h = ScrH() * 0.7
    local Ipattern = {}
    local Tpattern = {}
    
    for i = 1, 15 do
        table.Add(Tpattern,{[i]=table.Random({true,false})})
    end
    
    for i = 1, 15 do
        table.Add(Ipattern,{[i]=nil})
    end
    
	self:SetSize(w, h)	
	self:MakePopup()
	self:Center()
    self:IsDraggable(false)
    self:ShowCloseButton(false)
    self:SetPaintBorderEnabled(false)
	self:SetTitle(" ")

	self.controls = self:Add("DPanel")
	self.controls:Dock(BOTTOM)
	self.controls:SetTall(30)
	self.controls:DockMargin(0, 5, 0, 0)
    
    self.grid = self:Add( "DGrid" )
    self.grid:SetPos( w * 0.03, h * 0.05 )
    self.grid:SetCols( 5 )
    self.grid:SetColWide( w * 0.2 )
    self.grid:SetRowHeight(h * 0.3)

    for i = 1, 15 do
        local butFrame = vgui.Create( "DPanel" )
        butFrame:SetSize( w * 0.15, h * 0.24 )
        butFrame.Num = i
        
        butFrame.Paint = function(this, w, h) end
            
        local but = vgui.Create( "DButton" )
        but:SetText("")
        but:SetSize( w * 0.15, h * 0.18 )
    	but.Num = i
        
        but.DoClick = function(this) 
        	if Ipattern[butFrame.Num] == true then
                Ipattern[butFrame.Num] = false
            elseif Ipattern[butFrame.Num] == false then
                Ipattern[butFrame.Num] = nil
            elseif Ipattern[butFrame.Num] == nil then
                Ipattern[butFrame.Num] = true
            end
            surface.PlaySound("scifi/hudbleep.mp3")
        end 
        but.DoRightClick = function(this) 
        	if Ipattern[butFrame.Num] == true then
                Ipattern[butFrame.Num] = nil
            elseif Ipattern[butFrame.Num] == false then
                Ipattern[butFrame.Num] = true
            elseif Ipattern[butFrame.Num] == nil then
                Ipattern[butFrame.Num] = false
            end
            surface.PlaySound("scifi/hudbleep.mp3")
        end
        
        but.Paint = function(this, w, h) 
            if Ipattern[butFrame.Num] == false then
            	draw.RoundedBox( 10, 0, 0, w, h, Color(134,0,0) )
            elseif Ipattern[butFrame.Num] == true then 
            	draw.RoundedBox( 10, 0, 0, w, h, Color(44,133,56) )
			else
            	draw.RoundedBox( 10, 0, 0, w, h, Color(255,255,0) )
            end
        end
        
        butFrame:Add(but)
        
        local butLabel = vgui.Create( "DPanel" )
		butLabel:SetSize(w * 0.15, h *0.05)
        butLabel:SetPos(0 , h * 0.2)
        butLabel:SetBackgroundColor(Color(225,225,225))
        
        local butLabelText = vgui.Create( "DLabel" )
        butLabelText:SetPos( 5,5 )
		butLabelText:SetText("This should be set to : "..tostring(Tpattern[butFrame.Num]))
        butLabelText:SetTextColor(Color(0,0,0))
        butLabelText:SizeToContents()
        
        butLabel:Add(butLabelText)
        butFrame:Add(butLabel)
        
        self.grid:AddItem( butFrame )
    end	

	self.test = self.controls:Add("DTextEntry")
	self.test:SetMultiline(true)
	self.test:SetSize(0,0)
	self.test:SetEditable(false)
    
	self.confirm = self.controls:Add("DButton")
	self.confirm:Dock(RIGHT)
	self.confirm:SetDisabled(false)
    self.confirm:SetWidth(w * 0.1)
	self.confirm:SetText(L("Submit Configuration"))
    self.confirm:SetTextColor( Color( 26, 26, 26) )
    self.confirm.Paint = function(this, w, h)
        draw.RoundedBox( 10, 0, 0, w, h, Color(255,255,255) )
    end
	self.controls.Paint = function(this, w, h)
		draw.SimpleText(Format("Area Enviromental Control Terminal - Liscenced Technicians Only", 25), "SiderealPanels", 15, h/2, color_white, TEXT_ALIGN_LEFT, 1)
	end

	self.confirm.DoClick = function(this)
		netstream.Start("clientEndMaintenance", ID, Tpattern, Ipattern, 0)
		self:Close()
	end
end

function PANEL:SetText(id)
	ID = id
end

function PANEL:Paint(w, h)
    draw.RoundedBox( 12, 0, 0, w , h , Color(76,76,76,250) )
    --surface.SetMaterial( Material( "expression 2/cog_prop" ) )
    --surface.DrawTexturedRectRotated( w/2, h * 0.075, w*0.08, w*0.08, self.ValveRot, Color( 255, 255, 255,255) )
end

vgui.Register("MaintenancePanel_TypeOne", PANEL, "DFrame")

------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
------------------------------- NEW PANEL STARTS HERE ------------------------------------------------------
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

local PANEL = {}

function NoRepeats(Tabl,NewNum)
    local Total = 0
    local ChecksPassed = 0
    for k,v in pairs(Tabl) do
        Total = Total + 1
        if NewNum == v then
            ChecksPassed = ChecksPassed + 0
		else 
            ChecksPassed = ChecksPassed + 1
        end 
    end
    if ChecksPassed != Total then
        NewNum2 = math.random(1,4)
        Tpattern = NoRepeats(Tabl,NewNum2)
	else
        table.insert(Tabl,NewNum)
    end
    return Tabl
end

function PANEL:Init()
    local w = ScrW() * 0.65
    local h = ScrH() * 0.7
    local Ipattern = {}
    local Tpattern = {}
    
    local List1_Active = 0
    local List2_Active = 0
    
    self:IsDraggable(false)
    self:ShowCloseButton(false)
            
    for i = 1, 4 do
        NewNum = math.random(1,4)
        Tpattern = NoRepeats(Tpattern,NewNum)
    end
    
    for i = 1, 4 do
        table.Add(Ipattern,{[i]=0})
    end
    
	self:SetSize(w, h)	
	self:MakePopup()
	self:Center()
    self:IsDraggable(false)
    self:ShowCloseButton(false)
    self:SetPaintBorderEnabled(false)
	self:SetTitle(" ")

	self.controls = self:Add("DPanel")
	self.controls:Dock(BOTTOM)
	self.controls:SetTall(30)
    self.controls:DockMargin(0, 5, 0, 0)
    self.controls.Paint = function(this, W, H) end
    
    self.List1 = self:Add( "DPanel" )
    self.List1:SetPos( w * 0.05,  h*0.1  ) 
    self.List1:SetSize(  w * 0.2,  h*0.8 )
    self.List1.Paint = function(this, w, h) end
    
    for i = 1,4 do
    	local butFrame = self.List1:Add( "DPanel" )
        butFrame:SetSize( w * 0.2, h * 0.18 )
        butFrame:SetPos( 0, ((i-1)*(h * 0.205)))
        butFrame.Num = i
        
        butFrame.Paint = function(this, w, h) 
            draw.RoundedBox( 10, 0, 0, w, h, Color(175,175,175) )
        end
        
        local butIndicator = butFrame:Add( "DPanel" )
        butIndicator:SetSize( w * 0.05, w * 0.05 )
        butIndicator:SetPos( w * 0.1 - (w * 0.05/2), h * 0.10)
        butIndicator.Paint = function(this, w, h) 
            local Colour = Color(0,0,0)
            local TargN = Tpattern[butFrame.Num]
            if TargN == 1 then
                Colour = Color(250,100,100)
            elseif TargN == 2 then
                Colour = Color(100,250,100)
            elseif TargN == 3 then
                Colour = Color(100,100,250)
            elseif TargN == 4 then
                Colour = Color(250,250,250)
            end
            draw.RoundedBox( 2, 0, 0, w, h, Colour )
        end
        local but = butFrame:Add( "DButton" )
        but:SetText("")
        but:SetSize( w * 0.2, h * 0.10 )
    	but.Num = i
        
        but.DoClick = function(this) 
            surface.PlaySound("buttons/button15.wav")
            List1_Active = but.Num
            List2_Active = 0
        end
        
        but.Paint = function(this, W, H) 
            if List1_Active == but.Num then
            	draw.RoundedBox( 10, 0, 0, W, H, Color(191,127,255) )
			elseif Ipattern[but.Num] != 0 then
            	draw.RoundedBox( 10, 0, 0, W, H, Color(100,200,100) )
			else
            	draw.RoundedBox( 10, 0, 0, W, H, Color(75,75,75) )
            end
        end
        
    end
    self.List2 = self:Add( "DPanel" )
    self.List2:SetPos( w - (w * 0.25), h*0.1 )
    self.List2:SetSize(  w * 0.2, h*0.8 ) 
    self.List2.Paint = function(this, w, h) end

    for i = 1,4 do
    	local butFrame = self.List2:Add( "DPanel" )
        butFrame:SetSize( w * 0.2, h * 0.18 )
        butFrame:SetPos( 0, ((i-1)*(h * 0.205)))
        butFrame.Num = i
        
        butFrame.Paint = function(this, w, h) 
            draw.RoundedBox( 10, 0, 0, w, h, Color(175,175,175) )
        end
        
        local butIndicator = butFrame:Add( "DPanel" )
        butIndicator:SetSize( w * 0.05, w * 0.05 )
        butIndicator:SetPos( w * 0.1 - (w * 0.05/2), h * 0.10)
        butIndicator.Paint = function(this, w, h) 
            local Colour = Color(0,0,0)
            if butFrame.Num == 1 then
                Colour = Color(250,100,100)
            elseif butFrame.Num == 2 then
                Colour = Color(100,250,100)
            elseif butFrame.Num == 3 then
                Colour = Color(100,100,250)
            elseif butFrame.Num == 4 then
                Colour = Color(250,250,250)
            end
            draw.RoundedBox( 2, 0, 0, w, h, Colour )
        end
        
        local but = butFrame:Add( "DButton" )
        but:SetText("")
        but:SetSize( w * 0.2, h * 0.10 )
    	but.Num = i
        
        but.DoClick = function(this) 
            List2_Active = but.Num
            if List1_Active != 0 then
                Ipattern[List1_Active] = List2_Active
            	surface.PlaySound("buttons/combine_button5.wav")
			else
            	surface.PlaySound("buttons/button2.wav")
            end
            timer.Simple(0.2, function() 
            List1_Active = 0
            List2_Active = 0 end)
        end
        
        but.Paint = function(this, w, h) 
            if List2_Active == but.Num then
            	draw.RoundedBox( 10, 0, 0, w, h, Color(191,127,255) )
			elseif Ipattern[1] == but.Num or Ipattern[2] == but.Num or Ipattern[3] == but.Num or Ipattern[4] == but.Num then
            	draw.RoundedBox( 10, 0, 0, w, h, Color(100,200,100) )
			else
            	draw.RoundedBox( 10, 0, 0, w, h, Color(75,75,75) )
            end
        end
    end
    
    
	self.confirm = self:Add("DButton")
    self.confirm:SetSize(w*0.2,w*0.05)
    self.confirm:SetPos(w/2 - self.confirm:GetWide()/2,h*0.7)
	self.confirm:SetDisabled(false)
	self.confirm:SetText(L(" "))
	self.confirm.Paint = function(this, w, h)
    draw.RoundedBox( 9, 0, 0, w , h , Color(222,222,222,255) )
	draw.DrawText( "Attempt System Restart", "TargetID", w * 0.5, h * 0.4, Color(55,55,55), TEXT_ALIGN_CENTER )
    end
    
	self.confirm.DoClick = function(this)
		netstream.Start("clientEndMaintenance", ID, Tpattern, Ipattern, 1)
		self:Close()
	end
end

function PANEL:SetText(id)
	ID = id
end

function PANEL:Paint(w,h)
    draw.RoundedBox( 12, 0, 0, w , h , Color(156,156,156,255) )
    draw.RoundedBox( 12, w*0.015, w*0.015, w -w*0.03 , h - w*0.03, Color(100,100,100,255) )
    
    draw.SimpleText(Format("WARNING! High Voltage Electical Wires - Liscenced Technicians Only", 25), "SiderealPanels", w/2, h*0.065, color_white, TEXT_ALIGN_CENTER, 1)
end
vgui.Register("MaintenancePanel_TypeTwo", PANEL, "DFrame")