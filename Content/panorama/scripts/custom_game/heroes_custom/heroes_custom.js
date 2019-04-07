function updateSkillInTooltip(tooltip, queryUnit){
	if (tooltip.indexOf("@Ability") > -1){
			for (i = 1; i <= 4; i++) { 
				var heroName = Entities.GetClassname(queryUnit)
				var skillName = getSkillSlot2(queryUnit, i)
				var exp = new RegExp("@Ability"+i, "g")
				tooltip = tooltip.replace(exp, "<font color='#CCFF66'>"+$.Localize(skillName)+"</font>");
				tooltip = tooltip.replace(exp, "<font color='#CCFF66'>"+$.Localize(skillName)+"</font>");
			}
	}
	return tooltip
}

function updateSkillInTooltipByName(tooltip, heroName){
	if (tooltip.indexOf("@Ability") > -1){
		for (i = 1; i <= 4; i++) { 
			var skillName = getSkillSlot(heroName, i)
			var exp = new RegExp("@Ability"+i, "g")
			tooltip = tooltip.replace(exp, "<font color='#CCFF66'>"+$.Localize(skillName)+"</font>");
			tooltip = tooltip.replace(exp, "<font color='#CCFF66'>"+$.Localize(skillName)+"</font>");
		}
	}
	return tooltip
}

