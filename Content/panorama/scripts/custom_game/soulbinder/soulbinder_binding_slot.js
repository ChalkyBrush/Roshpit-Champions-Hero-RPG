m_Item = -1
function InitializeElementDrop()
{
	// $('#item_placement_tip').text = $.Localize('reroll_tip_one')
	// $('#reroll_other_tip').text = $.Localize('reroll_tip_two')
	$('#socket_item_slot').SetImage("file://{images}/custom_game/ui/empty-inventory-slot.png")

}



function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}


function OnDragEnter( a, draggedPanel )
{
	var draggedItem = draggedPanel.m_DragItem;
	//$.Msg("HOVERITA")
	// only care about dragged items other than us
	if ( draggedItem === null || (!(draggedPanel.fromInventory)) )
		return true;

	var itemName = Abilities.GetAbilityName(draggedItem)
	if (isValidItem(draggedItem)){
		$.GetContextPanel().AddClass( "synth_highlight" );
		$.GetContextPanel().RemoveClass("blue_border")
	}
	// Game.EmitSound("Item.DropRecipeWorld")
	return true;
}

function StopUnit(unit){
    GameUI.DropItemLock = true
	$.Schedule(0.03, function(){
		GameUI.DropItemLock = false
	});
}

function OnDragDrop( panelId, draggedPanel )
{
	var draggedItem = draggedPanel.m_DragItem;
	//$.Msg("qwer")
	//$.Msg(draggedItem)
	//$.Msg("------------")
	// only care about dragged items other than us
	if ( draggedItem === null )
		return true;
	//$.Msg(panelId)
	//$.Msg(draggedItem)
	//$.Msg("421")
	var itemName = Abilities.GetAbilityName(draggedItem)
	if (draggedPanel.fromInventory && isValidItem(draggedItem)){
			var playerID = Game.GetLocalPlayerID()
			var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
			draggedPanel.m_DragCompleted = true
			m_Item = draggedItem
			Game.EmitSound("ui.crafting_pulse")
			var soul_bind_slot = $.GetContextPanel().GetAttributeInt( "soulbind_slot", 0)
			GameEvents.SendCustomGameEventToServer( "soulbinder", {itemIndex: m_Item, slot: soul_bind_slot, event_type: "item_up_for_binding"});
			$('#socket_item_slot').contextEntityIndex = draggedItem;
			$('#socket_item_slot').SetAttributeInt("item", draggedItem)		
			// $.GetContextPanel().AddClass("blue_border")
			$.GetContextPanel().RemoveClass( "synth_highlight" );
			//$.Msg("LETSGO6")

	}
	return true

}

function ItemShowTooltipInit()
{
	var item = m_Item
	if ( item == -1 )
		return;
	var itemName = Abilities.GetAbilityName( item );
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	$.GetContextPanel().SetAttributeInt( "item", item)
	//$.Msg("HELLO SIR")
	ItemShowTooltipOnPanel($.GetContextPanel())
}

function ItemHideTooltipInit()
{
	ItemHideTooltipByPanel($.GetContextPanel())
	// $.DispatchEvent( "DOTAHideTitleTextTooltip", $.GetContextPanel() );
	// $.DispatchEvent( "DOTAHideAbilityTooltip", $.GetContextPanel() );
}

function OnDragLeave( panelId, draggedPanel )
{
	var draggedItem = draggedPanel.m_DragItem;
	if ( draggedItem === null || draggedItem == m_Item )
		return false;
	// $.GetContextPanel().AddClass("blue_border")
	$.GetContextPanel().RemoveClass( "synth_highlight" );
	return true;
}

function isValidItem(item){
	var itemName = Abilities.GetAbilityName(item)
	var mItemName = $.GetContextPanel().GetAttributeString( "item_name", "")
	$.Msg($.GetContextPanel())
	if ((itemName == mItemName)){
		return true
	}else{
		return false
	}
}

function checkItemCondition(){
	if (($.GetContextPanel().witchDoctorParent.wind > -1) && ($.GetContextPanel().witchDoctorParent.water > -1) && ($.GetContextPanel().witchDoctorParent.fire > -1)){
		//$.Msg("CHECK ITEM CONDITION YES!")
		$.GetContextPanel().combineButton.RemoveClass('invisible')
	}
}


(function()
{
	InitializeElementDrop();
	$.RegisterEventHandler( 'DragEnter', $('#socket_item_slot'), OnDragEnter );
	$.RegisterEventHandler( 'DragDrop', $('#socket_item_slot'), OnDragDrop );
	$.RegisterEventHandler( 'DragLeave', $('#socket_item_slot'), OnDragLeave );
})();

