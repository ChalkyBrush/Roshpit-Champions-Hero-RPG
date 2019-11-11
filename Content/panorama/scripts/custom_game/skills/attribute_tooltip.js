HEALTH_PER_STR = 10
HEALTH_REGEN_PER_STR = 0.5
ARMOR_PER_STR = 2

ATTACKSPEED_PER_AGI = 0.3
MOVESPEED_PER_AGI = 0.1
ARMOR_PIERCE_PER_AGI = 2

MANA_PER_INT = 5
MANA_REGEN_PER_INT = 0.5
SPELL_PIERCE_PER_INT = 2

STATUS_RESIST_PER_SPIRIT = 0.01
BASE_ABILITY_DAMAGE_PER_SPIRIT = 0.1
MAGIC_ARMOR_PER_SPIRIT = 2

ATK_DMG_PER_PRIMARY = 1

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
	var halcyonMult = 1
	if (GameUI.StatQueryData.halcyon == 1){
		halcyonMult = 1.5
	}
	$('#tooltip_title').text = "<font color='"+nameColor+"'>"+$.Localize(name)+"</font>"
	$('#tooltip_level').text = "Lv "+level
	if (Entities.IsHero( queryUnit )){
		$('#attribute_title_strength').text = $.Localize("#item_strength")
		$('#attribute_title_agility').text = $.Localize("#item_agility")
		$('#attribute_title_int').text = $.Localize("#item_intelligence")
		$('#attribute_title_spr').text = $.Localize("#item_spirit")

		var heroAttributes = CustomNetTables.GetTableValue( "hero_index", queryUnit.toString()+"_attributes" );

		$('#attribute_value_strength').text = numberWithCommas(heroAttributes.strength)
		$('#attribute_value_agility').text = numberWithCommas(heroAttributes.agility)
		$('#attribute_value_int').text = numberWithCommas(heroAttributes.intelligence)
		$('#attribute_value_spr').text = numberWithCommas(heroAttributes.spirit)

		var healthBonus = heroAttributes.strength*HEALTH_PER_STR*halcyonMult
		var healthRegenBonus = parseInt(heroAttributes.strength*HEALTH_REGEN_PER_STR*halcyonMult)
		var armorBonus = parseInt(heroAttributes.strength*ARMOR_PER_STR*halcyonMult)
		$('#attribute_given_bonus_str_1_left').text = "<font color='#FFFFFF'>HP</font>"
		$('#attribute_given_bonus_str_1_right').text = "+"+numberWithCommas(healthBonus)

		$('#attribute_given_bonus_str_2_left').text = "<font color='#FFFFFF'>"+$.Localize('#ui_regen')+"</font>"
		$('#attribute_given_bonus_str_2_right').text = "+"+numberWithCommas(healthRegenBonus)

		$('#attribute_given_bonus_str_3_left').text = "<font color='#FFFFFF'>"+$.Localize('#item_armor')+"</font>"
		$('#attribute_given_bonus_str_3_right').text = "+"+numberWithCommas(armorBonus)

		var atkspdBonus = parseInt(heroAttributes.agility*ATTACKSPEED_PER_AGI*halcyonMult)
		var movespeedBonus = parseInt(heroAttributes.agility*MOVESPEED_PER_AGI*halcyonMult)
		var armorPierceBonus = parseInt(heroAttributes.agility*ARMOR_PIERCE_PER_AGI*halcyonMult)

		$('#attribute_given_bonus_agi_1_left').text = "<font color='#FFFFFF'>"+$.Localize('#item_attack_speed')+"</font>"
		$('#attribute_given_bonus_agi_1_right').text = "+"+numberWithCommas(atkspdBonus)

		$('#attribute_given_bonus_agi_2_left').text = "<font color='#FFFFFF'>"+$.Localize('#item_movespeed')+"</font>"
		$('#attribute_given_bonus_agi_2_right').text = "+"+numberWithCommas(movespeedBonus)

		$('#attribute_given_bonus_agi_3_left').text = "<font color='#FFFFFF'>"+$.Localize('#item_armor_pierce')+"</font>"
		$('#attribute_given_bonus_agi_3_right').text = "+"+numberWithCommas(armorPierceBonus)

		var manaBonus = parseInt(heroAttributes.intelligence*MANA_PER_INT*halcyonMult)
		var manaRegenBonus = parseInt(heroAttributes.intelligence*MANA_REGEN_PER_INT*halcyonMult)
		var spellPierceBonus = parseInt(heroAttributes.intelligence*SPELL_PIERCE_PER_INT*halcyonMult)

		$('#attribute_given_bonus_int_1_left').text = "<font color='#FFFFFF'>"+"Mana"+"</font>"
		$('#attribute_given_bonus_int_1_right').text = "+"+numberWithCommas(manaBonus)

		$('#attribute_given_bonus_int_2_left').text = "<font color='#FFFFFF'>"+$.Localize('#item_mana_regen')+"</font>"
		$('#attribute_given_bonus_int_2_right').text = "+"+numberWithCommas(manaRegenBonus)

		$('#attribute_given_bonus_int_3_left').text = "<font color='#FFFFFF'>"+$.Localize('#item_spell_pierce')+"</font>"
		$('#attribute_given_bonus_int_3_right').text = "+"+numberWithCommas(spellPierceBonus)

		var statusResistBonus = Math.round(heroAttributes.spirit*STATUS_RESIST_PER_SPIRIT*halcyonMult*100)/100
		var base_ability_damage = parseInt(heroAttributes.spirit*BASE_ABILITY_DAMAGE_PER_SPIRIT*halcyonMult)
		var magicArmorBonus = parseInt(heroAttributes.spirit*MAGIC_ARMOR_PER_SPIRIT*halcyonMult)
		$('#attribute_given_bonus_spr_1_left').text = "<font color='#FFFFFF'>"+$.Localize('#item_status_resist')+"</font>"
		$('#attribute_given_bonus_spr_1_right').text = "+"+statusResistBonus+"%"

		$('#attribute_given_bonus_spr_2_left').text = "<font color='#FFFFFF'>"+$.Localize('#ui_base_ability_damage')+"</font>"
		$('#attribute_given_bonus_spr_2_right').text = "+"+numberWithCommas(base_ability_damage)+"%"

		$('#attribute_given_bonus_spr_3_left').text = "<font color='#FFFFFF'>"+$.Localize('#item_magic_armor')+"</font>"
		$('#attribute_given_bonus_spr_3_right').text = "+"+numberWithCommas(magicArmorBonus)		

		var primaryAttribute = parseInt(heroAttributes.primaryAttribute)
		if (primaryAttribute == 0){
			var atkBonus = parseInt(heroAttributes.strength*ATK_DMG_PER_PRIMARY*halcyonMult)
			$('#attribute_given_bonus_str_4_left').text = "<font color='#FFFFFF'>"+$.Localize('#ui_attack_damage')+"</font>"
			$('#attribute_given_bonus_str_4_right').text = "+"+numberWithCommas(atkBonus)
			$('#attribute_image_strength').AddClass('primary_attribute')

			$('#attribute_given_bonus_agi_4_left').text = ""
			$('#attribute_given_bonus_agi_4_right').text = ""

			$('#attribute_given_bonus_int_4_left').text = ""
			$('#attribute_given_bonus_int_4_right').text = ""

			$('#attribute_given_bonus_spr_4_left').text = ""
			$('#attribute_given_bonus_spr_4_right').text = ""
		}else if(primaryAttribute == 1){
			var atkBonus = parseInt(heroAttributes.agility*ATK_DMG_PER_PRIMARY*halcyonMult)
			$('#attribute_given_bonus_agi_4_left').text = "<font color='#FFFFFF'>"+$.Localize('#ui_attack_damage')+"</font>"
			$('#attribute_given_bonus_agi_4_right').text = "+"+numberWithCommas(atkBonus)
			$('#attribute_image_agility').AddClass('primary_attribute')	
			$('#attribute_given_bonus_str_4_left').text = ""
			$('#attribute_given_bonus_str_4_right').text = ""

			$('#attribute_given_bonus_int_4_left').text = ""
			$('#attribute_given_bonus_int_4_right').text = ""
			$('#attribute_given_bonus_spr_4_left').text = ""
			$('#attribute_given_bonus_spr_4_right').text = ""	
		}else if(primaryAttribute == 2){
			var atkBonus = parseInt(heroAttributes.intelligence*ATK_DMG_PER_PRIMARY*halcyonMult)
			$('#attribute_given_bonus_int_4_left').text = "<font color='#FFFFFF'>"+$.Localize('#ui_attack_damage')+"</font>"
			$('#attribute_given_bonus_int_4_right').text = "+"+numberWithCommas(atkBonus)
			$('#attribute_image_int').AddClass('primary_attribute')	
			$('#attribute_given_bonus_agi_4_left').text = ""
			$('#attribute_given_bonus_agi_4_right').text = ""

			$('#attribute_given_bonus_str_4_left').text = ""
			$('#attribute_given_bonus_str_4_right').text = ""
			$('#attribute_given_bonus_spr_4_left').text = ""
			$('#attribute_given_bonus_spr_4_right').text = ""	
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
	// $.Msg(atkTime)
	var atkSpdValue = Math.min(atkSpd, 890) + " ("+atkTime+"s)"
	$('#atk_3_right').text = atkSpdValue

	$('#atk_4_left').text = $.Localize("#ui_attack_range")
	var attackRange = Entities.GetAttackRange( queryUnit )
	$('#atk_4_right').text = numberWithCommas(attackRange)

	$('#atk_5_left').text = $.Localize("#item_armor_pierce")
	$('#atk_5_right').text = numberWithCommas(GameUI.StatQueryData.roshpit_armor_pierce)

	$('#atk_6_left').text = $.Localize("#item_spell_pierce")
	$('#atk_6_right').text = numberWithCommas(GameUI.StatQueryData.roshpit_spell_pierce)

	$('#attack_defense_subtitle_base_ability').text = $.Localize('#ui_base_ability_damage')
	$('#base_ability_title_q').text = "Q"
	$('#base_ability_value_q').text = parseInt(GameUI.StatQueryData.qAmp)/1 + "%"

	$('#base_ability_title_w').text = "W"
	$('#base_ability_value_w').text = parseInt(GameUI.StatQueryData.wAmp)/1 + "%"

	$('#base_ability_title_e').text = "E"
	$('#base_ability_value_e').text = parseInt(GameUI.StatQueryData.eAmp)/1 + "%"

	$('#base_ability_title_r').text = "R"
	$('#base_ability_value_r').text = parseInt(GameUI.StatQueryData.rAmp)/1 + "%"

	// $('#post_mit_phys_damage_title').text = $.Localize("#DOTA_ToolTip_Damage_Physical")
	// $('#post_mit_phys_damage_value').text = parseInt(GameUI.StatQueryData.phys_post_mit)/1 + "%"

	// $('#post_mit_magic_damage_title').text = $.Localize("#DOTA_ToolTip_Damage_Magical")
	// $('#post_mit_magic_damage_value').text = parseInt(GameUI.StatQueryData.magic_post_mit)/1 + "%"

	// $('#post_mit_pure_damage_title').text = $.Localize("#DOTA_ToolTip_Damage_Pure")
	// $('#post_mit_pure_damage_value').text = parseInt(GameUI.StatQueryData.pure_post_mit)/1 + "%"

	$('#item_damage_title').text = $.Localize("#ui_item")
	$('#item_damage_value').text = parseInt(GameUI.StatQueryData.item_damage)/1 + "%"
	//DEFENSE

	$('#attack_defense_title_def').text = $.Localize("#ui_defense").toUpperCase()
	$('#def_1_left').text = $.Localize("#item_armor")
    var physArmor = GameUI.StatQueryData.base_roshpit_armor
	$('#def_1_right').text = numberWithCommas(physArmor)
	var bonusArmor = parseInt(GameUI.StatQueryData.roshpit_armor - GameUI.StatQueryData.base_roshpit_armor)
	$('#def_2_left').text = $.Localize("#ui_bonus_armor")
	if (bonusArmor >= 0){
		$('#def_2_right').text = "<font color='#68ff23'>+"+numberWithCommas(bonusArmor)+"</font>"
	}else{
		$('#def_2_right').text = "<font color='#ff0000'>"+numberWithCommas(bonusArmor)+"</font>"
	}

	$('#def_3_left').text = $.Localize("#ui_physical_reduction")
	var totalArmor = physArmor + bonusArmor
	var resist = 1 - (255 / (255 + totalArmor))
	resist = (parseInt(resist*10000))/100
	$('#def_3_right').text = resist+"%"

	$('#def_4_left').text = $.Localize("#item_magic_armor")
    var magic_armor = GameUI.StatQueryData.base_roshpit_magic_armor
	$('#def_4_right').text = numberWithCommas(magic_armor)
	var bonus_magic_armor = parseInt(GameUI.StatQueryData.roshpit_magic_armor - GameUI.StatQueryData.base_roshpit_magic_armor)
	$('#def_5_left').text = $.Localize("#bonus_magic_armor")
	if (bonus_magic_armor >= 0){
		$('#def_5_right').text = "<font color='#68ff23'>+"+numberWithCommas(bonus_magic_armor)+"</font>"
	}else{
		$('#def_5_right').text = "<font color='#ff0000'>"+numberWithCommas(bonus_magic_armor)+"</font>"
	}

	$('#def_6_left').text = $.Localize("#tooltip_magic_armor")
	var total_magic_armor = magic_armor + bonus_magic_armor
	var resist = 1 - (255 / (255 + total_magic_armor))
	resist = (parseInt(resist*10000))/100
	$('#def_6_right').text = resist+"%"
	
	// $.Msg(GameUI.StatQueryData)
	$('#attack_defense_subtitle_resist').text = $.Localize('ui_additional_resistance')

	var phys_resist = GameUI.StatQueryData.phys
	$('#resist_title_phys').text = $.Localize("#DOTA_ToolTip_Damage_Physical")
	$('#resist_value_phys').text = phys_resist+"%"

	var magic_resist = GameUI.StatQueryData.magic
	$('#resist_title_magic').text = $.Localize("#DOTA_ToolTip_Damage_Magical")
	$('#resist_value_magic').text = magic_resist+"%"

	var pure_resist = GameUI.StatQueryData.pure
	$('#resist_title_pure').text = $.Localize("#DOTA_ToolTip_Damage_Pure")
	$('#resist_value_pure').text = pure_resist+"%"

	if (Entities.IsHero(queryUnit)){
		$("#elements_title").text = $.Localize("#ui_elements").toUpperCase()
		$("#post_mit_and_item_damage_title").text = $.Localize("#ui_most_mit_and_item_global")
	}else{
		$("#elements_title").text = $.Localize("#ui_elements_resist").toUpperCase()
		$("#post_mit_and_item_damage_title").text = $.Localize("#ui_most_mit_and_item_single")
	}
	var parent = $('#element_row1')
	for ( var i = 1; i <= 18; ++i ){
		var board = $('#element'+i)
		board.FindChildTraverse('element_title'+i).SetImage("file://{images}/custom_game/ui/elements/element"+i+".png")
		board.FindChildTraverse('element_value'+i).text = Math.round(GameUI.StatQueryData.elements[i])+"%"
	}
	//movement
	$('#attack_defense_subtitle_movement').text = $.Localize("ui_movement")
	$('#move_1_left').text = $.Localize("ui_base_movement_speed")
	$('#move_2_left').text = $.Localize("ui_bonus_movement_speed")
	$('#move_3_left').text = $.Localize("ui_max_movement_speed")

	$('#move_1_right').text = GameUI.StatQueryData.movespeed
	$('#move_2_right').text = "<font color='#68ff23'>+"+GameUI.StatQueryData.movespeed_bonus+"</font>"
	$('#move_3_right').text = GameUI.StatQueryData.max_ms

	// HANDLE NON HERO
	if (Entities.IsHero( queryUnit )){
		$('#attributes_main_container').RemoveClass('invisible')
		$('#base_ability_container').RemoveClass('invisible')
		$('#attack_defense_subtitle_base_ability').RemoveClass('invisible')
		$('#elements_container').RemoveClass('invisible')
	}else{
		$('#attributes_main_container').AddClass('invisible')
		$('#base_ability_container').AddClass('invisible')
		$('#attack_defense_subtitle_base_ability').AddClass('invisible')
		// $('#elements_container').AddClass('invisible')
	}
	$.Schedule(0.3, function(){
		GameEvents.SendCustomGameEventToServer( "stats_hover", {playerID: Game.GetLocalPlayerID(), queryunit: Players.GetLocalPlayerPortraitUnit()});
	})
}

function init(){
	$.GetContextPanel().style.backgroundColor = "#1A1A1A"
	// $.Msg("INIT")
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

(function()
{
	init();
})();
