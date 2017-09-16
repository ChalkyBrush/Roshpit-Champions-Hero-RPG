function trade_begin(msg){
		$('#overlay_event').style.visibility = "visible"
		$('#overlay_event').RemoveAndDeleteChildren();
		$('#overlay_event').eventIndex = 0;
		var parentPanel = $('#overlay_event')
		// reset_overlay_event(parentPanel)
		var newChildPanel = $.CreatePanel( "Panel", parentPanel, "trade_god_container" );
		newChildPanel.playerFrom = msg.playerFrom
		newChildPanel.playerTo = msg.playerTo
		newChildPanel.mainParent = parentPanel
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/trade/trade.xml", false, false );	
		Game.EmitSound( "Item.DropGemShop" )
		//sound Accept:  "Item.PickUpGemShop"
		//sound Cancel:  "Item.DropRingShop"
	// GameEvents.SendCustomGameEventToServer( "save_menu", {playerID: playerID, saveOrLoad: "load"});
}

(function()
{
	GameEvents.Subscribe( "trade_begin", trade_begin );
})();
