function hero_icon_click(){
	var heroClickIndex = $('#HeroIcon').heroIndex
	GameUI.SelectUnit( heroClickIndex, false )
}

function hero_icon_right_click(){
	var heroClickIndex = $('#HeroIcon').heroIndex
	if (!(heroClickIndex==Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ))){
		var contextMenu = $.CreatePanel( "Panel", $('#menu-container'), "" );
		contextMenu.AddClass( "ContextMenu_NoArrow" );
		contextMenu.AddClass( "ContextMenu_NoBorder" );
		contextMenu.hero = $('#HeroIcon').heroIndex;
		contextMenu.menu = $('#menu-container')
		contextMenu.BLoadLayout( "file://{resources}/layout/custom_game/top_board_menu.xml", false, false );
		$('#menu-container').AddClass('menu-open')
		$('#menu-container').AddClass('animateFromTop')
	}
}