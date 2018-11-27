if Foot == nil then
  Foot = class({})
end


function Foot:add_modifiers(hero, inventory_unit, item)
	print(item)
	local foot_ability = inventory_unit:FindAbilityByName("foot_slot")
	foot_ability.strength = 0
	foot_ability.agility = 0
	foot_ability.intelligence = 0
	foot_ability.magic_resist = 0
	foot_ability.armor = 0
	foot_ability.health_regen = 0
	foot_ability.mana_regen = 0
	foot_ability.movespeed = 0
	foot_ability.movespeed_slow = 0
	foot_ability.movespeed_max = 0
	foot_ability.respawn_reduce = 0
	foot_ability.evasion = 0
	foot_ability.base_ability = 0
	foot_ability.max_health = 0
	local property1 = RPCItems:AdjustAttributeValue(hero, item.property1)
	Foot:action(item.property1name, property1, hero, inventory_unit, foot_ability, item)
	Foot:runeProperty(item.property1name, item.property1, hero)
	if item.property2name then
		local property2 = RPCItems:AdjustAttributeValue(hero, item.property2)
		Foot:action(item.property2name, property2, hero, inventory_unit, foot_ability, item)
		Foot:runeProperty(item.property2name, item.property2, hero)
	end
	if item.property3name then
		local property3 = RPCItems:AdjustAttributeValue(hero, item.property3)
		Foot:action(item.property3name, property3, hero, inventory_unit, foot_ability, item)
		Foot:runeProperty(item.property3name, item.property3, hero)
	end
	if item.property4name then
		local property4 = RPCItems:AdjustAttributeValue(hero, item.property4)
		Foot:action(item.property4name, property4, hero, inventory_unit, foot_ability, item)
		Foot:runeProperty(item.property4name, item.property4, hero)
	end
end


