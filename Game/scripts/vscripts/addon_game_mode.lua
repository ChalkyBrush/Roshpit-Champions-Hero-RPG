-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('gamemode')

function Precache( context )
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See GameMode:PostLoadPrecache() in gamemode.lua for more information
  ]]

  DebugPrint("[BAREBONES] Performing pre-load precache")

  -- Particles can be precached individually or by folder
  -- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
  PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
  PrecacheResource("particle_folder", "particles/test_particle", context)
  PrecacheResource("particle", "particles/units/heroes/hero_riki/astral_smoke.vpcf", context)

PrecacheUnitByNameSync("zap_assassin_clone", context)
  -- Models can also be precached by folder or individually
  -- PrecacheModel should generally used over PrecacheResource for individual models


  PrecacheResource("soundfile", "soundevents/game_sounds_custom.vsndevts", context)
  -- PrecacheResource("soundfile", "soundevents/soundscapes_dota.vsndevts", context)
  -- PrecacheResource("soundfile", "game_sounds_music.vsndevts", context)
  -- PrecacheResource("soundfile", "soundevents/game_sounds_music.vsndevts", context)
  PrecacheResource( "sound", "sounds/music/valve_dota_001/music/battle_02_end.vsnd", context)
  PrecacheResource( "soundfile", "sounds/music/valve_dota_001/music/battle_02_end.vsnd", context)

  PrecacheResource("model", "models/items/razor/razor_head_bindings/razor_head_bindings.vmdl", context)


  PrecacheResource("particle", "particles/status_fx/status_effect_brewmaster_thunder_clap.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap_debuff.vpcf", context)
  PrecacheResource("particle", "particles/items2_fx/necronomicon_archer_projectile.vpcf", context)

  PrecacheResource("particle", "particles/status_fx/status_effect_nightmare.vpcf", context)

  PrecacheResource("particle", "particles/items_fx/mithril_collect.vpcf", context)


  PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
  PrecacheResource("particle", "particles/econ/generic/generic_buff_1/generic_buff_1.vpcf", context)

  PrecacheResource("particle", "particles/econ/items/enigma/enigma_geodesic/enigma_base_attack_eidolon_geodesic.vpcf", context)

  -- PrecacheResource("model", "econ/items/dark_seer/imperialrelics_back/imperialrelics_back", context)

  PrecacheResource("model", "models/heroes/ancient_apparition/ancient_apparition.vmdl", context)
  
  
PrecacheUnitByNameSync("the_oracle", context) 
PrecacheUnitByNameSync("the_crusader", context)
PrecacheUnitByNameSync("the_glyph_enchanter", context)
PrecacheUnitByNameSync("the_curator", context)


-- PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_meepo.vsndevts", context)

 
PrecacheResource("particle", "particles/econ/items/techies/techies_arcana/techies_suicide_arcana.vpcf", context)
PrecacheResource("particle", "particles/units/heroes/hero_oracle/duskbringer_c_a_heal_heal_core.vpcf", context)
PrecacheResource("particle", "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_gold_lvl2.vpcf", context)

PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_techies.vsndevts", context)


-- PrecacheResource("particle", "particles/econ/items/natures_prophet/natures_prophet_weapon_verodicia.vpcf", context)

--itemDrops

