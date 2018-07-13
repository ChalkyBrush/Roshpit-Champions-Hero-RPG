var menuPanel = null

function OpenOracle(msg){
	$.Msg("OPEN ORACLE")
	if (GameUI.CustomUIConfig().mainDialog == 0){
		$('#oracle_container').RemoveClass("invisible")
		$('#oracle_container').style.visibility = "visible"
		GameUI.CustomUIConfig().mainDialog = 1
		if (msg.loadEnabled == 0){
			DisableLoading()
		}
	}
	// $.GetContextPanel().style.visibility = "visible"
}

function CloseOracle(){
	$('#oracle_container').AddClass("invisible")
	$.GetContextPanel().saveOpen = false
	$.GetContextPanel().loadOpen = false
	$.GetContextPanel().stashOpen = false
	$.GetContextPanel().keybankOpen = false
	$('#oracle_container').style.visibility = "collapse"
	GameUI.CustomUIConfig().mainDialog = 0
	ClearOracle();
}

function InitializeOracle(){
	$('#save_button_label').text = $.Localize("saveload_save")
	$('#load_button_label').text = $.Localize("saveload_load")
	GameUI.CustomUIConfig().oracleLoad = $('#oracle_load')
	GameUI.CustomUIConfig().oracleLoadLabel = $('#load_button_label')
	GameUI.CustomUIConfig().oracleSave = $('#oracle_save')
	GameUI.CustomUIConfig().oracleSaveLabel = $('#save_button_label')
	GameUI.CustomUIConfig().oracleSave.state = 0
	$('#stash_button_label').text = $.Localize("#saveload_stash")
	$('#oracle_load').state = 0
	GameUI.CustomUIConfig().mainDialog = 0
}

function ClearOracle(){
	
	$('#oracle_content').RemoveAndDeleteChildren()
	if (!($('#save_box') == null)){
		$('#save_box').RemoveAndDeleteChildren()
		$('#save_box').DeleteAsync(0)
	}
}

function SaveButton(msg){
	if (!($.GetContextPanel().saveOpen)){
		if (GameUI.CustomUIConfig().oracleSave.state == 0){
			ClearOracle();
			actionRefresh("save")
			var parentPanel = $('#oracle_content')
			var newChildPanel = $.CreatePanel( "Panel", parentPanel, "save_box" );
			newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/save_menu.xml", false, false );	
			var playerID = Game.GetLocalPlayerID();
			GameEvents.SendCustomGameEventToServer( "save_menu", {playerID: playerID, saveOrLoad: "save"});
		}
	}
}

function recentlySaved(msg){
	var j = 1
	var saveCooldown = 120
	$.Msg("anything?")
	for (i = 1; i < saveCooldown; i++) {
	 	$.Schedule(1*i, function(){
	 		j = j + 1
	 		var saveAgain = saveCooldown-j
	 		GameUI.CustomUIConfig().oracleSaveLabel.text = $.Localize('#saveload_save_again')+" "+saveAgain
	 	});
	}
 	$.Schedule(saveCooldown, function(){
 		$.Msg("10 seconds")
 		GameUI.CustomUIConfig().oracleSaveLabel.text = $.Localize("saveload_save")
		GameUI.CustomUIConfig().oracleSave.RemoveClass('button_inactive')
		GameUI.CustomUIConfig().oracleSave.AddClass('main_menu_button')	
		GameUI.CustomUIConfig().oracleSave.state = 0	 		
 	});
}

function actionRefresh(type){
	if (type == "save"){
		$.GetContextPanel().saveOpen = true
		$.GetContextPanel().loadOpen = false
		$.GetContextPanel().stashOpen = false
		$.GetContextPanel().keybankOpen = false
	}else if (type == "load"){
		$.GetContextPanel().saveOpen = false
		$.GetContextPanel().loadOpen = true
		$.GetContextPanel().stashOpen = false
		$.GetContextPanel().keybankOpen = false
	}else if (type == "stash"){
		$.GetContextPanel().saveOpen = false
		$.GetContextPanel().loadOpen = false
		$.GetContextPanel().stashOpen = true
		$.GetContextPanel().keybankOpen = false
	}else if (type == "keybank"){
		$.GetContextPanel().saveOpen = false
		$.GetContextPanel().loadOpen = false
		$.GetContextPanel().stashOpen = false
		$.GetContextPanel().keybankOpen = true
	}
}

