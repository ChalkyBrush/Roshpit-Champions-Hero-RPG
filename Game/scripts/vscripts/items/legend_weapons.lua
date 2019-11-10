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
	if string.match(propertyName, "immortal_weapon_") then
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
	local item_level = math.max(RPCItems:RollItemLevelFromUnit(100), 100)
	local mainAttrRoll = RandomInt(1, 3)
	local internalName = class
	local whichHero = HerosCustom:ConvertRPCNameToStringHeroNameSeinaru(class)
	local maxLevel = 10
	local item_slot = RPC_GEAR_SLOT_WEAPON
	local weaponName = "item_rpc_"..internalName.."_immortal_weapon_1"

	local weapon = Weapons:CreateWeaponVariant(weaponName, rarity, "", "weapon", true, "Slot: Weapon", whichHero, maxLevel, item_level)
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

function Weapons:RollLegendWeapon2(location, class, strictMaxItemLevel, disableDrop)
	local rarity = RPC_ITEMS_RARITY_IMMORTAL
	local itemName = ""
	local item_level = RPCItems:RollItemLevelFromUnit(100)
	local mainAttrRoll = RandomInt(1, 3)
	local internalName = class
	local whichHero = HerosCustom:ConvertRPCNameToStringHeroNameSeinaru(class)
	local maxLevel = 10
	local item_slot = RPC_GEAR_SLOT_WEAPON
	local weaponName = "item_rpc_"..internalName.."_immortal_weapon_2"

	local weapon = Weapons:CreateWeaponVariant(weaponName, rarity, "", "weapon", true, "Slot: Weapon", whichHero, maxLevel, item_level)
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
		Weapons:SetLegendWeaponProperty2(weapon, "element_wind", 2)
	elseif internalName == "warlord" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#D6CF82", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "intelligence", 2)
	elseif internalName == "bahamut" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#9EFFF2", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "intelligence", 2)
	elseif internalName == "auriun" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#FFF95B", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "intelligence", 2)
	elseif internalName == "duskbringer" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_2", "#9EE2D3", nil, 2)
		Weapons:SetLegendWeaponProperty2(weapon, "element_ghost", 2)
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

function Weapons:RollLegendWeapon3(location, class, strictMaxItemLevel, disableDrop)
	local rarity = RPC_ITEMS_RARITY_IMMORTAL
	local itemName = ""
	local item_level = RPCItems:RollItemLevelFromUnit(100)
	local mainAttrRoll = RandomInt(1, 3)
	local internalName = class
	local whichHero = HerosCustom:ConvertRPCNameToStringHeroNameSeinaru(class)
	local maxLevel = 10
	local item_slot = RPC_GEAR_SLOT_WEAPON
	local weaponName = "item_rpc_"..internalName.."_immortal_weapon_3"

	local weapon = Weapons:CreateWeaponVariant(weaponName, rarity, "", "weapon", true, "Slot: Weapon", whichHero, maxLevel, item_level)
	weapon.newItemTable.minLevel = item_level
	if internalName == "flamewaker" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#E06647", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "strength", 2)
	elseif internalName == "voltex"	then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#88ECF7", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "agility", 2)
	elseif internalName == "venomort" then	
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#82C46D", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "element_poison", 2)
	elseif internalName == "axe" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#EDDFDC", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "element_normal", 1)
	elseif internalName == "astral" then	
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#BC96F2", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "element_cosmic", 3)
	elseif internalName == "epoch" then	
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#6EB788", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "intelligence", 3)
	elseif internalName == "paladin" then	
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#82C46D", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "strength", 2)
	elseif internalName == "sorceress" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#E88640", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "intelligence", 2)
	elseif internalName == "conjuror" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#C4FFE6", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "strength", 2)
	elseif internalName == "seinaru" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#ABDD71", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "strength", 2)
	elseif internalName == "warlord" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#F4A86E", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "strength", 2)
	elseif internalName == "bahamut" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#ADCCFF", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "all_attributes", 2.5)
	elseif internalName == "auriun" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#9B53C1", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "element_shadow", 2.5)
	elseif internalName == "duskbringer" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#9EE2D3", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "strength", 2)
	elseif internalName == "trapper" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#BBEAC0", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "all_attributes", 2)
	elseif internalName == "spirit_warrior" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#A1C6A5", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "armor_pierce", 3)
	elseif internalName == "mountain_protector" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#C6C63F", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "element_earth", 2)
	elseif internalName == "chernobog" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#796DC6", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "agility", 2)
	elseif internalName == "solunia" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#D64FD3", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "element_cosmic", 2)
	elseif internalName == "hydroxis" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#5FB6F4", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "strength", 3)
	elseif internalName == "ekkan" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#959BB2", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "element_undead", 2.5)
	elseif internalName == "zonik" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#63FFAC", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "strength", 2)
	elseif internalName == "arkimus" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#A6A9FC", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "agility", 2)
	elseif internalName == "djanghor" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#4D7EC6", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "intelligence", 2)
	elseif internalName == "slipfinn" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#4843BA", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "element_shadow", 2.5)
	elseif internalName == "sephyr" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#5AEDA1", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "all_attributes", 2)
	elseif internalName == "dinath" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#643EBC", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "element_cosmic", 3)
	elseif internalName == "jex" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#C25DFC", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "attack_damage", 2)
	elseif internalName == "omniro" then
		Weapons:SetLegendWeaponProperty1Alt(weapon, internalName, "immortal_weapon_3", "#3289C7", nil, 3)
		Weapons:SetLegendWeaponProperty2(weapon, "all_attributes", 2)
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

function Weapons:RollJexLegendWeapon2a(location, disableDrop)
	local rarity = RPC_ITEMS_RARITY_IMMORTAL
	local itemName = ""
	local item_level = RPCItems:RollItemLevelFromUnit(100)
	local mainAttrRoll = RandomInt(1, 3)
	local internalName = class
	local item_slot = RPC_GEAR_SLOT_WEAPON
	local maxLevel = 10

	local weaponName = "item_rpc_jex_immortal_weapon_2_a"

	local weapon = Weapons:CreateWeaponVariant(weaponName, rarity, "", "weapon", true, "Slot: Weapon", "npc_dota_hero_arc_warden", maxLevel, item_level)
	weapon.newItemTable.minLevel = item_level

	weapon.newItemTable.property1 = 1
	weapon.newItemTable.property1name = "immortal_weapon_2_a"
	RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_jex_immortal_weapon2_a", "#EF4126", 1, "#property_jex_immortal_weapon2_a_description")

	Weapons:SetLegendWeaponProperty2(weapon, "attack_damage", 2)



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
