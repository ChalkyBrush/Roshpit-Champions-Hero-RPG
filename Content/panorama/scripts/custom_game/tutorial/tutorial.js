TUTORIAL_CATEGORIES = 2
mCloseButton = null

function OpenTutorial(msg){
	var parent = $('#tutorial_container')
	parent.RemoveClass('invisible')
	parent.AddClass('animateEaseClass')
	parent.RemoveClass('animateEaseOutClass')
	if (msg.sound == 1){
		Game.EmitSound( "Tutorial.FirstOpen" )
		msg.sound = 0;
	}
	parent.RemoveAndDeleteChildren(0)
    var tutorial_main = $.CreatePanel("Panel", parent, "tutorial-main")
    tutorial_main.BLoadLayoutSnippet("tutorial_main");
    var header = tutorial_main.FindChildTraverse('tutorial_header')
    var imageName = "file://{images}/custom_game/ui/tutorial/tutorial_header.jpg"
    header.SetImage(imageName)


    mCloseButton = tutorial_main.FindChildTraverse('close_button')
    mCloseButton.FindChildTraverse('close_button_label').text = $.Localize("ui_close")
    var available_category_count = Object.keys(msg.categories).length
	for (var i = 0; i < available_category_count; i++) {
		var category = msg.categories[i+1]
	    setupCategory(category, i, tutorial_main.FindChildTraverse('tutorial_categories_container'), false, msg)
	}
   
	tutorial_main.FindChildTraverse('close_button').SetPanelEvent('onactivate', function Close() {
		Game.EmitSound("Tutorial.UI.Close")
		CloseTutorial();
	})

}

function CloseTutorial(){
	var parent = $('#tutorial_container')
	parent.AddClass('invisible')
	var hero = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer())
	GameEvents.SendCustomGameEventToServer( "tutorial", {hero: hero, code: "close_tutorial"} );
	parent.AddClass('animateEaseClass')
	parent.RemoveClass('animateEaseOutClass')
}

function setupCategory(category, index, parent, bStatic, msg)
{
	var categoryPanel = $.CreatePanel("Panel", parent, "category"+index)
	categoryPanel.BLoadLayoutSnippet("tutorial_category")
	categoryPanel.FindChildTraverse('tutorial_category_header_label').text = $.Localize(category["header"])
	categoryPanel.FindChildTraverse('tutorial_category_description_label').text = $.Localize(category["description"])
	var categoryButton = categoryPanel.FindChildTraverse('tutorial_category_clickable')
	if (!(bStatic)){
		categoryPanel.rewardActive = isCategoryRewardActive(category, index, msg)
		if (categoryPanel.rewardActive){
			categoryPanel.FindChildTraverse('tutorial_category_header').AddClass('reward_active')
			categoryPanel.FindChildTraverse('tutorial_category_header_label').text = $.Localize(category["header"]) + " - <font color='#e6ff59'>"+$.Localize('quest_reward_available')+"</font>"
		}
		if (isCategoryRewardClaimed(category, index, msg)){
			categoryPanel.FindChildTraverse('tutorial_category_header_label').text = $.Localize(category["header"]) + " - <font color='#e6ff59'>"+$.Localize("tutorial_section_completed")+"</font>"
		}
		categoryPanel.SetPanelEvent('onmouseover', function HoverIn() {
			if (categoryPanel.rewardActive){
				categoryPanel.FindChildTraverse('tutorial_category_header').AddClass('reward_active_hover')
			}else{
				categoryPanel.FindChildTraverse('tutorial_category_header').AddClass('tutorial_category_header_active')
			}
			categoryPanel.AddClass('tutorial_category_description_active')
		});
		categoryPanel.SetPanelEvent('onmouseout', function HoverOut() {
			categoryPanel.FindChildTraverse('tutorial_category_header').RemoveClass('tutorial_category_header_active')
			categoryPanel.FindChildTraverse('tutorial_category_header').RemoveClass('reward_active_hover')
			categoryPanel.RemoveClass('tutorial_category_description_active')
		});
		categoryButton.SetPanelEvent('onactivate', function Activate() {
			category_panel_click_setup(categoryPanel, index, category, msg)
		});
		// categoryPanel.AddClass('reward_active')
	}
}

function isCategoryRewardActive(category, index, msg)
{
	var challenge_section = index+1
	var key = ("section"+challenge_section).toString()
	var challengeCount = category["challenges"]
	var progress = msg.tutorial[key]["progress"]
	var reward = msg.tutorial[key]["reward"]
	return ((progress == challengeCount) && (reward==0))
}

function isCategoryRewardClaimed(category, index, msg){
	var challenge_section = index+1
	var key = ("section"+challenge_section).toString()
	var challengeCount = category["challenges"]
	var progress = msg.tutorial[key]["progress"]
	var reward = msg.tutorial[key]["reward"]
	return (reward == 1)	
}