function LoadCharButton(msg){
	if (!($.GetContextPanel().loadOpen)){
		if ($('#oracle_load').state == 0){
			$.Msg("LOAD BUTTON??")
			ClearOracle();
			actionRefresh("load")
			var parentPanel = $('#oracle_content')
			var newChildPanel = $.CreatePanel( "Panel", parentPanel, "load_box" );
			newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/load_menu.xml", false, false );	
			var playerID = Game.GetLocalPlayerID();
			GameEvents.SendCustomGameEventToServer( "save_menu", {playerID: playerID, saveOrLoad: "load"});
		}else{
			Game.EmitSound("General.Cancel")
		}
	}
}

function OpenStash(msg){
	if (!($.GetContextPanel().stashOpen)){
		$.Msg("LOAD BUTTON??")
		ClearOracle();
		actionRefresh("stash")
		var parentPanel = $('#oracle_content')
		var newChildPanel = $.CreatePanel( "Panel", parentPanel, "load_box" );
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/pool_of_eternity.xml", false, false );	
		var playerID = Game.GetLocalPlayerID();
		GameEvents.SendCustomGameEventToServer( "stash_open", {playerID: playerID});
	}
}

function OpenKeyBank(){
	if (!($.GetContextPanel().keybankOpen)){
		ClearOracle();
		actionRefresh("keybank")
		// var parentPanel = $('#oracle_content')
		// var newChildPanel = $.CreatePanel( "Panel", parentPanel, "load_box" );
		// newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/save_load/pool_of_eternity.xml", false, false );	
		var playerID = Game.GetLocalPlayerID();
		GameEvents.SendCustomGameEventToServer( "keybank_open", {playerID: playerID});
	}
}

function keysLoaded(msg){
	$.GetContextPanel().keysLocked = false
	ClearOracle()
	var parentPanel = $('#oracle_content')
	var board = $.CreatePanel( "Panel", parentPanel, "load_box" );
	board.BLoadLayoutSnippet("key_bank");
	$.Msg(msg.result)
	for (i = 1; i <= 4; i++) {
		for (j = 1; j <= 3; j++) {
			var parentRow = $('#keys_row'+j)
			var keyBoard = $.CreatePanel( "Panel", parentRow, "load_box" );
			keyBoard.BLoadLayoutSnippet("key_bank_item");
			var index = (j-1)*4 + i
			var keyData = getKeyData(index, msg.result)
			if (keyData[0]){
				$.Msg(keyData[0])
				keyBoard.FindChildTraverse('key_image').SetImage(keyData[0])
				// keyBoard.FindChildTraverse('key_title').text = $.Localize(keyData[1])
				keyBoard.FindChildTraverse('key_quantity').text = "x"+keyData[2]
				// keyBoard.FindChildTraverse('key_title').AddClass(keyData[3])
				setButtonEvents(keyData, keyBoard.FindChildTraverse('keybank_button'), index)
			}else{
				keyBoard.AddClass('invisible')
			}
		}
	}
	$.GetContextPanel().resultTable = msg.result
	var item_image = board.FindChildTraverse('key_deposit_slot')
    $.RegisterEventHandler( 'DragEnter', item_image, OnDragEnter );
    $.RegisterEventHandler( 'DragDrop', item_image, OnDragDrop );
    $.RegisterEventHandler( 'DragLeave', item_image, OnDragLeave );
}

function setButtonEvents(keyData, button, index)
{
	button.SetPanelEvent('onactivate', function ClickKeyButton() {
		keyClickToWithdraw(index, keyData[2], button)
	});
	button.SetPanelEvent('onmouseover', function KeyHoverSet(){
		KeyHover(keyData[1], button, keyData[3])
	});
	button.SetPanelEvent('onmouseout', function KeyHoveroutSet(){
		KeyHoverEnd(keyData[1], button)
	});	
}

