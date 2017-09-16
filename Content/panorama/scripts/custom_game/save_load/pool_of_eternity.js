function InitializePool(){
	$('#pool_menu_title').text= $.Localize('#saveload_stash_description')
	$('#premium_stash_label').text = $.Localize('#premium_stash_slots')
	// $('#pool_menu_title').text = $.Localize('#saveload_stash_description')

}

var m_InventoryPanels = []

// Currently hardcoded: first 6 are inventory, next 6 are stash items
var STASH_SIZE = 48;
var PREMIUM_SIZE = 30;

function UpdateStash(msg)
{
	CreateStashPanels(msg)
	// var result = msg.result
	// $.Msg(msg.result)
	// var queryUnit = Players.GetLocalPlayerPortraitUnit();
	// var playerID = msg.playerID
	// for ( var i = 1; i <= STASH_SIZE; ++i )
	// {
	// 	var stashItem = CustomNetTables.GetTableValue( "stash", playerID.toString()+"-"+i.toString() )
	// 	// var inventoryPanel = m_InventoryPanels[i-1]
	// 	// if (stashItem === undefined){
	// 	// 	// inventoryPanel.SetItem( queryUnit, -1 );
	// 	// 	SetInventoryItem(queryUnit, -1, inventoryPanel)
	// 	// }else if (stashItem.itemIndex == 0){
	// 	// 	SetInventoryItem(queryUnit, -1, inventoryPanel)
	// 	// 	// inventoryPanel.SetItem( queryUnit, -1 );
	// 	// }else{
	// 	// 	SetInventoryItem(queryUnit, stashItem.itemIndex, inventoryPanel)
	// 	// 	// inventoryPanel.SetItem( queryUnit, stashItem.itemIndex );
	// 	// 	$.Msg("the item!?")
	// 	// 	$.Msg(stashItem.itemIndex)
	// 	// }
	// }
}

function UpdateStashAfterDrag(msg)
{

}

