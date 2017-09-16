"use strict";

function OpenEquipment()
{
$.Msg( "OPENDAT" );
	if ($('#equipment_button_label').open){
		$('#equipment_button_label').text = $.Localize("#ui_close_equipment")
		$('#equipment_button_label').open = false;
		$('#large_equipment_panel').RemoveClass('animateEaseOutClass');
		$('#large_equipment_panel').AddClass('animateEaseClass');
		$('#large_equipment_panel').RemoveClass('invisible');
		$('#equipment_panel_image').RemoveClass('equipment_panel_image_glow');
		
	}else{
		$('#equipment_button_label').text = $.Localize("#ui_open_equipment")
		$('#equipment_button_label').open = true;
		$('#large_equipment_panel').RemoveClass('animateEaseClass');
		$('#large_equipment_panel').AddClass('animateEaseOutClass');
		$('#equipment_panel_image').AddClass('equipment_panel_image_glow');

		$.Schedule(0.45, function(){
			$('#large_equipment_panel').AddClass('invisible');
		});
		
	}
}

function InitializeEquipment(msg)
{
	$('#equipment_button_label').open = true;
	OpenEquipment();
	$.Msg( "InitializeEquipment" );
	$('#equipment_button_label').text = $.Localize("#ui_close_equipment")
	$('#recalculate_button_text').text = $.Localize("#ui_recalculate_stats_button")
	$('#recalculate_button').SetAttributeInt("active", 0)
}

function EquipmentClick(slot)
{
	if (GameUI.CustomUIConfig().chisel == 1){
		var itemPanel = getSlot(slot)
		var item = itemPanel.GetAttributeInt( "item", -1 );
		var ownerID = itemPanel.GetAttributeInt( "ownerID", -10 );
		if (!(Players.GetLocalPlayer() == ownerID)){
			Game.EmitSound("General.Cancel")
			$.Msg("YOU DONT MATCH PLAYER ID")
			return			
		}
		if (item == -1){
			Game.EmitSound("General.Cancel")
			return
		}
		if (!(itemPanel.BHasClass('chiselable_gear'))){
			Game.EmitSound("General.Cancel")
			return			
		}

		GameEvents.SendCustomGameEventToServer( "clicked_chisel_gear", {playerID: Game.GetLocalPlayerID(), itemIndex: item});
	}
}

function UpdateItem()
{
	for ( var i = 0; i < 6; ++i )
	{
		if (i == 0){
			var itemPanel = $("#helm_container");
			var itemImage = $('#ItemImageHelm')
		}
		if (i == 1){
			var itemPanel = $("#weapon_container");
			var itemImage = $('#ItemImageWeapon')
		}
		if (i == 2){
			var itemPanel = $("#glove_container");
			var itemImage = $('#ItemImageGlove')
		}
		if (i == 3){
			var itemPanel = $("#boot_container");
			var itemImage = $('#ItemImageBoot')
		}
		if (i == 4){
			var itemPanel = $("#armor_container");
			var itemImage = $('#ItemImageArmor')
		}
		if (i == 5){
			var itemPanel = $("#amulet_container");
			var itemImage = $('#ItemImageAmulet')
		}
		var item = itemPanel.GetAttributeInt( "item", -1 );
		var queryUnit = itemPanel.GetAttributeInt( "queryUnit", -1 );
		var itemName = Abilities.GetAbilityName( item );
		var hotkey = Abilities.GetKeybind( item, queryUnit );
		var chargeCount = 0;
		var hasCharges = false;
		var altChargeCount = 0;
		var hasAltCharges = false;


		// $.Msg( $("#helm_container"));

		itemImage.itemname = itemName;
		itemImage.contextEntityIndex = item;
		if (item == -1){
			itemImage.SetImage("file://{images}/custom_game/ui/empty-inventory-slot.png");
		}
	}

	$.Schedule( 0.2, UpdateItem );
}

function getSlot(slot)
{
		if (slot == 0){
			var itemPanel = $("#helm_container");
		}
		if (slot == 1){
			var itemPanel = $("#weapon_container");
		}
		if (slot == 2){
			var itemPanel = $("#glove_container");
		}
		if (slot == 3){
			var itemPanel = $("#boot_container");
		}
		if (slot == 4){
			var itemPanel = $("#armor_container");
		}
		if (slot == 5){
			var itemPanel = $("#amulet_container");
		}	
		return itemPanel;
}

