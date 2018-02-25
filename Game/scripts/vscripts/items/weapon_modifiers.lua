if Weaponmodifiers == nil then
  Weaponmodifiers = class({})
end


function Weaponmodifiers:add_modifiers(hero, inventory_unit, item)
	print(item)
	local weapon_ability = inventory_unit:FindAbilityByName("weapon_slot")
	weapon_ability.strength = 0
	weapon_ability.agility = 0
	weapon_ability.intelligence = 0
	weapon_ability.attack_damage = 0
	weapon_ability.critical_strike = 0
	weapon_ability.splash_damage = 0
	weapon_ability.base_ability = 0
	local property1 = RPCItems:AdjustAttributeValue(hero, item.property1)
	Weaponmodifiers:action(item.property1name, property1, hero, inventory_unit, weapon_ability, item)
	Weaponmodifiers:runeProperty(item.property1name, item.property1, hero)
	if item.property2name then
		local property2 = RPCItems:AdjustAttributeValue(hero, item.property2)
		Weaponmodifiers:action(item.property2name, property2, hero, inventory_unit, weapon_ability, item)
		Weaponmodifiers:runeProperty(item.property2name, item.property2, hero)
	end
	if item.property3name then
		local property3 = RPCItems:AdjustAttributeValue(hero, item.property3)
		Weaponmodifiers:action(item.property3name, property3, hero, inventory_unit, weapon_ability, item)
		Weaponmodifiers:runeProperty(item.property3name, item.property3, hero)
	end
	if item.property4name then
		local property4 = RPCItems:AdjustAttributeValue(hero, item.property4)
		Weaponmodifiers:action(item.property4name, property4, hero, inventory_unit, weapon_ability, item)
		Weaponmodifiers:runeProperty(item.property4name, item.property4, hero)
	end
	if item.rarity =="immortal" then
		Stars:StarEventPlayer("weapon", hero)
	end
end


