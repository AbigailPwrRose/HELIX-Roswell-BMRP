AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Xen Weather Station"
ENT.Category = "Black Mesa"
ENT.Author = "Winter"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true
ENT.RefreshTime = 600
ENT.ProgTick = 0.05
ENT.ProgMaxxer = 100

ENT.MaxRenderDistance = math.pow(256, 2)

function ENT:Initialize()
    self:SetModel("models/props_office/open_laptop.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self.canUse = true
    self:SetSkin(0)
    self.Cooldown = self.RefreshTime
    self.Progress = 0
    local physics = self:GetPhysicsObject()
    physics:EnableMotion(false)
    physics:Sleep()
end

function ENT:Use( activator )
	if ( activator:IsPlayer() ) then 
        local SpawnPos = self:GetPos()+Vector(0,0,50)
        if (self:GetSkin() == 3) then
            activator:SetAction("Repairing...", 15)
    		activator:DoStaredAction(self, function()
                self.Cooldown = self.RefreshTime
                self:SetSkin(0)
                activator:ChatNotify("You have reactivated this weather station!")
    		end, 15, function()
            activator:Notify("Action Cancelled!")
            activator:SetAction(" ", 0.01) end)
        elseif (self:GetSkin() == 1) then
            activator:SetAction("Exporting...", 15)
    		activator:DoStaredAction(self, function()
                self.Cooldown = self.Cooldown + self.RefreshTime/2
                self:SetSkin(0)
                self.Progress = 0
                ix.item.Spawn("weather_report", SpawnPos, nil, Angle(0,0,0), 
            {
              name="Xen Weather Report",
              description="A compiled report of data collected from Xen.",
              pressure = math.random(80,110),
              oxygen = math.random(160,250),
              nitrogen = math.random(500,600),
              argon = math.random(60,100),
              airbornBacteria = math.random(0,2),
              staticElectricity = math.random(0,2),
              temper = math.random(205,450),
              watercontents = math.random(300,960),
              windysped = math.random(60,320),
              windydirection = table.Random({"Station North","Station East","Station South","Station West","Station North-East", "Station North-West", "Station South-East", "Station South-West"})
            })
                activator:ChatNotify("You have collected the data this weather station!")
        		end, 15, function()
                  activator:Notify("Action Cancelled!")
                  activator:SetAction(" ", 0.01) 
            end)
        end
	end
end
if !(CLIENT) then
function ENT:Think()
    self.Cooldown = math.Clamp(self.Cooldown - 1,0,self.RefreshTime)
    self:NextThink( CurTime()+2 )
    -- This will run the chance for crashing the program
    if self:GetSkin() == 0 then
      if self.Cooldown == 0 then
        local Rand = math.random(0,100)
        if Rand < 5 then
          self:SetSkin(3)
        end
      end
    end
    -- This will run the progress tick
    if self:GetSkin() == 0 then
      self.Progress = math.Clamp(self.Progress + self.ProgTick,0,self.ProgMaxxer)
      if self.Progress == self.ProgMaxxer then
          self:SetSkin(1)
      end
    end
    -- Sets a Networked variable to display in the info
    self:SetNW2Var("ProgToComplete", math.Truncate( self.Progress , 1 ) )
    
    return true -- Apply NextThink call
end end

if not CLIENT then return end
function ENT:Draw()
    self:DrawModel() 
end
ENT.PopulateEntityInfo = true
function ENT:OnPopulateEntityInfo(container)
    local name = container:AddRow("name")
    name:SetImportant()
    name:SetText("Xen Weather Station")
    name:SizeToContents()
    local description = container:AddRow("description")
    if self:GetSkin() == 3 then
        description:SetText("A laptop from which a Xen weather station is monitored. Its malfunctioned, and needs to be reset.")
    elseif self:GetSkin() == 1 then
        description:SetText("A laptop from which a Xen weather station is monitored. Its finished processing data, and is ready to extract!.")
    else
        local DisNum = math.Truncate( self:GetNW2Var("ProgToComplete",0), 1)
        description:SetText("A laptop from which a Xen weather station is monitored and controlled. Its currently gathering and compiling data.\n\n Current Progress: "..DisNum.."%") end
    description:SizeToContents()
end