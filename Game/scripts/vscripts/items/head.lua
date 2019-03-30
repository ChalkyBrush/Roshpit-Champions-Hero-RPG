if Head == nil then
  Head = class({})
end


function Head:add_modifiers(hero, inventory_unit, item)
	print(item)
	local head_ability = inventory_unit:FindAbilityByName("helm_slot")
	head_ability.strength = 0
	head_ability.agility = 0
	head_ability.intelligence = 0
	head_ability.magic_resist = 0
	head_ability.armor = 0
	head_ability.health_regen = 0
	head_ability.mana_regen = 0
	head_ability.max_health = 0
	head_ability.max_mana = 0
	head_ability.respawn_reduce = 0
	head_ability.attack_speed = 0
	head_ability.attack_damage = 0
	head_ability.lifesteal = 0
	head_ability.base_ability = 0
	local property1 = RPCItems:AdjustAttributeValue(hero, item.property1)
	Head:action(item.property1name, property1, hero, inventory_unit, head_ability, item)
	Head:runeProperty(item.property1name, item.property1, hero)
	if item.property2name then
		local property2 = RPCItems:AdjustAttributeValue(hero, item.property2)
		Head:action(item.property2name, property2, hero, inventory_unit, head_ability, item)
		Head:runeProperty(item.property2name, item.property2, hero)
	end
	if item.property3name then
		local property3 = RPCItems:AdjustAttributeValue(hero, item.property3)
		Head:action(item.property3name, property3, hero, inventory_unit, head_ability, item)
		Head:runeProperty(item.property3name, item.property3, hero)
	end
	if item.property4name then
		local property4 = RPCItems:AdjustAttributeValue(hero, item.property4)
		Head:action(item.property4name, property4, hero, inventory_unit, head_ability, item)
		Head:runeProperty(item.property4name, item.property4, hero)
	end
end