function replaceRuneTooltip(tooltip, queryUnit, requiredHero)
{
	var playerIndex = Entities.GetPlayerOwnerID( queryUnit )
	$.Msg(requiredHero)
	var heroName = convertFullHeroNameToRPC(requiredHero)
	$.Msg("----heroes_custom replaceRuneTooltip ")
	$.Msg(heroName)
	$.Msg("-----")
	if (tooltip.indexOf("[Q1]") > -1){
		if (queryUnit > 0){
			var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit1" ).runeUnit;
			var ability = Entities.GetAbility( skill_tree_data, 0 );
			tooltip = tooltip.replace(/\[Q1\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+Abilities.GetAbilityName( ability ))+"</font>");
		}else if (!(requiredHero == "")){
            tooltip = tooltip.replace(/\[Q1\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+heroName+"_rune_q_1")+"</font>");
		}
    }
    if (tooltip.indexOf("[Q2]") > -1) {
		if (queryUnit > 0){
			var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit2" ).runeUnit;
			var ability = Entities.GetAbility( skill_tree_data, 0 );
			tooltip = tooltip.replace(/\[Q2\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+Abilities.GetAbilityName( ability ))+"</font>");
		}else if (!(requiredHero == "")){
			tooltip = tooltip.replace(/\[Q2\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+heroName+"_rune_q_2")+"</font>");
		}
    }
    if (tooltip.indexOf("[Q3]") > -1) {
		if (queryUnit > 0){
			var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit3" ).runeUnit;
			var ability = Entities.GetAbility( skill_tree_data, 0 );
			tooltip = tooltip.replace(/\[Q3\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+Abilities.GetAbilityName( ability ))+"</font>");
		}else if (!(requiredHero == "")){
			tooltip = tooltip.replace(/\[Q3\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+heroName+"_rune_q_3")+"</font>");
		}
    }
    if (tooltip.indexOf("[Q4]") > -1) {
		if (queryUnit > 0){
			var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit4" ).runeUnit;
			var ability = Entities.GetAbility( skill_tree_data, 0 );
			tooltip = tooltip.replace(/\[Q4\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+Abilities.GetAbilityName( ability ))+"</font>");
		}else if (!(requiredHero == "")){
			tooltip = tooltip.replace(/\[Q4\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+heroName+"_rune_q_4")+"</font>");
		}
    }
    if (tooltip.indexOf("[W1]") > -1) {
		if (queryUnit > 0){
			var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit1" ).runeUnit;
			var ability = Entities.GetAbility( skill_tree_data, 1 );
			tooltip = tooltip.replace(/\[W1\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+Abilities.GetAbilityName( ability ))+"</font>");
		}else if (!(requiredHero == "")){
			tooltip = tooltip.replace(/\[W1\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+heroName+"_rune_w_1")+"</font>");
		}
    }
    if (tooltip.indexOf("[W2]") > -1) {
		if (queryUnit > 0){
			var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit2" ).runeUnit;
			var ability = Entities.GetAbility( skill_tree_data, 1 );
			tooltip = tooltip.replace(/\[W2\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+Abilities.GetAbilityName( ability ))+"</font>");
		}else if (!(requiredHero == "")){
			tooltip = tooltip.replace(/\[W2\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+heroName+"_rune_w_2")+"</font>");
		}
    }
    if (tooltip.indexOf("[W3]") > -1) {
		if (queryUnit > 0){
			var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit3" ).runeUnit;
			var ability = Entities.GetAbility( skill_tree_data, 1 );
			tooltip = tooltip.replace(/\[W3\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+Abilities.GetAbilityName( ability ))+"</font>");
		}else if (!(requiredHero == "")){
			tooltip = tooltip.replace(/\[W3\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+heroName+"_rune_w_3")+"</font>");
		}
    }
    if (tooltip.indexOf("[W4]") > -1) {
		if (queryUnit > 0){
			var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit4" ).runeUnit;
			var ability = Entities.GetAbility( skill_tree_data, 1 );
			tooltip = tooltip.replace(/\[W4\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+Abilities.GetAbilityName( ability ))+"</font>");
		}else if (!(requiredHero == "")){
			tooltip = tooltip.replace(/\[W4\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+heroName+"_rune_w_4")+"</font>");
		}
    }
    if (tooltip.indexOf("[E1]") > -1) {
		if (queryUnit > 0){
			var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit1" ).runeUnit;
			var ability = Entities.GetAbility( skill_tree_data, 2 );
			tooltip = tooltip.replace(/\[E1\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+Abilities.GetAbilityName( ability ))+"</font>");
		}else if (!(requiredHero == "")){
			tooltip = tooltip.replace(/\[E1\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+heroName+"_rune_e_1")+"</font>");
		}
    }
    if (tooltip.indexOf("[E2]") > -1) {
		if (queryUnit > 0){
			var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit2" ).runeUnit;
			var ability = Entities.GetAbility( skill_tree_data, 2 );
			tooltip = tooltip.replace(/\[E2\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+Abilities.GetAbilityName( ability ))+"</font>");
		}else if (!(requiredHero == "")){
			tooltip = tooltip.replace(/\[E2\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+heroName+"_rune_e_2")+"</font>");
		}
    }
    if (tooltip.indexOf("[E3]") > -1) {
		if (queryUnit > 0){
			var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit3" ).runeUnit;
			var ability = Entities.GetAbility( skill_tree_data, 2 );
			tooltip = tooltip.replace(/\[E3\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+Abilities.GetAbilityName( ability ))+"</font>");
		}else if (!(requiredHero == "")){
			tooltip = tooltip.replace(/\[E3\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+heroName+"_rune_e_3")+"</font>");
		}
    }
    if (tooltip.indexOf("[E4]") > -1) {
		if (queryUnit > 0){
			var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit4" ).runeUnit;
			var ability = Entities.GetAbility( skill_tree_data, 2 );
			tooltip = tooltip.replace(/\[E4\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+Abilities.GetAbilityName( ability ))+"</font>");
		}else if (!(requiredHero == "")){
			tooltip = tooltip.replace(/\[E4\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+heroName+"_rune_e_4")+"</font>");
		}
    }
    if (tooltip.indexOf("[R1]") > -1) {
		if (queryUnit > 0){
			var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit1" ).runeUnit;
			var ability = Entities.GetAbility( skill_tree_data, 3 );
			tooltip = tooltip.replace(/\[R1\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+Abilities.GetAbilityName( ability ))+"</font>");
		}else if (!(requiredHero == "")){
			tooltip = tooltip.replace(/\[R1\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+heroName+"_rune_r_1")+"</font>");
		}
    }
    if (tooltip.indexOf("[R2]") > -1) {
		if (queryUnit > 0){
			var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit2" ).runeUnit;
			var ability = Entities.GetAbility( skill_tree_data, 3 );
			tooltip = tooltip.replace(/\[R2\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+Abilities.GetAbilityName( ability ))+"</font>");
		}else if (!(requiredHero == "")){
			tooltip = tooltip.replace(/\[R2\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+heroName+"_rune_r_2")+"</font>");
		}
    }
    if (tooltip.indexOf("[R3]") > -1) {
		if (queryUnit > 0){
			var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit3" ).runeUnit;
			var ability = Entities.GetAbility( skill_tree_data, 3 );
			tooltip = tooltip.replace(/\[R3\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+Abilities.GetAbilityName( ability ))+"</font>");
		}else if (!(requiredHero == "")){
			tooltip = tooltip.replace(/\[R3\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+heroName+"_rune_r_3")+"</font>");
		}
    }
    if (tooltip.indexOf("[R4]") > -1) {
		if (queryUnit > 0){
			var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit4" ).runeUnit;
			var ability = Entities.GetAbility( skill_tree_data, 3 );
			tooltip = tooltip.replace(/\[R4\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+Abilities.GetAbilityName( ability ))+"</font>");
		}else if (!(requiredHero == "")){
			tooltip = tooltip.replace(/\[R4\]/g, "<font color='#7DFF12'>"+$.Localize("DOTA_Tooltip_Ability_"+heroName+"_rune_r_4")+"</font>");
		}
	}
	return tooltip
}