function ItemShowTooltipInit(slot)
{
	var itemPanel = getSlot(slot)
	var item = itemPanel.GetAttributeInt( "item", -1 );
	if ( item == -1 )
		return;
	// $.GetContextPanel().SetAttributeInt( "item", item)
	ItemShowTooltipOnPanel(itemPanel)
	// var itemName = Abilities.GetAbilityName( item );
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	// //var property1 = RPCItems.GetProperty1( item )
	// var itemValues = CustomNetTables.GetTableValue( "item_basics", item.toString() )
	// var itemProperty1 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-1" )
	// itemValues = itemValuesCheck(itemValues)
	// var tooltip = CreateCustomTooltip(itemValues, itemName, itemProperty1)
	// tooltip = AddAffixToItem(tooltip, itemProperty1)

	// if (itemValues.rarityFactor >= 2 )
	// {
	// 	var itemProperty2 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-2" )
	// 	tooltip = AddAffixToItem(tooltip, itemProperty2)
	// }
	// if (itemValues.rarityFactor >= 3 )
	// {
	// 	var itemProperty3 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-3" )
	// 	tooltip = AddAffixToItem(tooltip, itemProperty3)
	// }
	// if (itemValues.rarityFactor >= 4 )
	// {
	// 	var itemProperty4 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-4" )
	// 	tooltip = AddAffixToItem(tooltip, itemProperty4)
	// }
	// 	var itemPrefix = itemValues.itemPrefix
	// 	var itemSuffix = itemValues.itemSuffix
	// 	//$.Msg( itemValues.property1 );
	// 	//$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", $.GetContextPanel(), itemName, queryUnit );
	// 	var localizedItemName = $.Localize("#DOTA_Tooltip_ability_"+Abilities.GetAbilityName(item))
	// 	var title = "<font color='"+itemValues.qualityColor+"'>"+itemPrefix+" "+localizedItemName+" "+itemSuffix+"</font>"
	// if (!(itemValues.minLevel ===undefined)){
	// 	tooltip = AddMinLevelToTooltip(itemValues, tooltip, item)
	// }
	// tooltip = AddSpecialDescriptionToTooltip(tooltip, itemProperty1, itemProperty2, itemProperty3, itemProperty4, itemValues.rarityFactor, item)
	// tooltip = updateSkillInTooltip(tooltip, queryUnit)
	if(slot == 1){
		weaponDetailsIn(queryUnit)
	}
	// if (!(itemValues.requiredHero === undefined)){
	// 	if (itemValues.glyph){
	// 		tooltip = tooltip + "<br><br><font color='#F7501E'>"+$.Localize('#'+itemValues.requiredHero)+" "+$.Localize('#tooltip_glyph')+"</font>"
	// 	}else if(itemValues.rarityFactor == 6){
	// 		tooltip = tooltip + "<br><br><font color='#F7501E'>"+$.Localize('#'+itemValues.requiredHero)+" "+$.Localize('#item_only')+"</font>"
	// 	}else{
	// 		tooltip = AddWeaponDataToTooltip(tooltip, itemValues)
	// 	}
	// }
	// title = title.replace(/(['"])/g, "\\$1");
	// tooltip = tooltip.replace(/(['"])/g, "\\$1");
	// $.DispatchEvent("DOTAShowTitleTextTooltip", itemPanel, title, tooltip);
	//$.DispatchEvent("DOTAShowTitleTextTooltip", $.GetContextPanel(),  "#DOTA_Tooltip_ability_"+itemName, tooltip );

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
	return specialText
}

function round(value, decimals) {
  return Number(Math.round(value+'e'+decimals)+'e-'+decimals);
}

function AddWeaponDataToTooltip(tooltip, itemTable){
	tooltip = tooltip + "<br><br><font color='#F7501E'>"+$.Localize('#'+itemTable.requiredHero)+" "+$.Localize('#weapon_usable')+"</font>"
	tooltip = tooltip + "<br><br><font color='#FF2B2B'>"+$.Localize('#weapon_max_level')+": "+itemTable.maxLevel+"</font>"
	
	return tooltip
}
function weaponDetailsIn(hero){
	var weaponTable = CustomNetTables.GetTableValue( "weapons",  hero.toString() )
	GameUI.CustomUIConfig().weaponPanel.RemoveClass('invisible')
	GameUI.CustomUIConfig().weaponPanel.style.visibility = "visible"
	GameUI.CustomUIConfig().weaponPanel.AddClass('animateWeaponPanel')
	GameUI.CustomUIConfig().weaponPanel.weaponCurrentLevel.text = weaponTable.level
	GameUI.CustomUIConfig().weaponPanel.weaponMaxLevel.text = weaponTable.maxLevel
	GameUI.CustomUIConfig().weaponPanel.expLabel.text = weaponTable.xp+"/"+weaponTable.xpNeeded
	var percentage = Math.floor(weaponTable.xp*100/weaponTable.xpNeeded)
	if (weaponTable.maxLevel == weaponTable.level){
		percentage = 100
		GameUI.CustomUIConfig().weaponPanel.expLabel.text = "MAX"
	}
	GameUI.CustomUIConfig().weaponPanel.progressBar.style.width = percentage+"%"
	GameUI.CustomUIConfig().weaponPanel.container.style.visibility = "visible"

	// GameUI.CustomUIConfig().weaponPanel.weaponCurrentLevel = $('#weapon_current_level')
	// GameUI.CustomUIConfig().weaponPanel.weaponMaxLevel = $('#weapon_max_level')
	// GameUI.CustomUIConfig().weaponPanel.expLabel = $('#weapon_exp_label')
	// GameUI.CustomUIConfig().weaponPanel.progressBar = $('#weapon_exp_bar_progress')
}

