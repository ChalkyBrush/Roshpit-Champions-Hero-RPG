function Weapons:RollLegendWeaponVariantWithAbilityName(abilityName, strictMaxItemLevel, position, disableDrop)
	if string.match(abilityName, "item_rpc_") then--item_rpc_hydroxis_immortal_weapon_3
		abilityName = string.gsub(abilityName, "item_rpc_", "")
		local class = nil
		if string.match(abilityName, "_immortal_weapon_1") then
			class = string.gsub(abilityName, "_immortal_weapon_1", "")
			return Weapons:RollLegendWeapon1(position, class, strictMaxItemLevel, disableDrop)
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

function Weapons:RollLegendWeapon1(deathLocation, class, strictMaxItemLevel, disableDrop)
	
	local maxFactor = RPCItems:GetMaxFactor()
	local rarityRoll = RandomInt(1, 100+RandomInt(1, maxFactor))
	local rarity = "immortal"
	local itemName = ""
	local mainAttrRoll = RandomInt(1,3)
	local internalName = class
	local whichHero = HerosCustom:ConvertRPCNameToStringHeroNameSeinaru(class)
	local rarityFactor = RPCItems:GetRarityFactor(rarity)
	local disableArena = false
	if not Beacons.cheats and Arena == nil then
		Arena = {}
		Arena.PitLevel = 1
		disableArena = true
	end	
	if Beacons.cheats and Arena == nil then
		Arena = {}
		Arena.PitLevel = 7
	end
	local maxLevel = math.min(12 + RandomInt(Arena.PitLevel*3, Arena.PitLevel*4) + GameState:GetPlayerPremiumStatusCount()*2, 50)
	local maxLuck = RandomInt(1,200)
	if maxLuck == 200 then
		maxLevel = math.min(maxLevel+20, 50)
	elseif maxLuck >= 190 then
		maxLevel = math.min(maxLevel+18, 50)
	elseif maxLuck >= 170 then
		maxLevel = math.min(maxLevel+16, 50)
	elseif maxLuck >= 150 then
		maxLevel = math.min(maxLevel+14, 50)
	elseif maxLuck >= 120 then
		maxLevel = math.min(maxLevel+12, 50)
	elseif maxLuck >= 80 then
		maxLevel = math.min(maxLevel+10, 50)
	elseif maxLuck >= 50 then
		maxLevel = math.min(maxLevel+8, 50)
	elseif maxLuck >= 1 then
		maxLevel = math.min(maxLevel+6, 50)
	end
	if Arena.PitLevel <= 3 then
		maxLevel = math.min(maxLevel+6, 50)
	elseif Arena.PitLevel == 4 then
		maxLevel = math.min(maxLevel+4, 50)
	elseif Arena.PitLevel == 5 then
		maxLevel = math.min(maxLevel+2, 50)
	end
	if Arena.PitLevel == 5 then
		maxLevel = math.max(maxLevel, 43)
	elseif Arena.PitLevel == 6 then
		maxLevel = math.max(maxLevel, 45)
	elseif Arena.PitLevel == 7 then
		maxLevel = math.max(maxLevel, 47)
	end
	if strictMaxItemLevel then
		maxLevel = strictMaxItemLevel
		if strictMaxItemLevel == 50 then
			Arena.PitLevel = 7
		end
	end
	local propertyTable, baseValueTable, propensityTable, tooltipTable, colorTable = HerosCustom:GetAvailableRunes(whichHero)
	local specialProperty1 = RandomInt(1, #propensityTable)
	local specialProperty2 = RandomInt(1, #propensityTable)
	while specialProperty1 == specialProperty2 do
		specialProperty2 = RandomInt(1, #propensityTable)
	end
	local weaponName = "item_rpc_"..internalName.."_immortal_weapon_1"

	local weapon = Weapons:CreateWeaponVariant(weaponName, rarity, "", "weapon", true, "Slot: Weapon", whichHero, maxLevel, 100)
	if internalName == "conjuror" then

		local value = Weapons:GetDeviation(2000+RandomInt(1,Arena.PitLevel*150), 0)
	    weapon.property1 = value
	    weapon.property1name = "aspect_health"
	    RPCItems:SetPropertyValues(weapon, weapon.property1, "#item_aspect_health", "#3D82CC",  1) 

		local value = RandomInt(1, RandomInt(1, Arena.PitLevel))
	    weapon.property2 = value
	    weapon.property2name = "base_ability"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_base_ability", "#7AB4CC",  2)
	elseif internalName == "flamewaker" then
	    weapon.property1 = 1
	    weapon.property1name = "flamewaker_legend"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_flamewaker_immortal_weapon", "#E06647",  1, "#property_flamewaker_immortal_weapon_description")

		local value = Weapons:GetDeviation(15+RandomInt(1,Arena.PitLevel*3), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "strength"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_strength", "#CC0000",  2)
	elseif internalName == "voltex" then
	    weapon.property1 = 1
	    weapon.property1name = "voltex_legend"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_voltex_immortal_weapon", "#31EBEB",  1, "#property_voltex_immortal_weapon_description")

		local value = Weapons:GetDeviation(1000+RandomInt(1,Arena.PitLevel*100), 0)
	    weapon.property2 = value
	    weapon.property2name = "attack_damage"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_bonus_attack_damage", "#343EC9",  2) 		
	elseif internalName == "venomort" then
	    weapon.property1 = 1
	    weapon.property1name = "venomort_legend"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_venomort_immortal_weapon", "#62DE72",  1, "#property_venomort_immortal_weapon_description")

		local value = RandomInt(1, RandomInt(1, Arena.PitLevel))
	    weapon.property2 = value
	    weapon.property2name = "base_ability"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_base_ability", "#7AB4CC",  2)  
	elseif internalName == "axe" then
	    weapon.property1 = 1
	    weapon.property1name = "axe_legend"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_axe_immortal_weapon", "#D62B2B",  1, "#property_axe_immortal_weapon_description")

		local value = Weapons:GetDeviation(25+RandomInt(1,Arena.PitLevel*3), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "strength"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_strength", "#CC0000",  2)
	elseif internalName == "astral" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_astral_immortal_weapon", "#BCA7E8",  1, "#property_astral_immortal_weapon_description")

	    local value = Weapons:GetDeviation(23+RandomInt(1,Arena.PitLevel*2), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "all_attributes"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_all_attributes", "#FFFFFF",  2)
	elseif internalName == "epoch" then
	    weapon.property1 = 1
	    weapon.property1name = "epoch_legend"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_epoch_immortal_weapon", "#42F48F",  1, "#property_epoch_immortal_weapon_description")

		local value = Weapons:GetDeviation(400+RandomInt(1,Arena.PitLevel*50), 0)
	    weapon.property2 = value
	    weapon.property2name = "attack_damage"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_bonus_attack_damage", "#343EC9",  2) 
	elseif internalName == "paladin" then
	    weapon.property1 = 1
	    weapon.property1name = "paladin_legend"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_paladin_immortal_weapon", "#E3ED87",  1, "#property_paladin_immortal_weapon_description")

		local value = Weapons:GetDeviation(18+RandomInt(1,Arena.PitLevel*3), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "strength"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_strength", "#CC0000",  2)
	elseif internalName == "sorceress" then
		local value = RandomInt(1, RandomInt(1, Arena.PitLevel))
	    weapon.property1 = value
	    weapon.property1name = "base_ability"
	    RPCItems:SetPropertyValues(weapon, weapon.property1, "#item_base_ability", "#7AB4CC",  1)  

		local value = Weapons:GetDeviation(17+RandomInt(1,Arena.PitLevel*3), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "intelligence"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_intelligence", "#33CCFF",  2)
	elseif internalName == "seinaru" then
	    weapon.property1 = 1
	    weapon.property1name = "seinaru_legend"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_seinaru_immortal_weapon", "#60FC63",  1, "#property_seinaru_immortal_weapon_description")

		local value = Weapons:GetDeviation(22+RandomInt(1,Arena.PitLevel*2), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "agility"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_agility", "#2EB82E",  2)
	elseif internalName == "warlord" then
	    weapon.property1 = 1
	    weapon.property1name = "warlord_legend"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_warlord_immortal_weapon", "#F7E845",  1, "#property_warlord_immortal_weapon_description")

		local value = RandomInt(1, RandomInt(1, Arena.PitLevel))
	    weapon.property2 = value
	    weapon.property2name = "base_ability"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_base_ability", "#7AB4CC",  2)
	elseif internalName == "bahamut" then
	    weapon.property1 = 1
	    weapon.property1name = "bahamut_legend"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_bahamut_immortal_weapon", "#ADFFFF",  1, "#property_bahamut_immortal_weapon_description")

		local value = RandomInt(1, RandomInt(1, Arena.PitLevel))
	    weapon.property2 = value
	    weapon.property2name = "base_ability"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_base_ability", "#7AB4CC",  2)
	elseif internalName == "auriun" then
	    weapon.property1 = 1
	    weapon.property1name = "auriun_legend"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_auriun_immortal_weapon", "#E2FF70",  1, "#property_auriun_immortal_weapon_description")

		local value = Weapons:GetDeviation(16+RandomInt(1,Arena.PitLevel*4), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "intelligence"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_intelligence", "#33CCFF",  2)
	elseif internalName == "duskbringer" then
	    weapon.property1 = 1
	    weapon.property1name = "duskbringer_legend"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_duskbringer_immortal_weapon", "#8FDBCB",  1, "#property_duskbringer_immortal_weapon_description")

		local value = Weapons:GetDeviation(23+RandomInt(1,Arena.PitLevel*3), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "strength"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_strength", "#CC0000",  2)
	elseif internalName == "trapper" then
		local value = Weapons:GetDeviation(600+RandomInt(1,Arena.PitLevel*130), 0)
	    weapon.property1 = value
	    weapon.property1name = "attack_damage"
	    RPCItems:SetPropertyValues(weapon, weapon.property1, "#item_bonus_attack_damage", "#343EC9",  1) 

		local value = RandomInt(1, RandomInt(1, Arena.PitLevel))
	    weapon.property2 = value
	    weapon.property2name = "base_ability"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_base_ability", "#7AB4CC",  2)  
	elseif internalName == "spirit_warrior" then
	    weapon.property1 = 1
	    weapon.property1name = "spirit_warrior_legend"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_spirit_warrior_immortal_weapon", "#5AE8A8",  1, "#property_spirit_warrior_immortal_weapon_description")

		local value = Weapons:GetDeviation(500+RandomInt(1,Arena.PitLevel*155), 0)
	    weapon.property2 = value
	    weapon.property2name = "attack_damage"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_bonus_attack_damage", "#343EC9",  2) 
	elseif internalName == "mountain_protector" then
	    weapon.property1 = 1
	    weapon.property1name = "mountain_protector_legend"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_mountain_protector_immortal_weapon", "#C96E34",  1, "#property_mountain_protector_immortal_weapon_description")

		local value = RandomInt(1, RandomInt(1, Arena.PitLevel))
	    weapon.property2 = value
	    weapon.property2name = "base_ability"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_base_ability", "#7AB4CC",  2)  
	elseif internalName == "chernobog" then
	    weapon.property1 = 1
	    weapon.property1name = "chernobog_legend"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_chernobog_immortal_weapon", "#457CF5",  1, "#property_chernobog_immortal_weapon_description")

		local value = Weapons:GetDeviation(400+RandomInt(1,Arena.PitLevel*65), 0)
	    weapon.property2 = value
	    weapon.property2name = "attack_damage"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_bonus_attack_damage", "#343EC9",  2) 
	elseif internalName == "solunia" then
	    weapon.property1 = 1
	    weapon.property1name = "solunia_legend"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_solunia_immortal_weapon", "#4286F4",  1, "#property_solunia_immortal_weapon_description")
		local luck = RandomInt(1,2)
		if luck == 1 then
			local value = Weapons:GetDeviation(380+RandomInt(1,Arena.PitLevel*100), 0)
		    weapon.property2 = value
		    weapon.property2name = "attack_damage"
		    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_bonus_attack_damage", "#343EC9",  2) 
		else
			local value = Weapons:GetDeviation(44+RandomInt(1,Arena.PitLevel*2), rarityFactor)
		    weapon.property2 = value
		    weapon.property2name = "agility"
		    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_agility", "#2EB82E",  2)
		end
	elseif internalName == "hydroxis" then
	    weapon.property1 = 1
	    weapon.property1name = "hydroxis_legend"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_hydroxis_immortal_weapon", "#4286F4",  1, "#property_hydroxis_immortal_weapon_description")

		local value = Weapons:GetDeviation(18+RandomInt(1,Arena.PitLevel*3), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "strength"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_strength", "#CC0000",  2)
	elseif internalName == "ekkan" then
	    weapon.property1 = 1
	    weapon.property1name = "ekkan_legend"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_ekkan_immortal_weapon", "#BAC2D1",  1, "#property_ekkan_immortal_weapon_description")

		local value = Weapons:GetDeviation(500+RandomInt(1,Arena.PitLevel*100), 0)
	    weapon.property2 = value
	    weapon.property2name = "attack_damage"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_bonus_attack_damage", "#343EC9",  2) 
	elseif internalName == "zonik" then
	    weapon.property1 = 1
	    weapon.property1name = "zonik_legend"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_zonik_immortal_weapon", "#00FF8C",  1, "#property_zonik_immortal_weapon_description")

		local value = Weapons:GetDeviation(27+RandomInt(1,Arena.PitLevel*3), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "strength"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_strength", "#CC0000",  2)
	elseif internalName == "arkimus" then
	    weapon.property1 = 1
	    weapon.property1name = "arkimus_legend"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_arkimus_immortal_weapon", "#D84ED1",  1, "#property_arkimus_immortal_weapon_description")

		local value = Weapons:GetDeviation(24+RandomInt(1,Arena.PitLevel*2), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "agility"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_agility", "#2EB82E",  2)
	elseif internalName == "djanghor" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_djanghor_immortal_weapon", "#A4EDA3",  1, "#property_djanghor_immortal_weapon_description")

		local value = Weapons:GetDeviation(24+RandomInt(1,Arena.PitLevel*2), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "agility"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_agility", "#2EB82E",  2)
	elseif internalName == "slipfinn" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_slipfinn_immortal_weapon", "#4286f4",  1, "#property_slipfinn_immortal_weapon_description")

		local value = Weapons:GetDeviation(20+RandomInt(1,Arena.PitLevel*2), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "agility"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_agility", "#2EB82E",  2)
	elseif internalName == "sephyr" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_sephyr_immortal_weapon", "#8af473",  1, "#property_sephyr_immortal_weapon_description")

		local value = Weapons:GetDeviation(20+RandomInt(1,Arena.PitLevel*6), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "intelligence"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_intelligence", "#33CCFF",  2)
	elseif internalName == "dinath" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_dinath_immortal_weapon", "#6ba3ff",  1, "#property_dinath_immortal_weapon_description")

		local value = Weapons:GetDeviation(25+RandomInt(1,Arena.PitLevel*3), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "strength"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_strength", "#CC0000",  2)
	end
	-- if mainAttrRoll == 1 then
	-- 	local value = Weapons:GetDeviation(15, rarityFactor)
	--     weapon.property2 = value
	--     weapon.property2name = "strength"
	--     RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_strength", "#CC0000",  2)
	-- elseif mainAttrRoll == 2 then
	-- 	local value = Weapons:GetDeviation(15, rarityFactor)
	--     weapon.property2 = value
	--     weapon.property2name = "agility"
	--     RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_agility", "#2EB82E",  2)
	-- else
	-- 	local value = Weapons:GetDeviation(15, rarityFactor)
	--     weapon.property2 = value
	--     weapon.property2name = "intelligence"
	--     RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_intelligence", "#33CCFF",  2)
	-- end
	print("----------")
	print(class)
	DeepPrintTable(baseValueTable)
	DeepPrintTable(tooltipTable)
	DeepPrintTable(propertyTable)
	print("----------")
	local value = Weapons:GetDeviation(baseValueTable[specialProperty1]+RandomInt(1, Arena.PitLevel*2), rarityFactor)
	weapon.property3 = value
	weapon.property3name = propertyTable[specialProperty1]
	RPCItems:SetPropertyValues(weapon, weapon.property3, tooltipTable[specialProperty1], colorTable[specialProperty1],  3)

	local value = Weapons:GetDeviation(baseValueTable[specialProperty2]+RandomInt(1, Arena.PitLevel*2), rarityFactor)
	weapon.property4 = value
	weapon.property4name = propertyTable[specialProperty2]
	RPCItems:SetPropertyValues(weapon, weapon.property4, tooltipTable[specialProperty2], colorTable[specialProperty2],  4)

	if not disableDrop then
		local drop = CreateItemOnPositionSync( deathLocation, weapon )
		local position = deathLocation
		RPCItems:DropItem(weapon, position)
	end
	if disableArena then
		Arena = nil
	end
	return weapon
end

function Weapons:RollInfernalStaff(deathLocation)
	local class = "sorceress"
	local maxFactor = RPCItems:GetMaxFactor()
	local rarityRoll = RandomInt(1, 100+RandomInt(1, maxFactor))
	local rarity = "immortal"
	local itemName = ""
	local mainAttrRoll = RandomInt(1,3)
	local internalName = class
	local whichHero = HerosCustom:ConvertRPCNameToStringHeroNameSeinaru(class)
	local rarityFactor = RPCItems:GetRarityFactor(rarity)
	local maxLevel = math.min(RPCItems:GetLogarithmicVarianceValue(40, 0, 0, 0, 0), 50)

	local propertyTable, baseValueTable, propensityTable, tooltipTable, colorTable = HerosCustom:GetAvailableRunes(whichHero)
	local specialProperty1 = RandomInt(1, #propensityTable)
	local specialProperty2 = RandomInt(1, #propensityTable)
	while specialProperty1 == specialProperty2 do
		specialProperty2 = RandomInt(1, #propensityTable)
	end
	local weaponName = "item_rpc_"..internalName.."_immortal_weapon_2"

	local weapon = Weapons:CreateWeaponVariant(weaponName, rarity, "", "weapon", true, "Slot: Weapon", whichHero, maxLevel, 100)


		local value = RandomInt(1, RandomInt(1, Arena.PitLevel))
	    weapon.property1 = value
	    weapon.property1name = "base_ability"
	    RPCItems:SetPropertyValues(weapon, weapon.property1, "#item_base_ability", "#7AB4CC",  1)  

		local value = Weapons:GetDeviation(15+RandomInt(1,Arena.PitLevel*3), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "intelligence"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_intelligence", "#33CCFF",  2)


	print("----------")
	print(class)
	DeepPrintTable(baseValueTable)
	DeepPrintTable(tooltipTable)
	DeepPrintTable(propertyTable)
	print("----------")
	local value = Weapons:GetDeviation(baseValueTable[specialProperty1]+RandomInt(1, Arena.PitLevel*2), rarityFactor)
	weapon.property3 = value
	weapon.property3name = propertyTable[specialProperty1]
	RPCItems:SetPropertyValues(weapon, weapon.property3, tooltipTable[specialProperty1], colorTable[specialProperty1],  3)

	local value = Weapons:GetDeviation(baseValueTable[specialProperty2]+RandomInt(1, Arena.PitLevel*2), rarityFactor)
	weapon.property4 = value
	weapon.property4name = propertyTable[specialProperty2]
	RPCItems:SetPropertyValues(weapon, weapon.property4, tooltipTable[specialProperty2], colorTable[specialProperty2],  4)

    local drop = CreateItemOnPositionSync( deathLocation, weapon )
    local position = deathLocation
    RPCItems:DropItem(weapon, position)
    
end

function Weapons:RollLegendWeapon2(deathLocation, class, strictMaxItemLevel, disableDrop)
	
	local maxFactor = RPCItems:GetMaxFactor()
	local rarityRoll = RandomInt(1, 100+RandomInt(1, maxFactor))
	local rarity = "immortal"
	local itemName = ""
	local mainAttrRoll = RandomInt(1,3)
	local internalName = class
	local whichHero = HerosCustom:ConvertRPCNameToStringHeroNameSeinaru(class)
	local rarityFactor = RPCItems:GetRarityFactor(rarity)
	local maxLevel = math.min(RPCItems:GetLogarithmicVarianceValue(48, 0, 0, 0, 0), 50)
	maxLevel = math.max(maxLevel, 50)
	if strictMaxItemLevel then
		maxLevel = strictMaxItemLevel
	end
	local maxLuck = RandomInt(1,200)


	local propertyTable, baseValueTable, propensityTable, tooltipTable, colorTable = HerosCustom:GetAvailableRunes(whichHero)
	local specialProperty1 = RandomInt(1, #propensityTable)
	local specialProperty2 = RandomInt(1, #propensityTable)
	while specialProperty1 == specialProperty2 do
		specialProperty2 = RandomInt(1, #propensityTable)
	end
	local weaponName = "item_rpc_"..internalName.."_immortal_weapon_2"

	local weapon = Weapons:CreateWeaponVariant(weaponName, rarity, "", "weapon", true, "Slot: Weapon", whichHero, maxLevel, 100)


	if internalName == "flamewaker" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_flamewaker_immortal_weapon2", "#E06647",  1, "#property_flamewaker_immortal_weapon2_description")

		local value = Weapons:GetDeviation(18+RandomInt(5,21), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "agility"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_agility", "#2EB82E",  2)
	elseif internalName == "voltex" then
	    local value = Weapons:GetDeviation(25+RandomInt(6,25), rarityFactor)
	    weapon.property1 = value
	    weapon.property1name = "all_attributes"
	    RPCItems:SetPropertyValues(weapon, weapon.property1, "#item_all_attributes", "#FFFFFF",  1)

		local value = Weapons:GetDeviation(24+RandomInt(5,22), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "agility"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_agility", "#2EB82E",  2)	
	elseif internalName == "venomort" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_venomort_immortal_weapon2", "#82C46D",  1, "#property_venomort_immortal_weapon2_description")

		local value = Weapons:GetDeviation(800+RandomInt(1,600), 0)
	    weapon.property2 = value
	    weapon.property2name = "attack_damage"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_bonus_attack_damage", "#343EC9",  2) 	
	elseif internalName == "axe" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_axe_immortal_weapon2", "#FC643F",  1, "#property_axe_immortal_weapon2_description")

		local value = RandomInt(1,5)
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_NORMAL)
		weapon.property2 = value
		weapon.property2name = name
		RPCItems:SetPropertyValues(weapon, weapon.property2, "#rpc_item_element"..RPC_ELEMENT_NORMAL, color,  2)
	elseif internalName == "astral" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_astral_immortal_weapon2", "#A86BFF",  1, "#property_astral_immortal_weapon2_description")

		local value = Weapons:GetDeviation(5+RandomInt(1,5), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "critical_strike"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_critical_strike", "#CC3D3D",  2)
	elseif internalName == "epoch" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_epoch_immortal_weapon2", "#6BEF9A",  1, "#property_epoch_immortal_weapon2_description")

		local value = Weapons:GetDeviation(18+RandomInt(8,22), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "strength"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_strength", "#CC0000",  2)
	elseif internalName == "paladin" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_paladin_immortal_weapon2", "#82C46D",  1, "#property_paladin_immortal_weapon2_description")

		local value = math.min(Weapons:GetDeviation(4, rarityFactor), RandomInt(2,7))
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_HOLY)
	    weapon.property2 = value
	    weapon.property2name = name
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#rpc_item_element"..RPC_ELEMENT_HOLY, color,  2) 
	elseif internalName == "sorceress" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_sorceress_immortal_weapon2", "#93F3F9",  1, "#property_sorceress_immortal_weapon2_description")

		local value = Weapons:GetDeviation(18+RandomInt(8,24), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "strength"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_strength", "#CC0000",  2)
	elseif internalName == "conjuror" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_conjuror_immortal_weapon2", "#C4FFE6",  1, "#property_conjuror_immortal_weapon2_description")

	    local value = Weapons:GetDeviation(14+RandomInt(4,20), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "all_attributes"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_all_attributes", "#FFFFFF",  2)	
	elseif internalName == "seinaru" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_seinaru_immortal_weapon2", "#8BEFA4",  1, "#property_seinaru_immortal_weapon2_description")

		local value = math.min(Weapons:GetDeviation(5, rarityFactor), RandomInt(2,8))
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_WIND)
	    weapon.property2 = value
	    weapon.property2name = name
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#rpc_item_element"..RPC_ELEMENT_WIND, color,  2) 
	elseif internalName == "warlord" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_warlord_immortal_weapon2", "#D6CF82",  1, "#property_warlord_immortal_weapon2_description")

		local value = Weapons:GetDeviation(16+RandomInt(8,20), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "intelligence"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_intelligence", "#33CCFF",  2)
	elseif internalName == "bahamut" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_bahamut_immortal_weapon2", "#9EFFF2",  1, "#property_bahamut_immortal_weapon2_description")

		local value = Weapons:GetDeviation(16+RandomInt(8,28), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "intelligence"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_intelligence", "#33CCFF",  2)
	elseif internalName == "duskbringer" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_duskbringer_immortal_weapon2", "#9EE2D3",  1, "#property_duskbringer_immortal_weapon2_description")

		local value = math.min(Weapons:GetDeviation(4, rarityFactor), RandomInt(2,7))
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_GHOST)
	    weapon.property2 = value
	    weapon.property2name = name
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#rpc_item_element"..RPC_ELEMENT_GHOST, color,  2) 
	elseif internalName == "auriun" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_auriun_immortal_weapon2", "#FFF95B",  1, "#property_auriun_immortal_weapon2_description")

		local value = Weapons:GetDeviation(16+RandomInt(8,28), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "intelligence"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_intelligence", "#33CCFF",  2)
	elseif internalName == "trapper" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_trapper_immortal_weapon2", "#C1A6A7",  1, "#property_trapper_immortal_weapon2_description")

		local value = RandomInt(1,3)
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_NORMAL)
	    weapon.property2 = value
	    weapon.property2name = name
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#rpc_item_element"..RPC_ELEMENT_NORMAL, color,  2) 
	elseif internalName == "spirit_warrior" then
		local luck = RandomInt(1,3)
		local value = Weapons:GetDeviation(16+RandomInt(8,24), rarityFactor)
	    weapon.property1 = value
	    if luck == 1 then
		    weapon.property1name = "intelligence"
		    RPCItems:SetPropertyValues(weapon, weapon.property1, "#item_intelligence", "#33CCFF", 1)
		elseif luck == 2 then
		    weapon.property1name = "strength"
		    RPCItems:SetPropertyValues(weapon, weapon.property1, "#item_strength", "#CC0000", 1)
		elseif luck == 3 then
		    weapon.property1name = "agility"
		    RPCItems:SetPropertyValues(weapon, weapon.property1, "#item_agility", "#2EB82E",  1)
		end		   
		local luck = RandomInt(1,3)
		local value = math.min(Weapons:GetDeviation(3, rarityFactor), RandomInt(2,5))
		if luck == 1 then
			local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_FIRE)
		    weapon.property2 = value
		    weapon.property2name = name
		    RPCItems:SetPropertyValues(weapon, weapon.property2, "#rpc_item_element"..RPC_ELEMENT_FIRE, color,  2) 
		elseif luck == 2 then
			local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_WIND)
		    weapon.property2 = value
		    weapon.property2name = name
		    RPCItems:SetPropertyValues(weapon, weapon.property2, "#rpc_item_element"..RPC_ELEMENT_WIND, color,  2) 
		elseif luck == 3 then
			local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_WATER)
		    weapon.property2 = value
		    weapon.property2name = name
		    RPCItems:SetPropertyValues(weapon, weapon.property2, "#rpc_item_element"..RPC_ELEMENT_WATER, color,  2) 
		end
	elseif internalName == "mountain_protector" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_mountain_protector_immortal_weapon2", "#AF2B2B",  1, "#property_mountain_protector_immortal_weapon2_description")

		local value = Weapons:GetDeviation(800+RandomInt(1,700), 0)
	    weapon.property2 = value
	    weapon.property2name = "attack_damage"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_bonus_attack_damage", "#343EC9",  2) 	
	elseif internalName == "chernobog" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_chernobog_immortal_weapon2", "#817BAD",  1, "#property_chernobog_immortal_weapon2_description")

		local value = RandomInt(1,3)
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_DEMON)
	    weapon.property2 = value
	    weapon.property2name = name
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#rpc_item_element"..RPC_ELEMENT_DEMON, color,  2) 
	elseif internalName == "solunia" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_solunia_immortal_weapon2", "#90D7ED",  1, "#property_solunia_immortal_weapon2_description")

		local value = Weapons:GetDeviation(800+RandomInt(1,700), 0)
	    weapon.property2 = value
	    weapon.property2name = "attack_damage"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_bonus_attack_damage", "#343EC9",  2) 
	elseif internalName == "hydroxis" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_hydroxis_immortal_weapon2", "#6D78BA",  1, "#property_hydroxis_immortal_weapon2_description")

		local value = Weapons:GetDeviation(700+RandomInt(1,600), 0)
	    weapon.property2 = value
	    weapon.property2name = "attack_damage"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_bonus_attack_damage", "#343EC9",  2) 
	elseif internalName == "ekkan" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_ekkan_immortal_weapon2", "#99B0C1",  1, "#property_ekkan_immortal_weapon2_description")

		local value = Weapons:GetDeviation(700+RandomInt(1,800), 0)
	    weapon.property2 = value
	    weapon.property2name = "attack_damage"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_bonus_attack_damage", "#343EC9",  2) 
	elseif internalName == "zonik" then
	    weapon.property1 = RandomInt(1, 3)
	    weapon.property1name = "movespeed"
	    RPCItems:SetPropertyValues(weapon, weapon.property1, "#item_movespeed", "#B02020",  1)

		local value = math.min(Weapons:GetDeviation(3, rarityFactor), RandomInt(3,8))
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_TIME)
	    weapon.property2 = value
	    weapon.property2name = name
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#rpc_item_element"..RPC_ELEMENT_TIME, color, 2) 
	elseif internalName == "arkimus" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_arkimus_immortal_weapon2", "#CC92E8",  1, "#property_arkimus_immortal_weapon2_description")

		local value = Weapons:GetDeviation(600+RandomInt(1,600), 0)
	    weapon.property2 = value
	    weapon.property2name = "attack_damage"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_bonus_attack_damage", "#343EC9",  2) 
	elseif internalName == "djanghor" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_djanghor_immortal_weapon2", "#E54E4E",  1, "#property_djanghor_immortal_weapon2_description")

		local value = Weapons:GetDeviation(14+RandomInt(6,18), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "strength"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_strength", "#CC0000",  2)
	elseif internalName == "slipfinn" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_slipfinn_immortal_weapon2", "#3D6DBA",  1, "#property_slipfinn_immortal_weapon2_description")

		local value = Weapons:GetDeviation(800+RandomInt(1,600), 0)
	    weapon.property2 = value
	    weapon.property2name = "attack_damage"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_bonus_attack_damage", "#343EC9",  2)
	elseif internalName == "sephyr" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
		RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_sephyr_immortal_weapon2", "#6de253",  1, "#property_sephyr_immortal_weapon2_description")

		local value = Weapons:GetDeviation(18+RandomInt(5,25), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "agility"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_agility", "#2EB82E",  2)	
	elseif internalName == "dinath" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_dinath_immortal_weapon2", "#83eafc",  1, "#property_dinath_immortal_weapon2_description")

		local value = Weapons:GetDeviation(200+RandomInt(1,550), 0)
	    weapon.property2 = value
	    weapon.property2name = "attack_damage"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_bonus_attack_damage", "#343EC9",  2)
	end

	print("----------")
	print(class)
	DeepPrintTable(baseValueTable)
	DeepPrintTable(tooltipTable)
	DeepPrintTable(propertyTable)
	print("----------")
	local value = Weapons:GetDeviation(baseValueTable[specialProperty1]+RandomInt(1, 15), rarityFactor)
	weapon.property3 = value
	weapon.property3name = propertyTable[specialProperty1]
	RPCItems:SetPropertyValues(weapon, weapon.property3, tooltipTable[specialProperty1], colorTable[specialProperty1],  3)

	local value = Weapons:GetDeviation(baseValueTable[specialProperty2]+RandomInt(1, 15), rarityFactor)
	weapon.property4 = value
	weapon.property4name = propertyTable[specialProperty2]
	RPCItems:SetPropertyValues(weapon, weapon.property4, tooltipTable[specialProperty2], colorTable[specialProperty2],  4)

	if not disableDrop then
		local drop = CreateItemOnPositionSync( deathLocation, weapon )
		local position = deathLocation
		RPCItems:DropItem(weapon, position)
	end
	return weapon
end

function Weapons:RollLegendWeapon3(deathLocation, class, strictMaxItemLevel, disableDrop)
	
	local maxFactor = RPCItems:GetMaxFactor()
	local rarityRoll = RandomInt(1, 100+RandomInt(1, maxFactor))
	local rarity = "immortal"
	local itemName = ""
	local mainAttrRoll = RandomInt(1,3)
	local internalName = class
	local whichHero = HerosCustom:ConvertRPCNameToStringHeroNameSeinaru(class)
	local rarityFactor = RPCItems:GetRarityFactor(rarity)
	local maxLevel = math.min(RPCItems:GetLogarithmicVarianceValue(48, 0, 0, 0, 0), 50)
	maxLevel = math.max(maxLevel, 50)
	if strictMaxItemLevel then
		maxLevel = strictMaxItemLevel
	end
	local maxLuck = RandomInt(1,200)


	local propertyTable, baseValueTable, propensityTable, tooltipTable, colorTable = HerosCustom:GetAvailableRunes(whichHero)
	local specialProperty1 = RandomInt(1, #propensityTable)
	local specialProperty2 = RandomInt(1, #propensityTable)
	while specialProperty1 == specialProperty2 do
		specialProperty2 = RandomInt(1, #propensityTable)
	end
	local weaponName = "item_rpc_"..internalName.."_immortal_weapon_3"

	local weapon = Weapons:CreateWeaponVariant(weaponName, rarity, "", "weapon", true, "Slot: Weapon", whichHero, maxLevel, 100)


	if internalName == "flamewaker" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_flamewaker_immortal_weapon3", "#E06647",  1, "#property_flamewaker_immortal_weapon3_description")

		local value = Weapons:GetDeviation(17+RandomInt(8,21), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "strength"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_strength", "#CC0000",  2)
	elseif internalName == "voltex" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_voltex_immortal_weapon3", "#88ECF7",  1, "#property_voltex_immortal_weapon3_description")

		local value = Weapons:GetDeviation(28+RandomInt(5,25), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "agility"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_agility", "#2EB82E",  2)	
	elseif internalName == "venomort" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_venomort_immortal_weapon3", "#82C46D",  1, "#property_venomort_immortal_weapon3_description")

		local value = math.min(Weapons:GetDeviation(5, rarityFactor), RandomInt(2,8))
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_POISON)
	    weapon.property2 = value
	    weapon.property2name = name
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#rpc_item_element"..RPC_ELEMENT_POISON, color,  2) 
	elseif internalName == "axe" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_axe_immortal_weapon3", "#EDDFDC",  1, "#property_axe_immortal_weapon3_description")

		local value = RandomInt(1,5)
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_NORMAL)
	    weapon.property2 = value
	    weapon.property2name = name
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#rpc_item_element"..RPC_ELEMENT_NORMAL, color,  2) 	
	elseif internalName == "astral" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_astral_immortal_weapon3", "#BC96F2",  1, "#property_astral_immortal_weapon3_description")

		local value = math.min(Weapons:GetDeviation(5, rarityFactor), RandomInt(2,7))
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_COSMOS)
	    weapon.property2 = value
	    weapon.property2name = name
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#rpc_item_element"..RPC_ELEMENT_COSMOS, color,  2) 	
	elseif internalName == "epoch" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_epoch_immortal_weapon3", "#6EB788",  1, "#property_epoch_immortal_weapon3_description")

		local value = Weapons:GetDeviation(16+RandomInt(5,18), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "intelligence"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_intelligence", "#33CCFF",  2)
	elseif internalName == "paladin" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_paladin_immortal_weapon3", "#82C46D",  1, "#property_paladin_immortal_weapon3_description")

		local value = Weapons:GetDeviation(7+RandomInt(8,17), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "strength"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_strength", "#CC0000",  2)
	elseif internalName == "sorceress" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_sorceress_immortal_weapon3", "#E88640",  1, "#property_sorceress_immortal_weapon3_description")

		local value = Weapons:GetDeviation(12+RandomInt(5,18), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "intelligence"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_intelligence", "#33CCFF",  2)
	elseif internalName == "conjuror" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_conjuror_immortal_weapon3", "#D8B65F",  1, "#property_conjuror_immortal_weapon3_description")

		local value = Weapons:GetDeviation(7+RandomInt(8,25), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "strength"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_strength", "#CC0000",  2)
	elseif internalName == "seinaru" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_seinaru_immortal_weapon3", "#ABDD71",  1, "#property_seinaru_immortal_weapon3_description")

		local value = Weapons:GetDeviation(6+RandomInt(6,22), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "strength"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_strength", "#CC0000",  2)
	elseif internalName == "warlord" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_warlord_immortal_weapon3", "#F4A86E",  1, "#property_warlord_immortal_weapon3_description")

		local value = Weapons:GetDeviation(5+RandomInt(8,27), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "strength"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_strength", "#CC0000",  2)
	elseif internalName == "bahamut" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_bahamut_immortal_weapon3", "#ADCCFF",  1, "#property_bahamut_immortal_weapon3_description")

	    local value = Weapons:GetDeviation(12+RandomInt(4,24), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "all_attributes"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_all_attributes", "#FFFFFF",  2)	
	elseif internalName == "duskbringer" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_duskbringer_immortal_weapon3", "#9EE2D3",  1, "#property_duskbringer_immortal_weapon3_description")

		local value = Weapons:GetDeviation(17+RandomInt(8,30), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "strength"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_strength", "#CC0000",  2)
	elseif internalName == "auriun" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_auriun_immortal_weapon3", "#9B53C1",  1, "#property_auriun_immortal_weapon3_description")

		local value = math.min(Weapons:GetDeviation(5, rarityFactor), RandomInt(2,8))
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_SHADOW)
	    weapon.property2 = value
	    weapon.property2name = name
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#rpc_item_element"..RPC_ELEMENT_SHADOW, color,  2) 
	elseif internalName == "trapper" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_trapper_immortal_weapon3", "#BBEAC0",  1, "#property_trapper_immortal_weapon3_description")

	    local value = Weapons:GetDeviation(12+RandomInt(4,24), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "all_attributes"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_all_attributes", "#FFFFFF",  2)	
	elseif internalName == "spirit_warrior" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_spirit_warrior_immortal_weapon3", "#A1C6A5",  1, "#property_spirit_warrior_immortal_weapon3_description")

		local value = Weapons:GetDeviation(5+RandomInt(1,5), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "critical_strike"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_critical_strike", "#CC3D3D",  2)
	elseif internalName == "mountain_protector" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_mountain_protector_immortal_weapon3", "#C6C63F",  1, "#property_mountain_protector_immortal_weapon3_description")

		local value = math.min(Weapons:GetDeviation(5, rarityFactor), RandomInt(2,8))
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_EARTH)
	    weapon.property2 = value
	    weapon.property2name = name
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#rpc_item_element"..RPC_ELEMENT_EARTH, color,  2) 
	elseif internalName == "chernobog" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_chernobog_immortal_weapon3", "#796DC6",  1, "#property_chernobog_immortal_weapon3_description")

		local value = Weapons:GetDeviation(22+RandomInt(5,23), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "agility"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_agility", "#2EB82E",  2)	
	elseif internalName == "solunia" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_solunia_immortal_weapon3", "#D64FD3",  1, "#property_solunia_immortal_weapon3_description")

		local value = math.min(Weapons:GetDeviation(4, rarityFactor), RandomInt(2,5))
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_COSMOS)
	    weapon.property2 = value
	    weapon.property2name = name
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#rpc_item_element"..RPC_ELEMENT_COSMOS, color,  2) 	
	elseif internalName == "hydroxis" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_hydroxis_immortal_weapon3", "#5FB6F4",  1, "#property_hydroxis_immortal_weapon3_description")

		local value = Weapons:GetDeviation(6+RandomInt(6,25), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "strength"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_strength", "#CC0000",  2)
	elseif internalName == "ekkan" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_ekkan_immortal_weapon3", "#959BB2",  1, "#property_ekkan_immortal_weapon3_description")

		local value = math.min(Weapons:GetDeviation(4, rarityFactor), RandomInt(2,6))
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_UNDEAD)
	    weapon.property2 = value
	    weapon.property2name = name
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#rpc_item_element"..RPC_ELEMENT_UNDEAD, color,  2)  
	elseif internalName == "zonik" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_zonik_immortal_weapon3", "#63FFAC",  1, "#property_zonik_immortal_weapon3_description")

		local value = Weapons:GetDeviation(6+RandomInt(6,28), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "strength"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_strength", "#CC0000",  2)
	elseif internalName == "arkimus" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_arkimus_immortal_weapon3", "#A6A9FC",  1, "#property_arkimus_immortal_weapon3_description")

		local value = Weapons:GetDeviation(18+RandomInt(5,20), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "agility"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_agility", "#2EB82E",  2)
	elseif internalName == "djanghor" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_djanghor_immortal_weapon3", "#4D7EC6",  1, "#property_djanghor_immortal_weapon3_description")

		local value = Weapons:GetDeviation(12+RandomInt(5,24), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "intelligence"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_intelligence", "#33CCFF",  2)
	elseif internalName == "slipfinn" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_slipfinn_immortal_weapon3", "#4843BA",  1, "#property_slipfinn_immortal_weapon3_description")

		local value = math.min(Weapons:GetDeviation(5, rarityFactor), RandomInt(3,9))
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_SHADOW)
	    weapon.property2 = value
	    weapon.property2name = name
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#rpc_item_element"..RPC_ELEMENT_SHADOW, color,  2) 
	elseif internalName == "sephyr" then
	    weapon.property1 = 1
	    weapon.property1name = "sephyr_immortal3"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_sephyr_immortal_weapon3", "#5AEDA1",  1, "#property_sephyr_immortal_weapon3_description")

	    local value = Weapons:GetDeviation(4+RandomInt(4,26), rarityFactor)
	    weapon.property2 = value
	    weapon.property2name = "all_attributes"
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#item_all_attributes", "#FFFFFF",  2)	
	elseif internalName == "dinath" then
	    weapon.property1 = 1
	    weapon.property1name = "!immortal_weapon!"
	    RPCItems:SetPropertyValuesSpecial(weapon, "★", "#item_property_dinath_immortal_weapon3", "#643EBC",  1, "#property_dinath_immortal_weapon3_description")

		local value = math.min(Weapons:GetDeviation(5, rarityFactor), RandomInt(2,7))
		local name, color = Elements:GetElementNameAndColorByCode(RPC_ELEMENT_COSMOS)
	    weapon.property2 = value
	    weapon.property2name = name
	    RPCItems:SetPropertyValues(weapon, weapon.property2, "#rpc_item_element"..RPC_ELEMENT_COSMOS, color,  2) 	
	end

	print("----------")
	print(class)
	DeepPrintTable(baseValueTable)
	DeepPrintTable(tooltipTable)
	DeepPrintTable(propertyTable)
	print("----------")
	local value = Weapons:GetDeviation(baseValueTable[specialProperty1]+RandomInt(1, 15), rarityFactor)
	weapon.property3 = value
	weapon.property3name = propertyTable[specialProperty1]
	RPCItems:SetPropertyValues(weapon, weapon.property3, tooltipTable[specialProperty1], colorTable[specialProperty1],  3)

	local value = Weapons:GetDeviation(baseValueTable[specialProperty2]+RandomInt(1, 15), rarityFactor)
	weapon.property4 = value
	weapon.property4name = propertyTable[specialProperty2]
	RPCItems:SetPropertyValues(weapon, weapon.property4, tooltipTable[specialProperty2], colorTable[specialProperty2],  4)

	if not disableDrop then
		local drop = CreateItemOnPositionSync( deathLocation, weapon )
		local position = deathLocation
		RPCItems:DropItem(weapon, position)
	end
	return weapon
end