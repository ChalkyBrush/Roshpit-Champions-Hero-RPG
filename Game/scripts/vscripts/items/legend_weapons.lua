function Weapons:RollLegendWeaponVariantWithAbilityName(abilityName, strictMaxItemLevel, position, disableDrop)
	if string.match(abilityName, "item_rpc_") then--item_rpc_hydroxis_immortal_weapon_3
		abilityName = string.gsub(abilityName, "item_rpc_", "")
		local class = nil
		if string.match(abilityName, "_immortal_weapon_1") then
			class = string.gsub(abilityName, "_immortal_weapon_1", "")
			return Weapons:RollLegendWeapon1(position, class, strictMaxItemLevel, disableDrop)
		elseif string.match(abilityName, "_immortal_weapon_2_a") then
			return Weapons:RollJexLegendWeapon2a(position, disableDrop)
		elseif string.match(abilityName, "_immortal_weapon_2") then
			class = string.gsub(abilityName, "_immortal_weapon_2", "")
			return Weapons:RollLegendWeapon2(position, class, strictMaxItemLevel, disableDrop)
		elseif string.match(abilityName, "_immortal_weapon_3") then
			class = string.gsub(abilityName, "_immortal_weapon_3", "")
			return Weapons:RollLegendWeapon3(position, class, strictMaxItemLevel, disableDrop)
		end
	end
end

