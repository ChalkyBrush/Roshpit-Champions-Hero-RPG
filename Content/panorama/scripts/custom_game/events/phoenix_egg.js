mMaxHealth = $.GetContextPanel().maxHealth
mCurrentSound = 0
function update_phoenix_health(msg)
{
	var currentHealth = msg.currentHealth
	var maxHealth = msg.maxHealth
	var percentage = (currentHealth/maxHealth)*100
	$('#phoenix_current_health').style.width = percentage+"%"

	var currentHealthProt1 = msg.currentHealthProt1
	var maxHealthProt1 = msg.maxHealthProt1
	var currentHealthProt2 = msg.currentHealthProt2
	var maxHealthProt2 = msg.maxHealthProt2
	var currentHealthProt3 = msg.currentHealthProt3
	var maxHealthProt3 = msg.maxHealthProt3
	var currentHealthProt4 = msg.currentHealthProt4
	var maxHealthProt4 = msg.maxHealthProt4
	percentage = (currentHealthProt1/maxHealthProt1)*100
	if (currentHealthProt1 == 0){

	}else{
		$('#guardian_current_health1').style.width = percentage+"%"
	}
	percentage = (currentHealthProt2/maxHealthProt2)*100
	if (currentHealthProt2 == 0){

	}else{
		$('#guardian_current_health2').style.width = percentage+"%"
	}
	percentage = (currentHealthProt3/maxHealthProt3)*100
	if (currentHealthProt3 == 0){

	}else{
		$('#guardian_current_health3').style.width = percentage+"%"
	}
	percentage = (currentHealthProt4/maxHealthProt4)*100
	if (currentHealthProt4 == 0){

	}else{
		$('#guardian_current_health4').style.width = percentage+"%"
	}


}

function eggDie(msg){
	$('#phoenix_current_health').style.width = "0%"
}

function guardianRegenBegin(msg){
	var number = msg.guardianNumber
	$('#guardian_current_health'+number).AddClass("regenning_health")
	$("#guardian_name_label"+number).text = $.Localize('#phoenix_nest_protector_regen')
}

function guardianRegenEnd(msg){
	var number = msg.guardianNumber
	$('#guardian_current_health'+number).RemoveClass("regenning_health")
	$("#guardian_name_label"+number).text = $.Localize('#phoenix_nest_protector')+" "+number
}

function phoenixHatched2(msg){
	// $('#phoenix_name_label').text = $.Localize('#phoenix_hatched')
	$('#guardian_container').AddClass("invisible")
	$('#phoenix_health_outer').AddClass("invisible")
}

function initializePhoenix(){
	$('#phoenix_name_label').text = $.Localize('#phoenix_egg_name')
	$("#guardian_name_label1").text = $.Localize('#phoenix_nest_protector')+" 1"
	$("#guardian_name_label2").text = $.Localize('#phoenix_nest_protector')+" 2"
	$("#guardian_name_label3").text = $.Localize('#phoenix_nest_protector')+" 3"
	$("#guardian_name_label4").text = $.Localize('#phoenix_nest_protector')+" 4"
}

function updatePhoenixWave(msg)
{
	var waveNumber = msg.waveNumber
	var wavePrefix = msg.wavePrefix
	$('#phoenix_wave_label').text = $.Localize('#phoenix_wave')+": "+msg.wavePrefix+msg.waveNumber
}

function phoenixBossStartMusic(msg)
{
	$.Msg("WORKING MUSIC??")
	mCurrentSound = Game.EmitSound( "Music.PhoenixBoss" )
}

function phoenixBossSequenceMusic(msg)
{
	mCurrentSound = Game.EmitSound( "Music.PhoenixBossSequence" )
}

function phoenixBossEndMusic(msg)
{
	Game.StopSound( mCurrentSound )
	Game.EmitSound( "ui.npe_badge") 
}

function hideGuardianContainer(){
	$('#guardian_container').AddClass("invisible")
}

function phoenixBossSpawn(msg)
{
	// $('#guardian_container').RemoveClass("invisible")
	var bossLevel = msg.bossLevel
	$('#phoenix_health_outer').RemoveClass("invisible")
	$('#phoenix_name_label').text = $.Localize('#phoenix_boss') + " LV"+bossLevel
	$("#guardian_name_label1").text = $.Localize('#phoenix_subboss_a')
	$("#guardian_name_label2").text = $.Localize('#phoenix_subboss_b')
	$("#guardian_name_label3").text = $.Localize('#phoenix_subboss_c')
	$("#guardian_name_label4").text = $.Localize('#phoenix_subboss_d')
	$('#phoenix_current_health').RemoveClass('phoenix_current_health')
	$('#phoenix_current_health').AddClass('phoenix_boss_health')

	$('#guardian_current_health1').AddClass("phoenix_subboss_health")
	$('#guardian_current_health2').AddClass("phoenix_subboss_health")
	$('#guardian_current_health3').AddClass("phoenix_subboss_health")
	$('#guardian_current_health4').AddClass("phoenix_subboss_health")
}

function phoenixSubbossSpawn(msg)
{
	$('#guardian_container').RemoveClass("invisible")
	$('#guardian_container').AddClass('animateEaseClassOneSecond')
}

function phoenixGuardianBarUpdate(msg)
{
	var updateIndex = msg.updateIndex
	$('#guardian_current_health'+updateIndex).style.width = "0%"
}

(function () {
  initializePhoenix();
  GameEvents.Subscribe( "update_phoenix_health", update_phoenix_health );
  GameEvents.Subscribe( "guardian_regen_begin", guardianRegenBegin );
  GameEvents.Subscribe( "guardian_regen_end", guardianRegenEnd );
  GameEvents.Subscribe( "update_phoenix_wave", updatePhoenixWave );
  GameEvents.Subscribe( "phoenixHatched2", phoenixHatched2 );

  GameEvents.Subscribe( "phoenixBossStartMusic", phoenixBossStartMusic );

  GameEvents.Subscribe( "phoenixBossSpawn", phoenixBossSpawn );
  GameEvents.Subscribe( "phoenixBossSequenceMusic", phoenixBossSequenceMusic );
  GameEvents.Subscribe( "phoenixBossEndMusic", phoenixBossEndMusic );
  GameEvents.Subscribe( "phoenixSubbossSpawn", phoenixSubbossSpawn );

  GameEvents.Subscribe( "hideGuardianContainer", hideGuardianContainer );
  
  GameEvents.Subscribe( "phoenixGuardianBarUpdate", phoenixGuardianBarUpdate );

  GameEvents.Subscribe( "eggDie", eggDie );
})();