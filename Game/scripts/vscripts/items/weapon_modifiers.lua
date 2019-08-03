
require('items/constants/boots')
require('items/constants/chest')
require('items/constants/gloves')
require('items/constants/helm')
require('items/constants/trinket')

if Weaponmodifiers == nil then
	Weaponmodifiers = class({})
end

function Weaponmodifiers:add_modifiers(hero, inventory_unit, item)
	--print("[Weaponmodifiers:add_modifiers] ++++++++++++++++++++++++++++++++++++++++++++")
	--DeepPrintTable(item)
	if not item.newItemTable then
		--print("[Error] Weaponmodifiers:add_modifiers item.newItemTable is null")
		RPCItems:ItemUTIL_Remove(item)
		return
	end
	local weapon_ability = inventory_unit:FindAbilityByName("weapon_slot")
	weapon_ability.strength = 0
	weapon_ability.agility = 0
	weapon_ability.intelligence = 0
	weapon_ability.attack_damage = 0
	weapon_ability.critical_strike = 0
	weapon_ability.splash_damage = 0
	weapon_ability.base_ability = 0
	weapon_ability.item_damage = 0
	if item.newItemTable.property1name then
		local property1 = RPCItems:AdjustAttributeValue(hero, item.newItemTable.property1)
		Weaponmodifiers:action(item.newItemTable.property1name, property1, hero, inventory_unit, weapon_ability, item)
		Weaponmodifiers:runeProperty(item.newItemTable.property1name, item.newItemTable.property1, hero)
	end
	if item.newItemTable.property2name then
		local property2 = RPCItems:AdjustAttributeValue(hero, item.newItemTable.property2)
		Weaponmodifiers:action(item.newItemTable.property2name, property2, hero, inventory_unit, weapon_ability, item)
		Weaponmodifiers:runeProperty(item.newItemTable.property2name, item.newItemTable.property2, hero)
	end
	if item.newItemTable.property3name then
		local property3 = RPCItems:AdjustAttributeValue(hero, item.newItemTable.property3)
		Weaponmodifiers:action(item.newItemTable.property3name, property3, hero, inventory_unit, weapon_ability, item)
		Weaponmodifiers:runeProperty(item.newItemTable.property3name, item.newItemTable.property3, hero)
	end
	if item.newItemTable.property4name then
		local property4 = RPCItems:AdjustAttributeValue(hero, item.newItemTable.property4)
		Weaponmodifiers:action(item.newItemTable.property4name, property4, hero, inventory_unit, weapon_ability, item)
		Weaponmodifiers:runeProperty(item.newItemTable.property4name, item.newItemTable.property4, hero)
	end
	if item.newItemTable.rarity == "immortal" then
		Stars:StarEventPlayer("weapon", hero)
	end
end

function Weaponmodifiers:action(propertyName, propertyValue, hero, inventory_unit, weapon_ability, item)
	--print("[Weaponmodifiers:action] propertyName:"..tostring(propertyName))
	if type(propertyValue) == "string" then
		--print("[Weaponmodifiers:action] propertyValue:"..propertyValue)
		propertyValue = 1
	end
	local propertyBoost = 1
	if hero:HasModifier("modifier_blacksmiths_tablet") then
		if propertyValue > 1 then
			propertyBoost = propertyBoost + BLACKSMITH_TABLE_ADD_STATS_PCT
		end
	end
	if hero:HasModifier("modifier_paladin_glyph_2_2") then
		if propertyValue > 1 then
			propertyBoost = propertyBoost + PALADIN_GLYPH_2_2_WEAPON_BONUS_PCT / 100
		end
	end
	propertyValue = propertyValue * propertyBoost
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
		weapon_ability.attack_damage = weapon_ability.attack_damage + Amulet:AdjustAttackPowerBonus(hero, propertyValue)
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
	elseif propertyName == "item_damage" then
		weapon_ability.item_damage = weapon_ability.item_damage + propertyValue
		Weaponmodifiers:addBasicModifier(weapon_ability.item_damage, hero, inventory_unit, "modifier_weapon_item_damage_inc", weapon_ability)
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
		--print("SEPHYR IMMORTAL3")
		local runeTable = {"rune_q_4", "rune_w_4", "rune_e_4", "rune_r_4"}
		for i = 1, #runeTable, 1 do
			Weaponmodifiers:runeProperty(runeTable[i], 7, hero)
		end
	end
	RPCItems:PreacheArcanaResources(item)
