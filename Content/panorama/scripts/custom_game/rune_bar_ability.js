"use strict";

var r_Ability = -1;
var r_QueryUnit = -1;
var r_bInLevelUp = false;
var r_mainHero = -1
var r_BaseRuneLevel = 0
var x = null

var COST_LEVEL_UP_RUNES = [1,1,2,4]
var MAX_RUNE_LEVELS = [40, 40, 20, 10]

function SetAbility( ability, queryUnit, bInLevelUp, mainHero, ability_level)
{
	var bChanged = ( ability !== r_Ability || queryUnit !== r_QueryUnit );
	bInLevelUp = false;
	r_Ability = ability;
	r_QueryUnit = queryUnit;
	r_mainHero = mainHero;
	r_BaseRuneLevel = ability_level;
	$.Msg("SET BASE LEVEL: "+r_BaseRuneLevel)

	var playerID = Game.GetLocalPlayerID();
	playerID = getControllingPlayerIndex();
	var player_stats = CustomNetTables.GetTableValue( "player_stats", playerID.toString() );
	var runePoints = player_stats.runePoints
	var tier = $.GetContextPanel().GetAttributeInt( "tier", 0)
	if ((runePoints >= COST_LEVEL_UP_RUNES[tier-1]) && (ability_level < MAX_RUNE_LEVELS[tier-1])){
		bInLevelUp = true;
	}
	
	var canUpgradeRet = Abilities.CanAbilityBeUpgraded( r_Ability );
	var canUpgrade = ( canUpgradeRet == AbilityLearnResult_t.ABILITY_CAN_BE_UPGRADED );
	
	$.GetContextPanel().SetHasClass( "no_ability", ( ability == -1 ) );
	$.GetContextPanel().SetHasClass( "learnable_ability", bInLevelUp && canUpgrade );
	UpdateRune();
}

function AutoUpdateRunes()
{
	UpdateRune();
	// $.Schedule( 1, AutoUpdateRunes );
}

function GetRuneBonus(mainHero, rune_slot)
{
    $.Msg("RuneSlot: " + rune_slot)
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
	if (abilityName.indexOf("rune_q_1") > -1){
		return "rune_q_1"
	}else if (abilityName.indexOf("rune_w_1") > -1){
		return "rune_w_1"
	}else if (abilityName.indexOf("rune_e_1") > -1){
		return "rune_e_1"
	}else if (abilityName.indexOf("rune_r_1") > -1){
		return "rune_r_1"
	}else if (abilityName.indexOf("rune_q_2") > -1){
		return "rune_q_2"
	}else if (abilityName.indexOf("rune_w_2") > -1){
		return "rune_w_2"
	}else if (abilityName.indexOf("rune_e_2") > -1){
		return "rune_e_2"
	}else if (abilityName.indexOf("rune_r_2") > -1){
		return "rune_r_2"
	}else if (abilityName.indexOf("rune_q_3") > -1){
		return "rune_q_3"
	}else if (abilityName.indexOf("rune_w_3") > -1){
		return "rune_w_3"
	}else if (abilityName.indexOf("rune_e_3") > -1){
		return "rune_e_3"
	}else if (abilityName.indexOf("rune_r_3") > -1){
		return "rune_r_3"
	}else if (abilityName.indexOf("rune_q_4") > -1){
		return "rune_q_4"
	}else if (abilityName.indexOf("rune_w_4") > -1){
		return "rune_w_4"
	}else if (abilityName.indexOf("rune_e_4") > -1){
		return "rune_e_4"
	}else if (abilityName.indexOf("rune_r_4") > -1){
		return "rune_r_4"
	}else{
		return ""
	}
}

// function getRuneAbilitySlotFromName(abilityName){
// 	var return_letter = ""
// 	if (abilityName.indexOf("_q_") >= 1 || abilityName.indexOf("q_2") >= 1 || abilityName.indexOf("q_3") >= 1 || abilityName.indexOf("q_4") >= 1 ){
// 		return_letter = "q"
// 	}else if (abilityName.indexOf("w_1") >= 1 || abilityName.indexOf("w_2") >= 1 || abilityName.indexOf("w_3") >= 1 || abilityName.indexOf("w_4") >= 1 ){
// 		index = 1
// 	}else if (abilityName.indexOf("e_1") >= 1 || abilityName.indexOf("e_2") >= 1 || abilityName.indexOf("e_3") >= 1 || abilityName.indexOf("e_4") >= 1 ){
// 		index = 2
// 	}
// 	return index
// }

// function getRuneLevelFromModifiers(caster, ability){
// 	var number_of_buffs = Entities.GetNumBuffs( caster )
// 	var abilityName = Abilities.GetAbilityName(ability);
// 	for (i = 0; i < number_of_buffs; i++) {
// 	  var buff = Entities.GetBuff( queryUnit, i)
// 	  var buffName = Buffs.GetName( queryUnit, buff )	
// }