function getSkillSlot2(queryUnit, slot)
{
	if (slot == 4){
		slot = 6
	}
	var ability = Entities.GetAbility( queryUnit, slot - 1)
	var abilityName = Abilities.GetAbilityName( ability )
	if (abilityName == "blizzard" || abilityName == "ice_lance"){
		abilityName = "Tooltip_sorceress_q"
	}else if(abilityName == "pyroblast" || abilityName == "fireball"){
		abilityName = "Tooltip_sorceress_r"
	}else if(abilityName == "seinaru_hands_of_hikari"){
		abilityName = "Tooltip_seinaru_w"
	}else if(abilityName == "warlord_flame_rush" || abilityName == "warlord_ice_shell" || abilityName == "warlord_stone_form"){
		abilityName = "tooltip_warlord_q_abilities"
	}else if(abilityName == "axe_throw_earth" || abilityName == "axe_throw_ice" || abilityName == "axe_throw_fire"){
		abilityName = "Tooltip_throwing_axes"
	}else if(abilityName == "warlord_jump_earth" || abilityName == "warlord_jump_ice" || abilityName == "warlord_jump_fire"){
		abilityName = "Tooltip_jump_abilities"
	}else if(abilityName == "ability_whirling_flail"){
		abilityName = "tooltip_duskbringer_Q"
	}else if(abilityName == "trapper_arcana_venom_whip" || abilityName == "trapper_arcana_lasso"){
		abilityName = "item_property_trapper_arcana1"
	}else if(abilityName == "fulminating_trap" || abilityName == "net_trap" || abilityName == "poison_trap" || abilityName == "torrent_trap"){
		abilityName = "tooltip_trapper_q"
	}else if(abilityName == "explosive_bomb" || abilityName == "smoke_bomb"){
		abilityName = "tooltip_trapper_w"
	}else if(abilityName == "trapper_vanish" || abilityName == "trapper_action_leap"){
		abilityName = "tooltip_trapper_e"
	}else if(abilityName == "trapper_stealth" || abilityName == "trapper_backstab"){
		abilityName = "DOTA_Tooltip_ability_trapper_backstab"
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
	}else if(abilityName == "slipfinn_shadow_rush" || abilityName == "slipfinn_shadow_warp"){
		abilityName = "slipfinn_e"
	}else if(abilityName == "dinath_arctic_burn" || abilityName == "dinath_scorch_charge"){
		abilityName = "DOTA_Tooltip_ability_dinath_arctic_burn"
	}else{
		abilityName = "DOTA_Tooltip_Ability_"+abilityName
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
	}else if (heroName == "npc_dota_hero_monkey_king"){
		skillName = getDjanghorSkill(slot)
	}else if (heroName == "npc_dota_hero_slark"){
		skillName = getSlipfinnSkill(slot)
	}else if (heroName == "npc_dota_hero_skywrath_mage"){
		skillName = getSephyrSkill(slot)
	}else if (heroName == "npc_dota_hero_winter_wyvern"){
		skillName = getDinathSkill(slot)
	}else if (heroName == "npc_dota_hero_arc_warden"){
		skillName = getJexSkill(slot)
	}
	return skillName
}

