AddCSLuaFile()

if (CLIENT) then
	SWEP.PrintName = "Injector Syringe"
	SWEP.Slot = 0
	SWEP.SlotPos = 9
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Category = "Other"
SWEP.Author = "Winter"
SWEP.Instructions = "Left click to inject a victim with chemicals.\nRight click to extract sample."
SWEP.Purpose = "Science, baby!"
SWEP.Drop = false

SWEP.Spawnable = false
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Damage = 0
SWEP.Primary.Delay = 5

SWEP.HoldType = "slam"
SWEP.ViewModelFOV = 61.909547738693
SWEP.ViewModelFlip = false
SWEP.UseHands = false
SWEP.ViewModel = "models/winter_chemistry_props/syringe_out.mdl"
SWEP.WorldModel = "models/winter_chemistry_props/syringe_out.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {
	["joint1"] = { scale = Vector(0.591, 0.591, 0.591), pos = Vector(5.741, -2.408, -1.297), angle = Angle(-23.334, 5.556, -7.778) }
}
SWEP.VElements = {}
SWEP.WElements = {}

function SWEP:Initialize()
  	self:SetHoldType("slam")
	if CLIENT then
	
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		self:CreateModels(self.VElements)
		self:CreateModels(self.WElements)
		
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					vm:SetColor(Color(255,255,255,1))
					vm:SetMaterial("Debug/hsv")			
				end
			end
		end
		
	end

end

function SWEP:Holster()
	
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
	return true
end

function SWEP:OnRemove()
	self:Holster()
end

if CLIENT then
	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		
		if (!self.VElements) then return end
		
		self:UpdateBonePositions(vm)

		if (!self.vRenderOrder) then
			
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				--model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	SWEP.wRenderOrder = nil
    
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	-- Settings...
	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
            -- Specify a good position
			local offsetVec = Vector(5.8, -2, -1.5)
			local offsetAng = Angle(15, -15,120)
			
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

		WorldModel:SetModelScale(0.9)
		WorldModel:DrawModel()
	end
    
	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end
                
	function table.FullCopy( tab )

		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) // recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
	
end

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "ItemReference")
	self:SetNW2String("LastTarget","")
end

function SWEP:DrawHUD()
    local client = LocalPlayer()

    local scrW, scrH = ScrW(), ScrH()
    local halfWidth = scrW / 2
	
    surface.SetDrawColor(200, 200, 200, 20)
    surface.DrawRect(scrW*0.928, scrH*0.325, scrH*0.1, scrH*0.25)
    
	draw.DrawText( "Left click to inject target", "TargetID", ScrW() - ScrW()*0.01, ScrH() - ScrH()*0.12, color_white, TEXT_ALIGN_RIGHT )
	draw.DrawText( "Right click to take sample", "TargetID", ScrW() - ScrW()*0.01 , ScrH() - ScrH()*0.1, color_white, TEXT_ALIGN_RIGHT )
	draw.DrawText( "Reload to empty syringe", "TargetID", ScrW() - ScrW()*0.01 , ScrH() - ScrH()*0.08, color_white, TEXT_ALIGN_RIGHT )

	local FillRaw = 0
	local Chem = 0
	if self:GetItemReference() != 0 then
		FillRaw = ix.item.instances[self:GetItemReference()]:GetData("Volume",0)
		Chem = ix.item.instances[self:GetItemReference()]:GetData("Chemical",0)
	end
	local FillPer = FillRaw/200
	local HeightMod = scrH*0.25*(1-FillPer)

    surface.SetDrawColor(ix.chemistry.List[Chem][3], 200)
    surface.DrawRect(scrW*0.928, scrH*0.325 + HeightMod, scrH*0.1, scrH*0.25 * FillPer )

    surface.SetMaterial(Material("FlaskIcon.png"))
    surface.SetDrawColor(200,200,200, 255)
    surface.DrawTexturedRect(scrW*0.90, scrH*0.2, scrH*0.2, scrH*0.5)

	if self:GetNW2String("LastTarget","") != "" then
	    draw.SimpleText(
        self:GetNW2String("LastTarget",""),
        "RFF",
        halfWidth,
        scrH*0.9,
        Color(255,255,255),
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
   		)	
	end
