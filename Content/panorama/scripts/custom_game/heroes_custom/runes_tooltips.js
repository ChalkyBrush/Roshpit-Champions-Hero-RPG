function initializeTooltip(func){
	// $.Msg(func)
	// $.Msg("INIT TOOLTIP")
	var rune = GameUI.CustomUIConfig.runeTooltip
	var abilityNameInternal = Abilities.GetAbilityName( rune );

	$.Msg(Abilities.GetCaster( rune ).toString()+"-runeUnit")
	var runeUnitTable = CustomNetTables.GetTableValue( "player_stats", Abilities.GetCaster( rune ).toString()+"-runeUnit");
	var queryUnit = runeUnitTable.hero
	var abilityName = $.Localize("DOTA_Tooltip_Ability_"+abilityNameInternal)
	//TITLE

	var title = abilityName
	$('#tooltip_title').text = title

	var baseLevel = Abilities.GetLevel(rune)
	var rune_bonus = GetRuneBonus(queryUnit, GetRuneSlot(abilityNameInternal))
	var total_level = baseLevel + rune_bonus
	var level_line = "Level: "+total_level
	$('#rune_level_title').text = "<font color='#DDDDDD'>Level</font> "+total_level
	// $('#rune_level_value').text = total_level

	var blockCount = 0
	var baseAbilityIndex = Abilities.GetLevelSpecialValueFor( rune, "base_ability", 1)
	if (baseAbilityIndex == 4){
		baseAbilityIndex = 6
	}	
	if (baseAbilityIndex > 0){
		blockCount = blockCount + 1
		$.Msg("IN BLOCK!")
		var baseAbility = Entities.GetAbility( queryUnit, baseAbilityIndex-1 )
        $('#base_ability_title').text = $.Localize("#tooltip_rune_base_ability")
        $('#base_ability_value').text = $.Localize("#DOTA_Tooltip_Ability_"+Abilities.GetAbilityName( baseAbility ))
		$('#base_ability_container').RemoveClass("invisible")
	}else{
		$('#base_ability_container').AddClass("invisible")
	}
	var damageType = Abilities.GetAbilityDamageType( rune )
	if (damageType == DAMAGE_TYPES.DAMAGE_TYPE_MAGICAL){
		$('#damage_type_title').text = $.Localize('#tooltip_damage_type')
		$('#damage_type_value').text = $.Localize("#DOTA_ToolTip_Damage_Magical")
		blockCount = blockCount + 1
		$('#damage_type_container').RemoveClass("invisible")
	}else if (damageType == DAMAGE_TYPES.DAMAGE_TYPE_PHYSICAL){
		$('#damage_type_title').text = $.Localize('#tooltip_damage_type')
		$('#damage_type_value').text = $.Localize("#DOTA_ToolTip_Damage_Physical")
		blockCount = blockCount + 1
		$('#damage_type_container').RemoveClass("invisible")
	}else if (damageType == DAMAGE_TYPES.DAMAGE_TYPE_PURE){
		$('#damage_type_title').text = $.Localize('#tooltip_damage_type')
		$('#damage_type_value').text = $.Localize("#DOTA_ToolTip_Damage_Pure")
		blockCount = blockCount + 1
		$('#damage_type_container').RemoveClass("invisible")
	}else{
		$('#damage_type_container').AddClass("invisible")
	}

	var element1 = Abilities.GetLevelSpecialValueFor( rune, "element_one", 1)
	var element2 = Abilities.GetLevelSpecialValueFor( rune, "element_two", 1)

	if (element1 > 0){
		$('#element_container').RemoveClass("invisible")
		var element_text = $.Localize('#tooltip_element').toUpperCase()
		$('#element_title').text = element_text
		var element_main_text = $.Localize('#rpc_element'+element1)
		var elementColor = GetElementColor(element1)
		if (element2 > 0){
			var element_main_text2 = $.Localize('#rpc_element'+element2)
			var elementColor2 = GetElementColor(element2)
			var fullElementText = "<font color='"+elementColor+"'>"+element_main_text+"</font> / <font color='"+elementColor2+"'>"+element_main_text2+"</font><br>"
			$('#element_value').text = fullElementText
		}else{
			var fullElementText = "<font color='"+elementColor+"'>"+element_main_text+"</font><br>"
			$('#element_value').text = fullElementText
		}
	}else{
		$('#element_container').AddClass("invisible")
	}
	var raw_description = $.Localize( "#DOTA_Tooltip_Ability_"+abilityNameInternal+"_Description")
    raw_description = replaceConstantsInTooltip(rune, raw_description)
    raw_description = updateSkillInTooltip(raw_description, queryUnit)
    raw_description = replaceRuneTooltip(raw_description, queryUnit, queryUnit)
	$('#rune_description').text = raw_description


	var amount_per_level = Abilities.GetLevelSpecialValueFor( rune, "property_one", 1)
	amount_per_level = Math.round(amount_per_level * 100) / 100
	var property_one_base = Abilities.GetLevelSpecialValueFor( rune, "property_one_base", 1)
	property_one_base = Math.round(property_one_base * 100) / 100
	var property_one_max = Abilities.GetLevelSpecialValueFor( rune, "property_one_max", 1)

	var propertyValue = amount_per_level*total_level+property_one_base
	if (property_one_max > 0){
		if ((amount_per_level*total_level+property_one_base) > property_one_max){
			propertyValue = property_one_max
		}
	}
	propertyValue = Math.round(propertyValue * 100) / 100
	var propertyValueNext = amount_per_level*(total_level+1)+property_one_base
	if (property_one_max > 0){
		if ((amount_per_level*(total_level+1)+property_one_base) > property_one_max){
			propertyValueNext = property_one_max
		}
    }
    propertyValueNext = Math.round(propertyValueNext * 100) / 100
	$('#current_level_text_1').text ="<font color='#70ccea'>" + $.Localize( "#DOTA_Tooltip_Ability_"+abilityNameInternal+"_property_one") + ":</font> " + propertyValue + $.Localize( "#DOTA_Tooltip_Ability_"+abilityNameInternal+"_suffix")
	$('#next_level_text_1').text ="<font color='#70ccea'>" + $.Localize( "#DOTA_Tooltip_Ability_"+abilityNameInternal+"_property_one") + ":</font> " + propertyValueNext + $.Localize( "#DOTA_Tooltip_Ability_"+abilityNameInternal+"_suffix")

	var amount_per_level2 = Abilities.GetLevelSpecialValueFor( rune, "property_two", 1)
	if (!(amount_per_level2 == 0)){
		amount_per_level2 = Math.round(amount_per_level2 * 100) / 100
		var property_two_base = Abilities.GetLevelSpecialValueFor( rune, "property_two_base", 1)
		property_two_base = Math.round(property_two_base * 100) / 100
		var property_two_max = Abilities.GetLevelSpecialValueFor( rune, "property_two_max", 1)

		var propertyValue2 = amount_per_level2*total_level+property_two_base
		if (property_two_max > 0){
			if ((amount_per_level2*total_level+property_two_base) > property_two_max){
				propertyValue2 = property_two_max
			}
		}
		propertyValue2 = Math.round(propertyValue2 * 100) / 100
		var propertyValueNext2 = amount_per_level2*(total_level+1)+property_two_base
		if (property_two_max > 0){
			if ((amount_per_level2*(total_level+1)+property_two_base) > property_two_max){
				propertyValueNext2 = property_two_max
			}
        }
        propertyValueNext2 = Math.round(propertyValueNext2 * 100) / 100
		$('#current_level_text_2').text ="<font color='#70ccea'>" + $.Localize( "#DOTA_Tooltip_Ability_"+abilityNameInternal+"_property_two") + ":</font> " + propertyValue2 + $.Localize( "#DOTA_Tooltip_Ability_"+abilityNameInternal+"_suffix_two")
		$('#next_level_text_2').text ="<font color='#70ccea'>" + $.Localize( "#DOTA_Tooltip_Ability_"+abilityNameInternal+"_property_two") + ":</font> " + propertyValueNext2 + $.Localize( "#DOTA_Tooltip_Ability_"+abilityNameInternal+"_suffix_two")
		$('#current_level_text_2').RemoveClass('invisible')
		$('#next_level_text_2').RemoveClass('invisible')
	}else{
		$('#current_level_text_2').AddClass('invisible')
		$('#next_level_text_2').AddClass('invisible')
	}
	if (total_level<1){
		$("#current").AddClass("invisible")
		$("#current_level_text_1").AddClass("invisible")
		$("#current_level_text_2").AddClass("invisible")
		$("#rune_seperator").AddClass("invisible")
	}else{
		$("#current").RemoveClass("invisible")
		$("#current_level_text_1").RemoveClass("invisible")
		$("#rune_seperator").RemoveClass("invisible")
	}
}

