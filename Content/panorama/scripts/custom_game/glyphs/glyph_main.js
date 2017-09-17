var mCrystals;
var mTier;

function CloseGlyphs(msg){
	$('#glyphs_main_container').AddClass("invisible")
	$('#glyphs_main_container').style.visibility = "collapse"
	GameUI.CustomUIConfig().mainDialog = 0
	// ClearGlyphShop();
	if (msg!=0){
		if (!(msg === undefined)){
			if (msg.unlock == 1){
				GameUI.CustomUIConfig().glyphShopLock = 0
			}
		}
	}
}

function OpenGlyphs(){
	$.Msg("OPEN GLYPHS")
	if (GameUI.CustomUIConfig().mainDialog == 0){
		$('#glyphs_details_container').AddClass("invisible")
		$('#glyphs_details_container').style.visibility = "collapse"
		$('#glyphs_details_container').RemoveClass('animateIn')
		$('#glyphs_main_container').RemoveClass("invisible")
		$('#glyphs_main_container').style.visibility = "visible"
		GameUI.CustomUIConfig().mainDialog = 1
		$('#header_text').text = $.Localize('#glyph_enchanter_header')
		var playerID = Game.GetLocalPlayerID()
		var resourcesTable = CustomNetTables.GetTableValue( "player_stats", playerID.toString()+"-resources" )
		var crystals = resourcesTable.arcane
		mCrystals = crystals
		if (crystals < 0){
			crystals = $.Localize('#saveload_loading')
		}
		var enchanterTable = CustomNetTables.GetTableValue("player_stats", playerID.toString()+"-enchanter")
		var enchanterTier = enchanterTable.tier
		mTier = enchanterTier

		if (enchanterTier < 0){
			enchanterTier = $.Localize('#saveload_loading')
			$('#upgrade-tiers-box').AddClass('invisible')
		}else if(enchanterTier>=7){
			$('#upgrade-tiers-box').AddClass('invisible')
		}

		$('#current_crystals_label').text = $.Localize('#tooltip_arcane_crystals');
		$('#current_crystals_tier_label').text = $.Localize('#tooltip_enchanting_tier');
		$('#current_crystals_label_value').text = numberWithCommas(crystals)
		$('#current_crystals_tier_label_value').text = enchanterTier

		$('#upgrade-resource-button-label').text = $.Localize('#tooltip_upgrade_enchanter')
		$('#upgrade_crystals_label_value').text = $.Localize('#tooltip_upgrade_cost')+": "+numberWithCommas(getCrystalUpgradeCost(enchanterTier))

		$('#browse-label').text = $.Localize('#tooltip_shop_glyphs');
		
		
		$('#purchase-reanimation-stone').text = $.Localize('#DOTA_Tooltip_Ability_item_reanimation_stone')
		// $('#crusader_loading_label').RemoveClass('invisible')
		// $('#crusader_loading_label').text = $.Localize('#saveload_loading')
		// GameEvents.SendCustomGameEventToServer( "client_glyphs", {playerID: Game.GetLocalPlayerID()});
	}
		InitializeHeroMenu()
}

function InitializeHeroMenu(){
	$('#herolist-row-1').RemoveAndDeleteChildren()
	$('#herolist-row-2').RemoveAndDeleteChildren()
	$('#herolist-row-3').RemoveAndDeleteChildren()
	$('#herolist-row-4').RemoveAndDeleteChildren()
	$('#herolist-row-5').RemoveAndDeleteChildren()
	var availabileHeroArray = getHeroList();
	var parentPanel1 = $('#herolist-row-1')
	for (var i = 1; i <= 6; i++) {
		var newChildPanel = $.CreatePanel( "Panel", parentPanel1, "character"+i );
		$.Msg(availabileHeroArray[i-1])
		newChildPanel.heroName = availabileHeroArray[i-1];
		newChildPanel.playerTier = mTier
		newChildPanel.popoutContainer = $('#glyphs_details_container')
		newChildPanel.shopContentsContainer = $('#glyph_tiers_container')
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/glyphs/individual_shop_hero.xml", false, false );	
		
	}
	var parentPanel2 = $('#herolist-row-2')
	for (var i = 7; i <= 12; i++) {
		var newChildPanel = $.CreatePanel( "Panel", parentPanel2, "character"+i );
		newChildPanel.heroName = availabileHeroArray[i-1];
		newChildPanel.playerTier = mTier
		newChildPanel.popoutContainer = $('#glyphs_details_container')
		newChildPanel.shopContentsContainer = $('#glyph_tiers_container')
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/glyphs/individual_shop_hero.xml", false, false );	
	}
	var parentPanel3 = $('#herolist-row-3')
	for (var i = 13; i <= 18; i++) {
		var newChildPanel = $.CreatePanel( "Panel", parentPanel3, "character"+i );
		newChildPanel.heroName = availabileHeroArray[i-1];
		newChildPanel.playerTier = mTier
		newChildPanel.popoutContainer = $('#glyphs_details_container')
		newChildPanel.shopContentsContainer = $('#glyph_tiers_container')
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/glyphs/individual_shop_hero.xml", false, false );	
	}
	var parentPanel4 = $('#herolist-row-4')
	for (var i = 19; i <= 24; i++) {
		var newChildPanel = $.CreatePanel( "Panel", parentPanel4, "character"+i );
		newChildPanel.heroName = availabileHeroArray[i-1];
		newChildPanel.playerTier = mTier
		newChildPanel.popoutContainer = $('#glyphs_details_container')
		newChildPanel.shopContentsContainer = $('#glyph_tiers_container')
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/glyphs/individual_shop_hero.xml", false, false );	
	}
	var parentPanel5 = $('#herolist-row-5')
	for (var i = 25; i <= availabileHeroArray.length; i++) {
		var newChildPanel = $.CreatePanel( "Panel", parentPanel5, "character"+i );
		newChildPanel.heroName = availabileHeroArray[i-1];
		newChildPanel.playerTier = mTier
		newChildPanel.popoutContainer = $('#glyphs_details_container')
		newChildPanel.shopContentsContainer = $('#glyph_tiers_container')
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/glyphs/individual_shop_hero.xml", false, false );	
	}
}