function Head:action(propertyName, propertyValue, hero, inventory_unit, head_ability, item)
	if propertyName == "strength" then
		head_ability.strength = head_ability.strength + propertyValue
		Head:addBasicModifier(head_ability.strength, hero, inventory_unit, "modifier_helm_strength", head_ability)
	elseif propertyName == "agility" then
		head_ability.agility = head_ability.agility + propertyValue
		Head:addBasicModifier(head_ability.agility, hero, inventory_unit, "modifier_helm_agility", head_ability)
	elseif propertyName == "intelligence" then
		head_ability.intelligence = head_ability.intelligence + propertyValue
		Head:addBasicModifier(head_ability.intelligence, hero, inventory_unit, "modifier_helm_intelligence", head_ability)
	elseif propertyName == "magic_resist" then
		head_ability.magic_resist = head_ability.magic_resist + propertyValue
		Head:addBasicModifier(head_ability.magic_resist, hero, inventory_unit, "modifier_helm_magic_resist", head_ability)
	elseif propertyName == "armor" then
		head_ability.armor = head_ability.armor + propertyValue
		Head:addBasicModifier(head_ability.armor, hero, inventory_unit, "modifier_helm_armor", head_ability)
	elseif propertyName == "health_regen" then
		head_ability.health_regen = head_ability.health_regen + propertyValue
		Head:addBasicModifier(head_ability.health_regen, hero, inventory_unit, "modifier_helm_health_regen", head_ability)
	elseif propertyName == "mana_regen" then
		head_ability.mana_regen = head_ability.mana_regen + propertyValue
		Head:addBasicModifier(head_ability.mana_regen, hero, inventory_unit, "modifier_helm_mana_regen", head_ability)
	elseif propertyName == "max_health" then
		head_ability.max_health = head_ability.max_health + propertyValue
		Head:addBasicModifier(head_ability.max_health, hero, inventory_unit, "modifier_helm_max_health", head_ability)
	elseif propertyName == "max_mana" then
		head_ability.max_mana = head_ability.max_mana + propertyValue
		Head:addBasicModifier(head_ability.max_mana, hero, inventory_unit, "modifier_helm_max_mana", head_ability)
	elseif propertyName == "base_ability" then
		head_ability.base_ability = head_ability.base_ability + propertyValue
		Head:addBasicModifier(head_ability.base_ability, hero, inventory_unit, "modifier_helm_base_ability_damage", head_ability)
	elseif propertyName == "respawn_reduce" then
		head_ability.respawn_reduce = head_ability.respawn_reduce + propertyValue
		Head:addBasicModifier(head_ability.respawn_reduce, hero, inventory_unit, "modifier_helm_respawn", head_ability)
	elseif propertyName == "white_mage_hat" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_white_mage_hat", item)
	elseif propertyName == "attack_speed" then
		head_ability.attack_speed = head_ability.attack_speed + propertyValue
		Head:addBasicModifier(head_ability.attack_speed, hero, inventory_unit, "modifier_helm_attack_speed", head_ability)
	elseif propertyName == "attack_damage" then
		head_ability.attack_damage = head_ability.attack_damage + Amulet:AdjustAttackPowerBonus(hero, propertyValue)
		Head:addBasicModifier(head_ability.attack_damage, hero, inventory_unit, "modifier_helm_attack_damage", head_ability)
	elseif propertyName == "lifesteal" then
		print("LIFESTEAL: ")
		head_ability.lifesteal = head_ability.lifesteal + propertyValue
		print(head_ability.lifesteal)
		Head:addBasicModifier(head_ability.lifesteal, hero, inventory_unit, "modifier_helm_lifesteal", head_ability)
	elseif propertyName == "vision" then
		Head:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_helm_vision", head_ability)
	elseif propertyName == "hyper_visor" then	
		Head:addItemModifier(0, hero, inventory_unit, "modifier_hyper_visor", item)
	elseif propertyName == "ruby_dragon" then
		Head:addBasicModifier(1, hero, inventory_unit, "modifier_ruby_dragon", head_ability)
	elseif propertyName == "centaur_horns" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_centaur_horns", item)
	elseif propertyName == "death_whisper" then
		Head:addBasicModifier(1, hero, inventory_unit, "modifier_death_whisper", head_ability)
	elseif propertyName == "wild_nature_one" then
		Head:addBasicModifier(1, hero, inventory_unit, "modifier_wild_nature_one", head_ability)
	elseif propertyName == "wild_nature_two" then
		Head:addBasicModifier(1, hero, inventory_unit, "modifier_wild_nature_two", head_ability)
	elseif propertyName == "luma_guard" then
		Head:addBasicModifier(1, hero, inventory_unit, "modifier_luma_guard", head_ability)
	elseif propertyName == "odin" then
		Head:addBasicModifier(1, hero, inventory_unit, "modifier_helm_odin", head_ability)
	elseif propertyName == "iron_colossus" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_iron_colossus", item)
		hero:SetModelScale(hero.origModelScale*1.15)
	elseif propertyName == "mugato" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_mugato", item)
	elseif propertyName == "swamp_witch" then
		hero.witchHat = item
		Head:addItemModifier(0, hero, inventory_unit, "modifier_witch_hat", item)
	elseif propertyName == "trickster" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_trickster_mask", item)
		hero.tricksterItem = item
	elseif propertyName == "emerald_douli" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_emerald_douli", item)
	elseif propertyName == "tyrius" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_mask_of_tyrius", item)
	elseif propertyName == "cerulean_highguard" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_cerulean_high_guard", item)
	elseif propertyName == "all_attributes" then
		Head:action("strength", propertyValue, hero, inventory_unit, head_ability, item)
		Head:action("agility", propertyValue, hero, inventory_unit, head_ability, item)
		Head:action("intelligence", propertyValue, hero, inventory_unit, head_ability, item)
	elseif propertyName == "super_ascendency" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_super_ascendency", item)
		hero.InventoryUnit.ascendancy = item
	elseif propertyName == "phantom_sorcerer" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_phantom_sorcerer", item)
	elseif propertyName == "arcane_cascade" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_arcane_cascade_hat", item)
	elseif propertyName == "samurai_helmet" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_samurai_helmet", item)
	elseif propertyName == "scourge_knight" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_scourge_knight", item)
	elseif propertyName == "undertaker" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_undertakers_hood", item)
	elseif propertyName == "eternal_night" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_eternal_night", item)
	elseif propertyName == "druid_spirit" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_druid_spirit_helm", item)
		hero.druid_spirit = item
	elseif propertyName == "glint_of_onu" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_blinded_glint", item)
	elseif propertyName == "roknar" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_roknar_emperor", item)
	elseif propertyName == "swamp_doctor" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_swamp_doctor_mask", item)
	elseif propertyName == "desert_necromancer" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_desert_necromancer", item)
		hero.necro_hood = item
	elseif propertyName == "brazen_kabuto" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_brazen_kabuto", item)
		hero.kabuto = item
	elseif propertyName == "blackfeather" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_blackfeather_crown", item)
	elseif propertyName == "wraith" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_wraith_crown", item)
		hero.wraith_crown = item
	elseif propertyName == "demon_mask" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_demon_mask", item)
	elseif propertyName == "umbral" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_crest_of_the_umbral_sentinel", item)
	elseif propertyName == "carbuncle" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_carbuncles_helm_of_reflection", item)
	elseif propertyName == "grithault" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_guard_of_grithault", item)
	elseif propertyName == "wraith_hunter" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_wraith_hunters_steel_helm", item)
	elseif propertyName == "lava_forge" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_crown_of_the_lava_forge", item)
	elseif propertyName == "hood_of_defiler" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_hood_of_defiler", item)
	elseif propertyName == "excavator" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_excavators_focus_cap", item)
	elseif propertyName == "stormcrack" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_stormcrack_helm", item)
	elseif propertyName == "stormcrack2" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_stormcrack_helm2", item)
	elseif propertyName == "basilisk_plague" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_basilisk_plague_helm", item)
	elseif propertyName == "black_mage" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_hood_of_the_black_mage", item)
	elseif propertyName == "autumn_sleeper" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_autumn_sleeper_mask", item)
	elseif propertyName == "eye_of_seasons" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_eye_of_seasons", item)
	elseif propertyName == "silent_templar" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_helm_of_silent_templar", item)
	elseif propertyName == "wind_deity" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_wind_deity_crown", item)
	elseif propertyName == "water_deity" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_water_deity_crown", item)
	elseif propertyName == "fire_deity" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_fire_deity_crown", item)
	elseif propertyName == "shipyard_veil" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_shipyard_veil", item)
	elseif propertyName == "crimson_skull_cap" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_crimson_skull_cap", item)
	elseif propertyName == "lords" then
		hero:AddNewModifier( inventory_unit, nil, 'modifier_hood_of_lords_lua', nil )
	elseif propertyName == "igneous_canine" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_igneous_canine_helm", item)
	elseif propertyName == "flamewaker_arcana1" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_flamewaker_arcana1", item)
	elseif propertyName == "seinaru_arcana1" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_seinaru_arcana1", item)
	elseif propertyName == "white_mage_hat2" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_white_mage_hat2", item)
	elseif propertyName == "astral_arcana1" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_astral_arcana1", item)
	elseif propertyName == "undead" then
		Head:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_helm_undead", head_ability)
	elseif propertyName == "wind" then
		Head:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_helm_wind", head_ability)
	elseif propertyName == "demon" then
		Head:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_helm_demon", head_ability)
	elseif propertyName == "shadow" then
		Head:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_helm_shadow", head_ability)
	elseif propertyName == "poison" then
		Head:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_helm_poison", head_ability)
	elseif propertyName == "burning_spirit" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_burning_spirit_helmet", item)
	elseif string.match(propertyName, "!arcana!") then
		RPCItems:PreacheArcanaResources(item)
		local suffix = propertyName:gsub("!arcana!_", "")
		local modifierName = "modifier_"..suffix
		print(modifierName)
		Head:addItemModifier(0, hero, inventory_unit, modifierName, item)
	elseif propertyName == "shark_helmet" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_dark_reef_shark_helmet", item)
		RPCItems:PreacheArcanaResources(item)
	elseif propertyName == "sea_oracle" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_hood_of_the_sea_oracle", item)
		RPCItems:PreacheArcanaResources(item)
	elseif propertyName == "all_elements" then
		Head:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_helm_all_elements", head_ability)
	elseif propertyName == "mask_of_ahnqir_yellow" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_mask_of_ahnqhir_yellow", item)
	elseif propertyName == "mask_of_ahnqir_blue" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_mask_of_ahnqhir_blue", item)
	elseif propertyName == "mask_of_ahnqir_purple" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_mask_of_ahnqhir_purple", item)
	elseif propertyName == "frostmaw" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_frostmaw_hunters_hood", item)
		RPCItems:PreacheArcanaResources(item)
	elseif propertyName == "orthok" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_chains_of_orthok", item)
	elseif propertyName == "mountain_giant" then
		Head:addItemModifier(0, hero, inventory_unit, "modifier_helm_of_the_mountain_giant", item)
	end
	hero.headItem = item
