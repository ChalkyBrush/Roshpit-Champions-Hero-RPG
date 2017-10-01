"use strict";

var m_Item = -1;
var m_ItemSlot = -1;
var m_QueryUnit = -1;
var m_PlayerID = -1;
var m_type = "inventory";

function UpdateItem()
{
	var itemName = Abilities.GetAbilityName( m_Item );
	var hotkey = Abilities.GetKeybind( m_Item, m_QueryUnit );
	var isPassive = Abilities.IsPassive( m_Item );
	var chargeCount = 0;
	var hasCharges = false;
	var altChargeCount = 0;
	var hasAltCharges = false;
	
	if ( Items.ShowSecondaryCharges( m_Item ) )
	{
		// Ward stacks display charges differently depending on their toggle state
		// hasCharges = true;
		hasAltCharges = true;
		if ( Abilities.GetToggleState( m_Item ) )
		{
			chargeCount = Items.GetCurrentCharges( m_Item );
			altChargeCount = Items.GetSecondaryCharges( m_Item );
		}
		else
		{
			altChargeCount = Items.GetCurrentCharges( m_Item );
			chargeCount = Items.GetSecondaryCharges( m_Item );
		}
	}
	else if ( Items.ShouldDisplayCharges( m_Item ) )
	{
		// hasCharges = true;
		chargeCount = Items.GetCurrentCharges( m_Item );
	}

	$.GetContextPanel().SetHasClass( "no_item", (m_Item == -1) );
	$.GetContextPanel().SetHasClass( "show_charges", hasCharges );
	$.GetContextPanel().SetHasClass( "show_alt_charges", hasAltCharges );
	$.GetContextPanel().SetHasClass( "is_passive", isPassive );
	
	$( "#HotkeyText" ).text = hotkey;
	$( "#ItemImage" ).itemname = itemName;
	$( "#ItemImage" ).contextEntityIndex = m_Item;

	if (m_Item == -1){
		$( "#ItemImage" ).SetImage("file://{images}/custom_game/ui/empty-inventory-slot.png")
	}

	$( "#ChargeCount" ).text = chargeCount;
	$( "#AltChargeCount" ).text = altChargeCount;
	
	if(m_ItemSlot <= 5){
		if ( m_Item == -1 || Abilities.IsCooldownReady( m_Item ) )
		{
			$.GetContextPanel().SetHasClass( "cooldown_ready", true );
			$.GetContextPanel().SetHasClass( "in_cooldown", false );
		}
		else
		{
			$.GetContextPanel().SetHasClass( "cooldown_ready", false );
			$.GetContextPanel().SetHasClass( "in_cooldown", true );
			var cooldownLength = Abilities.GetCooldownLength( m_Item );
			var cooldownRemaining = Abilities.GetCooldownTimeRemaining( m_Item );
			var cooldownPercent = Math.ceil( 100 * cooldownRemaining / cooldownLength );
			$( "#CooldownTimer" ).text = Math.ceil( cooldownRemaining );
			$( "#CooldownOverlay" ).style.width = cooldownPercent+"%";
		}
	}

	if(m_ItemSlot > 5 && m_ItemSlot <= 8){
		$("#Hotkey").AddClass('invisible')
		$.GetContextPanel().SetHasClass( "in_cooldown", true );
		$.GetContextPanel().SetHasClass( "cooldown_ready", false );
		$( "#CooldownOverlay" ).style.width = "100%";
		$( "#CooldownTimer" ).text = "";
		$.GetContextPanel().AddClass('ItemPanelBackpack')
	}
	
	$.Schedule( 0.1, UpdateItem );
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

function ItemShowTooltipInit()
{
	var item = m_Item
	var queryUnit = m_QueryUnit
	if ( item == -1 )
		return;
	var itemName = Abilities.GetAbilityName( item );
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	$.GetContextPanel().SetAttributeInt( "item", item)
	ItemShowTooltipOnPanel($.GetContextPanel())

	// var itemValues = CustomNetTables.GetTableValue( "item_basics", item.toString() )
	// if (itemValues === undefined){
	// 	$.DispatchEvent("DOTAShowAbilityTooltipForEntityIndex", $.GetContextPanel(), itemName, item);
	// }else{
	// 	if (!(itemValues.useDescription === undefined)){
	// 		var tooltip = CreateCustomTooltip(itemValues, itemName, itemProperty1)
	// 		tooltip = tooltip + "<br><font color='#A3D4A1'>"+$.Localize(itemValues.useDescription)+"</font>"
	// 		tooltip = breakUpTooltip(tooltip)
	// 	}else{
	// 		var itemProperty1 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-1" )
	// 		var tooltip = CreateCustomTooltip(itemValues, itemName, itemProperty1)
	// 		tooltip = AddAffixToItem(tooltip, itemProperty1)
	// 		if (itemValues.rarityFactor >= 2 )
	// 		{
	// 			var itemProperty2 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-2" )
	// 			tooltip = AddAffixToItem(tooltip, itemProperty2)
	// 		}
	// 		if (itemValues.rarityFactor >= 3 )
	// 		{
	// 			var itemProperty3 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-3" )
	// 			tooltip = AddAffixToItem(tooltip, itemProperty3)
	// 		}
	// 		if (itemValues.rarityFactor >= 4 )
	// 		{
	// 			var itemProperty4 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-4" )
	// 			tooltip = AddAffixToItem(tooltip, itemProperty4)
	// 		}
	// 	}
	// 	var itemPrefix = itemValues.itemPrefix
	// 	var itemSuffix = itemValues.itemSuffix
	// 	//$.Msg( itemValues.property1 );
	// 	//$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", $.GetContextPanel(), itemName, queryUnit );
	// 	var localizedItemName = $.Localize("#DOTA_Tooltip_ability_"+Abilities.GetAbilityName(item))
	// 	var title = "<font color='"+itemValues.qualityColor+"'>"+itemPrefix+" "+localizedItemName+" "+itemSuffix+"</font>"
	// 	if (!(itemValues.minLevel ===undefined)){
	// 		tooltip = AddMinLevelToTooltip(itemValues, tooltip, item)
	// 	}		
	// 	if (!(itemValues.requiredHero === undefined)){
	// 		if (itemValues.glyph){
	// 			tooltip = tooltip + "<br><br><font color='#F7501E'>"+$.Localize('#'+itemValues.requiredHero)+" "+$.Localize('#tooltip_glyph')+"</font>"
	// 		}else if(itemValues.rarityFactor == 6){
	// 			$.Msg(itemValues.requiredHero)
	// 			tooltip = tooltip + "<br><br><font color='#F7501E'>"+$.Localize('#'+itemValues.requiredHero)+" "+$.Localize('#item_only')+"</font>"
	// 		}else{
	// 			tooltip = AddWeaponDataToTooltip(tooltip, itemValues)
	// 		}
	// 	}
	// 	tooltip = AddSpecialDescriptionToTooltip(tooltip, itemProperty1, itemProperty2, itemProperty3, itemProperty4, itemValues.rarityFactor, item)
	// 	tooltip = updateSkillInTooltip(tooltip, queryUnit)
	// 	tooltip = updateGlyphInTooltip(tooltip, item)
	// 	title = title.replace(/(['"])/g, "\\$1");
	// 	tooltip = tooltip.replace(/(['"])/g, "\\$1");

	// 	$.DispatchEvent("DOTAShowTitleTextTooltip", $.GetContextPanel(), title, tooltip);
		//$.DispatchEvent("DOTAShowTitleTextTooltip", $.GetContextPanel(),  "#DOTA_Tooltip_ability_"+itemName, tooltip );
	// }
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

function AddWeaponDataToTooltip(tooltip, itemTable){
	tooltip = tooltip + "<br><br><font color='#F7501E'>"+$.Localize('#'+itemTable.requiredHero)+" "+$.Localize('#weapon_usable')+"</font>"
	tooltip = tooltip + "<br><br><font color='#FF2B2B'>"+$.Localize('#weapon_max_level')+": "+itemTable.maxLevel+"</font>"
	
	return tooltip
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

function ItemHideTooltipInit()
{
	ItemHideTooltipByPanel($.GetContextPanel())
	// $.DispatchEvent( "DOTAHideTitleTextTooltip", $.GetContextPanel() );
	// $.DispatchEvent( "DOTAHideAbilityTooltip", $.GetContextPanel() );
}

function ActivateItem()
{
	if ( m_Item == -1 )
		return;

	// Items are abilities - just execute the ability
	Abilities.ExecuteAbility( m_Item, m_QueryUnit, false );
}

function DoubleClickItem()
{
	ActivateItem();
}

var DOTA_ITEM_STASH_MIN = 9;

function IsInStash()
{
	return ( m_ItemSlot >= DOTA_ITEM_STASH_MIN );
}

function RightClickItem()
{
	ItemHideTooltipInit();

	var bSlotInStash = IsInStash();
	var bControllable = Entities.IsControllableByPlayer( m_QueryUnit, Game.GetLocalPlayerID() );
	var bSellable = Items.IsSellable( m_Item ) && Items.CanBeSoldByLocalPlayer( m_Item );
	var bDisassemble = Items.IsDisassemblable( m_Item ) && bControllable && !bSlotInStash;
	var bAlertable = Items.IsAlertableItem( m_Item );
	var bShowInShop = Items.IsPurchasable( m_Item );
	var bDropFromStash = bSlotInStash && bControllable;

	if ( !bSellable && !bDisassemble && !bShowInShop && !bDropFromStash && !bAlertable && !bMoveToStash )
	{
		// don't show a menu if there's nothing to do
		return;
	}

	var bMoveToStash = true; // TODO
	/*
	bool bMoveToStash = false;
	bool bIsInventoryEditable = ( pDisplayedUnit == pPlayer->GetSelectedUnit() );
	bool bIsStashHero = ( pDisplayedUnit == GetHeroForStashDisplay() );		// orders don't support an m_Item move from inventory to stash of a different unit. for now only allow moves from the same unit
	bool bIsStashAccessible = pDisplayedUnit->IsInRangeOfShop( DOTA_SHOP_HOME ) || !pDisplayedUnit->IsAlive();
	if ( bIsInventoryEditable && bIsStashHero && bIsStashAccessible && pDisplayedUnit->IsControllableByPlayer( pPlayer->GetPlayerID() ) )
	{
		if ( pItem->IsDroppable() && ( iSlot >= 0 && iSlot < DOTA_ITEM_STASH_MIN ) )
		{
			bMoveToStash = true;
		}

		if ( pItem->GetShareability() == ITEM_NOT_SHAREABLE && pItem->GetPurchaser() != GetHeroForStashDisplay() )
		{
			bMoveToStash = false;
		}
	}	
	*/

	var contextMenu = $.CreatePanel( "DOTAContextMenuScript", $.GetContextPanel(), "" );
	contextMenu.AddClass( "ContextMenu_NoArrow" );
	contextMenu.AddClass( "ContextMenu_NoBorder" );
	contextMenu.GetContentsPanel().Item = m_Item;
	contextMenu.GetContentsPanel().SetHasClass( "bSellable", bSellable );
	contextMenu.GetContentsPanel().SetHasClass( "bDisassemble", bDisassemble );
	contextMenu.GetContentsPanel().SetHasClass( "bShowInShop", bShowInShop );
	contextMenu.GetContentsPanel().SetHasClass( "bDropFromStash", bDropFromStash );
	contextMenu.GetContentsPanel().SetHasClass( "bAlertable", bAlertable );
	contextMenu.GetContentsPanel().SetHasClass( "bMoveToStash", bMoveToStash );
	contextMenu.GetContentsPanel().BLoadLayout( "file://{resources}/layout/custom_game/inventory_context_menu.xml", false, false );
}

function OnDragEnter( a, draggedPanel )
{
	var draggedItem = draggedPanel.m_DragItem;

	// only care about dragged items other than us
	if ( draggedItem === null || draggedItem == m_Item )
		return true;

	// highlight this panel as a drop target
	$.GetContextPanel().AddClass( "potential_drop_target" );
	return true;
}

function OnDragDrop( panelId, draggedPanel )
{
	var draggedItem = draggedPanel.m_DragItem;
	
	// only care about dragged items other than us
	if ( draggedItem === null )
		return true;

	// executing a slot swap - don't drop on the world
	draggedPanel.m_DragCompleted = true;
	
	// item dropped on itself? don't acutally do the swap (but consider the drag completed)
	if ( draggedItem == m_Item )
		return true;
	if (draggedPanel.m_type == "inventory")
	{
		// create the order
		if (draggedPanel.lockOrder){
			return false
		}
		var moveItemOrder =
		{
			OrderType: dotaunitorder_t.DOTA_UNIT_ORDER_MOVE_ITEM,
			TargetIndex: m_ItemSlot,
			AbilityIndex: draggedItem
		};
		Game.PrepareUnitOrders( moveItemOrder );
		if ((draggedPanel.m_inventory_from_slot > 5) && (m_ItemSlot <= 5)){
			GameEvents.SendCustomGameEventToServer( "item_drag_from_backpack", {itemIndex: draggedItem});
		}
		if (m_ItemSlot > 5){
			if (m_Item > -1){
				GameEvents.SendCustomGameEventToServer( "item_drag_from_backpack", {itemIndex: m_Item});
			}
		}
		return true;
	}else if(draggedPanel.m_type == "stash"){
		
		if (Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ) == Players.GetLocalPlayerPortraitUnit())
		{
			$.Msg('dragged from stash to inventory')
			var playerID = Game.GetLocalPlayerID();
			if (GameUI.CustomUIConfig().stashAllowed == 1){
				GameUI.CustomUIConfig().stashAllowed = 0;
				GameEvents.SendCustomGameEventToServer( "item_dragged_from_stash_to_inventory", {playerID: playerID, itemIndex: draggedItem, stashSlot: draggedPanel.m_fromSlot, inventorySlot: $.GetContextPanel().m_inventoryStartSlot});
			}
		}
	}
}

function OnDragLeave( panelId, draggedPanel )
{
	var draggedItem = draggedPanel.m_DragItem;
	if ( draggedItem === null || draggedItem == m_Item )
		return false;

	// un-highlight this panel
	$.GetContextPanel().RemoveClass( "potential_drop_target" );
	return true;
}

function OnDragStart( panelId, dragCallbacks )
{
	if ( m_Item == -1 )
	{
		return true;
	}
	if (!(Players.GetLocalPlayer() == m_PlayerID))
	{
		return true;
	}
	var itemName = Abilities.GetAbilityName( m_Item );

	ItemHideTooltipInit(); // tooltip gets in the way

	// create a temp panel that will be dragged around
	var displayPanel = $.CreatePanel( "DOTAItemImage", $.GetContextPanel(), "dragImage" );
	displayPanel.itemname = itemName;
	displayPanel.fromInventory = true;
	displayPanel.contextEntityIndex = m_Item;
	displayPanel.m_DragItem = m_Item;
	displayPanel.m_Item = m_Item;
	displayPanel.m_DragCompleted = false; // whether the drag was successful
	displayPanel.m_type = m_type;
	displayPanel.m_inventory_from_slot = m_ItemSlot;

	// hook up the display panel, and specify the panel offset from the cursor
	dragCallbacks.displayPanel = displayPanel;
	dragCallbacks.offsetX = 0;
	dragCallbacks.offsetY = 0;
	if (itemName.indexOf("_glyph_") > 0 ){
		displayPanel.glyph = true;
		GameUI.CustomUIConfig().glyph1.AddClass('glyph_ready')
		GameUI.CustomUIConfig().glyph2.AddClass('glyph_ready')
		GameUI.CustomUIConfig().glyph3.AddClass('glyph_ready')
	}
	// grey out the source panel while dragging
	$.GetContextPanel().AddClass( "dragging_from" );
	return true;
}

function OnDragEnd( panelId, draggedPanel )
{
	// if the drag didn't already complete, then try dropping in the world
	if ( !draggedPanel.m_DragCompleted )
	{
		Game.DropItemAtCursor( m_QueryUnit, m_Item );
	}
	if (draggedPanel.glyph){
		GameUI.CustomUIConfig().glyph1.RemoveClass('glyph_ready')
		GameUI.CustomUIConfig().glyph2.RemoveClass('glyph_ready')
		GameUI.CustomUIConfig().glyph3.RemoveClass('glyph_ready')
		$.Msg("GLYPH REMOVE READY")		
	}
	// kill the display panel
	draggedPanel.DeleteAsync( 0 );

	// restore our look
	$.GetContextPanel().RemoveClass( "dragging_from" );
	return true;
}

function SetItemSlot( itemSlot )
{
	m_ItemSlot = itemSlot;
	$.GetContextPanel().m_inventoryStartSlot = m_ItemSlot
}

function SetItem( queryUnit, iItem, playerID, itemSlot )
{

	m_Item = iItem;
	m_QueryUnit = queryUnit;
	m_PlayerID = playerID;
	m_ItemSlot = itemSlot;
}

(function()
{
	$.GetContextPanel().SetItem = SetItem;
	$.GetContextPanel().SetItemSlot = SetItemSlot;

	// Drag and drop handlers ( also requires 'draggable="true"' in your XML, or calling panel.SetDraggable(true) )
	$.RegisterEventHandler( 'DragEnter', $.GetContextPanel(), OnDragEnter );
	$.RegisterEventHandler( 'DragDrop', $.GetContextPanel(), OnDragDrop );
	$.RegisterEventHandler( 'DragLeave', $.GetContextPanel(), OnDragLeave );
	$.RegisterEventHandler( 'DragStart', $.GetContextPanel(), OnDragStart );
	$.RegisterEventHandler( 'DragEnd', $.GetContextPanel(), OnDragEnd );

	UpdateItem(); // initial update of dynamic state
})();
