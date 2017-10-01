function updateSkillInTooltip(tooltip, queryUnit){
	if (tooltip.indexOf("@Ability") > -1){
			for (i = 1; i <= 4; i++) { 
				var heroName = Entities.GetClassname(queryUnit)
				var skillName = getSkillSlot2(queryUnit, i)
				tooltip = tooltip.replace("@Ability"+i, "<font color='#CCFF66'>"+$.Localize(skillName)+"</font>");
				tooltip = tooltip.replace("@Ability"+i, "<font color='#CCFF66'>"+$.Localize(skillName)+"</font>");
			}
	}
	return tooltip
}

function updateSkillInTooltipByName(tooltip, heroName){
	if (tooltip.indexOf("@Ability") > -1){
		for (i = 1; i <= 4; i++) { 
			var skillName = getSkillSlot(heroName, i)
			tooltip = tooltip.replace("@Ability"+i, "<font color='#CCFF66'>"+$.Localize(skillName)+"</font>");
			tooltip = tooltip.replace("@Ability"+i, "<font color='#CCFF66'>"+$.Localize(skillName)+"</font>");
		}
	}
	return tooltip
}

function getSkillSlot2(queryUnit, slot)
{
	var ability = Entities.GetAbility( queryUnit, slot - 1)
	var abilityName = Abilities.GetAbilityName( ability )
	if (abilityName == "blizzard" || abilityName == "ice_lance"){
		abilityName = "Tooltip_sorceress_q"
	}else if(abilityName == "pyroblast" || abilityName == "fireball"){
		abilityName = "Tooltip_sorceress_r"
	}else if(abilityName == "monk_heal"){
		abilityName = "Tooltip_seinaru_w"
	}else if(abilityName == "warlord_flame_rush" || abilityName == "warlord_ice_shell" || abilityName == "warlord_stone_form"){
		abilityName = "tooltip_warlord_q_abilities"
	}else if(abilityName == "axe_throw_earth" || abilityName == "axe_throw_ice" || abilityName == "axe_throw_fire"){
		abilityName = "Tooltip_throwing_axes"
	}else if(abilityName == "warlord_jump_earth" || abilityName == "warlord_jump_ice" || abilityName == "warlord_jump_fire"){
		abilityName = "Tooltip_jump_abilities"
	}else if(abilityName == "ability_whirling_flail"){
		abilityName = "tooltip_duskbringer_Q"
	}else if(abilityName == "flash_heal"){
		abilityName = "tooltip_auriun_w"
	}else if(abilityName == "trapper_arcana_venom_whip" || abilityName == "trapper_arcana_lasso"){
		abilityName = "item_property_trapper_arcana1"
	}else if(abilityName == "fulminating_trap" || abilityName == "net_trap" || abilityName == "poison_trap" || abilityName == "torrent_trap"){
		abilityName = "tooltip_trapper_q"
	}else if(abilityName == "explosive_bomb" || abilityName == "smoke_bomb"){
		abilityName = "tooltip_trapper_w"
	}else if(abilityName == "trapper_vanish" || abilityName == "trapper_action_leap"){
		abilityName = "tooltip_trapper_e"
	}else if(abilityName == "trapper_stealth" || abilityName == "trapper_backstab"){
		abilityName = "tooltip_trapper_r"
	}else if(abilityName == "spirit_warrior_flametongue" || abilityName == "spirit_warrior_windstrike_weapon"){
		abilityName = "spirit_warrior_q_ability"
	}else if(abilityName == "spirit_warrior_ancient_spirit"){
		abilityName = "spirit_warrior_e_ability"
	}else if(abilityName == "spirit_warrior_ancient_rain" || abilityName == "spirit_warrior_waterheart_weapon"){
		abilityName = "spirit_warrior_arcana1_r"
	}else if(abilityName == "spirit_warrior_ancient_spirit_elite"){
		abilityName = "spirit_warrior_arcana3_e"
	}else if(abilityName == "solunia_solar_glow" || abilityName == "solunia_lunar_glow"){
		abilityName = "solunia_q"
	}else if(abilityName == "solunia_solarang" || abilityName == "solunia_lunarang"){
		abilityName = "solunia_w"
	}else if(abilityName == "solunia_warp_flare" || abilityName == "solunia_lunar_warp_flare"){
		abilityName = "solunia_e"
	}else if(abilityName == "solunia_supernova" || abilityName == "solunia_eclipse"){
		abilityName = "solunia_r"
	}else if(abilityName == "draghor_mark_of_the_fang" || abilityName == "draghor_mark_of_the_claw" || abilityName == "draghor_mark_of_the_talon" || abilityName == "djanghor_wolf_howl" || abilityName == "djanghor_bear_roar" || abilityName == "draghor_hawk_screech"){
		abilityName = "djanghor_q_abilities"
	}else if(abilityName == "draghor_jin_bo" || abilityName == "draghor_wolf_rend" || abilityName == "djanghor_bear_war_stomp" || abilityName == "draghor_hawk_tornado"){
		abilityName = "djanghor_w_abilities"
	}else if(abilityName == "draghor_monkey_leap"|| abilityName == "djanghor_feral_sprint" || abilityName == "djanghor_bear_charge" || abilityName == "djanghor_hawk_soar"){
		abilityName = "djanghor_e_abilities"
	}else if(abilityName == "draghor_monkey_form"|| abilityName == "draghor_shapeshift_cat" || abilityName == "draghor_shapeshift_bear" || abilityName == "draghor_shapeshift_crow"){
		abilityName = "djanghor_r_abilities"
	}else{
		abilityName = "DOTA_Tooltip_ability_"+abilityName
	}
	return abilityName
}