function replaceConstantsInTooltip(ability, tooltip)
{
	if (tooltip.indexOf("@constant1") > -1){
		var constant1 = Abilities.GetLevelSpecialValueFor( ability, "constant_one", 1)
		tooltip = tooltip.replace("@constant1", "<font color='#edf2a7'>"+constant1+"</font>")
	}
	if (tooltip.indexOf("@constant2") > -1){
		var constant2 = Abilities.GetLevelSpecialValueFor( ability, "constant_two", 1)
		tooltip = tooltip.replace("@constant2", "<font color='#edf2a7'>"+constant2+"</font>")
	}
	if (tooltip.indexOf("@constant3") > -1){
		var constant3 = Abilities.GetLevelSpecialValueFor( ability, "constant_three", 1)
		tooltip = tooltip.replace("@constant3", "<font color='#edf2a7'>"+constant3+"</font>")
	}
	if (tooltip.indexOf("@constant4") > -1){
		var constant4 = Abilities.GetLevelSpecialValueFor( ability, "constant_four", 1)
		tooltip = tooltip.replace("@constant4", "<font color='#edf2a7'>"+constant4+"</font>")
	}
	return tooltip
}

function GetRuneBonus(mainHero, rune_slot)
{
	var total_bonus = 0;
	var values = CustomNetTables.GetTableValue( "skill_tree", mainHero.toString()+"_"+rune_slot+"_amulet" );
	if (values === undefined){
	total_bonus = total_bonus;
	}else{
	total_bonus = total_bonus + parseInt(values.bonus);
	}
	values = CustomNetTables.GetTableValue( "skill_tree", mainHero.toString()+"_"+rune_slot+"_hand" );
	if (values === undefined){
	total_bonus = total_bonus;
	}else{
	total_bonus = total_bonus + parseInt(values.bonus);
	}
	values = CustomNetTables.GetTableValue( "skill_tree", mainHero.toString()+"_"+rune_slot+"_body" );
	if (values === undefined){
	total_bonus = total_bonus;
	}else{
	total_bonus = total_bonus + parseInt(values.bonus);
	}
	values = CustomNetTables.GetTableValue( "skill_tree", mainHero.toString()+"_"+rune_slot+"_head" );
	if (values === undefined){
	total_bonus = total_bonus;
	}else{
	total_bonus = total_bonus + parseInt(values.bonus);
	}
	values = CustomNetTables.GetTableValue( "skill_tree", mainHero.toString()+"_"+rune_slot+"_weapon" );
	if (values === undefined){
	total_bonus = total_bonus;
	}else{
	total_bonus = total_bonus + parseInt(values.bonus);
	}
	values = CustomNetTables.GetTableValue( "skill_tree", mainHero.toString()+"_"+rune_slot+"_foot" );
	if (values === undefined){
	total_bonus = total_bonus;
	}else{
	total_bonus = total_bonus + parseInt(values.bonus);
	}
	return total_bonus
}