function Foot:action(propertyName, propertyValue, hero, inventory_unit, foot_ability, item)
	if propertyName == "strength" then
		foot_ability.strength = foot_ability.strength + propertyValue
		Foot:addBasicModifier(foot_ability.strength, hero, inventory_unit, "modifier_foot_strength", foot_ability)
	elseif propertyName == "agility" then
		foot_ability.agility = foot_ability.agility + propertyValue
		Foot:addBasicModifier(foot_ability.agility, hero, inventory_unit, "modifier_foot_agility", foot_ability)
	elseif propertyName == "intelligence" then
		foot_ability.intelligence = foot_ability.intelligence + propertyValue
		Foot:addBasicModifier(foot_ability.intelligence, hero, inventory_unit, "modifier_foot_intelligence", foot_ability)
	elseif propertyName == "magic_resist" then
		foot_ability.magic_resist = foot_ability.magic_resist + propertyValue
		Foot:addBasicModifier(foot_ability.magic_resist, hero, inventory_unit, "modifier_foot_magic_resist", foot_ability)
	elseif propertyName == "armor" then
		foot_ability.armor = foot_ability.armor + propertyValue
		Foot:addBasicModifier(foot_ability.armor, hero, inventory_unit, "modifier_foot_armor", foot_ability)
	elseif propertyName == "health_regen" then
		foot_ability.health_regen = foot_ability.health_regen + propertyValue
		Foot:addBasicModifier(foot_ability.health_regen, hero, inventory_unit, "modifier_foot_health_regen", foot_ability)
	elseif propertyName == "mana_regen" then
		foot_ability.mana_regen = foot_ability.mana_regen + propertyValue
		Foot:addBasicModifier(foot_ability.mana_regen, hero, inventory_unit, "modifier_foot_mana_regen", foot_ability)
	elseif propertyName == "movespeed" then
		foot_ability.movespeed = foot_ability.movespeed + propertyValue
		Foot:addBasicModifier(foot_ability.movespeed, hero, inventory_unit, "modifier_foot_movespeed", foot_ability)
	elseif propertyName == "movespeed_slow" then
		foot_ability.movespeed_slow = foot_ability.movespeed_slow + propertyValue
		Foot:addBasicModifier(foot_ability.movespeed_slow, hero, inventory_unit, "modifier_foot_movespeed_slow", foot_ability)
	elseif propertyName == "movespeed_max" then
		foot_ability.movespeed_max = foot_ability.movespeed_max + propertyValue
		Foot:addBasicModifier(foot_ability.movespeed_max, hero, inventory_unit, "modifier_foot_max_movespeed", foot_ability)
	elseif propertyName == "respawn_reduce" then
		foot_ability.respawn_reduce = foot_ability.respawn_reduce + propertyValue
		Foot:addBasicModifier(foot_ability.respawn_reduce, hero, inventory_unit, "modifier_foot_respawn", foot_ability)
	elseif propertyName == "max_health" then
		foot_ability.max_health = foot_ability.max_health + propertyValue
		Foot:addBasicModifier(foot_ability.max_health, hero, inventory_unit, "modifier_foot_max_health", foot_ability)
	elseif propertyName == "evasion" then
		foot_ability.evasion = foot_ability.evasion + propertyValue
		Foot:addBasicModifier(foot_ability.evasion, hero, inventory_unit, "modifier_foot_evasion", foot_ability)
	elseif propertyName == "base_ability" then
		foot_ability.base_ability = foot_ability.base_ability + propertyValue
		Foot:addBasicModifier(foot_ability.base_ability, hero, inventory_unit, "modifier_foot_base_ability_damage", foot_ability)
	elseif propertyName == "ghost_walk" then
		Foot:addBasicModifier(1, hero, inventory_unit, "modifier_foot_unit_walk", foot_ability)
	elseif propertyName == "dunetread" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_dunetread_boots", item)
	elseif propertyName == "violet_boots" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_violet_boots", item)
		item.hero = hero
		hero.violetBoot = item
	elseif propertyName == "slinger" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_slinger_boots", item)
	elseif propertyName == "guardian_greaves" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_guardian_greaves", item)
		item.inventory_unit = inventory_unit
	elseif propertyName == "tranquil" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_tranquil_boots", item)
	elseif propertyName == "sange" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_rpc_sange_boots", item)
	elseif propertyName == "mana_stride" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_mana_striders", item)
	elseif propertyName == "yasha" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_rpc_yasha_boots", item)
	elseif propertyName == "fire_walker" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_fire_walkers", item)
	elseif propertyName == "moon_tech" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_moon_techs", item)
	elseif propertyName == "sonic_boot" then
		inventory_unit.foot_item = item
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_sonic_boots", item)
	elseif propertyName == "falcon_boot" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_falcon_boots", item)
	elseif propertyName == "admiral" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_admiral_boots", item)
	elseif propertyName == "rooted_feet" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_rooted_feet", item)
	elseif propertyName == "crusader" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_devotion_aura", item)
	elseif propertyName == "arcanys" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_arcanys_slipper", item)
		hero.arcanys = item
	elseif propertyName == "voyager" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_voyager_boots", item)
	elseif propertyName == "redrock" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_redrock_footwear", item)
		hero.redrock = item
	elseif propertyName == "pathfinder" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_pathfinder_resonant", item)
	elseif propertyName == "neptune" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_neptunes_water_gliders", item)
	elseif propertyName == "dragon_greaves" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_blue_dragon_greaves", item)
	elseif propertyName == "rubber_boot" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_resplendent_rubber_boots", item)
	elseif propertyName == "old_wisdom" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_boots_of_old_wisdom", item)
	elseif propertyName == "pure_waters" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_boots_of_pure_waters", item)
	elseif propertyName == "terrasic_lava" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_rpc_terrasic_lava_boots", item)
	elseif propertyName == "ablecore" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_ablecore_greaves", item)
	elseif propertyName == "giant_hunter" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_giant_hunters_boots", item)
	elseif propertyName == "redfall_runners" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_redfall_runners", item)
	elseif propertyName == "ashara" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_boots_of_ashara", item)
	elseif propertyName == "sandstream" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_sandstream_slippers", item)
	elseif propertyName == "crimsyth_elite" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_crimsyth_elite_greaves", item)
	elseif propertyName == "great_fortune" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_boots_of_great_fortune", item)
	elseif propertyName == "bloodstone" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_bloodstone_boots", item)
	elseif propertyName == "cosmos" then
		Foot:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_foot_cosmos", foot_ability)
	elseif propertyName == "arcane" then
		Foot:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_foot_arcane", foot_ability)
	elseif propertyName == "fire" then
		Foot:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_foot_fire", foot_ability)
	elseif propertyName == "holy" then
		Foot:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_foot_holy", foot_ability)
	elseif propertyName == "time" then
		Foot:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_foot_time", foot_ability)
	elseif propertyName == "temporal_warp" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_temporal_warp_boots", item)
	elseif propertyName == "ice" then
		Foot:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_foot_ice", foot_ability)
	elseif propertyName == "alarana" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_alaranas_ice_boot", item)
	elseif propertyName == "emerald_speed" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_emerald_speed_runners", item)
	elseif propertyName == "spirit_warrior_arcana3" then
		RPCItems:PreacheArcanaResources(item)
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_spirit_warrior_arcana3", item)
	elseif propertyName == "red_october" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_red_october_boots", item)
		RPCItems:PreacheArcanaResources(item)
	elseif propertyName == "steamboots" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_rpc_steamboots", item)
	elseif string.match(propertyName, "!arcana!") then
		RPCItems:PreacheArcanaResources(item)
		local suffix = propertyName:gsub("!arcana!_", "")
		local modifierName = "modifier_"..suffix
		print(modifierName)
		Head:addItemModifier(0, hero, inventory_unit, modifierName, item)
	elseif propertyName == "crystalline" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_crystalline_slippers", item)
	elseif propertyName == "oceanrunner" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_oceanrunner_boots", item)
	elseif propertyName == "gravelfoot" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_gravelfoot_treads", item)
		RPCItems:PreacheArcanaResources(item)
	elseif propertyName == "ice_floe" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_ice_floe_slippers", item)
		RPCItems:PreacheArcanaResources(item)
	elseif propertyName == "destruction" then
		Foot:addItemModifier(0, hero, inventory_unit, "modifier_iron_treads_of_destruction", item)
	end
	item.hero = hero
	hero.foot = item