function Weapons:RollRandomLegendWeapon1(deathLocation)
	local classTable = HerosCustom:GetInternalNameTable()
	local class = classTable[RandomInt(1, #classTable)]
	Weapons:RollLegendWeapon1(deathLocation, class)
end

function Weapons:RollLegendWeapon1WithDotaName(class, deathLocation)
	local classTable = HerosCustom:GetInternalNameTable()
	class = HerosCustom:GetInternalHeroNameMain(class)
	Weapons:RollLegendWeapon1(deathLocation, class)
end

function Weapons:RollRandomLegendWeapon2(deathLocation)
	local classTable = HerosCustom:GetInternalNameTable()
	local class = classTable[RandomInt(1, #classTable)]
	Weapons:RollLegendWeapon2(deathLocation, class)
end

function Weapons:RollLegendWeapon2WithDotaName(class, deathLocation)
	local classTable = HerosCustom:GetInternalNameTable()
	class = HerosCustom:GetInternalHeroNameMain(class)
	Weapons:RollLegendWeapon2(deathLocation, class)
end

function Weapons:RollRandomLegendWeapon3(deathLocation)
	local classTable = HerosCustom:GetInternalNameTable()
	local class = classTable[RandomInt(1, #classTable)]
	Weapons:RollLegendWeapon3(deathLocation, class)
end

function Weapons:RollLegendWeapon3WithDotaName(class, deathLocation)
	local classTable = HerosCustom:GetInternalNameTable()
	class = HerosCustom:GetInternalHeroNameMain(class)
	Weapons:RollLegendWeapon3(deathLocation, class)
end

function Weapons:SetLegendWeaponProperty1(weapon, hero_name, propertyName, propertyColor, propertyMult)
	if propertyName == "immortal_weapon_1" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = propertyName
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_"..hero_name.."_immortal_weapon", propertyColor, 1, "#property_"..hero_name.."_immortal_weapon_description")
	else
		weapon.newItemTable.property1 = RPCItems:RollGearAttributeValue(weapon.newItemTable.minLevel, nil, nil, Weapons.AttributeBaseRolls[propertyName]*propertyMult)
		weapon.newItemTable.property1name = propertyName
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property1, "#item_"..propertyName, RPCItems.PROPERTY_COLORS[propertyName], 1)
	end
end

function Weapons:SetLegendWeaponProperty1Alt(weapon, hero_name, propertyName, propertyColor, propertyMult, weapon_number)
	if propertyName == "immortal_weapon_1" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = propertyName
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_"..hero_name.."_immortal_weapon"..weapon_number, propertyColor, 1, "#property_"..hero_name.."_immortal_weapon"..weapon_number.."_description")
	else
		weapon.newItemTable.property1 = RPCItems:RollGearAttributeValue(weapon.newItemTable.minLevel, nil, nil, Weapons.AttributeBaseRolls[propertyName]*propertyMult)
		weapon.newItemTable.property1name = propertyName
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property1, "#item_"..propertyName, RPCItems.PROPERTY_COLORS[propertyName], 1)
	end
end

function Weapons:SetLegendWeaponProperty2(weapon, propertyName, propertyMult)
	weapon.newItemTable.property2 = RPCItems:RollGearAttributeValue(weapon.newItemTable.minLevel, nil, nil, Weapons.AttributeBaseRolls[propertyName]*propertyMult)
	weapon.newItemTable.property2name = propertyName
	RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_"..propertyName, RPCItems.PROPERTY_COLORS[propertyName], 2)
end

function Weapons:RollLegendWeapon1(location, class, strictMaxItemLevel, disableDrop)
	local rarity = RPC_ITEMS_RARITY_IMMORTAL
	local itemName = ""
	local item_level = RPCItems:RollItemLevelFromUnit(100)
	local mainAttrRoll = RandomInt(1, 3)
	local internalName = class
	local whichHero = HerosCustom:ConvertRPCNameToStringHeroNameSeinaru(class)
	local maxLevel = 10

	local weaponName = "item_rpc_"..internalName.."_immortal_weapon_1"

	local weapon = Weapons:CreateWeaponVariant(weaponName, rarity, "", "weapon", true, "Slot: Weapon", whichHero, maxLevel, 100)
	weapon.newItemTable.minLevel = item_level
	if internalName == "conjuror" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "aspect_health", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "base_ability", 3)
	elseif internalName == "flamewaker" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#E06647", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "strength", 2)
	elseif internalName == "voltex"	then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#31EBEB", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "attack_damage", 2)
	elseif internalName == "venomort" then	
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#62DE72", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "base_ability", 2)
	elseif internalName == "axe" then	
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#D62B2B", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "strength", 2)
	elseif internalName == "astral" then	
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#BCA7E8", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "all_attributes", 2)
	elseif internalName == "epoch" then	
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#42F48F", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "attack_damage", 2)
	elseif internalName == "paladin" then	
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#E3ED87", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "strength", 2)
	elseif internalName == "sorceress" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "base_ability", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "intelligence", 3)
	elseif internalName == "seinaru" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#60FC63", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "agility", 2)
	elseif internalName == "warlord" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#F7E845", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "base_ability", 2)
	elseif internalName == "bahamut" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#ADFFFF", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "base_ability", 2)
	elseif internalName == "auriun" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#E2FF70", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "intelligence", 2)
	elseif internalName == "duskbringer" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#8FDBCB", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "strength", 2)
	elseif internalName == "trapper" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "attack_damage", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "base_ability", 3)
	elseif internalName == "spirit_warrior" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#5AE8A8", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "attack_damage", 2)
	elseif internalName == "mountain_protector" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#C96E34", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "base_ability", 2)
	elseif internalName == "chernobog" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#457CF5", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "attack_damage", 2)
	elseif internalName == "solunia" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#4286F4", nil)
		local luck = RandomInt(1, 2)
		if luck == 1 then
			Weapons:SetLegendWeaponProperty2(weapon, "attack_damage", 2)
		else
			Weapons:SetLegendWeaponProperty2(weapon, "agility", 2)
		end
	elseif internalName == "hydroxis" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#4286F4", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "strength", 2)
	elseif internalName == "ekkan" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#BAC2D1", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "attack_damage", 2)
	elseif internalName == "zonik" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#00FF8C", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "strength", 2)
	elseif internalName == "arkimus" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#D84ED1", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "agility", 2)
	elseif internalName == "djanghor" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#A4EDA3", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "agility", 2)
	elseif internalName == "slipfinn" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#4286F4", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "agility", 2)
	elseif internalName == "sephyr" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#8AF473", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "intelligence", 2)
	elseif internalName == "dinath" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#6BA3FF", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "strength", 2)
	elseif internalName == "jex" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#69BC71", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "attack_damage", 2)
	elseif internalName == "omniro" then
		Weapons:SetLegendWeaponProperty1(weapon, internalName, "immortal_weapon_1", "#F26AE6", nil)
		Weapons:SetLegendWeaponProperty2(weapon, "base_ability", 2)
	end


	local property = RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_WEAPON][RandomInt(1, #RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_WEAPON])]
	if property == "t1_rune" or property == "t2_rune" or property == "t3_rune" or property == "t4_rune" then
		weapon.newItemTable.property3 = RPCItems:RollGearAttributeValue(item_level, nil, nil, Weapons.AttributeBaseRolls[property])
		weapon.newItemTable.property3name = RPCItems:TranslateRuneRoll(property)
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property3, "rune", "#7DFF12", 3)
	else
		weapon.newItemTable.property3 = RPCItems:RollGearAttributeValue(item_level, nil, nil, Weapons.AttributeBaseRolls[property])
		weapon.newItemTable.property3name = property
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property3, "item_"..property, RPCItems.PROPERTY_COLORS[property], 3)
	end

	local property = RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_WEAPON][RandomInt(1, #RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_WEAPON])]
	if property == "t1_rune" or property == "t2_rune" or property == "t3_rune" or property == "t4_rune" then
		weapon.newItemTable.property4 = RPCItems:RollGearAttributeValue(item_level, nil, nil, Weapons.AttributeBaseRolls[property])
		weapon.newItemTable.property4name = RPCItems:TranslateRuneRoll(property)
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property4, "rune", "#7DFF12", 4)
	else
		weapon.newItemTable.property4 = RPCItems:RollGearAttributeValue(item_level, nil, nil, Weapons.AttributeBaseRolls[property])
		weapon.newItemTable.property4name = property
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property4, "item_"..property, RPCItems.PROPERTY_COLORS[property], 4)
	end

	RPCItems:SetBaseItemValues(weapon, item_variant, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, RPC_GEAR_SLOT_WEAPON)
	if not disableDrop then
		RPCItems:BasicDropItem(location, weapon)
	end
	return weapon
