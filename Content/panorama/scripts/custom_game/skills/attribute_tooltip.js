HEALTH_PER_STR = 20
HEALTH_REGEN_PER_STR = 0.1

ATTACKSPEED_PER_AGI = 0.04
ARMOR_PER_AGI = 0.1

MANA_PER_INT = 5
MANA_REGEN_PER_INT = 0.1

ATK_DMG_PER_PRIMARY = 2

function initializeTooltip(func){
	// $.Msg(func)
	var queryUnit = GameUI.AttributeQueryUnit
	var name = Entities.GetUnitName( queryUnit )
	var level = GameUI.StatQueryData.level
	var nameColor = "#FFFFFF"
	
	if(GameUI.StatQueryData.paragon == 1){
		$('#paragon-skull').RemoveClass('invisible')
		nameColor = "#FFDA44"
	}else{
		$('#paragon-skull').AddClass('invisible')
	}
	$('#tooltip_title').text = "<font color='"+nameColor+"'>"+$.Localize(name)+"</font>"
	$('#tooltip_level').text = "Lv "+level
	if (Entities.IsHero( queryUnit )){
		$('#attribute_title_strength').text = $.Localize("#item_strength")
		$('#attribute_title_agility').text = $.Localize("#item_agility")
		$('#attribute_title_int').text = $.Localize("#item_intelligence")

		var heroAttributes = CustomNetTables.GetTableValue( "hero_index", queryUnit.toString()+"_attributes" );

		$('#attribute_value_strength').text = numberWithCommas(heroAttributes.strength)
		$('#attribute_value_agility').text = numberWithCommas(heroAttributes.agility)
		$('#attribute_value_int').text = numberWithCommas(heroAttributes.intelligence)

		var healthBonus = heroAttributes.strength*HEALTH_PER_STR
		var healthRegenBonus = parseInt(heroAttributes.strength*HEALTH_REGEN_PER_STR)
		$('#attribute_given_bonus_str_1_left').text = "<font color='#FFFFFF'>HP</font>"
		$('#attribute_given_bonus_str_1_right').text = "+"+numberWithCommas(healthBonus)

		$('#attribute_given_bonus_str_2_left').text = "<font color='#FFFFFF'>"+$.Localize('#ui_regen')+"</font>"
		$('#attribute_given_bonus_str_2_right').text = "+"+numberWithCommas(healthRegenBonus)

		var atkspdBonus = parseInt(heroAttributes.agility*ATTACKSPEED_PER_AGI)
		var armorBonus = parseInt(heroAttributes.agility*ARMOR_PER_AGI)

		$('#attribute_given_bonus_agi_1_left').text = "<font color='#FFFFFF'>"+$.Localize('#item_attack_speed')+"</font>"
		$('#attribute_given_bonus_agi_1_right').text = "+"+numberWithCommas(atkspdBonus)

		$('#attribute_given_bonus_agi_2_left').text = "<font color='#FFFFFF'>"+$.Localize('#item_armor')+"</font>"
		$('#attribute_given_bonus_agi_2_right').text = "+"+numberWithCommas(armorBonus)

		var manaBonus = parseInt(heroAttributes.intelligence*MANA_PER_INT)
		var manaRegenBonus = parseInt(heroAttributes.intelligence*MANA_REGEN_PER_INT)

		$('#attribute_given_bonus_int_1_left').text = "<font color='#FFFFFF'>"+"Mana"+"</font>"
		$('#attribute_given_bonus_int_1_right').text = "+"+numberWithCommas(manaBonus)

		$('#attribute_given_bonus_int_2_left').text = "<font color='#FFFFFF'>"+$.Localize('#item_mana_regen')+"</font>"
		$('#attribute_given_bonus_int_2_right').text = "+"+numberWithCommas(manaRegenBonus)

		var primaryAttribute = parseInt(heroAttributes.primaryAttribute)
		if (primaryAttribute == 0){
			var atkBonus = parseInt(heroAttributes.strength*ATK_DMG_PER_PRIMARY)
			$('#attribute_given_bonus_str_3_left').text = "<font color='#FFFFFF'>"+$.Localize('#ui_attack_damage')+"</font>"
			$('#attribute_given_bonus_str_3_right').text = "+"+numberWithCommas(atkBonus)
			$('#attribute_image_strength').AddClass('primary_attribute')
		}else if(primaryAttribute == 1){
			var atkBonus = parseInt(heroAttributes.agility*ATK_DMG_PER_PRIMARY)
			$('#attribute_given_bonus_agi_3_left').text = "<font color='#FFFFFF'>"+$.Localize('#ui_attack_damage')+"</font>"
			$('#attribute_given_bonus_agi_3_right').text = "+"+numberWithCommas(atkBonus)
			$('#attribute_image_agility').AddClass('primary_attribute')		
		}else if(primaryAttribute == 2){
			var atkBonus = parseInt(heroAttributes.intelligence*ATK_DMG_PER_PRIMARY)
			$('#attribute_given_bonus_int_3_left').text = "<font color='#FFFFFF'>"+$.Localize('#ui_attack_damage')+"</font>"
			$('#attribute_given_bonus_int_3_right').text = "+"+numberWithCommas(atkBonus)
			$('#attribute_image_int').AddClass('primary_attribute')		
		}
	}

	//ATTACK

	$('#attack_defense_title_atk').text = $.Localize("#ui_attack").toUpperCase()
	$('#atk_1_left').text = $.Localize("#ui_attack_damage_full")
	var baseDMG = parseInt((Entities.GetDamageMax(queryUnit)+Entities.GetDamageMin(queryUnit))/2)
	$('#atk_1_right').text = numberWithCommas(baseDMG)
	var bonusDMG = Entities.GetDamageBonus(queryUnit)
	$('#atk_2_left').text = $.Localize("#ui_bonus_attack_damage")
	if (bonusDMG >= 0){
		$('#atk_2_right').text = "<font color='#68ff23'>+"+numberWithCommas(bonusDMG)+"</font>"
	}else{
		$('#atk_2_right').text = "<font color='#ff0000'>"+numberWithCommas(bonusDMG)+"</font>"
	}

	$('#atk_3_left').text = $.Localize("#ui_attack_speed")
	var atkSpd =  parseInt(Entities.GetAttackSpeed( queryUnit )*100)
	var atkTime = 1/(parseInt(Entities.GetAttacksPerSecond( queryUnit )*100)/100)
	atkTime = (parseInt(atkTime*100))/100
	$.Msg(atkTime)
	var atkSpdValue = Math.min(atkSpd, 890) + " ("+atkTime+"s)"
	$('#atk_3_right').text = atkSpdValue

	$('#atk_4_left').text = $.Localize("#ui_attack_range")
	var attackRange = Entities.GetAttackRange( queryUnit )
	$('#atk_4_right').text = numberWithCommas(attackRange)

	$('#attack_defense_subtitle_base_ability').text = $.Localize('#ui_base_ability_damage')
	$('#base_ability_title_q').text = "Q"
	$('#base_ability_value_q').text = parseInt(GameUI.StatQueryData.qAmp)/100 + "%"

	$('#base_ability_title_w').text = "W"
	$('#base_ability_value_w').text = parseInt(GameUI.StatQueryData.wAmp)/100 + "%"

	$('#base_ability_title_e').text = "E"
	$('#base_ability_value_e').text = parseInt(GameUI.StatQueryData.eAmp)/100 + "%"

	$('#base_ability_title_r').text = "R"
	$('#base_ability_value_r').text = parseInt(GameUI.StatQueryData.rAmp)/100 + "%"
	//DEFENSE

	$('#attack_defense_title_def').text = $.Localize("#ui_defense").toUpperCase()
	$('#def_1_left').text = $.Localize("#item_armor")
	var physArmor = parseInt(Entities.GetPhysicalArmorValue(queryUnit))
	$('#def_1_right').text = numberWithCommas(physArmor)
	var bonusArmor = parseInt(Entities.GetBonusPhysicalArmor(queryUnit))
	$('#def_2_left').text = $.Localize("#ui_bonus_armor")
	if (bonusArmor >= 0){
		$('#def_2_right').text = "<font color='#68ff23'>+"+numberWithCommas(bonusArmor)+"</font>"
	}else{
		$('#def_2_right').text = "<font color='#ff0000'>"+numberWithCommas(bonusArmor)+"</font>"
	}

	$('#def_3_left').text = $.Localize("#ui_physical_reduction")
	var totalArmor = physArmor + bonusArmor
	var resist = (0.05*totalArmor/(1 + (0.05 * Math.abs(totalArmor))))
	resist = (parseInt(resist*100000))/1000
	$('#def_3_right').text = resist+"%"

	$('#def_4_left').text = $.Localize("#item_magic_resist")
	var magRes = parseInt(Entities.GetMagicalArmorValue( queryUnit)*10000)/100
	$('#def_4_right').text = magRes+"%"
	
	$.Msg(GameUI.StatQueryData)
	$('#attack_defense_subtitle_resist').text = $.Localize('ui_additional_resistance')

	var phys_resist = parseInt(GameUI.StatQueryData.phys)/1000
	$('#resist_title_phys').text = $.Localize("#DOTA_ToolTip_Damage_Physical")
	$('#resist_value_phys').text = phys_resist+"%"

	var magic_resist = parseInt(GameUI.StatQueryData.magic)/1000
	$('#resist_title_magic').text = $.Localize("#DOTA_ToolTip_Damage_Magical")
	$('#resist_value_magic').text = magic_resist+"%"

	var pure_resist = parseInt(GameUI.StatQueryData.pure)/1000
	$('#resist_title_pure').text = $.Localize("#DOTA_ToolTip_Damage_Pure")
	$('#resist_value_pure').text = pure_resist+"%"

	// HANDLE NON HERO
	if (Entities.IsHero( queryUnit )){
		$('#attributes_main_container').RemoveClass('invisible')
		$('#base_ability_container').RemoveClass('invisible')
		$('#attack_defense_subtitle_base_ability').RemoveClass('invisible')
	}else{
		$('#attributes_main_container').AddClass('invisible')
		$('#base_ability_container').AddClass('invisible')
		$('#attack_defense_subtitle_base_ability').AddClass('invisible')
	}
}

function init(){
	$.GetContextPanel().style.backgroundColor = "#1A1A1A"
	$.Msg("INIT")
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

(function()
{
	init();
})();