function Weaponmodifiers:action(propertyName, propertyValue, hero, inventory_unit, weapon_ability, item)
	if hero:HasModifier("modifier_blacksmiths_tablet") then
		if propertyValue > 1 then
			propertyValue = propertyValue*1.4
		end
	end
	if propertyName == "strength" then
		weapon_ability.strength = weapon_ability.strength + propertyValue
		Weaponmodifiers:addBasicModifier(weapon_ability.strength, hero, inventory_unit, "modifier_weapon_strength", weapon_ability)
	elseif propertyName == "agility" then
		weapon_ability.agility = weapon_ability.agility + propertyValue
		Weaponmodifiers:addBasicModifier(weapon_ability.agility, hero, inventory_unit, "modifier_weapon_agility", weapon_ability)
	elseif propertyName == "intelligence" then
		weapon_ability.intelligence = weapon_ability.intelligence + propertyValue
		Weaponmodifiers:addBasicModifier(weapon_ability.intelligence, hero, inventory_unit, "modifier_weapon_intelligence", weapon_ability)
	elseif propertyName == "attack_damage" then
		weapon_ability.attack_damage = weapon_ability.attack_damage + propertyValue
		Weaponmodifiers:addBasicModifier(weapon_ability.attack_damage, hero, inventory_unit, "modifier_weapon_attack_damage", weapon_ability)
	elseif propertyName == "critical_strike" then
		weapon_ability.critical_strike = weapon_ability.critical_strike + propertyValue
		Weaponmodifiers:addBasicModifier(weapon_ability.critical_strike, hero, inventory_unit, "modifier_weapon_critical_strike", weapon_ability)
	elseif propertyName == "aspect_health" then
		hero.aspectHealthAbility = weapon_ability
		Weaponmodifiers:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_weapon_aspect_health", weapon_ability)
	elseif propertyName == "splash_damage" then
		weapon_ability.splash_damage = weapon_ability.splash_damage + propertyValue
		Weaponmodifiers:addBasicModifier(weapon_ability.splash_damage, hero, inventory_unit, "modifier_weapon_splash_damage", weapon_ability)
	elseif propertyName == "flamewaker_legend" then
		item:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_flamewaker_immortal_weapon_1", {})
	elseif propertyName == "voltex_legend" then
		item:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_voltex_immortal_weapon_1", {})
	elseif propertyName == "venomort_legend" then
		item:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_venomort_immortal_weapon_1", {})
	elseif propertyName == "axe_legend" then
		item:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_axe_immortal_weapon_1", {})
	elseif propertyName == "paladin_legend" then
		item:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_paladin_immortal_weapon_1", {})
	elseif propertyName == "seinaru_legend" then
		item:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_seinaru_immortal_weapon_1", {})
	elseif propertyName == "bahamut_legend" then
		item:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_bahamut_immortal_weapon_1", {})
	elseif propertyName == "auriun_legend" then
		item:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_auriun_immortal_weapon_1", {})
	elseif propertyName == "duskbringer_legend" then
		item:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_duskbringer_immortal_weapon_1", {})
	elseif propertyName == "spirit_warrior_legend" then
		item:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_spirit_warrior_immortal_weapon_1", {})
	elseif propertyName == "mountain_protector_legend" then
		item:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_mountain_protector_immortal_weapon_1", {})
	elseif propertyName == "chernobog_legend" then
		item:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_chernobog_immortal_weapon_1", {})
	elseif propertyName == "epoch_legend" then
		item:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_epoch_immortal_weapon_1", {})
	elseif propertyName == "warlord_legend" then
		item:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_warlord_immortal_weapon_1", {})
	elseif propertyName == "solunia_legend" then
		item:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_solunia_immortal_weapon_1", {})
	elseif propertyName == "hydroxis_legend" then
		item:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_hydroxis_immortal_weapon_1", {})
	elseif propertyName == "ekkan_legend" then
		item:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_ekkan_immortal_weapon_1", {})
	elseif propertyName == "zonik_legend" then
		item:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_zonik_immortal_weapon_1", {})
	elseif propertyName == "arkimus_legend" then
		item:ApplyDataDrivenModifier(inventory_unit, hero, "modifier_arkimus_immortal_weapon_1", {})
	elseif propertyName == "base_ability" then
		weapon_ability.base_ability = weapon_ability.base_ability + propertyValue
		Weaponmodifiers:addBasicModifier(weapon_ability.base_ability, hero, inventory_unit, "modifier_weapon_base_ability_damage", weapon_ability)
	elseif propertyName == "all_attributes" then
		weapon_ability.strength = weapon_ability.strength + propertyValue
		Weaponmodifiers:addBasicModifier(weapon_ability.strength, hero, inventory_unit, "modifier_weapon_strength", weapon_ability)	
		weapon_ability.agility = weapon_ability.agility + propertyValue
		Weaponmodifiers:addBasicModifier(weapon_ability.agility, hero, inventory_unit, "modifier_weapon_agility", weapon_ability)
		weapon_ability.intelligence = weapon_ability.intelligence + propertyValue
		Weaponmodifiers:addBasicModifier(weapon_ability.intelligence, hero, inventory_unit, "modifier_weapon_intelligence", weapon_ability)
	elseif propertyName == "!immortal_weapon!" then
		local modifierName = item:GetAbilityName():gsub('item_rpc', "modifier")
		item:ApplyDataDrivenModifier(inventory_unit, hero, modifierName, {})
		RPCItems:PreacheArcanaResources(item)
	elseif propertyName == "poison" then
		Weaponmodifiers:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_weapon_poison", weapon_ability)
	elseif propertyName == "normal" then
		Weaponmodifiers:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_weapon_normal", weapon_ability)
	elseif propertyName == "cosmos" then
		Weaponmodifiers:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_weapon_cosmos", weapon_ability)
	elseif propertyName == "holy" then
		Weaponmodifiers:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_weapon_holy", weapon_ability)
	elseif propertyName == "wind" then
		Weaponmodifiers:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_weapon_wind", weapon_ability)
	elseif propertyName == "ghost" then
		Weaponmodifiers:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_weapon_ghost", weapon_ability)
	elseif propertyName == "shadow" then
		Weaponmodifiers:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_weapon_shadow", weapon_ability)
	elseif propertyName == "fire" then
		Weaponmodifiers:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_weapon_fire", weapon_ability)
	elseif propertyName == "water" then
		Weaponmodifiers:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_weapon_water", weapon_ability)
	elseif propertyName == "earth" then
		Weaponmodifiers:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_weapon_earth", weapon_ability)
	elseif propertyName == "demon" then
		Weaponmodifiers:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_weapon_demon", weapon_ability)
	elseif propertyName == "undead" then
		Weaponmodifiers:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_weapon_undead", weapon_ability)
	elseif propertyName == "movespeed" then
		Weaponmodifiers:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_weapon_movespeed", weapon_ability)
	elseif propertyName == "time" then
		Weaponmodifiers:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_weapon_time", weapon_ability)	
	elseif propertyName == "sephyr_immortal3" then
		print("SEPHYR IMMORTAL3")
		local runeTable = {"rune_d_a", "rune_d_b", "rune_d_c", "rune_d_d"}
		for i = 1, #runeTable, 1 do
			Weaponmodifiers:runeProperty(runeTable[i], 7, hero)
		end		
	end
