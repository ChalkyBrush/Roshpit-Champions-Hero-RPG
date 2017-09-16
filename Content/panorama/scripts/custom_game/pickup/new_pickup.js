var pickup_array = []
var pickupCount = 0

function PickupPopup(msg)
{
	var parentPanel = $('#main_pickup_parent')
	var newChildPanel = $.CreatePanel( "Panel", parentPanel, "popup-box" );
	newChildPanel.itemIndex = msg.item
	newChildPanel.heroName = msg.heroId
	newChildPanel.pickup = msg.pickup
	newChildPanel.playerID = msg.playerId
	newChildPanel.keyName = msg.keyName
	newChildPanel.popupIndex = pickupCount
	newChildPanel.BLoadLayout( "file://{resources}/layout/custom_game/new_pickup/pickup_box.xml", false, false );
	pickupCount++;
	pickup_array.push(newChildPanel)
	$.Schedule(10, function(){
		pickupCount--;				
	});

}


(function () {
  GameEvents.Subscribe( "PickupPopup", PickupPopup );
})();
