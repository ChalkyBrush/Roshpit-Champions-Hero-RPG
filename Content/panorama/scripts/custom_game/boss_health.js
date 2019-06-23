function showBossHealth(msg) {
    var bossUnitName = msg.bossName;
    var bossMaxHealth = msg.bossMaxHealth;
    var bossId = msg.bossId;
    if ($('#boss_health_outer').BHasClass('invisible')) {
        $('#boss_name').text = $.Localize(bossUnitName);
        $("#boss_current_health").SetAttributeInt("maxHealth", bossMaxHealth);
        $("#boss_current_health").style.width = "100%";
        $('#boss_health_outer').RemoveClass('invisible');
        $('#boss_id').text = bossId;
    } else if ($('#boss_health_outer2').BHasClass('invisible')) {
        $('#boss_name2').text = $.Localize(bossUnitName);
        $("#boss_current_health2").SetAttributeInt("maxHealth", bossMaxHealth);
        $("#boss_current_health2").style.width = "100%";
        $('#boss_health_outer2').RemoveClass('invisible');
        $('#boss_id2').text = bossId;
    } else if ($('#boss_health_outer3').BHasClass('invisible')) {
        $('#boss_name3').text = $.Localize(bossUnitName);
        $("#boss_current_health3").SetAttributeInt("maxHealth", bossMaxHealth);
        $("#boss_current_health3").style.width = "100%";
        $('#boss_health_outer3').RemoveClass('invisible');
        $('#boss_id3').text = bossId;
    } else if ($('#boss_health_outer4').BHasClass('invisible')) {
        $('#boss_name4').text = $.Localize(bossUnitName);
        $("#boss_current_health4").SetAttributeInt("maxHealth", bossMaxHealth);
        $("#boss_current_health4").style.width = "100%";
        $('#boss_health_outer4').RemoveClass('invisible');
        $('#boss_id4').text = bossId;
    } else if ($('#boss_health_outer5').BHasClass('invisible')) {
        $('#boss_name5').text = $.Localize(bossUnitName);
        $("#boss_current_health5").SetAttributeInt("maxHealth", bossMaxHealth);
        $("#boss_current_health5").style.width = "100%";
        $('#boss_health_outer5').RemoveClass('invisible');
        $('#boss_id5').text = bossId;
    }
}

function updateBossHealth(msg){
    var currentHealth = msg.current_health;
    var bossId = msg.bossId;
    var maxHealth = 0;
    var healthPercentage = 0;
    if ($('#boss_id').text === bossId) {
        maxHealth = $("#boss_current_health").GetAttributeInt("maxHealth", 1);
        healthPercentage = Math.floor((currentHealth / maxHealth) * 100);
        $("#boss_current_health").style.width = healthPercentage + "%";
    } else if ($('#boss_id2').text === bossId) {
        maxHealth = $("#boss_current_health2").GetAttributeInt("maxHealth", 1);
        healthPercentage = Math.floor((currentHealth / maxHealth) * 100);
        $("#boss_current_health2").style.width = healthPercentage + "%";
    } else if ($('#boss_id3').text === bossId) {
        maxHealth = $("#boss_current_health3").GetAttributeInt("maxHealth", 1);
        healthPercentage = Math.floor((currentHealth / maxHealth) * 100);
        $("#boss_current_health3").style.width = healthPercentage + "%";
    } else if ($('#boss_id4').text === bossId) {
        maxHealth = $("#boss_current_health4").GetAttributeInt("maxHealth", 1);
        healthPercentage = Math.floor((currentHealth / maxHealth) * 100);
        $("#boss_current_health4").style.width = healthPercentage + "%";
    } else if ($('#boss_id5').text === bossId) {
        maxHealth = $("#boss_current_health5").GetAttributeInt("maxHealth", 1);
        healthPercentage = Math.floor((currentHealth / maxHealth) * 100);
        $("#boss_current_health5").style.width = healthPercentage + "%";
    }
}

function hideBossHealth(msg) {
    var bossId = msg.bossId;
    if ($('#boss_id').text === bossId) {
        $('#boss_health_outer').AddClass('invisible');
        $('#boss_id').text = "";
    } else if ($('#boss_id2').text === bossId) {
        $('#boss_health_outer2').AddClass('invisible');
        $('#boss_id2').text = "";
    } else if ($('#boss_id3').text === bossId) {
        $('#boss_health_outer3').AddClass('invisible');
        $('#boss_id3').text = "";
    } else if ($('#boss_id4').text === bossId) {
        $('#boss_health_outer4').AddClass('invisible');
        $('#boss_id4').text = "";
    } else if ($('#boss_id5').text === bossId) {
        $('#boss_health_outer5').AddClass('invisible');
        $('#boss_id5').text = "";
    }
}

(function()
{
	GameEvents.Subscribe("show_boss_health", showBossHealth);
	GameEvents.Subscribe("update_boss_health", updateBossHealth);
	GameEvents.Subscribe("hide_boss_health", hideBossHealth);
})();

