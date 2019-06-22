function ItemShowTooltipOnPanel(itemPanel)
{
	var item = itemPanel.GetAttributeInt( "item", -1 );
	
	var queryUnit = Players.GetPlayerHeroEntityIndex( Game.GetLocalPlayerID())
	if ((queryUnit == -1) || queryUnit === undefined){
		queryUnit = itemPanel.GetAttributeInt( "queryUnit", -1 );
	}
	if ( item == -1 )
		return;

	// tooltip = updateGlyphInTooltip(tooltip, item)
	
	// title = title.replace(/(['"])/g, "\\$1");
	// tooltip = tooltip.replace(/(['"])/g, "\\$1");

	// $.DispatchEvent("UIShowCustomLayoutParametersTooltip", itemPanel, "ItemTooltip","file://{resources}/layout/custom_game/equipment/item_tooltip.xml",name2="ay lmao");
	$.Msg("TOOLTIP GLYPH.."+queryUnit)
	var tooltipArgs = "item="+item+"&queryUnit="+queryUnit
	$.DispatchEvent("UIShowCustomLayoutParametersTooltip", itemPanel, "file://{resources}/layout/custom_game/equipment/item_tooltip.xml", tooltipArgs);
	// $.DispatchEvent("DOTAShowTitleTextTooltip", itemPanel, title, tooltip);
	//$.DispatchEvent("DOTAShowTitleTextTooltip", $.GetContextPanel(),  "#DOTA_Tooltip_ability_"+itemName, tooltip );
}

function ItemShowTooltip(panelId)
{
	var itemPanel = $(panelId)
	var item = itemPanel.GetAttributeInt( "item", -1 );
	
	var queryUnit = Players.GetPlayerHeroEntityIndex( Game.GetLocalPlayerID())
	if ((queryUnit == -1) || queryUnit === undefined){
		queryUnit = itemPanel.GetAttributeInt( "queryUnit", -1 );
	}
	if ( item == -1 )
		return;

	var tooltipArgs = "item="+item+"&queryUnit="+queryUnit
	$.DispatchEvent("UIShowCustomLayoutParametersTooltip", itemPanel, "file://{resources}/layout/custom_game/equipment/item_tooltip.xml", tooltipArgs);

	// $.DispatchEvent("DOTAShowTitleTextTooltip", itemPanel, title, tooltip);


	//$.DispatchEvent("DOTAShowTitleTextTooltip", $.GetContextPanel(),  "#DOTA_Tooltip_ability_"+itemName, tooltip );
}

function AddWeaponDataToTooltip(tooltip, itemTable, item){
	tooltip = tooltip + "<br><br><font color='#F7501E'>"+$.Localize('#'+itemTable.requiredHero)+" "+$.Localize('#weapon_usable')+"</font>"
	tooltip = tooltip + "<br><br><font color='#FF2B2B'>"+$.Localize('#weapon_max_level')+": "+itemTable.maxLevel+"</font>"

	var weaponValues = CustomNetTables.GetTableValue( "weapons", "item"+item.toString() )
	$.Msg("WEAPON VALUES ----")
	$.Msg(weaponValues)
	if (!(weaponValues == undefined)){
		if (weaponValues.item_name == Abilities.GetAbilityName(item)){
			tooltip = tooltip + "<br>"
			if (weaponValues.level == weaponValues.maxLevel){
				tooltip = tooltip + "<font color='#f4dc42'>"+"★ MAX LEVEL ★"+"</font>"
			}else{
				tooltip = tooltip + "<font color='#FFFFFF'>"+$.Localize("weapon_current_level")+": "+weaponValues.level+"</font>"
				tooltip = tooltip + " - ["+weaponValues.xp+" / "+weaponValues.xpNeeded+"]"
			}
		}
	}	
	return tooltip
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
	return tooltip
}

function AddMinLevelToTooltip(itemValues, tooltip, item)
{
	var reduction = 0
	var minLevel = itemValues.minLevel
	if (minLevel > 0){
		if (reduction > 0){
			minLevel = minLevel - reduction
			tooltip = tooltip + "<br><br><font color='#DB2766'>"+$.Localize('#item_min_level')+": </font><font color='#F28100'>"+minLevel+"</font>"
		}
		else{
			tooltip = tooltip + "<br><br><font color='#DB2766'>"+$.Localize('#item_min_level')+": "+minLevel+"</font>"
		}
	}
	return tooltip
}