function GetElementColor(element_index){
	var color = "#FFFFFF"
	if (element_index == 1){
		color = "#DDDDDD"
	}else if(element_index == 2){
		color = "#EF4126"
	}else if(element_index == 3){
		color = "#AF843D"
	}else if(element_index == 4){
		color = "#5CCDF9"
	}else if(element_index == 5){
		color = "#37DD3D"
	}else if(element_index == 6){
		color = "#B5FFB7"
	}else if(element_index == 7){
		color = "#F6FFB5"
	}else if(element_index == 8){
		color = "#C25DFC"
	}else if(element_index == 9){
		color = "#87D9FF"
	}else if(element_index == 10){
		color = "#E1A2E8"
	}else if(element_index == 11){
		color = "#7F4F84"
	}else if(element_index == 12){
		color = "#7AE2A7"
	}else if(element_index == 13){
		color = "#9ACCD1"
	}else if(element_index == 14){
		color = "#3894FF"
	}else if(element_index == 15){
		color = "#5B648C"
	}else if(element_index == 16){
		color = "#69BC71"
	}else if(element_index == 17){
		color = "#5C776E"
	}else if(element_index == 18){
		color = "#3289C7"
	}
	return color
}

function GetRuneSlot(abilityName){
	if (abilityName.indexOf("rune_q_1") > -1){
		return "rune_q_1"
	}else if (abilityName.indexOf("rune_w_1") > -1){
		return "rune_w_1"
	}else if (abilityName.indexOf("rune_e_1") > -1){
		return "rune_e_1"
	}else if (abilityName.indexOf("rune_r_1") > -1){
		return "rune_r_1"
	}else if (abilityName.indexOf("rune_q_2") > -1){
		return "rune_q_2"
	}else if (abilityName.indexOf("rune_w_2") > -1){
		return "rune_w_2"
	}else if (abilityName.indexOf("rune_e_2") > -1){
		return "rune_e_2"
	}else if (abilityName.indexOf("rune_r_2") > -1){
		return "rune_r_2"
	}else if (abilityName.indexOf("rune_q_3") > -1){
		return "rune_q_3"
	}else if (abilityName.indexOf("rune_w_3") > -1){
		return "rune_w_3"
	}else if (abilityName.indexOf("rune_e_3") > -1){
		return "rune_e_3"
	}else if (abilityName.indexOf("rune_r_3") > -1){
		return "rune_r_3"
	}else if (abilityName.indexOf("rune_q_4") > -1){
		return "rune_q_4"
	}else if (abilityName.indexOf("rune_w_4") > -1){
		return "rune_w_4"
	}else if (abilityName.indexOf("rune_e_4") > -1){
		return "rune_e_4"
	}else if (abilityName.indexOf("rune_r_4") > -1){
		return "rune_r_4"
	}else{
		return ""
	}
}

