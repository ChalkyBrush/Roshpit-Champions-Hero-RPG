"use strict";

function new_item_with_slot(msg){
	InitializeSwapPanels();
	$('#full_swap_container').RemoveClass('invisible');
	$('#full_swap_container').AddClass('animateEaseClass');
	var newItem = msg.newItem
	var oldItem = msg.oldItem
	$('#ItemImageSwap').contextEntityIndex = oldItem;
	$('#ItemImageSwap2').contextEntityIndex = newItem;
	populateNewItem(newItem);
	populateOldItem(oldItem);
	$('#take_new').SetAttributeInt( "item",  newItem);
	$('#keep_old').SetAttributeInt( "item",  oldItem);
	//$('#full_swap_container').SetAttributeInt( "inventoryUnit",  msg.inventoryUnit);
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

function populateNewItem(newItem){
	var itemValues = CustomNetTables.GetTableValue( "item_basics", newItem.toString() );
	// $.Msg("populateNewItem +++++++++++++++++++++++++++");
	// $.Msg(itemValues);
	// $.Msg("populateNewItem +++++++++++++++++++++++++++");
	if (true)
	{
		$.Msg("populateNewItem stat 1");
		var itemProperty = {}
		if (itemValues.property1color) itemProperty.propertyColor = itemValues.property1color
		if (itemValues.property1) itemProperty.propertyValue = itemValues.property1
		if (itemValues.property1special) itemProperty.specialDescription = itemValues.property1special
		if (itemValues.property1tooltip) itemProperty.propertyName = itemValues.property1tooltip == "rune" ? itemValues.property1name : itemValues.property1tooltip		
		poplateProperty(itemProperty, $('#swap_item_property1name2'), $('#swap_item_property1value2'));
	}
	if (itemValues.rarityFactor >= 2 )
	{
		$.Msg("populateNewItem stat 2");
		var itemProperty = {}
		if (itemValues.property2color) itemProperty.propertyColor = itemValues.property2color
		if (itemValues.property2) itemProperty.propertyValue = itemValues.property2
		if (itemValues.property2special) itemProperty.specialDescription = itemValues.property2special
		if (itemValues.property2tooltip) itemProperty.propertyName = itemValues.property2tooltip == "rune" ? itemValues.property2name : itemValues.property2tooltip		
		poplateProperty(itemProperty, $('#swap_item_property2name2'), $('#swap_item_property2value2'));
	}
	if (itemValues.rarityFactor >= 3 )
	{
		$.Msg("populateNewItem stat 3");
		var itemProperty = {}
		if (itemValues.property3color) itemProperty.propertyColor = itemValues.property3color
		if (itemValues.property3) itemProperty.propertyValue = itemValues.property3
		if (itemValues.property3special) itemProperty.specialDescription = itemValues.property3special
		if (itemValues.property3tooltip) itemProperty.propertyName = itemValues.property3tooltip == "rune" ? itemValues.property3name : itemValues.property3tooltip		
		poplateProperty(itemProperty, $('#swap_item_property3name2'), $('#swap_item_property3value2'));
	}
	if (itemValues.rarityFactor >= 4 )
	{
		$.Msg("populateNewItem stat 4");
		var itemProperty = {}
		if (itemValues.property4color) itemProperty.propertyColor = itemValues.property4color
		if (itemValues.property4) itemProperty.propertyValue = itemValues.property4
		if (itemValues.property4special) itemProperty.specialDescription = itemValues.property4special
		if (itemValues.property4tooltip) itemProperty.propertyName = itemValues.property4tooltip == "rune" ? itemValues.property4name : itemValues.property4tooltip		
		poplateProperty(itemProperty, $('#swap_item_property4name2'), $('#swap_item_property4value2'));
	}
	var itemPrefix = itemValues.itemPrefix
	var itemSuffix = itemValues.itemSuffix
	var localizedItemName = $.Localize("#DOTA_Tooltip_Ability_"+Abilities.GetAbilityName(newItem))
	//$.Msg( itemValues.property1 );
	//$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", $.GetContextPanel(), itemName, queryUnit );
	var title = "<font color='"+itemValues.qualityColor+"'>"+itemPrefix+" "+localizedItemName+" "+itemSuffix+"</font>"
	$("#swap_item_name2").text = title;
}

function populateOldItem(oldItem){
	var itemValues = CustomNetTables.GetTableValue( "item_basics", oldItem.toString() );
	if (true)
	{
		$.Msg("populateNewItem stat 1");
		var itemProperty = {}
		if (itemValues.property1color) itemProperty.propertyColor = itemValues.property1color
		if (itemValues.property1) itemProperty.propertyValue = itemValues.property1
		if (itemValues.property1special) itemProperty.specialDescription = itemValues.property1special
		if (itemValues.property1tooltip) itemProperty.propertyName = itemValues.property1tooltip == "rune" ? itemValues.property1name : itemValues.property1tooltip		
		poplateProperty(itemProperty, $('#swap_item_property1name1'), $('#swap_item_property1value1'));
	}
	if (itemValues.rarityFactor >= 2 )
	{
		$.Msg("populateNewItem stat 2");
		var itemProperty = {}
		if (itemValues.property2color) itemProperty.propertyColor = itemValues.property2color
		if (itemValues.property2) itemProperty.propertyValue = itemValues.property2
		if (itemValues.property2special) itemProperty.specialDescription = itemValues.property2special
		if (itemValues.property2tooltip) itemProperty.propertyName = itemValues.property2tooltip == "rune" ? itemValues.property2name : itemValues.property2tooltip		
		poplateProperty(itemProperty, $('#swap_item_property2name1'), $('#swap_item_property2value1'));
	}
	if (itemValues.rarityFactor >= 3 )
	{
		$.Msg("populateNewItem stat 3");
		var itemProperty = {}
		if (itemValues.property3color) itemProperty.propertyColor = itemValues.property3color
		if (itemValues.property3) itemProperty.propertyValue = itemValues.property3
		if (itemValues.property3special) itemProperty.specialDescription = itemValues.property3special
		if (itemValues.property3tooltip) itemProperty.propertyName = itemValues.property3tooltip == "rune" ? itemValues.property3name : itemValues.property3tooltip		
		poplateProperty(itemProperty, $('#swap_item_property3name1'), $('#swap_item_property3value1'));
	}
	if (itemValues.rarityFactor >= 4 )
	{
		$.Msg("populateNewItem stat 4");
		var itemProperty = {}
		if (itemValues.property4color) itemProperty.propertyColor = itemValues.property4color
		if (itemValues.property4) itemProperty.propertyValue = itemValues.property4
		if (itemValues.property4special) itemProperty.specialDescription = itemValues.property4special
		if (itemValues.property4tooltip) itemProperty.propertyName = itemValues.property4tooltip == "rune" ? itemValues.property4name : itemValues.property4tooltip		
		poplateProperty(itemProperty, $('#swap_item_property4name1'), $('#swap_item_property4value1'));
	}
	var itemPrefix = itemValues.itemPrefix
	var itemSuffix = itemValues.itemSuffix
	var localizedItemName = $.Localize("#DOTA_Tooltip_Ability_"+Abilities.GetAbilityName(oldItem))
	//$.Msg( itemValues.property1 );
	//$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", $.GetContextPanel(), itemName, queryUnit );
	var title = "<font color='"+itemValues.qualityColor+"'>"+itemPrefix+" "+localizedItemName+" "+itemSuffix+"</font>"
	$("#swap_item_name1").text = title;
}


function poplateProperty(property, panelDescription, panelValue){
	$.Msg("poplateProperty +++++++++++++++++++++++++++");
	
	var property = itemPropertyCheck(property)
	var text = "<font color='"+property.propertyColor+"'>"+property.propertyName+"</font>"
	var propertyValue = property.propertyValue
	panelDescription.text = text;
	panelValue.text = propertyValue;
	panelDescription.RemoveClass('invisible')
	panelValue.RemoveClass('invisible')
}

function InitializeSwapPanels()
{
	$('#full_swap_container').AddClass('invisible');
	$('#swap_item_property2name1').AddClass('invisible');
	$('#swap_item_property2value1').AddClass('invisible');
	$('#swap_item_property3name1').AddClass('invisible');
	$('#swap_item_property3value1').AddClass('invisible');
	$('#swap_item_property4name1').AddClass('invisible');
	$('#swap_item_property4value1').AddClass('invisible');
	$('#swap_item_property5name1').AddClass('invisible');
	$('#swap_item_property5value1').AddClass('invisible');

	$('#swap_item_property2name2').AddClass('invisible');
	$('#swap_item_property2value2').AddClass('invisible');
	$('#swap_item_property3name2').AddClass('invisible');
	$('#swap_item_property3value2').AddClass('invisible');
	$('#swap_item_property4name2').AddClass('invisible');
	$('#swap_item_property4value2').AddClass('invisible');
	$('#swap_item_property5name2').AddClass('invisible');
	$('#swap_item_property5value2').AddClass('invisible');

	$("#keep_equipped_label").text = $.Localize("#ui_keep_old_item")
	$("#equip_new_label").text = $.Localize("#ui_take_new_item")
}

function KeepOld()
{
	if ($('#full_swap_container').GetAttributeInt( "closing", -1 ) == -1)
	{
		$('#full_swap_container').AddClass('animateEaseOutClass');
		$.Schedule(0.45, function(){
			$('#full_swap_container').AddClass('invisible');
			$('#full_swap_container').RemoveClass('animateEaseOutClass');
			$('#full_swap_container').RemoveClass('animateEaseClass');
		});
		var newItem = $('#take_new').GetAttributeInt( "item", -1 );
		var oldItem = $('#keep_old').GetAttributeInt( "item", -1 );
		var inventoryUnit = $('#full_swap_container').GetAttributeInt("inventoryUnit", -1);
		GameEvents.SendCustomGameEventToServer( "reject_item", {newItem: newItem, oldItem: oldItem, inventoryUnit: inventoryUnit} )
	}
}

function TakeNew()
{	
	if ($('#full_swap_container').GetAttributeInt( "closing", -1 ) == -1)
	{
	$('#full_swap_container').SetAttributeInt( "closing", 1 );
	$('#full_swap_container').AddClass('animateEaseOutClass');
	$.Schedule(0.45, function(){
		$('#full_swap_container').SetAttributeInt( "closing", -1 );
		$('#full_swap_container').AddClass('invisible');
		$('#full_swap_container').RemoveClass('animateEaseOutClass');
		$('#full_swap_container').RemoveClass('animateEaseClass');
	});
	var newItem = $('#take_new').GetAttributeInt( "item", -1 );
	var oldItem = $('#keep_old').GetAttributeInt( "item", -1 );
	var inventoryUnit = $('#full_swap_container').GetAttributeInt("inventoryUnit", -1);
	GameEvents.SendCustomGameEventToServer( "accept_item", {newItem: newItem, oldItem: oldItem, inventoryUnit: inventoryUnit} )
	}
}

function CloseSwapUI()
{
	if ($('#full_swap_container').GetAttributeInt( "closing", -1 ) == -1 && !$('#full_swap_container').BHasClass("invisible"))
	{
		$('#full_swap_container').SetAttributeInt( "closing", 1 );
		$('#full_swap_container').AddClass('animateEaseOutClass');
		$.Schedule(0.45, function(){
			$('#full_swap_container').SetAttributeInt( "closing", -1 );
			$('#full_swap_container').AddClass('invisible');
			$('#full_swap_container').RemoveClass('animateEaseOutClass');
			$('#full_swap_container').RemoveClass('animateEaseClass');
		});	
	}
}


(function () {
  GameEvents.Subscribe( "new_item_with_slot", new_item_with_slot );
  GameEvents.Subscribe( "close_swap_ui", CloseSwapUI );
})();