end

function Weaponmodifiers:addItemModifier(propertyValue, hero, inventory_unit, modifier_name, weapon_ability)
	weapon_ability:ApplyDataDrivenModifier(inventory_unit, hero, modifier_name, {})
	if propertyValue > 0 then
		hero:SetModifierStackCount(modifier_name, weapon_ability, propertyValue)
	end
end

function Weaponmodifiers:runeProperty(propertyName, propertyValue, hero)
	if hero:HasModifier("modifier_puzzlers_locket") then
		if string.match(propertyName, "_2") then
			propertyName = string.gsub(propertyName, "_2", "_3")
		elseif string.match(propertyName, "_3") then
			propertyName = string.gsub(propertyName, "_3", "_2")
		end
	end
	if type(propertyValue) == "string" then
		--print("[Weaponmodifiers:runeProperty] propertyValue:"..propertyValue)
		return
	end
	if hero:HasModifier("modifier_blacksmiths_tablet") then
		if propertyValue > 1 then
			propertyValue = math.ceil(propertyValue * (1 + BLACKSMITH_TABLE_ADD_STATS_PCT))
		end
	end
	if hero:HasModifier("modifier_paladin_glyph_2_2") then
		if propertyValue > 1 then
			propertyValue = math.ceil(propertyValue * (1 + PALADIN_GLYPH_2_2_WEAPON_BONUS_PCT / 100))
		end
	end
	if propertyName == "rune_q_1" then
		hero.runeUnit.weapon.q_1 = hero.runeUnit.weapon.q_1 + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit.weapon.q_1, propertyName, hero)
	elseif propertyName == "rune_w_1" then
		hero.runeUnit.weapon.w_1 = hero.runeUnit.weapon.w_1 + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit.weapon.w_1, propertyName, hero)
	elseif propertyName == "rune_e_1" then
		hero.runeUnit.weapon.e_1 = hero.runeUnit.weapon.e_1 + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit.weapon.e_1, propertyName, hero)
	elseif propertyName == "rune_r_1" then
		hero.runeUnit.weapon.r_1 = hero.runeUnit.weapon.r_1 + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit.weapon.r_1, propertyName, hero)
	elseif propertyName == "rune_q_2" then
		hero.runeUnit2.weapon.q_2 = hero.runeUnit2.weapon.q_2 + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit2.weapon.q_2, propertyName, hero)
	elseif propertyName == "rune_w_2" then
		hero.runeUnit2.weapon.w_2 = hero.runeUnit2.weapon.w_2 + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit2.weapon.w_2, propertyName, hero)
	elseif propertyName == "rune_e_2" then
		hero.runeUnit2.weapon.e_2 = hero.runeUnit2.weapon.e_2 + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit2.weapon.e_2, propertyName, hero)
	elseif propertyName == "rune_r_2" then
		hero.runeUnit2.weapon.r_2 = hero.runeUnit2.weapon.r_2 + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit2.weapon.r_2, propertyName, hero)
	elseif propertyName == "rune_q_3" then
		hero.runeUnit3.weapon.q_3 = hero.runeUnit3.weapon.q_3 + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit3.weapon.q_3, propertyName, hero)
	elseif propertyName == "rune_w_3" then
		hero.runeUnit3.weapon.w_3 = hero.runeUnit3.weapon.w_3 + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit3.weapon.w_3, propertyName, hero)
	elseif propertyName == "rune_e_3" then
		hero.runeUnit3.weapon.e_3 = hero.runeUnit3.weapon.e_3 + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit3.weapon.e_3, propertyName, hero)
	elseif propertyName == "rune_r_3" then
		hero.runeUnit3.weapon.r_3 = hero.runeUnit3.weapon.r_3 + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit3.weapon.r_3, propertyName, hero)
	elseif propertyName == "rune_q_4" then
		hero.runeUnit4.weapon.q_4 = hero.runeUnit4.weapon.q_4 + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit4.weapon.q_4, propertyName, hero)
	elseif propertyName == "rune_w_4" then
		hero.runeUnit4.weapon.w_4 = hero.runeUnit4.weapon.w_4 + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit4.weapon.w_4, propertyName, hero)
	elseif propertyName == "rune_e_4" then
		hero.runeUnit4.weapon.e_4 = hero.runeUnit4.weapon.e_4 + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit4.weapon.e_4, propertyName, hero)
	elseif propertyName == "rune_r_4" then
		hero.runeUnit4.weapon.r_4 = hero.runeUnit4.weapon.r_4 + propertyValue
		Weaponmodifiers:setRuneBonusNetTable(hero.runeUnit4.weapon.r_4, propertyName, hero)
	end

	local letter, tier = propertyName:match("rune_(.)_(.)")
	if letter ~= nil and tier ~= nil then
		Runes:OnRuneCountUpdate(hero, letter, tier)
	end