end

function Head:addItemModifier(propertyValue, hero, inventory_unit, modifier_name, head_ability)
	head_ability:ApplyDataDrivenModifier(inventory_unit, hero, modifier_name, {})
	if propertyValue > 0 then
		hero:SetModifierStackCount( modifier_name, head_ability, propertyValue )
	end
end

function Head:runeProperty(propertyName, propertyValue, hero)
	if hero:HasModifier("modifier_puzzlers_locket") then
		if string.match(propertyName, "_2") then
			propertyName = string.gsub(propertyName, "_2", "_3")
		elseif string.match(propertyName, "_3")
			propertyName = string.gsub(propertyName, "_3", "_2")
		end
	end
	if propertyName == "rune_q_1" then
		hero.runeUnit.head.q_1 = hero.runeUnit.head.q_1 + propertyValue
		Head:setRuneBonusNetTable(hero.runeUnit.head.q_1, propertyName, hero)
	elseif propertyName == "rune_w_1" then
		hero.runeUnit.head.w_1 = hero.runeUnit.head.w_1 + propertyValue
		Head:setRuneBonusNetTable(hero.runeUnit.head.w_1, propertyName, hero)
	elseif propertyName == "rune_e_1" then
		hero.runeUnit.head.e_1 = hero.runeUnit.head.e_1 + propertyValue
		Head:setRuneBonusNetTable(hero.runeUnit.head.e_1, propertyName, hero)
	elseif propertyName == "rune_r_1" then
		hero.runeUnit.head.r_1 = hero.runeUnit.head.r_1 + propertyValue
		Head:setRuneBonusNetTable(hero.runeUnit.head.r_1, propertyName, hero)
	elseif propertyName == "rune_q_2" then
		hero.runeUnit2.head.q_2 = hero.runeUnit2.head.q_2 + propertyValue
		Head:setRuneBonusNetTable(hero.runeUnit2.head.q_2, propertyName, hero)
	elseif propertyName == "rune_w_2" then
		hero.runeUnit2.head.w_2 = hero.runeUnit2.head.w_2 + propertyValue
		Head:setRuneBonusNetTable(hero.runeUnit2.head.w_2, propertyName, hero)
	elseif propertyName == "rune_e_2" then
		hero.runeUnit2.head.e_2 = hero.runeUnit2.head.e_2 + propertyValue
		Head:setRuneBonusNetTable(hero.runeUnit2.head.e_2, propertyName, hero)
	elseif propertyName == "rune_r_2" then
		hero.runeUnit2.head.r_2 = hero.runeUnit2.head.r_2 + propertyValue
		Head:setRuneBonusNetTable(hero.runeUnit2.head.r_2, propertyName, hero)
	elseif propertyName == "rune_q_3" then
		hero.runeUnit3.head.q_3 = hero.runeUnit3.head.q_3 + propertyValue
		Head:setRuneBonusNetTable(hero.runeUnit3.head.q_3, propertyName, hero)
	elseif propertyName == "rune_w_3" then
		hero.runeUnit3.head.w_3 = hero.runeUnit3.head.w_3 + propertyValue
		Head:setRuneBonusNetTable(hero.runeUnit3.head.w_3, propertyName, hero)
	elseif propertyName == "rune_e_3" then
		hero.runeUnit3.head.e_3 = hero.runeUnit3.head.e_3 + propertyValue
		Head:setRuneBonusNetTable(hero.runeUnit3.head.e_3, propertyName, hero)
	elseif propertyName == "rune_r_3" then
		hero.runeUnit3.head.r_3 = hero.runeUnit3.head.r_3 + propertyValue
		Head:setRuneBonusNetTable(hero.runeUnit3.head.r_3, propertyName, hero)
	elseif propertyName == "rune_q_4" then
		hero.runeUnit4.head.q_4 = hero.runeUnit4.head.q_4 + propertyValue
		Head:setRuneBonusNetTable(hero.runeUnit4.head.q_4, propertyName, hero)
	elseif propertyName == "rune_w_4" then
		hero.runeUnit4.head.w_4 = hero.runeUnit4.head.w_4 + propertyValue
		Head:setRuneBonusNetTable(hero.runeUnit4.head.w_4, propertyName, hero)
	elseif propertyName == "rune_e_4" then
		hero.runeUnit4.head.e_4 = hero.runeUnit4.head.e_4 + propertyValue
		Head:setRuneBonusNetTable(hero.runeUnit4.head.e_4, propertyName, hero)
	elseif propertyName == "rune_r_4" then
		hero.runeUnit4.head.r_4 = hero.runeUnit4.head.r_4 + propertyValue
		Head:setRuneBonusNetTable(hero.runeUnit4.head.r_4, propertyName, hero)
	end