function updateSkillInTooltipHandler(tooltip, itemValues, queryUnit){
	if (!(itemValues.requiredHero === undefined)){
		if (Entities.GetUnitName( queryUnit ) == itemValues.requiredHero){
			tooltip = updateSkillInTooltip(tooltip, queryUnit)
		}else{
			$.Msg("OH DEAR REQUIRED HERO.."+itemValues.requiredHero)
			tooltip = updateSkillInTooltipByName(tooltip, itemValues.requiredHero)
		}
	}else{
		$.Msg("fsdfdfe?")
		tooltip = updateSkillInTooltip(tooltip, queryUnit)
	}
	return tooltip
}

function handleSpecialProperty(itemProperty, index, item, queryUnit, itemValues, itemProperty){
	if (!(itemProperty === undefined)){
		if (!(itemProperty.specialDescription === undefined)){
			specialText1 = $.Localize(itemProperty.specialDescription)
			specialText1 = SpecialDescriptionValues(specialText1, item)
			specialText1 = updateSkillInTooltipHandler(specialText1, itemValues, queryUnit)
			$('#properties_special'+index).RemoveClass('invisible')
			$('#properties_special_text'+index).text = specialText1
			$('#properties_special_title'+index).text = tooltipName = "<font color='"+itemProperty.propertyColor+"'>"+$.Localize(itemProperty.propertyName)+"</font>"
			if (index == 1){
				var typeData = AddDamageTypeAndElementToItem(item)
				if (typeData[2]){
					$('#tooltip_special_element_container1').RemoveClass('invisible')
					$('#tooltip_special_left1').text = typeData[0][0]
					$('#tooltip_special_right1').text = typeData[0][1]
					$('#tooltip_special_left2').text = typeData[1][0]
					$('#tooltip_special_right2').text = typeData[1][1]
				}else{
					$('#tooltip_special_element_container1').AddClass('invisible')
				}
			}
		}else{
			$('#properties_special'+index).AddClass('invisible')	
		}
	}else{
		$('#properties_name'+index).AddClass('invisible')
		$('#properties_value'+index).AddClass('invisible')
		$('#properties_special'+index).AddClass('invisible')				
	}
	if (itemValues.rarityFactor < index){
		$('#properties_name'+index).AddClass('invisible')
		$('#properties_value'+index).AddClass('invisible')
		$('#properties_special'+index).AddClass('invisible')		
	}
}