PrecacheResource("particle", "particles/units/heroes/hero_silencer/silencer_last_word_status.vpcf", context)
PrecacheResource("particle", "particles/units/heroes/hero_silencer/itemdropmythical.vpcf", context)
PrecacheResource("particle", "particles/units/heroes/hero_silencer/itemdroprare.vpcf", context)
PrecacheResource("particle", "particles/units/heroes/hero_silencer/itemdropimmortal.vpcf", context)
PrecacheResource("particle", "particles/roshpit/items/arcana_beam.vpcf", context)
--forest boss
PrecacheResource("particle", "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf", context)
PrecacheResource("particle", "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_explosion.vpcf", context)
PrecacheResource("particle", "particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_calldown_explosion.vpcf", context)
PrecacheResource("particle", "particles/econ/items/shadow_fiend/sf_desolation/forest_boss_splitter.vpcf", context)
PrecacheResource("model", "models/creeps/neutral_creeps/n_creep_golem_a/neutral_creep_golem_a.vmdl", context)
PrecacheResource("particle", "particles/status_fx/status_effect_overpower.vpcf", context)
PrecacheResource("model", "models/props_teams/logo_dire_winter_medium.vmdl", context)
PrecacheResource("particle", "particles/econ/events/ti5/town_portal_start_lvl2_ti5.vpcf", context)
PrecacheResource("particle", "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo_debuff.vpcf", context)
PrecacheResource("model", "models/items/courier/vigilante_fox_red/vigilante_fox_red.vmdl", context)
-- PrecacheResource("model", "models/items/courier/bookwyrm/bookwyrm.vmdl", context)
PrecacheResource("particle", "particles/units/heroes/hero_dazzle/unit_teleport.vpcf", context)
PrecacheResource("particle", "particles/status_fx/status_effect_siren_song.vpcf" , context)
PrecacheResource("particle", "particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_sparkles_nexon_hero_cp_2014.vpcf" , context)
PrecacheResource("particle", "particles/roshpit/potions/damage.vpcf", context)
PrecacheResource("particle", "particles/roshpit/potions/vitality.vpcf", context)
PrecacheResource("particle", "particles/roshpit/potions/ability.vpcf", context)

PrecacheResource("particle", "particles/roshpit/solunia/eclipse_sparks.vpcf", context)
PrecacheResource("particle", "particles/econ/items/monkey_king/arcana/water/mk_spring_arcana_water_channel_powertrails.vpcf", context)
PrecacheResource("particle", "particles/roshpit/respawn_channel.vpcf", context)
PrecacheResource("particle", "particles/econ/items/centaur/centaur_ti6_gold/centaur_ti6_warstomp_gold.vpcf", context)
PrecacheResource("particle", "particles/units/heroes/hero_chaos_knight/chaos_knight_weapon_blur_critical.vpcf", context)
PrecacheResource("particle", "particles/roshpit/learn_glyph_recipe.vpcf", context)


PrecacheResource("model", "models/props_teams/banner_radiant.vmdl", context)
PrecacheResource("model", "models/props_winter/present.vmdl", context)


PrecacheResource("model", "models/gameplay/attrib_tome_int.vmdl", context)
PrecacheResource("model", "models/gameplay/attrib_tome_agi.vmdl", context)
PrecacheResource("model", "models/gameplay/attrib_tome_str.vmdl", context)


-- PrecacheResource("model", "models/items/courier/shroomy/shroomy.vmdl", context)
-- PrecacheResource("model", "models/items/courier/teron/teron.vmdl", context)
-- PrecacheResource("model", "models/items/courier/dokkaebi_nexon_courier/dokkaebi_nexon_courier.vmdl", context)
-- PrecacheResource("model", "models/items/courier/coco_the_courageous/coco_the_courageous.vmdl", context)
-- PrecacheResource("model", "models/items/courier/bearzky/bearzky.vmdl", context)
-- PrecacheResource("model", "models/items/courier/snowl/snowl.vmdl", context)
PrecacheResource("model", "models/items/courier/mei_nei_rabbit/mei_nei_rabbit.vmdl", context)
PrecacheResource("model", "models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl", context)
PrecacheResource("model", "models/courier/lockjaw/lockjaw.vmdl", context)
PrecacheResource("model", "models/items/courier/sltv_10_courier/sltv_10_courier.vmdl", context)
PrecacheResource("particle", "particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf", context)
PrecacheResource("model", "models/items/wards/esl_wardchest_four_armed_observer/esl_wardchest_four_armed_observer.vmdl", context)


PrecacheResource("particle", "particles/units/heroes/hero_treant/treant_livingarmor_regen.vpcf" , context)
PrecacheResource("model", "models/heroes/antimage/antimage_offhand_weapon.vmdl", context)
PrecacheResource("model",  "models/heroes/antimage/antimage_weapon.vmdl", context)
PrecacheResource("model",  "models/items/furion/treant/shroomling_treant/shroomling_treant.vmdl", context)

