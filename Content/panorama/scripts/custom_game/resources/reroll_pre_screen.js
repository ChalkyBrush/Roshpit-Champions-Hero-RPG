
mForgePriceBoxContainerMain = $.GetContextPanel().forgePriceBoxContainerMain
mFinalForgeButton = $.GetContextPanel().finalForgeButton
mFinalForgeButtonContainer = $.GetContextPanel().finalForgeButtonContainer
mFinalForgeButtonLabel = $.GetContextPanel().finalForgeButtonLabel
mAttachItemPanel = $.GetContextPanel().attachItemPanel
mDetailParent = false
function InitializeRerollPreScreen()
{
	$('#item_placement_tip').text = $.Localize('reroll_tip_one')
	$('#reroll_other_tip').text = $.Localize('reroll_tip_two')
	$('#item_image').SetImage("file://{images}/custom_game/ui/empty-inventory-slot.png")
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

	var itemValues = CustomNetTables.GetTableValue( "item_basics", draggedItem.toString() )
	var rarity = itemValues.rarityFactor
	$.Msg(rarity)
	if (!(rarity == 5)){
		return true
	}
	// highlight this panel as a drop target
	$('#item_image').AddClass( "item_highlight" );
	Game.EmitSound("Item.DropRecipeWorld")
	return true;
}

function OnDragDrop( panelId, draggedPanel )
{
	var draggedItem = draggedPanel.m_DragItem;
	draggedPanel.lockOrder = true
	// only care about dragged items other than us
	if ( draggedItem === null )
		return true;
	var itemValues = CustomNetTables.GetTableValue( "item_basics", draggedItem.toString() )
	var rarity = itemValues.rarityFactor
	if (itemValues.slot == "weapon"){
		return false;
	}
	if (draggedPanel.fromInventory && rarity == 5){
			var playerID = Game.GetLocalPlayerID()
			var heroIndex = Players.GetPlayerHeroEntityIndex( playerID)
			Game.EmitSound("ui.crafting_pulse")
			// LoadItemForReroll(draggedItem)
			GameEvents.SendCustomGameEventToServer( "drag_into_reroll_slot", {playerID: playerID, heroIndex: heroIndex, itemIndex: draggedItem, ignoreLock: 0, lock1: 0, lock2: 0, lock3: 0, lock4: 0});
	}
	return true

}

function OnDragLeave( panelId, draggedPanel )
{
	var draggedItem = draggedPanel.m_DragItem;
	if ( draggedItem === null || draggedItem == m_Item )
		return false;

	$('#item_image').RemoveClass( "item_highlight" );
	return true;
}

mItemIndex = -1;

function LoadItemForReroll(msg)
{
	$.Msg("LOAD ITEM FOR REROLL")
	$.Msg("-----------")
	$.Msg(msg.ignoreLock)
	var itemIndex = msg.itemIndex
	if (parseInt(msg.ignoreLock) == 1){
		$.Msg("ITEM REROLL UNLOCK!")
		GameUI.CustomUIConfig().blacksmithLock = 0
	}
	var parentPanel = mAttachItemPanel
	var forgePriceContainer = mForgePriceBoxContainerMain
	var forgeButton = mFinalForgeButton
	parentPanel.RemoveAndDeleteChildren()
	var newChildPanel = $.CreatePanel( "Panel", parentPanel, "reroll-item" );
	newChildPanel.itemIndex = itemIndex
	mItemIndex = itemIndex
	newChildPanel.chisel = 0
	newChildPanel.reroll = 1
	newChildPanel.forgeButton = forgeButton
	newChildPanel.forgePriceContainer = forgePriceContainer
	newChildPanel.shards = mShards
	// newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/resources/item_detail_blacksmith.xml", false, false );	
	var playerID = Game.GetLocalPlayerID();

		
	GameUI.CustomUIConfig().rerollItem = itemIndex
	newChildPanel.BLoadLayoutSnippet("item_detail_blacksmith");
	newChildPanel.lockedSlotsCount = 0
	mDetailParent = newChildPanel
	InitializeItemDisplay(newChildPanel)

	lockSlotsFromServerCall(msg)
	// $.Schedule(0.5, function(){
		mFinalForgeButtonContainer.RemoveClass('invisible')
		mFinalForgeButtonLabel.text = $.Localize('#action_finish_reroll')
	// });
}

