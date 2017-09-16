function getSelectedPlayerID(entIndex)
{

}

function isRedfallRidge()
{
	var result = false
	var mapName = Game.GetMapInfo().map_display_name
	if (mapName === "rpc_redfall_ridge_normal" || mapName === "rpc_redfall_ridge_elite" || mapName === "rpc_redfall_ridge_legend" || mapName === "redfall_ridge_work" || mapName == "rpc_redfall_ridge"){
		result = true
	}	
	return result
}

function redfallQuest()
{
	
}