function getSkillSlot(heroName, slot){
	
	var skillName = "error"
	if (heroName == "npc_dota_hero_dragon_knight"){
		skillName = getFlamewakerSkill(slot)
	}else if (heroName == "npc_dota_hero_phantom_assassin"){
		skillName = getVoltexSkill(slot)
	}else if (heroName == "npc_dota_hero_necrolyte"){
		skillName = getVenoSkill(slot)
	}else if (heroName == "npc_dota_hero_axe"){
		skillName = getAxeSkill(slot)
	}else if (heroName == "npc_dota_hero_drow_ranger"){
		skillName = getAstralSkill(slot)
	}else if (heroName == "npc_dota_hero_obsidian_destroyer"){
		skillName = getEpochSkill(slot)
	}else if (heroName == "npc_dota_hero_omniknight"){
		skillName = getPaladinSkill(slot)
	}else if (heroName == "npc_dota_hero_crystal_maiden"){
		skillName = getSorcSkill(slot)
	}else if (heroName == "npc_dota_hero_invoker"){
		skillName = getConjurorSkill(slot)
	}else if (heroName == "npc_dota_hero_juggernaut"){
		skillName = getMonkSkill(slot)
	}else if (heroName == "npc_dota_hero_beastmaster"){
		skillName = getWarlordSkill(slot)
	}else if (heroName == "npc_dota_hero_leshrac"){
		skillName = getBahamutSkill(slot)
	}else if (heroName == "npc_dota_hero_spirit_breaker"){
		skillName = getDuskbringerSkill(slot)
	}else if (heroName == "npc_dota_hero_zuus"){
		skillName = getAuriunSkill(slot)
	}else if (heroName == "npc_dota_hero_templar_assassin"){
		skillName = getTrapperSkill(slot)
	}else if (heroName == "npc_dota_hero_huskar"){
		skillName = getSpiritWarriorSkill(slot)
	}else if (heroName == "npc_dota_hero_legion_commander"){
		skillName = getMountainProtectorSkill(slot)
	}else if (heroName == "npc_dota_hero_night_stalker"){
		skillName = getChernobogSkill(slot)
	}else if (heroName == "npc_dota_hero_vengefulspirit"){
		skillName = getSoluniaSkill(slot)
	}else if (heroName == "npc_dota_hero_slardar"){
		skillName = getHydroxisSkill(slot)
	}else if (heroName == "npc_dota_hero_visage"){
		skillName = getEkkanSkill(slot)
	}else if (heroName == "npc_dota_hero_dark_seer"){
		skillName = getZonikSkill(slot)
	}else if (heroName == "npc_dota_hero_antimage"){
		skillName = getArkimusSkill(slot)
	}
	return skillName
}

function getFlamewakerSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_ability_fire_blast"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_ability_second_heartbeat"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_ability_flame_ray"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_example_ability"
	}
	return skillName
}

function getVoltexSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_ability_lightning_attack"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_ability_ability_zap"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_ability_electric_jump"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_static_field"
	}
	return skillName
}

function getVenoSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_ability_gale_nova"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_ability_nether_blaster"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_ability_phase_walk"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_snake_trap"
	}
	return skillName
}

function getAxeSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_ability_stun_attack"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_ability_backshock"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_ability_whirlwind"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_sunder"
	}
	return skillName
}

function getAstralSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_ability_moon_shroud"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_ability_split_shot"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_ability_star_blink"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_ranger_aoe_explosion"	
	}
	return skillName
}

function getEpochSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_ability_time_binder"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_ability_time_genesis_orb"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_ability_time_warp"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_time_ulti"	
	}
	return skillName
}

function getPaladinSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_ability_holy_wings"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_ability_holy_cone"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_ability_crusader_dash"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_holy_ulti"	
	}
	return skillName
}

function getSorcSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "Tooltip_sorceress_q"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_ability_arcane_explosion"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_ability_sorceress_blink"
	}else if(slot == 4){
		skillName = "Tooltip_sorceress_r"
	}
	return skillName
}

function getConjurorSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_ability_earthquake"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_ability_immolation"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_ability_shadow_gate"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_call_of_elements"
	}
	return skillName
}

function getMonkSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_ability_seinaru_kaze_gust"
	}else if(slot == 2){
		skillName = "Tooltip_seinaru_w"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_ability_odachi_slice"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_seinaru_gorudo"
	}
	return skillName
}

function getWarlordSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "tooltip_warlord_q_abilities"
	}else if(slot == 2){
		skillName = "Tooltip_throwing_axes"
	}else if(slot == 3){
		skillName = "Tooltip_jump_abilities"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_elemental_overload_2"
	}
	return skillName
}

function getBahamutSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_ability_leshrac_wall"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_ability_leshrac_nuke"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_ability_leshrac_blink"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_charge_of_light"
	}
	return skillName
}

function getDuskbringerSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "tooltip_duskbringer_Q"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_ability_ghost_hallow"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_ability_specter_rush"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_seven_visions"
	}
	return skillName
}

function getAuriunSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_ability_heavens_shield"
	}else if(slot == 2){
		skillName = "tooltip_auriun_w"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_ability_seraph_surge"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_auriun_ult"
	}
	return skillName
}

function getTrapperSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "tooltip_trapper_q"
	}else if(slot == 2){
		skillName = "tooltip_trapper_w"
	}else if(slot == 3){
		skillName = "tooltip_trapper_e"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_trapper_backstab"
	}
	return skillName
}

function getSpiritWarriorSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "spirit_warrior_q_ability"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_ability_spirit_warrior_soul_thrust"
	}else if(slot == 3){
		skillName = "spirit_warrior_e_ability"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_spirit_warrior_ancient_vigor"
	}
	return skillName
}

function getMountainProtectorSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_ability_mountain_protector_shockwave"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_ability_mountain_protector_mountain_guardian"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_ability_mountain_protector_emberstone"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_mountain_protector_aeon_fracture"
	}
	return skillName
}

function getChernobogSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_ability_chernobog_charons_claw"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_ability_chernobog_demon_hunter"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_ability_chernobog_shadow_walk"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_chernobog_nights_procession"
	}
	return skillName
}

function getSoluniaSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "solunia_q"
	}else if(slot == 2){
		skillName = "solunia_w"
	}else if(slot == 3){
		skillName = "solunia_e"
	}else if(slot == 4){
		skillName = "solunia_r"
	}
	return skillName
}

function getHydroxisSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_ability_hydroxis_hydro_pump"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_ability_hydroxis_water_blade"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_ability_hydroxis_slippery_tail"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_hydroxis_tsunami"
	}
	return skillName	
}

function getEkkanSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_ability_ekkan_dominion"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_ability_ekkan_summon_skeleton"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_ability_ekkan_river_of_souls"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_ekkan_supercharge"
	}
	return skillName	
}

function getZonikSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_ability_tachyon_shell"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_ability_zonik_mach_punch"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_ability_zonik_lightspeed"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_zonik_speedball"
	}
	return skillName	
}

function getArkimusSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_ability_arkimus_zonis_spark"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_ability_arkimus_storm_weapon"	
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_ability_ark_jump"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_arkimus_energy_field"
	}
	return skillName	
}

function testing(){
	$.Msg("did we load?")
}

