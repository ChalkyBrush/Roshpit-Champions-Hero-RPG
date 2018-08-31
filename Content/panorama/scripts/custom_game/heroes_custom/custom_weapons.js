function getWeaponIndex(queryUnit, index){
	var heroName = Entities.GetClassname(queryUnit)
	var weaponUpgrades = []
	if (heroName == "npc_dota_hero_dragon_knight"){
		weaponUpgrades = getFlamewakerWeapons(index)
	}else if (heroName == "npc_dota_hero_phantom_assassin"){
		weaponUpgrades = getVoltexWeapons(index)
	}else if (heroName == "npc_dota_hero_necrolyte"){
		weaponUpgrades = getVenoWeapons(index)
	}else if (heroName == "npc_dota_hero_axe"){
		weaponUpgrades = getAxeWeapons(index)
	}else if (heroName == "npc_dota_hero_drow_ranger"){
		weaponUpgrades = getAstralWeapons(index)
	}else if (heroName == "npc_dota_hero_obsidian_destroyer"){
		weaponUpgrades = getEpochWeapons(index)
	}else if (heroName == "npc_dota_hero_omniknight"){
		weaponUpgrades = getPaladinWeapons(index)
	}else if (heroName == "npc_dota_hero_crystal_maiden"){
		weaponUpgrades = getSorcWeapons(index)
	}else if (heroName == "npc_dota_hero_invoker"){
		weaponUpgrades = getConjurorWeapons(index)
	}else if (heroName == "npc_dota_hero_juggernaut"){
		weaponUpgrades = getSeinaruWeapons(index)
	}else if (heroName == "npc_dota_hero_beastmaster"){
		weaponUpgrades = getWarlordWeapons(index)
	}else if (heroName == "npc_dota_hero_leshrac"){
		weaponUpgrades = getBahamutWeapons(index)
	}
	return weaponUpgrades
}

function getFlamewakerWeapons(index){
	var property = ""
	var itemName = ""
	var amount = 0
	if (index == "01"){
		property = "strength"
		amount = 100		
	}
	else if (index == "02"){
		property = "agility"
		amount = 100
	}
	else if (index == "03"){
		property = "intelligence"
		amount = 100
	}
	else if (index == "11"){ 
		property = "strength"
		amount = 200
	}
	else if (index == "12"){
			property = "rune_w_1"
			amount = 12
	}
	else if (index == "13"){
			property = "rune_e_1"
			amount = 20
	}
	else if (index == "14"){
			property = "rune_r_3"
			amount = 15
	}
	else if (index == "21"){
			property = "rune_q_3"
			amount = 20
	}
	else if (index == "22"){
			property = "rune_r_2"
			amount = 20
	}
	else if (index == "23"){
			property = "rune_e_2"
			amount = 20
	}
	else if (index == "24"){
			property = "rune_w_3"
			amount = 20
	}
	else if (index == "25"){
			property = "rune_w_2"
			amount = 3
	}
	itemName = $.Localize("flamewaker_sword_"+index)
	var itemVariant = "item_rpc_flamewaker_sword_"+index
	return [property, itemName, amount, itemVariant]
}

function getVoltexWeapons(index){
	var property = ""
	var itemName = ""
	var amount = 0
	if (index == "01"){
		property = "strength"
		amount = 100		
	}
	else if (index == "02"){
		property = "agility"
		amount = 100
	}
	else if (index == "03"){
		property = "intelligence"
		amount = 100
	}
	else if (index == "11"){ 
		property = "strength"
		amount = 200
	}
	else if (index == "12"){
			property = "rune_r_1"
			amount = 15
	}
	else if (index == "13"){
			property = "rune_q_2"
			amount = 20
	}
	else if (index == "14"){
			property = "rune_e_2"
			amount = 15
	}
	else if (index == "21"){
			property = "rune_w_3"
			amount = 20
	}
	else if (index == "22"){
			property = "strength"
			amount = 225
	}
	else if (index == "23"){
			property = "rune_e_3"
			amount = 20
	}
	else if (index == "24"){
			property = "rune_q_3"
			amount = 15
	}
	else if (index == "25"){
			property = "agility"
			amount = 225
	}
	itemName = $.Localize("voltex_weapon_"+index)
	var itemVariant = "item_rpc_voltex_weapon_"+index
	return [property, itemName, amount, itemVariant]
}

