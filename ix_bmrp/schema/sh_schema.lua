
-- The shared init file. You'll want to fill out the info for your schema and include any other files that you need.

-- Schema info
Schema.name = "Site Roswell BMRP : AMS Update"
Schema.author = "White Rose!"
Schema.description = "TBD."
Schema.logo = "logos/black_mesa.png"

ix.util.Include("cl_schema.lua")
ix.util.Include("sv_schema.lua")

ix.util.Include("cl_hooks.lua")
ix.util.Include("sh_hooks.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("sh_lua_yet_more_lua.lua")
ix.util.Include("sh_scannersystem.lua")

ix.util.Include("meta/sh_character.lua")
ix.util.Include("meta/sh_player.lua")

function Schema:ShouldHideBars()
  return true
end

function Schema:CanPlayerUseCharacter(client, character)
    local banned = character:GetData("banned")
    if (banned) then
        if (isnumber(banned)) then
            if (banned < os.time()) then
                return
            end
            return false, "@charBannedTemp"
        end
        return false, "@charBanned"
    else
        return true
    end
end

ix.flag.Add("W", "Access to spawn restricted wiremod components", function(client, bGiven)
end)

ix.option.Add("showStats", ix.type.bool, true, {
    phrase = "Show HUD Card",
    description = "Wether or not to show the HUD stat card",
	category = "appearance",
})

ALWAYS_RAISED["weapon_xdecf_mug"] = true
ALWAYS_RAISED["weapon_xdecf_can"] = true
ALWAYS_RAISED["weapon_xdecf_pot"] = true
ALWAYS_RAISED["white_knuckle"] = true
ALWAYS_RAISED["sandbox_knuckle"] = true
ALWAYS_RAISED["iron_knuckle"] = true
ALWAYS_RAISED["grub_knuckle"] = true
ALWAYS_RAISED["weapon_lvsrepair"] = true
ALWAYS_RAISED["cameras_monitor"] = true
ALWAYS_RAISED["cameras_wrench"] = true
ALWAYS_RAISED["weapon_crapvidcam"] = true
ALWAYS_RAISED["weapon_extinguisher_infinite"] = true
-- Tab Half-Life
ALWAYS_RAISED["weapon_hl1_357"] = true
ALWAYS_RAISED["weapon_hl1_glock"] = true
ALWAYS_RAISED["weapon_hl1_crossbow"] = true
ALWAYS_RAISED["weapon_hl1_crowbar"] = true
ALWAYS_RAISED["weapon_hl1_egon"] = true
ALWAYS_RAISED["weapon_hl1_handgrenade"] = true
ALWAYS_RAISED["weapon_hl1_hornetgun"] = true
ALWAYS_RAISED["weapon_hl1_mp5"] = true
ALWAYS_RAISED["weapon_hl1_rpg"] = true
ALWAYS_RAISED["weapon_hl1_satchel"] = true
ALWAYS_RAISED["weapon_hl1_shotgun"] = true
ALWAYS_RAISED["weapon_hl1_snark"] = true
ALWAYS_RAISED["weapon_hl1_gauss"] = true
ALWAYS_RAISED["weapon_hl1_tripmine"] = true
ALWAYS_RAISED["weapon_alienslave"] = true
-- Tab Half-Life 2
ALWAYS_RAISED["weapon_357"] = true
ALWAYS_RAISED["weapon_ar2"] = true
ALWAYS_RAISED["weapon_bugbait"] = true
ALWAYS_RAISED["weapon_crossbow"] = true
ALWAYS_RAISED["weapon_crowbar"] = true
ALWAYS_RAISED["weapon_frag"] = true
ALWAYS_RAISED["weapon_physcannon"] = true
ALWAYS_RAISED["weapon_pistol"] = true
ALWAYS_RAISED["weapon_rpg"] = true
ALWAYS_RAISED["weapon_shotgun"] = true
ALWAYS_RAISED["weapon_slam"] = true
ALWAYS_RAISED["weapon_smg1"] = true
ALWAYS_RAISED["weapon_stunstick"] = true
-- Tab Half-Life Co-Op: Infected
ALWAYS_RAISED["weapon_hl1_ak47"] = true
ALWAYS_RAISED["weapon_hl1_doublebarrel"] = true
ALWAYS_RAISED["weapon_hl1_m16"] = true
ALWAYS_RAISED["weapon_hl1_m249"] = true
ALWAYS_RAISED["weapon_hl1_sniperrifle"] = true
ALWAYS_RAISED["weapon_hl1_healthkit"] = true
ALWAYS_RAISED["weapon_hl1_minigun"] = true
ALWAYS_RAISED["weapon_hl1_rocketlauncher"] = true
-- Tab Sven CoOp
ALWAYS_RAISED["tfa_svencoop_lmglegacy"] = true
ALWAYS_RAISED["tfa_svencoop_handgun"] = true
ALWAYS_RAISED["tfa_svencoop_revolver"] = true
ALWAYS_RAISED["tfa_svencoop_crowbar"] = true
ALWAYS_RAISED["tfa_svencoop_deagle"] = true
ALWAYS_RAISED["tfa_svencoop_m16"] = true
ALWAYS_RAISED["tfa_svencoop_lmg"] = true
ALWAYS_RAISED["tfa_svencoop_sniper"] = true
ALWAYS_RAISED["tfa_svencoop_mp5"] = true
ALWAYS_RAISED["tfa_svencoop_shotgun"] = true
ALWAYS_RAISED["tfa_svencoop_uzi"] = true
ALWAYS_RAISED["tfa_svencoop_minigun"] = true
-- Half-Life: Opposing Force
ALWAYS_RAISED["weapon_hlof_9mmar"] = true
ALWAYS_RAISED["weapon_hlof_9mmhandgun"] = true
ALWAYS_RAISED["weapon_hlof_barnacle"] = true
ALWAYS_RAISED["weapon_hlof_eagle"] = true
ALWAYS_RAISED["weapon_hlof_displacer"] = true
ALWAYS_RAISED["weapon_hlof_handgrenade"] = true
ALWAYS_RAISED["weapon_hlof_knife"] = true
ALWAYS_RAISED["weapon_hlof_m249"] = true
ALWAYS_RAISED["weapon_hlof_penguin"] = true
ALWAYS_RAISED["weapon_hlof_pipewrench"] = true
ALWAYS_RAISED["weapon_hlof_rpg"] = true
ALWAYS_RAISED["weapon_hlof_satchel"] = true
ALWAYS_RAISED["weapon_hlof_shockrifle"] = true
ALWAYS_RAISED["weapon_hlof_shotgun"] = true
ALWAYS_RAISED["weapon_hlof_sniperrifle"] = true
ALWAYS_RAISED["weapon_hlof_sporelauncher"] = true
-- Tab TFA Sven Co-Op Reimagined
ALWAYS_RAISED["tfa_svencoop_halflife_crossbow"] = true
ALWAYS_RAISED["tfa_svencoopreimagined_lmg"] = true
ALWAYS_RAISED["tfa_svencoop_halflife_rpg"] = true
ALWAYS_RAISED["tfa_svencoop_halflife_gauss"] = true
ALWAYS_RAISED["tfa_svencoopreimagined_minigun"] = true
ALWAYS_RAISED["tfa_svencoopreimagined_crowbar"] = true
ALWAYS_RAISED["tfa_svencoop_halflife_crowbar"] = true
ALWAYS_RAISED["tfa_svencoop_theyhunger_umbrella"] = true
ALWAYS_RAISED["tfa_svencoop_halflife_357"] = true
ALWAYS_RAISED["tfa_svencoop_theyhunger_revolver"] = true
ALWAYS_RAISED["tfa_svencoop_halflife_glock"] = true
ALWAYS_RAISED["tfa_svencoopreimagined_handgun"] = true
ALWAYS_RAISED["tfa_svencoop_theyhunger_1911"] = true
ALWAYS_RAISED["tfa_svencoopreimagined_revolver"] = true
ALWAYS_RAISED["tfa_svencoopreimagined_deagle"] = true
ALWAYS_RAISED["tfa_svencoopreimagined_uzi"] = true
ALWAYS_RAISED["tfa_svencoop_theyhunger_m16"] = true
ALWAYS_RAISED["tfa_svencoop_theyhunger_m14"] = true
ALWAYS_RAISED["tfa_svencoopreimagined_m16"] = true
ALWAYS_RAISED["tfa_svencoopreimagined_sniper"] = true
ALWAYS_RAISED["tfa_svencoop_halflife_shotgun"] = true
ALWAYS_RAISED["tfa_svencoopreimagined_shotgun"] = true
ALWAYS_RAISED["tfa_svencoop_theyhunger_dbarrel"] = true
ALWAYS_RAISED["tfa_svencoop_theyhunger_greasegun"] = true
ALWAYS_RAISED["tfa_svencoop_halflife_smg"] = true
ALWAYS_RAISED["tfa_svencoopreimagined_mp5"] = true
ALWAYS_RAISED["tfa_svencoop_theyhunger_tommygun"] = true
-- TFA Frontline Forces
ALWAYS_RAISED["tfa_flf_hk21"] = true
ALWAYS_RAISED["tfa_flf_ksp58"] = true
ALWAYS_RAISED["tfa_flf_beretta"] = true
ALWAYS_RAISED["tfa_flf_usp"] = true
ALWAYS_RAISED["tfa_flf_rs202m2"] = true
ALWAYS_RAISED["tfa_flf_spas12"] = true
ALWAYS_RAISED["tfa_flf_mac10"] = true
ALWAYS_RAISED["tfa_flf_mp5a2"] = true
ALWAYS_RAISED["tfa_flf_mp5sd"] = true
ALWAYS_RAISED["tfa_flf_ump45"] = true
ALWAYS_RAISED["tfa_flf_ak105"] = true
ALWAYS_RAISED["tfa_flf_ak5"] = true
ALWAYS_RAISED["tfa_flf_famas"] = true
ALWAYS_RAISED["tfa_flf_m4"] = true
ALWAYS_RAISED["tfa_flf_msg90"] = true
ALWAYS_RAISED["tfa_flf_sako"] = true
-- Other
ALWAYS_RAISED["weapon_simrepair"] = true
ALWAYS_RAISED["weapon_hl1_healthkit"] = true
ALWAYS_RAISED["clipboard"] = true
ALWAYS_RAISED["xenobio_stunstick"] = true
ALWAYS_RAISED["injector"] = true