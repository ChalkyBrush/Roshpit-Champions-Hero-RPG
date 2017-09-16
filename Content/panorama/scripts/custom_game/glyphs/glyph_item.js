m_Item = 0;
m_GlyphSlot = $.GetContextPanel().glyphSlot;

function OnDragEnter( a, draggedPanel )
{
	var draggedItem = draggedPanel.m_DragItem;

	// only care about dragged items other than us
	if ( draggedItem === null || draggedItem == m_Item || (!(draggedPanel.glyph)) )
		return true;

	// highlight this panel as a drop target
	$('#glyph_image').AddClass( "glyph_highlighted" );
	Game.EmitSound("Glyphs.Highlight")
	return true;
}

function OnDragDrop( panelId, draggedPanel )
{
	var draggedItem = draggedPanel.m_DragItem;
	
	// only care about dragged items other than us
	if ( draggedItem === null )
		return true;
	if (draggedPanel.glyph){
			var glyphSlot = m_GlyphSlot;
			var playerID = Game.GetLocalPlayerID()
			var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
			GameEvents.SendCustomGameEventToServer( "glyph_in_slot", {playerID: playerID, heroIndex: heroIndex, itemIndex: draggedItem, glyphSlot: glyphSlot});
	}
	return true

}

function OnDragLeave( panelId, draggedPanel )
{
	var draggedItem = draggedPanel.m_DragItem;
	if ( draggedItem === null || draggedItem == m_Item )
		return false;

	$('#glyph_image').RemoveClass( "glyph_highlighted" );
	return true;
}

(function()
{
	// Drag and drop handlers ( also requires 'draggable="true"' in your XML, or calling panel.SetDraggable(true) )
	$.RegisterEventHandler( 'DragEnter', $.GetContextPanel(), OnDragEnter );
	$.RegisterEventHandler( 'DragDrop', $.GetContextPanel(), OnDragDrop );
	$.RegisterEventHandler( 'DragLeave', $.GetContextPanel(), OnDragLeave );
})();
