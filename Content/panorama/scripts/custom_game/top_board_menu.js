"use strict";

function DismissMenu()
{
	$.DispatchEvent( "DismissAllContextMenus" )
}

function traderequest()
{
	$.Msg("Send Trade Request")
	GameEvents.SendCustomGameEventToServer( "tradeRequest", {heroFrom: Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), heroTo: $.GetContextPanel().hero});
	closeMenu()
}

function star_request()
{
	var heroIndex = $.GetContextPanel().hero
	stars_button_other(heroIndex)
	closeMenu()
}

function stars_button_other(heroIndex){
	if (GameUI.CustomUIConfig().starsOpen){
		GameUI.CustomUIConfig().starsParent.AddClass('outLeftBig')
		GameUI.CustomUIConfig().starsOpen = false
		GameUI.CustomUIConfig().starsParent.RemoveClass('fromLeftBig')
		$.Schedule(0.26, function(){	
			GameUI.CustomUIConfig().starsParent.AddClass("invisible")
		});	
	}else{
		GameEvents.SendCustomGameEventToServer( "stars_menu", {heroIndex: heroIndex, openingPlayerID: Players.GetLocalPlayer() });
	}
	
}

function closeMenu()
{
	$.GetContextPanel().menu.RemoveClass('menu-open');
	$.GetContextPanel().menu.RemoveClass('animateFromTop')
	$.GetContextPanel().menu.RemoveAndDeleteChildren();
}

function initializeMenu()
{
	$('#trade-request-label').text = $.Localize('#ui_trade')
	$('#close-label').text = $.Localize('#ui_close_panel')
}

(function()
{
	initializeMenu();
})();