function getAxeWeapons(index){
	var property = ""
	var itemName = ""
	var amount = 0
	if (index == "01"){
		property = "strength"
		amount = 100		
	}
	else if (index == "02"){
		property = "agility"
		amount = 100
	}
	else if (index == "03"){
		property = "intelligence"
		amount = 100
	}
	else if (index == "11"){ 
		property = "strength"
		amount = 160
	}
	else if (index == "12"){
			property = "rune_e_1"
			amount = 12
	}
	else if (index == "13"){
			property = "rune_w_1"
			amount = 12
	}
	else if (index == "14"){
			property = "rune_r_2"
			amount = 15
	}
	else if (index == "21"){
			property = "rune_q_3"
			amount = 16
	}
	else if (index == "22"){
			property = "strength"
			amount = 240
	}
	else if (index == "23"){
			property = "agility"
			amount = 240
	}
	else if (index == "24"){
			property = "rune_w_3"
			amount = 12
	}
	else if (index == "25"){
			property = "rune_r_3"
			amount = 12
	}
	itemName = $.Localize("axe_weapon_"+index)
	var itemVariant = "item_rpc_axe_weapon_"+index
	return [property, itemName, amount, itemVariant]
}

function getPaladinWeapons(index){
	var property = ""
	var itemName = ""
	var amount = 0
	if (index == "01"){
			property = "strength"
			amount = 100		
	}
	else if (index == "02"){
			property = "agility"
			amount = 100
	}
	else if (index == "03"){
			property = "intelligence"
			amount = 100
	}
	else if (index == "11"){ 
			property = "rune_r_1"
			amount = 12
	}
	else if (index == "12"){
			property = "rune_w_2"
			amount = 10
	}
	else if (index == "13"){
			property = "rune_q_1"
			amount = 12
	}
	else if (index == "14"){
			property = "rune_w_1"
			amount = 10
	}
	else if (index == "21"){
			property = "rune_q_3"
			amount = 12
	}
	else if (index == "22"){
			property = "rune_e_3"
			amount = 12
	}
	else if (index == "23"){
			property = "rune_e_2"
			amount = 12
	}
	else if (index == "24"){
			property = "intelligence"
			amount = 225
	}
	else if (index == "25"){
			property = "rune_w_3"
			amount = 10
	}
	itemName = $.Localize("paladin_weapon_"+index)
	var itemVariant = "item_rpc_paladin_weapon_"+index
	return [property, itemName, amount, itemVariant]
}

function getVenoWeapons(index){
	var property = ""
	var itemName = ""
	var amount = 0
	if (index == "01"){
		property = "strength"
		amount = 100		
	}
	else if (index == "02"){
		property = "agility"
		amount = 100
	}
	else if (index == "03"){
		property = "intelligence"
		amount = 100
	}
	else if (index == "11"){ 
		property = "rune_q_1"
		amount = 12
	}
	else if (index == "12"){
			property = "rune_e_1"
			amount = 10
	}
	else if (index == "13"){
			property = "rune_w_1"
			amount = 12
	}
	else if (index == "14"){
			property = "strength"
			amount = 200
	}
	else if (index == "21"){
			property = "rune_r_3"
			amount = 10
	}
	else if (index == "22"){
			property = "agility"
			amount = 225
	}
	else if (index == "23"){
			property = "rune_e_2"
			amount = 20
	}
	else if (index == "24"){
			property = "rune_w_2"
			amount = 15
	}
	else if (index == "25"){
			property = "intelligence"
			amount = 270
	}
	itemName = $.Localize("venomort_weapon_"+index)
	var itemVariant = "item_rpc_venomort_weapon_"+index
	return [property, itemName, amount, itemVariant]
}

