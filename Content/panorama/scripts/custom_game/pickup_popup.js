"use strict";

function PickupPopup(msg)
{
	InitializePropertyPanels()
	$('#picked_up_panel').RemoveClass('invisible');
	$('#picked_up_panel').AddClass('animateEaseClass');
	var item = msg.item
	var heroName = msg.heroId
	var playerId = msg.playerId
	var pickup = msg.pickup
	$('#ItemImageSwap3').contextEntityIndex = item;
	var hero_image_name = "file://{images}/heroes/" + heroName + ".png";
	$('#pickup_player_portrait').SetImage( hero_image_name );
	//$().heroname(heroName);
	$('#pickup_player_name').text = Players.GetPlayerName(playerId)
	var heroName = $.Localize( "#"+heroName)
	$('#pickup_hero_name').text = heroName
	populatePickupItem(item)
	$.Msg( "PICKIN IT UP!" );
      // $.Schedule(5, function(){
      // 	$('#picked_up_panel').RemoveClass('animateEaseClass');
      //   $('#picked_up_panel').AddClass('animateEaseOutClass');
      //   $.Schedule(0.45, function(){
      //   	$('#picked_up_panel').AddClass('invisible');
      //   });
      // });
      if (pickup == "equip")
      {
      	$('#picked_up_title').text = $.Localize("#ui_equip_new")
      	$("#pickup_panel_image").SetImage("file://{images}/custom_game/ui/large_panel_green.png");
      }
      if ($('#picked_up_panel').GetAttributeInt('Fadeloop', 0) == 0)
      {
      fadeCalculator()
  	  }
}

function fadeCalculator(){
	
	var orig_level = $('#picked_up_panel').GetAttributeInt('Timer', 0);
	if (orig_level > 8){
      	$('#picked_up_panel').RemoveClass('animateEaseClass');
        $('#picked_up_panel').AddClass('animateEaseOutClass');
        $.Schedule(0.45, function(){
        		$('#picked_up_panel').AddClass('invisible');
        		$('#picked_up_panel').SetAttributeInt('Fadeloop', 0);
        });		
	}else{
		$('#picked_up_panel').SetAttributeInt('Fadeloop', 1);
		$('#picked_up_panel').SetAttributeInt('Timer', orig_level + 2);
		$.Schedule( 2, fadeCalculator );
	}
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
	$.Msg($.Localize(itemProperty.propertyName))
	itemProperty.propertyName = $.Localize(itemProperty.propertyName)
	return itemProperty
}


function populatePickupItem(item){
	var itemValues = CustomNetTables.GetTableValue( "item_basics", item.toString() );
	itemValues = itemValuesCheck(itemValues)
	var itemProperty1 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-1" );
	populatePickupProperty(itemProperty1, $('#swap_item_property1name3'), $('#swap_item_property1value3'));
	if (itemValues.rarityFactor >= 2 )
	{
		var itemProperty2 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-2" );
		populatePickupProperty(itemProperty2, $('#swap_item_property2name3'), $('#swap_item_property2value3'));
	}
	if (itemValues.rarityFactor >= 3 )
	{
		var itemProperty3 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-3" );
		populatePickupProperty(itemProperty3, $('#swap_item_property3name3'), $('#swap_item_property3value3'));
	}
	if (itemValues.rarityFactor >= 4 )
	{
		var itemProperty4 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-4" );
		populatePickupProperty(itemProperty4, $('#swap_item_property4name3'), $('#swap_item_property4value3'));
	}
	var itemPrefix = itemValues.itemPrefix
	var itemSuffix = itemValues.itemSuffix
	//$.Msg( itemValues.property1 );
	//$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", $.GetContextPanel(), itemName, queryUnit );
	var title = "<font color='"+itemValues.qualityColor+"'>"+itemPrefix+" "+itemValues.itemName+" "+itemSuffix+"</font>"
	$("#swap_item_name1").text = title;
}


function populatePickupProperty(property, panelDescription, panelValue){
	property = itemPropertyCheck(property)
	var text = "<font color='"+property.propertyColor+"'>"+property.propertyName+"</font>"
	var propertyValue = property.propertyValue
	panelDescription.text = text;
	panelValue.text = propertyValue;
	panelDescription.RemoveClass('invisible')
	panelValue.RemoveClass('invisible')
}

function InitializePropertyPanels()
{
	$('#picked_up_title').text = $.Localize("#ui_picked_up")
	$("#pickup_panel_image").SetImage("file://{images}/custom_game/ui/large_panel2.png");
	$('#picked_up_panel').RemoveClass('animateEaseOutClass');
	$('#picked_up_panel').RemoveClass('animateEaseClass');
	$('#picked_up_panel').AddClass('invisible');
	$('#picked_up_panel').SetAttributeInt('Timer', 0);
	//$('#picked_up_panel').SetAttributeInt('Fadeloop', 0);
	$('#swap_item_property2name3').AddClass('invisible');
	$('#swap_item_property2value3').AddClass('invisible');
	$('#swap_item_property3name3').AddClass('invisible');
	$('#swap_item_property3value3').AddClass('invisible');
	$('#swap_item_property4name3').AddClass('invisible');
	$('#swap_item_property4value3').AddClass('invisible');
	$('#swap_item_property5name3').AddClass('invisible');
	$('#swap_item_property5value3').AddClass('invisible');
}


(function () {
  GameEvents.Subscribe( "PickupPopup", PickupPopup );
})();

