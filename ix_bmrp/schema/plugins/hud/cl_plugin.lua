local PLUGIN = PLUGIN

surface.CreateFont("RFF", {
    font = "Tahoma",
    size = 20,
    weight = 600,
    antialias = true,
    additive = false,           
    outline = false,            
    shadow = true
})

surface.CreateFont("RFFBig", {
    font = "Tahoma",
    size = 60,
    weight = 600,
    antialias = true,
    additive = false,           
    outline = false,            
    shadow = true
})

local blackMesaLogo = Material("logos/WhiteLambda.png", "noclamp smooth")

hook.Add("HUDShouldDraw", "HideHelixHUD", function(name)
    local blockedHUD = {
        ["CHudHealth"] = true,
        ["CHudBattery"] = true,
        ["CHudAmmo"] = true,
        ["CHudSecondaryAmmo"] = true,
    }

    if blockedHUD[name] then
        return false
    end
end)

hook.Add("HUDPaint", "DrawHUD", function()
    local client = LocalPlayer()

    local factionTable = ix.faction
    local classTable = ix.class
    
    if (!IsValid(client)) then return end
    local character = client:GetCharacter()
    local DoShow = ix.option.Get("showStats", true)
    
    if (DoShow != true) then return end
    if (!character) then return end
    if (!client:Alive()) then return end
    if (IsValid(ix.gui.menu)) then return end
    
    local health = client:Health()
    local maxHealth = client:GetMaxHealth()

    local armor = client:Armor()
    local maxArmor = client:GetMaxArmor()

    local faction = character:GetFaction()
    local factionData = factionTable.Get(faction)
    local class = character:GetClass()
    local JobDisguise = character:GetFakejob()
    
    local factionName = factionData.name
    local pay = hook.Run("GetSalaryAmount", client, factionData) or factionData.pay
    local factionSalary = pay
    
    if factionSalary == nil then factionSalary = 0 end
    
    local className = classTable.Get(class).name
    local characterName = character:GetName()
    local characterMoney = character:GetMoney()
    local rank = character:GetRank()
    
    local rankDisplay = ""
    local rankNumDis = ""
    
    if factionData and factionData.Ranks and factionData.Ranks[rank] then
        rankDisplay = factionData.Ranks[rank][1]
        rankNumDis = "("..rank..")"
    end
    
    if JobDisguise != "" then
      className = ""
    end

    local scrW, scrH = ScrW(), ScrH()
    local width = 450
    local height = 30

    -- local x = scrW - width - 20
    local x = 20
    
    local moneyY = scrH - height - 20
    local healthY = scrH - height - 60
    local factionY = scrH - height - 100
    local classY = scrH - height - 140
    local nameY = scrH - height - 180

    local healthWidth = math.Clamp((health / maxHealth) * width, 0, width)
    local armorWidth = math.Clamp((armor / maxArmor) * width, 0, width)
    local halfWidth = width / 2
    
    if armor > 0 then
        local glowSize = 4
        surface.SetDrawColor(0, 255, 255, 150)
        surface.DrawRect(x - glowSize, healthY - glowSize, armorWidth + glowSize*2, height + glowSize*2)
    end

    surface.SetDrawColor(50, 50, 50, 120)
    -- BACKGROUND
    surface.DrawRect(10, scrH - height - 190, width + 20, (height + 10) * 5 + 10)
    
    surface.SetDrawColor(50, 50, 50, 255)
    surface.DrawRect(x, healthY, width, height)
    surface.SetDrawColor(200, 50, 50, 255)
    surface.DrawRect(x, healthY, healthWidth, height)

    draw.SimpleText(
        "A: " ..armor,
        "RFF",
        x + width - 10,
        healthY + height / 2,
        Color(255,255,255),
        TEXT_ALIGN_RIGHT,
        TEXT_ALIGN_CENTER
    )
    
    draw.SimpleText(
        "H: " ..health,
        "RFF",
        x + 10,
        healthY + height / 2,
        Color(255,255,255),
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_CENTER
    )

    surface.SetDrawColor(150,100,30, 255)
    surface.DrawRect(x, nameY, height * 3 + 20, height * 3 + 20)

    surface.SetMaterial(blackMesaLogo)
    surface.SetDrawColor(200,200,200, 255)
    surface.DrawTexturedRect(x + 5, nameY + 5, 100, 100)
    
    surface.SetDrawColor(150,100,30, 255)
    surface.DrawRect(x + (height * 3 + 20) + 10, factionY, (width - (height * 3 + 20)) - 10, height)
    draw.SimpleText(
        client:ConfiguredGetMesaArea(),
        "RFF",
        x + (height * 3 + 20) + 10 + ((width - (height * 3 + 20)) - 10) / 2,
        factionY + height / 2,
        Color(255,255,255),
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )
    
    surface.DrawRect(x + (height * 3 + 20) + 10, classY, (width - (height * 3 + 20)) - 10, height)
    draw.SimpleText(
        className..JobDisguise,
        "RFF",
        x + (height * 3 + 20) + 10 + ((width - (height * 3 + 20)) - 10) / 2,
        classY + height / 2,
        Color(255,255,255),
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )

    surface.SetDrawColor(150,100,30, 255)
    surface.DrawRect(x + (height * 3 + 20) + 10, nameY, (width - (height * 3 + 20)) - 10, height)

    draw.SimpleText(
        characterName,
        "RFF",
        x + (height * 3 + 20) + 10 + ((width - (height * 3 + 20)) - 10) / 2,
        nameY + height / 2,
        Color(255,255,255),
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )

    surface.DrawRect(x, moneyY, halfWidth - 5, height)
    
    draw.SimpleText(
        "Wallet: $" ..characterMoney,
        "RFF",
        x + 10,
        moneyY + height / 2,
        Color(255,255,255),
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_CENTER
    )
    draw.SimpleText(
        "Sal: $" ..factionSalary,
        "RFF",
        x + halfWidth - 15,
        moneyY + height / 2,
        Color(255,255,255),
        TEXT_ALIGN_RIGHT,
        TEXT_ALIGN_CENTER
    )
    
    surface.DrawRect(x + halfWidth + 5, moneyY, halfWidth - 5, height)

    draw.SimpleText(
        rankDisplay..rankNumDis or ERR,
        "RFF",
        (x + halfWidth) + halfWidth / 2,
        moneyY + height / 2,
        Color(255,255,255),
        TEXT_ALIGN_CENTER,
        TEXT_ALIGN_CENTER
    )

    --[[
    surface.DrawRect(x, attributeY2, (width / 3) - 5, height)
    surface.DrawRect(x + (width / 3) + 5, attributeY2, (width / 3) - 5, height)
    surface.DrawRect(x + 2 * (width / 3) + 5, attributeY2, (width / 3) - 5, height)
    ]]
    if character:GetData("WearingHEVStuff",0) == 1 then
      surface.SetMaterial(Material("icon16/status_offline.png"))
      surface.SetDrawColor(200,200,200, 145)
      surface.DrawTexturedRect(ScrW()-220, ScrH()-220, 200, 200)
    end
end)

hook.Add("PostPlayerDraw", "DrawCharacterName", function(ply)
        if not IsValid(ply) then return end
        if not ply:Alive() then return end

        local client = LocalPlayer()
        if ply == client then return end

        local bone = ply:LookupBone("ValveBiped.Bip01_Head1")
        local pos

        if bone then
            local bonePos, boneAng = ply:GetBonePosition(bone)
            pos = bonePos + Vector(0,0,14)
        else
            pos = ply:EyePos() + Vector(0,0,14)
        end

        local ang = Angle(0, client:EyeAngles().y - 90, 90)

        local name = ply:Nick()
        if client:GetPos():DistToSqr(ply:GetPos()) > 250000 then return end

        cam.Start3D2D(pos, ang, 0.05)
            draw.SimpleTextOutlined(
                name,
                "RFFBig",
                0,
                0,
                Color(255,255,255),
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER,
                2,
                Color(0,0,0)
            )
        cam.End3D2D()
end)