function getAstralWeapons(index){
	var property = ""
	var itemName = ""
	var amount = 0
	if (index == "01"){
		property = "strength"
		amount = 100		
	}
	else if (index == "02"){
		property = "agility"
		amount = 100
	}
	else if (index == "03"){
		property = "intelligence"
		amount = 100
	}
	else if (index == "11"){ 
		property = "strength"
		amount = 160
	}
	else if (index == "12"){
			property = "agility"
			amount = 140
	}
	else if (index == "13"){
			property = "rune_e_1"
			amount = 15 
	}
	else if (index == "14"){
			property = "rune_r_1"
			amount = 10
	}
	else if (index == "21"){
			property = "rune_q_2"
			amount = 15
	}
	else if (index == "22"){
			property = "rune_q_3"
			amount = 12
	}
	else if (index == "23"){
			property = "critical_strike"
			amount = 150
	}
	else if (index == "24"){
			property = "rune_r_3"
			amount = 15
	}
	else if (index == "25"){
			property = "rune_r_2"
			amount = 15
	}
	itemName = $.Localize("astral_weapon_"+index)
	var itemVariant = "item_rpc_astral_weapon_"+index
	return [property, itemName, amount, itemVariant]
}

function getSorcWeapons(index){
	var property = ""
	var itemName = ""
	var amount = 0
	if (index == "01"){
		property = "strength"
		amount = 100		
	}
	else if (index == "02"){
		property = "agility"
		amount = 100
	}
	else if (index == "03"){
		property = "intelligence"
		amount = 100
	}
	else if (index == "11"){ 
		property = "rune_r_1"
		amount = 12
	}
	else if (index == "12"){
			property = "rune_r_2"
			amount = 10
	}
	else if (index == "13"){
			property = "rune_q_1"
			amount = 12
	}
	else if (index == "14"){
			property = "rune_w_1"
			amount = 8
	}
	else if (index == "21"){
			property = "rune_r_3"
			amount = 10
	}
	else if (index == "22"){
			property = "rune_w_2"
			amount = 15
	}
	else if (index == "23"){
			property = "rune_q_2"
			amount = 15
	}
	else if (index == "24"){
			property = "rune_w_3"
			amount = 12
	}
	else if (index == "25"){
			property = "rune_e_2"
			amount = 20
	}
	itemName = $.Localize("sorceress_weapon_"+index)
	var itemVariant = "item_rpc_sorceress_weapon_"+index
	return [property, itemName, amount, itemVariant]
}

function getEpochWeapons(index){
	var property = ""
	var itemName = ""
	var amount = 0
	if (index == "01"){
		property = "strength"
		amount = 100		
	}
	else if (index == "02"){
		property = "agility"
		amount = 100
	}
	else if (index == "03"){
		property = "intelligence"
		amount = 100
	}
	else if (index == "11"){ 
		property = "rune_q_1"
		amount = 10
	}
	else if (index == "12"){
			property = "rune_r_1"
			amount = 10
	}
	else if (index == "13"){
			property = "rune_w_1"
			amount = 10
	}
	else if (index == "14"){
			property = "strength"
			amount = 240
	}
	else if (index == "21"){
			property = "rune_e_2"
			amount = 10
	}
	else if (index == "22"){
			property = "rune_r_2"
			amount = 15
	}
	else if (index == "23"){
			property = "rune_q_2"
			amount = 10
	}
	else if (index == "24"){
			property = "rune_w_2"
			amount = 10
	}
	else if (index == "25"){
			property = "rune_w_3"
			amount = 10
	}
	itemName = $.Localize("epoch_weapon_"+index)
	var itemVariant = "item_rpc_epoch_weapon_"+index
	return [property, itemName, amount, itemVariant]
}

