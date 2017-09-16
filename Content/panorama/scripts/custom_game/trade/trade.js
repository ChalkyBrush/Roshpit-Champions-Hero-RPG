function InitializePool(){
	// $('#pool_menu_title').text= $.Localize('#saveload_stash_description')
	// $('#premium_stash_label').text = $.Localize('#premium_stash_slots')
	// $('#pool_menu_title').text = $.Localize('#saveload_stash_description')
	CreateTradeItemPanels()
	var playerFrom = $.GetContextPanel().playerFrom
	var playerTo = $.GetContextPanel().playerTo
	$('#hero_portrait_trade1_label').text = Players.GetPlayerName(playerFrom);
	$('#hero_portrait_trade2_label').text = Players.GetPlayerName(playerTo);

	var hero_image_name = "file://{images}/heroes/" + Entities.GetUnitName(Players.GetPlayerHeroEntityIndex( playerFrom )) + ".png";
	$('#hero_portrait_trade1').SetImage( hero_image_name );
	var hero_image_name = "file://{images}/heroes/" + Entities.GetUnitName(Players.GetPlayerHeroEntityIndex( playerTo )) + ".png";
	$('#hero_portrait_trade2').SetImage( hero_image_name );
}

var m_LeftPanels = []
var m_RightPanels = []

// Currently hardcoded: first 6 are inventory, next 6 are stash items
var STASH_SIZE = 6;

function UpdateStash(msg)
{
	var result = msg.result
	$.Msg(msg.result)
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	var playerID = msg.playerID
	for ( var i = 1; i <= STASH_SIZE; ++i )
	{
		var stashItem = CustomNetTables.GetTableValue( "stash", playerID.toString()+"-"+i.toString() )
		var inventoryPanel = m_InventoryPanels[i-1]
		if (stashItem === undefined){
			inventoryPanel.SetItem( queryUnit, -1 );
		}else if (stashItem.itemIndex == 0){
			inventoryPanel.SetItem( queryUnit, -1 );
		}else{
			inventoryPanel.SetItem( queryUnit, stashItem.itemIndex );
			$.Msg("the item!?")
			$.Msg(stashItem.itemIndex)
		}
	}
}

function UpdateStashAfterDrag(msg)
{

}


function CreateTradeItemPanels()
{
	$.GetContextPanel().locked = 0
	var firstRowPanel = $( "#trade_row_1" );
	var secondRowPanel = $( "#trade_row_2" );
	if ( !firstRowPanel || !secondRowPanel ){
		$.Msg("HELLO?")
		return;
	}

	firstRowPanel.RemoveAndDeleteChildren();
	secondRowPanel.RemoveAndDeleteChildren();

	for ( var i = 0; i < STASH_SIZE; ++i )
	{	
		var parentPanel;
		if (i < 3){
			parentPanel = firstRowPanel;
		}
		else if ( (i > 2) && (i < 6) )
		{
			parentPanel = secondRowPanel;
		}else if( (i >= 6) && (i < 9) ){
			parentPanel = rowPanel3;
		}else if( (i >= 9) && (i < 12) ){
			parentPanel = rowPanel4;
		}else if( (i >= 12) && (i < 15) ){
			parentPanel = rowPanel5;
		}else if( (i >= 15) && (i < 18) ){
			parentPanel = rowPanel6;
		}else if( (i >= 18) && (i < 21) ){
			parentPanel = rowPanel7;
		}else{
			parentPanel = rowPanel8;
		}

		var inventoryPanel = $.CreatePanel( "Panel", parentPanel, "" );
		inventoryPanel.slot = i+1
		inventoryPanel.lockCheckPanel = $.GetContextPanel()
		inventoryPanel.BLoadLayout( "file://{resources}/layout/custom_game/trade/trade_item.xml", false, false );
		inventoryPanel.SetItemSlot( i+1 );

		m_LeftPanels.push( inventoryPanel );
	}
	var firstRowPanel2 = $( "#trade_row_1_p2" );
	var secondRowPanel2 = $( "#trade_row_2_p2" );
	for ( var i = 0; i < STASH_SIZE; ++i )
	{	
		var parentPanel;
		if (i < 3){
			parentPanel = firstRowPanel2;
		}
		else if ( (i > 2) && (i < 6) )
		{
			parentPanel = secondRowPanel2;
		}

		var inventoryPanel = $.CreatePanel( "Panel", parentPanel, "" );
		inventoryPanel.slot = i+1+STASH_SIZE
		inventoryPanel.lockCheckPanel = $.GetContextPanel()
		inventoryPanel.BLoadLayout( "file://{resources}/layout/custom_game/trade/trade_item.xml", false, false );
		inventoryPanel.SetItemSlot( i+1+STASH_SIZE );
		inventoryPanel.SetDraggable( false )
		m_RightPanels.push( inventoryPanel );
	}
}

