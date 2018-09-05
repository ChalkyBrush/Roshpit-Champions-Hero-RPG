TUTORIAL_CATEGORIES = 2

function OpenTutorial(msg){
	var parent = $('#tutorial_container')
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
   

}

function setupCategory(category, index, parent)
{
	var categoryPanel = $.CreatePanel("Panel", parent, "category"+index)
	categoryPanel.BLoadLayoutSnippet("tutorial_category")
	categoryPanel.FindChildTraverse('tutorial_category_header_label').text = $.Localize(category["header"])
	categoryPanel.FindChildTraverse('tutorial_category_description_label').text = $.Localize(category["description"])
}

(function()
{
	GameEvents.Subscribe( "open_tutorial", OpenTutorial );
})();
