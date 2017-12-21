mRowTier = $.GetContextPanel().rowTier
mHeroName = $.GetContextPanel().heroName
mPlayerTier = $.GetContextPanel().playerTier
mColumn = $.GetContextPanel().column

var mItemName;
var mItemDescription;
var mItemRarity;
var mMinLevel;
var mRequiredHero;

function InitializeShopGlyphItem()
{
	mRequiredHero = $.GetContextPanel().heroName
	mHeroName = convertFullHeroNameToRPC(mHeroName)
	var glyphIndex = mRowTier+"_"+ mColumn
	$.Msg(mRequiredHero)
	if (mRequiredHero == "tooltip_neutral"){
		$.Msg("file://{images}/items/glyphs/glyph_"+glyphIndex+".png")
		$('#glyph-image').SetImage("file://{images}/items/glyphs/glyph_"+glyphIndex+".png")
	}else{
		$.Msg("file://{images}/items/glyphs/glyph_"+mHeroName+"_"+glyphIndex+".png")
		$('#glyph-image').SetImage("file://{images}/items/glyphs/glyph_"+mHeroName+"_"+glyphIndex+".png")
	}
	// $('#glyph-image').SetImage("file://{images}/items/glyphs/basic_glyph.png")
	
	
	mItemName = "item_rpc_"+mHeroName+"_glyph_"+glyphIndex
	mItemDescription = mItemName+"_description"
	mItemRarity = getRarityForTier(mRowTier)
	mMinLevel = minLevelForTier(mRowTier)
	
	if (mRequiredHero == "neutral"){
		mRequiredHero = "tooltip_neutral"
	}
	$('#glyph_purchase_price_value').text = numberWithCommas(getTierCost(mRowTier))
	// if (mColumn == 1){
	// 	$('#glyph_purchase_price_value').text = numberWithCommas(getTierCost(mRowTier))
	// }else{
	// 	$('#shop-price-container').style.visibility = "collapse"
	// }
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

function getTierCost(tier)
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

function GlyphTooltip(){
	var panel = $.GetContextPanel()
	var queryUnit = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() )
	var title = "<font color='"+GetRarityColor(mItemRarity)+"'>"+$.Localize("DOTA_Tooltip_Ability_"+mItemName)+"</font>"
	var tooltip = "<font color='#A3D4A1'>"+$.Localize(mItemDescription)+"</font>"
	// tooltip = breakUpTooltip(tooltip)
	tooltip = updateGlyphInTooltip(tooltip, mItemName)
	tooltip = tooltip + "<br><br><font color='#DB2766'>"+$.Localize('#item_min_level')+": "+mMinLevel+"</font>"
	tooltip = tooltip + "<br><br><font color='#F7501E'>"+$.Localize('#'+mRequiredHero)+" "+$.Localize('#tooltip_glyph')+"</font>"

	tooltip = updateSkillInTooltip(tooltip, queryUnit)
	$.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);	
}

function updateGlyphInTooltip(tooltip, glyphName)
{
	if (tooltip.indexOf("@glyph_property1") > -1){
		var value = getGlyphProperty1(glyphName)
		tooltip = tooltip.replace("@glyph_property1", "<font color='#CCFF66'>"+value+"</font>");
	}
	if (tooltip.indexOf("@glyph_property2") > -1){
		var value2 = getGlyphProperty2(glyphName)
		tooltip = tooltip.replace("@glyph_property2", "<font color='#CCFF66'>"+value2+"</font>");
	}
	var value3 = getGlyphProperty3(glyphName)
	if (tooltip.indexOf("@glyph_property3") > -1){
		tooltip = tooltip.replace("@glyph_property3", "<font color='#CCFF66'>"+value3+"</font>");
	}
	return tooltip
}



function HideGlyphTooltip(){
	var panel = $.GetContextPanel()
	$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
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
	InitializeShopGlyphItem();
})();