end

function Head:setRuneBonusNetTable(value, rune, hero)
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()).."_"..rune.."_head", {bonus = value} )
	print("Setting Rune Net Table: ")
	print(tostring(hero:GetEntityIndex()).."_"..rune.."_head")
end

function Head:addBasicModifier(propertyValue, hero, inventory_unit, modifier_name, head_ability)
	print(inventory_unit)
	--local stacks = hero:GetModifierStackCount(modifierName, inventory_unit)
	head_ability = inventory_unit:FindAbilityByName("helm_slot")
	head_ability:ApplyDataDrivenModifier(inventory_unit, hero, modifier_name, {})
	--hero:SetModifierStackCount( modifier_name, head_ability, (propertyValue+stacks) )
	hero:SetModifierStackCount( modifier_name, head_ability, propertyValue )
	print(propertyValue)
	print(modifier_name)
end

function Head:remove_modifiers(hero)
	print("REMOVE HEAD MODIFIERS")
	local headModifierTable = {"modifier_helm_strength", "modifier_helm_agility", "modifier_helm_intelligence", "modifier_helm_magic_resist", "modifier_helm_base_ability_damage", "modifier_helm_armor", "modifier_helm_health_regen", "modifier_helm_mana_regen","modifier_helm_max_health","modifier_helm_max_mana", "modifier_hyper_visor", "modifier_helm_respawn","modifier_white_mage_hat", "attack_speed", "modifier_ruby_dragon", "modifier_centaur_horns", "modifier_death_whisper", "modifier_wild_nature_one", "modifier_wild_nature_two", "modifier_luma_guard", "modifier_helm_odin", "modifier_mugato", "modifier_witch_hat", "modifier_trickster_mask", "modifier_emerald_douli", "modifier_mask_of_tyrius", "modifier_tyrius_buff", "modifier_cerulean_high_guard", "modifier_helm_attack_damage", "modifier_super_ascendency", "modifier_phantom_sorcerer", "modifier_arcane_cascade_hat", "modifier_samurai_helmet", "modifier_helm_lifesteal", "modifier_scourge_knight", "modifier_undertakers_hood", "modifier_eternal_night", "modifier_druid_spirit_helm", "modifier_blinded_glint", "modifier_roknar_emperor", "modifier_swamp_doctor_mask", "modifier_desert_necromancer", "modifier_brazen_kabuto", "modifier_blackfeather_crown", "modifier_wraith_crown", "modifier_demon_mask", "modifier_crest_of_the_umbral_sentinel", "modifier_carbuncles_helm_of_reflection", "modifier_guard_of_grithault", "modifier_wraith_hunters_steel_helm", "modifier_crown_of_the_lava_forge", "modifier_hood_of_defiler", "modifier_excavators_focus_cap", "modifier_stormcrack_helm", "modifier_basilisk_plague_helm", "modifier_hood_of_the_black_mage", "modifier_autumn_sleeper_mask", "modifier_eye_of_seasons", "modifier_helm_of_silent_templar", "modifier_wind_deity_crown", "modifier_water_deity_crown", "modifier_fire_deity_crown", "modifier_shipyard_veil", "modifier_crimson_skull_cap", "modifier_hood_of_lords_lua", "modifier_igneous_canine_helm", "modifier_flamewaker_arcana1", "modifier_seinaru_arcana1", "modifier_white_mage_hat2", "modifier_astral_arcana1", "modifier_stormcrack_helm2", "modifier_helm_undead", "modifier_helm_wind", "modifier_helm_demon", "modifier_helm_shadow", "modifier_helm_poison", "modifier_burning_spirit_helmet", "modifier_auriun_arcana1", "modifier_auriun_arcana2", "modifier_epoch_arcana1", "modifier_ekkan_arcana1", "modifier_arkimus_arcana1", "modifier_dark_reef_shark_helmet", "modifier_hood_of_the_sea_oracle", "modifier_helm_all_elements", "modifier_mask_of_ahnqhir_purple", "modifier_mask_of_ahnqhir_yellow", "modifier_mask_of_ahnqhir_blue", "modifier_solunia_arcana1", "modifier_sorceress_arcana2", "modifier_venomort_arcana2", "modifier_frostmaw_hunters_hood", "modifier_chains_of_orthok", "modifier_helm_of_the_mountain_giant", "modifier_voltex_arcana2", "modifier_conjuror_arcana3"}
	for i = 1, #headModifierTable, 1 do
		hero:RemoveModifierByName(headModifierTable[i])
	end
	hero.wraith_crown = nil
	hero.necro_hood = nil
	hero.kabuto = nil
	if hero:HasModifier("modifier_iron_colossus") then
		hero:RemoveModifierByName("modifier_iron_colossus")
		hero:RemoveModifierByName("modifier_iron_colossus_attack_speed_loss")
		hero:RemoveModifierByName("modifier_colossus_attack_range_gain")
		hero:RemoveModifierByName("modifier_iron_colossus_attack_range_loss")
		hero:RemoveModifierByName("modifier_iron_colossus_attack_damage_increase")
		hero:SetModelScale(hero.origModelScale)
	end
	Head:remove_rune_bonuses(hero)
end

function Head:remove_rune_bonuses(hero)
	hero.runeUnit.head.q_1 = 0
	hero.runeUnit.head.w_1 = 0
	hero.runeUnit.head.e_1 = 0
	hero.runeUnit.head.r_1 = 0
	hero.runeUnit2.head.q_2 = 0
	hero.runeUnit2.head.w_2 = 0
	hero.runeUnit2.head.e_2 = 0
	hero.runeUnit2.head.r_2 = 0
	hero.runeUnit3.head.q_3 = 0
	hero.runeUnit3.head.w_3 = 0
	hero.runeUnit3.head.e_3 = 0
	hero.runeUnit3.head.r_3 = 0
	hero.runeUnit4.head.q_4 = 0
	hero.runeUnit4.head.w_4 = 0
	hero.runeUnit4.head.e_4 = 0
	hero.runeUnit4.head.r_4 = 0
	Runes:ResetRuneBonuses(hero, "head")
end