end
if !(CLIENT) then
    function SWEP:Reload()
        if self:GetNextPrimaryFire() >= CurTime() then
            return 
        end
        if (!self.Owner:IsWepRaised()) then
            return
        end
        --ix.item.instances[self:GetItemReference()]:Empty()
        self.Owner:Notify("This function is broken rn, sorry!")
        self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    end

    function SWEP:PrimaryAttack()
        self.Owner:SetAnimation(ACT_SLAM_THROW_DETONATE)
        if self:GetNextPrimaryFire() >= CurTime() then
            return 
        end
        if (!self.Owner:IsWepRaised()) then
            return
        end
        if self:GetItemReference() != 0 then
            self.Owner:LagCompensation(true)
                local data = {}
                    data.start = self.Owner:GetShootPos()
                    data.endpos = data.start + self.Owner:GetAimVector()*120
                    data.filter = self.Owner
                local trace = util.TraceLine(data)
            if (SERVER and trace.Hit) then
                local entity = trace.Entity

                if (IsValid(entity)) and (entity:IsNPC() or entity:IsPlayer()) and ix.item.instances[self:GetItemReference()]:GetData("Volume",0) >= 50 and ix.item.instances[self:GetItemReference()]:GetData("Chemical",0) != 0 then

                    local Name = entity:GetName():lower()
                    local CanInject = string.find( Name,"turret") or string.find( Name,"sentry") or string.find( Name,"robot") or string.find( Name,"abrams") or string.find( Name,"bradl") or string.find( Name,"osprey")
                    if CanInject != true or entity:IsPlayer() then
                        local Chem = ix.item.instances[self:GetItemReference()]:GetData("Chemical",0)
                        ix.chemistry.ApplyChem(entity,Chem)
                        self:SetNW2String("LastTarget",ix.chemistry.List[Chem][1].." injected into "..trace.Entity:GetName())
                        timer.Create( "Injector"..trace.Entity:GetName()..self.Owner:GetName(), 4, 1, function()
                            self:SetNW2String("LastTarget","")
                        end)

                        ix.item.instances[self:GetItemReference()]:SetData("Volume", ix.item.instances[self:GetItemReference()]:GetData("Volume",0)-50)
                        if ix.item.instances[self:GetItemReference()]:GetData("Volume",0) <= 0 then
                            ix.item.instances[self:GetItemReference()]:SetData("Chemical",0)
                        end 
                    end
                end
            end	
        end 
        self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
        return
    end
    function SWEP:SecondaryAttack()
        if self:GetNextPrimaryFire() >= CurTime() then
            return 
        end
        if (!self.Owner:IsWepRaised()) then
            return
        end
        self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
        self.Owner:SetAnimation(ACT_SLAM_THROW_DETONATE)
        if self:GetItemReference() != 0 then
            self.Owner:LagCompensation(true)
                local data = {}
                    data.start = self.Owner:GetShootPos()
                    data.endpos = data.start + self.Owner:GetAimVector()*120
                    data.filter = self.Owner
                local trace = util.TraceLine(data)
            self.Owner:LagCompensation(false)
            if (SERVER and trace.Hit) then
                local entity = trace.Entity

                if (IsValid(entity)) and (entity:IsNPC() or entity:IsPlayer()) then
                    local Chem = 0
                    if entity:IsPlayer() then
                        local Fac = ix.faction.Get(entity:GetCharacter():GetFaction()).name
                        if Fac == "Xenian" then
                            if string.find( entity:GetModel():lower(),"slave") or string.find( entity:GetModel():lower(),"vortigaunt") then
                                Chem = 10
                            elseif string.find( entity:GetModel():lower(),"grunt") then 
                                Chem = 11
                            elseif string.find( entity:GetModel():lower(),"crab") or string.find( entity:GetModel():lower(),"bull") or string.find( entity:GetModel():lower(),"hound") then 
                                Chem = 9
                            else
                                Chem = 13
                            end
                        else 
                            Chem = 2
                        end
                    else
                        local Name = entity:GetName():lower()
                        if string.find( Name,"slave") or string.find( Name,"slave") or string.find(Name,"tor") then
                            Chem = 10
                        elseif string.find( Name,"grunt") or string.find( Name,"grunt") then 
                            Chem = 11
                        elseif string.find( Name,"crab") or string.find( Name,"garg") or string.find( Name,"drone") or string.find( Name,"toad") or string.find( Name,"gonarch") or string.find( Name,"bull") or string.find(Name,"hound")  or string.find(Name,"panther") then 
                            Chem = 9
                        elseif string.find( Name,"barnacle") or string.find( Name,"tree") or Name == "Tentacle" then 
                            Chem = 12
                        elseif string.find( Name,"gonome") or string.find( Name,"zombie") or string.find( Name,"crasher") then 
                            Chem = 2
                        elseif string.find( Name,"turret") or string.find( Name,"sentry") or string.find( Name,"robot") or string.find( Name,"abrams") or string.find( Name,"bradl") or string.find( Name,"osprey") or Name == "" then 
                            Chem = 0
                        else
                            Chem = 2
                        end
                    end
                    if Chem != 0 and (ix.item.instances[self:GetItemReference()]:GetData("Chemical",0)==0 or ix.item.instances[self:GetItemReference()]:GetData("Chemical",0)==Chem) and ix.item.instances[self:GetItemReference()]:GetData("Volume",0) < 200 then
                        self:SetNW2String("LastTarget","Sample of "..ix.chemistry.List[Chem][1].." taken from "..trace.Entity:GetName())
                        ix.item.instances[self:GetItemReference()]:SetData("Chemical",Chem)
                        ix.item.instances[self:GetItemReference()]:SetData("Volume",math.Clamp(ix.item.instances[self:GetItemReference()]:GetData("Volume",200)+100,0,200))
                        timer.Create( "Injector"..trace.Entity:GetName()..self.Owner:GetName(), 5, 1, function()
                            if (self) then
                                self:SetNW2String("LastTarget","")
                            end
                        end)

                    end
                end

            end	
        end 
        return
    end 
end