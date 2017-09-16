var mShards;
var mChisel = 0;

function CloseBlacksmith(msg){
	$('#blacksmith_main_container').AddClass("invisible")
	$('#blacksmith_main_container').style.visibility = "collapse"
	GameUI.CustomUIConfig().mainDialog = 0
	ToggleChiselState(false)
	ToggleRerollState(false)
	$('#item-display-content').RemoveAndDeleteChildren();
	// ClearGlyphShop();
	if (msg!=0){
		if (!(msg === undefined)){
			if (msg.unlock == 1){
				GameUI.CustomUIConfig().blacksmithLock = 0
			}
		}
	}
}

function OpenBlacksmith(){
	$.Msg("OPEN BLACKSMITH")
	if (GameUI.CustomUIConfig().mainDialog == 0){
		GameUI.CustomUIConfig().chisel = 0
		GameUI.CustomUIConfig().reroll = 0
		GameUI.CustomUIConfig().rerollItem = 0
		$('#blacksmith_main_container').RemoveClass("invisible")
		$('#blacksmith_main_container').style.visibility = "visible"
		$('#upgrade-tiers-box').RemoveClass("invisible")
		GameUI.CustomUIConfig().mainDialog = 1
		$('#header_text').text = $.Localize('#ui_blacksmith_title')

		$('#chisel_button_label').text = $.Localize('#chisel_name')
		$('#reroll_button_label').text = $.Localize('#reroll_name')

		var playerID = Game.GetLocalPlayerID()
		var resourcesTable = CustomNetTables.GetTableValue( "player_stats", playerID.toString()+"-mithril" )
		var shards = resourcesTable.mithril
		mShards = shards
		shards = numberWithCommas(shards)
		if (shards < 0){
			shards = $.Localize('#saveload_loading')
		}
		$('#current_crystals_label_value').text = shards

		$('#current_crystals_label').text = $.Localize('tooltip_current_shards')
		$('#upgrade-resource-button-label').text =  $.Localize('tooltip_collect_income')
		
		var incomeAvailable = CustomNetTables.GetTableValue( "player_stats", playerID.toString()+"-income" ).available
		if (incomeAvailable == 0){
			$('#upgrade-tiers-box').AddClass("invisible")
			$('#resources-box-row').AddClass("no_income")
		}
		$('#income_crystals_label_value').text = $.Localize('#tooltip_daily_income')+": 120"
	}

}


function CollectMithrilIncome(){
	 if (GameUI.CustomUIConfig().blacksmithLock == 0){
		GameEvents.SendCustomGameEventToServer( "collect_mithril_income", {playerID: Game.GetLocalPlayerID()});
		GameUI.CustomUIConfig().blacksmithLock = 1
		Game.EmitSound("challenge.success")
	 }	
}




