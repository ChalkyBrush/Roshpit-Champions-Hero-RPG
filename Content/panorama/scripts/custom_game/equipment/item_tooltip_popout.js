function initializeTooltip(func){
	// $.Msg(func)
	// $.Msg("INIT TOOLTIP")
	var item = $.GetContextPanel().GetAttributeString( "item", "0" );
	
	item = parseInt(item)
	if (item == 0){
		item = GameUI.CustomUIConfig.itemTooltip;
	}
	var queryUnit = $.GetContextPanel().GetAttributeString( "queryUnit", "0" );
	queryUnit = parseInt(queryUnit)
	if (queryUnit==0){
		queryUnit = Players.GetLocalPlayerPortraitUnit();
	}
	var heroName = 	Entities.GetUnitName( queryUnit )
	// $.Msg(item)
	// $.Msg(queryUnit)
	var itemName = Abilities.GetAbilityName( item );
	var itemValues = CustomNetTables.GetTableValue( "item_basics", item.toString() )
	var itemProperty1 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-1" )
	itemValues = itemValuesCheck(itemValues)
	var unitName = queryUnit
	if (!(itemValues.requiredHero === undefined)){
		if (Entities.GetUnitName( queryUnit ) == itemValues.requiredHero){

		}else{
			heroName = itemValues.requiredHero
		}
	}

	//TITLE
	var localizedItemName = $.Localize("#DOTA_Tooltip_Ability_"+Abilities.GetAbilityName(item))
	var itemPrefix = itemValues.itemPrefix
	var itemSuffix = itemValues.itemSuffix
	var title = "<font color='"+itemValues.qualityColor+"'>"+itemPrefix+" "+localizedItemName+" "+itemSuffix+"</font>"

	$('#tooltip_title').text = title

	//QUALITY AND SLOT

	var tooltip = ""
	if (itemValues.consumable == 1)
	{
		tooltip = tooltip+"<font color='#AAAAAA'>Consumable</font><br>"
	}
	tooltip = tooltip+""+itemValues.itemDescription
	$('#tooltip_quality_left').text = itemValues.qualityName
	$('#tooltip_quality_right').text = tooltip

		if (!(itemValues.useDescription === undefined)){
			var tooltip = ""
			tooltip = tooltip + "<font color='#A3D4A1'>"+$.Localize(itemValues.useDescription)+"</font>"
			tooltip = replaceConsumableText(item, tooltip)
			tooltip = updateGlyphInTooltip(tooltip, item)
			$.Msg("AGAIN HI:"+queryUnit)
			tooltip = updateSkillInTooltipHandler(tooltip, itemValues, queryUnit)
			$('#consumable-text').text = tooltip
			$('#consumable-text').RemoveClass('invisible')
			$('#properties_name1').AddClass('invisible')
			$('#properties_value1').AddClass('invisible')
			$('#properties_special1').AddClass('invisible')
			$('#properties_name2').AddClass('invisible')
			$('#properties_value2').AddClass('invisible')
			$('#properties_special2').AddClass('invisible')
			$('#properties_name3').AddClass('invisible')
			$('#properties_value3').AddClass('invisible')
			$('#properties_special3').AddClass('invisible')
			$('#properties_name4').AddClass('invisible')
			$('#properties_value4').AddClass('invisible')
			$('#properties_special4').AddClass('invisible')

			var itemProperty1 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-1" )
			$.Msg(itemProperty1)
			if (!(itemProperty1===undefined)){
				var property1text = AddAffixToItem("", itemProperty1, queryUnit, "", 5, itemName)
				$('#properties_name1').text = property1text[0]
				$('#properties_value1').text = property1text[1]
				$('#properties_name1').RemoveClass('invisible')
				$('#properties_value1').RemoveClass('invisible')				
			}
		}else{
			$('#consumable-text').AddClass('invisible')
			//PROPERTY1
			var itemProperty1 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-1" )
			var property1text = AddAffixToItem("", itemProperty1, queryUnit, itemValues.requiredHero, itemValues.rarityFactor, itemName)
			$('#properties_name1').text = property1text[0]
			$('#properties_value1').text = property1text[1]
			$('#properties_name1').RemoveClass('invisible')
			$('#properties_value1').RemoveClass('invisible')

			handleSpecialProperty(itemProperty1, 1, item, queryUnit, itemValues, itemProperty1)
			//PROPERTY2
			var itemProperty2 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-2" )
			var property2text = AddAffixToItem("", itemProperty2, queryUnit, itemValues.requiredHero, itemValues.rarityFactor, itemName)
			$('#properties_name2').text = property2text[0]
			$('#properties_value2').text = property2text[1]
			$('#properties_name2').RemoveClass('invisible')
			$('#properties_value2').RemoveClass('invisible')

			handleSpecialProperty(itemProperty2, 2, item, queryUnit, itemValues, itemProperty2)
			//PROPERTY3
			var itemProperty3 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-3" )
			var property3text = AddAffixToItem("", itemProperty3, queryUnit, itemValues.requiredHero, itemValues.rarityFactor, itemName)
			$('#properties_name3').text = property3text[0]
			$('#properties_value3').text = property3text[1]
			$('#properties_name3').RemoveClass('invisible')
			$('#properties_value3').RemoveClass('invisible')

			handleSpecialProperty(itemProperty3, 3, item, queryUnit, itemValues, itemProperty3)
			//PROPERTY4
			var itemProperty4 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-4" )
			var property4text = AddAffixToItem("", itemProperty4, queryUnit, itemValues.requiredHero, itemValues.rarityFactor, itemName)
			$('#properties_name4').text = property4text[0]
			$('#properties_value4').text = property4text[1]
			$('#properties_name4').RemoveClass('invisible')
			$('#properties_value4').RemoveClass('invisible')

			handleSpecialProperty(itemProperty4, 4, item, queryUnit, itemValues, itemProperty4)

			if(!(itemValues.glyph ===undefined)){
				if (itemValues.glyph == 1){
					$('#properties_special1').AddClass('invisible')
				}
			}
		}

		//MINLEVEL
		var bHideReqLines = true
		if (!(itemValues.minLevel ===undefined)){
			var reductionTable = CustomNetTables.GetTableValue( "min_level_reduction", item.toString() )
			var reduction = 0
			if (!(reductionTable===undefined)){
				reduction = reductionTable.levelReduce
			}
			var minLevel = itemValues.minLevel
			var minLevelText = ""
			if (minLevel > 0){
				if (reduction > 0){
					minLevel = minLevel - reduction
					minLevelText = minLevelText + "<font color='#DB2766'>"+$.Localize('#item_min_level')+": </font><font color='#F28100'>"+minLevel+"</font>"
				}
				else{
					minLevelText = minLevelText + "<font color='#DB2766'>"+$.Localize('#item_min_level')+": "+minLevel+"</font>"
				}
			}
			if (parseInt(minLevel) > 0){
				$('#tooltip_requirements_left').RemoveClass('invisible')
				$('#tooltip_requirements_left').text = minLevelText
				bHideReqLines = false
			}else{
				$('#tooltip_requirements_left').AddClass('invisible')
			}
		}else{
			$('#tooltip_requirements_left').AddClass('invisible')
		}
		//REQUIRED HERO
		if (itemValues.requiredHero === undefined){
			$('#tooltip_requirements_right').AddClass('invisible')
		}else{
			var requiredHeroText = $.Localize(itemValues.requiredHero)
			$('#tooltip_requirements_right').RemoveClass('invisible')
			$('#tooltip_requirements_right').text = requiredHeroText

			$.Msg(requiredHeroText)
			bHideReqLines = false
		}
		$.Msg("BHIDEREQ")
		$.Msg(bHideReqLines)
		if(bHideReqLines){
			$('#class-splitter3').AddClass('invisible')
			$('#class-splitter4').AddClass('invisible')
		}else{
			$('#class-splitter3').RemoveClass('invisible')
			$('#class-splitter4').RemoveClass('invisible')
		}

		// WEAPON DATA

		// tooltip = tooltip + "<br><br><font color='#F7501E'>"+$.Localize('#'+itemTable.requiredHero)+" "+$.Localize('#weapon_usable')+"</font>"
		// tooltip = tooltip + "<br><br><font color='#FF2B2B'>"+$.Localize('#weapon_max_level')+": "+itemTable.maxLevel+"</font>"

		var weaponValues = CustomNetTables.GetTableValue( "weapons", "item"+item.toString() )
		$.Msg(weaponValues)
		if (!(weaponValues === undefined) && !(weaponValues.level === undefined)){
			$.Msg("SHOULD BE HERE!!!")
			$('#tooltip_weapons_data_container').RemoveClass('invisible')
			$('#tooltip_weapon_left1').text = "<font color='#ffb8b7'>"+$.Localize('weapon_usable')+"</font> <font color='#AAAAAA'>"+$.Localize('weapon_current_level')+":</font>"
			$('#tooltip_weapon_right1').text = "<font color='#FFFFFF'>"+weaponValues.level+"</font>"
			$('#tooltip_weapon_left2').text = "<font color='#ffb8b7'>"+$.Localize('weapon_usable')+"</font> <font color='#AAAAAA'>"+$.Localize('weapon_max_level')+":</font>"
			$('#tooltip_weapon_right2').text = "<font color='#FFFFFF'>"+weaponValues.maxLevel+"</font>"
			if (weaponValues.itemName == Abilities.GetAbilityName(item)){
				$('#weapon_exp_bar').RemoveClass("invisible")
				if (weaponValues.level == weaponValues.maxLevel){
					$('#weapon_exp_bar_inner').style.width = "100%"
					$('#weapon_exp_bar_text').text = "<font color='#f4dc42'>"+"★ MAX LEVEL ★"+"</font>"
				}else{
					var percentage = (parseInt(weaponValues.xp)/parseInt(weaponValues.xpNeeded))*100
					// percentage = toString(percentage)+"%"
					$.Msg(percentage)
					$('#weapon_exp_bar_inner').RemoveClass('invisible')
					$('#weapon_exp_bar_inner').style.width = percentage + "%"
					$('#weapon_exp_bar_text').text = weaponValues.xp+" / "+weaponValues.xpNeeded
				}
			}
		}else if(itemValues.maxLevel){
			$('#tooltip_weapons_data_container').RemoveClass('invisible')
			$('#tooltip_weapon_left1').text = "<font color='#ffb8b7'>"+$.Localize('weapon_usable')+"</font> <font color='#AAAAAA'>"+$.Localize('weapon_current_level')+":</font>"
			$('#tooltip_weapon_right1').text = "<font color='#FFFFFF'>"+1+"</font>"
			$('#tooltip_weapon_left2').text = "<font color='#ffb8b7'>"+$.Localize('weapon_usable')+"</font> <font color='#AAAAAA'>"+$.Localize('weapon_max_level')+":</font>"
			$('#tooltip_weapon_right2').text = "<font color='#FFFFFF'>"+itemValues.maxLevel+"</font>"
		}else{
			$('#weapon_exp_bar').AddClass("invisible")
			$('#tooltip_weapons_data_container').AddClass('invisible')
		}

		var returned = CustomNetTables.GetTableValue( "item_basics", item.toString()+"-returned")
		if (returned === undefined){
			$('#dupe').AddClass("invisible")
		}else{
			$('#dupe').RemoveClass("invisible")
			$('#dupe').text = "<font color='#FFFFFF'>*"+$.Localize('item_possibly_duped')+"</font>"
		}	
}

