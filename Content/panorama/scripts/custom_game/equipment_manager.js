"use strict";

function UpdateInventoryItem( itemSlot, item, queryUnit, parentPanel, ownerID )
{
	if (itemSlot==0){
	var abilityPanel = $("#helm_container");
	}
	if (itemSlot==1){
	var abilityPanel = $("#weapon_container");
	}
	if (itemSlot==2){
	var abilityPanel = $("#glove_container");
	}
	if (itemSlot==3){
	var abilityPanel = $("#boot_container");
	}
	if (itemSlot==4){
	var abilityPanel = $("#armor_container");
	}
	if (itemSlot==5){
	var abilityPanel = $("#amulet_container");
	}
	if (!(abilityPanel===null)){
	abilityPanel.SetAttributeInt( "itemSlot", itemSlot );
	abilityPanel.SetAttributeInt( "item", item );
	abilityPanel.SetAttributeInt( "ownerID", parseInt(ownerID))
	//abilityPanel.SetAttributeInt( "queryUnit", queryUnit );
	}

}

function UpdateInventory()
{
	var equipPanel = GameUI.CustomUIConfig().equipmentParent;
	if ( !equipPanel )
	{
		return;
	}


	// Brute-force recreate the entire inventory UI for now
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	var playerID = Players.GetLocalPlayer();
	$.Msg(Entities.IsHero(queryUnit))
	if (Entities.IsHero(queryUnit)){
		var playerTable = CustomNetTables.GetTableValue( "hero_index", queryUnit.toString() );
		if (playerTable === undefined){
			playerID= Players.GetLocalPlayer();
		}else{
			playerID = playerTable.playerOwner
		}
	}else{
		var playerID = Players.GetLocalPlayer();
	}
	$.Msg("playerID: "+playerID)

		for ( var i = 0; i < 6; ++i )
		{
			//var item = Entities.GetItemInSlot( queryUnit, i );
			var item = CustomNetTables.GetTableValue( "equipment", playerID.toString()+"-"+i.toString() );
			if (item){
				UpdateInventoryItem( i, item.itemIndex, "gg", equipPanel, playerID );
			}else{
				UpdateInventoryItem( i, -1, "gg", equipPanel, playerID );
			}
 
		}
	// if (playerID==Players.GetLocalPlayer()){
	// 	$('#recalculate_button_panel').RemoveClass('invisible');
	// }
	// else
	// {
	// 	$('#recalculate_button_panel').AddClass('invisible');
	// }
	UpdateGlyphDisplay(0)
	// UpdateQueryInventory()

}

function UpdateQueryInventory(){
	$.Msg("UPDATE QUERY UNIT::")
	$.Msg(Players.GetQueryUnit( Players.GetLocalPlayer() ))
	var queryUnit = Players.GetQueryUnit( Players.GetLocalPlayer() )
	if (queryUnit > -1){
	// if (Entities.IsHero( queryUnit )){
		var portrait = GameUI.DotaHUD.FindChildTraverse('QueryUnit').FindChildTraverse('QueryInfo')
		if (GameUI.queryPreview===undefined){
			var previewPanel = $.CreatePanel("Panel", portrait, "gear-preview")
			previewPanel.BLoadLayoutSnippet("equipment_query");
			GameUI.queryPreview = previewPanel
		}
	// }
	}
}

function recalculate_tooltip(){
	var title = "ui_recalculate_stats_button"
	var message = "ui_recalculate_stats_tooltip"
	message = $.Localize( "#"+message)
	title = $.Localize( "#"+title)
	var tooltip = message.replace(/(['"])/g, "\\$1");
	$.DispatchEvent("DOTAShowTextTooltip", $('#recalculate_button'), tooltip);
}

function hide_recalculate_tooltip(panelNum)
{
	$.DispatchEvent( "DOTAHideTextTooltip", $('#recalculate_button') );
}

function recalculate_items(){
	var active = $('#recalculate_button').GetAttributeInt("active", 0)
	if (active == 0){
		var playerId = Players.GetLocalPlayer();
		var recalcMessage = $.Localize("#ui_recalculate_stats_waiting")
		GameEvents.SendCustomGameEventToServer( "recalculate_stats", {playerId: playerId} );
		$('#recalculate_button').SetAttributeInt("active", 1)
		$('#recalculate_button_text').text = recalcMessage+" "+"5..."
		$('#recalculate_button_text').AddClass("calculating_color")
		var j = 1
		for (i = 1; i < 5; i++) {
		 	$.Schedule(1*i, function(){
		 		$('#recalculate_button_text').text = recalcMessage+" "+(5-j).toString()+"..."
		 		j = j+1
		 	});
		}
		$.Schedule(5, function(){
			$('#recalculate_button_text').text = $.Localize("#ui_recalculate_stats_button")
			$('#recalculate_button').SetAttributeInt("active", 0)
			$('#recalculate_button_text').RemoveClass("calculating_color")
		});
	}
}


(function()
{
	// GameEvents.Subscribe( "dota_inventory_changed", UpdateInventory );
	// GameEvents.Subscribe( "dota_inventory_item_changed", UpdateInventory );
	// GameEvents.Subscribe( "m_event_dota_inventory_changed_query_unit", UpdateInventory );
	// GameEvents.Subscribe( "m_event_keybind_changed", UpdateInventory );
	GameEvents.Subscribe( "dota_player_update_selected_unit", UpdateInventory );
	GameEvents.Subscribe( "dota_player_update_query_unit", UpdateInventory );
	GameEvents.Subscribe( "update_inventory", UpdateInventory );
	UpdateInventory(); // initial update
})();