function AddSpecialDescriptionToTooltip(tooltip, itemProperty1, itemProperty2, itemProperty3, itemProperty4, rarityFactor, item)
{
	var specialBreak = false
	var specialText1 = ""
	var specialText2 = ""
	var specialText3 = ""
	var specialText4 = ""
	if (!(itemProperty1 === undefined)){
		if (!(itemProperty1.specialDescription === undefined)){
			specialText1 = "<br>"+$.Localize(itemProperty1.specialDescription)
			
			specialBreak=true;
			specialText1 = breakUpTooltip(specialText1)
			specialText1 = SpecialDescriptionValues(specialText1, item)
		}
	}
	if (!(itemProperty2 === undefined)){
		if (rarityFactor >= 2){
			if (!(itemProperty2.specialDescription === undefined)){
				specialText2 = "<br>"+$.Localize(itemProperty2.specialDescription)
				
				specialBreak=true;
				specialText2 = breakUpTooltip(specialText2)
				specialText2 = SpecialDescriptionValues(specialText2, item)
			}
		}
	}
	if (!(itemProperty3 === undefined)){
		if (rarityFactor >= 3){
			if (!(itemProperty3.specialDescription === undefined)){
				
				specialText3 = SpecialDescriptionValues(specialText3, item)
				specialBreak=true;
				specialText3 = breakUpTooltip(specialText3)
				specialText3 = "<br>"+$.Localize(itemProperty3.specialDescription)
			}
		}
	}
	if (!(itemProperty4 === undefined)){
		if (rarityFactor >= 4){
			if (!(itemProperty4.specialDescription === undefined)){
				
				specialText4 = SpecialDescriptionValues(specialText4, item)
				specialBreak=true;
				specialText4 = breakUpTooltip(specialText4)
				specialText4 = "<br>"+$.Localize(itemProperty4.specialDescription)
			}
		}
	}
	if (specialBreak){
		tooltip = tooltip+"<br>_______________________<br>"
		tooltip = tooltip + AddDamageTypeAndElementToItem(tooltip, item)
	}
	tooltip = tooltip+"<font color='white'>"+specialText1+specialText2+specialText3+specialText4+"</font>"
	return tooltip
}

function AddDamageTypeAndElementToItem(tooltip, item)
{
	$.Msg("ELEMENT TIME!")
	var ability = item
	var damageType = Abilities.GetAbilityDamageType( ability )
	var tooltip = ""
	var element1 = Abilities.GetLevelSpecialValueFor( ability, "element_one", 1)
	var element2 = Abilities.GetLevelSpecialValueFor( ability, "element_two", 1)
	$.Msg(damageType)
		// 
	if (damageType == DAMAGE_TYPES.DAMAGE_TYPE_MAGICAL){
		var damage_type_text = $.Localize("#tooltip_damage_type")+": "
		var damage_type_main_text = $.Localize("#DOTA_ToolTip_Damage_Magical")
		tooltip = tooltip+"<font color='#FF8A8A'>"+damage_type_text+"</font><font color='#7083FF'>"+damage_type_main_text+"</font><br>"
	}else if (damageType == DAMAGE_TYPES.DAMAGE_TYPE_PHYSICAL){
		var damage_type_text = $.Localize("#tooltip_damage_type")+": "
		var damage_type_main_text = $.Localize("#DOTA_ToolTip_Damage_Physical")
		$.Msg("PHYS")
		tooltip = tooltip+"<font color='#FF8A8A'>"+damage_type_text+"</font><font color='#FF7070'>"+damage_type_main_text+"</font><br>"
	}else if (damageType == DAMAGE_TYPES.DAMAGE_TYPE_PURE){
		var damage_type_text = $.Localize("#tooltip_damage_type")+": "
		var damage_type_main_text = $.Localize("#DOTA_ToolTip_Damage_Pure")
		tooltip = tooltip+"<font color='#FF8A8A'>"+damage_type_text+"</font><font color='#FFFFFF'>"+damage_type_main_text+"</font><br>"
	}

	if (element1 > 0){
		var element_text = $.Localize('#tooltip_element').toUpperCase()+": "
		var element_main_text = $.Localize('#rpc_element'+element1)
		var elementColor = GetElementColor(element1)
		if (element2 > 0){
			var element_main_text2 = $.Localize('#rpc_element'+element2)
			var elementColor2 = GetElementColor(element2)
			tooltip = tooltip+"<font color='#DDDDDD'>"+element_text+"</font><font color='"+elementColor+"'>"+element_main_text+"</font> / <font color='"+elementColor2+"'>"+element_main_text2+"</font>"
		}else{
			tooltip = tooltip+"<font color='#DDDDDD'>"+element_text+"</font><font color='"+elementColor+"'>"+element_main_text+"</font>"
		}
	}	
	return tooltip
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
	}
	return color
}