function UpdateRune()
{
	var abilityButton = $( "#AbilityButton" );
    var abilityName = Abilities.GetAbilityName(r_Ability);

	var noLevel =( 0 == Abilities.GetLevel( r_Ability ) );
	var isCastable = !Abilities.IsPassive( r_Ability ) && !noLevel;
	var manaCost = Abilities.GetManaCost( r_Ability );

	var unitMana = Entities.GetMana( r_QueryUnit );
	var runeIndex = $.GetContextPanel().GetAttributeInt( "index", -1 );
	var runeTier = $.GetContextPanel().GetAttributeInt( "tier", -1 );

	var AbilityLevel = r_BaseRuneLevel;

    var mainHero = r_mainHero

	var baseAbilityIndex = runeIndex
	if (baseAbilityIndex == 3){
		baseAbilityIndex = 5
	}
	var baseSkill = Entities.GetAbility( mainHero, baseAbilityIndex )
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
    // $.Msg("RuneBonus: " + RuneBonus)
    
    $.Msg("RUNE LOADED. BASE LEVEL: "+AbilityLevel)
    // $.Msg("AbilityLevel: " + AbilityLevel)
	// $.Msg("RUNEBONUS: "+RuneBonus)
	if (RuneBonus == 0){
		$( "#LevelText" ).text = AbilityLevel;
	}else{
		$( "#LevelText" ).text = "<font color='#7DFF12'>"+parseInt(AbilityLevel+RuneBonus)+"</font>";
	}

	if (!x){
		x = $.CreatePanel("Image", abilityButton, "");
		x.SetImage("file://{images}/custom_game/ui/red-x.png");
		x.style.width = "65%"
		x.style.height = "65%"
		x.style.verticalAlign = "center"
		x.style.horizontalAlign = "center"
	}
	if (!(Abilities.IsActivated(r_Ability))){
		x.visible = true
	}else{
		x.visible = false
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
	GameUI.CustomUIConfig.runeTooltip = r_Ability
	$.DispatchEvent("UIShowCustomLayoutTooltip", $.GetContextPanel(), "RuneTooltip", "file://{resources}/layout/custom_game/runes/rune_tooltip.xml");
	// $.DispatchEvent("DOTAShowTitleTextTooltip", $.GetContextPanel(), abilityTitle, tooltip);

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
	var propertyOne = $.Localize( "#DOTA_Tooltip_Ability_"+abilityName+"_property_two")
	if (propertyOne!=null){
		var suffix = $.Localize( "#DOTA_Tooltip_Ability_"+abilityName+"_suffix_two")
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
	var propertyOne = $.Localize( "#DOTA_Tooltip_Ability_"+abilityName+"_property_one")
	var suffix = $.Localize( "#DOTA_Tooltip_Ability_"+abilityName+"_suffix")
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
	if (baseAbilityIndex == 4){
		baseAbilityIndex = 6
	}
	if (baseAbilityIndex > 0){
		$.Msg("IN BLOCK!")
		var baseAbility = Entities.GetAbility( mainHero, baseAbilityIndex-1 )
		var baseAbilityText = $.Localize("#tooltip_rune_base_ability")+": "
		var baseAbilityName = $.Localize("#DOTA_Tooltip_Ability_"+Abilities.GetAbilityName( baseAbility ))
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
	}else if(element_index == 18){
		color = "#3289C7"
	}
	return color
}

function AbilityHideTooltip()
{
	//var abilityButton = $( "#AbilityButton" );
	//$.DispatchEvent( "DOTAHideAbilityTooltip", abilityButton );
	// $.DispatchEvent( "DOTAHideTitleTextTooltip", $.GetContextPanel() );
	//$.DispatchEvent("DOTAHideTitleTextTooltip", $.GetContextPanel(), title, tooltip);
	$.DispatchEvent("UIHideCustomLayoutTooltip", "RuneTooltip");
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
			if (GameUI.IsAltDown()) {
				GameEvents.SendCustomGameEventToServer( "change_rune_state", {ability: r_Ability, playerID: localPlayer, unit: Players.GetLocalPlayerPortraitUnit()} );
            } else {
                if (GameUI.IsShiftDown()) {
                    var playerID = localPlayer;
                    GameEvents.SendCustomGameEventToServer("level_up_rune_max", { ability: r_Ability, playerID: playerID, unit: Players.GetLocalPlayerPortraitUnit() });
                    AbilityHideTooltip()
                    $.Schedule(0.05, function () {
                        AbilityShowTooltip()
                    });
                }
                else {
                    var playerID = localPlayer;
                    GameEvents.SendCustomGameEventToServer("level_up_rune", { ability: r_Ability, playerID: playerID, unit: Players.GetLocalPlayerPortraitUnit() });
                    AbilityHideTooltip()
                    $.Schedule(0.05, function () {
                        AbilityShowTooltip()
                    });
                }
			}
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
