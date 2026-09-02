AddCSLuaFile()

if (CLIENT) then
	SWEP.PrintName = "Clipboard"
	SWEP.Slot = 0
	SWEP.SlotPos = 9
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Category = "Other"
SWEP.Author = "Winter"
SWEP.Instructions = "Left click to edit document.\nRight click to drop."
SWEP.Purpose = "Science, baby!"
SWEP.Drop = false

SWEP.HoldType = "slam"

SWEP.Spawnable = false
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Damage = 0
SWEP.Primary.Delay = 5

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Delay = 5
SWEP.Secondary.Ammo = ""

SWEP.ViewModel = Model("models/player/hlew/extras/accessories/clipboard.mdl")
SWEP.WorldModel = Model("models/player/hlew/extras/accessories/clipboard.mdl")

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	-- Settings...
	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
            -- Specify a good position
			local offsetVec = Vector(3, -4, -2)
			local offsetAng = Angle(120, 180,0)
			
			local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)
            WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		WorldModel:DrawModel()
	end
end

function SWEP:CalcViewModelView(ViewModel, OldEyePos, OldEyeAng, EyePos, EyeAng )
	local Right 	= EyeAng:Right()
	local Up 		= EyeAng:Up()
	local Forward 	= EyeAng:Forward()
    local Offset = Vector(7,15,-3)
    EyePos = EyePos + Offset.x * Right * 1
	EyePos = EyePos + Offset.y * Forward * 1
	EyePos = EyePos + Offset.z * Up * 1
    ViewModel:SetPos(EyePos)
    ViewModel:SetAngles(OldEyeAng+Angle(-65,-25,0))
    ViewModel:DrawModel()
end

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "ItemReference")
end

function SWEP:Initialize()
  self:SetHoldType("slam")
end

function SWEP:OnRaised()
	self.lastRaiseTime = CurTime()
end

function SWEP:OnLowered()
end

function SWEP:Holster(nextWep)
	self:OnLowered()

	return true
end


function SWEP:PrimaryAttack()
    
	if (!self.Owner:IsWepRaised()) then
		return
	end
    if !(CLIENT) then
    if self:GetItemReference() != 0 then
      ix.item.instances[self:GetItemReference()]:ReadWrite(self:GetItemReference(),self.Owner)
    end end
    
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    return
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	if (!self.Owner:IsWepRaised()) then
		return
	end 
    
    --self.Owner:ChatNotify("This SWEP is currently WIP! Please do not use this :p")
    return
end