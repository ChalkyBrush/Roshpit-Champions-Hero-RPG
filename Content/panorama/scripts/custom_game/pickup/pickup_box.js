var Root = $.GetContextPanel();
var item = Root.itemIndex;
var heroName = Root.heroName;
var pickup = Root.pickup;
var playerID = Root.playerID;
var popupIndex = Root.popupIndex;
var keyName = Root.keyName;

function InitializePickupBox(){
	$.Msg("data:")
	$.Msg(item)
	Root.AddClass("fromRight"+popupIndex)
	var hero_image_name = "file://{images}/heroes/" + heroName + ".png"
	$('#pickup_player_portrait').SetImage( hero_image_name );
	$('#pickup_player_name').text = Players.GetPlayerName(playerID)
	var itemValues = CustomNetTables.GetTableValue( "item_basics", item.toString() );
	if (!(itemValues===undefined)){
		var rarity = itemValues.rarityFactor
		$('#pickup_item_rarity').text = "<font color='"+itemValues.qualityColor+"'>"+capitalizeFirstLetter(itemValues.qualityName)
	}else{
		$('#pickup_item_rarity').text = "<font color='"+"#FFFFFF"+"'>"+$.Localize(keyName+"_portal_key")
	}
	if (pickup == "equip"){
		$('#pickup-bg').AddClass("equipBG")
		$('#pickup_label').text = $.Localize('#ui_equip_new')
	}
	else if(pickup == "greed"){
		$('#pickup-bg').AddClass("greedBG")
		$('#pickup_label').text = $.Localize('#ui_won_greed_roll')
	}
	else if(pickup == "need"){
		$('#pickup-bg').AddClass("needBG")
		$('#pickup_label').text = $.Localize('#ui_won_need_roll')
	}
	else if(pickup == "weapon"){
		$('#pickup-bg').AddClass("weaponBG")
		$('#pickup_label').text = $.Localize('#weapon_lvl_message')
	}else{
		$('#pickup-bg').AddClass("pickupBG")
		$('#pickup_label').text = ""
	}
	$('#ItemImagePickup').contextEntityIndex = item;
	$('#ItemImagePickup').SetAttributeInt("item", item)
	if (pickup == "key"){
		$('#pickup-bg').RemoveClass("pickupBG")
		$('#pickup-bg').AddClass("keyBG")
		$('#pickup_label').text = $.Localize('#ui_acquired_key')
		$('#ItemImagePickup').contextEntityIndex = -1;
		$('#ItemImagePickup').SetAttributeInt("item", -1)
		$('#ItemImagePickup').SetImage("file://{images}/custom_game/ui/full-key-"+keyName+".png")
	}
	// $('#ItemImagePickup').SetAttributeInt("queryUnit", heroName)
	
	// $.Schedule(0.01, function(){	
	// 	Root.AddClass("animateDown")
	// });
	$.Schedule(10, function(){		
		
		Root.RemoveClass("animateIn")
		Root.AddClass("animateOut")
		$.Schedule(0.29, function(){
			$.GetContextPanel().AddClass("invisible")		
			$.GetContextPanel().RemoveAndDeleteChildren()
			// 
		});		
		$.Schedule(0.5, function(){	
			// $.GetContextPanel().DeleteAsync(0)
		});
	});			
}

function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

(function()
{
	InitializePickupBox();
})();