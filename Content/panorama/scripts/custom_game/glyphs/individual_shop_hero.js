mHeroName = $.GetContextPanel().heroName
mPopoutContainer = $.GetContextPanel().popoutContainer
mPlayerTier = $.GetContextPanel().playerTier
mShopContentsContainer = $.GetContextPanel().shopContentsContainer
MAX_TIERS = 7;

function InitializeshopHero()
{
	$.Msg(mHeroName)
	if (mHeroName == "tooltip_neutral"){
		$('#shop_portrait').SetImage( "file://{images}/custom_game/ui/empty_inventory.png")
		$('#slot_label_name').text = $.Localize(mHeroName)
	}else{
		$('#shop_portrait').SetImage( "file://{images}/heroes/" + mHeroName + ".png")
		$('#slot_label_name').text = ""
	}

}

function OpenGlyphShopForHero()
{
	mPopoutContainer.RemoveClass('animateInGlyph')
	$('#shop_portrait').AddClass('active-portrait')
	mPopoutContainer.RemoveClass('invisible')
	mPopoutContainer.style.visibility = "visible"
	mPopoutContainer.AddClass('animateInGlyph')
	GameEvents.SendCustomGameEventToServer( "get_glyph_availability", {playerID: Players.GetLocalPlayer(), hero: mHeroName});
	// var parent = mShopContentsContainer
	// parent.RemoveAndDeleteChildren();
	// for (var i = 1; i <= MAX_TIERS; i++) {
	// 	var newChildPanel = $.CreatePanel( "Panel", parent, "shop-row"+i );
	// 	newChildPanel.heroName = mHeroName
	// 	newChildPanel.playerTier = mPlayerTier
	// 	newChildPanel.rowTier = i
	// 	newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/glyphs/shop_row.xml", false, false );	
	// }
}

function OpenGlyphShopForHeroAfterServerLoads(msg)
{
	$.Msg(msg)
	var parent = mShopContentsContainer
	parent.RemoveAndDeleteChildren();
	for (var i = 1; i <= MAX_TIERS; i++) {
		var newChildPanel = $.CreatePanel( "Panel", parent, "shop-row"+i );
		newChildPanel.heroName = mHeroName
		newChildPanel.playerTier = mPlayerTier
		newChildPanel.rowTier = i
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/glyphs/shop_row.xml", false, false );	
	}
}

(function()
{
	// GameEvents.Subscribe( "glyph_recipes_loaded", OpenGlyphShopForHeroAfterServerLoads() );
	InitializeshopHero();
})();