function getHeroList(){
	var heroList = ["tooltip_neutral", "npc_dota_hero_dragon_knight", "npc_dota_hero_phantom_assassin", "npc_dota_hero_necrolyte", "npc_dota_hero_axe",
	"npc_dota_hero_drow_ranger", "npc_dota_hero_obsidian_destroyer", "npc_dota_hero_omniknight", "npc_dota_hero_crystal_maiden", "npc_dota_hero_invoker",
	"npc_dota_hero_juggernaut", "npc_dota_hero_beastmaster", "npc_dota_hero_leshrac", "npc_dota_hero_spirit_breaker", "npc_dota_hero_zuus", "npc_dota_hero_templar_assassin", 
	"npc_dota_hero_huskar", "npc_dota_hero_legion_commander", "npc_dota_hero_night_stalker", "npc_dota_hero_vengefulspirit", "npc_dota_hero_slardar", "npc_dota_hero_visage", 
	"npc_dota_hero_dark_seer", "npc_dota_hero_antimage", "npc_dota_hero_monkey_king"]
	return heroList
}

function breakUpTooltip(specialText){
	// var spacePosition10 = getPosition(specialText, " ", 8)
	// var spacePosition20 = getPosition(specialText, " ", 16)
	// var spacePosition30 = getPosition(specialText, " ", 24)
	// var brIndex = specialText.substring(0, spacePosition10).length
	// var br = "<br>"
	// var br2 = "<br>"
	// var br3 = "<br>"
	// if (spacePosition10 >= specialText.length){
	// 	br = ""
	// }
	// brIndex = specialText.substring(0, spacePosition20).length
	// if (spacePosition20 >= specialText.length){
	// 	br2 = ""
	// }
	// brIndex = specialText.substring(0, spacePosition30).length
	// if (spacePosition30 >= specialText.length){
	// 	br3 = ""
	// }
	// specialText= specialText.substring(0, spacePosition10) + br + specialText.substring(spacePosition10+1, spacePosition20) + br2 + specialText.substring(spacePosition20+1, spacePosition30) + br3 + specialText.substring(spacePosition30+1, specialText.length)
	return specialText
}

function getPosition(str, m, i) {
   return str.split(m, i).join(m).length;
}

function convertFullHeroNameToRPC(heroName){
	var rpcName = "error"
	if (heroName == "npc_dota_hero_dragon_knight"){
		rpcName = "flamewaker"
	}else if (heroName == "npc_dota_hero_phantom_assassin"){
		rpcName = "voltex"
	}else if (heroName == "npc_dota_hero_necrolyte"){
		rpcName = "venomort"
	}else if (heroName == "npc_dota_hero_axe"){
		rpcName = "axe"
	}else if (heroName == "npc_dota_hero_drow_ranger"){
		rpcName = "astral"
	}else if (heroName == "npc_dota_hero_obsidian_destroyer"){
		rpcName = "epoch"
	}else if (heroName == "npc_dota_hero_omniknight"){
		rpcName = "paladin"
	}else if (heroName == "npc_dota_hero_crystal_maiden"){
		rpcName = "sorceress"
	}else if (heroName == "npc_dota_hero_invoker"){
		rpcName = "conjuror"
	}else if (heroName == "npc_dota_hero_juggernaut"){
		rpcName = "monk"
	}else if (heroName == "npc_dota_hero_beastmaster"){
		rpcName = "warlord"
	}else if (heroName == "npc_dota_hero_leshrac"){
		rpcName = "bahamut"
	}else if (heroName == "npc_dota_hero_spirit_breaker"){
		rpcName = "duskbringer"
	}else if (heroName == "npc_dota_hero_zuus"){
		rpcName = "auriun"
	}else if (heroName == "npc_dota_hero_templar_assassin"){
		rpcName = "trapper"	
	}else if (heroName == "npc_dota_hero_huskar"){
		rpcName = "spirit_warrior"	
	}else if (heroName == "npc_dota_hero_legion_commander"){
		rpcName = "mountain_protector"	
	}else if (heroName == "npc_dota_hero_night_stalker"){
		rpcName = "chernobog"	
	}else if (heroName == "npc_dota_hero_vengefulspirit"){
		rpcName = "solunia"	
	}else if (heroName == "npc_dota_hero_slardar"){
		rpcName = "hydroxis"	
	}else if (heroName == "npc_dota_hero_visage"){
		rpcName = "ekkan"	
	}else if (heroName == "npc_dota_hero_dark_seer"){
		rpcName = "zonik"	
	}else if (heroName == "npc_dota_hero_antimage"){
		rpcName = "arkimus"	
	}else if (heroName == "npc_dota_hero_monkey_king"){
		rpcName = "djanghor"	
	}else if (heroName == "tooltip_neutral"){
		rpcName = "neutral"
	}
	return rpcName
}