function AddAffixToItem(tooltip, itemProperty, queryUnit, requiredHero, rarityFactor, itemName)
{
	if (itemProperty === undefined){
		return tooltip
	}
	var OGpropertyName = itemProperty.propertyName
	if (OGpropertyName === undefined){
		return tooltip
	}
	var propertyName = $.Localize(itemProperty.propertyName)
	// itemProperty = itemPropertyCheck(itemProperty)
	$.Msg(OGpropertyName)
	if (OGpropertyName.indexOf("rune_") >= 0){
		var playerIndex = getControllingPlayerIndex()
		var runeIndex = 1
		if (OGpropertyName.indexOf("rune_a") >= 0){
			runeIndex = 1
		}else if (OGpropertyName.indexOf("rune_w") >= 0){
			runeIndex = 2
		}else if (OGpropertyName.indexOf("rune_c") >= 0){
			runeIndex = 3
		}else if (OGpropertyName.indexOf("rune_d") >= 0){
			runeIndex = 4
		}
		if (requiredHero === undefined){
			var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit"+runeIndex );
			var rune_unit_index = skill_tree_data.runeUnit;
			var abilitySlot = getRuneIndexFromRuneName(OGpropertyName)
			var abilityIndex = 	Entities.GetAbility( rune_unit_index, abilitySlot)
			propertyName = $.Localize("DOTA_Tooltip_Ability_"+Abilities.GetAbilityName( abilityIndex ))
		}else{
			if (rarityFactor == 6){
				var RPCName = convertFullHeroNameToRPC(requiredHero)	
				var arcanaSuffix = itemName.replace("item_rpc_"+RPCName+"_", "_");
				propertyName = $.Localize("DOTA_Tooltip_Ability_"+RPCName+"_"+OGpropertyName+arcanaSuffix)
				$.Msg(propertyName)
			}else{
				var RPCName = convertFullHeroNameToRPC(requiredHero)	
				propertyName = $.Localize("DOTA_Tooltip_Ability_"+RPCName+"_"+OGpropertyName)
				$.Msg(propertyName)		
			}
		}
		// itemProperty = itemPropertyCheck(itemProperty)
	}
	if (OGpropertyName.indexOf("#DOTA_Tooltip_Ability") >= 0){
		propertyName = $.Localize(OGpropertyName)
		$.Msg("OGPROPERTYNAME!")
	}
	tooltipName = "<font color='"+itemProperty.propertyColor+"'>"+propertyName+"</font>"
	tooltipValue = "<font color='"+itemProperty.propertyColor+"'>"+itemProperty.propertyValue+"</font>"

	return [tooltipName, tooltipValue]
}

function itemValuesCheck(itemValues)
{
	if (itemValues === undefined){
		itemValues = {}
	}
	if (itemValues.qualityName === undefined){
		itemValues.qualityName = "undefined"
	}
	if (itemValues.consumable === undefined){
		itemValues.consumable = 0
	}
	if (itemValues.itemDescription === undefined){
		itemValues.itemDescription = "undefined"
	}
	if (itemValues.rarityFactor === undefined){
		itemValues.rarityFactor = 1
	}
	if (itemValues.itemPrefix === undefined){
		itemValues.itemPrefix = "undefined"
	}
	if (itemValues.itemSuffix === undefined){
		itemValues.itemSuffix = "undefined"
	}
	if (itemValues.qualityColor === undefined){
		itemValues.qualityColor  = "#FFFFFF"
	}
	if (itemValues.itemName === undefined){
		itemValues.itemName  = "undefined"
	}
	return itemValues
}

