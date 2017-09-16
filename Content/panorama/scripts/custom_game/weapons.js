function InitializeWeaponPanel(){
	$.Msg($('#weapon_lvlup'))
	if ($('#weapon_lvlup')!=null){
		var weaponTable = CustomNetTables.GetTableValue( "weapons",  Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()).toString() )
		var queryUnit = Players.GetLocalPlayerPortraitUnit();
		var playerWeaponID = Game.GetLocalPlayerID()
		var playerIDs = Game.GetAllPlayerIDs()
		for (i = 0; i < playerIDs.length; i++) {
			if (queryUnit == Players.GetPlayerHeroEntityIndex( playerIDs[i] )){
				playerWeaponID = playerIDs[i]
			}
		}
		var item = CustomNetTables.GetTableValue( "equipment",  playerWeaponID.toString()+"-1" )
		var itemEntIndex = item.itemIndex
		var itemBasics = CustomNetTables.GetTableValue( "item_basics", itemEntIndex.toString() )

		$('#weapon_title').text = itemBasics.itemName
		$('#weapon_lvlup_item').itemname = itemBasics.itemName;
		$('#weapon_lvlup_item').contextEntityIndex = itemEntIndex;

		$('#weapon_level').text = "LV "+weaponTable.level
		$("#weapon_lvl_message").text = ""
		$("#weapon_lvl_message2").text = ""
		if (weaponTable.upgradeStatus > 0){
			$("#weapon_upgrade_available").text = $.Localize("#weapon_upgrade_available")
			$("#weapon_tip").text = $.Localize("#weapon_lvl_tip")
			$('#weapon_lvlup').AddClass("blacksmith")
		}else{
			$("#weapon_upgrade_available").text = ""
			$("#weapon_tip").text = ""
			$('#weapon_lvlup').RemoveClass("blacksmith")
		}

		$("#weapon_xp_text").text = weaponTable.xp+"/"+weaponTable.xpNeeded

		$('#weapon_xp_bar').style.width = (weaponTable.xp/weaponTable.xpNeeded)*100+"%"

	}
}

function weaponFadeIn(bLvlup){
	InitializeWeaponPanel()
	if ($('#weapon_lvlup')!=null){
		if (bLvlup){
			Game.EmitSound("Conquest.capture_point_timer")
			Game.EmitSound("Conquest.capture_point_timer")
			$("#weapon_lvl_message").text = $.Localize("#weapon_lvl_message")
			$("#weapon_lvl_message2").text = $.Localize("#weapon_lvl_message_two")
		}
		$('#weapon_lvlup').RemoveClass("invisible")
		$('#weapon_lvlup').RemoveClass("animateEaseOutClass")
		$('#weapon_lvlup').AddClass("animateEaseClass")
	}
}

function weaponFadeOut(){
	if ($('#weapon_lvlup')!=null){
		$('#weapon_lvlup').RemoveClass("animateEaseClass")
		// $('#weapon_lvlup').AddClass("animateEaseOutClass")
		$('#weapon_lvlup').AddClass("invisible")
		// $.Schedule(0.45, function(){		
		// 	$('#weapon_lvlup').AddClass("invisible")
		// });		
	}
}

function weaponLvlUp(){
	weaponFadeIn(true)
	$.Schedule(6, function(){		
		weaponFadeOut()
	});			
}

function InitializeBlacksmith(){
	if ($('#blacksmith_panel') !=null){
		$('#blacksmith_title_text').text= $.Localize("#blacksmith_title")
		var weaponTable = CustomNetTables.GetTableValue( "weapons",  Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()).toString() )
		var item = CustomNetTables.GetTableValue( "equipment",  Game.GetLocalPlayerID().toString()+"-1" )
		var itemEntIndex = item.itemIndex
		var itemBasics = CustomNetTables.GetTableValue( "item_basics", itemEntIndex.toString() )
		$("#weapon_name_blacksmith").text = itemBasics.itemName
		$('#WeaponImage').contextEntityIndex = itemEntIndex;
		$('#weapon_lvl_blacksmith').text = "LV "+weaponTable.level
		populateBlacksmithProperties(itemEntIndex)
		if (weaponTable.upgradeStatus > 0){
			$('#weapon_upgrade_tip').text = $.Localize("#weapon_upgrade_tip_available")
			$('#weapon_upgrade_tip_two').text = $.Localize("#weapon_upgrade_tip_two")
			var hero = Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID())
			$("#weapon_upgrade_phase"+getUpgradePanelIndex(weaponTable.upgradeIndex)).RemoveClass("invisible")
			
			var imagePanelCodeArray = ["01", "02", "03", "11", "12", "13", "14", "21", "22", "23", "24", "25"]
			for (i = 0; i < imagePanelCodeArray.length; i++) {
				$("#upgrade_image_"+imagePanelCodeArray[i]).SetImage(getWeaponImage(hero, imagePanelCodeArray[i]))
				if ($("#upgrade_image_"+imagePanelCodeArray[i]+"2") !=null){
					$("#upgrade_image_"+imagePanelCodeArray[i]+"2").SetImage(getWeaponImage(hero, imagePanelCodeArray[i]))
				}
			}
		}else{
			if (weaponTable.phase == 3){
				$('#weapon_upgrade_tip').text = $.Localize("#weapon_maxed_tip")
			}else{
				$('#weapon_upgrade_tip').text = $.Localize("#weapon_upgrade_tip")
			}
			$('#weapon_upgrade_tip_two').text = ""
		}
	}
}