end

function Weapons:RollLegendWeapon2(deathLocation, class, strictMaxItemLevel, disableDrop)
	local rarity = RPC_ITEMS_RARITY_IMMORTAL
	local itemName = ""
	local item_level = RPCItems:RollItemLevelFromUnit(100)
	local mainAttrRoll = RandomInt(1, 3)
	local internalName = class
	local whichHero = HerosCustom:ConvertRPCNameToStringHeroNameSeinaru(class)
	local maxLevel = 10

	local weaponName = "item_rpc_"..internalName.."_immortal_weapon_2"

	local weapon = Weapons:CreateWeaponVariant(weaponName, rarity, "", "weapon", true, "Slot: Weapon", whichHero, maxLevel, 100)
	weapon.newItemTable.minLevel = item_level
	if internalName == "flamewaker" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#E06647", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "agility", 2)
	elseif internalName == "voltex"	then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "all_attributes", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "agility", 3)
	elseif internalName == "venomort" then	
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#82C46D", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "attack_damage", 2)
	elseif internalName == "axe" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#FC643F", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "element_normal", 1)
	elseif internalName == "astral" then	
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#A86BFF", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "armor_pierce", 3)
	elseif internalName == "epoch" then	
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#6BEF9A", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "strength", 2)
	elseif internalName == "paladin" then	
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#82C46D", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "element_holy", 2)
	elseif internalName == "sorceress" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#93F3F9", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "strength", 2)
	elseif internalName == "conjuror" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#C4FFE6", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "all_attributes", 2)
	elseif internalName == "seinaru" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#8BEFA4", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "element_wind", 3)
	elseif internalName == "warlord" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#D6CF82", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "intelligence", 3)
	elseif internalName == "bahamut" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#9EFFF2", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "intelligence", 3)
	elseif internalName == "auriun" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#FFF95B", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "intelligence", 3)
	elseif internalName == "duskbringer" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#9EE2D3", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "element_ghost", 3)
	elseif internalName == "trapper" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#C1A6A7", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "element_normal", 1.5)
	elseif internalName == "spirit_warrior" then
		local luck = RandomInt(1, 4)
		if luck == 1 then
			Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "strength", nil, 3)
		elseif luck == 2 then
			Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "agility", nil, 3)
		elseif luck == 3 then
			Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "intelligence", nil, 3)
		elseif luck == 4 then
			Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "spirit", nil, 3)
		end
		local luck = RandomInt(1, 3)
		if luck == 1 then
			Weapons:SetLegendWeaponProperty2(weapon, "element_fire", 3)
		elseif luck == 2 then
			Weapons:SetLegendWeaponProperty2(weapon, "element_wind", 3)
		elseif luck == 3 then
			Weapons:SetLegendWeaponProperty2(weapon, "element_water", 3)
		end
	elseif internalName == "mountain_protector" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#AF2B2B", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "attack_damage", 2)
	elseif internalName == "chernobog" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#817BAD", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "element_demon", 2)
	elseif internalName == "solunia" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#90D7ED", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "attack_damage", 2)
	elseif internalName == "hydroxis" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#6D78BA", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "attack_damage", 2)
	elseif internalName == "ekkan" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#99B0C1", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "attack_damage", 2)
	elseif internalName == "zonik" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "movespeed", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "element_time", 3)
	elseif internalName == "arkimus" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#CC92E8", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "attack_damage", 2)
	elseif internalName == "djanghor" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#E54E4E", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "strength", 2)
	elseif internalName == "slipfinn" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#3D6DBA", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "attack_damage", 2)
	elseif internalName == "sephyr" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#6de253", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "agility", 2)
	elseif internalName == "dinath" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#83eafc", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "attack_damage", 2)
	elseif internalName == "jex" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#5CCDF9", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "attack_damage", 2)
	elseif internalName == "omniro" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#c7eefc", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "agility", 2)
	end


	local property = RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_WEAPON][RandomInt(1, #RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_WEAPON])]
	if property == "t1_rune" or property == "t2_rune" or property == "t3_rune" or property == "t4_rune" then
		weapon.newItemTable.property3 = RPCItems:RollGearAttributeValue(item_level, nil, nil, Weapons.AttributeBaseRolls[property])
		weapon.newItemTable.property3name = RPCItems:TranslateRuneRoll(property)
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property3, "rune", "#7DFF12", 3)
	else
		weapon.newItemTable.property3 = RPCItems:RollGearAttributeValue(item_level, nil, nil, Weapons.AttributeBaseRolls[property])
		weapon.newItemTable.property3name = property
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property3, "item_"..property, RPCItems.PROPERTY_COLORS[property], 3)
	end

	local property = RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_WEAPON][RandomInt(1, #RPCItems.REGULAR_PROPERTIES[RPC_GEAR_SLOT_WEAPON])]
	if property == "t1_rune" or property == "t2_rune" or property == "t3_rune" or property == "t4_rune" then
		weapon.newItemTable.property4 = RPCItems:RollGearAttributeValue(item_level, nil, nil, Weapons.AttributeBaseRolls[property])
		weapon.newItemTable.property4name = RPCItems:TranslateRuneRoll(property)
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property4, "rune", "#7DFF12", 4)
	else
		weapon.newItemTable.property4 = RPCItems:RollGearAttributeValue(item_level, nil, nil, Weapons.AttributeBaseRolls[property])
		weapon.newItemTable.property4name = property
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property4, "item_"..property, RPCItems.PROPERTY_COLORS[property], 4)
	end

	RPCItems:SetBaseItemValues(weapon, item_variant, false, RPCItems.BASIC_ITEMS_SLOT_TEXT[item_slot], RPC_ITEM_RARITY_COLORS[rarity], RPCItems:GetRarityNameFromFactor(rarity), rarity, item_level, RPC_GEAR_SLOT_WEAPON)
	if not disableDrop then
		RPCItems:BasicDropItem(location, weapon)
	end
	return weapon
