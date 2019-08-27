if Amulet == nil then
	Amulet = class({})
end

function Amulet:AdjustAttackPowerBonus(hero, value)
	if hero:GetUnitName() == "npc_dota_hero_winter_wyvern" then
		-- local b_c_level = hero:GetRuneValue("e", 2)
		-- if hero:HasModifier("modifier_recently_respawned") then
		-- local ability = hero:FindAbilityByName("dinath_dragon_dive")
		-- b_c_level = ability.e_2_level
		-- end
		-- value = value + value*0.15*b_c_level
	end
	return value
end

function Amulet:add_modifiers(hero, inventory_unit, item)
	--print("[Amulet:add_modifiers] ++++++++++++++++++++++++++++++++++++++++++++")
	--DeepPrintTable(item)
	if not item.newItemTable then
		--print("[Error] Amulet:add_modifiers item.newItemTable is null")
		RPCItems:ItemUTIL_Remove(item)
		return
	end
	--print("[Amulet:add_modifiers] ++++++++++++++++++++++++++++++++++++++++++++")
	local trinket_ability = inventory_unit:FindAbilityByName("trinket_slot")
	trinket_ability.strength = 0
	trinket_ability.agility = 0
	trinket_ability.intelligence = 0
	trinket_ability.armor = 0
	trinket_ability.health_regen = 0
	trinket_ability.mana_regen = 0
	trinket_ability.attack_damage = 0
	trinket_ability.max_health = 0
	trinket_ability.max_mana = 0
	trinket_ability.magic_resist = 0
	trinket_ability.base_ability = 0
	trinket_ability.item_damage = 0
	trinket_ability.cosmos = 0
	trinket_ability.nature = 0
	trinket_ability.ice = 0
	trinket_ability.fire = 0
	trinket_ability.water = 0
	trinket_ability.demon = 0
	trinket_ability.arcane = 0
	trinket_ability.undead = 0
	if item.newItemTable.property1name then
		local property1 = RPCItems:AdjustAttributeValue(hero, item.newItemTable.property1)
		Amulet:action(item.newItemTable.property1name, property1, hero, inventory_unit, trinket_ability, item)
		Amulet:runeProperty(item.newItemTable.property1name, item.newItemTable.property1, hero)
	end
	if item.newItemTable.property2name then
		local property2 = RPCItems:AdjustAttributeValue(hero, item.newItemTable.property2)
		Amulet:action(item.newItemTable.property2name, property2, hero, inventory_unit, trinket_ability, item)
		Amulet:runeProperty(item.newItemTable.property2name, item.newItemTable.property2, hero)
	end
	if item.newItemTable.property3name then
		local property3 = RPCItems:AdjustAttributeValue(hero, item.newItemTable.property3)
		Amulet:action(item.newItemTable.property3name, property3, hero, inventory_unit, trinket_ability, item)
		Amulet:runeProperty(item.newItemTable.property3name, item.newItemTable.property3, hero)
	end
	if item.newItemTable.property4name then
		local property4 = RPCItems:AdjustAttributeValue(hero, item.newItemTable.property4)
		Amulet:action(item.newItemTable.property4name, property4, hero, inventory_unit, trinket_ability, item)
		Amulet:runeProperty(item.newItemTable.property4name, item.newItemTable.property4, hero)
	end
end

