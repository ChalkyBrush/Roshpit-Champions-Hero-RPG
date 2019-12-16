function InitializeResourceDisplay()
{
	var playerID = Game.GetLocalPlayerID()
	GameUI.CustomUIConfig().resourcesParent = $.GetContextPanel()
	var resources = CustomNetTables.GetTableValue( "player_stats", playerID.toString()+"-resources" );
	var mithril = CustomNetTables.GetTableValue( "player_stats", playerID.toString()+"-mithril" );
	var prismatics = CustomNetTables.GetTableValue( "player_stats", playerID.toString()+"-gemstones" );
	if (!(resources===undefined)){
		$('#arcane_crystals_value').text = numberWithCommas(resources.arcane)
	}
	if (!(resources===undefined)){
		$('#mithril_shards_value').text = numberWithCommas(mithril.mithril)
	}
	if (!(resources===undefined)){
		$('#prismatic_gemstones_value').text = numberWithCommas(prismatics.gemstones)
	}
	$.GetContextPanel().style.visibility = "collapse"
	$('#arcane_crystals_increment').text = ""
	$('#mithril_shards_increment').text = ""
	$('#prismatic_gemstones_increment').text = ""
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function UpdateResources(msg){
	var crystals = msg.arcane_crystals
	$('#arcane_crystals_value').text = numberWithCommas(crystals)
	$('#arcane_crystals_increment').text = ""
	var mithril = msg.mithril
	if (msg.mithril){
		$('#mithril_shards_value').text = numberWithCommas(mithril)
		$('#mithril_shards_increment').text = ""	
	}
	if (msg.gemstones){
		$('#prismatic_gemstones_value').text = numberWithCommas(msg.gemstones)
		$('#prismatic_gemstones_increment').text = ""			
	}
}

function UpdateMithril(msg){
	var mithril = msg.mithril
	$('#mithril_shards_value').text = numberWithCommas(mithril)
	$('#mithril_shards_increment').text = ""	
}

function UpdateGemstones(msg){
	var gemstones = msg.gemstones
	$.Msg("UPDATE GEMSTONES")
	$('#prismatic_gemstones_value').text = numberWithCommas(gemstones)
	$('#prismatic_gemstones_increment').text = ""	
}

function ResourceIncrement(msg){
	if (msg.resource =="arcane"){
		$('#arcane_crystals_increment').text = "(+"+msg.increment+")"
	}else if(msg.resource == "mithril"){
		$('#mithril_shards_increment').text = "(+"+msg.increment+")"
	}else if(msg.resource == "gemstones"){
		$('#prismatic_gemstones_increment').text = "(+"+msg.increment+")"
	}
}

(function()
{
	GameEvents.Subscribe( "update_resources", UpdateResources);
	GameEvents.Subscribe( "update_main_mithril", UpdateMithril);
	GameEvents.Subscribe( "update_gemstones", UpdateGemstones);
	GameEvents.Subscribe( "update_resources_increment", ResourceIncrement);
	InitializeResourceDisplay();
})();