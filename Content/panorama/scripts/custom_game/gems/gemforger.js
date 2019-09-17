function OpenGemforger(msg){
	$.Msg("GEM FORGER")
	var parent = $('#gemforger_container')
	parent.RemoveClass('invisible')
	parent.AddClass('animateEaseClass')
	parent.RemoveClass('animateEaseOutClass')
	parent.RemoveAndDeleteChildren(0)
    var gemforger_main = $.CreatePanel("Panel", parent, "gemforger-main")
    gemforger_main.BLoadLayoutSnippet("gemforger_main");
    var header = gemforger_main.FindChildTraverse('gemforger_header')
    var imageName = "file://{images}/custom_game/ui/gem_forger_header.jpg"
    header.SetImage(imageName)

    var attach_point = gemforger_main.FindChildTraverse('gemforger_attach_contents')
    var gemforger_reward_panel = $.CreatePanel("Panel", attach_point, "gemforger-reward")
    gemforger_reward_panel.BLoadLayoutSnippet("gemforger_reward");

    gemforger_reward_panel.FindChildTraverse("gemforger_reward_image").SetImage("file://{images}/custom_game/ui/prismatic_gemstone.png")
    $.Msg(msg.gem_reward)
    if (msg.gem_reward > 0){
    	gemforger_reward_panel.FindChildTraverse('gemforger_reward_collect').AddClass('gemforger_reward_active')
    }

    mCloseButton = gemforger_main.FindChildTraverse('close_button')
    mCloseButton.FindChildTraverse('close_button_label').text = $.Localize("ui_close")
   
	gemforger_main.FindChildTraverse('close_button').SetPanelEvent('onactivate', function Close() {
		Game.EmitSound("Gemforger.UI.Close")
		CloseTutorial();
	})

}

function CloseTutorial(){
	var parent = $('#gemforger_container')
	parent.AddClass('invisible')
	parent.RemoveAndDeleteChildren(0)
}

(function()
{
	GameEvents.Subscribe( "open_gemforger", OpenGemforger );
})();