function Amulet:action(propertyName, propertyValue, hero, inventory_unit, trinket_ability, item)
	--print("[Amulet:action] propertyName:"..tostring(propertyName))
	if type(propertyValue) == "string" then
		--print("[action] type(propertyValue) == string")
		propertyValue = 1
	end
	if propertyName == "strength" then
		trinket_ability.strength = trinket_ability.strength + propertyValue
		Amulet:addBasicModifier(trinket_ability.strength, hero, inventory_unit, "modifier_trinket_strength", trinket_ability)
	elseif propertyName == "agility" then
		trinket_ability.agility = trinket_ability.agility + propertyValue
		Amulet:addBasicModifier(trinket_ability.agility, hero, inventory_unit, "modifier_trinket_agility", trinket_ability)
	elseif propertyName == "intelligence" then
		trinket_ability.intelligence = trinket_ability.intelligence + propertyValue
		Amulet:addBasicModifier(trinket_ability.intelligence, hero, inventory_unit, "modifier_trinket_intelligence", trinket_ability)
	elseif propertyName == "armor" then
		trinket_ability.armor = trinket_ability.armor + propertyValue
		Amulet:addBasicModifier(trinket_ability.armor, hero, inventory_unit, "modifier_trinket_armor", trinket_ability)
	elseif propertyName == "health_regen" then
		trinket_ability.health_regen = trinket_ability.health_regen + propertyValue
		Amulet:addBasicModifier(trinket_ability.health_regen, hero, inventory_unit, "modifier_trinket_health_regen", trinket_ability)
	elseif propertyName == "mana_regen" then
		trinket_ability.mana_regen = trinket_ability.mana_regen + propertyValue
		Amulet:addBasicModifier(trinket_ability.mana_regen, hero, inventory_unit, "modifier_trinket_mana_regen", trinket_ability)
	elseif propertyName == "attack_damage" then
		trinket_ability.attack_damage = trinket_ability.attack_damage + Amulet:AdjustAttackPowerBonus(hero, propertyValue)
		Amulet:addBasicModifier(trinket_ability.attack_damage, hero, inventory_unit, "modifier_trinket_attack_damage", trinket_ability)
	elseif propertyName == "max_health" then
		trinket_ability.max_health = trinket_ability.max_health + propertyValue
		Amulet:addBasicModifier(trinket_ability.max_health, hero, inventory_unit, "modifier_trinket_max_health", trinket_ability)
	elseif propertyName == "max_mana" then
		trinket_ability.max_mana = trinket_ability.max_mana + propertyValue
		Amulet:addBasicModifier(trinket_ability.max_mana, hero, inventory_unit, "modifier_trinket_max_mana", trinket_ability)
	elseif propertyName == "magic_resist" then
		trinket_ability.magic_resist = trinket_ability.magic_resist + propertyValue
		Amulet:addBasicModifier(trinket_ability.magic_resist, hero, inventory_unit, "modifier_trinket_magic_resist", trinket_ability)
	elseif propertyName == "base_ability" then
		trinket_ability.base_ability = trinket_ability.base_ability + propertyValue
		Amulet:addBasicModifier(trinket_ability.base_ability, hero, inventory_unit, "modifier_trinket_base_ability_damage", trinket_ability)
	elseif propertyName == "item_damage" then
		trinket_ability.item_damage = trinket_ability.item_damage + propertyValue
		Amulet:addBasicModifier(trinket_ability.item_damage, hero, inventory_unit, "modifier_trinket_item_damage_inc", trinket_ability)
	elseif propertyName == "monkey_paw" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_monkey_paw", item)
		hero.monkey_paw = item
	elseif propertyName == "blacksmith" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_blacksmiths_tablet", item)
		local playerID = hero:GetPlayerOwnerID()
		local itemEntity = CustomNetTables:GetTableValue("equipment", tostring(playerID) .. "-"..tostring(1))
		if itemEntity then
			local item = EntIndexToHScript(itemEntity.itemIndex)
			if IsValidEntity(item) then
				RPCItems:EquipItem(1, hero, hero.InventoryUnit, item)
			end
		end
	elseif propertyName == "all_attributes" then
		trinket_ability.strength = trinket_ability.strength + propertyValue
		Amulet:addBasicModifier(trinket_ability.strength, hero, inventory_unit, "modifier_trinket_strength", trinket_ability)
		trinket_ability.agility = trinket_ability.agility + propertyValue
		Amulet:addBasicModifier(trinket_ability.agility, hero, inventory_unit, "modifier_trinket_agility", trinket_ability)
		trinket_ability.intelligence = trinket_ability.intelligence + propertyValue
		Amulet:addBasicModifier(trinket_ability.intelligence, hero, inventory_unit, "modifier_trinket_intelligence", trinket_ability)
	elseif propertyName == "sapphire_lotus" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_sapphire_lotus", item)
	elseif propertyName == "arbor" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_arbor_dragonfly", item)
	elseif propertyName == "eternal_frost" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_gem_of_eternal_frost", item)
		hero.eternal_frost_gem = item
	elseif propertyName == "lifesource" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_lifesource_vessel", item)
	elseif propertyName == "saytaru" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_hope_of_saytaru", item)
	elseif propertyName == "galaxy_orb" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_galaxy_orb", item)
		hero.galaxy_orb = item
	elseif propertyName == "azure_empire" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_azure_empire", item)
	elseif propertyName == "signus" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_signus_charm", item)
	elseif propertyName == "avernus" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_eye_of_avernus", item)
	elseif propertyName == "tome_of_chaos" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_tome_of_chaos", item)
		hero.tome_of_chaos = item
	elseif propertyName == "gengar" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_torch_of_gengar", item)
	elseif propertyName == "ruinfall" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_ruinfall_skull_token", item)
	elseif propertyName == "omega_ruby" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_omega_ruby", item)
	elseif propertyName == "raven2" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_raven_idol2", item)
	elseif propertyName == "phoenix_emblem" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_phoenix_emblem", item)
	elseif propertyName == "volcano_orb" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_volcano_orb", item)
	elseif propertyName == "aerith" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_aeriths_tear", item)
	elseif propertyName == "geode" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_fractional_enhancement_geode", item)
	elseif propertyName == "nobility" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_ring_of_nobility", item)
	elseif propertyName == "nobility_augmented" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_ring_of_nobility_augmented", item)
	elseif propertyName == "enlightened_twig" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_twig_of_the_enlightened", item)
	elseif propertyName == "ancient_waterstone" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_ancient_waterstone", item)
	elseif propertyName == "tempest_falcon" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_tempest_falcon_ring", item)
	elseif propertyName == "firelock" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_firelock_pendant", item)
	elseif propertyName == "mana_relic" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_antique_mana_relic", item)
	elseif propertyName == "stone_falcon" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_conquest_stone_falcon", item)
	elseif propertyName == "epsilon" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_epsilons_eyeglass", item)
	elseif propertyName == "fenrir_fang" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_fenrirs_fang", item)
	elseif propertyName == "fuchsia" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_fuchsia_ring", item)
	elseif propertyName == "fortune_talisman" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_fortunes_talisman_of_truth", item)
	elseif propertyName == "emerald_null" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_emerald_nullification_ring", item)
	elseif propertyName == "garnet_warfare" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_garnet_warfare_ring", item)
	elseif propertyName == "cobalt_serenity" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_cobalt_serenity_ring", item)
	elseif propertyName == "cosmos" then
		trinket_ability.cosmos = trinket_ability.cosmos + propertyValue
		Amulet:addBasicModifier(trinket_ability.cosmos, hero, inventory_unit, "modifier_trinket_cosmos", trinket_ability)
	elseif propertyName == "nature" then
		trinket_ability.nature = trinket_ability.nature + propertyValue
		Amulet:addBasicModifier(trinket_ability.nature, hero, inventory_unit, "modifier_trinket_nature", trinket_ability)
	elseif propertyName == "ice" then
		trinket_ability.ice = trinket_ability.ice + propertyValue
		Amulet:addBasicModifier(trinket_ability.ice, hero, inventory_unit, "modifier_trinket_ice", trinket_ability)
	elseif propertyName == "fire" then
		trinket_ability.fire = trinket_ability.fire + propertyValue
		Amulet:addBasicModifier(trinket_ability.fire, hero, inventory_unit, "modifier_trinket_fire", trinket_ability)
	elseif propertyName == "water" then
		trinket_ability.water = trinket_ability.water + propertyValue
		Amulet:addBasicModifier(trinket_ability.water, hero, inventory_unit, "modifier_trinket_water", trinket_ability)
	elseif propertyName == "demon" then
		trinket_ability.demon = trinket_ability.demon + propertyValue
		Amulet:addBasicModifier(trinket_ability.demon, hero, inventory_unit, "modifier_trinket_demon", trinket_ability)
	elseif propertyName == "arcane" then
		trinket_ability.arcane = trinket_ability.arcane + propertyValue
		Amulet:addBasicModifier(trinket_ability.arcane, hero, inventory_unit, "modifier_trinket_arcane", trinket_ability)
	elseif propertyName == "undead" then
		trinket_ability.undead = trinket_ability.undead + propertyValue
		Amulet:addBasicModifier(trinket_ability.undead, hero, inventory_unit, "modifier_trinket_undead", trinket_ability)
	elseif propertyName == "fire_blossom" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_fire_blossom", item)
	elseif propertyName == "aqua_lily" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_aqua_lily", item)
	elseif propertyName == "wind_orchid" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_wind_orchid", item)
	elseif propertyName == "ankh_of_ancients" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_ankh_of_the_ancients", item)
	elseif propertyName == "world_tree_flower" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_world_trees_flower_cache", item)
		RPCItems:PreacheArcanaResources(item)
	elseif propertyName == "oceanis" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_sparkling_token_of_oceanis", item)
	elseif propertyName == "arcane_charm" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_arcane_charm", item)
	elseif propertyName == "winterblight_skull_ring" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_winterblight_skull_ring", item)
	elseif string.match(propertyName, "_glyph_") then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_winterblight_skull_ring", item)
	elseif propertyName == "all_elements" then
		Amulet:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_trinket_all_elements", trinket_ability)
	elseif propertyName == "frozen_heart" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_frozen_heart", item)
		RPCItems:PreacheArcanaResources(item)
	elseif propertyName == "vision" then
		Head:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_trinket_vision", trinket_ability)
	elseif propertyName == "red_divinex" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_red_divinex_amulet", item)
	elseif propertyName == "blue_divinex" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_blue_divinex_amulet", item)
	elseif propertyName == "green_divinex" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_green_divinex_amulet", item)
	elseif propertyName == "puzzler" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_puzzlers_locket", item)
	elseif propertyName == "razor_band" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_galvanized_razor_band", item)
	elseif propertyName == "guardian_stone" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_guadian_stone", item)
	elseif propertyName == "beryl_intuition" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_beryl_ring_of_intuiton", item)
		RPCItems:PreacheArcanaResources(item)
	elseif propertyName == "auric_inspiration" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_auric_ring_of_inspiration", item)
		RPCItems:PreacheArcanaResources(item)
	end
	hero.amulet = item