function SpecialDescriptionValues(specialText, item)
{
	if (specialText.indexOf("@special_property1") > -1){
		var value = Abilities.GetSpecialValueFor( item, "property_one" )
		value = round(value, 1)
		specialText = specialText.replace("@special_property1", "<font color='#CCFF66'>"+value+"</font>");
	}	
	if (specialText.indexOf("@special_property2") > -1){
		var value = Abilities.GetSpecialValueFor( item, "property_two" )
		value = round(value, 1)
		specialText = specialText.replace("@special_property2", "<font color='#CCFF66'>"+value+"</font>");
	}	
	if (specialText.indexOf("@special_property3") > -1){
		var value = Abilities.GetSpecialValueFor( item, "property_three" )
		value = round(value, 1)
		specialText = specialText.replace("@special_property3", "<font color='#CCFF66'>"+value+"</font>");
	}	
	if (specialText.indexOf("@special_property4") > -1){
		var value = Abilities.GetSpecialValueFor( item, "property_four" )
		value = round(value, 1)
		specialText = specialText.replace("@special_property4", "<font color='#CCFF66'>"+value+"</font>");
	}
	if (specialText.indexOf("@special_property5") > -1){
		var value = Abilities.GetSpecialValueFor( item, "property_five" )
		value = round(value, 1)
		specialText = specialText.replace("@special_property5", "<font color='#CCFF66'>"+value+"</font>");
	}
	return specialText
}