function category_panel_click_setup(categoryPanel, index, category, msg){
	var parent = $('#tutorial_container')
	var category_container = parent.FindChildTraverse('tutorial_categories_container')
	category_container.RemoveAndDeleteChildren(0)
	setupCategory(category, index, category_container, true)
	var challengeListPanel = $.CreatePanel("Panel", category_container, "challenge-list")
	challengeListPanel.BLoadLayoutSnippet('tutorial_challenge_list')
	var challengeCount = category["challenges"]
	$.Msg(msg.tutorial)
	var challenge_section = index+1
	var key = ("section"+challenge_section).toString()
	$.Msg(key)
	var progress = msg.tutorial[key]["progress"]
	for (var i = 0; i < challengeCount; i++) {
		if (progress >= i){
			setupChallenge(category, category.challenges[i+1], i, challengeListPanel, challengeCount)
		}
	}
	Game.EmitSound("Tutorial.UI.CategoryClick")
	mCloseButton.FindChildTraverse('close_button_label').text = $.Localize("ui_back")
	mCloseButton.SetPanelEvent('onactivate', function Back() {
		Game.EmitSound("Tutorial.UI.Back")
		OpenTutorial(msg)
	})
}

function setupChallenge(category, challenge, index, challengeListPanel, challengeCount){
	challenge_list_adder_panel = challengeListPanel.FindChildTraverse('challenge_list_items')
	if (category["progress"] >= index){
		var challengePanel = $.CreatePanel("Panel", challenge_list_adder_panel, "challenge"+index)
		challengePanel.BLoadLayoutSnippet("tutorial_challenge")	
		var quest_number = category["index"]
		var challenge_number = index + 1
		$.Msg("---CHALLENGE NUMBER:"+challenge_number)
		challengePanel.FindChildTraverse('tutorial_challenge_text').text = $.Localize('quest_'+quest_number+"_challenge_"+challenge_number) 
		challengePanel.FindChildTraverse('challenge_button').SetPanelEvent('onactivate', function Activate() {
			challenge_activate(category, challenge_number, challengeListPanel)
		});
		if (category["progress"] > index){
			challengePanel.FindChildTraverse('green_check').RemoveClass('invisible')
			if ((category["progress"] == challengeCount) && (index+1 == challengeCount)){
				var challengePanel = $.CreatePanel("Panel", challenge_list_adder_panel, "reward"+index)
				challengePanel.BLoadLayoutSnippet("tutorial_challenge")	
				challengePanel.FindChildTraverse('tutorial_challenge_text').text = $.Localize("quest_reward_label") + " " + $.Localize("quest_"+quest_number+"_reward_title")
				challengePanel.FindChildTraverse('tutorial_challenge_text').AddClass('challenge_reward_button')
				challengePanel.FindChildTraverse('tutorial_challenge_text').style.color = '#f0f940'
				if (category["reward"] == 1){
					challengePanel.FindChildTraverse('green_check').RemoveClass('invisible')
				}
				challengePanel.FindChildTraverse('challenge_button').SetPanelEvent('onactivate', function Activate() {
					reward_activate(category, challengeListPanel, category["reward"])
				});
			}
		}
	}
}

function reward_activate(category, challengeListPanel, reward){
	var descrip_and_go_container = challengeListPanel.FindChildTraverse('total_challenge_list')
	var descripAndGoPanel = $.CreatePanel("Panel", descrip_and_go_container, "descrip_and_go")
	Game.EmitSound("Tutorial.UI.ChallengeClick")
	descripAndGoPanel.BLoadLayoutSnippet('reward_and_go')

	descripAndGoPanel.FindChildTraverse('reward_and_go_description_text').text = $.Localize("quest_1_reward_description")
	if (reward == 0){
		descripAndGoPanel.FindChildTraverse('challenge_go_button_text').text = $.Localize("quest_reward_claim")
		descripAndGoPanel.FindChildTraverse('reward_go_button').SetPanelEvent('onactivate', function Activate() {
				Game.EmitSound("Tutorial.Win")
				reward_claim_final(category)
		});
	}else{
		descripAndGoPanel.FindChildTraverse('challenge_go_button_text').text = $.Localize("quest_reward_claimed")
		descripAndGoPanel.FindChildTraverse('reward_go_button').AddClass('reward_claimed')
		descripAndGoPanel.FindChildTraverse('reward_go_button').RemoveClass('reward_unclaimed')
		descripAndGoPanel.FindChildTraverse('challenge_go_button_text').style.color = '#777777'
	}
}

function reward_claim_final(category){
	var hero = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer())
	GameEvents.SendCustomGameEventToServer( "tutorial", {hero: hero, code: "reward_select", category_index: category["index"]} );
	CloseTutorial();
}