function replaceConsumableText(item, tooltip)
{
	var itemProperty3 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-3" )
	if (!(itemProperty3===undefined)){
		tooltip = tooltip.replace("@consumableProperty3", "<font color='"+itemProperty3.propertyColor+"'>"+$.Localize(itemProperty3.propertyName)+"</font>")
	}
	return tooltip
}

function getControllingPlayerIndex()
{
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	var playerIndex = Players.GetLocalPlayer();
	if (Entities.IsHero(queryUnit)){
		var playerTable = CustomNetTables.GetTableValue( "hero_index", queryUnit.toString() );
		if (playerTable === undefined){
			playerIndex = Players.GetLocalPlayer();
		}else{
			playerIndex = playerTable.playerOwner
		}
		
	}else{
		playerIndex = Players.GetLocalPlayer();
	}
	playerIndex = parseInt(playerIndex)
	if (!(Players.IsValidPlayerID(playerIndex))){
		playerIndex = Game.GetAllPlayerIDs()[0];
	}
	return parseInt(playerIndex)
}

function getRuneIndexFromRuneName(propertyName){
	var index = 3
	if (propertyName.indexOf("q_1") >= 1 || propertyName.indexOf("q_2") >= 1 || propertyName.indexOf("q_3") >= 1 || propertyName.indexOf("q_4") >= 1 ){
		index = 0
	}else if (propertyName.indexOf("w_1") >= 1 || propertyName.indexOf("w_2") >= 1 || propertyName.indexOf("w_3") >= 1 || propertyName.indexOf("w_4") >= 1 ){
		index = 1
	}else if (propertyName.indexOf("e_1") >= 1 || propertyName.indexOf("e_2") >= 1 || propertyName.indexOf("e_3") >= 1 || propertyName.indexOf("e_4") >= 1 ){
		index = 2
	}
	return index
}

function updateGlyphInTooltip(tooltip, item)
{
	var value = Abilities.GetLevelSpecialValueFor( item, "property_one", 1)
	if (tooltip.indexOf("@glyph_property1") > -1){
		tooltip = tooltip.replace("@glyph_property1", "<font color='#CCFF66'>"+value+"</font>");
	}
	var value2 = Abilities.GetLevelSpecialValueFor( item, "property_two", 1)
	if (tooltip.indexOf("@glyph_property2") > -1){
		tooltip = tooltip.replace("@glyph_property2", "<font color='#CCFF66'>"+value2+"</font>");
	}
	var value3 = Abilities.GetLevelSpecialValueFor( item, "property_three", 1)
	if (tooltip.indexOf("@glyph_property3") > -1){
		tooltip = tooltip.replace("@glyph_property3", "<font color='#CCFF66'>"+value3+"</font>");
	}
	var value4 = Abilities.GetLevelSpecialValueFor( item, "property_four", 1)
	if (tooltip.indexOf("@glyph_property4") > -1){
		tooltip = tooltip.replace("@glyph_property4", "<font color='#CCFF66'>"+value4+"</font>");
	}
	var value5 = Abilities.GetLevelSpecialValueFor( item, "property_five", 1)
	if (tooltip.indexOf("@glyph_property5") > -1){
		tooltip = tooltip.replace("@glyph_property5", "<font color='#CCFF66'>"+value5+"</font>");
	}
	var value6 = Abilities.GetLevelSpecialValueFor( item, "property_six", 1)
	if (tooltip.indexOf("@glyph_property6") > -1){
		tooltip = tooltip.replace("@glyph_property6", "<font color='#CCFF66'>"+value6+"</font>");
	}
	var value7 = Abilities.GetLevelSpecialValueFor( item, "property_seven", 1)
	if (tooltip.indexOf("@glyph_property7") > -1){
		tooltip = tooltip.replace("@glyph_property7", "<font color='#CCFF66'>"+value7+"</font>");
	}
	return tooltip
}