function round(value, decimals) {
  return Number(Math.round(value+'e'+decimals)+'e-'+decimals);
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

function itemValuesCheck(itemValues)
{
	$.Msg(itemValues)
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
	if (itemValues.item_name === undefined){
		itemValues.item_name  = "undefined"
	}
	return itemValues
}

function itemPropertyCheck(itemProperty){
	if (itemProperty === undefined){
		itemProperty = {}
	}
	if (itemProperty.propertyColor === undefined){
		itemProperty.propertyColor = "#444444"
	}
	if (itemProperty.propertyName === undefined){
		itemProperty.propertyName = $.Localize("#item_broken_slot")
	}
	if (itemProperty.propertyValue === undefined){
		itemProperty.propertyValue = "-"
	}
	itemProperty.propertyName = $.Localize(itemProperty.propertyName)
	return itemProperty
}

// function GetElementColor(element_index){
// 	var color = "#FFFFFF"
// 	if (element_index == 1){
// 		color = "#DDDDDD"
// 	}else if(element_index == 2){
// 		color = "#EF4126"
// 	}else if(element_index == 3){
// 		color = "#AF843D"
// 	}else if(element_index == 4){
// 		color = "#5CCDF9"
// 	}else if(element_index == 5){
// 		color = "#37DD3D"
// 	}else if(element_index == 6){
// 		color = "#B5FFB7"
// 	}else if(element_index == 7){
// 		color = "#F6FFB5"
// 	}else if(element_index == 8){
// 		color = "#C25DFC"
// 	}else if(element_index == 9){
// 		color = "#87D9FF"
// 	}else if(element_index == 10){
// 		color = "#E1A2E8"
// 	}else if(element_index == 11){
// 		color = "#7F4F84"
// 	}else if(element_index == 12){
// 		color = "#7AE2A7"
// 	}else if(element_index == 13){
// 		color = "#9ACCD1"
// 	}else if(element_index == 14){
// 		color = "#3894FF"
// 	}else if(element_index == 15){
// 		color = "#5B648C"
// 	}else if(element_index == 16){
// 		color = "#69BC71"
// 	}
// 	return color
// }


function CreateCustomTooltip(itemValues, itemName, itemProperty1)
{
	$.Msg( itemValues );
	//var tooltip = "<Label style='color:"+itemValues.qualityColor+";font-size:16px;'>"+itemValues.item_name+"</Label><br>";

	var tooltip = "<i>"+itemValues.qualityName+"</i><br>"
	if (itemValues.consumable == 1)
	{
		tooltip = tooltip+"<font color='#AAAAAA'>Consumable</font><br>"
	}
	tooltip = tooltip+""+itemValues.itemDescription
	
	//tooltip = tooltip+"<img src='file://{images}/custom_game/text/dontdie.png'>"
	//$.Msg( tooltip );
	return tooltip
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
    if (OGpropertyName.indexOf("rune_") >= 0) {
        var playerIndex = getControllingPlayerIndex()
        var abilitySlot = -1
        if (OGpropertyName.indexOf("rune_q") >= 0) {
            abilitySlot = 0
        } else if (OGpropertyName.indexOf("rune_w") >= 0) {
            abilitySlot = 1
        } else if (OGpropertyName.indexOf("rune_e") >= 0) {
            abilitySlot = 2
        } else if (OGpropertyName.indexOf("rune_r") >= 0) {
            abilitySlot = 3
        }
        var runeIndex = getRuneIndexFromRuneName(OGpropertyName)
		if (requiredHero === undefined){
			var skill_tree_data = CustomNetTables.GetTableValue( "skill_tree", playerIndex.toString()+"rune_unit"+runeIndex );
			var rune_unit_index = skill_tree_data.runeUnit;
			var abilityIndex = 	Entities.GetAbility( rune_unit_index, abilitySlot)
			propertyName = $.Localize("DOTA_Tooltip_ability_"+Abilities.GetAbilityName( abilityIndex ))
		}else{
			if (rarityFactor == 6){
				var RPCName = convertFullHeroNameToRPC(requiredHero)	
				var arcanaSuffix = itemName.replace("item_rpc_"+RPCName+"_", "_");
				propertyName = $.Localize("DOTA_Tooltip_ability_"+RPCName+"_"+OGpropertyName+arcanaSuffix)
				$.Msg(propertyName)
			}else{
				var RPCName = convertFullHeroNameToRPC(requiredHero)	
				propertyName = $.Localize("DOTA_Tooltip_ability_"+RPCName+"_"+OGpropertyName)
				$.Msg(propertyName)		
			}
		}
		// itemProperty = itemPropertyCheck(itemProperty)
	}
	if (OGpropertyName.indexOf("#DOTA_Tooltip_ability") >= 0){
		propertyName = $.Localize(OGpropertyName)
		$.Msg("OGPROPERTYNAME!")
	}
	tooltip = tooltip+"<br><font color='"+itemProperty.propertyColor+"'>"+propertyName+": "+itemProperty.propertyValue+"</font>"

	return tooltip
}

function getRuneIndexFromRuneName(propertyName) {
    var index = -1
    if (propertyName.indexOf("_1") >= 1) {
        index = 1
    } else if (propertyName.indexOf("_2") >= 1) {
        index = 2
    } else if (propertyName.indexOf("_3") >= 1) {
        index = 3
    } else if (propertyName.indexOf("_4") >= 1) {
        index = 4
    }
    return index
}

function ItemHideTooltip(panelId)
{
	if (panelId){
		var itemPanel = $(panelId)
		$.DispatchEvent( "UIHideCustomLayoutTooltip", itemPanel );
	}
}

function ItemHideTooltipByPanel(itemPanel)
{
	$.DispatchEvent( "UIHideCustomLayoutTooltip", itemPanel );
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