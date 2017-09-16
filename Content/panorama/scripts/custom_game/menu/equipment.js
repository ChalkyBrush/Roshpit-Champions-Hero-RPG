function InitializeEquipment()
{
	GameUI.CustomUIConfig().equipmentParent = $('#main_equipment_parent').GetParent()
	GameUI.CustomUIConfig().weaponParent = $('#weapon_lvlup')
	GameUI.CustomUIConfig().equipmentContainer = $('#main_equipment_container')
}

(function()
{
	InitializeEquipment();
})();