-- PrecacheResource("particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf", context)
-- PrecacheResource("particle", "particles/items/cannon/breath_of_ice.vpcf", context)
-- PrecacheResource("particle", "particles/items/cannon/breath_of_wind.vpcf", context)


PrecacheResource("particle", "particles/units/heroes/hero_phoenix/phoenix_fire_spirit_burn_fire.vpcf", context)
PrecacheResource("particle", "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf", context)

--TOWN PORTAL--
PrecacheResource("particle", "particles/econ/items/meepo/meepo_colossal_crystal_chorus/meepo_divining_rod_poof_end.vpcf", context)

 PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_chen.vsndevts", context)
 PrecacheResource("model", "models/props_gameplay/rune_arcane.vmdl", context)
 PrecacheResource("model", "models/props_gameplay/salve_red.vmdl", context)
 PrecacheResource("model", "models/props_gameplay/salve_blue.vmdl", context)
 PrecacheResource("model", "models/props_gameplay/salve.vmdl", context)
 PrecacheResource("model", "models/props_gameplay/red_box.vmdl", context)
 PrecacheResource("model", "models/props_gameplay/treasure_chest001.vmdl", context)
 



  -- Sounds can precached here like anything else
  PrecacheResource("soundfile", "soundevents/voscripts/game_sounds_vo_secretshop.vsndevts", context)


  -- Entire items can be precached by name
  -- Abilities can also be precached in this way despite the name
  -- PrecacheItemByNameSync("example_ability", context)
  -- PrecacheItemByNameSync("item_example_item", context)
  -- PrecacheItemByNameSync("item_potion_green", context)
  -- PrecacheItemByNameSync("item_potion_red", context)
  -- PrecacheItemByNameSync("item_potion_blue", context)

  -- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
  -- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
  -- PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
  -- PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
  -- PrecacheUnitByNameSync("forest_boss", context)
 
  PrecacheUnitByNameSync("snake_trap_ward", context) 
  PrecacheUnitByNameSync("andromeda", context) 
  PrecacheUnitByNameSync("prop_unit", context) 
  -- PrecacheResource("particle_folder", "particles/units/heroes/hero_elder_titan", context)

  PrecacheResource("model",  'models/heroes/phantom_assassin/phantom_assassin_shoulders.vmdl', context)
  PrecacheResource("model",  'models/heroes/phantom_assassin/phantom_assassin_daggers.vmdl', context)
  PrecacheResource("particle", "particles/units/heroes/hero_treant/treant_overgrowth_area_beam.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_chen/chen_teleport.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_slark/beacon_glow_ground.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_slark/beacon_glow_red_ground.vpcf", context)
  PrecacheResource("particle", "particles/customgames/capturepoints/cp_allied_wood.vpcf", context)
  PrecacheResource("particle", "particles/portals/green_portal.vpcf", context)
  PrecacheResource("particle", "particles/customgames/capturepoints/cp_desert_allied_metal.vpcf", context)
  PrecacheResource("particle", "particles/customgames/capturepoints/cp_earth_captured.vpcf", context)

  PrecacheResource("particle", "particles/econ/events/fall_major_2016/blink_dagger_start_fm06.vpcf", context)
  PrecacheResource("particle", "particles/econ/events/fall_major_2016/blink_dagger_end_fm06.vpcf", context)
  --ITEMS
  -- PrecacheResource("model", "models/items/gauntlet.vmdl", context)
  -- PrecacheResource("model", "models/props_gameplay/boots_of_speed.vmdl", context)
  -- PrecacheResource("model", "models/props_gameplay/gem01.vmdl", context)
  -- PrecacheResource("model", "models/items/helm.vmdl", context)
  -- PrecacheResource("model", "models/items/scrimtar.vmdl", context)
  -- PrecacheResource("model", "models/items/vest.vmdl", context)

  -- SpecialPrecache(context)
end

-- Create the game mode when we activate
function Activate()
  GameRules.GameMode = GameMode()
  GameRules.GameMode:InitGameMode()