function SpecialDescriptionValues(specialText, item)
{
	if (specialText.indexOf("@special_property1") > -1){
		var value = Abilities.GetSpecialValueFor( item, "property_one" )
		$.Msg("$$$VALUE: "+value)
		value = Math.round(value*100, 1)/100
		specialText = specialText.replace("@special_property1", "<font color='#CCFF66'>"+value+"</font>");
	}	
	if (specialText.indexOf("@special_property2") > -1){
		var value = Abilities.GetSpecialValueFor( item, "property_two" )
		value = Math.round(value*100, 1)/100
		specialText = specialText.replace("@special_property2", "<font color='#CCFF66'>"+value+"</font>");
	}	
	if (specialText.indexOf("@special_property3") > -1){
		var value = Abilities.GetSpecialValueFor( item, "property_three" )
		value = Math.round(value*100, 1)/100
		specialText = specialText.replace("@special_property3", "<font color='#CCFF66'>"+value+"</font>");
	}	
	if (specialText.indexOf("@special_property4") > -1){
		var value = Abilities.GetSpecialValueFor( item, "property_four" )
		value = Math.round(value*100, 1)/100
		specialText = specialText.replace("@special_property4", "<font color='#CCFF66'>"+value+"</font>");
	}
	if (specialText.indexOf("@special_property5") > -1){
		var value = Abilities.GetSpecialValueFor( item, "property_five" )
		value = Math.round(value*100, 1)/100
		specialText = specialText.replace("@special_property5", "<font color='#CCFF66'>"+value+"</font>");
	}
	return specialText
}

function AddDamageTypeAndElementToItem(item)
{
	$.Msg("ELEMENT TIME!")
	var ability = item
	var damageType = Abilities.GetAbilityDamageType( ability )
	var tooltip = ""
	var element1 = Abilities.GetLevelSpecialValueFor( ability, "element_one", 1)
	var element2 = Abilities.GetLevelSpecialValueFor( ability, "element_two", 1)
	$.Msg(damageType)
		// 
	var shouldShow = false
	var tooltipTypeLeft = ""
	var tooltipTypeRight = ""
	var tooltipElementLeft = ""
	var tooltipElementRight = ""
	if (damageType == DAMAGE_TYPES.DAMAGE_TYPE_MAGICAL){
		tooltipTypeLeft = "<font color='#777777'>"+$.Localize("#tooltip_damage_type")+":</font>"
		tooltipTypeRight = "<font color='#7083FF'>"+$.Localize("#DOTA_ToolTip_Damage_Magical")+"</font>"
		shouldShow = true
	}else if (damageType == DAMAGE_TYPES.DAMAGE_TYPE_PHYSICAL){
		tooltipTypeLeft = "<font color='#777777'>"+$.Localize("#tooltip_damage_type")+":</font>"
		tooltipTypeRight = "<font color='#7083FF'>"+$.Localize("#DOTA_ToolTip_Damage_Physical")+"</font>"
		shouldShow = true
	}else if (damageType == DAMAGE_TYPES.DAMAGE_TYPE_PURE){
		tooltipTypeLeft = "<font color='#777777'>"+$.Localize("#tooltip_damage_type")+":</font>"
		tooltipTypeRight = "<font color='#7083FF'>"+$.Localize("#DOTA_ToolTip_Damage_Pure")+"</font>"
		shouldShow = true
	}

	if (element1 > 0){
		tooltipElementLeft = "<font color='#777777'>"+$.Localize('#tooltip_element').toUpperCase()+":</font>"
		element_main_text = $.Localize('#rpc_element'+element1)
		var elementColor = GetElementColor(element1)
		if (element2 > 0){
			var element_main_text2 = $.Localize('#rpc_element'+element2)
			var elementColor2 = GetElementColor(element2)
			tooltipElementRight = "<font color='"+elementColor+"'>"+element_main_text+"</font> / <font color='"+elementColor2+"'>"+element_main_text2+"</font>"
		}else{
			tooltipElementRight = "<font color='"+elementColor+"'>"+element_main_text+"</font>"
		}
		shouldShow = true
	}	
	return [[tooltipTypeLeft, tooltipTypeRight], [tooltipElementLeft, tooltipElementRight], shouldShow]
}

function init(){
	$.GetContextPanel().style.backgroundColor = "#1A1A1A"
	$.Msg("INIT")
}

(function()
{
	init();
})();
