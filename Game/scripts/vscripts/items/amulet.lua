if Amulet == nil then
  Amulet = class({})
end


function Amulet:add_modifiers(hero, inventory_unit, item)
	print(item)
	local trinket_ability = inventory_unit:FindAbilityByName("trinket_slot")
	trinket_ability.strength = 0
	trinket_ability.agility = 0
	trinket_ability.intelligence = 0
	trinket_ability.armor = 0
	trinket_ability.health_regen = 0
	trinket_ability.attack_damage = 0
	trinket_ability.max_health = 0
	trinket_ability.max_mana = 0
	trinket_ability.magic_resist = 0
	trinket_ability.base_ability = 0
	local property1 = RPCItems:AdjustAttributeValue(hero, item.property1)
	Amulet:action(item.property1name, property1, hero, inventory_unit, trinket_ability, item)
	Amulet:runeProperty(item.property1name, item.property1, hero)
	if item.property2name then
		local property2 = RPCItems:AdjustAttributeValue(hero, item.property2)
		Amulet:action(item.property2name, property2, hero, inventory_unit, trinket_ability, item)
		Amulet:runeProperty(item.property2name, item.property2, hero)
	end
	if item.property3name then
		local property3 = RPCItems:AdjustAttributeValue(hero, item.property3)
		Amulet:action(item.property3name, property3, hero, inventory_unit, trinket_ability, item)
		Amulet:runeProperty(item.property3name, item.property3, hero)
	end
	if item.property4name then
		local property4 = RPCItems:AdjustAttributeValue(hero, item.property4)
		Amulet:action(item.property4name, property4, hero, inventory_unit, trinket_ability, item)
		Amulet:runeProperty(item.property4name, item.property4, hero)
	end
	--CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "ability_tree_upgrade", {playerId="0"})
end


function Amulet:action(propertyName, propertyValue, hero, inventory_unit, trinket_ability, item)
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
	elseif propertyName == "attack_damage" then
		trinket_ability.attack_damage = trinket_ability.attack_damage + propertyValue
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
	elseif propertyName == "monkey_paw" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_monkey_paw", item)
		hero.monkey_paw = item
	elseif propertyName == "blacksmith" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_blacksmiths_tablet", item)
	elseif propertyName == "all_attributes" then
		trinket_ability.strength = trinket_ability.strength + propertyValue
		Amulet:addBasicModifier(trinket_ability.strength, hero, inventory_unit, "modifier_trinket_strength", trinket_ability)
		trinket_ability.agility = trinket_ability.agility + propertyValue
		Amulet:addBasicModifier(trinket_ability.agility, hero, inventory_unit, "modifier_trinket_agility", trinket_ability)		
		trinket_ability.intelligence = trinket_ability.intelligence + propertyValue
		Amulet:addBasicModifier(trinket_ability.intelligence, hero, inventory_unit, "modifier_trinket_intelligence", trinket_ability)
	elseif propertyName == "all_runes" then
		for i = 1, #AVAILABLE_RUNE_TABLE, 1 do
			Amulet:runeProperty(AVAILABLE_RUNE_TABLE[i], propertyValue, hero)
		end
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
	elseif propertyName == "raven" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_raven_idol", item)
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
		Amulet:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_trinket_cosmos", trinket_ability)
	elseif propertyName == "nature" then
		Amulet:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_trinket_nature", trinket_ability)
	elseif propertyName == "ice" then
		Amulet:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_trinket_ice", trinket_ability)
	elseif propertyName == "fire" then
		Amulet:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_trinket_fire", trinket_ability)
	elseif propertyName == "water" then
		Amulet:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_trinket_water", trinket_ability)
	elseif propertyName == "demon" then
		Amulet:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_trinket_demon", trinket_ability)
	elseif propertyName == "arcane" then
		Amulet:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_trinket_arcane", trinket_ability)
	elseif propertyName == "undead" then
		Amulet:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_trinket_undead", trinket_ability)
	elseif propertyName == "fire_blossom" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_fire_blossom", item)
	elseif propertyName == "aqua_lily" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_aqua_lily", item)
	elseif propertyName == "wind_orchid" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_wind_orchid", item)
	elseif propertyName == "ankh_of_ancients" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_ankh_of_the_ancients", item)
	elseif propertyName == "t4_runes" then
		local runeTable = {"rune_d_a", "rune_d_b", "rune_d_c", "rune_d_d"}
		for i = 1, #runeTable, 1 do
			Amulet:runeProperty(runeTable[i], propertyValue, hero)
		end
	elseif propertyName == "world_tree_flower" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_world_trees_flower_cache", item)
		RPCItems:PreacheArcanaResources(item)
	elseif propertyName == "oceanis" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_sparkling_token_of_oceanis", item)
	elseif propertyName == "arcane_charm" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_arcane_charm", item)
	elseif propertyName == "winterblight_skull_ring" then
		Amulet:addItemModifier(0, hero, inventory_unit, "modifier_winterblight_skull_ring", item)
	end
	hero.amulet = item