function keyClickToWithdraw(index, quantity, button)
{
    if ($.GetContextPanel().keysLocked){
    	return true
    }
	if (quantity > 0){
		$.GetContextPanel().keysLocked = true
		Game.EmitSound("Oracle.KeyWithdraw")
		var playerID = Game.GetLocalPlayerID()
		GameEvents.SendCustomGameEventToServer( "keybank_withdraw", {playerID: playerID, keyIndex: index});
	}
}

function wtf(){

}

function getKeyData(index, resultTable){
	$.Msg(index)
	$.Msg(resultTable)
	var array = [false, false, false, false]
	if (index == 1){
		array = ["file://{images}/items/wind_temple_key.png", "DOTA_Tooltip_Ability_item_tanari_wind_temple_key_normal", resultTable[1].wind_temple, '#4B69FF']
	}else if(index == 2){
		array = ["file://{images}/items/water_temple_key.png", "DOTA_Tooltip_Ability_item_tanari_water_temple_key_normal", resultTable[1].water_temple, '#4B69FF']
	}else if(index == 3){
		array = ["file://{images}/items/fire_temple_key.png", "DOTA_Tooltip_Ability_item_tanari_fire_temple_key_normal", resultTable[1].fire_temple, '#4B69FF']
	}else if(index == 4){
		array = ["file://{images}/items/tanari_spirit_stones.png", "DOTA_Tooltip_Ability_item_tanari_spirit_stones_normal", resultTable[1].spirit_stones, '#E4AE33']
	}else if(index == 5){
		array = ["file://{images}/items/redfall/autumnleaf_firefly.png", "DOTA_Tooltip_Ability_item_redfall_burgundy_firefly_normal", resultTable[1].burgundy_firefly, '#4B69FF']
	}else if(index == 6){
		array = ["file://{images}/items/redfall/purified_vermillion_bundle.png", "DOTA_Tooltip_Ability_item_redfall_purified_vermillion_bundle_normal", resultTable[1].vermillion_bundle, '#4B69FF']
	}else if(index == 7){
		array = ["file://{images}/items/redfall/hidden_shipyard_key.png", "DOTA_Tooltip_Ability_item_redfall_hidden_shipyard_key_normal", resultTable[1].shipyard_key, '#4B69FF']
	}else if(index == 8){
		array = ["file://{images}/items/redfall/crimsyth_demon_relic.png", "DOTA_Tooltip_Ability_item_redfall_crimsyth_demon_relic_normal", resultTable[1].demon_relic, '#4B69FF']
	}else if(index == 9){
		array = ["file://{images}/items/redfall/redfall_spirit_ruby.png", "DOTA_Tooltip_Ability_item_redfall_spirit_ruby_normal", resultTable[1].vestigial_ruby, '#8847FF']
	}else if(index == 10){
		array = ["file://{images}/items/rpc/sunstone.png", "DOTA_Tooltip_Ability_item_serengaard_sunstone", resultTable[1].serengaard_sunstone, '#8847FF']
	}else if(index == 11){
		array = ["file://{images}/items/winterblight/winterblight_glacier_stone.png", "DOTA_Tooltip_ability_item_rpc_winterblight_glacier_stone", resultTable[1].glacier_stone, '#8847FF']
	}
	return array
}

function KeyHover(titleText, board, color){
	$.Msg("HOVER??")
    if ($.GetContextPanel().keysLocked){
    	return true
    }
	var title = "<font color='"+color+"'>"+$.Localize(titleText)
	var tooltip = $.Localize("#key_hover_tooltip")
	$.DispatchEvent("DOTAShowTitleTextTooltip", board, title, tooltip);
	board.AddClass("keyhover")
}

function KeyHoverEnd(titleText, board){
	$.DispatchEvent( "DOTAHideTitleTextTooltip", board);	
	board.RemoveClass("keyhover")
}

