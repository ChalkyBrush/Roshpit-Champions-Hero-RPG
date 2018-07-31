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
	
	for (var i = 1; i <= availabileHeroArray.length; i++) {
		var rowNumber = Math.ceil(i/6)
		var parentPanel1 = $('#herolist-row-'+rowNumber)
		var newChildPanel = $.CreatePanel( "Panel", parentPanel1, "character"+i );
		newChildPanel.heroName = availabileHeroArray[i-1];
		newChildPanel.playerTier = mTier
		newChildPanel.popoutContainer = $('#glyphs_details_container')
		newChildPanel.shopContentsContainer = $('#glyph_tiers_container')
        newChildPanel.BLoadLayoutSnippet("shop_hero");
        parentPanel1.heroButton = newChildPanel	
		if (newChildPanel.heroName == "tooltip_neutral"){
			newChildPanel.FindChildTraverse('shop_portrait').SetImage( "file://{images}/custom_game/ui/empty_inventory.png")
			newChildPanel.FindChildTraverse('slot_label_name').text = $.Localize(newChildPanel.heroName)
		}else{
			newChildPanel.FindChildTraverse('shop_portrait').SetImage( "file://{images}/heroes/" + newChildPanel.heroName + ".png")
			newChildPanel.FindChildTraverse('slot_label_name').text = ""
		}
		SetShopHeroButtonEvent(newChildPanel)
	}
}
MAX_TIERS = 7;

function SetShopHeroButtonEvent(panel){
	panel.FindChildTraverse('glyph_hero_button').SetPanelEvent('onactivate', function heroGlyphsOpen() {
		heroButtonClick(panel)
    })
}
function heroButtonClick(heroPanel){
	var popoutContainer = heroPanel.popoutContainer
	var heroName = heroPanel.heroName
	popoutContainer.RemoveClass('animateInGlyph')
	heroPanel.FindChildTraverse('shop_portrait').AddClass('active-portrait')
	popoutContainer.RemoveClass('invisible')
	popoutContainer.style.visibility = "visible"
	popoutContainer.AddClass('animateInGlyph')
	var parent = $('#glyph_tiers_container')
	parent.RemoveAndDeleteChildren();
	$('#loading_text').RemoveClass('invisible')
	GameEvents.SendCustomGameEventToServer( "get_glyph_availability", {playerID: Players.GetLocalPlayer(), hero: heroName});	
}

function OpenGlyphShopForHeroAfterServerLoads(msg)
{
	$.Msg("LOADED GLYPH RECIPES")
	$.Msg(msg)
	var parent = $('#glyph_tiers_container')
	$('#loading_text').AddClass('invisible')
	// parent.RemoveAndDeleteChildren();
	for (var i = 1; i <= MAX_TIERS; i++) {
		var newChildPanel = $.CreatePanel( "Panel", parent, "shop-row"+i );
		newChildPanel.heroName = msg.heroName
		newChildPanel.playerTier = mTier
		newChildPanel.rowTier = i
		newChildPanel.BLoadLayoutSnippet("shop_row");
		InitializeGlyphRow(newChildPanel, msg)
	}
}

function InitializeGlyphRow(row, msg)
{
	var heroName = row.heroName
	var glyphsPerRow = 1
	if (heroName == "tooltip_neutral"){
		glyphsPerRow = 3
	}
	if (Object.keys(msg.data).length === 0){

	}else{
		// $.Msg(msg.data["2"][row.toString()])
		// $.Msg(msg.data["2"])
		glyphsPerRow = 1 + msg.data["2"][row.rowTier.toString()]
	}
	if (row.rowTier > row.playerTier){
		row.FindChildTraverse('shop-row-overlay').AddClass('shop-row-overlay-cant-use')
	}
	row.FindChildTraverse('shop-row-tier-label').text = $.Localize('#tooltip_tier')+" "+row.rowTier
	var rowParent = row.FindChildTraverse("shop-row-contents")
	for (var i = 1; i <= glyphsPerRow; i++) {
		var newChildPanel = $.CreatePanel( "Panel", rowParent, "glyph-item"+i+"-"+row.rowTier );
		newChildPanel.heroName = heroName
		newChildPanel.playerTier = row.playerTier
		newChildPanel.rowTier = row.rowTier
		newChildPanel.column = i
		newChildPanel.BLoadLayoutSnippet( "glyph_item" );
		InitializeShopGlyphItem(newChildPanel, msg)	
	}
}