end

function Amulet:addItemModifier(propertyValue, hero, inventory_unit, modifier_name, amulet_ability)
	amulet_ability:ApplyDataDrivenModifier(inventory_unit, hero, modifier_name, {})
	if propertyValue > 0 then
		hero:SetModifierStackCount( modifier_name, amulet_ability, propertyValue )
	end
end

function Amulet:runeProperty(propertyName, propertyValue, hero)
	if propertyName == "rune_a_a" then
		hero.runeUnit.amulet.a_a = hero.runeUnit.amulet.a_a + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit.amulet.a_a, propertyName, hero)
	elseif propertyName == "rune_a_b" then
		hero.runeUnit.amulet.a_b = hero.runeUnit.amulet.a_b + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit.amulet.a_b, propertyName, hero)
	elseif propertyName == "rune_a_c" then
		hero.runeUnit.amulet.a_c = hero.runeUnit.amulet.a_c + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit.amulet.a_c, propertyName, hero)
	elseif propertyName == "rune_a_d" then
		hero.runeUnit.amulet.a_d = hero.runeUnit.amulet.a_d + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit.amulet.a_d, propertyName, hero)
	elseif propertyName == "rune_b_a" then
		hero.runeUnit2.amulet.b_a = hero.runeUnit2.amulet.b_a + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit2.amulet.b_a, propertyName, hero)
	elseif propertyName == "rune_b_b" then
		hero.runeUnit2.amulet.b_b = hero.runeUnit2.amulet.b_b + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit2.amulet.b_b, propertyName, hero)
	elseif propertyName == "rune_b_c" then
		hero.runeUnit2.amulet.b_c = hero.runeUnit2.amulet.b_c + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit2.amulet.b_c, propertyName, hero)
	elseif propertyName == "rune_b_d" then
		hero.runeUnit2.amulet.b_d = hero.runeUnit2.amulet.b_d + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit2.amulet.b_d, propertyName, hero)
	elseif propertyName == "rune_c_a" then
		hero.runeUnit3.amulet.c_a = hero.runeUnit3.amulet.c_a + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit3.amulet.c_a, propertyName, hero)
	elseif propertyName == "rune_c_b" then
		hero.runeUnit3.amulet.c_b = hero.runeUnit3.amulet.c_b + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit3.amulet.c_b, propertyName, hero)
	elseif propertyName == "rune_c_c" then
		hero.runeUnit3.amulet.c_c = hero.runeUnit3.amulet.c_c + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit3.amulet.c_c, propertyName, hero)
	elseif propertyName == "rune_c_d" then
		hero.runeUnit3.amulet.c_d = hero.runeUnit3.amulet.c_d + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit3.amulet.c_d, propertyName, hero)
	elseif propertyName == "rune_d_a" then
		hero.runeUnit4.amulet.d_a = hero.runeUnit4.amulet.d_a + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit4.amulet.d_a, propertyName, hero)
	elseif propertyName == "rune_d_b" then
		hero.runeUnit4.amulet.d_b = hero.runeUnit4.amulet.d_b + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit4.amulet.d_b, propertyName, hero)
	elseif propertyName == "rune_d_c" then
		hero.runeUnit4.amulet.d_c = hero.runeUnit4.amulet.d_c + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit4.amulet.d_c, propertyName, hero)
	elseif propertyName == "rune_d_d" then
		hero.runeUnit4.amulet.d_d = hero.runeUnit4.amulet.d_d + propertyValue
		Amulet:setRuneBonusNetTable(hero.runeUnit4.amulet.d_d, propertyName, hero)
	end