function DisableLoading(){
	$.Msg("DISABLE LOAD")
	GameUI.CustomUIConfig().oracleLoad.state = 1
	GameUI.CustomUIConfig().oracleLoad.AddClass('button_inactive')
	GameUI.CustomUIConfig().oracleLoad.RemoveClass('main_menu_button')
	GameUI.CustomUIConfig().oracleLoadLabel.text = $.Localize('#saveload_one_load')
}

function IsValidKey(itemName){
	var valid = 0
	if ((itemName == "item_tanari_wind_temple_key_normal") || (itemName == "item_tanari_wind_temple_key_elite") || (itemName == "item_tanari_wind_temple_key_legend")){
		valid = 1
	}else if((itemName == "item_tanari_water_temple_key_normal") || (itemName == "item_tanari_water_temple_key_elite") || (itemName == "item_tanari_water_temple_key_legend")){
		valid = 2
	}else if((itemName == "item_tanari_fire_temple_key_normal") || (itemName == "item_tanari_fire_temple_key_elite") || (itemName == "item_tanari_fire_temple_key_legend")){
		valid = 3
	}else if((itemName == "item_tanari_spirit_stones_normal") || (itemName == "item_tanari_spirit_stones_elite") || (itemName == "item_tanari_spirit_stones_legend")){
		valid = 4
	}else if((itemName == "item_redfall_burgundy_firefly_normal") || (itemName == "item_redfall_burgundy_firefly_elite") || (itemName == "item_redfall_burgundy_firefly_legend")){
		valid = 5
	}else if((itemName == "item_redfall_purified_vermillion_bundle_normal") || (itemName == "item_redfall_purified_vermillion_bundle_elite") || (itemName == "item_redfall_purified_vermillion_bundle_true")){
		valid = 6
	}else if((itemName == "item_redfall_hidden_shipyard_key_normal") || (itemName == "item_redfall_hidden_shipyard_key_elite") || (itemName == "item_redfall_hidden_shipyard_key_legend")){
		valid = 7
	}else if((itemName == "item_redfall_crimsyth_demon_relic_normal") || (itemName == "item_redfall_crimsyth_demon_relic_elite") || (itemName == "item_redfall_crimsyth_demon_relic_legend")){
		valid = 8
	}else if((itemName == "item_redfall_spirit_ruby_normal") || (itemName == "item_redfall_spirit_ruby_elite") || (itemName == "item_redfall_spirit_ruby_legend")){
		valid = 9
	}else if(itemName == "item_serengaard_sunstone"){
		valid = 10
	}else if(itemName == "item_rpc_winterblight_glacier_stone"){
		valid = 11
	}
	return valid
}

function OnDragEnter( a, draggedPanel )
{
    var draggedItem = draggedPanel.m_DragItem;

    // only care about dragged items other than us
    if ( draggedItem === null || (!(draggedPanel.fromInventory)) )
        return true;

    var itemName = Abilities.GetAbilityName( draggedItem )
    var valid = IsValidKey(itemName)
    $.Msg("VALID? "+valid)
    if (valid == 0){
        return true
    }
    if ($.GetContextPanel().keysLocked){
    	return true
    }
    // highlight this panel as a drop target
    $('#key_deposit_slot').AddClass( "item_highlight" );
    Game.EmitSound("Oracle.KeyHover")
    return true;
}

function OnDragDrop( panelId, draggedPanel )
{
    var draggedItem = draggedPanel.m_DragItem;
    draggedPanel.lockOrder = true
    // only care about dragged items other than us
    if ( draggedItem === null )
        return true;
    var itemName = Abilities.GetAbilityName( draggedItem )
    var valid = IsValidKey(itemName)
    if (valid == 0){
        return true
    }
    if ($.GetContextPanel().keysLocked){
    	return true
    }
    if (draggedPanel.fromInventory){
        $.Msg("DROP ITEM")
            var playerID = Game.GetLocalPlayerID()
            var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
            GameEvents.SendCustomGameEventToServer( "stop_unit", {unitIndex: heroIndex} );
            Game.EmitSound("ui.crafting_pulse")
            keyDropped(draggedItem, valid)
            // LoadItemForReroll(draggedItem)
    }
    return true

}

