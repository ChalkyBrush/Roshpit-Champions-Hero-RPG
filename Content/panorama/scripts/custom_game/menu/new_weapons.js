function InitializeWeaponPanel()
{
	GameUI.CustomUIConfig().weaponPanel = $.GetContextPanel()
	
	GameUI.CustomUIConfig().weaponPanel.container = $('#weapons_main_container')
	GameUI.CustomUIConfig().weaponPanel.weaponCurrentLevel = $('#weapon_current_level_value')
	GameUI.CustomUIConfig().weaponPanel.weaponMaxLevel = $('#weapon_max_level_value')
	GameUI.CustomUIConfig().weaponPanel.expLabel = $('#weapon_exp_label')
	GameUI.CustomUIConfig().weaponPanel.progressBar = $('#weapon_exp_bar_progress')



	// $('#weapon_exp_bar_progress').style.width = "50%"

	$('#weapon_current_level').text = $.Localize('#weapon_current_level')+":"
	$('#weapon_max_level').text = $.Localize('#weapon_max_level')+":"
	$('#weapon_exp_label').text = "0/0"

	$.GetContextPanel().style.visibility = "collapse"
	$('#weapons_main_container').style.visibility = "collapse"
}

(function()
{
	InitializeWeaponPanel();
	// InitializeBlacksmith();
	// // GameEvents.Subscribe( "WeaponLevelup", OpenShop );
	// GameEvents.Subscribe( "WeaponXPGain", InitializeWeaponPanel );
	// GameEvents.Subscribe( "WeaponLvlup", weaponLvlUp );
	// GameEvents.Subscribe( "OpenBlacksmith", OpenBlacksmith );
	// GameEvents.Subscribe( "weapon_fade_in", weaponFadeIn );
	// GameEvents.Subscribe( "weapon_fade_out", weaponFadeOut );
})();
