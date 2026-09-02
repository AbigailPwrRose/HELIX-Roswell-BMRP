AddCSLuaFile()

if (CLIENT) then
	SWEP.PrintName = "Xenobiologists Stungun"
	SWEP.Slot = 0
	SWEP.SlotPos = 5
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
end

SWEP.Category = "Other"
SWEP.Author = "Winter"
SWEP.Instructions = "Primary Fire: Stun[Medium range]\nSecondary Fire: Ragdoll[Short range]\nReload: Extract Sample\nA specially developed stungun for Bio workers that only works on Xennians. Can still burn someone with its blast, so be careful!"
SWEP.Purpose = "Hitting things and stunning folk."
SWEP.Drop = false

SWEP.HoldType = "pistol"

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "pistol"

SWEP.ViewTranslation = 4

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Damage = 7.5
SWEP.Primary.Delay = 0.7

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.ViewModel = Model("models/weapons/hlwe1507/v_blaster.mdl")
SWEP.WorldModel = Model("models/weapons/hlwe1507/w_blaster.mdl")

SWEP.UseHands = true
SWEP.LowerAngles = Angle(15, -10, -20)

SWEP.FireWhenLowered = true

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Activated")
	self:NetworkVar("Int", 0, "Voltage")
end

function SWEP:Precache()
	util.PrecacheSound("physics/wood/wood_crate_impact_hard3.wav")
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:OnRaised()
	self.lastRaiseTime = CurTime()
end

function SWEP:OnLowered()
	self:SetActivated(false)
end

function SWEP:Holster(nextWep)
	self:OnLowered()

	return true
end

local color_glow = Color(128, 128, 128)

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	-- Settings...
	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
            -- Specify a good position
			local offsetVec = Vector(-8, -5, 29)
			local offsetAng = Angle(180, 175,0)
			
			local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)
            WorldModel:SetModelScale(0.7,0 )

            WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		WorldModel:DrawModel()
	end
end

local NUM_BEAM_ATTACHEMENTS = 9
local BEAM_ATTACH_CORE_NAME	= "sparkrear"

function SWEP:PostDrawViewModel()
	if (!self:GetActivated()) then
		return
	end

	local viewModel = LocalPlayer():GetViewModel()

	if (!IsValid(viewModel)) then
		return
	end

	cam.Start3D(EyePos(), EyeAngles())
		local size = math.Rand(3.0, 4.0)
		local color = Color(255, 255, 255, 50 + math.sin(RealTime() * 2)*20)

		STUNSTICK_GLOW_MATERIAL_NOZ:SetFloat("$alpha", color.a / 255)

		render.SetMaterial(STUNSTICK_GLOW_MATERIAL_NOZ)

		local attachment = viewModel:GetAttachment(viewModel:LookupAttachment(BEAM_ATTACH_CORE_NAME))

		if (attachment) then
			render.DrawSprite(attachment.Pos, size * 10, size * 15, color)
		end

		for i = 1, NUM_BEAM_ATTACHEMENTS do
			attachment = viewModel:GetAttachment(viewModel:LookupAttachment("spark"..i.."a"))
			size = math.Rand(2.5, 5.0)

			if (attachment and attachment.Pos) then
				render.DrawSprite(attachment.Pos, size, size, color)
			end

			attachment = viewModel:GetAttachment(viewModel:LookupAttachment("spark"..i.."b"))
			size = math.Rand(2.5, 5.0)

			if (attachment and attachment.Pos) then
				render.DrawSprite(attachment.Pos, size, size, color)
			end
		end
	cam.End3D()
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	if (!self.Owner:IsWepRaised()) then
		return
	end

	self:EmitSound("weapons/displacer/displacer_fire.wav")
	self:SendWeaponAnim(ACT_VM_HITCENTER)

	local damage = self.Primary.Damage

	if (self:GetActivated()) then
		local damageTab = {
			[1] = 5,
			[2] = 15,
			[3] = 30
		}
		damage = damageTab[self:GetVoltage()]
	end

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:ViewPunch(Angle(1, 0, 0.125))

	self.Owner:LagCompensation(true)
		local data = {}
			data.start = self.Owner:GetShootPos()
			data.endpos = data.start + self.Owner:GetAimVector()*500
			data.filter = self.Owner
		local trace = util.TraceLine(data)
	self.Owner:LagCompensation(false)
    util.Decal( "FadingScorch", data.start, data.endpos)
	if (SERVER and trace.Hit) then
		if (self:GetActivated()) then
			local effect = EffectData()
				effect:SetStart(trace.HitPos)
				effect:SetNormal(trace.HitNormal)
				effect:SetOrigin(trace.HitPos)
			util.Effect("StunstickImpact", effect, true, true)
		end

		self.Owner:EmitSound("weapons/displacer/displacer_start.wav")

		local entity = trace.Entity

		if (IsValid(entity)) then
			local damageInfo = DamageInfo()
				damageInfo:SetAttacker(self.Owner)
				damageInfo:SetInflictor(self)
				damageInfo:SetDamage(10)
				damageInfo:SetDamageType(DMG_ENERGYBEAM)
				damageInfo:SetDamagePosition(trace.HitPos)
				damageInfo:SetDamageForce(self.Owner:GetAimVector() * 10000)
			entity:DispatchTraceAttack(damageInfo, data.start, data.endpos)
		end
	end
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	if (!self.Owner:IsWepRaised()) then
		return
	end

	self:EmitSound("weapons/displacer/displacer_fire.wav")
	self:SendWeaponAnim(ACT_VM_HITCENTER)

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:ViewPunch(Angle(1, 0, 0.125))

	self.Owner:LagCompensation(true)
		local data = {}
			data.start = self.Owner:GetShootPos()
			data.endpos = data.start + self.Owner:GetAimVector()*200
			data.filter = self.Owner
		local trace = util.TraceLine(data)
	self.Owner:LagCompensation(false)
	local entity = trace.Entity
	if (SERVER and IsValid(entity)) then
		self:SetNextSecondaryFire(CurTime() + 2)
		self:SetNextPrimaryFire(CurTime() + 2)
		if (entity:IsPlayer()) then
            if (entity:GetFactionName() == "Xenian") or (entity:GetFactionName() == "Event") then
            	self.Owner:EmitSound("weapons/displacer/displacer_teleport.wav")
                entity:SetRagdolled(true,10,5)
    			bPushed = true 
            end
        else 
			local damageInfo = DamageInfo()
				damageInfo:SetAttacker(self.Owner)
				damageInfo:SetInflictor(self)
				damageInfo:SetDamage(10)
				damageInfo:SetDamageType(DMG_ENERGYBEAM)
				damageInfo:SetDamagePosition(trace.HitPos)
				damageInfo:SetDamageForce(self.Owner:GetAimVector() * 10000)
			entity:DispatchTraceAttack(damageInfo, data.start, data.endpos)
        end
	end
end
