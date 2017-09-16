function CollectArcane(msg)
{
	$('#extra_resource_gain').RemoveClass('invisible')
	$('#extra_resource_gain').AddClass('resourceIn')
	$('#extra_resource_gain').RemoveClass('resourceOut')
	var resourceGain = msg.gain
	$('#resource_gain_label').text = "+"+resourceGain
	$('#resource_gain_icon').SetImage("file://{images}/custom_game/ui/arcane_crystal.png" )
}

function CollectMithril(msg)
{
	$('#extra_resource_gain').RemoveClass('invisible')
	$('#extra_resource_gain').AddClass('resourceIn')
	$('#extra_resource_gain').RemoveClass('resourceOut')
	var resourceGain = msg.gain
	$('#resource_gain_label').text = "+"+resourceGain
	$('#resource_gain_icon').SetImage("file://{images}/custom_game/ui/mithril_shard.png" )
}

function ArcaneOut(msg)
{
	$.Schedule(0.67, function(){
		$('#extra_resource_gain').AddClass('invisible')
	});
	$('#extra_resource_gain').AddClass('resourceOut')	
	$('#extra_resource_gain').RemoveClass('resourceIn')
}

(function()
{
	GameEvents.Subscribe( "collect_arcane", CollectArcane );
	GameEvents.Subscribe( "collect_mithril", CollectMithril );
	GameEvents.Subscribe( "arcane_out", ArcaneOut );
})();
