"use strict";

var r_Ability = -1;
var r_QueryUnit = -1;
var r_bInLevelUp = false;
var r_mainHero = -1


function SetAbility( ability, queryUnit, bInLevelUp, mainHero)
{
	var bChanged = ( ability !== r_Ability || queryUnit !== r_QueryUnit );
	bInLevelUp = false;
	r_Ability = ability;
	r_QueryUnit = queryUnit;
	r_mainHero = mainHero;

	var playerID = Game.GetLocalPlayerID();
	playerID = getControllingPlayerIndex();
	var player_stats = CustomNetTables.GetTableValue( "player_stats", playerID.toString() );
	var runePoints = player_stats.runePoints
	if (runePoints > 0){
		bInLevelUp = true;
	}
	
	var canUpgradeRet = Abilities.CanAbilityBeUpgraded( r_Ability );
	var canUpgrade = ( canUpgradeRet == AbilityLearnResult_t.ABILITY_CAN_BE_UPGRADED );
	
	$.GetContextPanel().SetHasClass( "no_ability", ( ability == -1 ) );
	$.GetContextPanel().SetHasClass( "learnable_ability", bInLevelUp && canUpgrade );
	RebuildAbilityUI();
	UpdateRune();
}

function AutoUpdateRunes()
{
	UpdateRune();
	// $.Schedule( 1, AutoUpdateRunes );
}

function GetRuneBonus(mainHero, rune_slot)
{
	var total_bonus = 0;
	var values = CustomNetTables.GetTableValue( "skill_tree", mainHero.toString()+"_"+rune_slot+"_amulet" );
	if (values === undefined){
	total_bonus = total_bonus;
	}else{
	total_bonus = total_bonus + parseInt(values.bonus);
	}
	values = CustomNetTables.GetTableValue( "skill_tree", mainHero.toString()+"_"+rune_slot+"_hand" );
	if (values === undefined){
	total_bonus = total_bonus;
	}else{
	total_bonus = total_bonus + parseInt(values.bonus);
	}
	values = CustomNetTables.GetTableValue( "skill_tree", mainHero.toString()+"_"+rune_slot+"_body" );
	if (values === undefined){
	total_bonus = total_bonus;
	}else{
	total_bonus = total_bonus + parseInt(values.bonus);
	}
	values = CustomNetTables.GetTableValue( "skill_tree", mainHero.toString()+"_"+rune_slot+"_head" );
	if (values === undefined){
	total_bonus = total_bonus;
	}else{
	total_bonus = total_bonus + parseInt(values.bonus);
	}
	values = CustomNetTables.GetTableValue( "skill_tree", mainHero.toString()+"_"+rune_slot+"_weapon" );
	if (values === undefined){
	total_bonus = total_bonus;
	}else{
	total_bonus = total_bonus + parseInt(values.bonus);
	}
	values = CustomNetTables.GetTableValue( "skill_tree", mainHero.toString()+"_"+rune_slot+"_foot" );
	if (values === undefined){
	total_bonus = total_bonus;
	}else{
	total_bonus = total_bonus + parseInt(values.bonus);
	}
	return total_bonus
}

function getSelectedHeroIndex()
{
	if (Players.IsSpectator( Game.GetLocalPlayerID() )){
		return -1
	}
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	if (Entities.IsHero(queryUnit)){
		return queryUnit
	}else{
		return Players.GetPlayerSelectedHero( Game.GetLocalPlayerID() )
	}

}