end

function Amulet:addItemModifier(propertyValue, hero, inventory_unit, modifier_name, amulet_ability)
	amulet_ability:ApplyDataDrivenModifier(inventory_unit, hero, modifier_name, {})
	if propertyValue > 0 then
		hero:SetModifierStackCount(modifier_name, amulet_ability, propertyValue)
	end
end

function Amulet:runeProperty(propertyName, propertyValue, hero)
	if hero:HasModifier("modifier_puzzlers_locket") then
		if string.match(propertyName, "_2") then
			propertyName = string.gsub(propertyName, "_2", "_3")
		elseif string.match(propertyName, "_3") then
			propertyName = string.gsub(propertyName, "_3", "_2")
		end
	end
	if type(propertyValue) == "string" then
		--print("[Amulet:runeProperty] propertyValue:"..propertyValue)
		return
	end
	if propertyName == "rune_q_1" then
		hero.runeUnit.amulet.q_1 = hero.runeUnit.amulet.q_1 + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit.amulet.q_1, propertyName, hero)
	elseif propertyName == "rune_w_1" then
		hero.runeUnit.amulet.w_1 = hero.runeUnit.amulet.w_1 + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit.amulet.w_1, propertyName, hero)
	elseif propertyName == "rune_e_1" then
		hero.runeUnit.amulet.e_1 = hero.runeUnit.amulet.e_1 + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit.amulet.e_1, propertyName, hero)
	elseif propertyName == "rune_r_1" then
		hero.runeUnit.amulet.r_1 = hero.runeUnit.amulet.r_1 + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit.amulet.r_1, propertyName, hero)
	elseif propertyName == "rune_q_2" then
		hero.runeUnit2.amulet.q_2 = hero.runeUnit2.amulet.q_2 + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit2.amulet.q_2, propertyName, hero)
	elseif propertyName == "rune_w_2" then
		hero.runeUnit2.amulet.w_2 = hero.runeUnit2.amulet.w_2 + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit2.amulet.w_2, propertyName, hero)
	elseif propertyName == "rune_e_2" then
		hero.runeUnit2.amulet.e_2 = hero.runeUnit2.amulet.e_2 + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit2.amulet.e_2, propertyName, hero)
	elseif propertyName == "rune_r_2" then
		hero.runeUnit2.amulet.r_2 = hero.runeUnit2.amulet.r_2 + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit2.amulet.r_2, propertyName, hero)
	elseif propertyName == "rune_q_3" then
		hero.runeUnit3.amulet.q_3 = hero.runeUnit3.amulet.q_3 + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit3.amulet.q_3, propertyName, hero)
	elseif propertyName == "rune_w_3" then
		hero.runeUnit3.amulet.w_3 = hero.runeUnit3.amulet.w_3 + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit3.amulet.w_3, propertyName, hero)
	elseif propertyName == "rune_e_3" then
		hero.runeUnit3.amulet.e_3 = hero.runeUnit3.amulet.e_3 + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit3.amulet.e_3, propertyName, hero)
	elseif propertyName == "rune_r_3" then
		hero.runeUnit3.amulet.r_3 = hero.runeUnit3.amulet.r_3 + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit3.amulet.r_3, propertyName, hero)
	elseif propertyName == "rune_q_4" then
		hero.runeUnit4.amulet.q_4 = hero.runeUnit4.amulet.q_4 + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit4.amulet.q_4, propertyName, hero)
	elseif propertyName == "rune_w_4" then
		hero.runeUnit4.amulet.w_4 = hero.runeUnit4.amulet.w_4 + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit4.amulet.w_4, propertyName, hero)
	elseif propertyName == "rune_e_4" then
		hero.runeUnit4.amulet.e_4 = hero.runeUnit4.amulet.e_4 + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit4.amulet.e_4, propertyName, hero)
	elseif propertyName == "rune_r_4" then
		hero.runeUnit4.amulet.r_4 = hero.runeUnit4.amulet.r_4 + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit4.amulet.r_4, propertyName, hero)
	elseif propertyName == "all_runes" then
		for i = 1, #AVAILABLE_RUNE_TABLE, 1 do
			Amulet:runeProperty(AVAILABLE_RUNE_TABLE[i], propertyValue, hero)
		end
	elseif propertyName == "t4_runes" then
		local runeTable = {"rune_q_4", "rune_w_4", "rune_e_4", "rune_r_4"}
		for i = 1, #runeTable, 1 do
			Amulet:runeProperty(runeTable[i], propertyValue, hero)
		end
	end

	local letter, tier = propertyName:match("rune_(.)_(.)")
	if letter ~= nil and tier ~= nil then
		Runes:OnRuneCountUpdate(hero, letter, tier)
	end
