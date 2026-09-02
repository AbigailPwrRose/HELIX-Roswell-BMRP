
local errorModel = "models/error.mdl"
local PANEL = {}

AccessorFunc(PANEL, "animationTime", "AnimationTime", FORCE_NUMBER)

function PANEL:Init()
	local x, y = self:LocalToScreen(0, 0)

    local MainPanel = vgui.Create( "DPanel", self)
  
    local MainText = vgui.Create( "DLabel", MainPanel )
    MainText:SetPos( 10, 10 ) 
    MainText:SetText( "This is a WIP part of the UI, more coming soon!" ) 
    MainText:SetColor(255,240,230,250)
    MainText:SetTextColor( Color( 24, 24, 24) )
end

function PANEL:OnRemove()
	self.lastCharacter:Remove()
	self.activeCharacter:Remove()
end

vgui.Register("ixCharMenuCarousel", PANEL, "Panel")

-- character menu main button list

PANEL = {}

function PANEL:Init()
	local parent = self:GetParent()
	self:SetSize(parent:GetWide() * 0.25, parent:GetTall())
    self:SetBGColor(200,200,200,255)

	self:GetVBar():SetWide(0)
	self:GetVBar():SetVisible(false)
end

function PANEL:Add(name)
	local panel = vgui.Create(name, self)
	panel:Dock(TOP)

	return panel
end

function PANEL:SizeToContents()
	self:GetCanvas():InvalidateLayout(true)

	-- if the canvas has extra space, forcefully dock to the bottom so it doesn't anchor to the top
	if (self:GetTall() > self:GetCanvas():GetTall()) then
		self:GetCanvas():Dock(BOTTOM)
	else
		self:GetCanvas():Dock(NODOCK)
	end
end

vgui.Register("ixCharMenuButtonListUwUNyanChanUniqueIdentifier", PANEL, "DScrollPanel")


-- character load panel
PANEL = {}

AccessorFunc(PANEL, "animationTime", "AnimationTime", FORCE_NUMBER)
AccessorFunc(PANEL, "backgroundFraction", "BackgroundFraction", FORCE_NUMBER)

