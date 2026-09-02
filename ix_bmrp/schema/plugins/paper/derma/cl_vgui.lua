local PANEL = {}

function PANEL:Init()
	self:SetSize(500, 700)	
	self:MakePopup()
	self:Center()
	self:SetTitle("Document")

	self.controls = self:Add("DPanel")
	self.controls:Dock(BOTTOM)
	self.controls:SetTall(30)
	self.controls:DockMargin(0, 5, 0, 0)

	self.contents = self:Add("DTextEntry")
	self.contents:Dock(FILL)
	self.contents:SetMultiline(true)
	self.contents:SetEditable(true)

	self.test = self.controls:Add("DTextEntry")
	self.test:SetMultiline(true)
	self.test:SetSize(0,0)
	self.test:SetEditable(false)

	self.confirm = self.controls:Add("DButton")
	self.confirm:Dock(RIGHT)
	self.confirm:SetDisabled(false)
	self.confirm:SetText(L("Save & Exit"))

	self.controls.Paint = function(this, w, h)
		local text = self.contents:GetValue()
		draw.SimpleText(Format("Number of characters: %s/3000", string.len(text)), "DermaDefault", 10, h/2, color_white, TEXT_ALIGN_LEFT, 1)
	end

	self.confirm.DoClick = function(this)
		local text = self.contents:GetValue()
		netstream.Start("paperSendText", itemID, text)
		self:Close()
	end
end

function PANEL:setText(text, id)
	self.contents:SetValue(text or "")
	itemID = id
end

vgui.Register("paperRead", PANEL, "DFrame")

local PANEL = {}

function PANEL:Init()
	self:SetSize(500, 700)	
	self:MakePopup()
	self:Center()
	self:SetTitle("Document")

	self.controls = self:Add("DPanel")
	self.controls:Dock(BOTTOM)
	self.controls:SetTall(30)
	self.controls:DockMargin(0, 5, 0, 0)

	self.contents = self:Add("DTextEntry")
	self.contents:Dock(FILL)
	self.contents:SetMultiline(true)
	self.contents:SetEditable(false)

	self.test = self.controls:Add("DTextEntry")
	self.test:SetMultiline(true)
	self.test:SetSize(0,0)
	self.test:SetEditable(false)

	self.confirm = self.controls:Add("DButton")
	self.confirm:Dock(RIGHT)
	self.confirm:SetDisabled(false)
	self.confirm:SetText(L("Exit"))

	self.controls.Paint = function(this, w, h)
		local text = self.creator
		draw.SimpleText(Format("by %s", text), "DermaDefault", 10, h/2, color_white, TEXT_ALIGN_LEFT, 1)
	end

	self.confirm.DoClick = function(this)
		self:Close()
	end
end

function PANEL:setText(text, id)
	self.contents:SetValue(text or "")
	itemID = id
end

vgui.Register("paperRead_staticV", PANEL, "DFrame")
