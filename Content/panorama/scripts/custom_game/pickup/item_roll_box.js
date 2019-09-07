var MaxPlayers = 4;
if (Game.GetMapInfo().map_display_name == "rpc_sea_fortress") {
	MaxPlayers = 5
}else{
	$("#roll_portrait_5").AddClass("invisible")
	$("#portrait_overlay_5").AddClass("invisible")
}
var Root = $.GetContextPanel();
var item = Root.itemIndex;
var rollSlot = Root.rollSlot;
var portraitIndex = 0;
var rollTime = 30;
var currentRollInterval = 0;
var minLevel = Root.minLevel;

function getConnectedIds(){
	var allIds = Game.GetAllPlayerIDs();
	var connectedIds = []
	for (var i = 0; i < allIds.length; i++) {
		var playerInfo = Game.GetPlayerInfo(allIds[i]);
		if ((playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_FAILED) || (playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_ABANDONED) || (playerInfo.player_connection_state == playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_DISCONNECTED )){

		}else{
			connectedIds.push(allIds[i])
		}
	}
	return connectedIds
}

function InitializeRollBox(){
	// $.Msg("data:")
	// $.Msg(item)
	Root.AddClass("fromTopFade"+rollSlot)
	Root.AddClass("rollItemPosition"+rollSlot)
	$('#roll-item-image').contextEntityIndex = item;
	$('#roll-item-image').SetAttributeInt("item", item)

	manageSockets(item)
	// $('#need-button-label').text = $.Localize('#ui_need_roll')
	// $('#greed-button-label').text = $.Localize('#ui_greed_roll')
	// $('#pass-button-label').text = $.Localize('#ui_pass_roll')
	var localHero = Players.GetPlayerHeroEntityIndex( Game.GetLocalPlayerID())
	if (Entities.GetLevel( localHero) < minLevel){
		$('#option-need').AddClass('invisible')
	}
	var itemValues = CustomNetTables.GetTableValue( "item_basics", item.toString() )
	$.Msg("ITEM VALUES ROLL BOX:")
	$.Msg(itemValues)
	if (!(itemValues.requiredHero === undefined)){
		if (!(Entities.GetUnitName(localHero) == itemValues.requiredHero)){
			$('#option-need').AddClass('invisible')
		}
		if (itemValues.qualityName == "arcana"){
			$('#option-need').AddClass('invisible')
		}
	}
	if (!(itemValues.useDescription === undefined)){
		$('#option-need').AddClass('invisible')
	}
	//REMOVE NEED:
	$('#option-need').AddClass('invisible')

	var connectedIds = getConnectedIds()
	for (var i = 0; i < connectedIds.length; i++) {
		var hero = Players.GetPlayerHeroEntityIndex( connectedIds[i])	
		var heroName = Entities.GetUnitName(hero)
		var hero_image_name = "file://{images}/heroes/" + heroName + ".png"
		var panelIndex = i+1
		portraitIndex = panelIndex
    	$("#roll_portrait_"+panelIndex).SetImage( hero_image_name );
    	$('#portrait_overlay_'+portraitIndex).SetAttributeInt("playerID", connectedIds[i])
	}
	if (connectedIds.length < MaxPlayers){
		for (var i = connectedIds.length; i < MaxPlayers; i++) {
			var panelIndex = i+1
    		$("#roll_portrait_"+panelIndex).AddClass('invisible');
    		$('#portrait_overlay_'+panelIndex).AddClass('invisible')
		}
	}
	$('#countdown-timer').text = rollTime;
	for (i=1; i<=rollTime*4; i++){
		$.Schedule(i*0.25, function(){
			if (!($('#countdown-timer')==null)){
				currentRollInterval = currentRollInterval + 1
				if (currentRollInterval%4==0){
					$('#countdown-timer').text = rollTime - currentRollInterval/4
					//$.Msg(rollTime - currentRollInterval/4)
					if (rollTime - currentRollInterval/4 == 0){
						$('#roll-options').AddClass("invisible")
						$.Msg("roll-options -> invisible")
					}
				}
				$('#countdown-progress').style.width = (100-((25/rollTime)*currentRollInterval))+"%";
			}
		});
	}
	// $.Schedule(rollTime, function(){		
		
	// 	Root.RemoveClass("animateIn")
	// 	Root.AddClass("fromBottomFade"+rollSlot)
	// 	$.Schedule(0.29, function(){
	// 		$.GetContextPanel().AddClass("invisible")		
	// 		$.GetContextPanel().RemoveAndDeleteChildren()
	// 	});			
	// });			
}