end

function SpecialPrecache(context)
  print("performing pre-load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)

    PrecacheItemsSYNC(context)

  -- if GameState:IsWorld1() then
  --   Timers:CreateTimer(8, function()
  --     Precache:townSiege()
  --   end)
  --   Timers:CreateTimer(10, function()
  --     Precache:graveYard()
  --   end)
  --   Timers:CreateTimer(20, function()
  --     Precache:loggingCamp()
  --   end)
  --   Timers:CreateTimer(30, function()
  --     Precache:grizzlyFalls()
  --   end)
  --   Timers:CreateTimer(70, function()
  --     Precache:sandTomb()
  --   end)
  --   Timers:CreateTimer(45, function()
  --     Precache:desertRuins()
  --   end)
  --   Timers:CreateTimer(120, function()
  --     Precache:vault()
  --   end)
  --   Timers:CreateTimer(160, function()
  --     Precache:swamp()
  --   end)
  --   Timers:CreateTimer(4, function()
  --     Precache:phoenixNest()
  --   end)
  --   Timers:CreateTimer(200, function()
  --     Precache:castle()
  --   end)
  -- end
  PrecacheMobGeneralSYNC(context)
  if GameState:IsTanariJungle() then
    tanariSYNC(context)
    champions_walkSYNC(context)
    boulderspine_cavernSYNC(context)
    wildwood_thicketSYNC(context)
    water_templeSYNC(context)
    fire_templeSYNC(context)
    tanari_craterSYNC(context)
  end
  if GameState:IsRPCArena() then
    arenaSYNC(context)
    champions_leagueSYNC(context)
    pit_of_trialsSYNC(context)
  end
  if GameState:IsRedfallRidge() then
    redfallSYNC(context)
    autumnmist_cavernSYNC(context)
    redfall_farmlandsSYNC(context)
    abandoned_shipyardSYNC(context)
  end
end

function PrecacheMobGeneralSYNC(context)
  local unitTable = {"dark_fighter", "icy_venge", "sorc_water_elemental", "time_walker", "rabid_walker", "npc_dota_creature_basic_zombie_exploding", "gargoyle", "hook_flinger", "human_rifleman", "blood_jumper", "mekanoid_disruptor", "epoch_summon", "furion_brute", "freeze_fiend", "the_butcher", "forest_broodmother", "spiderling", "spiderling2", "rare_ghost", "rolling_earth_spirit", "little_meepo", "furion_mystic", "twitch_lone_druid"}
  for i = 1, #unitTable, 1 do
      print("precaching: "..unitTable[i])
      PrecacheUnitByNameSync(unitTable[i], context)   
  end
end

function PrecacheItemsSYNC(context)
local itemTable = {"item_reanimation_stone", "item_rpc_nightmare_rider_mantle", "item_rpc_redrock_footwear", "item_rpc_arcanys_slipper", "item_rpc_pathfinders_resonant_boots", "item_rpc_neptunes_water_gliders", "item_rpc_enchanted_solar_cape", "item_rpc_ruinfall_skull_token", "item_rpc_omega_ruby", "item_rpc_blue_dragon_greaves", "item_rpc_stormcloth_bracer", "item_rpc_ocean_tempest_pallium", "item_rpc_brazen_kabuto_of_the_desert_realm", "item_rpc_radiant_ruins_leather", "item_rpc_windsteel_armor", "item_rpc_phoenix_emblem", "item_rpc_demon_mask", "item_rpc_crest_of_the_umbral_sentinel", "item_rpc_savage_plate_of_ogthun", "item_rpc_arcane_cascade_hat", "item_rpc_skyforge_flurry_plate", "item_rpc_aeriths_tear", "item_rpc_carbuncles_helm_of_reflection", "item_rpc_boots_of_old_wisdom", "item_rpc_guard_of_grithault", "item_rpc_fractional_enhancement_geode", "item_rpc_ring_of_nobility", "item_rpc_mordiggus_gauntlet", "item_rpc_twig_of_the_enlightened", "item_rpc_boots_of_pure_waters", "item_rpc_gloves_of_sweeping_wind", "item_rpc_depth_crest_armor", "item_rpc_tempest_falcon_ring", "item_rpc_crown_of_the_lava_forge", "item_rpc_water_mage_robes", "item_rpc_undertakers_hood", "item_rpc_hood_of_defiler", "item_rpc_stormcrack_helm", "item_rpc_antique_mana_relic", "item_rpc_ablecore_greaves", "item_rpc_basilisk_plague_helm", "item_rpc_giant_hunters_boots_of_resilience", "item_rpc_conquest_stone_falcon", "item_rpc_moon_tech_runners", "item_rpc_space_tech_vest", "item_rpc_rooted_feet", "item_rpc_wolfir_druids_spirit_helm", "item_rpc_autumn_sleeper_mask", "item_rpc_redfall_runners", "item_rpc_fenrirs_fang", "item_rpc_autumnrock_bracer", "item_rpc_guard_of_feronia", "item_rpc_helm_of_the_silent_templar", "item_rpc_skulldigger_gauntlet_lv1", "item_rpc_shipyard_veil_lv1", "item_rpc_crimsyth_elite_greaves_lv1"}
  for i = 1, #itemTable, 1 do
      print("precaching: "..itemTable[i])
      PrecacheItemByNameSync(itemTable[i], context)
  end
end

function tanariSYNC(context)
  local unitTable = {"tanari_witch_doctor", "tanari_ancient_hero"}
  for i = 1, #unitTable, 1 do
      print("precaching: "..unitTable[i])
      PrecacheUnitByNameSync(unitTable[i], context)   
  end

end

function champions_walkSYNC(context)
  local unitTable = {"easy_kobold", "tanari_shrine_growth", "tanari_water_troll", "grizzly_bridge_fish", "tanari_angry_fish", "tanari_ambusher", "tanari_tribal_ambusher", "tanari_kraken_king", "tanari_crag_lizard", "tanari_mountain_bully", "tanari_poison_flower", "tanari_mountain_pass_guardian", "tanari_river_slug", "tanari_mountain_trogg", "tanari_reclusive_mountain_nomad", "grizzly_cave_dweller", "grizzly_cave_dweller_leader", "tanari_mountain_specter", "tanari_island_hydra", "tanari_wind_temple_keyholder"}
  for i = 1, #unitTable, 1 do
      print("precaching: "..unitTable[i])
      PrecacheUnitByNameSync(unitTable[i], context)   
  end

end

function wildwood_thicketSYNC(context)
  local unitTable = {"tanari_thicket_ursa", "tanari_primitive_hunter", "tanari_headhunter", "tanari_thicket_priest", "tanari_thicket_high_priest", "blighted_sapling", "tanari_wild_troll", "tanari_thicket_bat",  "tanari_thicket_matriarch", "wind_temple_avian_warder", "wind_temple_wind_mage", "wind_temple_emerald_spider", "wind_temple_venom_spider", "wind_temple_gardener", "wind_temple_wind_maiden",  "wind_temple_descendant_of_zeus",  "wind_temple_keeper_of_green_wind", "wind_temple_keeper_of_blue_wind", "wind_temple_keeper_of_red_wind", "wind_temple_master_of_storms", "wind_temple_wind_high_priest", "wind_temple_boss_staff", "wind_temple_boss"}
  for i = 1, #unitTable, 1 do
      print("precaching: "..unitTable[i])
      PrecacheUnitByNameSync(unitTable[i], context)    
  end
end

function boulderspine_cavernSYNC(context)
  local unitTable = {"gazbin_explosives_expert_friendly", "boulderspine_cavern_monster", "cave_stalker", "blood_fiend", "depth_demon", "boulderspine_dimension_warper", "boulderspine_dimension_jumper", "boulderspine_freeze_fiend", "boulderspine_terror", "boulderspine_baron_razor", "boulderspine_armored_cave_rat", "boulderspine_obsidian_cave_beast", "boulderspine_cave_lizard_brute", "boulderspine_mud_golem", "boulderspine_viper_blue", "chained_butcher", "boulderspine_pyro", "boulderspine_firebat", "boulderspine_princess", "boulderspine_lindworm_frost", "boulderspine_slithereen_guard", "boulderspine_slithereen_featherguard", "boulderspine_slithereen_royal_guard", "water_temple_keyholder"}
  for i = 1, #unitTable, 1 do
      print("precaching: "..unitTable[i])
      PrecacheUnitByNameSync(unitTable[i], context)    
  end
end

function tanari_craterSYNC(context)
  local unitTable = {"terrasic_lava_beast", "terrasic_volcanic_legion", "terrasic_flame_orchid", "terrasic_awakened_stone", "terrasic_boulderspine",  "terrasic_red_mist_soldier", "terrasic_doomguard", "terrasic_goremaw_flame_splitter", "terrasic_volcano_beetle", "volcanic_pharoah", "terrasic_black_drake", "terrasic_red_guard", "terrasic_captain_reimus", "molten_entity", "volcanic_ash", "terrasic_red_warlock", "terrasic_red_mist_conqueror", "terrasic_red_mist_brute", "terrasic_captain_clayborne", "terrasic_lava_summoner", "terrasic_warlock_summon", "terrasic_fire_key_holder"}
  for i = 1, #unitTable, 1 do
      print("precaching: "..unitTable[i])
      PrecacheUnitByNameSync(unitTable[i], context)     
  end
end

function water_templeSYNC(context)
  local unitTable = {"tanari_water_bug", "swamp_razorfish", "swamp_razorfish_captain", "swamp_razorfish_irritable", "tanari_ancient", "water_temple_vault_lord", "water_temple_shark", "water_temple_aqua_mage", "water_temple_beach_hermit", "water_temple_prison_guard", "water_temple_executioner", "water_temple_jailer", "water_temple_fish_prisoner", "water_temple_faceless_water_elemental", "water_temple_blue_warlock", "water_temple_emperor_elemental", "water_temple_vault_master", "water_temple_serpent_sleeper", "water_temple_armored_water_beetle", "water_temple_blinded_serpent_warrior", "water_temple_fairy_dragon", "water_temple_boss"}
  for i = 1, #unitTable, 1 do
      print("precaching: "..unitTable[i])
      PrecacheUnitByNameSync(unitTable[i], context)    
  end
end

function fire_templeSYNC(context)
  local unitTable = {"fire_temple_blackguard", "blackguard_cultist", "fire_temple_blackguard_doombringer",  "fire_temple_burning_prisoner", "fire_temple_molten_war_knight", "fire_temple_lost_shadow_of_davion", "fire_temple_passage_skeleton", "fire_temple_relic_seeker", "fire_temple_secret_fanatic", "disciple_of_yojimbo", "yojimbo_boss", "fire_temple_tempered_warrior", "fire_temple_mad_rito", "fire_temple_sky_guardian", "fire_temple_dimension_seeker", "fire_temple_fireling", "fire_temple_skeleton_archer", "fire_temple_lumos_ascender", "fire_temple_seer_of_solos", "fire_temple_final_wave_mob", "fire_temple_fire_mage", "fire_temple_lava_caller", "fire_temple_protective_spirit", "fire_temple_flame_wraith", "fire_temple_flame_wraith_lord", "flame_worshipper_kolthun", "fire_temple_neverlord_reborn", "tanari_ancient_hero"}
  for i = 1, #unitTable, 1 do

      print("precaching: "..unitTable[i])
      PrecacheUnitByNameSync(unitTable[i], context)    
  end
end

--ARENA--
function arenaSYNC(context)
  local unitTable = {"arena_show_combatant", "arena_attendee_one", "arena_entrance_fan", "arena_guard", "champions_league_attendant", "challenger_attendant", "arena_crowd_fan", "arena_show_fighter_one", "arena_show_fighter_two", "arena_hall_of_heroes_npc", "pvp_attendant", "arena_aquatarium_magician", "arena_game_elemental"}
  for i = 1, #unitTable, 1 do
      print("precaching: "..unitTable[i])
      PrecacheUnitByNameSync(unitTable[i], context)   
  end
end

function champions_leagueSYNC(context)
  local unitTable = {"champion_league_challenger_20", "champion_league_challenger_19", "champion_league_challenger_18", "champion_league_challenger_17", "arena_league_challenger_17_fire", "arena_league_challenger_17_earth", "arena_league_challenger_17_air",  "champion_league_challenger_16", "champion_league_challenger_15", "champion_league_challenger_14", "champion_league_challenger_13", "champion_league_challenger_13_a", "champion_league_challenger_13_b", "champion_league_challenger_13_c", "champion_league_challenger_12", "champion_league_challenger_11", "champion_league_challenger_10", "castle_skeleton_mage", "castle_skeleton_archer", "castle_ghost", "castle_skeleton_warrior", "champion_league_challenger_9", "champion_league_challenger_8", "champion_league_challenger_7", "champion_league_challenger_6", "arena_nightmare_spectre", "arena_nightmare_guard", "arena_nightmare_cerberus",  "arena_nightmare_zombie", "arena_nightmare_ghastly_airwarden", "arena_nightmare_fiend", "animated_arms", "arena_nightmare_boss", "champion_league_challenger_5", "champion_league_challenger_4", "champion_league_challenger_3_a", "champion_league_challenger_3_b", "champion_league_challenger_2", "champion_league_challenger_1"}
  for i = 1, #unitTable, 1 do
      print("precaching: "..unitTable[i])
      PrecacheUnitByNameSync(unitTable[i], context)    
  end
end

function pit_of_trialsSYNC(context)
  local unitTable = {"arena_pit_of_trials_final_boss", "arena_boss_spectre_summon", "arena_pit_pit_guardian", "master_duelist", "champion_gladiator", "pit_crawler", "arena_pit_quizmaster", "arena_pit_soul_revenant", "arena_pit_shadow_sniper", "arena_pit_conquest_mire_keeper", "arena_pit_conquest_mountain_behemoth", "arena_pit_conquest_root_overgrowth", "arena_pit_conquest_cragnataur", "arena_pit_conquest_mountain_spider", "arena_pit_conquest_spider", "arena_pit_conquest_priest_of_karzhun", "arena_pit_conquest_helob", "arena_conquest_ruins_guardian", "arena_conquest_gift_of_kharzun", "arena_pit_conquest_temple_explorer", "arena_pit_conquest_temple_shaman", "arena_pit_temple_guardian_snakes", "arena_conquest_temple_witch_doctor", "arena_conquest_temple_repeller", "arena_conquest_temple_hunter", "arena_conquest_skeletal_mage", "arena_conquest_temple_shifter", "pit_conquest_dragon", "arena_pit_conquest_mire_boss", "terrasic_goremaw_flame_splitter", "pit_conquest_forest_soldier", "pit_conquest_woods_titan", "pit_conquest_forest_mage", "arena_lies_castle_light_absorber", "pit_conquest_lord_of_bovel", "arena_lies_spark_beetle", "arena_lies_lich",  "arena_lies_doombringer", "arena_lies_samurai", "arena_lies_arbiter_of_truth", "lies_treasure_hoarder", "lies_golden_skullbone", "arena_lies_shadow_beast", "lies_trickster_mage", "tanari_angry_fish", "arena_lies_castle_enigma", "arena_lies_razor_miniboss", "arena_lies_boss", "arena_descent_exiled_spirit", "arena_descent_exiled_spirit_big", "arena_descent_passage_keeper", "arena_descent_grieving_widow", "arena_descent_horror_construct", "arena_descent_death_seeker", "arena_descent_zombie", "arena_descent_tombstone", "arena_descent_terror_striker", "arena_descent_gargoyle", "arena_descent_goo_beetle", "arena_descent_zombie_critter", "arena_descent_razor_guard", "arena_descent_doombringer", "arena_descent_boss", "pit_conquest_boss", "arena_pit_conquest_spirit_of_rakash"}
  for i = 1, #unitTable, 1 do
      print("precaching: "..unitTable[i])
      PrecacheUnitByNameSync(unitTable[i], context)  
  end
end

--REDFALL--

function redfallSYNC(context)
  local unitTable = {"redfall_first_unit", "redfall_shroomling", "redfall_autumn_gazer", "redfall_autumn_spawner", "redfall_autumn_flower", "redfall_forest_summoner", "redfall_crimsyth_cultist", "redfall_forest_minion", "redfall_aqua_lily", "redfall_forest_wood_dweller", "redfall_forest_overgrowth", "redfall_disciple_of_maru", "redfall_autumn_spirit", "redfall_forest_gnome", "redfall_cliff_weed", "redfall_otaru", "redfall_cliff_invader_range", "redfall_cliff_invader", "redfall_forest_ranger", "redfall_stone_watcher", "redfall_red_raven", "redfall_hooded_soul_reacher", "redfall_ash_snake", "redfall_ashfall_knight", "redfall_redfall_vulture", "redfall_autumn_cragnataur", "redfall_crimsyth_cultist_boss", "redfall_ashen_treant", "redfall_fenrir"}
  for i = 1, #unitTable, 1 do
      print("precaching: "..unitTable[i])
      PrecacheUnitByNameSync(unitTable[i], context)    
  end

end

function autumnmist_cavernSYNC(context)
  local unitTable = {"redfall_autumn_enforcer", "redfall_autumn_tyrant", "redfall_pan_knight", "redfall_canyon_alpha_beast", "redfall_canyon_breaker", "redfall_canyon_predator", "redfall_armored_crab_beast", "redfall_canyon_bull", "redfall_canyon_dinosaur", "redfall_lzard_guide", "redfall_canyon_grizzly_patriarch", "redfall_canyon_barbarian", "redfall_mist_knight", "redfall_autumn_mage", "redfall_troll_warlord", "redfall_mist_assassin", "redfall_autumn_mage_boss", "redfall_canyon_boss", "redfall_canyon_boss_miniature", "redfall_spirit_of_ashara", "redfall_ashara", "redfall_canyon_feronia"}
  for i = 1, #unitTable, 1 do
      print("precaching: "..unitTable[i])
      PrecacheUnitByNameSync(unitTable[i], context)    
  end

end

function redfall_farmlandsSYNC(context)
  local unitTable = {"redfall_farmlands_bandit", "redfall_farmland_spawner", "redfall_pumpkin_flower", "redfall_farmlands_thief", "redfall_harvest_wraith", "redfall_farmlands_flame_panda", "redfall_farmlands_corn_harvester", "redfall_twisted_pumpkin", "redfall_chibi_bear", "redfall_crymsith_duelist", "redfall_crimsyth_bandit", "redfall_farmlands_crymsith_taskmaster", "redfall_meepo_farmer", "redfall_crimsyth_recruiter", "redfall_demon_farmer"}
  for i = 1, #unitTable, 1 do
      print("precaching: "..unitTable[i])
      PrecacheUnitByNameSync(unitTable[i], context)     
  end

end

function abandoned_shipyardSYNC(context)
  local unitTable = {"redfall_shipyard_crimsyth_blood_hunter", "redfall_shipyard_demon_wolf", "redfall_shipyard_blood_wolf", "shipyard_skeleton_archer", "shipyard_skeleton_archer_boss",  "redfall_shipyard_void", "redfall_shipyard_conductor", "water_temple_armored_water_beetle", "redfall_shipyard_haunt_knight", "redfall_shipyard_gatekeeper", "shipyard_ghost_fish", "shipyard_pirate_archer", "redfall_shipyard_cargo_watcher", "redfall_shipyard_spawner_boss", "redfall_shipyard_pirate_gnoll", "redfall_shipyard_soul_collector", "shipyard_armored_bear_guard", "redfall_shipyard_crimsyth_knight", "redfall_shipyard_boss",  "redfall_farmlands_friendly_harvester"}
  for i = 1, #unitTable, 1 do
      print("precaching: "..unitTable[i])
      PrecacheUnitByNameSync(unitTable[i], context)   
  end

end