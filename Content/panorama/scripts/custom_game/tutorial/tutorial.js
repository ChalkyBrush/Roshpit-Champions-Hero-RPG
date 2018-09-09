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
		categoryPanel.SetPanelEvent('onmouseover', function HoverIn() {
			categoryPanel.FindChildTraverse('tutorial_category_header').AddClass('tutorial_category_header_active')
			categoryPanel.AddClass('tutorial_category_description_active')
		});
		categoryPanel.SetPanelEvent('onmouseout', function HoverOut() {
			categoryPanel.FindChildTraverse('tutorial_category_header').RemoveClass('tutorial_category_header_active')
			categoryPanel.RemoveClass('tutorial_category_description_active')
		});
		categoryButton.SetPanelEvent('onactivate', function Activate() {
			category_panel_click_setup(categoryPanel, index, category, msg)
		});
	}
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
			setupChallenge(category, category.challenges[i+1], i, challengeListPanel)
		}
	}
	Game.EmitSound("Tutorial.UI.CategoryClick")
	mCloseButton.FindChildTraverse('close_button_label').text = $.Localize("ui_back")
	mCloseButton.SetPanelEvent('onactivate', function Back() {
		Game.EmitSound("Tutorial.UI.Back")
		OpenTutorial(msg)
	})
}

function setupChallenge(category, challenge, index, challengeListPanel){
	$.Msg(category)
	$.Msg(category["progress"])
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
	}
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

(function()
{
	GameEvents.Subscribe( "open_tutorial", OpenTutorial );
	GameEvents.Subscribe("challenge_summary", ChallengeSummary);
	GameEvents.Subscribe("close_challenge_summary", CloseChallengeSummary);
})();
