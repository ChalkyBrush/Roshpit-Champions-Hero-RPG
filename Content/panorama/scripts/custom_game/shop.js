function select_rarity(message){
	$('#uncommon_panel').RemoveClass('button_glow');
	$('#rare_panel').RemoveClass('button_glow');
	$('#mythical_panel').RemoveClass('button_glow');
	$('#'+message+'_panel').AddClass('button_glow');
	$("#all_items_container").RemoveClass('collapsed');
	$("#all_items_container").RemoveClass('animateEaseClass');
	if ($("#all_items_container").GetAttributeInt('isOpen', -1) == 1){
        $.Schedule(0.45, function(){
        	$("#all_items_container").RemoveClass('animateEaseOutClass');
        	$("#all_items_container").AddClass('animateEaseClass');
        	update_colors(message);
        });	
        $("#all_items_container").AddClass('animateEaseOutClass');	
    }else{
    	$("#all_items_container").SetAttributeInt('isOpen', 1)
    	$("#all_items_container").AddClass('animateEaseClass');
    	update_colors(message);    	
    }
    $("#all_items_container").AddClass('animateEaseClass');
	$("#click_rarity_notification").AddClass('collapsed');
	Game.EmitSound("ui.trophy_new")
	$("#all_items_container").SetAttributeString('rarity', message)
}

function update_colors(message){
	for ( var i = 1; i < 16; ++i )
	{
	if ($('#item_name'+i)!=undefined){
		$('#item_name'+i).RemoveClass("uncommon_color");
		$('#item_name'+i).RemoveClass("rare_color");
		$('#item_name'+i).RemoveClass("mythical_color");
		var price = 0;
			if (message == "uncommon")
			{
				if (i <= 12){
					price = 350
				}else{
					price = 200
				}
				$('#item_name'+i).AddClass("uncommon_color");
			}
			if (message == "rare")
			{
				if (i <= 12){
					price = 1050
				}else{
					price = 600
				}
				$('#item_name'+i).AddClass("rare_color");
			}
			if (message == "mythical")
			{
				if (i <= 12){
					price = 3150
				}else{
					price = 1200
				}
				$('#item_name'+i).AddClass("mythical_color");
			}
			$('#item_price'+i).text = price.toString();
			$('#item_price'+i).SetAttributeInt("price", price);
		}
	}
}

function buy_item(message){
	$.Msg("Buy Item "+message);
	var id = Players.GetLocalPlayer();
	var price = $('#item_price'+message).GetAttributeInt("price", 0);
	var rarity = $("#all_items_container").GetAttributeString('rarity', "uncommon")
	GameEvents.SendCustomGameEventToServer( "buy_item", {itemtype: message, playerID: id, price: price, rarity: rarity, close: false} );
}

function ShopTooltip(title, message, panelNum){
	message = $.Localize( "#"+message)
	title = $.Localize( "#"+title)
	var tooltip = message
	$.DispatchEvent("DOTAShowTitleTextTooltip", $('#item_panel'+panelNum), title, tooltip);
}

function ShopHideTooltip(panelNum)
{
	$.DispatchEvent( "DOTAHideTitleTextTooltip", $('#item_panel'+panelNum) );
}

function InitializeShopPanels(){
	$("#all_items_container").SetAttributeInt('isOpen', 0)
	$("#all_items_container").SetAttributeInt('isCollapsed', 1)
	$("#click_rarity_notification").RemoveClass('collapsed');
	$("#all_items_container").AddClass('collapsed');
	$("#root_shop_panel_inner").RemoveClass('animateEaseOutClass');
	$("#root_shop_panel_inner").RemoveClass('collapsed');
	$("#root_shop_panel_inner").AddClass('collapsed');
	$('#uncommon_panel').RemoveClass('button_glow');
	$('#rare_panel').RemoveClass('button_glow');
	$('#mythical_panel').RemoveClass('button_glow');
	$('#uncommon_button_text').text = $.Localize( "#shop_button_common")
	$('#rare_button_text').text = $.Localize( "#shop_button_rare")
	$('#mythical_button_text').text = $.Localize( "#shop_button_mythical")
	$('#shop_title_text').text = $.Localize( "#shop_title_gheed")
}

function ClosePanel(){
	$("#root_shop_panel_inner").RemoveClass('animateEaseOutClass');
	$("#root_shop_panel_inner").AddClass('animateEaseOutClass')
        $.Schedule(0.45, function(){
        	InitializeShopPanels();
        });	
        var randomIndex = Math.floor((Math.random() * 2));
		var sounds = new Array("secretshop_secretshop_comeagain_01", "secretshop_secretshop_comeagain_02")
		if ($("#all_items_container").GetAttributeInt('isCollapsed', 1) == 0)
		{
			Game.EmitSound( sounds[randomIndex] )
		}
}

function OpenShop(){
	if ($("#all_items_container").GetAttributeInt('isCollapsed', 1) == 1)
	{
		$("#root_shop_panel_inner").RemoveClass('collapsed');
		$("#root_shop_panel_inner").RemoveClass('animateEaseClass');
		$("#root_shop_panel_inner").RemoveClass('animateEaseOutClass');
		$("#root_shop_panel_inner").AddClass('animateEaseClass')
		$("#all_items_container").SetAttributeInt('isCollapsed', 0)
		var randomIndex = Math.floor((Math.random() * 3));
		var sounds = new Array("secretshop_secretshop_welcome_04", "secretshop_secretshop_whatyoubuying_01", "secretshop_secretshop_whatyoubuying_02")
		Game.EmitSound( sounds[randomIndex] )
	}
}

(function()
{
	InitializeShopPanels();
	GameEvents.Subscribe( "OpenShop", OpenShop );
	GameEvents.Subscribe( "CloseShop", ClosePanel );
})();