function InitializeItemDisplay(detail_parent)
{
	$.Msg("ITEM PLACED??")
	var minLevel = populateItem(detail_parent)
	detail_parent.minLevel = minLevel
	Game.EmitSound("ui.crafting_gem_drop")
	if (detail_parent.chisel == 1){
		var chiselPrice = Math.floor(minLevel*1)
		// chiselPrice = 1000000
		detail_parent.FindChildTraverse('forge_price_label').text = $.Localize('#message_chisel_price')
		detail_parent.FindChildTraverse('forge_price_label_value').text = chiselPrice
		detail_parent.forgeButton.chiselItemIndex = mItemIndex
		detail_parent.forgeButton.chiselCost = chiselPrice
		if (detail_parent.shards >= chiselPrice){
			detail_parent.forgeButton.AddClass('forge_button_color_main')
			detail_parent.forgeButton.RemoveClass('forge_button_deactivated')

		}else{
			detail_parent.forgeButton.RemoveClass('forge_button_color_main')
			detail_parent.forgeButton.AddClass('forge_button_deactivated')
			detail_parent.forgeButton.FindChild('final_forge_button_label').text = $.Localize('#not_enough_shards')
		}
		// mForgePriceContainer.FindChild("forge_price_image_main").RemoveClass('invisible')
		// mForgePriceContainer.FindChild("forge_price_label_value_main").text = chiselPrice
	}else if (detail_parent.reroll == 1){
		recalculatePriceReroll(detail_parent)
	}

}

mLockedSlot1 = 0
mLockedSlot2 = 0
mLockedSlot3 = 0
mLockedSlot4 = 0

function recalculatePriceReroll(detail_parent){
	var minLevel = detail_parent.minLevel
	var rerollPrice = Math.floor(minLevel*3)
	if (detail_parent.lockedSlotsCount >= 1){
		rerollPrice = rerollPrice * 2
	}
	if (detail_parent.lockedSlotsCount >= 2){
		rerollPrice = rerollPrice * 2
	}
	detail_parent.FindChildTraverse('forge_price_label').text = $.Localize('#message_reroll_price')
	detail_parent.FindChildTraverse('forge_price_label_value').text = rerollPrice
	detail_parent.forgeButton.rerollItemIndex = detail_parent.forgeButton.chiselItemIndex
	detail_parent.forgeButton.rerollCost = rerollPrice
	detail_parent.forgeButton.itemLevel = minLevel
	detail_parent.forgeButton.lock1 = mLockedSlot1
	detail_parent.forgeButton.lock2 = mLockedSlot2
	detail_parent.forgeButton.lock3 = mLockedSlot3
	detail_parent.forgeButton.lock4 = mLockedSlot4
	if (mShards >= rerollPrice){
		detail_parent.forgeButton.AddClass('forge_button_color_main')
		detail_parent.forgeButton.RemoveClass('forge_button_deactivated')

	}else{
		detail_parent.forgeButton.RemoveClass('forge_button_color_main')
		detail_parent.forgeButton.AddClass('forge_button_deactivated')
		detail_parent.forgeButton.FindChild('final_forge_button_label').text = $.Localize('#not_enough_shards')
	}
}



function populateItem(detail_parent)
{
	$.Msg(detail_parent)
	$.Msg(mItemIndex)
	detail_parent.FindChildTraverse('item_image').contextEntityIndex = mItemIndex;
	detail_parent.FindChildTraverse('item_image').SetAttributeInt("item", mItemIndex)
	var itemName = Abilities.GetAbilityName( mItemIndex);

	var itemValues = CustomNetTables.GetTableValue( "item_basics", mItemIndex.toString() )
	
	var rarityColor = itemValues.qualityColor
	detail_parent.FindChildTraverse('item_name').text = "<font color='"+rarityColor+"'>"+$.Localize("#DOTA_Tooltip_ability_"+itemName)+"</font>"

	var parentPanel = detail_parent.FindChildTraverse("item_properties_container")
	for (i = 1; i <= 4; i++) 
	{ 
		var itemProperty = CustomNetTables.GetTableValue( "item_properties", mItemIndex.toString()+"-"+i.toString() )
		createAttributeRow(itemProperty, parentPanel, i, detail_parent)
		// if (itemProperty){
		// 	var newChildPanel = $.CreatePanel( "Panel", parentPanel, "chisel-item-attribute"+i );
		// 	newChildPanel.propertyTable = itemProperty
		// 	newChildPanel.chisel = 0
		// 	newChildPanel.reroll = 1
		// 	newChildPanel.propertySlot = i
		// 	newChildPanel.rerollParent = $.GetContextPanel()
		// 	newChildPanel.BLoadLayoutSnippet("blacksmith_item_row");
		// 	newChildPanel.FindChildTraverse('property_name').text = "<font color='"+itemProperty.propertyColor+"'>"+$.Localize(itemProperty.propertyName)+"</font>"
		// 	newChildPanel.FindChildTraverse('property_value').text = "<font color='"+itemProperty.propertyColor+"'>"+itemProperty.propertyValue+"</font>"

		// 	var button = newChildPanel.FindChildTraverse('property_row_button')
		// 	button.SetPanelEvent('onmouseover', function SetButtonItemMouseover(){
		// 		PropertyLockTooltip(button)
		// 	});
		// 	button.SetPanelEvent('onmouseout', function SetButtonItemMouseover(){
		// 		HidePropertyTooltip(button)
		// 	});
		// }
	}
	if (itemValues.minLevel){
		var minLevelText = $.Localize('#item_min_level')
		var reductionTable = CustomNetTables.GetTableValue( "min_level_reduction", mItemIndex.toString() )
		var reduction = 0
		if (!(reductionTable===undefined)){
			reduction = reductionTable.levelReduce
		}
		detail_parent.FindChildTraverse('min_level_label').text = minLevelText
		var minLevelValue = parseInt(itemValues.minLevel - reduction)
		detail_parent.FindChildTraverse('min_level_label_value').text = minLevelValue
		return minLevelValue
	}else{
		detail_parent.FindChildTraverse('min_level_label').AddClass('invisible')
		detail_parent.FindChildTraverse('min_level_label_value').AddClass('invisible')
		return 1
	}
}