end

function Weapons:RollLegendWeapon3(deathLocation, class, strictMaxItemLevel, disableDrop)

	local maxFactor = RPCItems:GetMaxFactor()
	local rarityRoll = RandomInt(1, 100 + RandomInt(1, maxFactor))
	local rarity = "immortal"
	local itemName = ""
	local mainAttrRoll = RandomInt(1, 3)
	local internalName = class
	local whichHero = HerosCustom:ConvertRPCNameToStringHeroNameSeinaru(class)
	local rarityFactor = RPCItems:GetRarityFactor(rarity)
	local maxLevel = math.min(RPCItems:GetLogarithmicVarianceValue(48, 0, 0, 0, 0), 50)
	maxLevel = math.max(maxLevel, 50)
	if strictMaxItemLevel then
		maxLevel = strictMaxItemLevel
	end
	local maxLuck = RandomInt(1, 200)

	local propertyTable, baseValueTable, propensityTable, tooltipTable, colorTable = HerosCustom:GetAvailableRunes(whichHero)
	local specialProperty1 = RandomInt(1, #propensityTable)
	local specialProperty2 = RandomInt(1, #propensityTable)
	while specialProperty1 == specialProperty2 do
		specialProperty2 = RandomInt(1, #propensityTable)
	end
	local weaponName = "item_rpc_"..internalName.."_immortal_weapon_3"

	local weapon = Weapons:CreateWeaponVariant(weaponName, rarity, "", "weapon", true, "Slot: Weapon", whichHero, maxLevel, 100)

	if internalName == "flamewaker" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_flamewaker_immortal_weapon3", "#E06647", 1, "#property_flamewaker_immortal_weapon3_description")

		local value = Weapons:GetDeviation(17 + RandomInt(8, 21), rarityFactor)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = "strength"
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_strength", "#CC0000", 2)
	elseif internalName == "voltex" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_voltex_immortal_weapon3", "#88ECF7", 1, "#property_voltex_immortal_weapon3_description")

		local value = Weapons:GetDeviation(28 + RandomInt(5, 25), rarityFactor)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = "agility"
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_agility", "#2EB82E", 2)
	elseif internalName == "venomort" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_venomort_immortal_weapon3", "#82C46D", 1, "#property_venomort_immortal_weapon3_description")

		local value = math.min(Weapons:GetDeviation(5, rarityFactor), RandomInt(2, 8))
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_POISON)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = name
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#rpc_item_element"..RPC_ELEMENT_POISON, color, 2)
	elseif internalName == "axe" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_axe_immortal_weapon3", "#EDDFDC", 1, "#property_axe_immortal_weapon3_description")

		local value = RandomInt(1, 5)
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_NORMAL)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = name
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#rpc_item_element"..RPC_ELEMENT_NORMAL, color, 2)
	elseif internalName == "astral" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_astral_immortal_weapon3", "#BC96F2", 1, "#property_astral_immortal_weapon3_description")

		local value = math.min(Weapons:GetDeviation(5, rarityFactor), RandomInt(2, 7))
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_COSMOS)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = name
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#rpc_item_element"..RPC_ELEMENT_COSMOS, color, 2)
	elseif internalName == "epoch" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_epoch_immortal_weapon3", "#6EB788", 1, "#property_epoch_immortal_weapon3_description")

		local value = Weapons:GetDeviation(16 + RandomInt(5, 18), rarityFactor)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = "intelligence"
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)
	elseif internalName == "paladin" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_paladin_immortal_weapon3", "#82C46D", 1, "#property_paladin_immortal_weapon3_description")

		local value = Weapons:GetDeviation(7 + RandomInt(8, 17), rarityFactor)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = "strength"
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_strength", "#CC0000", 2)
	elseif internalName == "sorceress" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_sorceress_immortal_weapon3", "#E88640", 1, "#property_sorceress_immortal_weapon3_description")

		local value = Weapons:GetDeviation(12 + RandomInt(5, 18), rarityFactor)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = "intelligence"
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)
	elseif internalName == "conjuror" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_conjuror_immortal_weapon3", "#D8B65F", 1, "#property_conjuror_immortal_weapon3_description")

		local value = Weapons:GetDeviation(7 + RandomInt(8, 25), rarityFactor)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = "strength"
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_strength", "#CC0000", 2)
	elseif internalName == "seinaru" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_seinaru_immortal_weapon3", "#ABDD71", 1, "#property_seinaru_immortal_weapon3_description")

		local value = Weapons:GetDeviation(6 + RandomInt(6, 22), rarityFactor)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = "strength"
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_strength", "#CC0000", 2)
	elseif internalName == "warlord" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_warlord_immortal_weapon3", "#F4A86E", 1, "#property_warlord_immortal_weapon3_description")

		local value = Weapons:GetDeviation(5 + RandomInt(8, 27), rarityFactor)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = "strength"
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_strength", "#CC0000", 2)
	elseif internalName == "bahamut" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_bahamut_immortal_weapon3", "#ADCCFF", 1, "#property_bahamut_immortal_weapon3_description")

		local value = Weapons:GetDeviation(12 + RandomInt(4, 24), rarityFactor)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = "all_attributes"
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_all_attributes", "#FFFFFF", 2)
	elseif internalName == "duskbringer" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_duskbringer_immortal_weapon3", "#9EE2D3", 1, "#property_duskbringer_immortal_weapon3_description")

		local value = Weapons:GetDeviation(17 + RandomInt(8, 30), rarityFactor)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = "strength"
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_strength", "#CC0000", 2)
	elseif internalName == "auriun" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_auriun_immortal_weapon3", "#9B53C1", 1, "#property_auriun_immortal_weapon3_description")

		local value = math.min(Weapons:GetDeviation(5, rarityFactor), RandomInt(2, 8))
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_SHADOW)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = name
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#rpc_item_element"..RPC_ELEMENT_SHADOW, color, 2)
	elseif internalName == "trapper" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_trapper_immortal_weapon3", "#BBEAC0", 1, "#property_trapper_immortal_weapon3_description")

		local value = Weapons:GetDeviation(12 + RandomInt(4, 24), rarityFactor)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = "all_attributes"
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_all_attributes", "#FFFFFF", 2)
	elseif internalName == "spirit_warrior" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_spirit_warrior_immortal_weapon3", "#A1C6A5", 1, "#property_spirit_warrior_immortal_weapon3_description")

		local value = Weapons:GetDeviation(5 + RandomInt(1, 5), rarityFactor)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = "critical_strike"
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_critical_strike", "#CC3D3D", 2)
	elseif internalName == "mountain_protector" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_mountain_protector_immortal_weapon3", "#C6C63F", 1, "#property_mountain_protector_immortal_weapon3_description")

		local value = math.min(Weapons:GetDeviation(5, rarityFactor), RandomInt(2, 8))
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_EARTH)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = name
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#rpc_item_element"..RPC_ELEMENT_EARTH, color, 2)
	elseif internalName == "chernobog" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_chernobog_immortal_weapon3", "#796DC6", 1, "#property_chernobog_immortal_weapon3_description")

		local value = Weapons:GetDeviation(22 + RandomInt(5, 23), rarityFactor)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = "agility"
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_agility", "#2EB82E", 2)
	elseif internalName == "solunia" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_solunia_immortal_weapon3", "#D64FD3", 1, "#property_solunia_immortal_weapon3_description")

		local value = math.min(Weapons:GetDeviation(4, rarityFactor), RandomInt(2, 5))
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_COSMOS)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = name
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#rpc_item_element"..RPC_ELEMENT_COSMOS, color, 2)
	elseif internalName == "hydroxis" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_hydroxis_immortal_weapon3", "#5FB6F4", 1, "#property_hydroxis_immortal_weapon3_description")

		local value = Weapons:GetDeviation(6 + RandomInt(6, 25), rarityFactor)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = "strength"
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_strength", "#CC0000", 2)
	elseif internalName == "ekkan" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_ekkan_immortal_weapon3", "#959BB2", 1, "#property_ekkan_immortal_weapon3_description")

		local value = math.min(Weapons:GetDeviation(4, rarityFactor), RandomInt(2, 6))
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_UNDEAD)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = name
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#rpc_item_element"..RPC_ELEMENT_UNDEAD, color, 2)
	elseif internalName == "zonik" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_zonik_immortal_weapon3", "#63FFAC", 1, "#property_zonik_immortal_weapon3_description")

		local value = Weapons:GetDeviation(6 + RandomInt(6, 28), rarityFactor)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = "strength"
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_strength", "#CC0000", 2)
	elseif internalName == "arkimus" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_arkimus_immortal_weapon3", "#A6A9FC", 1, "#property_arkimus_immortal_weapon3_description")

		local value = Weapons:GetDeviation(18 + RandomInt(5, 20), rarityFactor)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = "agility"
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_agility", "#2EB82E", 2)
	elseif internalName == "djanghor" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_djanghor_immortal_weapon3", "#4D7EC6", 1, "#property_djanghor_immortal_weapon3_description")

		local value = Weapons:GetDeviation(12 + RandomInt(5, 24), rarityFactor)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = "intelligence"
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_intelligence", "#33CCFF", 2)
	elseif internalName == "slipfinn" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_slipfinn_immortal_weapon3", "#4843BA", 1, "#property_slipfinn_immortal_weapon3_description")

		local value = math.min(Weapons:GetDeviation(5, rarityFactor), RandomInt(3, 9))
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_SHADOW)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = name
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#rpc_item_element"..RPC_ELEMENT_SHADOW, color, 2)
	elseif internalName == "sephyr" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "sephyr_immortal3"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_sephyr_immortal_weapon3", "#5AEDA1", 1, "#property_sephyr_immortal_weapon3_description")

		local value = Weapons:GetDeviation(4 + RandomInt(4, 26), rarityFactor)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = "all_attributes"
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_all_attributes", "#FFFFFF", 2)
	elseif internalName == "dinath" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_dinath_immortal_weapon3", "#643EBC", 1, "#property_dinath_immortal_weapon3_description")

		local value = math.min(Weapons:GetDeviation(5, rarityFactor), RandomInt(2, 7))
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_COSMOS)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = name
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#rpc_item_element"..RPC_ELEMENT_COSMOS, color, 2)
	elseif internalName == "jex" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_jex_immortal_weapon3", "#C25DFC", 1, "#property_jex_immortal_weapon3_description")

		local value = Weapons:GetDeviation(300 + RandomInt(1, 700), 0)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = "attack_damage"
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_bonus_attack_damage", "#343EC9", 2)
	elseif internalName == "omniro" then
		weapon.newItemTable.property1 = 1
		weapon.newItemTable.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_omniro_immortal_weapon3", "#3289C7", 1, "#property_omniro_immortal_weapon3_description")

		local value = Weapons:GetDeviation(5 + RandomInt(4, 24), rarityFactor)
		weapon.newItemTable.property2 = value
		weapon.newItemTable.property2name = "all_attributes"
		RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_all_attributes", "#FFFFFF", 2)
	end

	--print("------")
	--print(class)
	--DeepPrintTable(baseValueTable)
	--DeepPrintTable(tooltipTable)
	--DeepPrintTable(propertyTable)
	--print("------")
	local value = Weapons:GetDeviation(baseValueTable[specialProperty1] + RandomInt(1, 15), rarityFactor)
	weapon.newItemTable.property3 = value
	weapon.newItemTable.property3name = propertyTable[specialProperty1]
	RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property3, tooltipTable[specialProperty1], colorTable[specialProperty1], 3)

	local value = Weapons:GetDeviation(baseValueTable[specialProperty2] + RandomInt(1, 15), rarityFactor)
	weapon.newItemTable.property4 = value
	weapon.newItemTable.property4name = propertyTable[specialProperty2]
	RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property4, tooltipTable[specialProperty2], colorTable[specialProperty2], 4)
	RPCItems:ItemUpdateCustomNetTables(weapon)
	if not disableDrop then
		local drop = CreateItemOnPositionSync(deathLocation, weapon)
		local position = deathLocation
		RPCItems:DropItem(weapon, position)
	end
	return weapon
