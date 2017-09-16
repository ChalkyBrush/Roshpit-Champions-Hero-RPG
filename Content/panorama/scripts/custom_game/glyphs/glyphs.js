function InitializeGlyphs()
{
	$('#glyph_title_label').text = $.Localize("#ui_glyphs_title")
	// itemPanel.GetAttributeInt( "item", -1 );
	var glyphPanel = $.CreatePanel( "Panel", $("#glyph-row-1"), "" );
	glyphPanel.glyphID = 0
	glyphPanel.glyphSlot = 1
	glyphPanel.BLoadLayout( "file://{resources}/layout/custom_game/glyphs/glyph_item.xml", false, false );
	GameUI.CustomUIConfig().glyph1 = glyphPanel.FindChild('glyph_button').FindChild('glyph_image')
	GameUI.CustomUIConfig().glyph1.glyph = true

	var glyphPanel2 = $.CreatePanel( "Panel", $("#glyph-row-2"), "" );
	glyphPanel2.glyphID = 0
	glyphPanel2.glyphSlot = 2
	glyphPanel2.BLoadLayout( "file://{resources}/layout/custom_game/glyphs/glyph_item.xml", false, false );
	glyphPanel2.AddClass('glyph2')
	GameUI.CustomUIConfig().glyph2 = glyphPanel2.FindChild('glyph_button').FindChild('glyph_image')
	GameUI.CustomUIConfig().glyph2.glyph = true

	var glyphPanel3 = $.CreatePanel( "Panel", $("#glyph-row-2"), "" );
	glyphPanel3.glyphID = 0
	glyphPanel3.glyphSlot = 3
	glyphPanel3.BLoadLayout( "file://{resources}/layout/custom_game/glyphs/glyph_item.xml", false, false );
	glyphPanel3.AddClass('glyph3')
	GameUI.CustomUIConfig().glyph3 = glyphPanel3.FindChild('glyph_button').FindChild('glyph_image')
	GameUI.CustomUIConfig().glyph3.glyph = true

	// UpdateGlyphDisplay()
}

function NewGlyphInserted(msg)
{
	var glyphSlot = msg.glyphSlot
	var glyphPanel
	if (glyphSlot == 1){
		glyphPanel = GameUI.CustomUIConfig().glyph1
	}else if(glyphSlot == 2){
		glyphPanel = GameUI.CustomUIConfig().glyph2
	}else if(glyphSlot == 3){
		glyphPanel = GameUI.CustomUIConfig().glyph3
	}
	Game.EmitSound("Glyphs.Insert")
	UpdateGlyphDisplay(0.51);
	glyphPanel.AddClass("lightUpGlyph")
	$.Schedule(1.5, function(){
		glyphPanel.RemoveClass("lightUpGlyph")
	});
}

function UpdateGlyphDisplay(delay)
{
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	$.Msg(Entities.IsHero(queryUnit))
	var playerID = Players.GetLocalPlayer()
	if (Entities.IsHero(queryUnit)){
		var playerTable = CustomNetTables.GetTableValue( "hero_index", queryUnit.toString() );
		if (playerTable === undefined){
			playerID= Players.GetLocalPlayer();
		}else{
			playerID = playerTable.playerOwner
		}
	}else{
		if (Players.IsSpectator(Players.GetLocalPlayer())){
		 	playerID = 0
		}else{
			playerID = Players.GetLocalPlayer();
		}
	}

	$.Msg(playerID.toString()+"-glyph-1")
	var glyphTable1 = CustomNetTables.GetTableValue( "skill_tree", playerID.toString()+"-glyph-1" )
	var glyph1 = -1
	if (!(glyphTable1 == undefined)) {
		glyph1 = glyphTable1.glyphIndex
	}
	UpdateIndividualGlyph(glyph1, GameUI.CustomUIConfig().glyph1, delay)

	var glyphTable2 = CustomNetTables.GetTableValue( "skill_tree", playerID.toString()+"-glyph-2" )
	var glyph2 = -1
	if (!(glyphTable2 == undefined)) {
		glyph2 = glyphTable2.glyphIndex
	}
	UpdateIndividualGlyph(glyph2, GameUI.CustomUIConfig().glyph2, delay)

	var glyphTable3 = CustomNetTables.GetTableValue( "skill_tree", playerID.toString()+"-glyph-3" )
	var glyph3 = -1
	if (!(glyphTable3 == undefined)) {
		glyph3 = glyphTable3.glyphIndex
	}
	UpdateIndividualGlyph(glyph3, GameUI.CustomUIConfig().glyph3, delay)

}

function UpdateIndividualGlyph(glyph, glyphPanel, delay)
{
	var textureName = "file://{images}/custom_game/ui/empty_inventory.png"
	if (glyph > 0){
		textureName = "file://{images}/items/"+Abilities.GetAbilityTextureName( glyph)+".png"
	}
	$.Msg(textureName)
	glyphPanel.SetAttributeInt( "item", glyph );
	$.Schedule(delay, function(){
		glyphPanel.SetImage(textureName)
	});
}

(function()
{
	GameEvents.Subscribe( "new_glyph_inserted", NewGlyphInserted );
	GameEvents.Subscribe( "update_glyphs", UpdateGlyphDisplay );

	// GameEvents.Subscribe( "dota_player_update_query_unit", UpdateGlyphDisplay );
	// GameEvents.Subscribe( "dota_player_update_selected_unit", UpdateGlyphDisplay );
	InitializeGlyphs();
})();