mButtonTable = []
mChildPanelTable = []

function createAttributeRow(itemProperty, parentPanel, i, detail_parent)
{
	if (itemProperty){
		var newChildPanel = $.CreatePanel( "Panel", parentPanel, "chisel-item-attribute"+i );
		newChildPanel.propertyTable = itemProperty
		newChildPanel.chisel = 0
		newChildPanel.reroll = 1
		newChildPanel.propertySlot = i
		newChildPanel.rerollParent = $.GetContextPanel()
		newChildPanel.BLoadLayoutSnippet("blacksmith_item_row");
		newChildPanel.FindChildTraverse('property_name').text = "<font color='"+itemProperty.propertyColor+"'>"+$.Localize(itemProperty.propertyName)+"</font>"
		newChildPanel.FindChildTraverse('property_value').text = "<font color='"+itemProperty.propertyColor+"'>"+itemProperty.propertyValue+"</font>"

		var button = newChildPanel.FindChildTraverse('property_row_button')
		button.slot = i
		button.propertyLocked = 0
		mButtonTable[i] = button
		mChildPanelTable[i] = newChildPanel
		button.SetPanelEvent('onmouseover', function SetButtonItemMouseover(){
			PropertyLockTooltip(button)
		});
		button.SetPanelEvent('onmouseout', function SetButtonItemMouseover(){
			HidePropertyTooltip(button)
		});
		button.SetPanelEvent('onactivate', function SetButtonClick(){
			PropertyButtonActivate(button, detail_parent, newChildPanel)
		});
	}
}



function lockSlotsFromServerCall(msg)
{
	$.Msg("BEGIN LOCK SLOT FROM SERVER")
	$.Msg(msg)
	$.Msg(mButtonTable[1])
	if (msg.lock1==1){
		PropertyButtonActivate(mButtonTable[1], mDetailParent, mChildPanelTable[1])
	}
	if (msg.lock2==1){
		$.Msg("999999999WTF?99999999")
		PropertyButtonActivate(mButtonTable[2], mDetailParent, mChildPanelTable[2])
	}
	if (msg.lock3==1){
		PropertyButtonActivate(mButtonTable[3], mDetailParent, mChildPanelTable[3])
	}
	if (msg.lock4==1){
		PropertyButtonActivate(mButtonTable[4], mDetailParent, mChildPanelTable[4])
	}
}

function PropertyButtonActivate(button, detail_parent, newChildPanel){
	if (button.propertyLocked==0){
		if (detail_parent.lockedSlotsCount < 2){
			button.propertyLocked = 1
			newChildPanel.AddClass('locked_property')
			newChildPanel.FindChildTraverse('property-lock-image').RemoveClass('invisible')
			detail_parent.lockedSlotsCount = detail_parent.lockedSlotsCount + 1
			setLockSlot(button.slot)
			recalculatePriceReroll(detail_parent)
		}
	}else{
		button.propertyLocked= 0
		newChildPanel.RemoveClass('locked_property')
		newChildPanel.FindChildTraverse('property-lock-image').AddClass('invisible')
		detail_parent.lockedSlotsCount = detail_parent.lockedSlotsCount - 1
		setLockSlot(button.slot)
		recalculatePriceReroll(detail_parent)
	}
}

mLockedSlot1 = 0
mLockedSlot2 = 0
mLockedSlot3 = 0
mLockedSlot4 = 0

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

function PropertyLockTooltip(panel){
	// var panel = attributePanel.FindChildTraverse('property_row_button')
	panel.AddClass('property_row_button_hover')
	var title = "<font color='yellow'>"+$.Localize('#property_lock_title')
	var tooltip = $.Localize('#property_lock_tooltip')
	$.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function HidePropertyTooltip(panel){
	// var panel = attributePanel.FindChildTraverse('property_row_button')
	panel.RemoveClass('property_row_button_hover')
	$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
}




(function()
{
	InitializeRerollPreScreen();
	GameEvents.Subscribe( "load_item_for_reroll", LoadItemForReroll );
	GameEvents.Subscribe( "lockSlotsFromServerCall", lockSlotsFromServerCall );

	$.GetContextPanel().lockSlotsFromServerCall = lockSlotsFromServerCall;

	$.RegisterEventHandler( 'DragEnter', $('#item_image'), OnDragEnter );
	$.RegisterEventHandler( 'DragDrop', $('#item_image'), OnDragDrop );
	$.RegisterEventHandler( 'DragLeave', $('#item_image'), OnDragLeave );
})();