end

AVAILABLE_RUNE_TABLE = {"rune_q_1", "rune_w_1", "rune_e_1", "rune_r_1", "rune_q_2", "rune_w_2", "rune_e_2", "rune_r_2", "rune_q_3", "rune_w_3", "rune_e_3", "rune_r_3"}

function Amulet:setRuneBonusNetTable(value, rune, hero)
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()) .. "_"..rune.."_amulet", {bonus = value})
	--print("Setting Rune Net Table: ")
	--print(tostring(hero:GetEntityIndex()).."_"..rune.."_amulet")
end

function Amulet:addBasicModifier(propertyValue, hero, inventory_unit, modifier_name, trinket_ability)
	--print(inventory_unit)
	--local stacks = hero:GetModifierStackCount(modifierName, inventory_unit)
	local amulet_ability = inventory_unit:FindAbilityByName("trinket_slot")
	amulet_ability:ApplyDataDrivenModifier(inventory_unit, hero, modifier_name, {})
	--hero:SetModifierStackCount( modifier_name, trinket_ability, (propertyValue+stacks) )
	hero:SetModifierStackCount(modifier_name, amulet_ability, propertyValue)
end

function Amulet:remove_modifiers(hero)
	hero:RemoveModifierByName("modifier_trinket_strength")
	hero:RemoveModifierByName("modifier_trinket_agility")
	hero:RemoveModifierByName("modifier_trinket_intelligence")
	hero:RemoveModifierByName("modifier_trinket_armor")
	hero:RemoveModifierByName("modifier_trinket_attack_damage")
	hero:RemoveModifierByName("modifier_trinket_health_regen")
	hero:RemoveModifierByName("modifier_trinket_mana_regen")
	hero:RemoveModifierByName("modifier_trinket_max_health")
	hero:RemoveModifierByName("modifier_trinket_base_ability_damage")
	hero:RemoveModifierByName("modifier_trinket_item_damage_inc")
	hero:RemoveModifierByName("modifier_trinket_magic_resist")
	hero:RemoveModifierByName("modifier_monkey_paw")
	hero:RemoveModifierByName("modifier_blacksmiths_tablet")
	hero:RemoveModifierByName("modifier_sapphire_lotus")
	hero:RemoveModifierByName("modifier_sapphire_lotus_buff")
	hero:RemoveModifierByName("modifier_arbor_dragonfly")
	hero:RemoveModifierByName("modifier_gem_of_eternal_frost")
	hero:RemoveModifierByName("modifier_lifesource_vessel")
	hero:RemoveModifierByName("modifier_lifesource_vessel_buff")
	hero:RemoveModifierByName("modifier_hope_of_saytaru")
	hero:RemoveModifierByName("modifier_hope_of_saytaru_effect")
	hero:RemoveModifierByName("modifier_galaxy_orb")
	hero:RemoveModifierByName("modifier_azure_empire")
	hero:RemoveModifierByName("modifier_signus_charm")
	hero:RemoveModifierByName("modifier_tome_of_chaos")
	hero:RemoveModifierByName("modifier_torch_of_gengar")
	hero:RemoveModifierByName("modifier_ruinfall_skull_token")
	hero:RemoveModifierByName("modifier_omega_ruby")
	hero:RemoveModifierByName("modifier_raven_idol2")
	hero:RemoveModifierByName("modifier_phoenix_emblem")
	hero:RemoveModifierByName("modifier_volcano_orb")
	hero:RemoveModifierByName("modifier_aeriths_tear")
	hero:RemoveModifierByName("modifier_fractional_enhancement_geode")
	hero:RemoveModifierByName("modifier_ring_of_nobility")
	hero:RemoveModifierByName("modifier_ring_of_nobility_augmented")
	hero:RemoveModifierByName("modifier_twig_of_the_enlightened")
	hero:RemoveModifierByName("modifier_ancient_waterstone")
	hero:RemoveModifierByName("modifier_tempest_falcon_ring")
	hero:RemoveModifierByName("modifier_firelock_pendant")
	hero:RemoveModifierByName("modifier_antique_mana_relic")
	hero:RemoveModifierByName("modifier_conquest_stone_falcon")
	hero:RemoveModifierByName("modifier_epsilons_eyeglass")
	hero:RemoveModifierByName("modifier_fenrirs_fang")
	hero:RemoveModifierByName("modifier_fuchsia_ring")
	hero:RemoveModifierByName("modifier_fortunes_talisman_of_truth")
	hero:RemoveModifierByName("modifier_emerald_nullification_ring")
	hero:RemoveModifierByName("modifier_cobalt_serenity_ring")
	hero:RemoveModifierByName("modifier_garnet_warfare_ring")
	hero:RemoveModifierByName("modifier_trinket_cosmos")
	hero:RemoveModifierByName("modifier_trinket_ice")
	hero:RemoveModifierByName("modifier_trinket_fire")
	hero:RemoveModifierByName("modifier_trinket_water")
	hero:RemoveModifierByName("modifier_trinket_demon")
	hero:RemoveModifierByName("modifier_fire_blossom")
	hero:RemoveModifierByName("modifier_wind_orchid")
	hero:RemoveModifierByName("modifier_aqua_lily")
	hero:RemoveModifierByName("modifier_ankh_of_the_ancients")
	hero:RemoveModifierByName("modifier_trinket_nature")
	hero:RemoveModifierByName("modifier_trinket_vision")
	hero:RemoveModifierByName("modifier_world_trees_flower_cache")
	hero:RemoveModifierByName("modifier_sparkling_token_of_oceanis")
	hero:RemoveModifierByName("modifier_arcane_charm")
	hero:RemoveModifierByName("modifier_trinket_arcane")
	hero:RemoveModifierByName("modifier_trinket_undead")
	hero:RemoveModifierByName("modifier_winterblight_skull_ring")
	hero:RemoveModifierByName("modifier_trinket_all_elements")
	hero:RemoveModifierByName("modifier_frozen_heart")
	hero:RemoveModifierByName("modifier_red_divinex_amulet")
	hero:RemoveModifierByName("modifier_green_divinex_amulet")
	hero:RemoveModifierByName("modifier_blue_divinex_amulet")
	hero:RemoveModifierByName("modifier_puzzlers_locket")
	hero:RemoveModifierByName("modifier_galvanized_razor_band")
	hero:RemoveModifierByName("modifier_guadian_stone")
	hero:RemoveModifierByName("modifier_beryl_ring_of_intuiton")
	hero:RemoveModifierByName("modifier_auric_ring_of_inspiration")
	hero.monkey_paw = false
	hero.birdTable = false
	hero.eternal_frost_gem = false
	hero.galaxy_orb = false
	hero.tome_of_chaos = false
	hero.runeUnit.amulet.q_1 = 0
	hero.runeUnit.amulet.w_1 = 0
	hero.runeUnit.amulet.e_1 = 0
	hero.runeUnit.amulet.r_1 = 0
	hero.runeUnit2.amulet.q_2 = 0
	hero.runeUnit2.amulet.w_2 = 0
	hero.runeUnit2.amulet.e_2 = 0
	hero.runeUnit2.amulet.r_2 = 0
	hero.runeUnit3.amulet.q_3 = 0
	hero.runeUnit3.amulet.w_3 = 0
	hero.runeUnit3.amulet.e_3 = 0
	hero.runeUnit3.amulet.r_3 = 0
	hero.runeUnit4.amulet.q_4 = 0
	hero.runeUnit4.amulet.w_4 = 0
	hero.runeUnit4.amulet.e_4 = 0
	hero.runeUnit4.amulet.r_4 = 0
	Runes:ResetRuneBonuses(hero, "amulet")
end