function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function IncomeTooltip()
{
	var panel = $('#upgrade-tiers-box')
	var title = "<font color='yellow'>"+$.Localize('#tooltip_daily_income')
	var tooltip = $.Localize('#collect_income_info')
	tooltip = breakUpTooltip(tooltip)
	$.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function HideIncomeTooltip()
{
	var panel = $('#upgrade-tiers-box')
	$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
}




function InitializeBlacksmith(){

	GameUI.CustomUIConfig().blacksmithLock = 0
	
	CloseBlacksmith(0);

}

function UnlockBlacksmith(){
	GameUI.CustomUIConfig().blacksmithLock = 0
	GameUI.CustomUIConfig().mainDialog = 0
	ToggleChiselState(false)
	ToggleRerollState(false)
	$('#item-display-content').RemoveAndDeleteChildren();
	OpenBlacksmith()
}

function UnlockBlacksmithAfterReroll(msg){
	var itemIndex = msg.itemIndex
	GameUI.CustomUIConfig().blacksmithLock = 0
	GameUI.CustomUIConfig().mainDialog = 0
	ToggleChiselState(false)
	ToggleRerollState(false)
	$('#item-display-content').RemoveAndDeleteChildren();
	OpenBlacksmith()	
	var rerollPanel = RerollButtonActivate()

	var itemValues = CustomNetTables.GetTableValue( "item_basics", itemIndex.toString() )
	var rarity = itemValues.rarityFactor
	if (itemValues.slot == "weapon"){
		return false;
	}
	if (rarity == 5){
			var playerID = Game.GetLocalPlayerID()
			var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
			Game.EmitSound("ui.crafting_pulse")
			Game.PrepareUnitOrders( { OrderType: dotaunitorder_t.DOTA_UNIT_ORDER_STOP} );
			GameEvents.SendCustomGameEventToServer( "drag_into_reroll_slot", {playerID: playerID, heroIndex: heroIndex, itemIndex: itemIndex, ignoreLock: 0, lock1: msg.lock1, lock2: msg.lock2, lock3: msg.lock3, lock4: msg.lock4});
			// $.Schedule(0.15, function(){
			// 	rerollPanel.lockSlotsFromServerCall(msg)
			// });
	}
}

function ClearGlyphShop(){
	
	$('#glyph_content').RemoveAndDeleteChildren()

}

function ChiselButtonActivate(){
	if (mChisel == 0){
		mChisel = 1;
		Game.EmitSound("ui.crafting_gem_drop")
		ToggleChiselState(true)
	}else{
		mChisel = 0;
		ToggleChiselState(false)		
	}
}


function ToggleChiselState(bTurnOn)
{
	if (!(GameUI.CustomUIConfig().equipmentContainer)){
		return
	}
	$.Msg(GameUI.CustomUIConfig().equipmentContainer)
	var mainParent = GameUI.CustomUIConfig().equipmentContainer
	var helmPanel = mainParent.FindChild("helm_main_container").FindChild("helm_container")
	var chestPanel = mainParent.FindChild("armor_main_container").FindChild("armor_container")
	var glovePanel = mainParent.FindChild("weapon_glove_main_container").FindChild("glove_container")
	var bootPanel = mainParent.FindChild("boot_amulet_main_container").FindChild("boot_container")
	var amuletPanel = mainParent.FindChild("boot_amulet_main_container").FindChild("amulet_container")
	var weaponPanel = mainParent.FindChild("weapon_glove_main_container").FindChild("weapon_container")
	if (bTurnOn){
		GameUI.CustomUIConfig().chisel = 1
		$('#chisel_button_label').text = $.Localize('#ui_cancel')
		$('#chisel_button').AddClass('active_button')
		helmPanel.AddClass("chiselable_gear")
		chestPanel.AddClass("chiselable_gear")
		glovePanel.AddClass("chiselable_gear")
		bootPanel.AddClass("chiselable_gear")
		amuletPanel.AddClass("chiselable_gear")
		weaponPanel.AddClass("chiselable_gear")
		ToggleRerollState(false)
	}else{
		GameUI.CustomUIConfig().chisel = 0
		mChisel = 0
		$('#chisel_button_label').text = $.Localize('#chisel_name')
		$('#chisel_button').RemoveClass('active_button')
		$('#item-display-content').RemoveAndDeleteChildren()
		helmPanel.RemoveClass("chiselable_gear")
		chestPanel.RemoveClass("chiselable_gear")
		glovePanel.RemoveClass("chiselable_gear")
		bootPanel.RemoveClass("chiselable_gear")
		amuletPanel.RemoveClass("chiselable_gear")
		weaponPanel.RemoveClass("chiselable_gear")
		$('#final_forge_button_container').AddClass('invisible')
	}	
}

function ToggleRerollState(bTurnOn)
{
	if (!(GameUI.CustomUIConfig().equipmentContainer)){
		return
	}
	if (bTurnOn){
		GameUI.CustomUIConfig().reroll = 1
		$('#reroll_button_label').text = $.Localize('#ui_cancel')
		$('#reroll_button').AddClass('active_button')
		ToggleChiselState(false)
	}else{
		GameUI.CustomUIConfig().reroll = 0
		$('#reroll_button_label').text = $.Localize('#reroll_name')
		$('#reroll_button').RemoveClass('active_button')
		$('#item-display-content').RemoveAndDeleteChildren()
		// if (GameUI.CustomUIConfig().rerollItem > 0){
			
		// }
		// GameEvents.SendCustomGameEventToServer( "return_reroll", {playerID: Game.GetLocalPlayerID(), itemIndex: GameUI.CustomUIConfig().rerollItem});
		GameUI.CustomUIConfig().rerollItem = 0
		$('#final_forge_button_container').AddClass('invisible')
	}	
}

function RerollButtonActivate(){
	if (GameUI.CustomUIConfig().reroll == 0){
		ToggleRerollState(true)
		Game.EmitSound("ui.crafting_gem_drop")
		var parentPanel = $('#item-display-content')
		var forgePriceContainer = $('#forge_price_box_container_main')
		var forgeButton = $('#final_forge_button')
		parentPanel.RemoveAndDeleteChildren()
		var newChildPanel = $.CreatePanel( "Panel", parentPanel, "chisel-item" );
		newChildPanel.shards = mShards
		newChildPanel.attachItemPanel = $('#item-display-content')
		newChildPanel.forgePriceBoxContainerMain = $('#forge_price_box_container_main')
		newChildPanel.finalForgeButton = $('#final_forge_button')
		newChildPanel.finalForgeButtonContainer = $('#final_forge_button_container')
		newChildPanel.finalForgeButtonLabel = $('#final_forge_button_label')
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/resources/reroll_pre_screen.xml", false, false );	
		return newChildPanel
	}else{
		ToggleRerollState(false)
	}

}



function chiselGearSelected(msg)
{
	var itemIndex = msg.itemIndex
	var parentPanel = $('#item-display-content')
	var forgePriceContainer = $('#forge_price_box_container_main')
	var forgeButton = $('#final_forge_button')
	parentPanel.RemoveAndDeleteChildren()
	var newChildPanel = $.CreatePanel( "Panel", parentPanel, "chisel-item" );
	newChildPanel.itemIndex = itemIndex
	newChildPanel.chisel = 1
	newChildPanel.reroll = 0
	newChildPanel.forgeButton = forgeButton
	newChildPanel.forgePriceContainer = forgePriceContainer
	newChildPanel.shards = mShards
	newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/resources/item_detail_blacksmith.xml", false, false );	
	var playerID = Game.GetLocalPlayerID();
	$('#final_forge_button_container').RemoveClass('invisible')
	$('#final_forge_button_label').text = $.Localize('#action_finish_chisel')
}

function FinalForgeActivate()
{ 
	if (GameUI.CustomUIConfig().blacksmithLock == 0){

		if (GameUI.CustomUIConfig().chisel == 1){
			var forgeButton = $('#final_forge_button')
			var cost = forgeButton.chiselCost
			if (mShards>=cost){
			//Complete Chiseling
				GameUI.CustomUIConfig().blacksmithLock = 1
				$('#final_forge_button_label').text = $.Localize('#tooltip_forge_in_process')
				forgeButton.RemoveClass('forge_button_color_main')
				forgeButton.AddClass('forge_button_deactivated')

				var itemIndex = forgeButton.chiselItemIndex
				Game.EmitSound("ui.crafting_confirm_socket")
				GameEvents.SendCustomGameEventToServer( "final_chisel", {playerID: Game.GetLocalPlayerID(), itemIndex: itemIndex, cost: cost});
			}else{
				Game.EmitSound("General.Cancel")
			}
		}else if (GameUI.CustomUIConfig().reroll == 1){

			var forgeButton = $('#final_forge_button')
			var cost = forgeButton.rerollCost
			var itemLevel = forgeButton.itemLevel
			$.Msg("COST?"+cost)
			$.Msg("SHARDS?"+mShards)
			if (mShards>=cost){

				var lock1 = forgeButton.lock1
				var lock2 = forgeButton.lock2
				var lock3 = forgeButton.lock3
				var lock4 = forgeButton.lock4
				if ((lock1 + lock2 + lock3 + lock4) > 2){
					return false
				}
				GameUI.CustomUIConfig().blacksmithLock = 1
				$('#final_forge_button_label').text = $.Localize('#tooltip_forge_in_process')
				forgeButton.RemoveClass('forge_button_color_main')
				forgeButton.AddClass('forge_button_deactivated')
				var itemIndex = GameUI.CustomUIConfig().rerollItem
				// GameUI.CustomUIConfig().backup = GameUI.CustomUIConfig().rerollItem
				Game.EmitSound("ui.crafting_confirm_socket")
				$.Msg("final reroll...")
				GameEvents.SendCustomGameEventToServer( "final_reroll", {playerID: Game.GetLocalPlayerID(), itemIndex: itemIndex, cost: cost, lock1: lock1, lock2: lock2, lock3: lock3, lock4: lock4});	
				GameUI.CustomUIConfig().rerollItem = 0	
			}else{
				Game.EmitSound("General.Cancel")
			}
		}
	}
}

function ChiselTooltip(){
	var panel = $('#chisel_button_container')
	var title = "<font color='yellow'>"+$.Localize('#chisel_name')
	var tooltip = $.Localize('#chisel_tooltip')
	tooltip = breakUpTooltip(tooltip)
	$.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function HideChiselTooltip(){
	var panel = $('#chisel_button_container')
	$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
}

function RerollTooltip(){
	var panel = $('#reroll_button_container')
	var title = "<font color='yellow'>"+$.Localize('#reroll_name')
	var tooltip = $.Localize('#reroll_tooltip')
	tooltip = breakUpTooltip(tooltip)
	$.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function HideRerollTooltip(){
	var panel = $('#reroll_button_container')
	$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
}

function playerReceivedItem(){

}

(function()
{
	InitializeBlacksmith();
	// CloseOracle();
	GameEvents.Subscribe( "open_blacksmith", OpenBlacksmith );
	GameEvents.Subscribe( "close_blacksmith", CloseBlacksmith);
	GameEvents.Subscribe( "reopen_blacksmith", InitializeBlacksmith);
	GameEvents.Subscribe( "unlock_blacksmith", UnlockBlacksmith);

	GameEvents.Subscribe( "unlock_blacksmith_after_reroll", UnlockBlacksmithAfterReroll);

	GameEvents.Subscribe( "chiselable_gear_clicked", chiselGearSelected);
	GameEvents.Subscribe( "playerReceivedItem", playerReceivedItem)
})();