end

function Weaponmodifiers:addItemModifier(propertyValue, hero, inventory_unit, modifier_name, weapon_ability)
	weapon_ability:ApplyDataDrivenModifier(inventory_unit, hero, modifier_name, {})
	if propertyValue > 0 then
		hero:SetModifierStackCount( modifier_name, weapon_ability, propertyValue )
	end
end

function Weaponmodifiers:runeProperty(propertyName, propertyValue, hero)
	if hero:HasModifier("modifier_blacksmiths_tablet") then
		if propertyValue > 1 then
			propertyValue = propertyValue*1.4
		end
	end
	if propertyName == "rune_a_a" then
		hero.runeUnit.weapon.a_a = hero.runeUnit.weapon.a_a + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit.weapon.a_a, propertyName, hero)
	elseif propertyName == "rune_a_b" then
		hero.runeUnit.weapon.a_b = hero.runeUnit.weapon.a_b + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit.weapon.a_b, propertyName, hero)
	elseif propertyName == "rune_a_c" then
		hero.runeUnit.weapon.a_c = hero.runeUnit.weapon.a_c + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit.weapon.a_c, propertyName, hero)
	elseif propertyName == "rune_a_d" then
		hero.runeUnit.weapon.a_d = hero.runeUnit.weapon.a_d + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit.weapon.a_d, propertyName, hero)
	elseif propertyName == "rune_b_a" then
		hero.runeUnit2.weapon.b_a = hero.runeUnit2.weapon.b_a + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit2.weapon.b_a, propertyName, hero)
	elseif propertyName == "rune_b_b" then
		hero.runeUnit2.weapon.b_b = hero.runeUnit2.weapon.b_b + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit2.weapon.b_b, propertyName, hero)
	elseif propertyName == "rune_b_c" then
		hero.runeUnit2.weapon.b_c = hero.runeUnit2.weapon.b_c + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit2.weapon.b_c, propertyName, hero)
	elseif propertyName == "rune_b_d" then
		hero.runeUnit2.weapon.b_d = hero.runeUnit2.weapon.b_d + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit2.weapon.b_d, propertyName, hero)
	elseif propertyName == "rune_c_a" then
		hero.runeUnit3.weapon.c_a = hero.runeUnit3.weapon.c_a + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit3.weapon.c_a, propertyName, hero)
	elseif propertyName == "rune_c_b" then
		hero.runeUnit3.weapon.c_b = hero.runeUnit3.weapon.c_b + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit3.weapon.c_b, propertyName, hero)
	elseif propertyName == "rune_c_c" then
		hero.runeUnit3.weapon.c_c = hero.runeUnit3.weapon.c_c + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit3.weapon.c_c, propertyName, hero)
	elseif propertyName == "rune_c_d" then
		hero.runeUnit3.weapon.c_d = hero.runeUnit3.weapon.c_d + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit3.weapon.c_d, propertyName, hero)
	elseif propertyName == "rune_d_a" then
		hero.runeUnit4.weapon.d_a = hero.runeUnit4.weapon.d_a + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit4.weapon.d_a, propertyName, hero)
	elseif propertyName == "rune_d_b" then
		hero.runeUnit4.weapon.d_b = hero.runeUnit4.weapon.d_b + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit4.weapon.d_b, propertyName, hero)
	elseif propertyName == "rune_d_c" then
		hero.runeUnit4.weapon.d_c = hero.runeUnit4.weapon.d_c + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit4.weapon.d_c, propertyName, hero)
	elseif propertyName == "rune_d_d" then
		hero.runeUnit4.weapon.d_d = hero.runeUnit4.weapon.d_d + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit4.weapon.d_d, propertyName, hero)
	end
