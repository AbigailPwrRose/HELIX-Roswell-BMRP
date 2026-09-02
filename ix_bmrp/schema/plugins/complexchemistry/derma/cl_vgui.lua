local PANEL = {}

function PANEL:Init()
	self:SetSize(500, 700)	
	self:MakePopup()
	self:Center()
	self:SetTitle("Chemical Readout")

	self.controls = self:Add("DPanel")
	self.controls:Dock(BOTTOM)
	self.controls:SetTall(30)
	self.controls:DockMargin(0, 5, 0, 0)

	self.Scroll = self:Add( "DScrollPanel")
	self.Scroll:Dock( FILL )

	self.Scroll.contents = self:Add("DTextEntry")
	self.Scroll.contents:Dock(FILL)
	self.Scroll.contents:SetMultiline(true)
	self.Scroll.contents:SetEditable(false)

	self.test = self.controls:Add("DTextEntry")
	self.test:SetMultiline(true)
	self.test:SetSize(0,0)
	self.test:SetEditable(false)

	self.confirm = self.controls:Add("DButton")
	self.confirm:Dock(RIGHT)
	self.confirm:SetDisabled(false)
	self.confirm:SetText(L("Exit"))

	self.confirm.DoClick = function(this)
		self:Close()
	end
end

function PANEL:setText(text)
	self.Scroll.contents:SetValue(text or "")
end

vgui.Register("Chemistry_ReadOut", PANEL, "DFrame")