function PremiumTooltip()
{
	var panel = $('#premium_info')
	var title = "<font color='yellow'>"+$.Localize('#premium_stash_slots')
	var tooltip = $.Localize('#premium_stash_info_tooltip')
	tooltip = breakUpTooltip(tooltip)
	$.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function HidePremiumTooltip(){

	var panel = $('#premium_info')
	$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
}

function breakUpTooltip(specialText){
	var spacePosition10 = getPosition(specialText, " ", 8)
	var spacePosition20 = getPosition(specialText, " ", 16)
	var spacePosition30 = getPosition(specialText, " ", 24)
	var spacePosition40 = getPosition(specialText, " ", 32)
	var brIndex = specialText.substring(0, spacePosition10).length
	var br = "<br>"
	var br2 = "<br>"
	var br3 = "<br>"
	var br4 = "<br>"
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
	brIndex = specialText.substring(0, spacePosition40).length
	if (spacePosition40 >= specialText.length){
		br4 = ""
	}
	specialText= specialText.substring(0, spacePosition10) + br + specialText.substring(spacePosition10+1, spacePosition20) + br2 + specialText.substring(spacePosition20+1, spacePosition30) + br3 + specialText.substring(spacePosition30+1, spacePosition40) + br4 + specialText.substring(spacePosition40+1, specialText.length)
	return specialText
}

function getPosition(str, m, i) {
   return str.split(m, i).join(m).length;
}


function CreateStashPanels(msg)
{
	$.Msg("CREATE STASH PANELS")
	var playerID = msg.playerID
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	GameUI.CustomUIConfig().stashAllowed = 1;
	$.GetContextPanel().RemoveClass( "dragging_from" );
	var firstRowPanel = $( "#stash_row_1" );
	var secondRowPanel = $( "#stash_row_2" );
	var rowPanel3 = $( "#stash_row_3" );
	var rowPanel4 = $( "#stash_row_4" );
	var rowPanel5 = $( "#stash_row_5" );
	var rowPanel6 = $( "#stash_row_6" );
	var rowPanel7 = $( "#stash_row_7" );
	var rowPanel8 = $( "#stash_row_8" );
	var rowPanel9 = $( "#stash_row_9" );
	var rowPanel10 = $( "#stash_row_10" );
	var rowPanel11 = $( "#stash_row_11" );
	var rowPanel12 = $( "#stash_row_12" );
	if ( !firstRowPanel || !secondRowPanel ){
		return;
	}
	

	firstRowPanel.RemoveAndDeleteChildren();
	secondRowPanel.RemoveAndDeleteChildren();
	rowPanel3.RemoveAndDeleteChildren();
	rowPanel4.RemoveAndDeleteChildren();
	rowPanel5.RemoveAndDeleteChildren();
	rowPanel6.RemoveAndDeleteChildren();
	rowPanel7.RemoveAndDeleteChildren();
	rowPanel8.RemoveAndDeleteChildren();
	rowPanel9.RemoveAndDeleteChildren();
	rowPanel10.RemoveAndDeleteChildren();
	rowPanel11.RemoveAndDeleteChildren();
	rowPanel12.RemoveAndDeleteChildren();
	m_InventoryPanels = []

	for ( var i = 1; i <= STASH_SIZE; ++i )
	{	
		var parentPanel;
		if (i <= 6){
			parentPanel = firstRowPanel;
		}
		else if ( (i > 6) && (i <= 12) )
		{
			parentPanel = secondRowPanel;
		}else if( (i > 12) && (i <= 18) ){
			parentPanel = rowPanel3;
		}else if( (i > 18) && (i <= 24) ){
			parentPanel = rowPanel4;
		}else if( (i > 24) && (i <= 30) ){
			parentPanel = rowPanel5;
		}else if( (i > 30) && (i <= 36) ){
			parentPanel = rowPanel6;
		}
		else if( (i > 36) && (i <= 42) ){
			parentPanel = rowPanel7;
		}
		else if( (i > 42) && (i <= 48) ){
			parentPanel = rowPanel8;
		}
		// }else if( (i >= 21) && (i < 24) ){
		// 	parentPanel = rowPanel8;
		// }else if( (i >= 24) && (i < 27) ){
		// 	parentPanel = rowPanel9;
		// }else{
		// 	parentPanel = rowPanel10;
		// }

		var inventoryPanel = $.CreatePanel( "Panel", parentPanel, "stash-panel"+i );
		inventoryPanel.SetDraggable( true)
		inventoryPanel.slot = i+1
		inventoryPanel.scrollingParent = $('#pool_container')
		// inventoryPanel.hittest(true)
		// inventoryPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/pool_of_eternity_item.xml", false, false );
		inventoryPanel.BLoadLayoutSnippet( "pool_item" );


		var itemImage = snippetInventoryPanel(inventoryPanel, i+1)

		var stashItem = CustomNetTables.GetTableValue( "stash", playerID.toString()+"-"+i.toString() )
		// var inventoryPanel = m_InventoryPanels[i-1]
		if (stashItem === undefined){
			// inventoryPanel.SetItem( queryUnit, -1 );
			SetInventoryItem(queryUnit, -1, inventoryPanel, i)
		}else if (stashItem.itemIndex == 0){
			SetInventoryItem(queryUnit, -1, inventoryPanel, i)
			// inventoryPanel.SetItem( queryUnit, -1 );
		}else{
			SetInventoryItem(queryUnit, stashItem.itemIndex, inventoryPanel, i)
			// inventoryPanel.SetItem( queryUnit, stashItem.itemIndex );
			// $.Msg("the item!?")
			// $.Msg(stashItem.itemIndex)
		}
		UpdateItem(itemImage)

		// var draggablePanel = itemImage.GetParent()
		RegisterEventHandlers(inventoryPanel)

		m_InventoryPanels.push(itemImage);

		AddMouseOverToItemImage(i);
		AddMouseOutToItemImage(i);
		// $.Msg(m_InventoryPanels)
	}
}

function RegisterEventHandlers(draggablePanel)
{
	$.RegisterEventHandler('DragEnter', draggablePanel, OnDragEnter );
	$.RegisterEventHandler('DragDrop', draggablePanel, OnDragDrop );
	$.RegisterEventHandler('DragLeave', draggablePanel, OnDragLeave );
	$.RegisterEventHandler('DragStart', draggablePanel, OnDragStart);
	$.RegisterEventHandler('DragEnd', draggablePanel, OnDragEnd );	
}

function AddMouseOverToItemImage(index)
{
	var itemImage = m_InventoryPanels[index-1]
	itemImage.GetParent().SetPanelEvent('onmouseover', function ShowTooltip() {
		stashShowItemTooltip(itemImage)
	})	
}

function AddMouseOutToItemImage(index)
{
	var itemImage = m_InventoryPanels[index-1]
	itemImage.GetParent().SetPanelEvent('onmouseout', function HideTooltip() {
		stashHideItemTooltip(itemImage)
	})	
}

function stashShowItemTooltip(itemImage)
{
	ItemShowTooltipOnPanel(itemImage)
}

function stashHideItemTooltip(itemImage)
{

	ItemHideTooltipByPanel(itemImage)
}

function snippetInventoryPanel(panel, slotNumber)
{
	var itemImage = panel.FindChildTraverse('ItemImage')
	itemImage.parentPanel = panel

	return itemImage
}

function SetInventoryItem( queryUnit, iItem, inventoryPanel, slot )
{
	var itemImage = inventoryPanel.FindChildTraverse('ItemImage')
	itemImage.m_Item = iItem;
	itemImage.m_QueryUnit = queryUnit;
	itemImage.m_fromSlot = slot
	itemImage.SetAttributeInt("item", iItem);
	itemImage.GetParent().SetAttributeInt("item", iItem);
	itemImage.m_Item = iItem
	itemImage.m_type = "stash"
	itemImage.m_slot = slot
	itemImage.m_QueryUnit = Players.GetPlayerHeroEntityIndex( Game.GetLocalPlayerID());
}

function UpdateItem(itemImage)
{
	var itemName = Abilities.GetAbilityName( itemImage.m_Item);
	var isPassive = Abilities.IsPassive(itemImage.m_Item );


	itemImage.parentPanel.SetHasClass( "no_item", (itemImage.m_Item == -1) );
	// $.GetContextPanel().SetHasClass( "show_charges", hasCharges );
	// $.GetContextPanel().SetHasClass( "show_alt_charges", hasAltCharges );
	itemImage.parentPanel.SetHasClass( "is_passive", isPassive );
	

	itemImage.contextEntityIndex = itemImage.m_Item;
	if (itemImage.m_Item == -1){
		itemImage.SetImage("file://{images}/custom_game/ui/empty-inventory-slot.png")
	}

	// if (itemImage.m_Item == -1){
	// 	$.Schedule( 0.1, UpdateItem(itemImage) );
	// }
	// else{
	// 	$.Schedule( 2, UpdateItem(itemImage) );
	// }
	
}



function OnDragEnter( panelId, draggedPanel, data3 )
{
	$.Msg(panelId)
	$.Msg(draggedPanel)
	var panel = $('#'+panelId)
	var m_Item = panel.m_Item
	var draggedItem = draggedPanel.m_Item
	$.Msg(draggedItem)
	// only care about dragged items other than us
	if ( draggedItem === null || draggedItem == m_Item )
		return true;

	// highlight this panel as a drop target
	panel.AddClass( "potential_drop_target" );
	$.Msg(panel)
	return true;
}

function OnDragDrop( panelId, draggedPanel )
{
	if (GameUI.CustomUIConfig().stashAllowed == 0){
		return false;
	}
	var panel = $('#'+panelId).FindChildTraverse('ItemImage')
	var m_Item = panel.m_Item
	var draggedItem = draggedPanel.m_Item
	$.Msg(draggedItem)
	$.Msg("STASH DRAG DROP")
	$.Msg(draggedItem)
	// only care about dragged items other than us
	if ( draggedItem === null )
		return true;

	// executing a slot swap - don't drop on the world
	draggedPanel.m_DragCompleted = true;
	
	// item dropped on itself? don't acutally do the swap (but consider the drag completed)
	if ( draggedItem == m_Item )
		return true;

	$.Msg("slot: "+panel.m_slot)
	var playerID = Game.GetLocalPlayerID();
	$.Msg("FROM SLOT")
	$.Msg(draggedPanel.m_fromSlot)
	if ((draggedPanel.m_type == "inventory") || (draggedPanel.m_type == "stash")){
		if (draggedPanel.m_fromSlot === undefined){
			draggedPanel.m_fromSlot = 0
		}
		if (GameUI.CustomUIConfig().stashAllowed == 1){
			GameUI.CustomUIConfig().stashAllowed = 0
			$.GetContextPanel().AddClass( "dragging_from" );
			$.Msg("dragged to stash")
			GameEvents.SendCustomGameEventToServer( "item_dragged_to_stash", {playerID: playerID, itemIndex: draggedItem, slot: panel.m_slot, fromSlot: draggedPanel.m_fromSlot, drag_type: draggedPanel.m_type});
		}
	}

	m_fromSlot = 0;
	return true;
}

function OnDragLeave( panelId, draggedPanel )
{
	var panel = $('#'+panelId)
	var m_Item = panel.m_Item
	var draggedItem = draggedPanel.m_Item

	if ( draggedItem === null || draggedItem == m_Item )
		return false;

	// un-highlight this panel
	panel.RemoveClass( "potential_drop_target" );
	return true;
}

function OnDragStart( panelId, dragCallbacks )
{	
	if (GameUI.CustomUIConfig().stashAllowed == 0){
		return false;
	}
	var panel = $('#'+panelId).FindChildTraverse('ItemImage')
	var m_Item = panel.m_Item
	$.Msg(m_Item)
	if ( m_Item == -1 )
	{
		return true;
	}
	var itemName = Abilities.GetAbilityName( m_Item );

	stashHideItemTooltip(panel)

	
	// create a temp panel that will be dragged around
	var displayPanel = $.CreatePanel( "DOTAItemImage", $.GetContextPanel(), "dragImage" );
	displayPanel.itemname = itemName;
	displayPanel.contextEntityIndex = m_Item;
	displayPanel.m_DragItem = m_Item;
	displayPanel.m_Item = m_Item;
	displayPanel.m_DragCompleted = false; // whether the drag was successful
	displayPanel.m_fromSlot = panel.m_slot
	displayPanel.m_stashSlot = panel.m_slot
	displayPanel.m_type = panel.m_type;

	// hook up the display panel, and specify the panel offset from the cursor
	dragCallbacks.displayPanel = displayPanel;
	dragCallbacks.offsetX = 0;
	dragCallbacks.offsetY = 0;
	// grey out the source panel while dragging
	panel.AddClass( "dragging_from" );
	return true;
}

function OnDragEnd( panelId, draggedPanel )
{
	var panel = $('#'+panelId).FindChildTraverse('ItemImage')
	var m_Item = panel.m_Item
	var m_QueryUnit = panel.m_QueryUnit
	var draggedItem = draggedPanel.m_Item
	// if the drag didn't already complete, then try dropping in the world
	// if ( !draggedPanel.m_DragCompleted )
	// {
	// 	Game.DropItemAtCursor( m_QueryUnit, m_Item );
	// }
	// $.GetContextPanel().scrollingParent.ScrollToTop()
	// $.GetContextPanel().scrollingParent.ScrollToLeftEdge()
	// kill the display panel
	draggedPanel.DeleteAsync( 0 );
	// m_fromSlot = 0
	// restore our look
	panel.RemoveClass( "dragging_from" );

	return true;
}





(function()
{

	InitializePool();
	// GameEvents.Subscribe( "stash_loaded", CreateStashPanels );
	GameEvents.Subscribe( "stash_loaded", UpdateStash );
	GameEvents.Subscribe( "stash_item_upated", UpdateStashAfterDrag );
	
	
})();