end

function Weaponmodifiers:setRuneBonusNetTable(value, rune, hero)
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()).."_"..rune.."_weapon", {bonus = value} )
	print("Setting Rune Net Table: ")
	print(tostring(hero:GetEntityIndex()).."_"..rune.."_weapon")
end

function Weaponmodifiers:addBasicModifier(propertyValue, hero, inventory_unit, modifier_name, weapon_ability)
	print(inventory_unit)
	--local stacks = hero:GetModifierStackCount(modifierName, inventory_unit)
	weapon_ability = inventory_unit:FindAbilityByName("weapon_slot")
	weapon_ability:ApplyDataDrivenModifier(inventory_unit, hero, modifier_name, {})
	--hero:SetModifierStackCount( modifier_name, weapon_ability, (propertyValue+stacks) )
	hero:SetModifierStackCount( modifier_name, weapon_ability, propertyValue )
end

function Weaponmodifiers:remove_modifiers(hero)
	hero:RemoveModifierByName("modifier_weapon_strength")
	hero:RemoveModifierByName("modifier_weapon_agility")
	hero:RemoveModifierByName("modifier_weapon_intelligence")
	hero:RemoveModifierByName("modifier_weapon_attack_damage")
	hero:RemoveModifierByName("modifier_weapon_poison")
	hero:RemoveModifierByName("modifier_weapon_normal")
	hero:RemoveModifierByName("modifier_weapon_cosmos")
	hero:RemoveModifierByName("modifier_weapon_holy")
	hero:RemoveModifierByName("modifier_weapon_wind")
	hero:RemoveModifierByName("modifier_weapon_ghost")
	hero:RemoveModifierByName("modifier_weapon_shadow")
	hero:RemoveModifierByName("modifier_weapon_fire")
	hero:RemoveModifierByName("modifier_weapon_water")
	hero:RemoveModifierByName("modifier_weapon_earth")
	hero:RemoveModifierByName("modifier_weapon_demon")
	hero:RemoveModifierByName("modifier_weapon_undead")
	hero:RemoveModifierByName("modifier_weapon_movespeed")
	hero:RemoveModifierByName("modifier_weapon_time")

	local classTable = HerosCustom:GetInternalNameTable()
	for i = 1, #classTable, 1 do
		for j = 1, 3, 1 do
			hero:RemoveModifierByName("modifier_"..classTable[i].."_immortal_weapon_"..j)
		end
	end

	Weaponmodifiers:remove_rune_bonuses(hero)
end

function Weaponmodifiers:remove_rune_bonuses(hero)
	hero.runeUnit.weapon.a_a = 0
	hero.runeUnit.weapon.a_b = 0
	hero.runeUnit.weapon.a_c = 0
	hero.runeUnit.weapon.a_d = 0
	hero.runeUnit2.weapon.b_a = 0
	hero.runeUnit2.weapon.b_b = 0
	hero.runeUnit2.weapon.b_c = 0
	hero.runeUnit2.weapon.b_d = 0
	hero.runeUnit3.weapon.c_a = 0
	hero.runeUnit3.weapon.c_b = 0
	hero.runeUnit3.weapon.c_c = 0
	hero.runeUnit3.weapon.c_d = 0
	hero.runeUnit4.weapon.d_a = 0
	hero.runeUnit4.weapon.d_b = 0
	hero.runeUnit4.weapon.d_c = 0
	hero.runeUnit4.weapon.d_d = 0
	Runes:ResetRuneBonuses(hero, "weapon")
end