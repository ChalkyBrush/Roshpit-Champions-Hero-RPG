
mElement = $.GetContextPanel().element
mDifficulty = 0
function InitializeElementDrop()
{
	// $('#item_placement_tip').text = $.Localize('reroll_tip_one')
	// $('#reroll_other_tip').text = $.Localize('reroll_tip_two')
	$('#item_witch_doctor_slot').SetImage("file://{images}/custom_game/ui/empty-inventory-slot.png")
	if (mElement == "wind"){
		$.GetContextPanel().AddClass('green_border')
	}else if(mElement == "water"){
		$.GetContextPanel().AddClass('blue_border')
	}else if(mElement == "fire"){
		$.GetContextPanel().AddClass('red_border')
	}
}



function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

m_Item = 0;
mShards = $.GetContextPanel().shards

function OnDragEnter( a, draggedPanel )
{
	var draggedItem = draggedPanel.m_DragItem;

	// only care about dragged items other than us
	if ( draggedItem === null || (!(draggedPanel.fromInventory)) )
		return true;

	var itemName = Abilities.GetAbilityName(draggedItem)
	if (isValidCoreItem(itemName)){
		$('#item_witch_doctor_slot').AddClass( "item_highlight" );
	}
	// Game.EmitSound("Item.DropRecipeWorld")
	return true;
}

function OnDragDrop( panelId, draggedPanel )
{
	var draggedItem = draggedPanel.m_DragItem;
	
	// only care about dragged items other than us
	if ( draggedItem === null )
		return true;
	var itemName = Abilities.GetAbilityName(draggedItem)
	if (draggedPanel.fromInventory && isCorrectCoreItem(itemName)){
			var playerID = Game.GetLocalPlayerID()
			var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
			Game.EmitSound("ui.crafting_pulse")
			GameEvents.SendCustomGameEventToServer( "drag_item_to_tanari_doctor_slot", {playerID: playerID, heroIndex: heroIndex, itemIndex: draggedItem});
	}
	return true

}

function OnDragLeave( panelId, draggedPanel )
{
	var draggedItem = draggedPanel.m_DragItem;
	if ( draggedItem === null || draggedItem == m_Item )
		return false;

	$('#item_witch_doctor_slot').RemoveClass( "item_highlight" );
	return true;
}

function isValidCoreItem(itemName){
	if ((itemName.indexOf("_essence_of_wind_") > 0) || (itemName.indexOf("_heart_of_water_") > 0) || (itemName.indexOf("_core_of_fire_") > 0)){
		return true
	}else{
		return false
	}
}

function isCorrectCoreItem(itemName){
	if ((itemName.indexOf("_essence_of_wind_") > 0) && (mElement == "wind")){
		return true
	}
	if ((itemName.indexOf("_heart_of_water_") > 0) && (mElement == "water")){
		return true
	}
	if ((itemName.indexOf("_core_of_fire_") > 0) && (mElement == "fire")){
		return true
	}
	return false
}

function getItemDifficultyLevel(itemName){
	if ((itemName.indexOf("normal") > 0)){
		return 1
	}else if((itemName.indexOf("elite") > 0)){
		return 2
	}else if((itemName.indexOf("legend") > 0)){
		return 3
	}
}

function itemPlaced(msg)
{
	var itemIndex = msg.itemIndex
	var itemName = Abilities.GetAbilityName(itemIndex)
	if (isCorrectCoreItem(itemName)){
		$('#item_witch_doctor_slot').contextEntityIndex = itemIndex;
		$('#item_witch_doctor_slot').SetAttributeInt("item", itemIndex)
		
		mDifficulty = getItemDifficultyLevel(itemName)
		$.GetContextPanel().mDifficulty = mDifficulty
		if (mElement == "wind"){
			$.GetContextPanel().witchDoctorParent.wind = itemIndex
		}else if(mElement == "water"){
			$.GetContextPanel().witchDoctorParent.water = itemIndex
		}else if(mElement == "fire"){
			$.GetContextPanel().witchDoctorParent.fire = itemIndex
		}
		checkItemCondition()
	}

}



function checkItemCondition(){
	if (($.GetContextPanel().witchDoctorParent.wind > -1) && ($.GetContextPanel().witchDoctorParent.water > -1) && ($.GetContextPanel().witchDoctorParent.fire > -1)){
		$.Msg("CHECK ITEM CONDITION YES!")
		$.GetContextPanel().combineButton.RemoveClass('invisible')
	}
}


(function()
{
	InitializeElementDrop();
	GameEvents.Subscribe( "witch_doctor_item_placed", itemPlaced)
	$.RegisterEventHandler( 'DragEnter', $('#item_witch_doctor_slot'), OnDragEnter );
	$.RegisterEventHandler( 'DragDrop', $('#item_witch_doctor_slot'), OnDragDrop );
	$.RegisterEventHandler( 'DragLeave', $('#item_witch_doctor_slot'), OnDragLeave );
})();