function getFlamewakerSkill(slot){
	var skillName = ""
	if (slot == 1){
        skillName = "DOTA_Tooltip_Ability_seismic_flare"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_Ability_second_heartbeat"
	}else if(slot == 3){
        skillName = "DOTA_Tooltip_Ability_heat_wave"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_Ability_cataclysm"
	}
	return skillName
}

function getVoltexSkill(slot){
	var skillName = ""
	if (slot == 1){
        skillName = "DOTA_Tooltip_Ability_overcharge"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_Ability_ability_zap"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_Ability_electric_jump"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_Ability_static_field"
	}
	return skillName
}

function getVenoSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_Ability_gale_nova"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_Ability_nether_blaster"
	}else if(slot == 3){
        skillName = "DOTA_Tooltip_Ability_venomort_ghost_warp"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_Ability_snake_trap"
	}
	return skillName
}

function getAxeSkill(slot){
	var skillName = ""
	if (slot == 1){
        skillName = "DOTA_Tooltip_Ability_red_general_skull_basher"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_Ability_backshock"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_Ability_whirlwind"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_Ability_sunder"
	}
	return skillName
}

function getAstralSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_Ability_moon_shroud"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_Ability_split_shot"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_Ability_star_blink"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_Ability_ranger_aoe_explosion"	
	}
	return skillName
}

function getEpochSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_Ability_epoch_time_binder"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_Ability_time_genesis_orb"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_Ability_time_warp"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_Ability_eternity_flood"	
	}
	return skillName
}

function getPaladinSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_Ability_heroic_fury"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_Ability_justice_overwhelming"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_Ability_crusader_dash"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_Ability_knights_disciple"	
	}
	return skillName
}

function getSorcSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "Tooltip_sorceress_q"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_Ability_arcane_explosion"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_Ability_sorceress_blink"
	}else if(slot == 4){
		skillName = "Tooltip_sorceress_r"
	}
	return skillName
}

function getConjurorSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_Ability_earthquake"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_Ability_immolation"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_Ability_shadow_gate"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_Ability_call_of_elements"
	}
	return skillName
}

function getMonkSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_Ability_seinaru_konokaze"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_Ability_seinaru_hands_of_hikari"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_Ability_seinaru_odachi_leap"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_Ability_seinaru_gorudo"
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
		skillName = "DOTA_Tooltip_Ability_elemental_overload_2"
	}
	return skillName
}

function getBahamutSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_Ability_leshrac_wall"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_Ability_leshrac_nuke"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_Ability_leshrac_blink"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_Ability_charge_of_light"
	}
	return skillName
}

function getDuskbringerSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "tooltip_duskbringer_Q"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_Ability_ghost_hallow"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_Ability_specter_rush"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_Ability_seven_visions"
	}
	return skillName
}

function getAuriunSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_Ability_heavens_shield"
	}else if(slot == 2){
		skillName = "tooltip_auriun_w"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_Ability_seraph_surge"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_Ability_auriun_ult"
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
		skillName = "DOTA_Tooltip_Ability_trapper_backstab"
	}
	return skillName
}

function getSpiritWarriorSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "spirit_warrior_q_ability"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_Ability_spirit_warrior_soul_thrust"
	}else if(slot == 3){
		skillName = "spirit_warrior_e_ability"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_Ability_spirit_warrior_ancient_vigor"
	}
	return skillName
}

function getMountainProtectorSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_Ability_mountain_protector_shockwave"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_Ability_mountain_protector_mountain_guardian"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_Ability_mountain_protector_emberstone"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_Ability_mountain_protector_aeon_fracture"
	}
	return skillName
}

function getChernobogSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_Ability_chernobog_charons_claw"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_Ability_chernobog_demon_hunter"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_Ability_chernobog_shadow_walk"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_Ability_chernobog_nights_procession"
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
		skillName = "DOTA_Tooltip_Ability_hydroxis_hydro_pump"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_Ability_hydroxis_water_blade"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_Ability_hydroxis_slippery_tail"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_Ability_hydroxis_tsunami"
	}
	return skillName	
}

function getEkkanSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_Ability_ekkan_dominion"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_Ability_ekkan_summon_skeleton"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_Ability_ekkan_river_of_souls"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_Ability_ekkan_supercharge"
	}
	return skillName	
}

function getZonikSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_Ability_tachyon_shell"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_Ability_zonik_mach_punch"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_Ability_zonik_lightspeed"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_Ability_zonik_speedball"
	}
	return skillName	
}

function getArkimusSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_Ability_arkimus_zonis_spark"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_Ability_arkimus_storm_weapon"	
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_ability_ark_jump"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_Ability_arkimus_energy_field"
	}
	return skillName	
}

function getDjanghorSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "djanghor_q"
	}else if(slot == 2){
		skillName = "djanghor_w"	
	}else if(slot == 3){
		skillName = "djanghor_e"
	}else if(slot == 4){
		skillName = "djanghor_r"
	}
	return skillName	
}

function getSlipfinnSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_Ability_slipfinn_prone"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_Ability_slipfinn_jump"	
	}else if(slot == 3){
		skillName = "slipfinn_e"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_Ability_slipfinn_bubble_possession"
	}
	return skillName	
}

function getSephyrSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_ability_sephyr_lightbomb"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_ability_piercing_gale"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_ability_sephyr_strafe"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_blessing_of_nefali"
	}
	return skillName	
}

function getDinathSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "DOTA_Tooltip_ability_dinath_arctic_burn"
	}else if(slot == 2){
		skillName = "DOTA_Tooltip_ability_dinath_drake_ring"
	}else if(slot == 3){
		skillName = "DOTA_Tooltip_ability_dinath_dragon_dive"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_dinath_hyper_beam"
	}
	return skillName	
}

function getJexSkill(slot){
	var skillName = ""
	if (slot == 1){
		skillName = "tooltip_jex_q"
	}else if(slot == 2){
		skillName = "tooltip_jex_w"
	}else if(slot == 3){
		skillName = "tooltip_jex_e"
	}else if(slot == 4){
		skillName = "DOTA_Tooltip_ability_jex_essence_harvest"
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
	"npc_dota_hero_dark_seer", "npc_dota_hero_antimage", "npc_dota_hero_monkey_king", "npc_dota_hero_slark", "npc_dota_hero_skywrath_mage", "npc_dota_hero_winter_wyvern", "npc_dota_hero_arc_warden"]
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
		rpcName = "seinaru"
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
	}else if (heroName == "npc_dota_hero_slark"){
		rpcName = "slipfinn"
	}else if (heroName == "npc_dota_hero_skywrath_mage"){
		rpcName = "sephyr"
	}else if (heroName == "npc_dota_hero_winter_wyvern"){
		rpcName = "dinath"
	}else if (heroName == "npc_dota_hero_arc_warden"){
		rpcName = "jex"
	}else if (heroName == "tooltip_neutral"){
		rpcName = "neutral"
	}
	return rpcName
}