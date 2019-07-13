if Precache == nil then
	Precache = class({})
end

function Precache:redirect(waveNumber)
	if waveNumber == 8 then
		Precache:butcher()
	elseif waveNumber == 4 then
		Precache:section2()
	elseif waveNumber == 12 then
		Precache:section3()
	elseif waveNumber == 16 then
		Precache:act2()
	end
end

function Precache:butcher()
	PrecacheUnitByNameAsync("the_butcher", function(...) end)
end

function Precache:section2()
	PrecacheUnitByNameAsync("freeze_fiend", function(...) end)
	PrecacheUnitByNameAsync("forest_broodmother", function(...) end)
	PrecacheUnitByNameAsync("spiderling", function(...) end)
	PrecacheUnitByNameAsync("spiderling2", function(...) end)
end

function Precache:section3()
	--print("precacheing yo")
	local unitTable = {"rolling_earth_spirit", "little_meepo", "furion_mystic", "twitch_lone_druid", "exploding_warrior"}
	for i = 1, #unitTable, 1 do
		Timers:CreateTimer(i * 0.3, function()
			PrecacheUnitByNameAsync(unitTable[i], function(...) end)
		end)
	end
end

function Precache:items()
	local itemTable = {"item_rpc_ice_quill_carapace",
		"item_rpc_epsilons_eyeglass",
		"item_rpc_monkey_paw",
		"item_rpc_guard_of_luma",
		"item_rpc_frostburn_gauntlets",
		"item_rpc_seraphic_soulvest",
		"item_rpc_centaur_horns",
		"item_rpc_featherwhite_armor",
		"item_rpc_gem_of_eternal_frost",
		"item_rpc_gilded_soul_cage",
		"item_rpc_scorched_gauntlets",
		"item_rpc_living_gauntlet",
		"item_rpc_hyper_visor",
		"item_reanimation_stone",
		"item_rpc_super_ascendency_mask",
		"item_rpc_nightmare_rider_mantle",
		"item_rpc_redrock_footwear",
		"item_rpc_arcanys_slipper",
		"item_rpc_pathfinders_resonant_boots",
		"item_rpc_neptunes_water_gliders",
		"item_rpc_enchanted_solar_cape",
		"item_rpc_ruinfall_skull_token",
		"item_rpc_omega_ruby",
		"item_rpc_blue_dragon_greaves",
		"item_rpc_stormcloth_bracer",
		"item_rpc_ocean_tempest_pallium",
		"item_rpc_brazen_kabuto_of_the_desert_realm",
		"item_rpc_radiant_ruins_leather",
		"item_rpc_windsteel_armor",
		"item_rpc_phoenix_emblem",
		"item_rpc_demon_mask",
		"item_rpc_crest_of_the_umbral_sentinel",
		"item_rpc_savage_plate_of_ogthun",
		"item_rpc_arcane_cascade_hat",
		"item_rpc_skyforge_flurry_plate",
		"item_rpc_aeriths_tear",
		"item_rpc_carbuncles_helm_of_reflection",
		"item_rpc_boots_of_old_wisdom",
		"item_rpc_guard_of_grithault",
		"item_rpc_fractional_enhancement_geode",
		"item_rpc_ring_of_nobility",
		"item_rpc_mordiggus_gauntlet",
		"item_rpc_twig_of_the_enlightened",
		"item_rpc_barons_storm_armor",
		"item_rpc_boots_of_pure_waters",
		"item_rpc_gloves_of_sweeping_wind",
		"item_rpc_depth_crest_armor",
		"item_rpc_tempest_falcon_ring",
		"item_rpc_crown_of_the_lava_forge",
		"item_rpc_water_mage_robes",
		"item_rpc_undertakers_hood",
		"item_rpc_hood_of_defiler",
		"item_rpc_stormcrack_helm",
		"item_rpc_antique_mana_relic",
		"item_rpc_ablecore_greaves",
		"item_rpc_basilisk_plague_helm",
		"item_rpc_temporal_warp_boots",
		"item_rpc_giant_hunters_boots_of_resilience",
		"item_rpc_conquest_stone_falcon",
		"item_rpc_moon_tech_runners",
		"item_rpc_space_tech_vest",
		"item_rpc_rooted_feet",
		"item_rpc_wolfir_druids_spirit_helm",
		"item_rpc_autumn_sleeper_mask",
		"item_rpc_redfall_runners",
		"item_rpc_fenrirs_fang",
		"item_rpc_autumnrock_bracer",
		"item_rpc_guard_of_feronia",
		"item_rpc_helm_of_the_silent_templar",
		"item_rpc_white_mage_hat",
		"item_rpc_skulldigger_gauntlet_lv1",
		"item_rpc_shipyard_veil_lv1",
		"item_rpc_crimsyth_elite_greaves_lv1",
		"item_rpc_doomplate",
		"item_rpc_claws_of_the_ethereal_revenant",
		"item_rpc_crimson_skull_cap",
		"item_rpc_igneous_canine_helm",
		"item_rpc_azure_empire",
		"item_rpc_hurricane_vest",
		"item_rpc_falcon_boots",
		"item_rpc_avalanche_plate",
		"item_rpc_odin_helmet",
		"item_rpc_ankh_of_the_ancients",
		"item_rpc_alaranas_ice_boot",
		"item_rpc_ancient_tanari_wind_armor",
		"item_rpc_blue_rain_gauntlet",
		"item_rpc_aquasteel_bracers",
		"item_rpc_demonfire_gauntlet",
	"item_rpc_outland_stone_cuirass"}

	local i = 1
	local function precache_function()
		--print("done precaching: "..itemTable[i])
		i = i + 1
		if i > #itemTable then
			--print("done precaching items")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {items = 1})
				return 2
			end)
		else
			--print("precaching "..itemTable[i])
			local pct = math.floor(i / #itemTable * 100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {items = 1, pct = tostring(pct)})
			PrecacheItemByNameAsync(itemTable[i], precache_function)
		end
	end
	--print("precaching "..itemTable[i])
	PrecacheItemByNameAsync(itemTable[i], precache_function)
end

function Precache:act2()
	local unitTable = {"rockjaw", "wastelands_archer", "desert_ghost", "bone_horror", "wandering_mage", "satyr_doctor", "hammersaur", "alpha_wolf", "general_wolfenstein", "wolf_ally", "mountain_destroyer", "desert_warlord", "blood_fiend", "dune_crasher"}
	for i = 1, #unitTable, 1 do
		Timers:CreateTimer(i * 2, function()
			PrecacheUnitByNameAsync(unitTable[i], function(...) end)
		end)
	end
end

function Precache:townSiege()
	local unitTable = {"town_footman", "town_archer", "garrison_commander", "basic_siege_unit", "chaos_chieftain", "leaping_lion", "siege_catapult", "siege_dragon", "siege_hulker"}
	for i = 1, #unitTable, 1 do
		Timers:CreateTimer(i * 0.3, function()
			--print("precaching "..unitTable[i])
			PrecacheUnitByNameAsync(unitTable[i], function(...) end)
		end)
	end
end

function Precache:graveYard()
	local unitTable = {"arcane_crystal", "basic_skeleton", "skeleton_archer", "zombie_warrior", "raider", "zombie_raider", "graveyard_boss"}
	for i = 1, #unitTable, 1 do
		Timers:CreateTimer(i * 0.3, function()
			--print("precaching "..unitTable[i])
			PrecacheUnitByNameAsync(unitTable[i], function(...) end)
		end)
	end
end

function Precache:loggingCamp()
	local unitTable = {"conjured_tide", "forest_sprite", "infected_treant", "gazbin_alchemist", "mutated_treant", "gazbin_guard", "gazbin_brute", "gazbin_peon", "gazbin_berserker", "gazbin_recruit", "gazbin_explosives_expert", "shredder_max", "gazbin_mercenary", "reinforcement_zeppelin", "gazbin_mercenary_ranged", "sludge_golem", "lumber_mill_treant", "lumber_mill_boss", "mill_warrior_tree"}
	for i = 1, #unitTable, 1 do
		Timers:CreateTimer(i * 1.7, function()
			--print("precaching "..unitTable[i])
			PrecacheUnitByNameAsync(unitTable[i], function(...) end)
		end)
	end
end

function Precache:grizzlyFalls()
	local unitTable = {"river_beast", "grizzled_woodsman", "grizzly_twilight_worshipper", "twilight_crow_cultist", "twilight_crow_summon", "grizzly_ally_healer", "grizzly_ally_tank", "grizzly_bridge_fish", "grizzly_twilight_guardian", "grizzly_falls_boss", "grizzly_sleepy_ogre", "grizzly_cave_dweller", "grizzly_cave_dweller_leader", "grizzly_awakened_stone", "grizzly_awakened_stone_leader", "grizzly_ancient_crag_golem", "grizzly_granite_apparition", "grizzly_water_hydra", "grizzly_cave_shroomling", "grizzly_medusa_acolyte"}
	for i = 1, #unitTable, 1 do
		Timers:CreateTimer(i * 1.5, function()
			--print("precaching "..unitTable[i])
			PrecacheUnitByNameAsync(unitTable[i], function(...) end)
		end)
	end
end

function Precache:sandTomb()
	local unitTable = {"tomb_remnant", "ancient_ghost", "tomb_defender", "raging_flame", "crow_eater", "soul_sucker", "spine_hermit", "tomb_stalker", "vision_warden", "sand_tomb_boss"}
	for i = 1, #unitTable, 1 do
		Timers:CreateTimer(i * 1.6, function()
			--print("precaching "..unitTable[i])
			PrecacheUnitByNameAsync(unitTable[i], function(...) end)
		end)
	end
end

function Precache:desertRuins()
	local unitTable = {"feathered_hunter", "desert_outrunner", "nomadic_hunter", "blood_worshipper", "wandering_mage_ruins", "desert_ruins_necromancer", "enslaved_corpse", "thorok_reborn", "grave_watcher", "ruins_solarium_void", "ruins_solarium_enigma", "ruins_king_rozan", "fungal_overlord", "blighted_sapling", "ruins_golden_skullbone", "ruins_venomous_burrower", "ruins_blood_arcanist", "ruins_key_holder", "well_of_sacrifice_ghost", "ruins_boss", "ancient_ruby_giant"}
	for i = 1, #unitTable, 1 do
		Timers:CreateTimer(i * 1.5, function()
			--print("precaching "..unitTable[i])
			PrecacheUnitByNameAsync(unitTable[i], function(...) end)
		end)
	end
end

function Precache:vault()
	local unitTable = {"dynasty_heir_majinaq", "vault_guard", "vault_assassin", "vault_antimage", "vault_pleb", "vault_invisible_keyholder", "vault_executioner", "vault_henchman", "vault_treasurer", "vault_worshipper", "unreal_terror", "vault_arcanist", "vault_statue_one", "vault_statue_two", "vault_statue_three", "vault_statue_four", "vault_statue_five", "vault_statue_six"}
	for i = 1, #unitTable, 1 do
		Timers:CreateTimer(i * 1.8, function()
			--print("precaching "..unitTable[i])
			PrecacheUnitByNameAsync(unitTable[i], function(...) end)
		end)
	end
end

function Precache:swamp()
	local unitTable = {"swamp_viper", "swamp_razorfish", "swamp_razorfish_captain", "swamp_tribal_cultist", "the_bog_monster", "swamp_razorfish_irritable", "swamp_tribal_invoker", "swamp_grove_bear", "swamp_grove_tender", "swamp_grove_ancestral_bear", "swamp_boss"}
	for i = 1, #unitTable, 1 do
		Timers:CreateTimer(i * 2.0, function()
			--print("precaching "..unitTable[i])
			PrecacheUnitByNameAsync(unitTable[i], function(...) end)
		end)
	end
end

function Precache:castle()
	local unitTable = {"wraithguard", "haunted_tree", "mad_pumpkin", "groundskeeper", "wraithguard_elite", "animated_arms", "castle_ghost", "castle_skeleton_archer", "castle_chef", "burning_spider", "courtyard_summoner", "castle_skeleton_mage", "castle_undertaker", "summoner_true_form", "castle_boss_intro", "castle_boss"}
	for i = 1, #unitTable, 1 do
		Timers:CreateTimer(i * 2.2, function()
			--print("precaching "..unitTable[i])
			PrecacheUnitByNameAsync(unitTable[i], function(...) end)
		end)
	end
end

function Precache:phoenixNest()
	local unitTable = {"phoenix_nest_protector", "phoenix_boss", "invader_kriggus", "follower_of_kriggus", "portal_invader", "iron_spine", "feral_bloodseeker", "phoenix_marshall", "phoenix_assassin", "bat_summon", "phoenix_siege_bat", "phoenix_siege_lich", "phoenix_siege_lich_boss", "phoenix_hunter", "phoenix_electron_raider", "phoenix_hatched", "phoenix_subboss_a", "phoenix_subboss_b", "phoenix_subboss_c", "phoenix_subboss_d"}
	for i = 1, #unitTable, 1 do
		Timers:CreateTimer(i * 2.0, function()
			--print("precaching "..unitTable[i])
			PrecacheUnitByNameAsync(unitTable[i], function(...) end)
		end)
	end
end

--TANARI--

function Precache:tanari()
	local unitTable = {"tanari_witch_doctor", "tanari_ancient_hero", "tanari_hero_remnant", "arena_training_dummy"}
	local i = 1
	local function precache_function()
		--print("done precaching: "..unitTable[i])
		i = i + 1
		if i > #unitTable then
			--print("done precaching units")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
				return 2
			end)
		else
			--print("precaching "..unitTable[i])
			local pct = math.floor(i / #unitTable * 100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
			PrecacheUnitByNameAsync(unitTable[i], precache_function)
		end
	end
	--print("precaching "..unitTable[i])
	PrecacheUnitByNameAsync(unitTable[i], precache_function)

end

function Precache:tanariExpansion()
	local unitTable = {"tanari_clam_spawner", "tanari_clam_fish", "tanari_voodoo_shaman", "tanari_alchemist", "grizzled_woodsman", "thicket_watcher", "tanari_mountain_specter_crow_form", "tanari_ancient_wind_spirit", "tanari_wind_bear", "tanari_jade_water_elemental", "tanari_wind_temple_lizard", "tanari_wind_temple_viper", "tanari_wind_crusher", "tanari_wind_sprite", "tanari_wind_spark", "tanari_wind_crystal_tree", "tanari_wind_demon", "tanari_wind_apparation", "wind_valley_guardian", "wind_temple_spirit_boss", "water_temple_spirit_jailer", "caged_water_wraith", "water_temple_vault_king", "water_shadow_hunter", "slithereen_prison_guard", "water_temple_meta_prisoner", "water_manifestation", "water_temple_duke_korlazeen", "water_temple_stone_priestess", "water_temple_stone_fish", "tanari_drowned_sorrow", "water_archer_spirit", "water_temple_aqualeen_defector", "ice_queen_alarana", "slithereen_elite_warrior", "tanari_water_spirit_boss", "tanari_ancient_fire_spirit", "fire_temple_flame_shaman", "tanari_fire_temple_spawner", "tanari_lava_spectre", "flamerider_gorthos", "tanari_flame_beast", "fire_temple_ogre", "tanari_inferno_demon", "tanari_lava_bully", "tanari_lava_bully_big", "tanari_fire_crab_beast", "fire_temple_siege_hulker", "tanari_fire_spirit_boss"}
	local i = 1
	local function precache_function()
		--print("done precaching: "..unitTable[i])
		i = i + 1
		if i > #unitTable then
			--print("done precaching units")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
				return 2
			end)
		else
			--print("precaching "..unitTable[i])
			local pct = math.floor(i / #unitTable * 100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
			PrecacheUnitByNameAsync(unitTable[i], precache_function)
		end
	end
	--print("precaching "..unitTable[i])
	PrecacheUnitByNameAsync(unitTable[i], precache_function)
end

function Precache:champions_walk()
	local unitTable = {"easy_kobold", "tanari_shrine_growth", "tanari_water_troll", "grizzly_bridge_fish", "tanari_angry_fish", "tanari_ambusher", "tanari_tribal_ambusher", "tanari_kraken_king", "tanari_crag_lizard", "tanari_mountain_bully", "tanari_poison_flower", "tanari_mountain_pass_guardian", "tanari_river_slug", "tanari_mountain_trogg", "tanari_reclusive_mountain_nomad", "grizzly_cave_dweller", "grizzly_cave_dweller_leader", "tanari_mountain_specter", "tanari_island_hydra", "tanari_wind_temple_keyholder"}
	local i = 1
	local function precache_function()
		--print("done precaching: "..unitTable[i])
		i = i + 1
		if i > #unitTable then
			--print("done precaching units")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
				return 2
			end)
		else
			--print("precaching "..unitTable[i])
			local pct = math.floor(i / #unitTable * 100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
			PrecacheUnitByNameAsync(unitTable[i], precache_function)
		end
	end
	--print("precaching "..unitTable[i])
	PrecacheUnitByNameAsync(unitTable[i], precache_function)

end

function Precache:wildwood_thicket()
	local unitTable = {"wind_temple_staff", "tanari_thicket_ursa", "tanari_primitive_hunter", "tanari_headhunter", "tanari_thicket_priest", "tanari_thicket_high_priest", "blighted_sapling", "tanari_wild_troll", "tanari_thicket_bat", "tanari_thicket_matriarch", "wind_temple_avian_warder", "wind_temple_wind_mage", "wind_temple_emerald_spider", "wind_temple_venom_spider", "wind_temple_gardener", "wind_temple_wind_maiden", "wind_temple_descendant_of_zeus", "wind_temple_keeper_of_green_wind", "wind_temple_keeper_of_blue_wind", "wind_temple_keeper_of_red_wind", "wind_temple_master_of_storms", "wind_temple_wind_high_priest", "wind_temple_boss_staff", "wind_temple_boss", "wind_temple_rare_falcon_warden"}
	local i = 1
	local function precache_function()
		--print("done precaching: "..unitTable[i])
		i = i + 1
		if i > #unitTable then
			--print("done precaching units")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
				return 2
			end)
		else
			--print("precaching "..unitTable[i])
			local pct = math.floor(i / #unitTable * 100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
			PrecacheUnitByNameAsync(unitTable[i], precache_function)
		end
	end
	--print("precaching "..unitTable[i])
	PrecacheUnitByNameAsync(unitTable[i], precache_function)
end

function Precache:boulderspine_cavern()
	local unitTable = {"gazbin_explosives_expert_friendly", "boulderspine_cavern_monster", "cave_stalker", "blood_fiend", "depth_demon", "boulderspine_dimension_warper", "boulderspine_dimension_jumper", "boulderspine_freeze_fiend", "boulderspine_terror", "boulderspine_baron_razor", "boulderspine_armored_cave_rat", "boulderspine_obsidian_cave_beast", "boulderspine_cave_lizard_brute", "boulderspine_mud_golem", "boulderspine_viper_blue", "chained_butcher", "boulderspine_pyro", "boulderspine_firebat", "boulderspine_princess", "boulderspine_lindworm_frost", "boulderspine_slithereen_guard", "boulderspine_slithereen_featherguard", "boulderspine_slithereen_royal_guard", "water_temple_keyholder"}
	local i = 1
	local function precache_function()
		--print("done precaching: "..unitTable[i])
		i = i + 1
		if i > #unitTable then
			--print("done precaching units")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
				return 2
			end)
		else
			--print("precaching "..unitTable[i])
			local pct = math.floor(i / #unitTable * 100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
			PrecacheUnitByNameAsync(unitTable[i], precache_function)
		end
	end
	--print("precaching "..unitTable[i])
	PrecacheUnitByNameAsync(unitTable[i], precache_function)
end

function Precache:tanari_crater()
	local unitTable = {"terrasic_lava_beast", "terrasic_volcanic_legion", "terrasic_flame_orchid", "tanari_molten_walker", "terrasic_awakened_stone", "terrasic_boulderspine", "terrasic_red_mist_soldier", "terrasic_doomguard", "terrasic_goremaw_flame_splitter", "terrasic_volcano_beetle", "volcanic_pharoah", "terrasic_black_drake", "terrasic_red_guard", "terrasic_captain_reimus", "molten_entity", "volcanic_ash", "terrasic_red_warlock", "terrasic_red_mist_conqueror", "terrasic_red_mist_brute", "terrasic_captain_clayborne", "terrasic_lava_summoner", "terrasic_warlock_summon", "terrasic_fire_key_holder", "terrasic_general_roofus"}
	local i = 1
	local function precache_function()
		--print("done precaching: "..unitTable[i])
		i = i + 1
		if i > #unitTable then
			--print("done precaching units")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
				return 2
			end)
		else
			--print("precaching "..unitTable[i])
			local pct = math.floor(i / #unitTable * 100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
			PrecacheUnitByNameAsync(unitTable[i], precache_function)
		end
	end
	--print("precaching "..unitTable[i])
	PrecacheUnitByNameAsync(unitTable[i], precache_function)
end

function Precache:water_temple()
	local unitTable = {"tanari_water_bug", "swamp_razorfish", "swamp_razorfish_captain", "swamp_razorfish_irritable", "tanari_ancient", "water_temple_vault_lord", "water_temple_shark", "water_temple_aqua_mage", "water_temple_beach_hermit", "water_temple_prison_guard", "water_temple_executioner", "water_temple_jailer", "water_temple_fish_prisoner", "water_temple_faceless_water_elemental", "water_temple_blue_warlock", "water_temple_emperor_elemental", "water_temple_vault_master", "water_temple_serpent_sleeper", "water_temple_armored_water_beetle", "water_temple_blinded_serpent_warrior", "water_temple_amphi_lizard_rider", "water_temple_fairy_dragon", "water_temple_boss"}
	local i = 1
	local function precache_function()
		--print("done precaching: "..unitTable[i])
		i = i + 1
		if i > #unitTable then
			--print("done precaching units")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
				return 2
			end)
		else
			--print("precaching "..unitTable[i])
			local pct = math.floor(i / #unitTable * 100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
			PrecacheUnitByNameAsync(unitTable[i], precache_function)
		end
	end
	--print("precaching "..unitTable[i])
	PrecacheUnitByNameAsync(unitTable[i], precache_function)
end

function Precache:fire_temple()
	local unitTable = {"fire_temple_blackguard", "blackguard_cultist", "fire_temple_blackguard_doombringer", "fire_temple_burning_prisoner", "fire_temple_molten_war_knight", "fire_temple_lost_shadow_of_davion", "fire_temple_passage_skeleton", "fire_temple_relic_seeker", "fire_temple_secret_fanatic", "disciple_of_yojimbo", "yojimbo_boss", "fire_temple_tempered_warrior", "fire_temple_mad_rito", "fire_temple_sky_guardian", "fire_temple_dimension_seeker", "fire_temple_fireling", "fire_temple_skeleton_archer", "fire_temple_lumos_ascender", "fire_temple_seer_of_solos", "fire_temple_final_wave_mob", "fire_temple_fire_mage", "fire_temple_lava_caller", "fire_temple_protective_spirit", "fire_temple_flame_wraith", "fire_temple_flame_wraith_lord", "flame_worshipper_kolthun", "fire_temple_neverlord_reborn", "tanari_ancient_hero"}
	local i = 1
	local function precache_function()
		--print("done precaching: "..unitTable[i])
		i = i + 1
		if i > #unitTable then
			--print("done precaching units")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
				return 2
			end)
		else
			--print("precaching "..unitTable[i])
			local pct = math.floor(i / #unitTable * 100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
			PrecacheUnitByNameAsync(unitTable[i], precache_function)
		end
	end
	--print("precaching "..unitTable[i])
	PrecacheUnitByNameAsync(unitTable[i], precache_function)
end

--ARENA--
function Precache:arena()
	local unitTable = {"arena_show_combatant", "arena_attendee_one", "arena_entrance_fan", "arena_guard", "champions_league_attendant", "challenger_attendant", "arena_crowd_fan", "arena_show_fighter_one", "arena_show_fighter_two", "arena_hall_of_heroes_npc", "pvp_attendant", "arena_aquatarium_magician", "arena_game_elemental", "arena_training_dummy"}
	local i = 1
	local function precache_function()
		--print("done precaching: "..unitTable[i])
		i = i + 1
		if i > #unitTable then
			--print("done precaching units")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
				return 2
			end)
		else
			--print("precaching "..unitTable[i])
			local pct = math.floor(i / #unitTable * 100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
			PrecacheUnitByNameAsync(unitTable[i], precache_function)
		end
	end
	--print("precaching "..unitTable[i])
	PrecacheUnitByNameAsync(unitTable[i], precache_function)
end

function Precache:champions_league()
	local unitTable = {"champion_league_challenger_20", "champion_league_challenger_19", "champion_league_challenger_18", "champion_league_challenger_17", "arena_league_challenger_17_fire", "arena_league_challenger_17_earth", "arena_league_challenger_17_air", "champion_league_challenger_16", "champion_league_challenger_15", "champion_league_challenger_14", "champion_league_challenger_13", "champion_league_challenger_13_a", "champion_league_challenger_13_b", "champion_league_challenger_13_c", "champion_league_challenger_12", "champion_league_challenger_11", "champion_league_challenger_10", "castle_skeleton_mage", "castle_skeleton_archer", "castle_ghost", "castle_skeleton_warrior", "champion_league_challenger_9", "champion_league_challenger_8", "champion_league_challenger_7", "champion_league_challenger_6", "arena_nightmare_spectre", "arena_nightmare_guard", "arena_nightmare_cerberus", "arena_nightmare_zombie", "arena_nightmare_ghastly_airwarden", "arena_nightmare_fiend", "animated_arms", "arena_nightmare_boss", "champion_league_challenger_5", "champion_league_challenger_4", "champion_league_challenger_3_a", "champion_league_challenger_3_b", "champion_league_challenger_2", "champion_league_challenger_1"}
	local i = 1
	local function precache_function()
		--print("done precaching: "..unitTable[i])
		i = i + 1
		if i > #unitTable then
			--print("done precaching units")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
				return 2
			end)
		else
			--print("precaching "..unitTable[i])
			local pct = math.floor(i / #unitTable * 100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
			PrecacheUnitByNameAsync(unitTable[i], precache_function)
		end
	end
	--print("precaching "..unitTable[i])
	PrecacheUnitByNameAsync(unitTable[i], precache_function)
end

function Precache:pit_of_trials_1()
	local unitTable = {"arena_pit_pit_guardian", "master_duelist", "champion_gladiator", "pit_crawler", "arena_pit_quizmaster", "arena_pit_soul_revenant", "arena_pit_shadow_sniper", "arena_pit_conquest_mire_keeper", "arena_pit_conquest_mountain_behemoth", "arena_pit_conquest_root_overgrowth", "arena_pit_conquest_cragnataur", "arena_pit_conquest_mountain_spider", "arena_pit_conquest_spider", "arena_pit_conquest_priest_of_karzhun", "arena_pit_conquest_helob", "arena_conquest_ruins_guardian", "pit_conquest_dragon", "arena_pit_conquest_mire_boss", "terrasic_goremaw_flame_splitter", "pit_conquest_forest_soldier", "pit_conquest_woods_titan", "arena_lies_spark_beetle", "arena_lies_lich", "arena_lies_samurai", "arena_lies_arbiter_of_truth", "lies_treasure_hoarder", "arena_lies_shadow_beast", "lies_trickster_mage", "tanari_angry_fish", "arena_descent_exiled_spirit", "arena_descent_exiled_spirit_big", "arena_descent_passage_keeper", "arena_descent_grieving_widow", "arena_descent_horror_construct"}
	local i = 1
	local function precache_function()
		--print("done precaching: "..unitTable[i])
		i = i + 1
		if i > #unitTable then
			--print("done precaching units")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
				return 2
			end)
		else
			--print("precaching "..unitTable[i])
			local pct = math.floor(i / #unitTable * 100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
			PrecacheUnitByNameAsync(unitTable[i], precache_function)
		end
	end
	--print("precaching "..unitTable[i])
	PrecacheUnitByNameAsync(unitTable[i], precache_function)
end

function Precache:pit_of_trials_2()
	local unitTable = {"arena_pit_of_trials_final_boss", "arena_boss_spectre_summon", "lies_golden_skullbone", "arena_descent_doombringer", "arena_descent_boss", "pit_conquest_boss", "pit_conquest_lord_of_bovel", "arena_conquest_temple_witch_doctor", "arena_conquest_temple_repeller", "arena_conquest_temple_hunter", "arena_conquest_skeletal_mage", "arena_conquest_temple_shifter", "arena_lies_castle_enigma", "arena_lies_razor_miniboss", "arena_lies_boss", "arena_lies_doombringer", "arena_conquest_gift_of_kharzun", "arena_pit_conquest_temple_explorer", "arena_pit_conquest_temple_shaman", "arena_pit_temple_guardian_snakes", "arena_descent_tombstone", "arena_descent_terror_striker", "arena_descent_gargoyle", "arena_descent_goo_beetle", "arena_descent_zombie_critter", "arena_descent_razor_guard", "arena_pit_conquest_spirit_of_rakash", "arena_descent_death_seeker", "arena_descent_zombie", "pit_conquest_forest_mage", "arena_lies_castle_light_absorber"}
	local i = 1
	local function precache_function()
		--print("done precaching: "..unitTable[i])
		i = i + 1
		if i > #unitTable then
			--print("done precaching units")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
				return 2
			end)
		else
			--print("precaching "..unitTable[i])
			local pct = math.floor(i / #unitTable * 100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
			PrecacheUnitByNameAsync(unitTable[i], precache_function)
		end
	end
	--print("precaching "..unitTable[i])
	PrecacheUnitByNameAsync(unitTable[i], precache_function)
end

--REDFALL--

function Precache:redfall()
	local unitTable = {"redfall_first_unit", "redfall_shroomling", "redfall_autumn_gazer", "redfall_autumn_spawner", "redfall_wozxak", "redfall_autumn_flower", "redfall_forest_summoner", "redfall_crimsyth_cultist", "redfall_forest_minion", "redfall_aqua_lily", "redfall_forest_wood_dweller", "redfall_forest_overgrowth", "redfall_disciple_of_maru", "redfall_autumn_spirit", "redfall_forest_gnome", "redfall_cliff_weed", "redfall_otaru", "redfall_cliff_invader_range", "redfall_cliff_invader", "redfall_forest_ranger", "redfall_stone_watcher", "redfall_red_raven", "redfall_hooded_soul_reacher", "redfall_ash_snake", "redfall_ashfall_knight", "redfall_redfall_vulture", "redfall_autumn_cragnataur", "redfall_crimsyth_cultist_boss", "redfall_ashen_treant", "redfall_fenrir"}
	local i = 1
	local function precache_function()
		--print("done precaching: "..unitTable[i])
		i = i + 1
		if i > #unitTable then
			--print("done precaching units")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
				return 2
			end)
		else
			--print("precaching "..unitTable[i])
			local pct = math.floor(i / #unitTable * 100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
			PrecacheUnitByNameAsync(unitTable[i], precache_function)
		end
	end
	--print("precaching "..unitTable[i])
	PrecacheUnitByNameAsync(unitTable[i], precache_function)

end

function Precache:autumnmist_cavern()
	local unitTable = {"redfall_autumn_enforcer", "redfall_autumn_tyrant", "redfall_pan_knight", "redfall_canyon_alpha_beast", "redfall_canyon_breaker", "redfall_canyon_predator", "redfall_armored_crab_beast", "redfall_canyon_bull", "redfall_canyon_dinosaur", "redfall_lzard_guide", "redfall_canyon_grizzly_patriarch", "redfall_canyon_barbarian", "redfall_mist_knight", "redfall_autumn_mage", "redfall_troll_warlord", "redfall_mist_assassin", "redfall_autumn_mage_boss", "redfall_canyon_boss", "redfall_canyon_boss_miniature", "redfall_spirit_of_ashara", "redfall_ashara", "redfall_canyon_feronia"}
	local i = 1
	local function precache_function()
		--print("done precaching: "..unitTable[i])
		i = i + 1
		if i > #unitTable then
			--print("done precaching units")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
				return 2
			end)
		else
			--print("precaching "..unitTable[i])
			local pct = math.floor(i / #unitTable * 100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
			PrecacheUnitByNameAsync(unitTable[i], precache_function)
		end
	end
	--print("precaching "..unitTable[i])
	PrecacheUnitByNameAsync(unitTable[i], precache_function)

end

function Precache:redfall_farmlands()
	local unitTable = {"redfall_farmlands_bandit", "redfall_farmland_spawner", "redfall_pumpkin_flower", "redfall_farmlands_thief", "ancient_ruby_giant", "redfall_harvest_wraith", "redfall_farmlands_flame_panda", "redfall_farmlands_corn_harvester", "redfall_twisted_pumpkin", "redfall_chibi_bear", "redfall_crymsith_duelist", "redfall_crimsyth_bandit", "redfall_farmlands_crymsith_taskmaster", "redfall_meepo_farmer", "redfall_crimsyth_recruiter", "redfall_demon_farmer"}
	local i = 1
	local function precache_function()
		--print("done precaching: "..unitTable[i])
		i = i + 1
		if i > #unitTable then
			--print("done precaching units")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
				return 2
			end)
		else
			--print("precaching "..unitTable[i])
			local pct = math.floor(i / #unitTable * 100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
			PrecacheUnitByNameAsync(unitTable[i], precache_function)
		end
	end
	--print("precaching "..unitTable[i])
	PrecacheUnitByNameAsync(unitTable[i], precache_function)
end

function Precache:abandoned_shipyard()
	local unitTable = {"redfall_shipyard_crimsyth_blood_hunter", "redfall_shipyard_demon_wolf", "redfall_shipyard_blood_wolf", "shipyard_skeleton_archer", "shipyard_skeleton_archer_boss", "redfall_shipyard_void", "redfall_shipyard_conductor", "water_temple_armored_water_beetle", "redfall_shipyard_haunt_knight", "shipyard_zombie_warrior", "redfall_shipyard_gatekeeper", "shipyard_ghost_fish", "shipyard_pirate_archer", "redfall_shipyard_cargo_watcher", "redfall_shipyard_spawner_boss", "redfall_shipyard_pirate_gnoll", "redfall_shipyard_soul_collector", "shipyard_armored_bear_guard", "redfall_shipyard_crimsyth_knight", "redfall_shipyard_boss", "redfall_farmlands_friendly_harvester"}
	local i = 1
	local function precache_function()
		--print("done precaching: "..unitTable[i])
		i = i + 1
		if i > #unitTable then
			--print("done precaching units")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
				return 2
			end)
		else
			--print("precaching "..unitTable[i])
			local pct = math.floor(i / #unitTable * 100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
			PrecacheUnitByNameAsync(unitTable[i], precache_function)
		end
	end
	--print("precaching "..unitTable[i])
	PrecacheUnitByNameAsync(unitTable[i], precache_function)

end

function Precache:crimsyth_castle()
	local unitTable = {"redfall_ancient_tree", "redfall_dragonkin", "redfall_crimsyth_hell_bandit", "redfall_autumn_monster", "crimsyth_bombadier", "crimsyth_bombadier_rooted", "redfall_snarlroot_treant", "crimsyth_sorceress", "redfall_crimsyth_castle_boss", "redfall_crimsyth_thug", "redfall_castle_archer", "nibohg", "phoenix_siege_dragon", "redfall_crimsyth_hawk_soldier", "redfall_crimsyth_hawk_soldier_elite", "redfall_crimsyth_shadow", "redfall_castle_warflayer", "redfall_lava_lizard", "redfall_crimsyth_gunman", "redfall_castle_tongey_kong", "redfall_crimsyth_gunman_elite", "redfall_crimsyth_khan_knight", "redfall_enclave_viking", "redfall_erakor_the_sadist", "redfall_crimsyth_torture_puppet", "redfall_crimsyth_corrupted_corpse", "redfall_tortured_soul", "redfall_the_archivist", "archivist_demon_moloth", "redfall_castle_garden_overlord", "redfall_castle_mini_golem", "redfall_crimson_samurai", "redfall_crimson_warrior", "redfall_crimson_shadow_dancer", "redfall_castle_crimson_flood", "redfall_crimsyth_crystal_hoarder", "redfall_castle_loki_the_mad", "redfall_crystal_shifter", "redfall_lava_room_ice_switch", "fire_temple_flame_wraith", "redfall_crimsyth_mage", "redfall_crimsyth_mage_elite", "redfall_soul_scar", "arena_conquest_ruins_guardian", "redfall_crimsyth_grunt", "crimsyth_raging_shaman", "crimsyth_ghost_of_perdition", "crimsyth_fortune_seeker", "redfall_castle_effigy_of_fortunis", "redfall_maze_ghost", "redfall_ethereal_revenant", "redfall_crimsyth_castle_grounds_guardian", "redfall_crimsyth_guard", "redfall_crimsyth_berserker", "redfall_castle_garden_watcher", "prince_elthezun", "iron_spine", "redfall_castle_dweller", "redfall_castle_demented_shaman", "redfall_castle_avian_purifier", "redfall_crimsyth_demon_knight", "redfall_the_cannibal", "redfall_demonic_follower", "redfall_lava_behemoth"}
	local i = 1
	local function precache_function()
		--print("done precaching: "..unitTable[i])
		i = i + 1
		if i > #unitTable then
			--print("done precaching units")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
				return 2
			end)
		else
			--print("precaching "..unitTable[i])
			local pct = math.floor(i / #unitTable * 100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
			PrecacheUnitByNameAsync(unitTable[i], precache_function)
		end
	end
	--print("precaching "..unitTable[i])
	PrecacheUnitByNameAsync(unitTable[i], precache_function)
end
--PVP--
function Precache:pvp()
	local unitTable = {"rpc_pvp_vision_node", "rpc_pvp_line_tower_good", "rpc_pvp_line_tower_bad", "rpc_pvp_tanari_builder", "tanari_mountain_bully", "tanari_tribal_ambusher", "tanari_thicket_ursa", "tanari_headhunter", "tanari_thicket_priest", "tanari_thicket_pain_absorber", "wind_temple_avian_warder", "boulderspine_cavern_monster", "boulderspine_slithereen_guard", "boulderspine_slithereen_featherguard", "boulderspine_slithereen_royal_guard", "water_temple_shark", "water_temple_faceless_water_elemental", "water_temple_fairy_dragon", "terrasic_red_mist_soldier", "terrasic_goremaw_flame_splitter", "fire_temple_blackguard", "fire_temple_blackguard_doombringer", "fire_temple_secret_fanatic", "fire_temple_molten_war_knight", "fire_temple_flame_wraith", "redfall_autumn_spirit", "redfall_forest_gnome", "redfall_stone_watcher", "redfall_forest_ranger", "redfall_autumn_cragnataur", "redfall_canyon_bull", "redfall_hooded_soul_reacher", "redfall_autumn_mage", "redfall_farmlands_bandit", "redfall_harvest_wraith", "redfall_farmlands_corn_harvester", "redfall_crymsith_duelist", "redfall_crimsyth_recruiter", "shipyard_skeleton_archer", "redfall_farmlands_crymsith_taskmaster", "redfall_shipyard_crimsyth_knight", "crimsyth_bombadier", "redfall_snarlroot_treant", "redfall_crimsyth_hawk_soldier_elite", "redfall_crimsyth_shadow", "redfall_castle_warflayer", "redfall_crimsyth_mage", "crimsyth_fortune_seeker", "redfall_crimsyth_berserker", "wind_temple_rare_wind_prophet", "water_temple_rare_water_construct", "fire_temple_rare_lava_forgemaster", "redfall_ashara", "ancient_ruby_giant", "redfall_lava_behemoth"}
	for i = 1, #unitTable, 1 do
		Timers:CreateTimer(i * 0.3, function()
			--print("precaching "..unitTable[i])
			PrecacheUnitByNameAsync(unitTable[i], function(...) end)
		end)
	end

end

function Precache:serengaard()
	local unitTable = {"lies_golden_skullbone", "arena_pit_conquest_priest_of_karzhun", "rpc_serengaard_tower", "serengaard_ranger", "serengaard_ancient_guardian", "rpc_serengaard_teleporter", "rpc_serengaard_barracks", "serengaard_knight", "dark_fighter_serengaard", "rpc_serengaard_ancient", "serengaard_freeze_fiend", "serengaard_icy_venge", "gargoyle", "npc_dota_creature_basic_zombie_exploding", "serengaard_hook_flinger", "serengaard_antimage", "blood_fiend", "serengaard_sand_king", "serengaard_wandering_mage", "experimental_minion", "desert_warlord", "tomb_stalker", "serengaard_neverlord", "goremaw_brute", "goremaw_shaman", "obsidian_golem", "serengaard_siege_archer", "arabor_cultist", "hell_hound", "crawler", "dire_ranged", "dire_melee", "shadow_hunter", "warden_of_death", "swamp_viper", "amber_spider_queen", "amber_spiderling", "citre_spiderling", "spectral_assassin", "conjured_tide", "betrayer_of_time", "serengaard_baron_razor", "serengaard_engima_raider", "serengaard_mini_enigma", "serengaard_geosidic", "serengaard_snowball_thrower", "serengaard_ice_shard_thrower", "serengaard_shredder_max", "serengaard_gazbin_mercenary", "wraithguard", "wraithguard_elite", "castle_skeleton_archer", "serengaard_nightmare_raider", "serengaard_night_invader", "phoenix_assassin", "phoenix_siege_lich", "phoenix_siege_lich_boss", "phoenix_electron_raider", "phoenix_hunter", "phoenix_executioner", "phoenix_siege_dragon", "serengaard_final_boss"}
	local i = 1
	local function precache_function()
		--print("done precaching: "..unitTable[i])
		i = i + 1
		if i > #unitTable then
			--print("done precaching units")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
				return 2
			end)
		else
			--print("precaching "..unitTable[i])
			local pct = math.floor(i / #unitTable * 100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
			PrecacheUnitByNameAsync(unitTable[i], precache_function)
		end
	end
	--print("precaching "..unitTable[i])
	PrecacheUnitByNameAsync(unitTable[i], precache_function)
	local delay = 45
	if Beacons.cheats then
		delay = 0.5
	end
	Timers:CreateTimer(delay, function()
		local unitTable = {"redfall_dragonkin", "redfall_crimsyth_hell_bandit", "redfall_autumn_monster", "crimsyth_bombadier", "redfall_snarlroot_treant", "redfall_crimsyth_thug", "redfall_castle_archer", "nibohg", "redfall_crimsyth_hawk_soldier", "redfall_crimsyth_hawk_soldier_elite", "redfall_crimsyth_shadow", "redfall_castle_warflayer", "redfall_lava_lizard", "redfall_crimsyth_gunman", "redfall_castle_tongey_kong", "redfall_crimsyth_gunman_elite", "redfall_crimsyth_khan_knight", "redfall_enclave_viking", "redfall_crimsyth_torture_puppet", "redfall_crimsyth_corrupted_corpse", "redfall_tortured_soul", "redfall_crimson_samurai", "redfall_crimson_warrior", "redfall_crimson_shadow_dancer", "redfall_crimsyth_crystal_hoarder", "redfall_crystal_shifter", "redfall_crimsyth_mage", "redfall_crimsyth_mage_elite", "redfall_soul_scar", "arena_conquest_ruins_guardian", "redfall_crimsyth_grunt", "crimsyth_raging_shaman", "crimsyth_fortune_seeker", "redfall_crimsyth_castle_grounds_guardian", "redfall_crimsyth_guard", "redfall_crimsyth_berserker", "redfall_castle_garden_watcher", "iron_spine", "redfall_castle_dweller", "redfall_castle_demented_shaman", "redfall_castle_avian_purifier", "redfall_crimsyth_demon_knight", "redfall_demonic_follower",
			"redfall_shipyard_crimsyth_blood_hunter", "redfall_shipyard_demon_wolf", "redfall_shipyard_blood_wolf", "shipyard_skeleton_archer", "redfall_shipyard_void", "redfall_shipyard_haunt_knight", "shipyard_zombie_warrior", "shipyard_ghost_fish", "shipyard_pirate_archer", "redfall_shipyard_cargo_watcher", "redfall_shipyard_pirate_gnoll", "shipyard_armored_bear_guard", "redfall_shipyard_crimsyth_knight",
			"redfall_farmlands_bandit", "redfall_farmlands_thief", "redfall_harvest_wraith", "redfall_farmlands_flame_panda", "redfall_farmlands_corn_harvester", "redfall_twisted_pumpkin", "redfall_chibi_bear", "redfall_crymsith_duelist", "redfall_crimsyth_bandit", "redfall_farmlands_crymsith_taskmaster", "redfall_crimsyth_recruiter",
			"redfall_autumn_enforcer", "redfall_autumn_tyrant", "redfall_pan_knight", "redfall_canyon_alpha_beast", "redfall_canyon_breaker", "redfall_canyon_predator", "redfall_armored_crab_beast", "redfall_canyon_bull", "redfall_canyon_grizzly_patriarch", "redfall_mist_knight", "redfall_autumn_mage", "redfall_troll_warlord", "redfall_mist_assassin",
			"redfall_shroomling", "redfall_autumn_spawner", "redfall_wozxak", "redfall_forest_summoner", "redfall_crimsyth_cultist", "redfall_forest_minion", "redfall_forest_wood_dweller", "redfall_forest_overgrowth", "redfall_disciple_of_maru", "redfall_autumn_spirit", "redfall_forest_gnome", "redfall_cliff_weed", "redfall_cliff_invader_range", "redfall_cliff_invader", "redfall_stone_watcher", "redfall_hooded_soul_reacher", "redfall_ash_snake", "redfall_ashfall_knight", "redfall_redfall_vulture", "redfall_autumn_cragnataur",
			"fire_temple_blackguard", "blackguard_cultist", "fire_temple_blackguard_doombringer", "fire_temple_burning_prisoner", "fire_temple_molten_war_knight", "fire_temple_lost_shadow_of_davion", "fire_temple_passage_skeleton", "fire_temple_relic_seeker", "fire_temple_secret_fanatic", "fire_temple_tempered_warrior", "fire_temple_sky_guardian", "fire_temple_dimension_seeker", "fire_temple_fireling", "fire_temple_skeleton_archer", "fire_temple_final_wave_mob", "fire_temple_fire_mage", "fire_temple_lava_caller", "fire_temple_protective_spirit", "fire_temple_flame_wraith", "fire_temple_flame_wraith_lord",
			"tanari_water_bug", "swamp_razorfish", "swamp_razorfish_captain", "swamp_razorfish_irritable", "tanari_ancient", "water_temple_vault_lord", "water_temple_shark", "water_temple_aqua_mage", "water_temple_beach_hermit", "water_temple_prison_guard", "water_temple_executioner", "water_temple_fish_prisoner", "water_temple_faceless_water_elemental", "water_temple_blue_warlock", "water_temple_vault_master", "water_temple_serpent_sleeper", "water_temple_armored_water_beetle", "water_temple_blinded_serpent_warrior", "water_temple_fairy_dragon",
			"terrasic_volcanic_legion", "terrasic_awakened_stone", "terrasic_red_mist_soldier", "terrasic_goremaw_flame_splitter", "terrasic_red_guard", "terrasic_captain_reimus", "molten_entity", "volcanic_ash", "terrasic_red_warlock", "terrasic_red_mist_conqueror", "terrasic_red_mist_brute", "terrasic_captain_clayborne",
			"tanari_thicket_ursa", "tanari_primitive_hunter", "tanari_headhunter", "tanari_thicket_priest", "tanari_thicket_high_priest", "blighted_sapling", "tanari_wild_troll", "tanari_thicket_bat", "tanari_thicket_matriarch", "wind_temple_avian_warder", "wind_temple_wind_mage", "wind_temple_emerald_spider", "wind_temple_venom_spider", "wind_temple_gardener", "wind_temple_wind_maiden", "wind_temple_descendant_of_zeus",
		"arena_boss_spectre_summon", "water_temple_vault_lord_two", "champion_gladiator", "arena_pit_quizmaster", "arena_pit_soul_revenant", "arena_pit_conquest_mire_keeper", "arena_pit_conquest_mountain_behemoth", "arena_pit_conquest_cragnataur", "arena_pit_conquest_mountain_spider", "arena_pit_conquest_spider", "arena_pit_conquest_priest_of_karzhun", "arena_pit_conquest_helob", "arena_conquest_ruins_guardian", "arena_pit_conquest_temple_explorer", "arena_conquest_temple_witch_doctor", "arena_conquest_temple_repeller", "arena_conquest_skeletal_mage", "arena_conquest_temple_shifter", "pit_conquest_dragon", "arena_pit_conquest_mire_boss", "pit_conquest_forest_soldier", "pit_conquest_woods_titan", "pit_conquest_forest_mage", "arena_lies_castle_light_absorber", "arena_lies_spark_beetle", "arena_lies_lich", "arena_lies_samurai", "lies_golden_skullbone", "lies_trickster_mage", "tanari_angry_fish", "arena_lies_castle_enigma", "arena_lies_razor_miniboss", "arena_descent_exiled_spirit", "arena_descent_exiled_spirit_big", "arena_descent_passage_keeper", "arena_descent_horror_construct", "arena_descent_death_seeker", "arena_descent_zombie", "arena_descent_tombstone", "arena_descent_terror_striker", "arena_descent_gargoyle", "arena_descent_goo_beetle", "arena_descent_zombie_critter", "arena_descent_razor_guard", "water_temple_stone_priestess", "water_manifestation"}
		local i = 1
		local function precache_function()
			--print("done precaching: "..unitTable[i])
			i = i + 1
			if i > #unitTable then
				--print("done precaching units")
				Timers:CreateTimer(0, function()
					CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
					return 2
				end)
			else
				--print("precaching "..unitTable[i])
				local pct = math.floor(i / #unitTable * 100)
				CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
				PrecacheUnitByNameAsync(unitTable[i], precache_function)
			end
		end
		--print("precaching "..unitTable[i])
		PrecacheUnitByNameAsync(unitTable[i], precache_function)
	end)
end

--SEA FORTRESS--
function Precache:SeaFortress()
	local unitTable = {"sea_fortress_precache", "sea_fortress_sea_queen", "sea_fortress_barnacle_behemoth", "seafortress_ocean_watcher", "seafortress_cheep", "sea_fortress_sea_lord_arghul", "sea_fortress_sea_portal", "sea_leaflet_master", "sea_fortress_leaflet", "sea_fortress_goddess_of_the_hunt", "sea_fortress_lunar_archer", "sea_fortress_venomous_dragonfly", "sea_fortress_aqua_scorcher", "sea_fortress_dryad", "sea_fortress_mountain_beast", "sea_fortress_grove_blossom", "seafortress_dimensional_construct", "sea_fortress_deep_earthen_warrior", "seafortress_torment_staff", "carnivorous_swamp_dweller", "seafortress_swamp_dragon", "seafortress_bear", "seafortress_viper", "seafortress_ahn_qhir", "seafortress_swamp_lady", "swamp_shadow", "water_temple_sea_lady_summoner", "sea_fortress_revenant", "seafortress_swamp_snake", "seafortress_hydra", "seafortress_manta_rider", "seafortress_canyon_lizard", "seafortress_temple_exiler", "water_temple_naga_samurai", "water_temple_naga_frost_mage", "water_temple_naga_protector", "seafortress_primeval_ursan", "seafortress_water_huntress", "elite_ocean_warrior", "seafortress_ocean_lord_zarkhaz", "seafortress_ghost_pirate", "seafortress_deep_sea_construct", "seafortress_deep_shadow_weaver", "deep_ocean_death_archer", "seafortress_cavern_summoner", "serengaard_siege_archer", "deep_sea_rider", "water_shadow_hunter", "seafortress_jailer", "sapphire_dragon", "seafortress_infernal_jail_guard", "water_temple_vault_lord_two", "seafortress_fish_prisoner", "seafortress_mekanoid_disruptor", "spikey_beetle", "cavern_spearback", "seafortress_duelist", "seafortress_rock_breaker", "crimsyth_fortune_seeker", "redfall_crimsyth_berserker", "big_beach_ogre", "seafortress_deep_diver", "seafortress_depth_warper", "seafortress_thunder_zot", "seafortress_dark_sunderer", "seafortress_cephalopus", "seafortress_sea_maiden", "seafortress_centaur", "seafortress_soul_splicer", "sea_fortress_fairy_dragon", "seabinder_olaf", "seafortress_temple_assassin", "seafortress_giga_ocean_elemental", "seafortress_blazing_assassin", "seafortress_kray_beast", "seafortress_disciple_of_poseidon", "seafortress_sea_prophet", "water_temple_faceless_water_elemental", "water_temple_stone_priestess", "arena_conquest_temple_shifter", "seafortress_aqua_dragoon", "seafortress_blood_drinker", "seafortress_water_bug", "seafortress_saltwater_demon", "seafortress_sea_passage_titan", "seafortress_raging_bladewarrior", "seafortress_troll_axemaster", "seafortress_water_summoner", "seafortress_slicer", "seafortress_sea_dragon_warrior", "seafortress_wandering_pirate", "seafortress_dark_spirit", "sea_fortress_barnacle_colossus", "seafortress_deckhand", "seafortress_zombied_seafarer", "seafortress_drowned_wraith", "seafortress_stalacorr", "seafortress_rain_gargoyle", "seafortress_ghost_seal", "sea_fortress_featherguard", "seafortress_dark_reef_guard", "seafortress_big_blue_furbolg", "dark_reef_skhultoth", "seafortress_boss_siltbreaker", "seafortress_ocean_centaur", "seafortress_oceanrunner_arkguil", "seafortress_boss_silver_sea_giant", "seafortress_oracle_of_the_sea", "seafortress_ocean_diviner", "seafortress_final_boss", "seafortress_squidcicle", "seafortress_shadow_of_bahamut", "seafortress_archon_wizard", "sea_fortress_archon_golem", "sea_fortress_paladin_golem"}
	local i = 1
	local function precache_function()
		--print("done precaching: "..unitTable[i])
		i = i + 1
		if i > #unitTable then
			--print("done precaching units")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
				return 2
			end)
		else
			--print("precaching "..unitTable[i])
			local pct = math.floor(i / #unitTable * 100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
			PrecacheUnitByNameAsync(unitTable[i], precache_function)
		end
	end
	--print("precaching "..unitTable[i])
	PrecacheUnitByNameAsync(unitTable[i], precache_function)
end

--WINTERBLIGHT--
function Precache:Winterblight()
	local unitTable = {"winterblight_snowball_kid", "winterblight_snow_crab", "winterblight_snowcrab_eggs", "winterblight_seal", "winterblight_mountain_ogre", "winterblight_ancient_monolith", "winterblight_ice_champion_raxxus", "mountain_assassin", "aggressive_monster", "ice_beetle", "winterblight_wolf", "winterblight_ice_crystal", "winterblight_living_ice", "winterblight_mountain_dweller", "frostiok", "winterblight_icewrack_marauder", "winterblight_chilling_colossus", "winterblight_norgok_the_ice_rider", "winterblight_snow_shaker", "winterblight_frigid_growth", "winterblight_ice_summoner", "winterblight_summon_a", "winterblight_dashing_swordsman", "winterblight_mistral_assassin", "winterblight_frost_orchid", "winterblight_winterbear", "winterblight_void_spawn", "winterblight_ice_satyr", "winterblight_icetaur", "winterblight_frostbite_spiderling", "winterblight_rider_of_azalea", "winterblight_azure_sorceress", "winterblight_frost_avatar", "winterblight_frost_elemental", "winterblight_frost_frigid_hulk", "winterblight_azalean_priest", "winterblight_azalea_frost_titan", "winterblight_dimension_walker", "winterblight_puck", "frost_whelpling", "winterblight_frost_creep", "winterblight_azalea_zealot", "winterblight_cold_seer", "winterblight_azalea_archer", "winterblight_maiden_of_azalea", "winterblight_zefnar", "winterblight_syphist", "winterblight_source_revenant", "winterblight_skater_fiend", "winterblight_source_assembly", "winterblight_azalea_highguard", "winterblight_azalea_mindbreaker", "azalea_ghost_striker", "winterblight_azalea_secret_keeper", "azalea_thorcrux", "azalea_spineback", "winterblight_crippling_wraith", "azalea_armored_knight", "winterblight_azalea_chrolonus", "winterblight_crystal_malefor", "winterblight_candy_crush_blue_spirit", "winterblight_candy_crush_green_spirit", "winterblight_candy_crush_red_spirit", "winterblight_candy_crush_yellow_spirit", "winterblight_candy_crush_magenta_spirit", "winterblight_candy_crush_orange_spirit", "winterblight_candy_crush_teal_spirit", "winterblight_azalea_spectral_witch", "winterblight_puck_guard", "azalea_air_spirit", "winterblight_azalea_frost_cruxal", "winterblight_demon_spirit", "azalea_maze_ghost", "winterblight_bladewielder", "azalea_shrine_megmus", "rupthold_the_glutton", "rupthold_ghost", "azalea_grave_summoner", "winterblight_blue_gargoyle", "azalea_dragoon", "azalea_knife_scraper", "winterblight_buzuki", "winterblight_azertia", "winterblight_torphet", "azalea_fencer", "azalea_mystery_pixie", "pixie_minion", "winterblight_azalea_riftbreaker", "azalea_star_seeker", "azalea_spine_splitter", "stargazer_orin", "winter_snow_spirit", "giga_ice_revenant", "azalea_boss", "winterblight_altar_of_ice_apparition", "winterblight_heartfreezer", "winterblight_mountain_lord", "winterblight_azheran_iceblood", "winterblight_orthok_the_damned", "winterblight_captain_reynar_ghost", "winterblight_grand_stalacorr"}
	local i = 1
	local function precache_function()
		--print("done precaching: "..unitTable[i])
		i = i + 1
		if i > #unitTable then
			--print("done precaching units")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
				return 2
			end)
		else
			--print("precaching "..unitTable[i])
			local pct = math.floor(i / #unitTable * 100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
			PrecacheUnitByNameAsync(unitTable[i], precache_function)
		end
	end
	--print("precaching "..unitTable[i])
	PrecacheUnitByNameAsync(unitTable[i], precache_function)
end

function Precache:WinterblightCavern()
	local unitTable = {"winterblight_scouring_sherpa", "winterblight_skating_zealot", "winterblight_relict", "ferocious_polar_bear", "ice_haunter", "winterblight_stone_guardian", "winterblight_merkurio", "winterblight_cavern_guide", "winterblight_cavern_centaur", "azalea_mana_null", "winterblight_blood_wraith", "winterblight_cavern_ultra_ice", "drill_digger", "winter_cavern_bat", "cavern_pantheon_knight", "barbed_husker", "winterblight_cloaked_phantasm", "winterblight_boar", "winterblight_fungal_shaman", "winterblight_cavern_beguiler", "winterblight_corporeal_revenant", "crystarium_heart_slayer", "fungal_minion", "winterblight_skull_hunter"}
	local i = 1 
	local function precache_function()
		--print("done precaching: "..unitTable[i])
		i = i+1
		if i > #unitTable then
			--print("done precaching units")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
				return 2
			end)
		else
			--print("precaching "..unitTable[i])
			local pct = math.floor(i/#unitTable*100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
			PrecacheUnitByNameAsync(unitTable[i], precache_function)
		end
	end
	--print("precaching "..unitTable[i])
	PrecacheUnitByNameAsync(unitTable[i], precache_function)	
end

function Precache:Tutorial()
	local unitTable = {"tutorial_master", "tutorial_assistant", "tutorial_shroomling", "challens_elemental"}
	local i = 1
	local function precache_function()
		--print("done precaching: "..unitTable[i])
		i = i + 1
		if i > #unitTable then
			--print("done precaching units")
			Timers:CreateTimer(0, function()
				CustomGameEventManager:Send_ServerToAllClients("finish_precache", {units = 1})
				return 2
			end)
		else
			--print("precaching "..unitTable[i])
			local pct = math.floor(i / #unitTable * 100)
			CustomGameEventManager:Send_ServerToAllClients("update_precache", {units = 1, pct = tostring(pct)})
			PrecacheUnitByNameAsync(unitTable[i], precache_function)
		end
	end
	--print("precaching "..unitTable[i])
	PrecacheUnitByNameAsync(unitTable[i], precache_function)
end

--###################
--PRECACHE SYNC TEST
--###################

function Precache:section3SYNC()
	--print("precacheing yo")
	local unitTable = {"rolling_earth_spirit", "little_meepo", "furion_mystic", "twitch_lone_druid", "exploding_warrior"}
	for i = 1, #unitTable, 1 do
		Timers:CreateTimer(i * 0.3, function()
			PrecacheResource("unit", unitTable[i], context)
		end)
	end
end

function Precache:itemsSYNC()
	local itemTable = {"item_reanimation_stone", "item_rpc_nightmare_rider_mantle", "item_rpc_redrock_footwear", "item_rpc_arcanys_slipper", "item_rpc_pathfinders_resonant_boots", "item_rpc_neptunes_water_gliders", "item_rpc_enchanted_solar_cape", "item_rpc_ruinfall_skull_token", "item_rpc_omega_ruby", "item_rpc_blue_dragon_greaves", "item_rpc_ocean_tempest_pallium", "item_rpc_brazen_kabuto_of_the_desert_realm", "item_rpc_radiant_ruins_leather", "item_rpc_windsteel_armor", "item_rpc_phoenix_emblem", "item_rpc_demon_mask", "item_rpc_crest_of_the_umbral_sentinel", "item_rpc_savage_plate_of_ogthun", "item_rpc_arcane_cascade_hat", "item_rpc_skyforge_flurry_plate", "item_rpc_aeriths_tear", "item_rpc_carbuncles_helm_of_reflection", "item_rpc_boots_of_old_wisdom", "item_rpc_guard_of_grithault", "item_rpc_fractional_enhancement_geode", "item_rpc_ring_of_nobility", "item_rpc_mordiggus_gauntlet", "item_rpc_twig_of_the_enlightened", "item_rpc_boots_of_pure_waters", "item_rpc_gloves_of_sweeping_wind", "item_rpc_depth_crest_armor", "item_rpc_tempest_falcon_ring", "item_rpc_crown_of_the_lava_forge", "item_rpc_water_mage_robes", "item_rpc_undertakers_hood", "item_rpc_hood_of_defiler", "item_rpc_stormcrack_helm", "item_rpc_antique_mana_relic", "item_rpc_ablecore_greaves", "item_rpc_basilisk_plague_helm", "item_rpc_giant_hunters_boots_of_resilience", "item_rpc_conquest_stone_falcon", "item_rpc_moon_tech_runners", "item_rpc_space_tech_vest", "item_rpc_rooted_feet", "item_rpc_wolfir_druids_spirit_helm", "item_rpc_autumn_sleeper_mask", "item_rpc_redfall_runners", "item_rpc_fenrirs_fang", "item_rpc_autumnrock_bracer", "item_rpc_guard_of_feronia", "item_rpc_helm_of_the_silent_templar", "item_rpc_skulldigger_gauntlet_lv1", "item_rpc_shipyard_veil_lv1", "item_rpc_crimsyth_elite_greaves_lv1"}
	for i = 1, #itemTable, 1 do
		--print("precaching "..itemTable[i])
		PrecacheResource("item", itemTable[i], context)
	end
end

function Precache:act2SYNC()
	local unitTable = {"rockjaw", "wastelands_archer", "desert_ghost", "bone_horror", "wandering_mage", "satyr_doctor", "hammersaur", "alpha_wolf", "general_wolfenstein", "wolf_ally", "mountain_destroyer", "desert_warlord", "blood_fiend", "dune_crasher"}
	for i = 1, #unitTable, 1 do
		PrecacheResource("unit", unitTable[i], context)
	end
end

function Precache:townSiegeSYNC()
	local unitTable = {"town_footman", "town_archer", "garrison_commander", "basic_siege_unit", "chaos_chieftain", "leaping_lion", "siege_catapult", "siege_dragon", "siege_hulker"}
	for i = 1, #unitTable, 1 do
		--print("precaching "..unitTable[i])
		PrecacheResource("unit", unitTable[i], context)
	end
end

function Precache:graveYardSYNC()
	local unitTable = {"arcane_crystal", "basic_skeleton", "skeleton_archer", "zombie_warrior", "raider", "zombie_raider", "graveyard_boss"}
	for i = 1, #unitTable, 1 do
		--print("precaching "..unitTable[i])
		PrecacheResource("unit", unitTable[i], context)
	end
end

function Precache:loggingCampSYNC()
	local unitTable = {"conjured_tide", "forest_sprite", "infected_treant", "gazbin_alchemist", "mutated_treant", "gazbin_guard", "gazbin_brute", "gazbin_peon", "gazbin_berserker", "gazbin_recruit", "gazbin_explosives_expert", "shredder_max", "gazbin_mercenary", "reinforcement_zeppelin", "gazbin_mercenary_ranged", "sludge_golem", "lumber_mill_treant", "lumber_mill_boss", "mill_warrior_tree"}
	for i = 1, #unitTable, 1 do
		Timers:CreateTimer(i * 1.7, function()
			--print("precaching "..unitTable[i])
			PrecacheResource("unit", unitTable[i], context)
		end)
	end
end

function Precache:grizzlyFallsSYNC()
	local unitTable = {"river_beast", "grizzled_woodsman", "grizzly_twilight_worshipper", "twilight_crow_cultist", "twilight_crow_summon", "grizzly_ally_healer", "grizzly_ally_tank", "grizzly_bridge_fish", "grizzly_twilight_guardian", "grizzly_falls_boss", "grizzly_sleepy_ogre", "grizzly_cave_dweller", "grizzly_cave_dweller_leader", "grizzly_awakened_stone", "grizzly_awakened_stone_leader", "grizzly_ancient_crag_golem", "grizzly_granite_apparition", "grizzly_water_hydra", "grizzly_cave_shroomling", "grizzly_medusa_acolyte"}
	for i = 1, #unitTable, 1 do
		Timers:CreateTimer(i * 1.5, function()
			--print("precaching "..unitTable[i])
			PrecacheResource("unit", unitTable[i], context)
		end)
	end
end

function Precache:sandTombSYNC()
	local unitTable = {"tomb_remnant", "ancient_ghost", "tomb_defender", "raging_flame", "crow_eater", "soul_sucker", "spine_hermit", "tomb_stalker", "vision_warden", "sand_tomb_boss"}
	for i = 1, #unitTable, 1 do
		Timers:CreateTimer(i * 1.6, function()
			--print("precaching "..unitTable[i])
			PrecacheResource("unit", unitTable[i], context)
		end)
	end
end

function Precache:desertRuinsSYNC()
	local unitTable = {"feathered_hunter", "desert_outrunner", "nomadic_hunter", "blood_worshipper", "wandering_mage_ruins", "desert_ruins_necromancer", "enslaved_corpse", "thorok_reborn", "grave_watcher", "ruins_solarium_void", "ruins_solarium_enigma", "ruins_king_rozan", "fungal_overlord", "blighted_sapling", "ruins_golden_skullbone", "ruins_venomous_burrower", "ruins_blood_arcanist", "ruins_key_holder", "well_of_sacrifice_ghost", "ruins_boss", "ancient_ruby_giant"}
	for i = 1, #unitTable, 1 do
		Timers:CreateTimer(i * 1.5, function()
			--print("precaching "..unitTable[i])
			PrecacheResource("unit", unitTable[i], context)
		end)
	end
end

function Precache:vaultSYNC()
	local unitTable = {"dynasty_heir_majinaq", "vault_guard", "vault_assassin", "vault_antimage", "vault_pleb", "vault_invisible_keyholder", "vault_executioner", "vault_henchman", "vault_treasurer", "vault_worshipper", "unreal_terror", "vault_arcanist", "vault_statue_one", "vault_statue_two", "vault_statue_three", "vault_statue_four", "vault_statue_five", "vault_statue_six"}
	for i = 1, #unitTable, 1 do
		Timers:CreateTimer(i * 1.8, function()
			--print("precaching "..unitTable[i])
			PrecacheResource("unit", unitTable[i], context)
		end)
	end
end

function Precache:swampSYNC()
	local unitTable = {"swamp_viper", "swamp_razorfish", "swamp_razorfish_captain", "swamp_tribal_cultist", "the_bog_monster", "swamp_razorfish_irritable", "swamp_tribal_invoker", "swamp_grove_bear", "swamp_grove_tender", "swamp_grove_ancestral_bear", "swamp_boss"}
	for i = 1, #unitTable, 1 do
		Timers:CreateTimer(i * 2.0, function()
			--print("precaching "..unitTable[i])
			PrecacheResource("unit", unitTable[i], context)
		end)
	end
end

function Precache:castleSYNC()
	local unitTable = {"wraithguard", "haunted_tree", "mad_pumpkin", "groundskeeper", "wraithguard_elite", "animated_arms", "castle_ghost", "castle_skeleton_archer", "castle_chef", "burning_spider", "courtyard_summoner", "castle_skeleton_mage", "castle_undertaker", "summoner_true_form", "castle_boss_intro", "castle_boss"}
	for i = 1, #unitTable, 1 do
		Timers:CreateTimer(i * 2.2, function()
			--print("precaching "..unitTable[i])
			PrecacheResource("unit", unitTable[i], context)
		end)
	end
end

function Precache:phoenixNestSYNC()
	local unitTable = {"phoenix_nest_protector", "phoenix_boss", "invader_kriggus", "follower_of_kriggus", "portal_invader", "iron_spine", "feral_bloodseeker", "phoenix_marshall", "phoenix_assassin", "bat_summon", "phoenix_siege_bat", "phoenix_siege_lich", "phoenix_siege_lich_boss", "phoenix_hunter", "phoenix_electron_raider", "phoenix_hatched", "phoenix_subboss_a", "phoenix_subboss_b", "phoenix_subboss_c", "phoenix_subboss_d"}
	for i = 1, #unitTable, 1 do
		Timers:CreateTimer(i * 2.0, function()
			--print("precaching "..unitTable[i])
			PrecacheResource("unit", unitTable[i], context)
		end)
	end
end

--TANARI--

function Precache:tanariSYNC()
	local unitTable = {"tanari_witch_doctor", "tanari_ancient_hero"}
	for i = 1, #unitTable, 1 do
		--print("precaching "..unitTable[i])
		PrecacheResource("unit", unitTable[i], context)
	end

end

function Precache:champions_walkSYNC()
	local unitTable = {"easy_kobold", "tanari_shrine_growth", "tanari_water_troll", "grizzly_bridge_fish", "tanari_angry_fish", "tanari_ambusher", "tanari_tribal_ambusher", "tanari_kraken_king", "tanari_crag_lizard", "tanari_mountain_bully", "tanari_poison_flower", "tanari_mountain_pass_guardian", "tanari_river_slug", "tanari_mountain_trogg", "tanari_reclusive_mountain_nomad", "grizzly_cave_dweller", "grizzly_cave_dweller_leader", "tanari_mountain_specter", "tanari_island_hydra", "tanari_wind_temple_keyholder"}
	for i = 1, #unitTable, 1 do
		--print("precaching "..unitTable[i])
		PrecacheResource("unit", unitTable[i], context)
	end

end

function Precache:wildwood_thicketSYNC()
	local unitTable = {"tanari_thicket_ursa", "tanari_primitive_hunter", "tanari_headhunter", "tanari_thicket_priest", "tanari_thicket_high_priest", "blighted_sapling", "tanari_wild_troll", "tanari_thicket_bat", "tanari_thicket_matriarch", "wind_temple_avian_warder", "wind_temple_wind_mage", "wind_temple_emerald_spider", "wind_temple_venom_spider", "wind_temple_gardener", "wind_temple_wind_maiden", "wind_temple_descendant_of_zeus", "wind_temple_keeper_of_green_wind", "wind_temple_keeper_of_blue_wind", "wind_temple_keeper_of_red_wind", "wind_temple_master_of_storms", "wind_temple_wind_high_priest", "wind_temple_boss_staff", "wind_temple_boss"}
	for i = 1, #unitTable, 1 do
		--print("precaching "..unitTable[i])
		PrecacheResource("unit", unitTable[i], context)
	end
end

function Precache:boulderspine_cavernSYNC()
	local unitTable = {"gazbin_explosives_expert_friendly", "boulderspine_cavern_monster", "cave_stalker", "blood_fiend", "depth_demon", "boulderspine_dimension_warper", "boulderspine_dimension_jumper", "boulderspine_freeze_fiend", "boulderspine_terror", "boulderspine_baron_razor", "boulderspine_armored_cave_rat", "boulderspine_obsidian_cave_beast", "boulderspine_cave_lizard_brute", "boulderspine_mud_golem", "boulderspine_viper_blue", "chained_butcher", "boulderspine_pyro", "boulderspine_firebat", "boulderspine_princess", "boulderspine_lindworm_frost", "boulderspine_slithereen_guard", "boulderspine_slithereen_featherguard", "boulderspine_slithereen_royal_guard", "water_temple_keyholder"}
	for i = 1, #unitTable, 1 do
		--print("precaching "..unitTable[i])
		PrecacheResource("unit", unitTable[i], context)
	end
end

function Precache:tanari_craterSYNC()
	local unitTable = {"terrasic_lava_beast", "terrasic_volcanic_legion", "terrasic_flame_orchid", "terrasic_awakened_stone", "terrasic_boulderspine", "terrasic_red_mist_soldier", "terrasic_doomguard", "terrasic_goremaw_flame_splitter", "terrasic_volcano_beetle", "volcanic_pharoah", "terrasic_black_drake", "terrasic_red_guard", "terrasic_captain_reimus", "molten_entity", "volcanic_ash", "terrasic_red_warlock", "terrasic_red_mist_conqueror", "terrasic_red_mist_brute", "terrasic_captain_clayborne", "terrasic_lava_summoner", "terrasic_warlock_summon", "terrasic_fire_key_holder"}
	for i = 1, #unitTable, 1 do
		--print("precaching "..unitTable[i])
		PrecacheResource("unit", unitTable[i], context)
	end
end

function Precache:water_templeSYNC()
	local unitTable = {"tanari_water_bug", "swamp_razorfish", "swamp_razorfish_captain", "swamp_razorfish_irritable", "tanari_ancient", "water_temple_vault_lord", "water_temple_shark", "water_temple_aqua_mage", "water_temple_beach_hermit", "water_temple_prison_guard", "water_temple_executioner", "water_temple_jailer", "water_temple_fish_prisoner", "water_temple_faceless_water_elemental", "water_temple_blue_warlock", "water_temple_emperor_elemental", "water_temple_vault_master", "water_temple_serpent_sleeper", "water_temple_armored_water_beetle", "water_temple_blinded_serpent_warrior", "water_temple_fairy_dragon", "water_temple_boss"}
	for i = 1, #unitTable, 1 do
		--print("precaching "..unitTable[i])
		PrecacheResource("unit", unitTable[i], context)
	end
end

function Precache:fire_templeSYNC()
	local unitTable = {"fire_temple_blackguard", "blackguard_cultist", "fire_temple_blackguard_doombringer", "fire_temple_burning_prisoner", "fire_temple_molten_war_knight", "fire_temple_lost_shadow_of_davion", "fire_temple_passage_skeleton", "fire_temple_relic_seeker", "fire_temple_secret_fanatic", "disciple_of_yojimbo", "yojimbo_boss", "fire_temple_tempered_warrior", "fire_temple_mad_rito", "fire_temple_sky_guardian", "fire_temple_dimension_seeker", "fire_temple_fireling", "fire_temple_skeleton_archer", "fire_temple_lumos_ascender", "fire_temple_seer_of_solos", "fire_temple_final_wave_mob", "fire_temple_fire_mage", "fire_temple_lava_caller", "fire_temple_protective_spirit", "fire_temple_flame_wraith", "fire_temple_flame_wraith_lord", "flame_worshipper_kolthun", "fire_temple_neverlord_reborn", "tanari_ancient_hero"}
	for i = 1, #unitTable, 1 do

		--print("precaching "..unitTable[i])
		PrecacheResource("unit", unitTable[i], context)
	end
end

--ARENA--
function Precache:arenaSYNC()
	local unitTable = {"arena_show_combatant", "arena_attendee_one", "arena_entrance_fan", "arena_guard", "champions_league_attendant", "challenger_attendant", "arena_crowd_fan", "arena_show_fighter_one", "arena_show_fighter_two", "arena_hall_of_heroes_npc", "pvp_attendant", "arena_aquatarium_magician", "arena_game_elemental"}
	for i = 1, #unitTable, 1 do
		--print("precaching "..unitTable[i])
		PrecacheResource("unit", unitTable[i], context)
	end
end

function Precache:champions_leagueSYNC()
	local unitTable = {"champion_league_challenger_20", "champion_league_challenger_19", "champion_league_challenger_18", "champion_league_challenger_17", "arena_league_challenger_17_fire", "arena_league_challenger_17_earth", "arena_league_challenger_17_air", "champion_league_challenger_16", "champion_league_challenger_15", "champion_league_challenger_14", "champion_league_challenger_13", "champion_league_challenger_13_a", "champion_league_challenger_13_b", "champion_league_challenger_13_c", "champion_league_challenger_12", "champion_league_challenger_11", "champion_league_challenger_10", "castle_skeleton_mage", "castle_skeleton_archer", "castle_ghost", "castle_skeleton_warrior", "champion_league_challenger_9", "champion_league_challenger_8", "champion_league_challenger_7", "champion_league_challenger_6", "arena_nightmare_spectre", "arena_nightmare_guard", "arena_nightmare_cerberus", "arena_nightmare_zombie", "arena_nightmare_ghastly_airwarden", "arena_nightmare_fiend", "animated_arms", "arena_nightmare_boss", "champion_league_challenger_5", "champion_league_challenger_4", "champion_league_challenger_3_a", "champion_league_challenger_3_b", "champion_league_challenger_2", "champion_league_challenger_1"}
	for i = 1, #unitTable, 1 do
		--print("precaching "..unitTable[i])
		PrecacheResource("unit", unitTable[i], context)
	end
end

function Precache:pit_of_trialsSYNC()
	local unitTable = {"arena_pit_of_trials_final_boss", "arena_boss_spectre_summon", "arena_pit_pit_guardian", "master_duelist", "champion_gladiator", "pit_crawler", "arena_pit_quizmaster", "arena_pit_soul_revenant", "arena_pit_shadow_sniper", "arena_pit_conquest_mire_keeper", "arena_pit_conquest_mountain_behemoth", "arena_pit_conquest_root_overgrowth", "arena_pit_conquest_cragnataur", "arena_pit_conquest_mountain_spider", "arena_pit_conquest_spider", "arena_pit_conquest_priest_of_karzhun", "arena_pit_conquest_helob", "arena_conquest_ruins_guardian", "arena_conquest_gift_of_kharzun", "arena_pit_conquest_temple_explorer", "arena_pit_conquest_temple_shaman", "arena_pit_temple_guardian_snakes", "arena_conquest_temple_witch_doctor", "arena_conquest_temple_repeller", "arena_conquest_temple_hunter", "arena_conquest_skeletal_mage", "arena_conquest_temple_shifter", "pit_conquest_dragon", "arena_pit_conquest_mire_boss", "terrasic_goremaw_flame_splitter", "pit_conquest_forest_soldier", "pit_conquest_woods_titan", "pit_conquest_forest_mage", "arena_lies_castle_light_absorber", "pit_conquest_lord_of_bovel", "arena_lies_spark_beetle", "arena_lies_lich", "arena_lies_doombringer", "arena_lies_samurai", "arena_lies_arbiter_of_truth", "lies_treasure_hoarder", "lies_golden_skullbone", "arena_lies_shadow_beast", "lies_trickster_mage", "tanari_angry_fish", "arena_lies_castle_enigma", "arena_lies_razor_miniboss", "arena_lies_boss", "arena_descent_exiled_spirit", "arena_descent_exiled_spirit_big", "arena_descent_passage_keeper", "arena_descent_grieving_widow", "arena_descent_horror_construct", "arena_descent_death_seeker", "arena_descent_zombie", "arena_descent_tombstone", "arena_descent_terror_striker", "arena_descent_gargoyle", "arena_descent_goo_beetle", "arena_descent_zombie_critter", "arena_descent_razor_guard", "arena_descent_doombringer", "arena_descent_boss", "pit_conquest_boss", "arena_pit_conquest_spirit_of_rakash"}
	for i = 1, #unitTable, 1 do
		--print("precaching "..unitTable[i])
		PrecacheResource("unit", unitTable[i], context)
	end
end

--REDFALL--

function Precache:redfallSYNC()
	local unitTable = {"redfall_first_unit", "redfall_shroomling", "redfall_autumn_gazer", "redfall_autumn_spawner", "redfall_autumn_flower", "redfall_forest_summoner", "redfall_crimsyth_cultist", "redfall_forest_minion", "redfall_aqua_lily", "redfall_forest_wood_dweller", "redfall_forest_overgrowth", "redfall_disciple_of_maru", "redfall_autumn_spirit", "redfall_forest_gnome", "redfall_cliff_weed", "redfall_otaru", "redfall_cliff_invader_range", "redfall_cliff_invader", "redfall_forest_ranger", "redfall_stone_watcher", "redfall_red_raven", "redfall_hooded_soul_reacher", "redfall_ash_snake", "redfall_ashfall_knight", "redfall_redfall_vulture", "redfall_autumn_cragnataur", "redfall_crimsyth_cultist_boss", "redfall_ashen_treant", "redfall_fenrir"}
	for i = 1, #unitTable, 1 do
		--print("precaching "..unitTable[i])
		PrecacheResource("unit", unitTable[i], context)
	end

end

function Precache:autumnmist_cavernSYNC()
	local unitTable = {"redfall_autumn_enforcer", "redfall_autumn_tyrant", "redfall_pan_knight", "redfall_canyon_alpha_beast", "redfall_canyon_breaker", "redfall_canyon_predator", "redfall_armored_crab_beast", "redfall_canyon_bull", "redfall_canyon_dinosaur", "redfall_lzard_guide", "redfall_canyon_grizzly_patriarch", "redfall_canyon_barbarian", "redfall_mist_knight", "redfall_autumn_mage", "redfall_troll_warlord", "redfall_mist_assassin", "redfall_autumn_mage_boss", "redfall_canyon_boss", "redfall_canyon_boss_miniature", "redfall_spirit_of_ashara", "redfall_ashara", "redfall_canyon_feronia"}
	for i = 1, #unitTable, 1 do
		--print("precaching "..unitTable[i])
		PrecacheResource("unit", unitTable[i], context)
	end

end

function Precache:redfall_farmlandsSYNC()
	local unitTable = {"redfall_farmlands_bandit", "redfall_farmland_spawner", "redfall_pumpkin_flower", "redfall_farmlands_thief", "redfall_harvest_wraith", "redfall_farmlands_flame_panda", "redfall_farmlands_corn_harvester", "redfall_twisted_pumpkin", "redfall_chibi_bear", "redfall_crymsith_duelist", "redfall_crimsyth_bandit", "redfall_farmlands_crymsith_taskmaster", "redfall_meepo_farmer", "redfall_crimsyth_recruiter", "redfall_demon_farmer"}
	for i = 1, #unitTable, 1 do
		--print("precaching "..unitTable[i])
		PrecacheResource("unit", unitTable[i], context)
	end

end

function Precache:abandoned_shipyardSYNC()
	local unitTable = {"redfall_shipyard_crimsyth_blood_hunter", "redfall_shipyard_demon_wolf", "redfall_shipyard_blood_wolf", "shipyard_skeleton_archer", "shipyard_skeleton_archer_boss", "redfall_shipyard_void", "redfall_shipyard_conductor", "water_temple_armored_water_beetle", "redfall_shipyard_haunt_knight", "redfall_shipyard_gatekeeper", "shipyard_ghost_fish", "shipyard_pirate_archer", "redfall_shipyard_cargo_watcher", "redfall_shipyard_spawner_boss", "redfall_shipyard_pirate_gnoll", "redfall_shipyard_soul_collector", "shipyard_armored_bear_guard", "redfall_shipyard_crimsyth_knight", "redfall_shipyard_boss", "redfall_farmlands_friendly_harvester"}
	for i = 1, #unitTable, 1 do
		--print("precaching "..unitTable[i])
		PrecacheResource("unit", unitTable[i], context)
	end

end

