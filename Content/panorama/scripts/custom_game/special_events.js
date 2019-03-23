function crixalisEventStart(){
	$.Msg("begin crixalis")
	$('#yellow_panel').RemoveClass('invisible');
	$('#yellow_panel').AddClass('animateEaseClassHalf');
	    $.Schedule(3, function(){
	    	$('#black_panel').RemoveClass('invisible');
	    	$('#black_panel').AddClass('animateEaseClass');
	    	$.Schedule(5, function(){
	    		$('#yellow_panel').AddClass('invisible');
	    		$('#yellow_panel').RemoveClass('animateEaseClassHalf');
	    		$('#black_panel').RemoveClass('animateEaseClass');
	    		$('#black_panel').AddClass('animateEaseOutClass');
	    		$.Schedule(0.5, function(){
	    			$('#black_panel').RemoveClass('animateEaseOutClass');
	    			$('#black_panel').AddClass('invisible');

	    		});
	    	});
	    });
}

function alarmEventStart(){
	$.Msg("begin alarm")
	$('#red_panel').RemoveClass('invisible');
	var loopCount = 4
	for (i = 0; i < loopCount; i++) { 
		$.Schedule(1*i, function(){
			$('#red_panel').AddClass('animateEaseClassHalfSecond');
			$('#red_panel').RemoveClass('animateEaseOutClassHalfSecond');
			Game.EmitSound( "General.CastFail_NoMana")
			$.Schedule(0.5, function(){
				$('#red_panel').RemoveClass('animateEaseClassHalfSecond');
				$('#red_panel').AddClass('animateEaseOutClassHalfSecond');
			});	
		});
	}
	$.Schedule(loopCount, function(){
		$('#red_panel').RemoveClass('animateEaseOutClassHalfSecond')
		$('#red_panel').AddClass('invisible')
	});

}

function OpenRareShop(){
	if ($("#rare_shop").GetAttributeInt('isCollapsed', 1) == 1){
		$("#rare_shop").RemoveClass('invisible');
		$("#rare_shop").RemoveClass('animateEaseClass');
		$("#rare_shop").RemoveClass('animateEaseOutClass');
		$("#rare_shop").AddClass('animateEaseClass')
		$("#rare_shop").SetAttributeInt('isCollapsed', 0)
		Game.EmitSound( "meepo_meepo_move_36" )
		$('#rare_item_price1').SetAttributeInt("price", 25000);
	}
}

function buy_item(message){
	$.Msg("Buy Item "+message);
	var id = Game.GetLocalPlayerID();
	var price = $('#rare_item_price'+message).GetAttributeInt("price", 0);
	GameEvents.SendCustomGameEventToServer( "buy_item", {itemtype: "immortal_helm", playerID: id, price: price, rarity: "immortal", close: true} );
}

function ShopTooltip(title, message, panelNum){
	message = $.Localize( "#"+message)
	title = $.Localize( "#"+title)
	var tooltip = message
	$.DispatchEvent("DOTAShowTitleTextTooltip", $('#rare_item_panel'+panelNum), title, tooltip);
}

function ShopHideTooltip(panelNum)
{
	$.DispatchEvent( "DOTAHideTitleTextTooltip", $('#rare_item_panel'+panelNum) );
}

function ClosePanel(){
	$("#rare_shop").RemoveClass('animateEaseOutClass');
	$("#rare_shop").AddClass('animateEaseOutClass')
        $.Schedule(0.45, function(){
        	$("#rare_shop").AddClass('invisible');
        	$("#rare_shop").SetAttributeInt('isCollapsed', 1)
        });	
}

function fadeToBlack(){
	$('#black_panel').RemoveClass('invisible');

	$('#black_panel').AddClass('animateEaseClassOneSecond');
	$('#black_panel').RemoveClass('animateEaseOutClassOneSecond');
	$.Schedule(1.5, function(){
		$('#black_panel').RemoveClass('animateEaseClassOneSecond');
		$('#black_panel').AddClass('animateEaseOutClassOneSecond');
	});	
	$.Schedule(2.4, function(){
		$('#black_panel').RemoveClass('animateEaseOutClassOneSecond');
		$('#black_panel').AddClass('invisible');
	});		

}