function populateBlacksmithProperties(item){
	var itemValues = CustomNetTables.GetTableValue( "item_basics", item.toString() );
	var itemProperty1 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-1" );
	populateBlacksmithProperty(itemProperty1, $('#weapon_property1name'), $('#weapon_property1value'));
	if (itemValues.rarityFactor >= 2 )
	{
		var itemProperty2 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-2" );
		populateBlacksmithProperty(itemProperty2, $('#weapon_property2name'), $('#weapon_property2value'));
	}
	if (itemValues.rarityFactor >= 3 )
	{
		var itemProperty3 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-3" );
		populateBlacksmithProperty(itemProperty3, $('#weapon_property3name'), $('#weapon_property3value'));
	}
	if (itemValues.rarityFactor >= 4 )
	{
		var itemProperty4 = CustomNetTables.GetTableValue( "item_properties", item.toString()+"-4" );
		populateBlacksmithProperty(itemProperty4, $('#weapon_property4name'), $('#weapon_property4value'));
	}
	var itemPrefix = ""
	var itemSuffix = ""
	//$.Msg( itemValues.property1 );
	//$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", $.GetContextPanel(), itemName, queryUnit );
	var title = "<font color='"+itemValues.qualityColor+"'>"+itemPrefix+" "+itemValues.itemName+" "+itemSuffix+"</font>"
	$("#weapon_name_blacksmith").text = title;
}


function populateBlacksmithProperty(property, panelDescription, panelValue){
	// property = itemPropertyCheck(property)
	var text = "<font color='"+property.propertyColor+"'>"+$.Localize(property.propertyName)+"</font>"
	var propertyValue = property.propertyValue
	panelDescription.text = text;
	panelValue.text = propertyValue;
	panelDescription.RemoveClass('invisible')
	panelValue.RemoveClass('invisible')
}

function CloseBlacksmith(){
	$("#blacksmith_panel").RemoveClass('animateEaseOutClass');
	$("#blacksmith_panel").AddClass('animateEaseOutClass')
        $.Schedule(0.45, function(){
        	$("#blacksmith_panel").AddClass('invisible');
        	$("#blacksmith_panel").SetAttributeInt('isCollapsed', 1)
        });		
}

function OpenBlacksmith(){
	if ($('#blacksmith_panel') !=null){
		if($("#blacksmith_panel").GetAttributeInt('isCollapsed', 1) == 1){
			InitializeBlacksmith()
			$("#blacksmith_panel").RemoveClass('animateEaseOutClass');
			$("#blacksmith_panel").AddClass('animateEaseClass');
			$("#blacksmith_panel").RemoveClass('invisible');
		        $.Schedule(0.45, function(){
		        	$("#blacksmith_panel").SetAttributeInt('isCollapsed', 0)
		        	$("#blacksmith_panel").RemoveClass('animateEaseClass');
		        });	
	    }
    }	
}

function select_upgrade(index){
	var id = Players.GetLocalPlayer();
	var hero =  Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID())
	var weaponArray = getWeaponIndex(hero, index)
	var propertyCode = weaponArray[0]
	var weaponName = weaponArray[1]
	var value = weaponArray[2]
	var itemVariant = weaponArray[3]

	var propertyArray = convertPropertyToNameAndColor(propertyCode)
	var propertyTitle = propertyArray[0]
	var propertyColor = propertyArray[1] 
	GameEvents.SendCustomGameEventToServer( "weapon_upgrade", {hero: hero, index: index, propertyCode: propertyCode, weaponName: weaponName, value: value, propertyTitle: propertyTitle, propertyColor: propertyColor, itemVariant: itemVariant} );
	$("#weapon_upgrade_phase1").AddClass("invisible")
	$("#weapon_upgrade_phase21").AddClass("invisible")
	$("#weapon_upgrade_phase22").AddClass("invisible")
	$("#weapon_upgrade_phase23").AddClass("invisible")
	$("#weapon_upgrade_phase31").AddClass("invisible")
	$("#weapon_upgrade_phase32").AddClass("invisible")
	$("#weapon_upgrade_phase33").AddClass("invisible")
	$("#weapon_upgrade_phase34").AddClass("invisible")
	CloseBlacksmith()

	$.Msg("Upgrade Selected")
}