function getConjurorWeapons(index){
	var property = ""
	var itemName = ""
	var amount = 0
	if (index == "01"){
		property = "strength"
		amount = 100		
	}
	else if (index == "02"){
		property = "agility"
		amount = 100
	}
	else if (index == "03"){
		property = "intelligence"
		amount = 100
	}
	else if (index == "11"){ 
		property = "strength"
		amount = 180
	}
	else if (index == "12"){
			property = "attack_damage"
			amount = 500
	}
	else if (index == "13"){
			property = "rune_q_2"
			amount = 10
	}
	else if (index == "14"){
			property = "intelligence"
			amount = 240
	}
	else if (index == "21"){
			property = "agility"
			amount = 400
	}
	else if (index == "22"){
			property = "rune_e_2"
			amount = 12
	}
	else if (index == "23"){
			property = "rune_e_3"
			amount = 10
	}
	else if (index == "24"){
			property = "rune_w_3"
			amount = 12
	}
	else if (index == "25"){
			property = "rune_w_2"
			amount = 10
	}
	itemName = $.Localize("conjuror_weapon_"+index)
	var itemVariant = "item_rpc_conjuror_weapon_"+index
	return [property, itemName, amount, itemVariant]
}



function getSeinaruWeapons(index){
	var property = ""
	var itemName = ""
	var amount = 0
	if (index == "01"){
		property = "strength"
		amount = 100		
	}
	else if (index == "02"){
		property = "agility"
		amount = 100
	}
	else if (index == "03"){
		property = "intelligence"
		amount = 100
	}
	else if (index == "11"){ 
		property = "agility"
		amount = 160
	}
	else if (index == "12"){
			property = "rune_e_1"
			amount = 12
	}
	else if (index == "13"){
			property = "rune_r_1"
			amount = 12
	}
	else if (index == "14"){
			property = "rune_w_1"
			amount = 10
	}
	else if (index == "21"){
			property = "rune_q_1"
			amount = 20
	}
	else if (index == "22"){
			property = "rune_q_3"
			amount = 20
	}
	else if (index == "23"){
			property = "strength"
			amount = 210
	}
	else if (index == "24"){
			property = "rune_q_2"
			amount = 25
	}
	else if (index == "25"){
			property = "intelligence"
			amount = 320
	}
	itemName = $.Localize("seinaru_weapon_"+index)
	var itemVariant = "item_rpc_seinaru_weapon_"+index
	return [property, itemName, amount, itemVariant]
}

function getWarlordWeapons(index){
	var property = ""
	var itemName = ""
	var amount = 0
	if (index == "01"){
		property = "strength"
		amount = 100		
	}
	else if (index == "02"){
		property = "agility"
		amount = 100
	}
	else if (index == "03"){
		property = "intelligence"
		amount = 100
	}
	else if (index == "11"){ 
		property = "rune_q_1"
		amount = 10
	}
	else if (index == "12"){
			property = "splash_damage"
			amount = 25
	}
	else if (index == "13"){
			property = "rune_q_3"
			amount = 10
	}
	else if (index == "14"){
			property = "rune_q_2"
			amount = 10
	}
	else if (index == "21"){
			property = "rune_e_1"
			amount = 20
	}
	else if (index == "22"){
			property = "rune_e_3"
			amount = 12
	}
	else if (index == "23"){
			property = "rune_w_2"
			amount = 15
	}
	else if (index == "24"){
			property = "rune_w_3"
			amount = 10
	}
	else if (index == "25"){
			property = "rune_w_1"
			amount = 10
	}
	itemName = $.Localize("warlord_weapon_"+index)
	var itemVariant = "item_rpc_warlord_weapon_"+index
	return [property, itemName, amount, itemVariant]
}

function getBahamutWeapons(index){
	var property = ""
	var itemName = ""
	var amount = 0
	if (index == "01"){
		property = "strength"
		amount = 100		
	}
	else if (index == "02"){
		property = "agility"
		amount = 100
	}
	else if (index == "03"){
		property = "intelligence"
		amount = 100
	}
	else if (index == "11"){ 
		property = "rune_e_1"
		amount = 12
	}
	else if (index == "12"){
			property = "rune_w_1"
			amount = 12
	}
	else if (index == "13"){
			property = "rune_e_2"
			amount = 10
	}
	else if (index == "14"){
			property = "rune_q_1"
			amount = 10
	}
	else if (index == "21"){
			property = "rune_e_3"
			amount = 10
	}
	else if (index == "22"){
			property = "strength"
			amount = 220
	}
	else if (index == "23"){
			property = "rune_w_2"
			amount = 15
	}
	else if (index == "24"){
			property = "rune_r_2"
			amount = 10
	}
	else if (index == "25"){
			property = "rune_w_3"
			amount = 10
	}
	itemName = $.Localize("bahamut_weapon_"+index)
	var itemVariant = "item_rpc_bahamut_weapon_"+index
	return [property, itemName, amount, itemVariant]
}

