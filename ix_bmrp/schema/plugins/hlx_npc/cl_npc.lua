surface.CreateFont( "CloseCaption_Normal:50", {
  font = "CloseCaption_Normal",
  extended = false,
  size = 50,
  weight = 500,
  italic = false,
} )
surface.CreateFont( "ixMenuButtonBigLabelFont", {
  font = "DebugFixed",
  extended = false,
  size = 30,
  weight = 500,
  italic = true,
} )
surface.CreateFont( "NPCchatfontnormal", {
  font = "CenterPrintText",
  extended = false,
  size = 20,
  weight = 500,
  italic = false,
} )

net.Receive("ix_npc_open", function() 
    NPC_UI(net.ReadString(),net.ReadInt(9),net.ReadString(),net.ReadTable(),net.ReadEntity())
end)

ix_npcui = false

net.Receive("ix_npc_close", function() 
    if IsValid(NpcMenu) then
        NpcMenu:AlphaTo(0, 0.2, 0, function()
            if IsValid(NpcMenu) then

                NpcMenu:Remove()
                ix_npcui = false
                timer.Stop("npc_smoothdesc")
                timer.Create("npc_force_close_focus", 0.75, 1, function() 
                    hook.Remove("CalcView", "npc_focus")
                end)

            end
        end)
    end
end)

function NPC_UI(name,dialogID,text,answers,ent)
    local Xsize = ScrW()
    local Ysize = ScrH()
    local SchemaColor = Color(255, 252, 84)

    local letter = 0
    local smoothtext = ""
    timer.Create("npc_smoothdesc", 0.0001, string.len(text)+1, function()
        smoothtext = string.sub(text, 0, letter)
        letter = letter + 1
        if string.GetChar(text, letter) == "" then
        else
            LocalPlayer():EmitSound("ui/buttonrollover.wav", 25)
        end
    end)


    if !IsValid(NpcMenu) then

        NpcMenu = vgui.Create("DFrame")
        NpcMenu:SetPos(0, 0)
        NpcMenu:SetSize(Xsize, Ysize)
        NpcMenu:SetTitle("")
        NpcMenu:MakePopup()
        NpcMenu:SetDraggable(false)
        NpcMenu:ShowCloseButton(false)
        NpcMenu:SetAlpha(0)
        NpcMenu:AlphaTo(255, 0.3, 0)

        function NpcMenu:Paint(w, h)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawLine(w * 0.6, h * 0.1, w * 0.6, h * 0.9)
            surface.DrawLine(w * 0.6, h * 0.2, w * 0.9, h * 0.2)
            draw.DrawText(name, "CloseCaption_Normal:50", w * 0.61, h * 0.125, Color(255, 255, 225, 255), TEXT_ALIGN_LEFT)
            draw.DrawText(smoothtext, "NPCchatfontnormal", w * 0.625, (h * (0.015) + h * 0.22), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
        end
    else

        for _, child in pairs(NpcMenu:GetChildren()) do
            if IsValid(child) and child.isAnswers then
                child:Remove()
            end
        end

        function NpcMenu:Paint(w, h)

            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawLine(w * 0.6, h * 0.1, w * 0.6, h * 0.9)
            surface.DrawLine(w * 0.6, h * 0.2, w * 0.9, h * 0.2)
                
            draw.DrawText(name, "CloseCaption_Normal:50", w * 0.61, h * 0.125, Color(255, 255, 225, 255), TEXT_ALIGN_LEFT)
            draw.DrawText(smoothtext, "NPCchatfontnormal", w * 0.625, (h * (0.015) + h * 0.22), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

        end

    end

    local buttonSlot = 0
    local buttonWidth = Xsize * 0.3
    local buttonHeight = Ysize * 0.05
    local startY = Ysize * 0.85

    for i,v in pairs(answers) do

        local button = vgui.Create("DButton", NpcMenu)
        button:SetText("")
        button:SetPos(Xsize * 0.6, startY-buttonHeight*buttonSlot)
        button:SetSize(buttonWidth, buttonHeight)
        button.hoverFrac = 0
        button.isAnswers = true
        button.DoClick = function()
            net.Start("ix_npc_callback")
            net.WriteEntity(ent)
            net.WriteInt(dialogID, 9)
            net.WriteInt(i, 4)
            net.SendToServer()
        end

        function button:OnCursorEntered()
            LocalPlayer():EmitSound("Helix.Rollover")
        end

        function button:Paint(w, h)
            local target = self:IsHovered() and 1 or 0
            self.hoverFrac = Lerp(FrameTime() * 10, self.hoverFrac, target)
            local alpha = Lerp(self.hoverFrac, 0, 200)
            surface.SetDrawColor(SchemaColor.r, SchemaColor.g, SchemaColor.b, alpha)
            surface.SetMaterial(Material("vgui/gradient-l.png"))
            surface.DrawTexturedRect(0, 0, w, h)
            draw.DrawText(v, "ixMenuButtonBigLabelFont", w / 2, h * 0.3, Color(255, 255, 225, 255), TEXT_ALIGN_CENTER)
        end
        buttonSlot=buttonSlot+1
    end

end