end

function Foot:addItemModifier(propertyValue, hero, inventory_unit, modifier_name, foot_ability)
	foot_ability:ApplyDataDrivenModifier(inventory_unit, hero, modifier_name, {})
	if propertyValue > 0 then
		hero:SetModifierStackCount( modifier_name, foot_ability, propertyValue )
	end
end

function Foot:addBasicModifier(propertyValue, hero, inventory_unit, modifier_name, foot_ability)
	print(inventory_unit)
	--local stacks = hero:GetModifierStackCount(modifierName, inventory_unit)
	foot_ability = inventory_unit:FindAbilityByName("foot_slot")
	foot_ability:ApplyDataDrivenModifier(inventory_unit, hero, modifier_name, {})
	--hero:SetModifierStackCount( modifier_name, foot_ability, (propertyValue+stacks) )
	hero:SetModifierStackCount( modifier_name, foot_ability, propertyValue )
end

function Foot:remove_modifiers(hero)
	hero:RemoveModifierByName("modifier_foot_strength")
	hero:RemoveModifierByName("modifier_foot_agility")
	hero:RemoveModifierByName("modifier_foot_intelligence")
	hero:RemoveModifierByName("modifier_foot_magic_resist")
	hero:RemoveModifierByName("modifier_foot_armor")
	hero:RemoveModifierByName("modifier_foot_health_regen")
	hero:RemoveModifierByName("modifier_foot_mana_regen")
	hero:RemoveModifierByName("modifier_foot_movespeed")
	hero:RemoveModifierByName("modifier_foot_movespeed_slow")
	hero:RemoveModifierByName("modifier_foot_max_movespeed")
	hero:RemoveModifierByName("modifier_foot_respawn")
	hero:RemoveModifierByName("modifier_foot_evasion")
	hero:RemoveModifierByName("modifier_foot_unit_walk")
	hero:RemoveModifierByName("modifier_foot_base_ability_damage")
	hero:RemoveModifierByName("modifier_foot_max_health")

	hero:RemoveModifierByName("modifier_dunetread_boots")
	hero:RemoveModifierByName("modifier_violet_boots")
	hero:RemoveModifierByName("modifier_slinger_boots")
	hero:RemoveModifierByName("modifier_guardian_greaves")
	hero:RemoveModifierByName("modifier_tranquil_boots")
	hero:RemoveModifierByName("modifier_rpc_sange_boots")
	hero:RemoveModifierByName("modifier_rpc_sange_buff")
	hero:RemoveModifierByName("modifier_mana_striders")
	hero:RemoveModifierByName("modifier_rpc_yasha_boots")
	hero:RemoveModifierByName("modifier_rpc_yasha_buff")
	hero:RemoveModifierByName("modifier_fire_walkers")
	hero:RemoveModifierByName("modifier_falcon_boots")
	hero:RemoveModifierByName("modifier_moon_techs")
	hero:RemoveModifierByName("modifier_sonic_boots")
	hero:RemoveModifierByName("modifier_admiral_boots")
	hero:RemoveModifierByName("modifier_rooted_feet")
	hero:RemoveModifierByName("modifier_devotion_aura")
	hero:RemoveModifierByName("modifier_arcanys_slipper")
	hero:RemoveModifierByName("modifier_voyager_boots")
	hero:RemoveModifierByName("modifier_redrock_footwear")
	hero:RemoveModifierByName("modifier_pathfinder_resonant")
	hero:RemoveModifierByName("modifier_neptunes_water_gliders")
	hero:RemoveModifierByName("modifier_blue_dragon_greaves")
	hero:RemoveModifierByName("modifier_resplendent_rubber_boots")
	hero:RemoveModifierByName("modifier_boots_of_old_wisdom")
	hero:RemoveModifierByName("modifier_boots_of_pure_waters")
	hero:RemoveModifierByName("modifier_rpc_terrasic_lava_boots")
	hero:RemoveModifierByName("modifier_ablecore_greaves")
	hero:RemoveModifierByName("modifier_giant_hunters_boots")
	hero:RemoveModifierByName("modifier_redfall_runners")
	hero:RemoveModifierByName("modifier_boots_of_ashara")
	hero:RemoveModifierByName("modifier_sandstream_slippers")
	hero:RemoveModifierByName("modifier_crimsyth_elite_greaves")
	hero:RemoveModifierByName("modifier_boots_of_great_fortune")
	hero:RemoveModifierByName("modifier_bloodstone_boots")
	hero:RemoveModifierByName("modifier_foot_cosmos")
	hero:RemoveModifierByName("modifier_foot_arcane")
	hero:RemoveModifierByName("modifier_foot_fire")
	hero:RemoveModifierByName("modifier_foot_holy")
	hero:RemoveModifierByName("modifier_foot_time")
	hero:RemoveModifierByName("modifier_temporal_warp_boots")
	hero:RemoveModifierByName("modifier_foot_ice")
	hero:RemoveModifierByName("modifier_alaranas_ice_boot")
	hero:RemoveModifierByName("modifier_emerald_speed_runners")
	hero:RemoveModifierByName("modifier_spirit_warrior_arcana3")
	hero:RemoveModifierByName("modifier_voltex_arcana1")
	hero:RemoveModifierByName("modifier_red_october_boots")
	hero:RemoveModifierByName("modifier_zonik_arcana1")
	hero:RemoveModifierByName("modifier_crystalline_slippers")
	hero:RemoveModifierByName("modifier_oceanrunner_boots")
	hero:RemoveModifierByName("modifier_seinaru_arcana2")
	hero:RemoveModifierByName("modifier_rpc_steamboots")
	hero:RemoveModifierByName("modifier_paladin_arcana2")
	hero:RemoveModifierByName("modifier_mountain_protector_arcana3")
	hero:RemoveModifierByName("modifier_chernobog_arcana2")
	hero:RemoveModifierByName("modifier_gravelfoot_treads")
	hero:RemoveModifierByName("modifier_ice_floe_slippers")
	hero:RemoveModifierByName("modifier_iron_treads_of_destruction")
	hero:RemoveModifierByName("modifier_conjuror_arcana4")
	hero.arcanys = nil
	hero.redrock = nil

	Foot:remove_rune_bonuses(hero)