function bigTextMessage(message){
	$('#big_text_container').RemoveClass('invisible');
	$('#big_text').text = ""
	var text = $.Localize(message.message)
	$.Msg(text)
	var j = 1
	var loop = text.length
	for (i = 1; i < loop; i++) {
	 	$.Schedule(0.07*i, function(){
	 		j = j + 1
	 		$('#big_text').text = text.substring(0,j);
	 	});
	}
	$.Schedule(0.07*loop+2.5, function(){
		$('#big_text_container').AddClass("animateEaseOutClassOneSecond")
		$.Schedule(0.9, function(){
			$('#big_text_container').AddClass('invisible');
			$('#big_text_container').RemoveClass("animateEaseOutClassOneSecond");
		});
	});
	
}

function ruins_console(msg){
	if (!($('#special_event').eventIndex == 1)){
		var stoneIndex = msg.stoneIndex
		$.Msg(stoneIndex)
		$('#special_event').style.visibility = "visible"
		$('#special_event').RemoveAndDeleteChildren();
		$('#special_event').eventIndex = 1;
		var parentPanel = $('#special_event')
		reset_special_event(parentPanel)
		var newChildPanel = $.CreatePanel( "Panel", parentPanel, "ruins_console" );
		newChildPanel.stoneIndex = stoneIndex
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/events/ruins_console.xml", false, false );	
		newChildPanel.AddClass('animateEaseClassOneSecond')
		var playerID = Game.GetLocalPlayerID();
		Game.EmitSound( "Building_DireTower.Destruction.Distant")
		
	// GameEvents.SendCustomGameEventToServer( "save_menu", {playerID: playerID, saveOrLoad: "load"});
	}
}

function close_special_events(){
	$('#special_event').style.visibility = "collapse"
	$('#special_event').eventIndex = -1
}

function initializeSpecialEvents(){
	$('#special_event').eventIndex = -1
	GameUI.CustomUIConfig().specialEventsPanel = $('#special_event')
}

function screenBlur(msg){
	$.Msg("WE BLURRING!!")
	$('#special_event_image').style.visibility = "visible"
	$('#special_event_image').SetImage("file://{images}/custom_game/ui/blur_overlay.png")
	$('#special_event_image').AddClass('animateEaseClassOneSecond');
	$.Schedule(msg.duration, function(){
		$('#special_event_image').AddClass('animateEaseOutClassOneSecond');
		$.Schedule(1, function(){
			$('#special_event_image').style.visibility = "collapse"
			$('#special_event_image').SetImage("")
			$('#special_event_image').RemoveClass('animateEaseClassOneSecond');
			$('#special_event_image').RemoveClass('animateEaseOutClassOneSecond');
		});
	});
}

function flashHeal(msg){
	$.Msg("flash heal")
	var cursorPos = GameUI.GetScreenWorldPosition( GameUI.GetCursorPosition(Players.GetLocalPlayer()) )
	$.Msg(cursorPos)
	GameEvents.SendCustomGameEventToServer( "flash_heal", {xPos: cursorPos[0], yPos: cursorPos[1], auriun: msg.auriun} );
}

function reset_special_event(panel)
{
	panel.RemoveClass("align-right")
}

function phoenix_nest(msg){
	if (!($('#special_event').eventIndex == 2)){
		$('#special_event').style.visibility = "visible"
		$('#special_event').RemoveAndDeleteChildren();
		$('#special_event').eventIndex = 2;
		var parentPanel = $('#special_event')
		reset_special_event(parentPanel)
		parentPanel.AddClass("align-right")
		var newChildPanel = $.CreatePanel( "Panel", parentPanel, "phoenix_container" );
		newChildPanel.maxHealth = msg.max_health
		newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/events/phoenix_nest.xml", false, false );	
		newChildPanel.AddClass('animateEaseClassOneSecond')
		
	// GameEvents.SendCustomGameEventToServer( "save_menu", {playerID: playerID, saveOrLoad: "load"});
	}
}