end

function Weaponmodifiers:setRuneBonusNetTable(value, rune, hero)
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()) .. "_"..rune.."_weapon", {bonus = value})
	--print("Setting Rune Net Table: ")
	--print(tostring(hero:GetEntityIndex()).."_"..rune.."_weapon")
end

function Weaponmodifiers:addBasicModifier(propertyValue, hero, inventory_unit, modifier_name, weapon_ability)
	--print(inventory_unit)
	--local stacks = hero:GetModifierStackCount(modifierName, inventory_unit)
	weapon_ability = inventory_unit:FindAbilityByName("weapon_slot")
	weapon_ability:ApplyDataDrivenModifier(inventory_unit, hero, modifier_name, {})
	--hero:SetModifierStackCount( modifier_name, weapon_ability, (propertyValue+stacks) )
	hero:SetModifierStackCount(modifier_name, weapon_ability, propertyValue)
end

function Weaponmodifiers:remove_modifiers(hero)
	hero:RemoveModifierByName("modifier_weapon_strength")
	hero:RemoveModifierByName("modifier_weapon_agility")
	hero:RemoveModifierByName("modifier_weapon_intelligence")
	hero:RemoveModifierByName("modifier_weapon_attack_damage")
	hero:RemoveModifierByName("modifier_weapon_base_ability_damage")
	hero:RemoveModifierByName("modifier_weapon_item_damage_inc")
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
			hero:RemoveModifierByName("modifier_"..classTable[i] .. "_immortal_weapon_"..j)
		end
	end

	Weaponmodifiers:remove_rune_bonuses(hero)
end

function Weaponmodifiers:remove_rune_bonuses(hero)
	hero.runeUnit.weapon.q_1 = 0
	hero.runeUnit.weapon.w_1 = 0
	hero.runeUnit.weapon.e_1 = 0
	hero.runeUnit.weapon.r_1 = 0
	hero.runeUnit2.weapon.q_2 = 0
	hero.runeUnit2.weapon.w_2 = 0
	hero.runeUnit2.weapon.e_2 = 0
	hero.runeUnit2.weapon.r_2 = 0
	hero.runeUnit3.weapon.q_3 = 0
	hero.runeUnit3.weapon.w_3 = 0
	hero.runeUnit3.weapon.e_3 = 0
	hero.runeUnit3.weapon.r_3 = 0
	hero.runeUnit4.weapon.q_4 = 0
	hero.runeUnit4.weapon.w_4 = 0
	hero.runeUnit4.weapon.e_4 = 0
	hero.runeUnit4.weapon.r_4 = 0
	Runes:ResetRuneBonuses(hero, "weapon")
end