end

function Foot:runeProperty(propertyName, propertyValue, hero)
	if propertyName == "rune_q_1" then
		hero.runeUnit.foot.q_1 = hero.runeUnit.foot.q_1 + propertyValue
		Foot:setRuneBonusNetTable(hero.runeUnit.foot.q_1, propertyName, hero)
	elseif propertyName == "rune_w_1" then
		hero.runeUnit.foot.w_1 = hero.runeUnit.foot.w_1 + propertyValue
		Foot:setRuneBonusNetTable(hero.runeUnit.foot.w_1, propertyName, hero)
	elseif propertyName == "rune_e_1" then
		hero.runeUnit.foot.e_1 = hero.runeUnit.foot.e_1 + propertyValue
		Foot:setRuneBonusNetTable(hero.runeUnit.foot.e_1, propertyName, hero)
	elseif propertyName == "rune_r_1" then
		hero.runeUnit.foot.r_1 = hero.runeUnit.foot.r_1 + propertyValue
		Foot:setRuneBonusNetTable(hero.runeUnit.foot.r_1, propertyName, hero)
	elseif propertyName == "rune_q_2" then
		hero.runeUnit2.foot.q_2 = hero.runeUnit2.foot.q_2 + propertyValue
		Foot:setRuneBonusNetTable(hero.runeUnit2.foot.q_2, propertyName, hero)
	elseif propertyName == "rune_w_2" then
		hero.runeUnit2.foot.w_2 = hero.runeUnit2.foot.w_2 + propertyValue
		Foot:setRuneBonusNetTable(hero.runeUnit2.foot.w_2, propertyName, hero)
	elseif propertyName == "rune_e_2" then
		hero.runeUnit2.foot.e_2 = hero.runeUnit2.foot.e_2 + propertyValue
		Foot:setRuneBonusNetTable(hero.runeUnit2.foot.e_2, propertyName, hero)
	elseif propertyName == "rune_r_2" then
		hero.runeUnit2.foot.r_2 = hero.runeUnit2.foot.r_2 + propertyValue
		Foot:setRuneBonusNetTable(hero.runeUnit2.foot.r_2, propertyName, hero)
	elseif propertyName == "rune_q_3" then
		hero.runeUnit3.foot.q_3 = hero.runeUnit3.foot.q_3 + propertyValue
		Foot:setRuneBonusNetTable(hero.runeUnit3.foot.q_3, propertyName, hero)
	elseif propertyName == "rune_w_3" then
		hero.runeUnit3.foot.w_3 = hero.runeUnit3.foot.w_3 + propertyValue
		Foot:setRuneBonusNetTable(hero.runeUnit3.foot.w_3, propertyName, hero)
	elseif propertyName == "rune_e_3" then
		hero.runeUnit3.foot.e_3 = hero.runeUnit3.foot.e_3 + propertyValue
		Foot:setRuneBonusNetTable(hero.runeUnit3.foot.e_3, propertyName, hero)
	elseif propertyName == "rune_r_3" then
		hero.runeUnit3.foot.r_3 = hero.runeUnit3.foot.r_3 + propertyValue
		Foot:setRuneBonusNetTable(hero.runeUnit3.foot.r_3, propertyName, hero)
	elseif propertyName == "rune_q_4" then
		hero.runeUnit4.foot.q_4 = hero.runeUnit4.foot.q_4 + propertyValue
		Foot:setRuneBonusNetTable(hero.runeUnit4.foot.q_4, propertyName, hero)
	elseif propertyName == "rune_w_4" then
		hero.runeUnit4.foot.w_4 = hero.runeUnit4.foot.w_4 + propertyValue
		Foot:setRuneBonusNetTable(hero.runeUnit4.foot.w_4, propertyName, hero)
	elseif propertyName == "rune_e_4" then
		hero.runeUnit4.foot.e_4 = hero.runeUnit4.foot.e_4 + propertyValue
		Foot:setRuneBonusNetTable(hero.runeUnit4.foot.e_4, propertyName, hero)
	elseif propertyName == "rune_r_4" then
		hero.runeUnit4.foot.r_4 = hero.runeUnit4.foot.r_4 + propertyValue
		Foot:setRuneBonusNetTable(hero.runeUnit4.foot.r_4, propertyName, hero)
	end
end

function Foot:setRuneBonusNetTable(value, rune, hero)
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()).."_"..rune.."_foot", {bonus = value} )
	print("Setting Rune Net Table: ")
	print(tostring(hero:GetEntityIndex()).."_"..rune.."_foot")
end

function Foot:remove_rune_bonuses(hero)
	hero.runeUnit.foot.q_1 = 0
	hero.runeUnit.foot.w_1 = 0
	hero.runeUnit.foot.e_1 = 0
	hero.runeUnit.foot.r_1 = 0
	hero.runeUnit2.foot.q_2 = 0
	hero.runeUnit2.foot.w_2 = 0
	hero.runeUnit2.foot.e_2 = 0
	hero.runeUnit2.foot.r_2 = 0
	hero.runeUnit3.foot.q_3 = 0
	hero.runeUnit3.foot.w_3 = 0
	hero.runeUnit3.foot.e_3 = 0
	hero.runeUnit3.foot.r_3 = 0
	hero.runeUnit4.foot.q_4 = 0
	hero.runeUnit4.foot.w_4 = 0
	hero.runeUnit4.foot.e_4 = 0
	hero.runeUnit4.foot.r_4 = 0
	Runes:ResetRuneBonuses(hero, "foot")
end