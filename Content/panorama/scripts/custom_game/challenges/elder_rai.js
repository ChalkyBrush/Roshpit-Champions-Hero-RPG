gemforge_item = -1
mTooltipPanel = null

function OpenElderRai(msg){
	$.Msg("GEM FORGER")
	var parent = $('#elder_rai_container')
	parent.RemoveClass('invisible')
	parent.AddClass('animateEaseClass')
	parent.RemoveClass('animateEaseOutClass')
	parent.RemoveAndDeleteChildren(0)
    var elder_rai_main = $.CreatePanel("Panel", parent, "elder_rai-main")
    elder_rai_main.BLoadLayoutSnippet("elder_rai_main");
    var header = elder_rai_main.FindChildTraverse('elder_rai_header')
    var imageName = "file://{images}/custom_game/ui/elder_rai_header.jpg"
    header.SetImage(imageName)

    mCloseButton = elder_rai_main.FindChildTraverse('close_button')
    mCloseButton.FindChildTraverse('close_button_label').text = $.Localize("ui_close")
   
	elder_rai_main.FindChildTraverse('close_button').SetPanelEvent('onactivate', function Close() {
		Game.EmitSound("Gemforger.UI.Close")
		CloseElderRai();
	})

}


function CloseElderRai(){
	var parent = $('#elder_rai_container')
	parent.AddClass('invisible')
	parent.RemoveAndDeleteChildren(0)
	if (GameUI.CustomUIConfig().gemforge == 1){
		clearGearHighlighter()
	}
	mTooltipPanel = null
}



(function()
{
	GameEvents.Subscribe( "open_elder_rai", OpenElderRai );
	GameEvents.Subscribe( "close_elder_rai", CloseElderRai );

})();