end

function Weapons:RollJexLegendWeapon2a(deathLocation, disableDrop)

	local maxFactor = RPCItems:GetMaxFactor()
	local rarityRoll = RandomInt(1, 100 + RandomInt(1, maxFactor))
	local rarity = "immortal"
	local itemName = ""
	local mainAttrRoll = RandomInt(1, 3)
	local rarityFactor = RPCItems:GetRarityFactor(rarity)
	local maxLevel = math.min(RPCItems:GetLogarithmicVarianceValue(48, 0, 0, 0, 0), 50)
	maxLevel = math.max(maxLevel, 50)
	if strictMaxItemLevel then
		maxLevel = strictMaxItemLevel
	end
	local maxLuck = RandomInt(1, 200)

	local propertyTable, baseValueTable, propensityTable, tooltipTable, colorTable = HerosCustom:GetAvailableRunes("npc_dota_hero_arc_warden")
	local specialProperty1 = RandomInt(1, #propensityTable)
	local specialProperty2 = RandomInt(1, #propensityTable)
	while specialProperty1 == specialProperty2 do
		specialProperty2 = RandomInt(1, #propensityTable)
	end
	local weaponName = "item_rpc_jex_immortal_weapon_2_a"

	local weapon = Weapons:CreateWeaponVariant(weaponName, rarity, "", "weapon", true, "Slot: Weapon", "npc_dota_hero_arc_warden", maxLevel, 100)

	weapon.newItemTable.property1 = 1
	weapon.newItemTable.property1name = "!immortal_weapon!"
	RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_jex_immortal_weapon2_a", "#EF4126", 1, "#property_jex_immortal_weapon2_a_description")

	local value = Weapons:GetDeviation(300 + RandomInt(1, 700), 0)
	weapon.newItemTable.property2 = value
	weapon.newItemTable.property2name = "attack_damage"
	RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property2, "#item_bonus_attack_damage", "#343EC9", 2)

	local value = Weapons:GetDeviation(baseValueTable[specialProperty1] + RandomInt(1, 15), rarityFactor)
	weapon.newItemTable.property3 = value
	weapon.newItemTable.property3name = propertyTable[specialProperty1]
	RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property3, tooltipTable[specialProperty1], colorTable[specialProperty1], 3)

	local value = Weapons:GetDeviation(baseValueTable[specialProperty2] + RandomInt(1, 15), rarityFactor)
	weapon.newItemTable.property4 = value
	weapon.newItemTable.property4name = propertyTable[specialProperty2]
	RPCItems:SetPropertyValues(weapon, weapon.newItemTable.property4, tooltipTable[specialProperty2], colorTable[specialProperty2], 4)
	RPCItems:ItemUpdateCustomNetTables(weapon)
	if not disableDrop then
		local drop = CreateItemOnPositionSync(deathLocation, weapon)
		local position = deathLocation
		RPCItems:DropItem(weapon, position)
	end
	return weapon
end