function challenge_activate(category, challenge_index, challengeListPanel){
	var descrip_and_go_container = challengeListPanel.FindChildTraverse('total_challenge_list')
	var descripAndGoPanel = $.CreatePanel("Panel", descrip_and_go_container, "descrip_and_go")
	Game.EmitSound("Tutorial.UI.ChallengeClick")
	descripAndGoPanel.BLoadLayoutSnippet('challenge_description_and_go')

	descripAndGoPanel.FindChildTraverse('descrip_and_go_description_text').text = $.Localize("quest_"+category["index"]+"_challenge_"+challenge_index+"_desc")
	descripAndGoPanel.FindChildTraverse('challenge_go_button').SetPanelEvent('onactivate', function Activate() {
			Game.EmitSound("Tutorial.UI.ChallengeSelect")
			challenge_go_final(category, challenge_index)
	});
	descripAndGoPanel.FindChildTraverse('challenge_go_button_text').text = $.Localize("tutorial_challenge_go")
}

function challenge_go_final(category, challenge_index)
{
	var hero = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer())
	GameEvents.SendCustomGameEventToServer( "tutorial", {hero: hero, code: "challenge_select", category_index: category["index"], challenge_index: challenge_index} );
	CloseTutorial();	
}

function ChallengeSummary(msg)
{
	var parent = $('#tutorial_challenge_summary_container')
	parent.RemoveAndDeleteChildren(0)
    var tutorial_challenge_panel = $.CreatePanel("Panel", parent, "tutorial-challenges")
    tutorial_challenge_panel.BLoadLayoutSnippet("challenge_summary");
    var listItemCount = msg.sub_index
    if (msg.bCapped){
    	listItemCount = listItemCount - 1
    	Game.EmitSound("Tutorial.Win")
    }else{
    	Game.EmitSound("Tutorial.WinSub")
    }
	for (var i = 0; i <= listItemCount; i++) {
		var challenge_progress_panel = $.CreatePanel("Panel", tutorial_challenge_panel, "tutorial-challenge-progress-"+i)
		challenge_progress_panel.BLoadLayoutSnippet('challenge_summary_item')
		challenge_progress_panel.FindChildTraverse('challenge_summary_item_label').text = $.Localize('quest_'+msg.category_index+'_challenge_'+msg.challenge_index+'_sub_'+i+'_summary')
		if (msg.sub_index > i){
			challenge_progress_panel.FindChildTraverse('challenge_summary_item_label').AddClass('challenge_summary_item_completed')
		}
	}    
}

function CloseChallengeSummary(msg){
	var parent = $('#tutorial_challenge_summary_container')
	parent.RemoveAndDeleteChildren(0)	
}

function CallQuizBox(msg){
	var parent = $('#tutorial_quiz_container')
	parent.RemoveClass('invisible')
	parent.AddClass('animateEaseClass')
	parent.RemoveClass('animateEaseOutClass')
	parent.RemoveAndDeleteChildren(0)
    var quiz_box = $.CreatePanel("Panel", parent, "quiz")
    quiz_box.BLoadLayoutSnippet("quiz_box");	
    quiz_box.FindChildTraverse('quiz_box_question').text = $.Localize(msg.quiz_question).replace('@sub1', "<font color='#7DFF12'>"+msg.gsub1+"</font>")
   	submit_button = parent.FindChildTraverse('quiz_submit_button')
	submit_button.SetPanelEvent('onactivate', function SubmitQuiz() {
		setupQuizAnswerSubmit(parent, msg.identifier, msg.sequence, msg.verifier, msg.localize_verifier, msg.challenge_progress)
	})
	parent.FindChildTraverse('quiz_box_input').SetFocus();
}

function quiz_submit_sound(msg){
	Game.EmitSound(msg.sound)
}

function setupQuizAnswerSubmit(parent, identifier, sequence, verifier, bLocalize, challenge_progress)
{
	$.Msg("SUBMIT QUIZ")
	var input = parent.FindChildTraverse('quiz_box_input').text
	var hero = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer())
	if (bLocalize == 1){
		verifier = $.Localize(verifier).toLowerCase()
		input = input.toLowerCase()
	}
	GameEvents.SendCustomGameEventToServer( "tutorial", {hero: hero, code: "submit_quiz", challenge_index: identifier, sequence: sequence, verifier: verifier, answer: input, challenge_progress: challenge_progress} );	
}

function close_quiz()
{
	var parent = $('#tutorial_quiz_container')
	parent.AddClass('invisible')
}

(function()
{
	GameEvents.Subscribe( "open_tutorial", OpenTutorial );
	GameEvents.Subscribe("challenge_summary", ChallengeSummary);
	GameEvents.Subscribe("close_challenge_summary", CloseChallengeSummary);
	GameEvents.Subscribe("call_quiz", CallQuizBox);
	GameEvents.Subscribe("quiz_sound", quiz_submit_sound);
	GameEvents.Subscribe("close_quiz", close_quiz);
})();