function UpgradeGlyphEnchanter(){
	 if (GameUI.CustomUIConfig().glyphShopLock == 0){
		if (mCrystals >= getCrystalUpgradeCost(mTier)){
			GameEvents.SendCustomGameEventToServer( "upgrade_arcane_tier", {playerID: Game.GetLocalPlayerID()});
			GameUI.CustomUIConfig().glyphShopLock = 1
			Game.EmitSound("challenge.success")
		}else{
			Game.EmitSound("General.Cancel")
		}
	 }
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function UpgradeTooltip()
{
	var panel = $('#upgrade-tiers-box')
	var title = "<font color='yellow'>"+$.Localize('#tooltip_upgrade_enchanter')
	var tooltip = $.Localize('#upgrade_enchanter_info_tooltip')
	tooltip = breakUpTooltip(tooltip)
	$.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function HideUpgradeTooltip()
{
	var panel = $('#upgrade-tiers-box')
	$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
}

function getCrystalUpgradeCost(tier)
{
	var upgradeCost = 0;
	if (tier == 0){
		upgradeCost = 100;
	}else if (tier == 1){
		upgradeCost = 500
	}else if (tier == 2){
		upgradeCost = 5000
	}else if (tier == 3){
		upgradeCost = 10000
	}else if (tier == 4){
		upgradeCost = 50000
	}else if (tier == 5){
		upgradeCost = 100000
	}else if (tier == 6){
		upgradeCost = 500000
	}
	return upgradeCost
}


function InitializeGlyphs(){

	GameUI.CustomUIConfig().glyphShopLock = 0
	
	CloseGlyphs(0);

}

function ClearGlyphShop(){
	
	$('#glyph_content').RemoveAndDeleteChildren()

}

function ReanimationTooltip(){
	var title = "<font color='#8847FF'>"+$.Localize("#DOTA_Tooltip_Ability_item_reanimation_stone")+"</font>"
	var tooltip = "<i>"+"mythical"+"</i><br>"

	tooltip = tooltip+"<font color='#AAAAAA'>Consumable</font><br>"

	tooltip = tooltip+""+$.Localize("#reanimation_stone_desc")
	$.DispatchEvent("DOTAShowTitleTextTooltip", $('#reanimation-image'), title, tooltip);
}

function HideReanimationTooltip(){
	$.DispatchEvent( "DOTAHideTitleTextTooltip", $('#reanimation-image') );
}

function ReanimationHover(){
	$('#reanimation-box-bg').RemoveClass('reanimation_no_hover')
	$('#reanimation-box-bg').AddClass('reanimation_hover')
	
}

function ReanimationHoverEnd(){
	$('#reanimation-box-bg').RemoveClass('reanimation_hover')
	$('#reanimation-box-bg').AddClass('reanimation_no_hover')
}

function PurchaseReanimation(){
	 if (GameUI.CustomUIConfig().glyphShopLock == 0){
		if (mCrystals >= 30000){
			GameEvents.SendCustomGameEventToServer( "purchase_reanimation_stone", {playerID: Game.GetLocalPlayerID()});
			GameUI.CustomUIConfig().glyphShopLock = 1
			Game.EmitSound("challenge.success")
		}else{
			Game.EmitSound("General.Cancel")
		}
	 }
	
}


(function()
{
	InitializeGlyphs();
	// CloseOracle();
	GameEvents.Subscribe( "open_glyph_shop", OpenGlyphs );
	GameEvents.Subscribe( "close_glyph_shop", CloseGlyphs);
	GameEvents.Subscribe( "reopen_glyph_shop", InitializeGlyphs);
})();