function roll(type){
	var playerID = Game.GetLocalPlayerID()
	var isSpectator = Players.IsSpectator( playerID )
	if (!isSpectator){
		if (type=="pass"){
			GameEvents.SendCustomGameEventToServer( "vote_roll", {index: rollSlot+1, type: "pass", playerID: playerID, itemIndex: item});
		}
		else if (type=="greed"){
			GameEvents.SendCustomGameEventToServer( "vote_roll", {index: rollSlot+1, type: "greed", playerID: playerID, itemIndex: item});
		}
		else if (type=="need"){
			GameEvents.SendCustomGameEventToServer( "vote_roll", {index: rollSlot+1, type: "need", playerID: playerID, itemIndex: item});
		}
	}
	$('#roll-options').AddClass("invisible")
}

function register_roll(keys){
	$.Msg("ROLL INDEX:::")
	$.Msg(keys.rollIndex)
	if ((keys.rollIndex-1) == rollSlot){
		var playerID = keys.playerID
		var roll = keys.roll
		var label = getOverlayLabel(playerID)
		var rollType = keys.rollType
		var overlay = getPortraitOverlay(playerID)
		if (!(label==null)){
			if(!(rollType=="pass")){
				label.text = roll
			}
		}
		if (!(overlay==null)){
			if (rollType == "need"){
				overlay.AddClass('yellow-overlay')
			}else if (rollType == "greed"){
				overlay.AddClass('green-overlay')
			}else if (rollType == "pass"){
				overlay.AddClass('red-overlay')
			}
		}else{
			$.Msg("================")
			$.Msg("Overlay is null!")
			$.Msg("================")
			$.Msg("Players:",Game.GetAllPlayerIDs())
			$.Msg("================")
		}
	}
}

function getPortraitOverlay(playerID)
{
	$.Msg("================")
	$.Msg("Players:",Game.GetAllPlayerIDs())
	$.Msg("================")
	var allIds = Game.GetAllPlayerIDs();
	for (var i = 1; i <= allIds.length; i++)
	{
		if (!($('#portrait_overlay_'+i)==null)){
			if ($('#portrait_overlay_'+i).GetAttributeInt("playerID", -1) == playerID){
				return $('#portrait_overlay_'+i)
			}
		}
	}
}

function getOverlayLabel(playerID)
{
	var allIds = Game.GetAllPlayerIDs();
	for (var i = 1; i <= allIds.length; i++)
	{
		if (!($('#portrait_overlay_'+i)==null)){
			if ($('#portrait_overlay_'+i).GetAttributeInt("playerID", -1) == playerID){
				return $('#roll_label_'+i)
			}
		}
	}
}
function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

function RollTooltip(title, message, panelId, titleColor){
	message = $.Localize( "#"+message)
	title = $.Localize( "#"+title)
	title = "<font color='"+titleColor+"'>"+title+"</font>"
	title = title.replace(/(['"])/g, "\\$1");
	var tooltip = breakUpTooltip(message)
	var panel = $(panelId)
	$.DispatchEvent("DOTAShowTitleTextTooltip", panel, title, tooltip);
}

function RollHideTooltip(panelId)
{
	var panel = $(panelId)
	$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
}

(function()
{
	GameEvents.Subscribe( "register_roll", register_roll );
	InitializeRollBox();
})();