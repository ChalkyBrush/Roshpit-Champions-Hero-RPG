
function BasicDialogue(msg){
	$.Msg("BASIC DIALOGUE")
	if ($('#hud_dialogue_container').BHasClass('animateEaseOutClass')){
		$('#hud_dialogue_container').RemoveClass('animateEaseOutClass')
	}
	$('#hud_dialogue_container').RemoveClass('animateEaseClass')
	$('#hud_dialogue_container').RemoveAndDeleteChildren(0);
	var parent = $('#hud_dialogue_container')
    var dialogue = $.CreatePanel("Panel", parent, "hud_dialogue")
    dialogue.BLoadLayoutSnippet("basic_dialogue");
    $('#hud_dialogue_container').AddClass('animateEaseClass')

    var portraitHero = msg.portraitHero
    var unitName = msg.unitName
    var messageText = msg.messageText
    messageText = $.Localize(messageText)
    var bDialogue = msg.bDialogue
    $('#hud_dialogue_container').unlock = false
    if (!(msg.azalea === undefined)){
    	messageText = messageText + "!!"
    }
    var heroPortraitContainer = dialogue.FindChildTraverse('dialogue_portrait_scene')

    // var heroPortraitAnimated = $.CreatePanel("DOTAScenePanel", button, "dialogue_portrait_scene2");
	// heroPortraitContainer.BLoadLayoutFromString("<DOTAScenePanel class='SceneLoaded' camera='default_camera' unit='" + portraitHero + "'></DOTAScenePanel>", false, false) 

var camera = "default_camera";
var style = "width:80px;height:100px;margin-bottom:10px;";
$.Msg(msg.nameColorClass)
heroPortraitContainer.LoadLayoutFromStringAsync("<root><Panel><DOTAScenePanel particleonly='false' style='" + style + "' class='SceneLoaded' camera='" + camera + "' unit='" + unitName +"'/></Panel></root>", false, false);
    var dialogueHeader = dialogue.FindChildTraverse('dialoge_name_label')
    dialogueHeader.text = $.Localize(unitName)
    dialogueHeader.AddClass(msg.nameColorClass)
    var dialogueLabel = dialogue.FindChildTraverse('dialogue_text')
    
    if (!(dialogueLabel.level)){
    	dialogueLabel.level = 0;
    }
    if (!($('#hud_dialogue_container').dialogueLevel)){
    	$('#hud_dialogue_container').dialogueLevel = 0
    }
    dialogueLabel.level = dialogueLabel.level + 1
    $('#hud_dialogue_container').dialogueLevel = $('#hud_dialogue_container').dialogueLevel + 1
    var dialogueLevel = $('#hud_dialogue_container').dialogueLevel
    typeText(dialogueLabel, messageText, dialogueLabel.level)
    $('#hud_dialogue_container').dialogueLock = true
	$.Schedule(parseInt(msg.timeLock), function(){
		CloseDialogue(dialogueLevel)
	});
}

function CloseDialogeImmediate()
{
	$('#hud_dialogue_container').dialogueLevel = 0
	$('#hud_dialogue_container').RemoveClass('animateEaseClass')
	$('#hud_dialogue_container').RemoveClass('animateEaseOutClass')
	$('#hud_dialogue_container').RemoveAndDeleteChildren(0);	
}

function CloseDialogue(dialogueLevel){
	if (dialogueLevel >= $('#hud_dialogue_container').dialogueLevel){
		$('#hud_dialogue_container').AddClass('animateEaseOutClass')

		$.Schedule(0.45, function(){
			if (dialogueLevel >= $('#hud_dialogue_container').dialogueLevel){
				$('#hud_dialogue_container').dialogueLevel = 0
				$('#hud_dialogue_container').RemoveClass('animateEaseClass')
				$('#hud_dialogue_container').RemoveClass('animateEaseOutClass')
				$('#hud_dialogue_container').RemoveAndDeleteChildren(0);
			}
		});
	}
}

function typeText(label, text, labelLevel)
{
	var j = 1
	var loop = text.length
	if (!(label)){
		return false
	}
	label.active = true
	for (i = 1; i < loop; i++) {
	 	$.Schedule(0.02*i, function(){
	 		if (label.level <= labelLevel){
	 			if (!(label)){
	 				return false
	 			}
		 		j = j + 1
		 		if (!(label===null)){
		 			label.text = text.substring(0,j);
		 		}
	 		}else{
	 			return
	 		}
	 	});
	}
}

(function()
{
	GameEvents.Subscribe( "basic_dialogue", BasicDialogue );
	GameEvents.Subscribe( "close_basic_dialogue", CloseDialogue );
})();