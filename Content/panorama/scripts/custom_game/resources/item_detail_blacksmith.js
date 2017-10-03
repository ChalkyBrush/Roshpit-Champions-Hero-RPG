mItemIndex = $.GetContextPanel().itemIndex
mSlot = $.GetContextPanel().slot
mChisel = $.GetContextPanel().chisel
mReroll = $.GetContextPanel().reroll
mMinLevel = 1
$.GetContextPanel().mLockedSlotsCount = 0
mLockedSlot1 = 0
mLockedSlot2 = 0
mLockedSlot3 = 0
mLockedSlot4 = 0
mForgePriceContainer = $.GetContextPanel().forgePriceContainer
mForgeButton = $.GetContextPanel().forgeButton
mShards = $.GetContextPanel().shards

function InitializeItemDisplay()
{
	$.Msg("ITEM PLACED??")
	var minLevel = populateItem()
	mMinLevel = minLevel
	Game.EmitSound("ui.crafting_gem_drop")
	if (mChisel == 1){
		var chiselPrice = Math.floor(minLevel*1)
		// chiselPrice = 1000000
		$('#forge_price_label').text = $.Localize('#message_chisel_price')
		$('#forge_price_label_value').text = chiselPrice
		mForgeButton.chiselItemIndex = mItemIndex
		mForgeButton.chiselCost = chiselPrice
		mForgeButton.chiselSlot = mSlot
		if (mShards >= chiselPrice){
			mForgeButton.AddClass('forge_button_color_main')
			mForgeButton.RemoveClass('forge_button_deactivated')

		}else{
			mForgeButton.RemoveClass('forge_button_color_main')
			mForgeButton.AddClass('forge_button_deactivated')
			mForgeButton.FindChild('final_forge_button_label').text = $.Localize('#not_enough_shards')
		}
		// mForgePriceContainer.FindChild("forge_price_image_main").RemoveClass('invisible')
		// mForgePriceContainer.FindChild("forge_price_label_value_main").text = chiselPrice
	}else if (mReroll == 1){
		recalculatePriceReroll()
	}

}

function recalculatePriceReroll(){
	var minLevel = mMinLevel
	var rerollPrice = Math.floor(minLevel*3)
	if ($.GetContextPanel().mLockedSlotsCount >= 1){
		rerollPrice = rerollPrice * 2
	}
	if ($.GetContextPanel().mLockedSlotsCount >= 2){
		rerollPrice = rerollPrice * 2
	}
	$('#forge_price_label').text = $.Localize('#message_reroll_price')
	$('#forge_price_label_value').text = rerollPrice
	mForgeButton.rerollItemIndex = mItemIndex
	mForgeButton.rerollCost = rerollPrice
	mForgeButton.itemLevel = minLevel
	mForgeButton.lock1 = mLockedSlot1
	mForgeButton.lock2 = mLockedSlot2
	mForgeButton.lock3 = mLockedSlot3
	mForgeButton.lock4 = mLockedSlot4
	if (mShards >= rerollPrice){
		mForgeButton.AddClass('forge_button_color_main')
		mForgeButton.RemoveClass('forge_button_deactivated')

	}else{
		mForgeButton.RemoveClass('forge_button_color_main')
		mForgeButton.AddClass('forge_button_deactivated')
		mForgeButton.FindChild('final_forge_button_label').text = $.Localize('#not_enough_shards')
	}
}

function setLockSlot(slot){
	if (slot == 1){
		if (mLockedSlot1 == 0){
			mLockedSlot1 = 1
		}else{
			mLockedSlot1 = 0
		}
	}else if (slot == 2){
		if (mLockedSlot2 == 0){
			mLockedSlot2 = 1
		}else{
			mLockedSlot2 = 0
		}
	}else if (slot == 3){
		if (mLockedSlot3 == 0){
			mLockedSlot3 = 1
		}else{
			mLockedSlot3 = 0
		}
	}else if (slot == 4){
		if (mLockedSlot4 == 0){
			mLockedSlot4 = 1
		}else{
			mLockedSlot4 = 0
		}
	}
}

function populateItem()
{
	$('#item_image').contextEntityIndex = mItemIndex;
	$('#item_image').SetAttributeInt("item", mItemIndex)
	var itemName = Abilities.GetAbilityName( mItemIndex);

	var itemValues = CustomNetTables.GetTableValue( "item_basics", mItemIndex.toString() )
	
	var rarityColor = itemValues.qualityColor
	$('#item_name').text = "<font color='"+rarityColor+"'>"+$.Localize("#DOTA_Tooltip_ability_"+itemName)+"</font>"

	var parentPanel = $("#item_properties_container")
	for (i = 1; i <= 4; i++) 
	{ 
		var itemProperty = CustomNetTables.GetTableValue( "item_properties", mItemIndex.toString()+"-"+i.toString() )
		if (itemProperty){
			var newChildPanel = $.CreatePanel( "Panel", parentPanel, "chisel-item" );
			newChildPanel.propertyTable = itemProperty
			newChildPanel.chisel = mChisel
			newChildPanel.reroll = mReroll
			newChildPanel.propertySlot = i
			newChildPanel.rerollParent = $.GetContextPanel()
			newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/resources/blacksmith_attribute_row.xml", false, false );	
		}
	}
	if (itemValues.minLevel){
		var minLevelText = $.Localize('#item_min_level')
		var reductionTable = CustomNetTables.GetTableValue( "min_level_reduction", mItemIndex.toString() )
		var reduction = 0
		if (!(reductionTable===undefined)){
			reduction = reductionTable.levelReduce
		}
		$('#min_level_label').text = minLevelText
		var minLevelValue = parseInt(itemValues.minLevel - reduction)
		$('#min_level_label_value').text = minLevelValue
		return minLevelValue
	}else{
		$('#min_level_label').AddClass('invisible')
		$('#min_level_label_value').AddClass('invisible')
		return 1
	}
}

function PurchaseGlyph()
{
	if (GameUI.CustomUIConfig().glyphShopLock == 0 && mPlayerTier >= mRowTier){
		var heroIndex = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() )
		GameEvents.SendCustomGameEventToServer( "glyph_purchase", {heroIndex: heroIndex, glyphName: mItemName, tier: mRowTier});
		GameUI.CustomUIConfig().glyphShopLock = 1
		Game.EmitSound("Glyphs.Purchase")
	}
}

function GlyphPurchaseConfirm()
{
	GameUI.CustomUIConfig().glyphShopLock = 0
}



function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function GetRarityColor(rarityFactor)
{
	var color
	if (rarityFactor == 1){
		color = "#B0C3D9"
	}
	else if (rarityFactor == 2){
		color = "#99FF33"
	}
	else if (rarityFactor == 3){
		color = "#4B69FF"
	}
	else if (rarityFactor == 4){
		color = "#8847FF"
	}
	else if (rarityFactor == 5){
		color = "#E4AE33"
	}
	return color
}

(function()
{
	$.GetContextPanel().RecalculatePrice = recalculatePriceReroll;
	$.GetContextPanel().setLockSlot = setLockSlot;
	InitializeItemDisplay();
})();

