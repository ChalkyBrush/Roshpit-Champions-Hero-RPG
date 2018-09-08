TUTORIAL_CATEGORIES = 2

function OpenTutorial(msg){
	var parent = $('#tutorial_container')
	parent.RemoveClass('invisible')
	parent.AddClass('animateEaseClass')
	parent.RemoveClass('animateEaseOutClass')
	if (msg.sound == 1){
		Game.EmitSound( "Tutorial.FirstOpen" )
	}
	parent.RemoveAndDeleteChildren(0)
    var tutorial_main = $.CreatePanel("Panel", parent, "tutorial-main")
    tutorial_main.BLoadLayoutSnippet("tutorial_main");
    var header = tutorial_main.FindChildTraverse('tutorial_header')
    var imageName = "file://{images}/custom_game/ui/tutorial/tutorial_header.jpg"
    header.SetImage(imageName)

	for (var i = 0; i < TUTORIAL_CATEGORIES; i++) {
		var category = msg.categories[i+1]
	    setupCategory(category, i, tutorial_main.FindChildTraverse('tutorial_categories_container'))
	}
   
	tutorial_main.FindChildTraverse('close_button').SetPanelEvent('onactivate', function Close() {
		CloseTutorial();
	})

}

function CloseTutorial(msg){
	var parent = $('#tutorial_container')
	parent.AddClass('invisible')
	var hero = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer())
	GameEvents.SendCustomGameEventToServer( "tutorial", {hero: hero, code: "close_tutorial"} );
	parent.AddClass('animateEaseClass')
	parent.RemoveClass('animateEaseOutClass')
}

function setupCategory(category, index, parent)
{
	var categoryPanel = $.CreatePanel("Panel", parent, "category"+index)
	categoryPanel.BLoadLayoutSnippet("tutorial_category")
	categoryPanel.FindChildTraverse('tutorial_category_header_label').text = $.Localize(category["header"])
	categoryPanel.FindChildTraverse('tutorial_category_description_label').text = $.Localize(category["description"])
	categoryPanel.SetPanelEvent('onmouseover', function Close() {
		categoryPanel.FindChildTraverse('tutorial_category_header').AddClass('tutorial_category_header_active')
		categoryPanel.AddClass('tutorial_category_description_active')
	});
	categoryPanel.SetPanelEvent('onmouseout', function Close() {
		categoryPanel.FindChildTraverse('tutorial_category_header').RemoveClass('tutorial_category_header_active')
		categoryPanel.RemoveClass('tutorial_category_description_active')
	});
}

(function()
{
	GameEvents.Subscribe( "open_tutorial", OpenTutorial );
})();
