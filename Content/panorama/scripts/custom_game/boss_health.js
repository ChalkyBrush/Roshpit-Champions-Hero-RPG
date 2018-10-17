function showBossHealth(msg){
	var bossUnitName = msg.bossName
	var bossMaxHealth = msg.bossMaxHealth
	$('#boss_name').text = $.Localize(bossUnitName)
	$("#boss_current_health").SetAttributeInt("maxHealth", bossMaxHealth)
	$("#boss_current_health").style.width = "100%"
	$('#boss_health_outer').RemoveClass('invisible')
}

function updateBossHealth(msg){
	var currentHealth = msg.current_health
	var maxHealth = $("#boss_current_health").GetAttributeInt("maxHealth", 1)
	var healthPercentage = Math.floor((currentHealth/maxHealth)*100)
	$("#boss_current_health").style.width = healthPercentage+"%"
}

function hideBossHealth(){
	$('#boss_health_outer').AddClass('invisible')
}

(function()
{
	GameEvents.Subscribe( "show_boss_health", showBossHealth );
	GameEvents.Subscribe( "update_boss_health", updateBossHealth );
	GameEvents.Subscribe( "hide_boss_health", hideBossHealth );
})();