function GetRuneSlot(abilityName){
	if (abilityName.indexOf("rune_a_a") > -1){
		return "rune_a_a"
	}else if (abilityName.indexOf("rune_a_b") > -1){
		return "rune_a_b"
	}else if (abilityName.indexOf("rune_a_c") > -1){
		return "rune_a_c"
	}else if (abilityName.indexOf("rune_a_d") > -1){
		return "rune_a_d"
	}else if (abilityName.indexOf("rune_b_a") > -1){
		return "rune_b_a"
	}else if (abilityName.indexOf("rune_b_b") > -1){
		return "rune_b_b"
	}else if (abilityName.indexOf("rune_b_c") > -1){
		return "rune_b_c"
	}else if (abilityName.indexOf("rune_b_d") > -1){
		return "rune_b_d"
	}else if (abilityName.indexOf("rune_c_a") > -1){
		return "rune_c_a"
	}else if (abilityName.indexOf("rune_c_b") > -1){
		return "rune_c_b"
	}else if (abilityName.indexOf("rune_c_c") > -1){
		return "rune_c_c"
	}else if (abilityName.indexOf("rune_c_d") > -1){
		return "rune_c_d"
	}else if (abilityName.indexOf("rune_d_a") > -1){
		return "rune_d_a"
	}else if (abilityName.indexOf("rune_d_b") > -1){
		return "rune_d_b"
	}else if (abilityName.indexOf("rune_d_c") > -1){
		return "rune_d_c"
	}else if (abilityName.indexOf("rune_d_d") > -1){
		return "rune_d_d"
	}else{
		return ""
	}
}

function UpdateRune()
{
	var abilityButton = $( "#AbilityButton" );
	var abilityName = Abilities.GetAbilityName( r_Ability );

	var noLevel =( 0 == Abilities.GetLevel( r_Ability ) );
	var isCastable = !Abilities.IsPassive( r_Ability ) && !noLevel;
	var manaCost = Abilities.GetManaCost( r_Ability );

	var unitMana = Entities.GetMana( r_QueryUnit );
	var runeIndex = $.GetContextPanel().GetAttributeInt( "index", -1 );
	var runeTier = $.GetContextPanel().GetAttributeInt( "tier", -1 );
	var mainHero = r_mainHero
	var baseSkill = Entities.GetAbility( mainHero, runeIndex )
	var baseSkillLevel = Abilities.GetLevel( baseSkill )
	//$.Msg("baseSkillLevel ="+baseSkillLevel+", runeTier ="+runeTier)
	if (baseSkillLevel < runeTier){
		$.GetContextPanel().SetHasClass( "no_level", true );
		$.GetContextPanel().SetAttributeInt( "no_level", 1 );
	}else{
		$.GetContextPanel().SetHasClass( "no_level", false );
		$.GetContextPanel().SetAttributeInt( "no_level", 0 );
	}
	//$.GetContextPanel().SetHasClass( "is_passive", Abilities.IsPassive(r_Ability) );
	$.GetContextPanel().SetHasClass( "no_mana_cost", ( true ) );
	//$.GetContextPanel().SetHasClass( "insufficient_mana", ( manaCost > unitMana ) );
	//$.GetContextPanel().SetHasClass( "auto_cast_enabled", Abilities.GetAutoCastState(r_Ability) );
	//$.GetContextPanel().SetHasClass( "toggle_enabled", Abilities.GetToggleState(r_Ability) );
	//$.GetContextPanel().SetHasClass( "is_active", ( r_Ability == Abilities.GetLocalPlayerActiveAbility() ) );

	// if base skill level is high enough, enable button
	abilityButton.enabled = ( true );
	
	//$( "#HotkeyText" ).text = runeTier;
	// $.Msg("RUNEBONUS HERO: "+mainHero)
	var RuneBonus = GetRuneBonus(mainHero, GetRuneSlot(abilityName))
	var AbilityLevel = Abilities.GetLevel( r_Ability )
	// $.Msg("RUNEBONUS: "+RuneBonus)
	if (RuneBonus == 0){
		$( "#LevelText" ).text = AbilityLevel;
	}else{
		$( "#LevelText" ).text = "<font color='#7DFF12'>"+parseInt(AbilityLevel+RuneBonus)+"</font>";
	}
	
	$( "#AbilityImage" ).abilityname = abilityName;
	$( "#AbilityImage" ).contextEntityIndex = r_Ability;
	
	$( "#ManaCost" ).text = manaCost;
	
	if ( Abilities.IsCooldownReady( r_Ability ) )
	{
		$.GetContextPanel().SetHasClass( "cooldown_ready", true );
		$.GetContextPanel().SetHasClass( "in_cooldown", false );
	}
	else
	{
		$.GetContextPanel().SetHasClass( "cooldown_ready", false );
		$.GetContextPanel().SetHasClass( "in_cooldown", true );
		var cooldownLength = Abilities.GetCooldownLength( r_Ability );
		var cooldownRemaining = Abilities.GetCooldownTimeRemaining( r_Ability );
		var cooldownPercent = Math.ceil( 100 * cooldownRemaining / cooldownLength );
		$( "#CooldownTimer" ).text = Math.ceil( cooldownRemaining );
		$( "#CooldownOverlay" ).style.width = cooldownPercent+"%";
	}
	
}