function ShowUpgradeTooltip(index){
	var queryUnit = Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID())
	var weaponArray = getWeaponIndex(queryUnit, index)
	var propertyArray = convertPropertyToNameAndColor(weaponArray[0])
	var title = $.Localize(propertyArray[0])
	if (title.indexOf("rune_") > -1){
		title = runeTranslate(queryUnit, title)
	}
	var titleColor = propertyArray[1]
	var tooltip = $.Localize(propertyArray[2])
	tooltip=tooltip+"<br>Value: <font color='yellow'>"+weaponArray[2]+"</font>"
	title = "<font color='"+titleColor+"'>"+title
	title = title.replace(/(['"])/g, "\\$1");
	tooltip = tooltip.replace(/(['"])/g, "\\$1");
	$.DispatchEvent("DOTAShowTitleTextTooltip", $.GetContextPanel(), title, tooltip);
}

function HideUpgradeTooltip(index){
	$.DispatchEvent( "DOTAHideTitleTextTooltip", $.GetContextPanel() );
}

function getWeaponImage(queryUnit, index){
	var heroName = Entities.GetClassname(queryUnit)
	var skillName = "error"
	var weaponPath = "error"
	if (heroName == "npc_dota_hero_dragon_knight"){
		weaponPath = "file://{images}/items/weapons/flamewaker/flamewaker_sword_"+index+".png"
	}else if (heroName == "npc_dota_hero_phantom_assassin"){
		weaponPath = "file://{images}/items/weapons/voltex/voltex_weapon_"+index+".png"
	}else if (heroName == "npc_dota_hero_necrolyte"){
		weaponPath = "file://{images}/items/weapons/venomort/venomort_weapon_"+index+".png"
	}else if (heroName == "npc_dota_hero_axe"){
		weaponPath = "file://{images}/items/weapons/axe/axe_weapon_"+index+".png"
	}else if (heroName == "npc_dota_hero_drow_ranger"){
		weaponPath = "file://{images}/items/weapons/astral/astral_weapon_"+index+".png"
	}else if (heroName == "npc_dota_hero_obsidian_destroyer"){
		weaponPath = "file://{images}/items/weapons/epoch/epoch_weapon_"+index+".png"
	}else if (heroName == "npc_dota_hero_omniknight"){
		weaponPath = "file://{images}/items/weapons/paladin/paladin_weapon_"+index+".png"
	}else if (heroName == "npc_dota_hero_crystal_maiden"){
		weaponPath = "file://{images}/items/weapons/sorceress/sorceress_weapon_"+index+".png"
	}else if (heroName == "npc_dota_hero_invoker"){
		weaponPath = "file://{images}/items/weapons/conjuror/conjuror_weapon_"+index+".png"
	}else if (heroName == "npc_dota_hero_juggernaut"){
		weaponPath = "file://{images}/items/weapons/seinaru/seinaru_weapon_"+index+".png"
	}else if (heroName == "npc_dota_hero_beastmaster"){
		weaponPath = "file://{images}/items/weapons/warlord/warlord_weapon_"+index+".png"
	}else if (heroName == "npc_dota_hero_leshrac"){
		weaponPath = "file://{images}/items/weapons/bahamut/bahamut_weapon_"+index+".png"
	}
	return weaponPath
}


(function()
{
	InitializeWeaponPanel();
	InitializeBlacksmith();
	// GameEvents.Subscribe( "WeaponLevelup", OpenShop );
	GameEvents.Subscribe( "WeaponXPGain", InitializeWeaponPanel );
	GameEvents.Subscribe( "WeaponLvlup", weaponLvlUp );
	GameEvents.Subscribe( "OpenBlacksmith", OpenBlacksmith );
	GameEvents.Subscribe( "weapon_fade_in", weaponFadeIn );
	GameEvents.Subscribe( "weapon_fade_out", weaponFadeOut );
})();
