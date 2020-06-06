var updateTooltip = false;
var currentSlot = -1
var extraTooltipsActive = false;

function AbilityShowTooltip(element)
{
    var slot = element.GetAttributeInt("abilityIndex", 0)
    currentSlot = slot
    var currentAbility = -1
    var m_QueryUnit = Players.GetLocalPlayerPortraitUnit()
    for (i = 0; i < Entities.GetAbilityCount(m_QueryUnit) - 1; i++) {
        var ability = Entities.GetAbility(m_QueryUnit, i)
        if (!Abilities.IsHidden(ability)){
            currentAbility += 1;
        }
        if (currentAbility == slot) {
            slot = i;
            break;
        }
    }
	var m_Ability = Entities.GetAbility(m_QueryUnit, slot)
	var abilityName = Abilities.GetAbilityName( m_Ability );
	$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", element, abilityName, m_QueryUnit);

	if (extraTooltipsActive){
		AbilityShowExtraTooltip(m_QueryUnit, slot)
	}
}

function AbilityShowExtraTooltip(unit, slot) {
	var tooltipLabel = GameUI.DotaHUD.FindChildTraverse("AbilityExtraAttributes");
	var parent = tooltipLabel.GetParent()

	var roshpitAttributes = parent.FindChildTraverse("roshpit_attributes_tooltip")

	if(roshpitAttributes === null){
		roshpitAttributes = $.CreatePanel("Label", parent, "roshpit_attributes_tooltip")
	}
	
	roshpitAttributes.text = GetRoshpitAbilityTooltip(unit, slot)
	parent.MoveChildAfter(roshpitAttributes, tooltipLabel);
	roshpitAttributes.style.color = "#FFFFFF"
	roshpitAttributes.style.padding = "0px 0px 0px 8px";
	roshpitAttributes.html = true
	updateTooltip = true;
	roshpitAttributes.ApplyStyles(true)
	UpdateTooltip(roshpitAttributes, unit, slot);
}

function AbilityHideTooltip(element)
{
	$.DispatchEvent( "DOTAHideAbilityTooltip", element );
    
	if (extraTooltipsActive){
		AbilityHideExtraTooltip();
	}
}

function AbilityHideExtraTooltip(){
	var tooltipLabel = GameUI.DotaHUD.FindChildTraverse("AbilityExtraAttributes");
	var parent = tooltipLabel.GetParent()
	var roshpitAttributes = parent.FindChildTraverse("roshpit_attributes_tooltip")
	roshpitAttributes.text = "";
	updateTooltip = false;
}

function UpdateTooltip(element, unit, slot)
{
	if(updateTooltip && currentSlot == slot){
        $.Schedule(0.03, () => UpdateTooltip(element, unit, slot))
        element.text = GetRoshpitAbilityTooltip(unit, slot);
    }
}

function GetRoshpitAbilityTooltip(unit, slot)
{
    var tooltip = "";
	var tooltips = CustomNetTables.GetTableValue("tooltip", unit.toString() + "-" + slot)
    if(tooltips == undefined)
        return "";
    $.Each(tooltips, function(value, index){
		if (value.itemIndex !== undefined 
			&& (value.immortal == true 
				|| (value.ruby !== undefined && value.ruby > 0) 
				|| (value.sapphire !== undefined && value.sapphire > 0)
				|| (value.emerald !== undefined && value.emerald > 0)
				|| (value.amethyst !== undefined && value.amethyst > 0))){
			var itemName = Abilities.GetAbilityName(value.itemIndex)
			var name = itemName.replace("item_rpc_", "")
			tooltip += "<br/><font color='#E4AE33'>" + $.Localize("DOTA_Tooltip_ability_item_rpc_" + name) + "</font><br/>";
			if (value.immortal == true){
				tooltip += "<font color='" + value.color + "'>" + $.Localize("item_property_" + name) + ": </font>" + $.Localize("item_rpc_" + name + "_ability_tooltip") + "<br/>";
			}
			if (value.ruby !== undefined && value.ruby > 0){
				var rubyTooltip = $.Localize("item_rpc_" + name + "_ability_ruby_tooltip")
				rubyTooltip = ReplaceGemProperties(rubyTooltip, "ruby", value.ruby, value.itemIndex)
				tooltip += "<font color='" + GetGemColor("ruby") + "'>Ruby: </font>" + rubyTooltip + "<br/>";
			}
			if (value.sapphire !== undefined && value.sapphire > 0){
				var sapphireTooltip = $.Localize("item_rpc_" + name + "_ability_sapphire_tooltip")
				sapphireTooltip = ReplaceGemProperties(sapphireTooltip, "sapphire", value.sapphire, value.itemIndex)
				tooltip += "<font color='" + GetGemColor("sapphire") + "'>Sapphire: </font>" + sapphireTooltip + "<br/>";
			}
			if (value.emerald !== undefined && value.emerald > 0){
				var emeraldTooltip = $.Localize("item_rpc_" + name + "_ability_emerald_tooltip")
				emeraldTooltip = ReplaceGemProperties(emeraldTooltip, "emerald", value.emerald, value.itemIndex)
				tooltip += "<font color='" + GetGemColor("emerald") + "'>Emerald: </font>" + emeraldTooltip + "<br/>";
			}
			if (value.amethyst !== undefined && value.amethyst > 0){
				var amethystTooltip = $.Localize("item_rpc_" + name + "_ability_amethyst_tooltip")
				amethystTooltip = ReplaceGemProperties(amethystTooltip, "amethyst", value.amethyst, value.itemIndex)
				tooltip += "<font color='" + GetGemColor("amethyst") + "'>Amethyst: </font>" + amethystTooltip + "<br/>";
			}
		}
		else if (value.channeltime !== undefined) {
			tooltip = "<font color='#596e89'>CHANNELTIME: </font>" + value.channeltime + "s"
		}
    })
	return tooltip
}

function ReplaceGemProperties(description, gem, gem_level, item){
	var substitution_color = GetGemColor(gem)
	for (var i = 1; i <= 5; i++) {
		var value_name = gem+i
		var value = Abilities.GetLevelSpecialValueFor( item, value_name, gem_level - 1 )
		value = Math.round(value*100)/100
		description = description.replace("@"+gem+"_property"+i, "<font color='"+substitution_color+"'>"+value+"</font>")
	}
	return description
}

function GetGemColor(gem){
	var substitution_color = "#DDDDDD"
	if (gem == "ruby"){
		substitution_color = "#f02929"
	}else if(gem == "emerald"){
		substitution_color = "#36d63b"
	}else if (gem == "sapphire"){
		substitution_color = "#388af5"
	}else if (gem == "amethyst"){
		substitution_color = "#c744b8"
	}	
	return substitution_color
}

function ToggleExtraTooltips() {
	if (extraTooltipsActive){
		extraTooltipsActive = false;
		AbilityHideExtraTooltip();
	}
	else{
		extraTooltipsActive = true;
	}
}



(function()
{
	GameEvents.Subscribe( "toggleExtraTooltips", ToggleExtraTooltips );
})();