function OnDragLeave( panelId, draggedPanel )
{
    var draggedItem = draggedPanel.m_DragItem;
    if ( draggedItem === null )
        return false;

    $('#key_deposit_slot').RemoveClass( "item_highlight" );
    return true;
}

function keyDropped(draggedItem, keyIndex){
	$.Msg("ITEM DRAGGED IN!")
	var itemName = Abilities.GetAbilityName( draggedItem )
	var playerID = Game.GetLocalPlayerID();
	var limit = 5
	if (Players.HasCustomGameTicketForPlayerID( playerID) ){
		limit = 20
	}
	var currentKeys = GetKeyCountByItemName(itemName)
	if (currentKeys < limit){
		$.GetContextPanel().keysLocked = true
		$('#key_deposit_slot').contextEntityIndex = draggedItem;
		GameEvents.SendCustomGameEventToServer( "keybank_deposit", {playerID: playerID, itemIndex: draggedItem, limit: limit, keyIndex: keyIndex});
	}
	
}

function GetKeyCountByItemName(itemName){
	var keyCount = -1
	var resultTable = $.GetContextPanel().resultTable
	if ((itemName == "item_tanari_wind_temple_key_normal") || (itemName == "item_tanari_wind_temple_key_elite") || (itemName == "item_tanari_wind_temple_key_legend")){
		keyCount = resultTable[1].wind_temple
	}else if((itemName == "item_tanari_water_temple_key_normal") || (itemName == "item_tanari_water_temple_key_elite") || (itemName == "item_tanari_water_temple_key_legend")){
		keyCount = resultTable[1].water_temple
	}else if((itemName == "item_tanari_fire_temple_key_normal") || (itemName == "item_tanari_fire_temple_key_elite") || (itemName == "item_tanari_fire_temple_key_legend")){
		keyCount = resultTable[1].fire_temple
	}else if((itemName == "item_tanari_spirit_stones_normal") || (itemName == "item_tanari_spirit_stones_elite") || (itemName == "item_tanari_spirit_stones_legend")){
		keyCount = resultTable[1].spirit_stones
	}else if((itemName == "item_redfall_burgundy_firefly_normal") || (itemName == "item_redfall_burgundy_firefly_elite") || (itemName == "item_redfall_burgundy_firefly_legend")){
		keyCount = resultTable[1].burgundy_firefly
	}else if((itemName == "item_redfall_purified_vermillion_bundle_normal") || (itemName == "item_redfall_purified_vermillion_bundle_elite") || (itemName == "item_redfall_purified_vermillion_bundle_legend")){
		keyCount = resultTable[1].vermillion_bundle
	}else if((itemName == "item_redfall_hidden_shipyard_key_normal") || (itemName == "item_redfall_hidden_shipyard_key_elite") || (itemName == "item_redfall_hidden_shipyard_key_legend")){
		keyCount = resultTable[1].shipyard_key
	}else if((itemName == "item_redfall_crimsyth_demon_relic_normal") || (itemName == "item_redfall_crimsyth_demon_relic_elite") || (itemName == "item_redfall_crimsyth_demon_relic_legend")){
		keyCount = resultTable[1].demon_relic
	}else if((itemName == "item_redfall_spirit_ruby_normal") || (itemName == "item_redfall_spirit_ruby_elite") || (itemName == "item_redfall_spirit_ruby_legend")){
		keyCount = resultTable[1].vestigial_ruby
	}else if(itemName == "item_serengaard_sunstone"){
		keyCount = resultTable[1].serengaard_sunstone
	}else if(itemName == "item_rpc_winterblight_glacier_stone"){
		keyCount = resultTable[1].glacier_stone
	}
	return keyCount
}


function LoadButton(){

}

(function()
{
	InitializeOracle();
	// CloseOracle();
	GameEvents.Subscribe( "open_oracle", OpenOracle );
	GameEvents.Subscribe( "close_oracle", CloseOracle);
	GameEvents.Subscribe( "recentlySaved", recentlySaved);
	GameEvents.Subscribe( "player_keys_loaded", keysLoaded);
})();
