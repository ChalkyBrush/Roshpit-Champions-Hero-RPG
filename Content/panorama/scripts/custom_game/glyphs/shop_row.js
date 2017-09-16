mRowTier = $.GetContextPanel().rowTier
mHeroName = $.GetContextPanel().heroName
mPlayerTier = $.GetContextPanel().playerTier

function InitializeShopRow()
{
	var glyphsPerRow = 1
	if (mHeroName == "tooltip_neutral"){
		glyphsPerRow = 3
	}
	if (mRowTier > mPlayerTier){
		$('#shop-row-overlay').AddClass('shop-row-overlay-cant-use')
	}
	$('#shop-row-tier-label').text = $.Localize('#tooltip_tier')+" "+mRowTier
	var parent = $("#shop-row-contents")
	for (var i = 1; i <= glyphsPerRow; i++) {
		var newChildPanel = $.CreatePanel( "Panel", parent, "glyph-item"+i+"-"+mRowTier );
		newChildPanel.heroName = mHeroName
		newChildPanel.playerTier = mPlayerTier
		newChildPanel.rowTier = mRowTier
		newChildPanel.column = i
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/glyphs/shop_glyph_item.xml", false, false );	
	}
}



(function()
{
	InitializeShopRow();
})();
