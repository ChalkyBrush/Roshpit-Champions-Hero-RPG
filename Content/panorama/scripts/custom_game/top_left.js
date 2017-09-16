function StartTimer(msg){
	$('#timer_title').text= $.Localize('#challenge_timer_title')
	$('#timer_container').RemoveClass('invisible')
	var seconds = msg.seconds
	genericUpdateTimer(seconds)
}

function UpdateTimer(msg){
	genericUpdateTimer(msg.seconds)
}

function genericUpdateTimer(seconds){
	$("#timer_value").text = convertSecondsRemainingToReadableTime(seconds)
}

function convertSecondsRemainingToReadableTime(rawSeconds){
	if (rawSeconds <= 0){
		HideTimer()
		return ""
	}
	var seconds = Math.floor(rawSeconds%60)
	if (seconds < 10){
		seconds = "0"+seconds
	}
	var minutes = Math.floor(rawSeconds/60)
	var timeString = minutes+":"+seconds
	return timeString	
}

function HideTimer(){
	$('#timer_container').AddClass('invisible')
}

(function()
{
	GameEvents.Subscribe( "start_challenge_timer", StartTimer );
	GameEvents.Subscribe( "update_challenge_timer", UpdateTimer );
	GameEvents.Subscribe( "close_challenge_timer", HideTimer );
	
})();