function PANEL:Init()
	local parent = self:GetParent()
	local padding = self:GetPadding()
	local halfWidth = parent:GetWide() * 0.5 - (padding * 2)
	local halfHeight = parent:GetTall() * 0.5 - (padding * 2)
	local modelFOV = (ScrW() > ScrH() * 1.8) and 102 or 78

	self.animationTime = 1
	self.backgroundFraction = 1

	-- main panel
	self.panel = self:AddSubpanel("main")
	self.panel:SetTitle("loadTitle")
	self.panel.OnSetActive = function()
		self:CreateAnimation(self.animationTime, {
			index = 2,
			target = {backgroundFraction = 1},
			easing = "outQuint",
		})
	end

	-- character button list
	local controlList = self.panel:Add("Panel")
	controlList:Dock(LEFT)
	controlList:SetSize(halfWidth, halfHeight*1.2)
  
	-- right-hand side with carousel and buttons
	local infoPanel = self.panel:Add("Panel")
	infoPanel:Dock(BOTTOM)

	local infoButtons = self.panel:Add("Panel")
	infoButtons:Dock(BOTTOM)
	infoButtons:SetTall(halfHeight*0.2) -- hmm...
  
    local back = infoButtons:Add("ixMenuButton")
	back:Dock(LEFT)
	back:SetText("return")
	back:SizeToContents()
	back.DoClick = function()
		self:SlideDown()
		parent.mainPanel:Undim()
	end
  
	self.characterList = controlList:Add("ixCharMenuButtonListUwUNyanChanUniqueIdentifier")
	self.characterList.buttons = {}
	self.characterList:Dock(FILL)
    self.characterList:SetWidth(halfWidth*0.9)
    self.characterList:SetHeight(halfHeight*1.4)
  
	self.carousel = self.panel:Add("DPanel")
    self.carousel:Dock(FILL)
  
	local continueButton = infoButtons:Add("ixMenuButton")
	continueButton:Dock(RIGHT)
	continueButton:SetText("choose")
	continueButton:SetContentAlignment(6)
	continueButton:SizeToContents()
	continueButton.DoClick = function()
		self:SlideDown(self.animationTime, function()
			net.Start("ixCharacterChoose")
				net.WriteUInt(self.character:GetID(), 32)
			net.SendToServer()
		end, true)
	end

	local deleteButton = infoButtons:Add("ixMenuButton")
	deleteButton:Dock(RIGHT)
	deleteButton:SetText("delete")
	deleteButton:SetContentAlignment(5)
	deleteButton:SetTextInset(0, 0)
	deleteButton:SizeToContents()
	deleteButton:SetTextColor(derma.GetColor("Error", deleteButton))
	deleteButton.DoClick = function()
		self:SetActiveSubpanel("delete")
	end

	-- character deletion panel
	self.delete = self:AddSubpanel("delete")
	self.delete:SetTitle(nil)
	self.delete.OnSetActive = function()
		self.deleteModel:SetModel(self.character:GetModel())
		self:CreateAnimation(self.animationTime, {
			index = 2,
			target = {backgroundFraction = 0},
			easing = "outQuint"
		})
	end

	local deleteInfo = self.delete:Add("Panel")
	deleteInfo:SetSize(parent:GetWide() * 0.5, parent:GetTall())
	deleteInfo:Dock(LEFT)

	local deleteReturn = deleteInfo:Add("ixMenuButton")
	deleteReturn:Dock(BOTTOM)
	deleteReturn:SetText("no")
	deleteReturn:SizeToContents()
	deleteReturn.DoClick = function()
		self:SetActiveSubpanel("main")
	end

	local deleteConfirm = self.delete:Add("ixMenuButton")
	deleteConfirm:Dock(BOTTOM)
	deleteConfirm:SetText("yes")
	deleteConfirm:SetContentAlignment(6)
	deleteConfirm:SizeToContents()
	deleteConfirm:SetTextColor(derma.GetColor("Error", deleteConfirm))
	deleteConfirm.DoClick = function()
		local id = self.character:GetID()

		parent:ShowNotice(1, L("deleteComplete", self.character:GetName()))
		self:Populate(id)
		self:SetActiveSubpanel("main")

		net.Start("ixCharacterDelete")
			net.WriteUInt(id, 32)
		net.SendToServer()
	end

	self.deleteModel = deleteInfo:Add("ixModelPanel")
	self.deleteModel:Dock(FILL)
	self.deleteModel:SetModel(errorModel)
	self.deleteModel:SetFOV(modelFOV)
	self.deleteModel.PaintModel = self.deleteModel.Paint

	local deleteNag = self.delete:Add("Panel")
	deleteNag:SetTall(parent:GetTall() * 0.5)
	deleteNag:Dock(BOTTOM)

	local deleteTitle = deleteNag:Add("DLabel")
	deleteTitle:SetFont("ixTitleFont")
	deleteTitle:SetText(L("areYouSure"):utf8upper())
	deleteTitle:SetTextColor(ix.config.Get("color"))
	deleteTitle:SizeToContents()
	deleteTitle:Dock(TOP)

	local deleteText = deleteNag:Add("DLabel")
	deleteText:SetFont("ixMenuButtonFont")
	deleteText:SetText(L("deleteConfirm"))
	deleteText:SetTextColor(color_white)
	deleteText:SetContentAlignment(7)
	deleteText:Dock(FILL)

	-- finalize setup
	self:SetActiveSubpanel("main", 0)
end

function PANEL:OnCharacterDeleted(character)
	if (self.bActive and #ix.characters == 0) then
		self:SlideDown()
	end
end

function PANEL:Populate(ignoreID)
	self.characterList:Clear()
	self.characterList.buttons = {}

	local bSelected

	-- loop backwards to preserve order since we're docking to the bottom
	for i = 1, #ix.characters do
		local id = ix.characters[i]
		local character = ix.char.loaded[id]

		if (!character or character:GetID() == ignoreID) then
			continue
		end

		local index = character:GetFaction()
		local faction = ix.faction.indices[index]
		local color = faction and faction.color or color_white

		local button = self.characterList:Add("ixMenuSelectionButton")
		button:SetBackgroundColor(color)
		button:SetText(character:GetName())
		button:SizeToContents()
		button:SetButtonList(self.characterList.buttons)
		button.character = character
		button.OnSelected = function(panel)
			self:OnCharacterButtonSelected(panel)
		end

		-- select currently loaded character if available
		local localCharacter = LocalPlayer().GetCharacter and LocalPlayer():GetCharacter()

		if (localCharacter and character:GetID() == localCharacter:GetID()) then
			button:SetSelected(true)
			self.characterList:ScrollToChild(button)

			bSelected = true
		end
	end

	if (!bSelected) then
		local buttons = self.characterList.buttons

		if (#buttons > 0) then
			local button = buttons[#buttons]

			button:SetSelected(true)
			self.characterList:ScrollToChild(button)
		else
			self.character = nil
		end
	end

	self.characterList:SizeToContents()
end

function PANEL:OnSlideUp()
	self.bActive = true
	self:Populate()
end

function PANEL:OnSlideDown()
	self.bActive = false
end

function PANEL:OnCharacterButtonSelected(panel)
	--self.carousel:SetActiveCharacter(panel.character)
	self.character = panel.character
end

function PANEL:Paint(width, height)
	derma.SkinFunc("PaintCharacterLoadBackground", self, width, height)
end

vgui.Register("ixCharMenuLoad", PANEL, "ixCharMenuPanel")