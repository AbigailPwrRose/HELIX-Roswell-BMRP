local PLUGIN = PLUGIN

surface.CreateFont("BannerFont", { font = "Tahoma", size = 20, weight = 100, antialias = true, additive = false, outline = false, shadow = true })

surface.CreateFont("BannerFontBig", { font = "Tahoma", size = 35, weight = 100, antialias = true, additive = false, outline = false, shadow = true })
-- why did this copy weirdly?

local bannerActive = false
local bannerTitle = ""
local bannerSubtitle = ""

net.Receive("FancyHUD_SetTitle", function()
    bannerActive = true
    bannerTitle = net.ReadString()
end)

net.Receive("FancyHUD_SetSubtitle", function()
    bannerActive = true
    bannerSubtitle = net.ReadString()
end)

net.Receive("FancyHUD_Clear", function()
    bannerActive = false
    bannerTitle = ""
    bannerSubtitle = ""
end)

hook.Add("HUDPaint", "FancyHUD_BannerDraw", function()
    if !bannerActive then return end

    local w = ScrW()
    
    draw.RoundedBox(
        0,
        0,
        0,
        w,
        80,
        Color(150,100,30,200)
    )

    draw.SimpleText(
        bannerTitle,
        "BannerFontBig",
        w/2,
        15,
        Color(255,255,255),
        TEXT_ALIGN_CENTER
    )

    draw.SimpleText(
        bannerSubtitle,
        "BannerFont",
        w/2,
        50,
        Color(200,200,200),
        TEXT_ALIGN_CENTER
    )

end)