function phoenix_hatch(msg){
	$('#red_panel').RemoveClass('invisible')
	$('#red_panel').AddClass('animateEaseClassHalfSecond');
	$.Schedule(0.5, function(){
			$('#red_panel').AddClass('animateEaseOutClassOneSecond');
			$.Schedule(0.95, function(){
				$('#red_panel').RemoveClass('animateEaseOutClassHalfSecond');
				$('#red_panel').AddClass('invisible');
				$('#red_panel').RemoveClass('animateEaseClassHalfSecond');
			});
	});
}

function enter_spirit_realm(){
	$('#generic_panel').RemoveClass('invisible');
	$('#generic_panel').AddClass('white_panel')
	$('#generic_panel').AddClass('animateEaseClassSpecial');
	
	$.Msg("EASING IN")
	    	$.Schedule(5, function(){
	    		$('#generic_panel').RemoveClass('animateEaseClassSpecial')
	    		$('#generic_panel').AddClass('animateEaseOutClassSpecial');
	    		$.Msg("EASING OUT")
	    		$.Schedule(3.95, function(){
	    			$('#generic_panel').RemoveClass('animateEaseOutClassSpecial');
	    			$('#generic_panel').AddClass('invisible');
	    			$.Msg("DONE")
	    		});
	    	});

}

function enter_equinox(){
	$('#generic_panel').RemoveClass('invisible');
	$('#generic_panel').AddClass('pale_green_panel')
	$('#generic_panel').AddClass('animateEaseClassSpecial');
	
	$.Msg("EASING IN")
	    	$.Schedule(5, function(){
	    		$('#generic_panel').RemoveClass('animateEaseClassSpecial')
	    		$('#generic_panel').AddClass('animateEaseOutClassSpecial');
	    		$.Msg("EASING OUT")
	    		$.Schedule(3.95, function(){
	    			$('#generic_panel').RemoveClass('animateEaseOutClassSpecial');
	    			$('#generic_panel').AddClass('invisible');
	    			$.Msg("DONE")
	    		});
	    	});

}

function sunstone_activate(){
	$('#generic_panel').RemoveClass('invisible');
	$('#generic_panel').AddClass('yellow_panel')
	$('#generic_panel').AddClass('animateEaseClassSpecial');
	
	$.Msg("EASING IN")
	    	$.Schedule(5, function(){
	    		$('#generic_panel').RemoveClass('animateEaseClassSpecial')
	    		$('#generic_panel').AddClass('animateEaseOutClassSpecial');
	    		$.Msg("EASING OUT")
	    		$.Schedule(3.95, function(){
	    			$('#generic_panel').RemoveClass('animateEaseOutClassSpecial');
	    			$('#generic_panel').AddClass('invisible');
	    			$.Msg("DONE")
	    		});
	    	});
	
}

(function () {
  initializeSpecialEvents();
  GameEvents.Subscribe( "crixalisEvent", crixalisEventStart );
  GameEvents.Subscribe( "vaultAlarmEvent", alarmEventStart );
  GameEvents.Subscribe( "OpenRareShop", OpenRareShop );
  GameEvents.Subscribe( "CloseRareShop", ClosePanel );
  GameEvents.Subscribe( "fadeToBlack", fadeToBlack );
  GameEvents.Subscribe( "big_text", bigTextMessage );
  GameEvents.Subscribe( "ruins_console_open", ruins_console );
  GameEvents.Subscribe( "special_event_close", close_special_events );
  GameEvents.Subscribe( "grizzly_medusa_event", screenBlur );
  GameEvents.Subscribe( "flash_heal", flashHeal );
  GameEvents.Subscribe( "phoenix_nest_begin", phoenix_nest );
  GameEvents.Subscribe( "phoenix_hatch", phoenix_hatch );
  GameEvents.Subscribe( "enter_spirit_realm", enter_spirit_realm );
  GameEvents.Subscribe( "enter_equinox", enter_equinox );
  GameEvents.Subscribe( "sunstone_activate", sunstone_activate );
})();