function InitializeShopGlyphItem(glyphPanel, msg)
{

	heroName = glyphPanel.heroName
	mHeroName = convertFullHeroNameToRPC(heroName)
	var glyphIndex = glyphPanel.rowTier+"_"+ glyphPanel.column
	$.Msg(heroName)
	$.Msg(msg)
	var item = msg.glyphDisplay[glyphIndex]
	$.Msg("ITEM GLYPH INDEX!!! : "+item)
	// if (heroName == "tooltip_neutral"){
	// 	$.Msg("file://{images}/items/glyphs/glyph_"+glyphIndex+".png")
	// 	$('#glyph-image').SetImage("file://{images}/items/glyphs/glyph_"+glyphIndex+".png")
	// }else{
	// 	$.Msg("file://{images}/items/glyphs/glyph_"+mHeroName+"_"+glyphIndex+".png")
	// 	$('#glyph-image').SetImage("file://{images}/items/glyphs/glyph_"+mHeroName+"_"+glyphIndex+".png")
	// }
	$.Msg("file://{images}/"+Abilities.GetAbilityTextureName( item )+".png")
	glyphPanel.FindChildTraverse('glyph-image').SetImage("file://{images}/items/"+Abilities.GetAbilityTextureName( item )+".png")
	
	
	mItemName = Abilities.GetAbilityName( item)
	mItemDescription = mItemName+"_description"
	mItemRarity = getRarityForTier(glyphPanel.rowTier)
	mMinLevel = minLevelForTier(glyphPanel.rowTier)
	
	if (heroName == "neutral"){
		heroName = "tooltip_neutral"
	}
	glyphPanel.FindChildTraverse('glyph_purchase_price_value').text = numberWithCommas(getTierCost(glyphPanel.rowTier, glyphPanel.column, heroName))
	glyphPanel.SetAttributeInt('item', item)
	glyphPanel.itemName = mItemName
	SetShopGlyphEvents(glyphPanel)
	// if (glyphPanel.column == 1){
	// 	$('#glyph_purchase_price_value').text = numberWithCommas(getTierCost(mRowTier))
	// }else{
	// 	$('#shop-price-container').style.visibility = "collapse"
	// }
}

function SetShopGlyphEvents(shopGlyphPanel){
	shopGlyphPanel.FindChildTraverse('glyph-item-shop-button').SetPanelEvent('onmouseover', function heroGlyphsMouseover() {
		ItemShowTooltipOnPanel(shopGlyphPanel)
    })
	shopGlyphPanel.FindChildTraverse('glyph-item-shop-button').SetPanelEvent('onmouseout', function heroGlyphsMouseout() {
		ItemHideTooltipByPanel(shopGlyphPanel)
    })
	shopGlyphPanel.FindChildTraverse('glyph-item-shop-button').SetPanelEvent('onactivate', function heroShopGlyphClick() {
		PurchaseGlyph(shopGlyphPanel)
    })    
}

function PurchaseGlyph(glyphPanel)
{
	if (GameUI.CustomUIConfig().glyphShopLock == 0 && mTier >= glyphPanel.rowTier){
		var heroIndex = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() )
		GameEvents.SendCustomGameEventToServer( "glyph_purchase", {heroIndex: heroIndex, glyphName: glyphPanel.itemName, tier: glyphPanel.rowTier, column: glyphPanel.column, glyphHero: glyphPanel.heroName});
		GameUI.CustomUIConfig().glyphShopLock = 1
		Game.EmitSound("Glyphs.Purchase")
	}
}

function GlyphPurchaseConfirm()
{
	GameUI.CustomUIConfig().glyphShopLock = 0
}
function getTierCost(tier, column, heroName)
{
	var cost = 0
	if (tier == 1){
		cost = 200
	}else if (tier == 2){
		cost = 500
	}else if (tier == 3){
		cost = 1000
	}else if (tier == 4){
		cost = 2000
	}else if (tier == 5){
		cost = 5000
	}else if (tier == 6){
		cost = 10000
	}else if (tier == 7){
		cost = 25000
	}
	if (column==2){
		if (!(heroName=="tooltip_neutral")){
			cost = cost*5
		}
	}
	return cost
}

function getRarityForTier(tier)
{
	var rarity = 0
	if (tier <= 2){
		rarity = 2;
	}else if(tier<=4){
		rarity = 3;
	}else{
		rarity = 4;
	}
	return rarity
}

function minLevelForTier(tier)
{
	return tier*15
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

	GameEvents.Subscribe( "glyph_recipes_loaded", OpenGlyphShopForHeroAfterServerLoads );
})();