function convertPropertyToNameAndColor(property){
	var title = ""
	var titleColor = "#FFFFFF"
	var tooltip = ""
	if (property=="strength"){
		title = "#item_strength"
		titleColor = "#CC0000"
		tooltip = '#upgrade_tooltip_'+property
	}else if (property=="agility"){
		title = "#item_agility"
		titleColor = "#2EB82E"
		tooltip = '#upgrade_tooltip_'+property	
	}else if (property=="intelligence"){
		title = "#item_intelligence"
		titleColor = "#33CCFF"	
		tooltip = '#upgrade_tooltip_'+property
	}else if (property=="critical_strike"){
		title = "#item_critical_strike"
		titleColor = "#CC3D3D"	
		tooltip = '#upgrade_tooltip_'+property
	}else if (property=="splash_damage"){
		title = "#item_splash_damage"
		titleColor = "#CC3D3D"	
		tooltip = '#upgrade_tooltip_'+property
	}else if (property=="attack_damage"){
		title = "#item_bonus_attack_damage"
		titleColor = "#343EC9"	
		tooltip = '#upgrade_tooltip_'+property
	}else{
		title = property
		titleColor = "#7DFF12"	
		tooltip = '#upgrade_tooltip_rune'		
	}
	return [title, titleColor, tooltip]
}

function getUpgradePanelIndex(currentIndex){
	var upgradePanelIndex = "00"
	if (currentIndex == "00"){
		upgradePanelIndex = "1"
	}else if (currentIndex == "01"){
		upgradePanelIndex = "21"
	}else if (currentIndex == "02"){
		upgradePanelIndex = "22"
	}else if (currentIndex == "03"){
		upgradePanelIndex = "23"
	}else if (currentIndex == "11"){
		upgradePanelIndex = "31"
	}else if (currentIndex == "12"){
		upgradePanelIndex = "32"
	}else if (currentIndex == "13"){
		upgradePanelIndex = "33"
	}else if (currentIndex == "14"){
		upgradePanelIndex = "34"
	}

	return upgradePanelIndex
}

function runeTranslate(queryUnit, rune){
	var heroName = Entities.GetClassname(queryUnit)
	var runeName = ""
	if (heroName == "npc_dota_hero_dragon_knight"){
		runeName = "flamewaker_"+rune
	}else if (heroName == "npc_dota_hero_phantom_assassin"){
		runeName = "voltex_"+rune
	}else if (heroName == "npc_dota_hero_necrolyte"){
		runeName = "venomort_"+rune
	}else if (heroName == "npc_dota_hero_axe"){
		runeName = "axe_"+rune
	}else if (heroName == "npc_dota_hero_drow_ranger"){
		runeName = "astral_"+rune
	}else if (heroName == "npc_dota_hero_obsidian_destroyer"){
		runeName = "epoch_"+rune
	}else if (heroName == "npc_dota_hero_omniknight"){
		runeName = "paladin_"+rune
	}else if (heroName == "npc_dota_hero_crystal_maiden"){
		runeName = "sorceress_"+rune
	}else if (heroName == "npc_dota_hero_invoker"){
		runeName = "conjuror_"+rune
	}else if (heroName == "npc_dota_hero_juggernaut"){
		runeName = "monk_"+rune
	}else if (heroName == "npc_dota_hero_beastmaster"){
		runeName = "warlord_"+rune
	}else if (heroName == "npc_dota_hero_leshrac"){
		runeName = "bahamut_"+rune
	}
	return $.Localize("DOTA_Tooltip_Ability_"+runeName)
}