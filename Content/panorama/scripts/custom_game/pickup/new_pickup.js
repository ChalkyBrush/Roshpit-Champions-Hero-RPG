var pickup_array = []
var pickupCount = 0

function PickupPopup(msg)
{
	$.Msg("PICKUP LETS GO")
	var parentPanel = $('#main_pickup_parent')
	var new_panel = $.CreatePanel( "Panel", parentPanel, "popup-box-"+pickupCount );

	var pickup_box = new_panel.BLoadLayoutSnippet("pickup_contents")
	InitializePickupBox(pickup_box, msg, pickupCount, new_panel)
	pickupCount++;
	pickup_array.push(new_panel)
	$.Schedule(10.5, function(){
		pickupCount--;			
		if (pickupCount == 0){
			parentPanel.RemoveAndDeleteChildren();
		}
	});

}

function InitializePickupBox(pickup_box, msg, popupIndex, pickup_parent){
	var item = msg.item

	pickup_parent.AddClass("fromRight"+popupIndex)
	var heroName = msg.heroId
	var hero_image_name = "file://{images}/heroes/" + heroName + ".png"
	pickup_parent.FindChildTraverse('pickup_player_portrait').SetImage( hero_image_name );
	pickup_parent.FindChildTraverse('pickup_player_name').text = Players.GetPlayerName(msg.playerId)
	var itemValues = CustomNetTables.GetTableValue( "item_basics", item.toString() );
	var pickup = msg.pickup
	if (!(itemValues===undefined)){
		var rarity = itemValues.rarityFactor
		pickup_parent.FindChildTraverse('pickup_item_rarity').text = "<font color='"+msg.rarityColor+"'>"+capitalizeFirstLetter(msg.rarity)
	}
	if (pickup == "equip"){
		pickup_parent.FindChildTraverse('pickup-bg').AddClass("equipBG")
		pickup_parent.FindChildTraverse('pickup_label').text = $.Localize('#ui_equip_new')
	}
	else if(pickup == "greed"){
		pickup_parent.FindChildTraverse('pickup-bg').AddClass("greedBG")
		pickup_parent.FindChildTraverse('pickup_label').text = $.Localize('#ui_won_greed_roll')
	}
	else if(pickup == "need"){
		pickup_parent.FindChildTraverse('pickup-bg').AddClass("needBG")
		pickup_parent.FindChildTraverse('pickup_label').text = $.Localize('#ui_won_need_roll')
	}
	else if(pickup == "weapon"){
		pickup_parent.FindChildTraverse('pickup-bg').AddClass("weaponBG")
		pickup_parent.FindChildTraverse('pickup_label').text = $.Localize('#weapon_lvl_message')
	}else{
		pickup_parent.FindChildTraverse('pickup-bg').AddClass("pickupBG")
		pickup_parent.FindChildTraverse('pickup_label').text = ""
	}
	
	var item_image = pickup_parent.FindChildTraverse('ItemImagePickup')
	item_image.contextEntityIndex = item;
	item_image.SetAttributeInt("item", item)

	var tooltip_panel = pickup_parent.FindChildTraverse('ItemImagePickup-container')
	tooltip_panel.SetPanelEvent('onmouseover', function PickUpTooltipShow() {
		set_item_tooltip(tooltip_panel, item)
	});		
	tooltip_panel.SetPanelEvent('onmouseout', function PickUpTooltipHide() {
		ItemHideTooltipPickup()
	});		
	$.Schedule(10, function(){		
		
		pickup_parent.RemoveClass("animateIn")
		pickup_parent.AddClass("animateOut")
		$.Schedule(0.29, function(){
			if (pickup_parent){
				pickup_parent.AddClass("invisible")		
				pickup_parent.RemoveAndDeleteChildren()
			}
		});	
	});	

}

function set_item_tooltip(tooltip_panel, item){
	$.Msg("SET IT")
	ItemShowTooltipPickup(tooltip_panel, item)
}

function ItemShowTooltipPickup(tooltip_panel, item){
	GameUI.CustomUIConfig.itemTooltip = item
	$.Msg("TT ME")
	$.DispatchEvent("UIShowCustomLayoutTooltip", tooltip_panel, "ItemTooltipPickup", "file://{resources}/layout/custom_game/equipment/item_tooltip.xml");
}

function ItemHideTooltipPickup(){
	$.DispatchEvent("UIHideCustomLayoutTooltip", "ItemTooltipPickup");
}

function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}


(function () {
  GameEvents.Subscribe( "PickupPopup", PickupPopup );
})();
