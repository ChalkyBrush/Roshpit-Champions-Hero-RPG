var bossHealthContext = $.GetContextPanel()
var updateHealthBar = {};


function showBossHealth(msg) {
	var bossHealthContainer = bossHealthContext.FindChildTraverse("boss_health_container");
	if (bossHealthContainer.FindChildTraverse("boss" + msg.bossEntityIndex) == undefined) {
		var newBossHealthBar = $.CreatePanel( "Panel", bossHealthContainer, "boss" + msg.bossEntityIndex );
		newBossHealthBar.BLoadLayoutSnippet("boss_health_bar_snippet"); 
		newBossHealthBar.FindChildTraverse("boss_current_health").style.width = "100%";
		newBossHealthBar.SetAttributeInt("boss_entity_index", msg.bossEntityIndex);
		newBossHealthBar.FindChildTraverse("boss_name").text = $.Localize(Entities.GetUnitName(msg.bossEntityIndex));
		updateHealthBar[msg.bossEntityIndex] = true;
		updateBossHealth(msg.bossEntityIndex);
	}
}

function updateBossHealth(bossEntityIndex){
	if(updateHealthBar[bossEntityIndex]) { 
		$.Schedule(0.03, () => updateBossHealth(bossEntityIndex));
		var bossHealthContainer = bossHealthContext.FindChildTraverse("boss" + bossEntityIndex);
		if (bossHealthContainer.FindChildTraverse("boss_name").text === "") {
			bossHealthContainer.FindChildTraverse("boss_name").text = $.Localize(Entities.GetUnitName(bossEntityIndex));
		}
		bossHealthContainer.FindChildTraverse("boss_current_health").style.width = (Entities.GetHealth(bossEntityIndex) / Entities.GetMaxHealth(bossEntityIndex)) * 100 + "%";
	}
}

function hideBossHealth(msg) {
	var bossHealthContainer = bossHealthContext.FindChildTraverse("boss_health_container");
	var bossHealthBar = bossHealthContainer.FindChildTraverse("boss" + msg.bossEntityIndex);
	bossHealthBar.DeleteAsync(0);
	updateHealthBar[msg.bossEntityIndex] = false;
}

(function()
{
	GameEvents.Subscribe("show_boss_health", showBossHealth);
	GameEvents.Subscribe("hide_boss_health", hideBossHealth);
})();