function weaponDetailsOut(){
	GameUI.CustomUIConfig().weaponPanel.RemoveClass('animateWeaponPanel')
	GameUI.CustomUIConfig().weaponPanel.AddClass('invisible')
	GameUI.CustomUIConfig().weaponPanel.style.visibility = "collapse"
}

function AddMinLevelToTooltip(itemValues, tooltip, item)
{
	var reductionTable = CustomNetTables.GetTableValue( "min_level_reduction", item.toString() )
	var reduction = 0
	if (!(reductionTable===undefined)){
		reduction = reductionTable.levelReduce
	}
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
				specialText3 = "<br>"+$.Localize(itemProperty3.specialDescription)
				
				specialBreak=true;
				specialText3 = breakUpTooltip(specialText3)
				specialText3 = SpecialDescriptionValues(specialText3, item)
			}
		}
	}
	if (!(itemProperty4 === undefined)){
		if (rarityFactor >= 4){
			if (!(itemProperty4.specialDescription === undefined)){
				specialText4 = "<br>"+$.Localize(itemProperty4.specialDescription)
				
				specialBreak=true;
				specialText4 = breakUpTooltip(specialText4)
				specialText4 = SpecialDescriptionValues(specialText4, item)
			}
		}
	}
	if (specialBreak){
		tooltip = tooltip+"<br>_______________________<br>"
	}
	tooltip = tooltip+"<font color='white'>"+specialText1+specialText2+specialText3+specialText4+"</font>"
	return tooltip
}

function breakUpTooltip(specialText){
	var spacePosition10 = getPosition(specialText, " ", 8)
	var spacePosition20 = getPosition(specialText, " ", 16)
	var spacePosition30 = getPosition(specialText, " ", 24)
	var brIndex = specialText.substring(0, spacePosition10).length
	var br = "<br>"
	var br2 = "<br>"
	var br3 = "<br>"
	if (spacePosition10 >= specialText.length){
		br = ""
	}
	brIndex = specialText.substring(0, spacePosition20).length
	if (spacePosition20 >= specialText.length){
		br2 = ""
	}
	brIndex = specialText.substring(0, spacePosition30).length
	if (spacePosition30 >= specialText.length){
		br3 = ""
	}
	specialText= specialText.substring(0, spacePosition10) + br + specialText.substring(spacePosition10+1, spacePosition20) + br2 + specialText.substring(spacePosition20+1, spacePosition30) + br3 + specialText.substring(spacePosition30+1, specialText.length)
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
	if (itemValues.itemName === undefined){
		itemValues.itemName  = "undefined"
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


function CreateCustomTooltip(itemValues, itemName, itemProperty1)
{
	$.Msg( itemValues );
	//var tooltip = "<Label style='color:"+itemValues.qualityColor+";font-size:16px;'>"+itemValues.itemName+"</Label><br>";

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

function AddAffixToItem(tooltip, itemProperty)
{
	itemProperty = itemPropertyCheck(itemProperty)
	tooltip = tooltip+"<br><font color='"+itemProperty.propertyColor+"'>"+itemProperty.propertyName+": "+itemProperty.propertyValue+"</font>"
	return tooltip
}

function ItemHideTooltipInit(slot)
{
	var itemPanel = getSlot(slot)
	$.DispatchEvent( "DOTAHideTitleTextTooltip", itemPanel );
	if (slot == 1){
		weaponDetailsOut()
	}
}

(function()
{
	UpdateItem(); // initial update of dynamic state
	GameEvents.Subscribe( "InitializeEquipment", InitializeEquipment );
})();