function trade_cancel(msg)
{
	var player1 = $.GetContextPanel().playerFrom
	var player2 = $.GetContextPanel().playerTo
	var hero1 = Players.GetPlayerHeroEntityIndex( player1 )
	var hero2 = Players.GetPlayerHeroEntityIndex( player2 )

GameEvents.SendCustomGameEventToServer( "cancel_trade", {heroFrom: hero1, heroTo: hero2, sentBy: Players.GetLocalPlayer()});


}



function getLeftPlayer(localPlayer)
{

}

function final_trade_close(msg)
{
	$.GetContextPanel().locked = 1
	$('#trade_buttons_container').AddClass('invisible')
	var panel;
	if (Players.GetLocalPlayer() == msg.sentBy){
		panel = $('#trade-bg-p1')
	}else{
		panel = $('#trade-bg-p2')
	}
	panel.AddClass('cancel-bg')
	panel.RemoveClass('accept-bg')
	panel.RemoveClass('base-bg')
	$.Schedule(0.65, function(){
		Game.EmitSound("Item.DropRingShop");
		$.GetContextPanel().DeleteAsync(0)
		
	});


}

function trade_final_close_accept(msg)
{
	$.Schedule(0.65, function(){
		Game.EmitSound("Item.PickUpGemShop");
		$.GetContextPanel().DeleteAsync(0)
	});
}

function trade_accept()
{
	GameEvents.SendCustomGameEventToServer( "update_trade_lock", {playerID: Players.GetLocalPlayer()});
}

function trade_lock_updated(msg){
	var leftLock = msg.leftLock
	var rightLock = msg.rightLock

	if (leftLock == 1){
		$('#trade-bg-p1').RemoveClass('base-bg')
		$('#trade-bg-p1').AddClass('accept-bg')
	}else{
		$('#trade-bg-p1').RemoveClass('accept-bg')
		$('#trade-bg-p1').AddClass('base-bg')
	}

	if (rightLock == 1){
		$('#trade-bg-p2').RemoveClass('base-bg')
		$('#trade-bg-p2').AddClass('accept-bg')
	}else{
		$('#trade-bg-p2').RemoveClass('accept-bg')
		$('#trade-bg-p2').AddClass('base-bg')
	}

	if ((leftLock == 0) && (rightLock == 0) )
	{
		$('#trade-accept-image').SetImage("file://{images}/custom_game/ui/trade-lock.png")
		$('#accept-button').AddClass('trade-button-accept')
		$('#accept-button').RemoveClass('trade-button-unlock')
	}
	if ((leftLock == 1) && (rightLock == 0) )
	{
		$('#trade-accept-image').SetImage("file://{images}/custom_game/ui/trade-unlock.png")
		$('#accept-button').AddClass('trade-button-unlock')
		$('#accept-button').RemoveClass('trade-button-accept')
	}
	if ((leftLock == 0) && (rightLock == 1)){
		$('#trade-accept-image').SetImage("file://{images}/custom_game/ui/trade-y.png")
	}
	if ((leftLock == 1) && (rightLock == 1)){
		$.GetContextPanel().locked = 1
		$('#trade_buttons_container').AddClass('invisible')
	} 
}


// (function()
// {
// 	CreateInventoryPanels();
// 	UpdateInventory();

// 	GameEvents.Subscribe( "dota_inventory_changed", UpdateInventory );
// 	GameEvents.Subscribe( "dota_inventory_item_changed", UpdateInventory );
// 	GameEvents.Subscribe( "m_event_dota_inventory_changed_query_unit", UpdateInventory );
// 	GameEvents.Subscribe( "m_event_keybind_changed", UpdateInventory );
// 	GameEvents.Subscribe( "dota_player_update_selected_unit", UpdateInventory );
// 	GameEvents.Subscribe( "dota_player_update_query_unit", UpdateInventory );
// })();

function TradeItemAdded(msg)
{
	$.Msg("ADDED?")
	$.Msg(msg.itemsLeft)
	var itemsLeft = msg.itemsLeft
	var itemsRight = msg.itemsRight
	Object.keys(itemsLeft).forEach(function (key) { 
	    var item = itemsLeft[key]
	    var index = parseInt(key)-1
		m_LeftPanels[index].SetItem( -1, item )	
	})
	Object.keys(itemsRight).forEach(function (key) { 
	    var item = itemsRight[key]
	    var index = parseInt(key)-1
		m_RightPanels[index].SetItem( -1, item )
	})
}


(function()
{
	InitializePool();
	GameEvents.Subscribe( "trade_panels_updated", CreateTradeItemPanels );
	GameEvents.Subscribe( "trade_final_close", final_trade_close );

	GameEvents.Subscribe( "trade_item_added", TradeItemAdded )
	GameEvents.Subscribe( "trade_lock_updated", trade_lock_updated)
	GameEvents.Subscribe( "trade_final_close_accept", trade_final_close_accept)
})();

