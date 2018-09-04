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
}

(function()
{
	GameEvents.Subscribe( "open_tutorial", OpenTutorial );
})();