end

AVAILABLE_RUNE_TABLE = {"rune_a_a", "rune_a_b", "rune_a_c", "rune_a_d", "rune_b_a", "rune_b_b", "rune_b_c", "rune_b_d", "rune_c_a", "rune_c_b", "rune_c_c", "rune_c_d"}

function Amulet:setRuneBonusNetTable(value, rune, hero)
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()).."_"..rune.."_amulet", {bonus = value} )
	print("Setting Rune Net Table: ")
	print(tostring(hero:GetEntityIndex()).."_"..rune.."_amulet")
end

function Amulet:addBasicModifier(propertyValue, hero, inventory_unit, modifier_name, trinket_ability)
	print(inventory_unit)
	--local stacks = hero:GetModifierStackCount(modifierName, inventory_unit)
	local amulet_ability = inventory_unit:FindAbilityByName("trinket_slot")
	amulet_ability:ApplyDataDrivenModifier(inventory_unit, hero, modifier_name, {})
	--hero:SetModifierStackCount( modifier_name, trinket_ability, (propertyValue+stacks) )
	hero:SetModifierStackCount( modifier_name, amulet_ability, propertyValue )
end

function Amulet:remove_modifiers(hero)
	hero:RemoveModifierByName("modifier_trinket_strength")
	hero:RemoveModifierByName("modifier_trinket_agility")
	hero:RemoveModifierByName("modifier_trinket_intelligence")
	hero:RemoveModifierByName("modifier_trinket_armor")
	hero:RemoveModifierByName("modifier_trinket_attack_damage")
	hero:RemoveModifierByName("modifier_trinket_health_regen")
	hero:RemoveModifierByName("modifier_trinket_max_health")
	hero:RemoveModifierByName("modifier_trinket_base_ability_damage")
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
	hero:RemoveModifierByName("modifier_raven_idol")
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
	hero:RemoveModifierByName("modifier_world_trees_flower_cache")
	hero:RemoveModifierByName("modifier_sparkling_token_of_oceanis")
	hero:RemoveModifierByName("modifier_arcane_charm")
	hero:RemoveModifierByName("modifier_trinket_arcane")
	hero:RemoveModifierByName("modifier_trinket_undead")
	hero:RemoveModifierByName("modifier_winterblight_skull_ring")
	hero.monkey_paw = false
	hero.birdTable = false
	hero.eternal_frost_gem = false
	hero.galaxy_orb = false
	hero.tome_of_chaos = false
	hero.runeUnit.amulet.a_a = 0
	hero.runeUnit.amulet.a_b = 0
	hero.runeUnit.amulet.a_c = 0
	hero.runeUnit.amulet.a_d = 0
	hero.runeUnit2.amulet.b_a = 0
	hero.runeUnit2.amulet.b_b = 0
	hero.runeUnit2.amulet.b_c = 0
	hero.runeUnit2.amulet.b_d = 0
	hero.runeUnit3.amulet.c_a = 0
	hero.runeUnit3.amulet.c_b = 0
	hero.runeUnit3.amulet.c_c = 0
	hero.runeUnit3.amulet.c_d = 0
	hero.runeUnit4.amulet.d_a = 0
	hero.runeUnit4.amulet.d_b = 0 
	hero.runeUnit4.amulet.d_c = 0 
	hero.runeUnit4.amulet.d_d = 0
	Runes:ResetRuneBonuses(hero, "amulet")
end