function updateSkillInTooltipHandler(tooltip, itemValues, queryUnit){
	if (!(itemValues.requiredHero === undefined)){
		if (Entities.GetUnitName( queryUnit ) == itemValues.requiredHero){
			tooltip = updateSkillInTooltip(tooltip, queryUnit)
			tooltip = replaceRuneTooltip(tooltip, queryUnit, itemValues.requiredHero)
		}else{
			tooltip = updateSkillInTooltipByName(tooltip, itemValues.requiredHero)
			tooltip = replaceRuneTooltip(tooltip, -1, itemValues.requiredHero)
		}
	}else{
		tooltip = updateSkillInTooltip(tooltip, queryUnit)
		tooltip = replaceRuneTooltip(tooltip, queryUnit, "")
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
	var propertyName = $.Localize(itemProperty.propertyName)
	// itemProperty = itemPropertyCheck(itemProperty)
	$.Msg(OGpropertyName)
	if (OGpropertyName.indexOf("rune_") >= 0){
		var playerIndex = getControllingPlayerIndex()
		var runeIndex = 1
		if (OGpropertyName.indexOf("rune_a") >= 0){
			runeIndex = 1
		}else if (OGpropertyName.indexOf("rune_b") >= 0){
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
				if (RPCName == "monk"){
					arcanaSuffix = itemName.replace("item_rpc_"+"seinaru"+"_", "_");
				}
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
	if (propertyName.indexOf("a_a") >= 1 || propertyName.indexOf("b_a") >= 1 || propertyName.indexOf("c_a") >= 1 || propertyName.indexOf("d_a") >= 1 ){
		index = 0
	}else if (propertyName.indexOf("a_b") >= 1 || propertyName.indexOf("b_b") >= 1 || propertyName.indexOf("c_b") >= 1 || propertyName.indexOf("d_b") >= 1 ){
		index = 1
	}else if (propertyName.indexOf("a_c") >= 1 || propertyName.indexOf("b_c") >= 1 || propertyName.indexOf("c_c") >= 1 || propertyName.indexOf("d_c") >= 1 ){
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

function init(){
	$.GetContextPanel().style.backgroundColor = "#1A1A1A"
	$.Msg("INIT")
}

(function()
{
	init();
})();