function getPosition(str, m, i) {
   return str.split(m, i).join(m).length;
}

function AbilityShowTooltip()
{
	//var abilityButton = $( "#AbilityButton" );
	var abilityName = Abilities.GetAbilityName( r_Ability );
	// If you don't have an entity, you can still show a tooltip that doesn't account for the entity
	//$.DispatchEvent( "DOTAShowAbilityTooltip", abilityButton, abilityName );

	// If you have an entity index, this will let the tooltip show the correct level / upgrade information
	//$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", abilityButton, abilityName, r_QueryUnit );
	//$.DispatchEvent("DOTAShowTitleTextTooltip", $.GetContextPanel(), "Update Info", "Upgrades");
	var baseLevel = Abilities.GetLevel(r_Ability)
	var RuneBonus = GetRuneBonus(r_mainHero, GetRuneSlot(abilityName))
	var abilityLevel = Abilities.GetLevel(r_Ability) + RuneBonus
	
	var amount_per_level = Abilities.GetLevelSpecialValueFor( r_Ability, "property_one", 1)
	amount_per_level = Math.round(amount_per_level * 100) / 100
	var abilityTitle = $.Localize( "#DOTA_Tooltip_ability_"+abilityName)
	var raw_description = $.Localize( "#DOTA_Tooltip_ability_"+abilityName+"_Description")
	raw_description = raw_description.replace(",", " -");
	var spacePosition10 = getPosition(raw_description, " ", 12)
	var brIndex = raw_description.substring(0, spacePosition10).length
	var br = "<br>"
	var br2 = "<br>"
	if (brIndex == raw_description.length){
		br = ""
	}
	var abilityInfo = addAbilityInfoToTooltip(r_Ability, r_mainHero)
	// raw_description = breakUpTooltip(raw_description)
	var description = "<font color='#CCFF66'>"+raw_description+"</font>"
	// var attribute_scaler = attribute_scale(r_Ability)
	var scale = 0
	// if (attribute_scaler!=null){
	// 	description = description + attribute_scaler[0]
	// 	scale = attribute_scaler[1]
	// }
	var property_one_base = Abilities.GetLevelSpecialValueFor( r_Ability, "property_one_base", 1)
	property_one_base = Math.round(property_one_base * 100) / 100
	var level_line = "Level: "+abilityLevel+"<br>"
	if (abilityLevel == 0){
		property_one_base = 0
	}
	var property_one_max = Abilities.GetLevelSpecialValueFor( r_Ability, "property_one_max", 1)
	var property_two_max = Abilities.GetLevelSpecialValueFor( r_Ability, "property_two_max", 1)
	var propertyValue = amount_per_level*abilityLevel+property_one_base
	if (property_one_max > 0){
		if ((amount_per_level*abilityLevel+property_one_base) > property_one_max){
			propertyValue = property_one_max
		}
	}
	propertyValue = Math.round(propertyValue * 100) / 100
	var firstProperty = buildPropertyLine(abilityName, propertyValue, "Current:", scale)
	var property_one_base = Abilities.GetLevelSpecialValueFor( r_Ability, "property_one_base", 1)
	propertyValue = amount_per_level*(abilityLevel+1)+property_one_base
	if (property_one_max > 0){
		if ((propertyValue) > property_one_max){
			propertyValue = property_one_max
		}
	}	
	propertyValue = Math.round(propertyValue * 100) / 100
	var secondProperty = buildPropertyLine(abilityName, propertyValue, "Next Level:", scale)
	if (abilityLevel == 20){
		secondProperty = ""
	}
	var amount_per_level2 = Abilities.GetLevelSpecialValueFor( r_Ability, "property_two", 1)
	amount_per_level2 = Math.round(amount_per_level2 * 100) / 100
	if (amount_per_level2!=0){
		var property_two_base = Abilities.GetLevelSpecialValueFor( r_Ability, "property_two_base", 1)
		property_two_base = Math.round(property_two_base * 100) / 100
		if (abilityLevel == 0){
			property_two_base = 0
		}
		var property_two_current = amount_per_level2*abilityLevel+property_two_base
		var property_two_next = amount_per_level2*(abilityLevel+1)+property_two_base
		if (property_two_max > 0){
			if (property_two_current > property_two_max){
				property_two_current = property_two_max
			}
			if (property_two_next > property_two_max){
				property_two_next = property_two_max
			}
		}
		var secondFirstProperty = buildSecondProperty(abilityName, property_two_current, scale)
		property_two_base = Abilities.GetLevelSpecialValueFor( r_Ability, "property_two_base", 1)
		var secondSecondProperty = buildSecondProperty(abilityName, property_two_next, scale)
		if (abilityLevel == 20){
			secondSecondProperty = ""
		}
		var tooltip = level_line+abilityInfo+description+""+firstProperty+secondFirstProperty+secondProperty+secondSecondProperty
	}else{
		var tooltip = level_line+abilityInfo+description+""+firstProperty+secondProperty
	}
	abilityTitle = abilityTitle.replace("'", "’")
	tooltip = tooltip.replace(/(['"])/g, "\\$1")
	$.DispatchEvent("DOTAShowTitleTextTooltip", $.GetContextPanel(), abilityTitle, tooltip);

}

function breakUpTooltip(specialText){
	var spacePosition10 = getPosition(specialText, " ", 10)
	var spacePosition20 = getPosition(specialText, " ", 20)
	var spacePosition30 = getPosition(specialText, " ", 30)
	var brIndex = specialText.substring(0, spacePosition10).length
	var br = "<br>"
	var br2 = "<br>"
	var br3 = "<br>"
	if (spacePosition10 >= specialText.length){
		br = ""
	}
	brIndex = specialText.substring(0, spacePosition20).length
	if (spacePosition20 >= specialText.length){
		br2 = ""
	}
	brIndex = specialText.substring(0, spacePosition30).length
	if (spacePosition30 >= specialText.length){
		br3 = ""
	}
	specialText= specialText.substring(0, spacePosition10) + br + specialText.substring(spacePosition10+1, spacePosition20) + br2 + specialText.substring(spacePosition20+1, spacePosition30) + br3 + specialText.substring(spacePosition30+1, specialText.length)
	return specialText
}

function attribute_scale(r_Ability)
{
	var scaling = Abilities.GetLevelSpecialValueFor( r_Ability, "strength_multiplier", 1)
	var mainHero = $.GetContextPanel().GetAttributeInt( "mainHero", -1 );
	//$.Msg("scaling: "+scaling)
	if (scaling!=0){
		mainHero
		var string = "<br>Strength Multiplier: "+scaling
		return [string, scaling]
	}else{
		return null
	}
	
}

function buildSecondProperty(abilityName, amount_this_level, attribute_scale)
{
	if (attribute_scale == 0){
		attribute_scale = 1
	}	
	var propertyOne = $.Localize( "#DOTA_Tooltip_ability_"+abilityName+"_property_two")
	if (propertyOne!=null){
		var suffix = $.Localize( "#DOTA_Tooltip_ability_"+abilityName+"_suffix_two")
		var firstLine = "<br><font color='white'>"+propertyOne + ": </font><font color='yellow'>"+(amount_this_level*attribute_scale)+suffix+"</font>"
		return firstLine;
	}else{
		return null
	}
}

function buildPropertyLine(abilityName, amount_this_level, lineTitle, attribute_scale)
{
	if (attribute_scale == 0){
		attribute_scale = 1
	}
	var propertyOne = $.Localize( "#DOTA_Tooltip_ability_"+abilityName+"_property_one")
	var suffix = $.Localize( "#DOTA_Tooltip_ability_"+abilityName+"_suffix")
	var firstLineTitle = "<i><font color='#94B8FF'>"+lineTitle+"</font></i><br>"
	var firstLine = "<br>"+firstLineTitle+"<font color='white'>"+propertyOne + ": </font><font color='yellow'>"+(amount_this_level*attribute_scale)+suffix+"</font>"
	return firstLine;
}

function addAbilityInfoToTooltip(ability, mainHero)
{
	var damageType = Abilities.GetAbilityDamageType( ability )
	var tooltip = ""
	var baseAbilityIndex = Abilities.GetLevelSpecialValueFor( ability, "base_ability", 1)
	var element1 = Abilities.GetLevelSpecialValueFor( ability, "element_one", 1)
	var element2 = Abilities.GetLevelSpecialValueFor( ability, "element_two", 1)
	if (baseAbilityIndex > 0){
		$.Msg("IN BLOCK!")
		var baseAbility = Entities.GetAbility( mainHero, baseAbilityIndex-1 )
		var baseAbilityText = $.Localize("#tooltip_rune_base_ability")+": "
		var baseAbilityName = $.Localize("#DOTA_Tooltip_ability_"+Abilities.GetAbilityName( baseAbility ))
		tooltip = tooltip+"<font color='#7AB4CC'>"+baseAbilityText+"</font><font color='#FFFFFF'>"+baseAbilityName+"</font><br>"
	}
	$.Msg(baseAbilityIndex)
		// 
	if (damageType == DAMAGE_TYPES.DAMAGE_TYPE_MAGICAL){
		var damage_type_text = $.Localize("#tooltip_damage_type")+": "
		var damage_type_main_text = $.Localize("#DOTA_ToolTip_Damage_Magical")
		tooltip = tooltip+"<font color='#FF8A8A'>"+damage_type_text+"</font><font color='#7083FF'>"+damage_type_main_text+"</font><br>"
	}else if (damageType == DAMAGE_TYPES.DAMAGE_TYPE_PHYSICAL){
		var damage_type_text = $.Localize("#tooltip_damage_type")+": "
		var damage_type_main_text = $.Localize("#DOTA_ToolTip_Damage_Physical")
		$.Msg("PHYS")
		tooltip = tooltip+"<font color='#FF8A8A'>"+damage_type_text+"</font><font color='#FF7070'>"+damage_type_main_text+"</font><br>"
	}else if (damageType == DAMAGE_TYPES.DAMAGE_TYPE_PURE){
		var damage_type_text = $.Localize("#tooltip_damage_type")+": "
		var damage_type_main_text = $.Localize("#DOTA_ToolTip_Damage_Pure")
		tooltip = tooltip+"<font color='#FF8A8A'>"+damage_type_text+"</font><font color='#FFFFFF'>"+damage_type_main_text+"</font><br>"
	}

	if (element1 > 0){
		var element_text = $.Localize('#tooltip_element').toUpperCase()+": "
		var element_main_text = $.Localize('#rpc_element'+element1)
		var elementColor = GetElementColor(element1)
		if (element2 > 0){
			var element_main_text2 = $.Localize('#rpc_element'+element2)
			var elementColor2 = GetElementColor(element2)
			tooltip = tooltip+"<font color='#DDDDDD'>"+element_text+"</font><font color='"+elementColor+"'>"+element_main_text+"</font> / <font color='"+elementColor2+"'>"+element_main_text2+"</font><br>"
		}else{
			tooltip = tooltip+"<font color='#DDDDDD'>"+element_text+"</font><font color='"+elementColor+"'>"+element_main_text+"</font><br>"
		}
	}
	return tooltip
}

function GetElementColor(element_index){
	var color = "#FFFFFF"
	if (element_index == 1){
		color = "#DDDDDD"
	}else if(element_index == 2){
		color = "#EF4126"
	}else if(element_index == 3){
		color = "#AF843D"
	}else if(element_index == 4){
		color = "#5CCDF9"
	}else if(element_index == 5){
		color = "#37DD3D"
	}else if(element_index == 6){
		color = "#B5FFB7"
	}else if(element_index == 7){
		color = "#F6FFB5"
	}else if(element_index == 8){
		color = "#C25DFC"
	}else if(element_index == 9){
		color = "#87D9FF"
	}else if(element_index == 10){
		color = "#E1A2E8"
	}else if(element_index == 11){
		color = "#7F4F84"
	}else if(element_index == 12){
		color = "#7AE2A7"
	}else if(element_index == 13){
		color = "#9ACCD1"
	}else if(element_index == 14){
		color = "#3894FF"
	}else if(element_index == 15){
		color = "#5B648C"
	}else if(element_index == 16){
		color = "#69BC71"
	}else if(element_index == 17){
		color = "#5C776E"
	}
	return color
}

function AbilityHideTooltip()
{
	//var abilityButton = $( "#AbilityButton" );
	//$.DispatchEvent( "DOTAHideAbilityTooltip", abilityButton );
	$.DispatchEvent( "DOTAHideTitleTextTooltip", $.GetContextPanel() );
	//$.DispatchEvent("DOTAHideTitleTextTooltip", $.GetContextPanel(), title, tooltip);
}

function ActivateRune()
{

	var localPlayer = Game.GetLocalPlayerID();
	if(localPlayer == getControllingPlayerIndex())
	{
		//$.Msg('activateRune')
		if ($.GetContextPanel().GetAttributeInt("no_level", -1) == 1){
			Game.EmitSound( "General.Cancel" )
		}else{
			var playerID = localPlayer;
			GameEvents.SendCustomGameEventToServer( "level_up_rune", {ability: r_Ability, playerID: playerID, unit: Players.GetLocalPlayerPortraitUnit()} );
			AbilityHideTooltip()
			$.Schedule(0.05, function(){
				AbilityShowTooltip()
			});
		}
		UpdateRune();
		return;
	}
	
	//Abilities.ExecuteAbility( r_Ability, r_QueryUnit, false );
}

function getControllingPlayerIndex()
{
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	var playerIndex = Players.GetLocalPlayer();
	if (Entities.IsHero(queryUnit)){
		playerIndex = CustomNetTables.GetTableValue( "hero_index", queryUnit.toString() ).playerOwner;
	}else{
		playerIndex = Players.GetLocalPlayer();
	}
	playerIndex = parseInt(playerIndex)
	if (!(Players.IsValidPlayerID(playerIndex))){
		playerIndex = Game.GetAllPlayerIDs()[0];
	}
	return parseInt(playerIndex)
}

function DoubleClickAbility()
{
	// Handle double-click like a normal click - ExecuteAbility will either double-tap (self cast) or normal toggle as appropriate
	//ActivateAbility();
}

function RightClickAbility()
{
	if ( r_bInLevelUp )
		return;

	if ( Abilities.IsAutocast( r_Ability ) )
	{
		Game.PrepareUnitOrders( { OrderType: dotaunitorder_t.DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO, AbilityIndex: r_Ability } );
	}
}

function RebuildAbilityUI()
{
	// var abilityLevelContainer = $( "#AbilityLevelContainer" );
	// abilityLevelContainer.RemoveAndDeleteChildren();
	// var currentLevel = Abilities.GetLevel( r_Ability );
	// for ( var lvl = 0; lvl < Abilities.GetMaxLevel( r_Ability ); lvl++ )
	// {
	// 	var levelPanel = $.CreatePanel( "Panel", abilityLevelContainer, "" );
	// 	levelPanel.AddClass( "LevelPanel" );
	// 	levelPanel.SetHasClass( "active_level", ( lvl < currentLevel ) );
	// 	levelPanel.SetHasClass( "next_level", ( lvl == currentLevel ) );
	// }
}

(function()
{
	$.GetContextPanel().SetAbility = SetAbility;
	GameEvents.Subscribe( "refresh_runes", UpdateRune );
	AutoUpdateRunes(); // initial update of dynamic state
})();
