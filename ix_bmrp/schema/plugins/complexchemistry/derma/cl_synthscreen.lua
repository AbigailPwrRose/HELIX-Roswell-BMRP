local PANEL = {}

function PANEL:Init()
	self:SetSize(500, 700)	
	self:MakePopup()
	self:Center()
	self:SetTitle("Chemical Request Menu")
    
    self.SelChem = {0,0,0}
    self.RefID = 0

	self.controls = self:Add("DPanel")
	self.controls:Dock(BOTTOM)
	self.controls:SetTall(30)
	self.controls:DockMargin(0, 5, 0, 0)

	self.SelectedShow = self:Add("DTextEntry")
	self.SelectedShow:SetMultiline(true)
	self.SelectedShow:Dock(BOTTOM)
	self.SelectedShow:SetEditable(false)
	self.SelectedShow:SetText("Currently Selected: No Chemical")
    
	self.Scroll = self:Add( "DScrollPanel")
	self.Scroll:DockMargin(4, 4, 4, 4)
	self.Scroll:Dock( FILL )
    
    self.Scroll.SynthList = self:Add( "DListView" )
    self.Scroll.SynthList:Dock( FILL )
    self.Scroll.SynthList:SetMultiSelect( false )
    self.Scroll.SynthList:AddColumn( "Chemical" )
    self.Scroll.SynthList:AddColumn( "Volume" )
    self.Scroll.SynthList:AddColumn( "Cost" )

    self.Scroll.SynthList.OnRowRightClick = function( lineid, line )
        
        SubPanel = vgui.Create( "DFrame" )
        SubPanel:SetSize( 200, 200 )
        SubPanel:Center()
        SubPanel:MakePopup()
		SubPanel:SetTitle(ix.chemistry.List[self.ChemTab[line][1]][1])
        
        DescriptionPanel = SubPanel:Add( "DTextEntry" )
        DescriptionPanel:Dock(FILL)
        DescriptionPanel:SetMultiline(true)
        DescriptionPanel:SetEditable(false)
        DescriptionPanel:SetText(ix.chemistry.List[self.ChemTab[line][1]][5])
        
        SubPanel:SetParent( self )
    end
    
    self.Scroll.SynthList.OnRowSelected = function( lst, index, pnl )
        surface.PlaySound("terminalr/char/1.wav")
        self.SelChem = {self.ChemTab[index][1],self.ChemTab[index][2],self.ChemTab[index][3]}
		self.SelectedShow:SetText("Currently Selected: ".. ix.chemistry.GetChemName(self.SelChem[1]) )
    end
  

	self.exitBut = self.controls:Add("DButton")
	self.exitBut:Dock(RIGHT)
	self.exitBut:SetDisabled(false)
	self.exitBut:SetText(L("Exit"))

	self.exitBut.DoClick = function(this)
        surface.PlaySound("terminalr/false.wav")
		self:Close()
	end
    
	self.activate = self.controls:Add("DButton")
	self.activate:Dock(LEFT)
	self.activate:SetDisabled(false)
	self.activate:SetText(L("Request"))
    self.activate:SizeToContents()

	self.activate.DoClick = function(this)
        if self.SelChem[1] != 0 then
            surface.PlaySound("terminalr/disk/eject/3.wav")
            netstream.Start("SynthManufacture", util.TableToJSON(self.SelChem), self.RefID)
			self:Close()
        else
            surface.PlaySound("terminalr/passbad.wav")
        end
	end
end

function PANEL:setText(contents,ID)
    self.ChemTab = util.JSONToTable(contents)
    self.RefID = ID
    if self.ChemTab == nil or self.RefID <= 0 then
        LocalPlayer():Notify("An Unexpected Error has occured!")
        self:Close()
    end
    for k,v in pairs(self.ChemTab) do
        if istable(v) then
            self.Scroll.SynthList:AddLine( ix.chemistry.GetChemName(v[1]), v[2].."ml", v[3] )
        end
    end
end

vgui.Register("Chemistry_SynthPanel", PANEL, "DFrame")
