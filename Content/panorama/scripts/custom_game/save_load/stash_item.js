"use strict";

var m_Item = -1;
var m_ItemSlot = -1;
var m_QueryUnit = -1;
var m_fromSlot = 0;
var m_disabled = 0;
var m_type = "stash";

function UpdateItem()
{
	var itemName = Abilities.GetAbilityName( m_Item );
	var hotkey = Abilities.GetKeybind( m_Item, m_QueryUnit );
	var isPassive = Abilities.IsPassive( m_Item );
	// var chargeCount = 0;
	// var hasCharges = false;
	// var altChargeCount = 0;
	// var hasAltCharges = false;
	
	// if ( Items.ShowSecondaryCharges( m_Item ) )
	// {
	// 	// Ward stacks display charges differently depending on their toggle state
	// 	hasCharges = true;
	// 	hasAltCharges = true;
	// 	if ( Abilities.GetToggleState( m_Item ) )
	// 	{
	// 		chargeCount = Items.GetCurrentCharges( m_Item );
	// 		altChargeCount = Items.GetSecondaryCharges( m_Item );
	// 	}
	// 	else
	// 	{
	// 		altChargeCount = Items.GetCurrentCharges( m_Item );
	// 		chargeCount = Items.GetSecondaryCharges( m_Item );
	// 	}
	// }
	// else if ( Items.ShouldDisplayCharges( m_Item ) )
	// {
	// 	hasCharges = true;
	// 	chargeCount = Items.GetCurrentCharges( m_Item );
	// }

	$.GetContextPanel().SetHasClass( "no_item", (m_Item == -1) );
	// $.GetContextPanel().SetHasClass( "show_charges", hasCharges );
	// $.GetContextPanel().SetHasClass( "show_alt_charges", hasAltCharges );
	$.GetContextPanel().SetHasClass( "is_passive", isPassive );
	
	// $( "#HotkeyText" ).text = hotkey;
	// $.Msg(itemName);
	// $( "#ItemImage" ).itemname = itemName;
	$( "#ItemImage" ).contextEntityIndex = m_Item;
	if (m_Item == -1){
		$( "#ItemImage" ).SetImage("file://{images}/custom_game/ui/empty-inventory-slot.png")
	}
	// $( "#ChargeCount" ).text = chargeCount;
	// $( "#AltChargeCount" ).text = altChargeCount;
	
	// if ( m_Item == -1 || Abilities.IsCooldownReady( m_Item ) )
	// {
	// 	$.GetContextPanel().SetHasClass( "cooldown_ready", true );
	// 	$.GetContextPanel().SetHasClass( "in_cooldown", false );
	// }
	// else
	// {
	// 	$.GetContextPanel().SetHasClass( "cooldown_ready", false );
	// 	$.GetContextPanel().SetHasClass( "in_cooldown", true );
	// 	var cooldownLength = Abilities.GetCooldownLength( m_Item );
	// 	var cooldownRemaining = Abilities.GetCooldownTimeRemaining( m_Item );
	// 	var cooldownPercent = Math.ceil( 100 * cooldownRemaining / cooldownLength );
	// 	$( "#CooldownTimer" ).text = Math.ceil( cooldownRemaining );
	// 	$( "#CooldownOverlay" ).style.width = cooldownPercent+"%";
	// }
	if (m_Item == -1){
		$.Schedule( 0.1, UpdateItem );
	}
	else{
		$.Schedule( 2, UpdateItem );
	}
	
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

function ItemShowTooltip()
{
	var item = m_Item
	var queryUnit = m_QueryUnit
	if ( item == -1 )
		return;
	var itemName = Abilities.GetAbilityName( item );
	var queryUnit = Players.GetLocalPlayerPortraitUnit();

	var itemValues = CustomNetTables.GetTableValue( "item_basics", item.toString() )
	if (itemValues === undefined){
		$.DispatchEvent("DOTAShowAbilityTooltipForEntityIndex", $.GetContextPanel(), itemName, item);
	}else{
		var itemProperty1 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-1" )
		var tooltip = CreateCustomTooltip(itemValues, itemName, itemProperty1)
		tooltip = AddAffixToItem(tooltip, itemProperty1)
		if (itemValues.rarityFactor >= 2 )
		{
			var itemProperty2 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-2" )
			tooltip = AddAffixToItem(tooltip, itemProperty2)
		}
		if (itemValues.rarityFactor >= 3 )
		{
			var itemProperty3 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-3" )
			tooltip = AddAffixToItem(tooltip, itemProperty3)
		}
		if (itemValues.rarityFactor >= 4 )
		{
			var itemProperty4 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-4" )
			tooltip = AddAffixToItem(tooltip, itemProperty4)
		}
		var itemPrefix = ""
		var itemSuffix = ""
		//$.Msg( itemValues.property1 );
		//$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", $.GetContextPanel(), itemName, queryUnit );
		var title = "<font color='"+itemValues.qualityColor+"'>"+itemPrefix+" "+itemValues.itemName+" "+itemSuffix+"</font>"
		if (!(itemValues.minLevel ===undefined)){
			tooltip = AddMinLevelToTooltip(itemValues, tooltip)
		}		
		tooltip = AddSpecialDescriptionToTooltip(tooltip, itemProperty1, itemProperty2, itemProperty3, itemProperty4, itemValues.rarityFactor, item)
		tooltip = updateSkillInTooltip(tooltip, queryUnit)
		title = title.replace(/(['"])/g, "\\$1");
		tooltip = tooltip.replace(/(['"])/g, "\\$1");

		$.DispatchEvent("DOTAShowTitleTextTooltip", $.GetContextPanel(), title, tooltip);
		//$.DispatchEvent("DOTAShowTitleTextTooltip", $.GetContextPanel(),  "#DOTA_Tooltip_ability_"+itemName, tooltip );
	}
}

function AddMinLevelToTooltip(itemValues, tooltip)
{
	var minLevel = itemValues.minLevel
	if (minLevel > 0){
		tooltip = tooltip + "<br><br><font color='#DB2766'>"+$.Localize('#item_min_level')+": "+minLevel+"</font>"
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
			specialText1 = SpecialDescriptionValues(specialText1, item)
			specialBreak=true;
			specialText1 = breakUpTooltip(specialText1)
		}
	}
	if (!(itemProperty2 === undefined)){
		if (rarityFactor >= 2){
			if (!(itemProperty2.specialDescription === undefined)){
				specialText2 = "<br>"+$.Localize(itemProperty2.specialDescription)
				specialText2 = SpecialDescriptionValues(specialText2, item)
				specialBreak=true;
				specialText2 = breakUpTooltip(specialText2)
			}
		}
	}
	if (!(itemProperty3 === undefined)){
		if (rarityFactor >= 3){
			if (!(itemProperty3.specialDescription === undefined)){
				specialText3 = "<br>"+$.Localize(itemProperty3.specialDescription)
				specialText3 = SpecialDescriptionValues(specialText3, item)
				specialBreak=true;
				specialText3 = breakUpTooltip(specialText3)
			}
		}
	}
	if (!(itemProperty4 === undefined)){
		if (rarityFactor >= 4){
			if (!(itemProperty4.specialDescription === undefined)){
				specialText4 = "<br>"+$.Localize(itemProperty4.specialDescription)
				specialText4 = SpecialDescriptionValues(specialText4, item)
				specialBreak=true;
				specialText4 = breakUpTooltip(specialText4)
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
	// $.Msg( itemValues );
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

function ItemHideTooltip()
{
	$.DispatchEvent( "DOTAHideTitleTextTooltip", $.GetContextPanel() );
	$.DispatchEvent( "DOTAHideAbilityTooltip", $.GetContextPanel() );
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

var DOTA_ITEM_STASH_MIN = 6;

function IsInStash()
{
	return ( m_ItemSlot >= DOTA_ITEM_STASH_MIN );
}

function RightClickItem()
{
	ItemHideTooltip();

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
	// $.Msg(draggedItem)
	// only care about dragged items other than us
	if ( draggedItem === null )
		return true;

	// executing a slot swap - don't drop on the world
	draggedPanel.m_DragCompleted = true;
	
	// item dropped on itself? don't acutally do the swap (but consider the drag completed)
	if ( draggedItem == m_Item )
		return true;

	// create the order
	// var moveItemOrder =
	// {
	// 	OrderType: dotaunitorder_t.DOTA_UNIT_ORDER_MOVE_ITEM,
	// 	TargetIndex: m_ItemSlot,
	// 	AbilityIndex: draggedItem
	// };
	// Game.PrepareUnitOrders( moveItemOrder );
	// $.Msg("slot: "+$.GetContextPanel().slot)
	var playerID = Game.GetLocalPlayerID();
	// $.Msg("FROM SLOT")
	// $.Msg(draggedPanel.m_fromSlot)
	if ((draggedPanel.m_type == "inventory") || (draggedPanel.m_type == "stash")){
		if (draggedPanel.m_fromSlot === undefined){
			draggedPanel.m_fromSlot = 0
		}
		if (GameUI.CustomUIConfig().stashAllowed == 1){
			GameUI.CustomUIConfig().stashAllowed = 0
			GameEvents.SendCustomGameEventToServer( "item_dragged_to_stash", {playerID: playerID, itemIndex: draggedItem, slot: $.GetContextPanel().slot, fromSlot: draggedPanel.m_fromSlot});
		}
	}
	$.GetContextPanel().scrollingParent.style.overflow = "scroll"
	m_fromSlot = 0;
	return true;
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
	var itemName = Abilities.GetAbilityName( m_Item );

	ItemHideTooltip(); // tooltip gets in the way
	$.GetContextPanel().scrollingParent.style.overflow = "clip"
	// create a temp panel that will be dragged around
	var displayPanel = $.CreatePanel( "DOTAItemImage", $.GetContextPanel(), "dragImage" );
	displayPanel.itemname = itemName;
	displayPanel.contextEntityIndex = m_Item;
	displayPanel.m_DragItem = m_Item;
	displayPanel.m_DragCompleted = false; // whether the drag was successful
	displayPanel.m_fromSlot = $.GetContextPanel().slot
	displayPanel.m_stashSlot = $.GetContextPanel().slot
	displayPanel.m_type = m_type;

	// hook up the display panel, and specify the panel offset from the cursor
	dragCallbacks.displayPanel = displayPanel;
	dragCallbacks.offsetX = 0;
	dragCallbacks.offsetY = 0;
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
	// $.GetContextPanel().scrollingParent.ScrollToTop()
	// $.GetContextPanel().scrollingParent.ScrollToLeftEdge()
	// kill the display panel
	draggedPanel.DeleteAsync( 0 );
	// m_fromSlot = 0
	// restore our look
	$.GetContextPanel().RemoveClass( "dragging_from" );
	$.GetContextPanel().scrollingParent.style.overflow = "scroll"
	return true;
}

function SetItemSlot( itemSlot )
{
	m_ItemSlot = itemSlot;
}

function SetItem( queryUnit, iItem )
{
	m_Item = iItem;
	m_QueryUnit = queryUnit;
	m_fromSlot = 0
	$('#ItemImage').SetAttributeInt("item", iItem);
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
