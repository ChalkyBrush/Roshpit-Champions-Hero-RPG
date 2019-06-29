if Hand == nil then
	Hand = class({})
end

function Hand:add_modifiers(hero, inventory_unit, item)
	--print("[Hand:add_modifiers] ++++++++++++++++++++++++++++++++++++++++++++")
	--DeepPrintTable(item)
	if not item.newItemTable then
		--print("[Error] Hand:add_modifiers item.newItemTable is null")
		RPCItems:ItemUTIL_Remove(item)
		return
	end
	local hand_ability = inventory_unit:FindAbilityByName("hand_slot")
	hand_ability.strength = 0
	hand_ability.agility = 0
	hand_ability.intelligence = 0
	hand_ability.magic_resist = 0
	hand_ability.armor = 0
	hand_ability.health_regen = 0
	hand_ability.mana_regen = 0
	hand_ability.attack_speed = 0
	hand_ability.cooldown_reduce = 0
	hand_ability.respawn_reduce = 0
	hand_ability.max_health = 0
	hand_ability.lifesteal = 0
	hand_ability.base_ability = 0
	hand_ability.item_damage = 0
	hand_ability.attack_damage = 0
	if item.newItemTable.property1name then
		local property1 = RPCItems:AdjustAttributeValue(hero, item.newItemTable.property1)
		Hand:action(item.newItemTable.property1name, property1, hero, inventory_unit, hand_ability, item)
		Hand:runeProperty(item.newItemTable.property1name, item.newItemTable.property1, hero)
	end
	if item.newItemTable.property2name then
		local property2 = RPCItems:AdjustAttributeValue(hero, item.newItemTable.property2)
		Hand:action(item.newItemTable.property2name, property2, hero, inventory_unit, hand_ability, item)
		Hand:runeProperty(item.newItemTable.property2name, item.newItemTable.property2, hero)
	end
	if item.newItemTable.property3name then
		local property3 = RPCItems:AdjustAttributeValue(hero, item.newItemTable.property3)
		Hand:action(item.newItemTable.property3name, property3, hero, inventory_unit, hand_ability, item)
		Hand:runeProperty(item.newItemTable.property3name, item.newItemTable.property3, hero)
	end
	if item.newItemTable.property4name then
		local property4 = RPCItems:AdjustAttributeValue(hero, item.newItemTable.property4)
		Hand:action(item.newItemTable.property4name, property4, hero, inventory_unit, hand_ability, item)
		Hand:runeProperty(item.newItemTable.property4name, item.newItemTable.property4, hero)
	end
end

function Hand:action(propertyName, propertyValue, hero, inventory_unit, hand_ability, item)
	--print("[Hand:action] propertyName:"..tostring(propertyName))
	if type(propertyValue) == "string" then
		--print("[action] type(propertyValue) == string")
		propertyValue = 1
	end
	if propertyName == "strength" then
		hand_ability.strength = hand_ability.strength + propertyValue
		Hand:addBasicModifier(hand_ability.strength, hero, inventory_unit, "modifier_hand_strength", hand_ability)
	elseif propertyName == "agility" then
		hand_ability.agility = hand_ability.agility + propertyValue
		Hand:addBasicModifier(hand_ability.agility, hero, inventory_unit, "modifier_hand_agility", hand_ability)
	elseif propertyName == "intelligence" then
		hand_ability.intelligence = hand_ability.intelligence + propertyValue
		Hand:addBasicModifier(hand_ability.intelligence, hero, inventory_unit, "modifier_hand_intelligence", hand_ability)
	elseif propertyName == "magic_resist" then
		hand_ability.magic_resist = hand_ability.magic_resist + propertyValue
		Hand:addBasicModifier(hand_ability.magic_resist, hero, inventory_unit, "modifier_hand_magic_resist", hand_ability)
	elseif propertyName == "armor" then
		hand_ability.armor = hand_ability.armor + propertyValue
		Hand:addBasicModifier(hand_ability.armor, hero, inventory_unit, "modifier_hand_armor", hand_ability)
	elseif propertyName == "health_regen" then
		hand_ability.health_regen = hand_ability.health_regen + propertyValue
		Hand:addBasicModifier(hand_ability.health_regen, hero, inventory_unit, "modifier_hand_health_regen", hand_ability)
	elseif propertyName == "mana_regen" then
		hand_ability.mana_regen = hand_ability.mana_regen + propertyValue
		Hand:addBasicModifier(hand_ability.mana_regen, hero, inventory_unit, "modifier_hand_mana_regen", hand_ability)
	elseif propertyName == "attack_speed" then
		hand_ability.attack_speed = hand_ability.attack_speed + propertyValue
		Hand:addBasicModifier(hand_ability.attack_speed, hero, inventory_unit, "modifier_hand_attack_speed", hand_ability)
	elseif propertyName == "cooldown_reduction" then
		hand_ability.cooldown_reduce = hand_ability.cooldown_reduce + propertyValue
		Hand:addBasicModifier(hand_ability.cooldown_reduce, hero, inventory_unit, "modifier_hand_cooldown_reduce", hand_ability)
	elseif propertyName == "attack_damage" then
		hand_ability.attack_damage = hand_ability.attack_damage + Amulet:AdjustAttackPowerBonus(hero, propertyValue)
		Hand:addBasicModifier(hand_ability.attack_damage, hero, inventory_unit, "modifier_hand_attack_damage", hand_ability)
	elseif propertyName == "respawn_reduce" then
		hand_ability.respawn_reduce = hand_ability.respawn_reduce + propertyValue
		Hand:addBasicModifier(hand_ability.respawn_reduce, hero, inventory_unit, "modifier_hand_respawn", hand_ability)
	elseif propertyName == "max_health" then
		hand_ability.max_health = hand_ability.max_health + propertyValue
		Hand:addBasicModifier(hand_ability.max_health, hero, inventory_unit, "modifier_hand_max_health", hand_ability)
	elseif propertyName == "lifesteal" then
		hand_ability.lifesteal = hand_ability.lifesteal + propertyValue
		Hand:addBasicModifier(hand_ability.lifesteal, hero, inventory_unit, "modifier_hand_lifesteal", hand_ability)
	elseif propertyName == "base_ability" then
		hand_ability.base_ability = hand_ability.base_ability + propertyValue
		Hand:addBasicModifier(hand_ability.base_ability, hero, inventory_unit, "modifier_hand_base_ability_damage", hand_ability)
	elseif propertyName == "item_damage" then
		hand_ability.item_damage = hand_ability.item_damage + propertyValue
		Hand:addBasicModifier(hand_ability.item_damage, hero, inventory_unit, "modifier_hand_item_damage_inc", hand_ability)
	elseif propertyName == "berserker_rage" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_berserker_gloves_base", item)
	elseif propertyName == "shadow_armlet" then
		Hand:addBasicModifier(1, hero, inventory_unit, "modifier_shadow_armlet", hand_ability)
	elseif propertyName == "boneguard" then
		Hand:addBasicModifier(1, hero, inventory_unit, "modifier_hand_boneguard", hand_ability)
	elseif propertyName == "scorched_gauntlet" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_hand_scorched_earth", item)
	elseif propertyName == "pride" then
		Hand:addBasicModifier(1, hero, inventory_unit, "modifier_hand_pride", hand_ability)
	elseif propertyName == "azinoth" then
		Hand:addBasicModifier(1, hero, inventory_unit, "modifier_hand_azinoth", hand_ability)
	elseif propertyName == "divine_purity" then
		Hand:addBasicModifier(1, hero, inventory_unit, "modifier_divine_purity", hand_ability)
	elseif propertyName == "marauder" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_hand_marauder", item)
	elseif propertyName == "elder_grasp" then
		RPCItems:PreacheArcanaResources(item)
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_grasp_of_elder", item)
	elseif propertyName == "midas" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_hand_of_midas", item)
	elseif propertyName == "scarecrow" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_scarecrow_gloves", item)
	elseif propertyName == "living_gauntlet" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_living_gauntlet", item)
	elseif propertyName == "master" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_master_gloves", item)
	elseif propertyName == "phoenix" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_phoenix_gloves", item)
	elseif propertyName == "spirit" then
		hero.spiritGlove = item
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_spirit_glove", item)
	elseif propertyName == "frostburn" then
		hero.frostburnItem = item
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_frostburn_gauntlets", item)
	elseif propertyName == "mountain_vambrace" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_mountain_vambraces", item)
	elseif propertyName == "cytopian_laser" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_cytopian_laser", item)
		hero.cytopian = item
		item.cytopianDamage = propertyValue
	elseif propertyName == "power_ranger" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_power_ranger", item)
	elseif propertyName == "grand_arcanist" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_grand_arcanist", item)
	elseif propertyName == "eternal_essence" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_eternal_essence", item)
	elseif propertyName == "bladeforge" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_bladeforge_gauntlet", item)
	elseif propertyName == "stormcloth" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_stormcloth_bracer", item)
		RPCItems:PreacheArcanaResources(item)
	elseif propertyName == "silverspring" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_silverspring_gloves", item)
	elseif propertyName == "far_seer" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_far_seers_gloves", item)
	elseif propertyName == "royal_wrist" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_royal_wristguards", item)
	elseif propertyName == "mordiggus" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_mordiggus_gauntlet", item)
	elseif propertyName == "ironbound" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_ironbound_gloves", item)
	elseif propertyName == "sweeping_wind" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_gloves_of_sweeping_wind", item)
	elseif propertyName == "halcyon_soul" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_halcyon_soul_glove", item)
	elseif propertyName == "all_attributes" then
		Hand:action("strength", propertyValue, hero, inventory_unit, hand_ability, item)
		Hand:action("agility", propertyValue, hero, inventory_unit, hand_ability, item)
		Hand:action("intelligence", propertyValue, hero, inventory_unit, hand_ability, item)
	elseif propertyName == "forgotten_ghost" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_glove_of_the_forgotten_ghost", item)
	elseif propertyName == "spiritual_empowerment" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_spiritual_empowerment_glove", item)
	elseif propertyName == "gravekeeper" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_gravekeepers_gauntlet", item)
	elseif propertyName == "autumnrock_bracer" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_autumnrock_bracer", item)
	elseif propertyName == "malachite_shade" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_malachite_shade_bracer", item)
	elseif propertyName == "skulldigger_v2" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_skulldigger_gauntlet", item)
	elseif propertyName == "ethereal_revenant" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_claws_of_the_ethereal_revenant", item)
	elseif propertyName == "spellfire" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_spellfire_gloves", item)
	elseif propertyName == "duskbringer_arcana1" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_duskbringer_arcana1", item)
	elseif propertyName == "wind" then
		Hand:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_hand_wind", hand_ability)
	elseif propertyName == "ghost" then
		Hand:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_hand_ghost", hand_ability)
	elseif propertyName == "demon" then
		Hand:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_hand_demon", hand_ability)
	elseif propertyName == "lightning" then
		Hand:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_hand_lightning", hand_ability)
	elseif propertyName == "holy" then
		Hand:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_hand_holy", hand_ability)
	elseif propertyName == "fire" then
		Hand:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_hand_fire", hand_ability)
	elseif propertyName == "water" then
		Hand:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_hand_water", hand_ability)
	elseif propertyName == "undead" then
		Hand:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_hand_undead", hand_ability)
	elseif propertyName == "trapper_arcana1" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_trapper_arcana1", item)
	elseif propertyName == "blue_rain" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_blue_rain_gauntlet", item)
	elseif propertyName == "shadow" then
		Hand:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_hand_shadow", hand_ability)
	elseif propertyName == "shadowflame" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_shadowflame_fist", item)
	elseif propertyName == "aquasteel" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_aquasteel_bracers", item)
	elseif propertyName == "demonfire" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_demonfire_gauntlet", item)
	elseif propertyName == "spirit_warrior_arcana2" then
		RPCItems:PreacheArcanaResources(item)
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_spirit_warrior_arcana2", item)
	elseif propertyName == "legion_commander_arcana1" then
		RPCItems:PreacheArcanaResources(item)
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_mountain_protector_arcana1", item)
	elseif string.match(propertyName, "!arcana!") then
		RPCItems:PreacheArcanaResources(item)
		local suffix = propertyName:gsub("!arcana!_", "")
		local modifierName = "modifier_"..suffix
		--print(modifierName)
		Head:addItemModifier(0, hero, inventory_unit, modifierName, item)
	elseif propertyName == "lobster" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_chitinous_lobster_claw", item)
	elseif propertyName == "dark_emissary" then
		RPCItems:PreacheArcanaResources(item)
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_dark_emissary_glove", item)
	elseif propertyName == "depth_demon" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_depth_demon_claw", item)
	elseif propertyName == "heavy_echo" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_heavy_echo_gauntlet", item)
	elseif propertyName == "energy_whip" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_energy_whip_glove", item)
	elseif propertyName == "buzuki" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_buzukis_finger", item)
		RPCItems:PreacheArcanaResources(item)
	elseif propertyName == "swiftspike" then
		Hand:addItemModifier(0, hero, inventory_unit, "modifier_swiftspike_bracer", item)
	elseif propertyName == "movespeed" then
		Hand:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_hand_movespeed", hand_ability)
	end
	hero.handItem = item
end

function Hand:addItemModifier(propertyValue, hero, inventory_unit, modifier_name, hand_ability)
	hand_ability:ApplyDataDrivenModifier(inventory_unit, hero, modifier_name, {})
	if propertyValue > 0 then
		hero:SetModifierStackCount(modifier_name, hand_ability, propertyValue)
	end
end

function Hand:runeProperty(propertyName, propertyValue, hero)
	if hero:HasModifier("modifier_puzzlers_locket") then
		if string.match(propertyName, "_2") then
			propertyName = string.gsub(propertyName, "_2", "_3")
		elseif string.match(propertyName, "_3") then
			propertyName = string.gsub(propertyName, "_3", "_2")
		end
	end
	if type(propertyValue) == "string" then
		--print("[Hand:runeProperty] propertyValue:"..propertyValue)
		return
	end
	if propertyName == "rune_q_1" then
		hero.runeUnit.hand.q_1 = hero.runeUnit.hand.q_1 + propertyValue
		Hand:setRuneBonusNetTable(hero.runeUnit.hand.q_1, propertyName, hero)
	elseif propertyName == "rune_w_1" then
		hero.runeUnit.hand.w_1 = hero.runeUnit.hand.w_1 + propertyValue
		Hand:setRuneBonusNetTable(hero.runeUnit.hand.w_1, propertyName, hero)
	elseif propertyName == "rune_e_1" then
		hero.runeUnit.hand.e_1 = hero.runeUnit.hand.e_1 + propertyValue
		Hand:setRuneBonusNetTable(hero.runeUnit.hand.e_1, propertyName, hero)
	elseif propertyName == "rune_r_1" then
		hero.runeUnit.hand.r_1 = hero.runeUnit.hand.r_1 + propertyValue
		Hand:setRuneBonusNetTable(hero.runeUnit.hand.r_1, propertyName, hero)
	elseif propertyName == "rune_q_2" then
		hero.runeUnit2.hand.q_2 = hero.runeUnit2.hand.q_2 + propertyValue
		Hand:setRuneBonusNetTable(hero.runeUnit2.hand.q_2, propertyName, hero)
	elseif propertyName == "rune_w_2" then
		hero.runeUnit2.hand.w_2 = hero.runeUnit2.hand.w_2 + propertyValue
		Hand:setRuneBonusNetTable(hero.runeUnit2.hand.w_2, propertyName, hero)
	elseif propertyName == "rune_e_2" then
		hero.runeUnit2.hand.e_2 = hero.runeUnit2.hand.e_2 + propertyValue
		Hand:setRuneBonusNetTable(hero.runeUnit2.hand.e_2, propertyName, hero)
	elseif propertyName == "rune_r_2" then
		hero.runeUnit2.hand.r_2 = hero.runeUnit2.hand.r_2 + propertyValue
		Hand:setRuneBonusNetTable(hero.runeUnit2.hand.r_2, propertyName, hero)
	elseif propertyName == "rune_q_3" then
		hero.runeUnit3.hand.q_3 = hero.runeUnit3.hand.q_3 + propertyValue
		Hand:setRuneBonusNetTable(hero.runeUnit3.hand.q_3, propertyName, hero)
	elseif propertyName == "rune_w_3" then
		hero.runeUnit3.hand.w_3 = hero.runeUnit3.hand.w_3 + propertyValue
		Hand:setRuneBonusNetTable(hero.runeUnit3.hand.w_3, propertyName, hero)
	elseif propertyName == "rune_e_3" then
		hero.runeUnit3.hand.e_3 = hero.runeUnit3.hand.e_3 + propertyValue
		Hand:setRuneBonusNetTable(hero.runeUnit3.hand.e_3, propertyName, hero)
	elseif propertyName == "rune_r_3" then
		hero.runeUnit3.hand.r_3 = hero.runeUnit3.hand.r_3 + propertyValue
		Hand:setRuneBonusNetTable(hero.runeUnit3.hand.r_3, propertyName, hero)
	elseif propertyName == "rune_q_4" then
		hero.runeUnit4.hand.q_4 = hero.runeUnit4.hand.q_4 + propertyValue
		Hand:setRuneBonusNetTable(hero.runeUnit4.hand.q_4, propertyName, hero)
	elseif propertyName == "rune_w_4" then
		hero.runeUnit4.hand.w_4 = hero.runeUnit4.hand.w_4 + propertyValue
		Hand:setRuneBonusNetTable(hero.runeUnit4.hand.w_4, propertyName, hero)
	elseif propertyName == "rune_e_4" then
		hero.runeUnit4.hand.e_4 = hero.runeUnit4.hand.e_4 + propertyValue
		Hand:setRuneBonusNetTable(hero.runeUnit4.hand.e_4, propertyName, hero)
	elseif propertyName == "rune_r_4" then
		hero.runeUnit4.hand.r_4 = hero.runeUnit4.hand.r_4 + propertyValue
		Hand:setRuneBonusNetTable(hero.runeUnit4.hand.r_4, propertyName, hero)
	end
end

function Hand:setRuneBonusNetTable(value, rune, hero)
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()) .. "_"..rune.."_hand", {bonus = value})
	--print("Setting Rune Net Table: ")
	--print(tostring(hero:GetEntityIndex()).."_"..rune.."_hand")
end

function Hand:addBasicModifier(propertyValue, hero, inventory_unit, modifier_name, hand_ability)
	--print(inventory_unit)
	--local stacks = hero:GetModifierStackCount(modifierName, inventory_unit)
	hand_ability = inventory_unit:FindAbilityByName("hand_slot")
	hand_ability:ApplyDataDrivenModifier(inventory_unit, hero, modifier_name, {})
	--hero:SetModifierStackCount( modifier_name, hand_ability, (propertyValue+stacks) )
	hero:SetModifierStackCount(modifier_name, hand_ability, propertyValue)
end

function Hand:remove_modifiers(hero)
	hero:RemoveModifierByName("modifier_hand_strength")
	hero:RemoveModifierByName("modifier_hand_agility")
	hero:RemoveModifierByName("modifier_hand_intelligence")
	hero:RemoveModifierByName("modifier_hand_magic_resist")
	hero:RemoveModifierByName("modifier_hand_armor")
	hero:RemoveModifierByName("modifier_hand_health_regen")
	hero:RemoveModifierByName("modifier_hand_mana_regen")
	hero:RemoveModifierByName("modifier_hand_attack_speed")
	hero:RemoveModifierByName("modifier_hand_cooldown_reduce")
	hero:RemoveModifierByName("modifier_hand_attack_damage")
	hero:RemoveModifierByName("modifier_hand_lifesteal")
	hero:RemoveModifierByName("modifier_hand_respawn")
	hero:RemoveModifierByName("modifier_hand_respawn")
	hero:RemoveModifierByName("modifier_berserker_gloves_base")
	hero:RemoveModifierByName("modifier_shadow_armlet")
	hero:RemoveModifierByName("modifier_hand_boneguard")
	hero:RemoveModifierByName("modifier_hand_scorched_earth")
	hero:RemoveModifierByName("modifier_hand_pride")
	hero:RemoveModifierByName("modifier_hand_azinoth")
	hero:RemoveModifierByName("modifier_divine_purity")
	hero:RemoveModifierByName("modifier_hand_max_health")
	hero:RemoveModifierByName("modifier_hand_base_ability_damage")
	hero:RemoveModifierByName("modifier_hand_item_damage_inc")
	hero:RemoveModifierByName("modifier_grasp_of_elder")
	hero:RemoveModifierByName("modifier_hand_of_midas")
	hero:RemoveModifierByName("modifier_hand_of_midas_effect")
	hero:RemoveModifierByName("modifier_scarecrow_gloves")
	hero:RemoveModifierByName("modifier_scarecrow_gloves_effect")
	hero:RemoveModifierByName("modifier_living_gauntlet")
	hero:RemoveModifierByName("modifier_living_gauntlet_effect_regen")
	hero:RemoveModifierByName("modifier_living_gauntlet_effect_armor")
	hero:RemoveModifierByName("modifier_master_gloves")
	hero:RemoveModifierByName("modifier_phoenix_gloves")
	hero:RemoveModifierByName("modifier_phoenix_gloves_effect")
	hero:RemoveModifierByName("modifier_spirit_glove")
	hero:RemoveModifierByName("modifier_frostburn_gauntlets")
	hero:RemoveModifierByName("modifier_mountain_vambraces")
	hero:RemoveModifierByName("modifier_cytopian_laser")
	hero:RemoveModifierByName("modifier_power_ranger")
	hero:RemoveModifierByName("modifier_grand_arcanist")
	hero:RemoveModifierByName("modifier_eternal_essence")
	hero:RemoveModifierByName("modifier_bladeforge_gauntlet")
	hero:RemoveModifierByName("modifier_stormcloth_bracer")
	hero:RemoveModifierByName("modifier_silverspring_gloves")
	hero:RemoveModifierByName("modifier_far_seers_gloves")
	hero:RemoveModifierByName("modifier_royal_wristguards")
	hero:RemoveModifierByName("modifier_mordiggus_gauntlet")
	hero:RemoveModifierByName("modifier_ironbound_gloves")
	hero:RemoveModifierByName("modifier_gloves_of_sweeping_wind")
	hero:RemoveModifierByName("modifier_halcyon_soul_glove")
	hero:RemoveModifierByName("modifier_glove_of_the_forgotten_ghost")
	hero:RemoveModifierByName("modifier_spiritual_empowerment_glove")
	hero:RemoveModifierByName("modifier_gravekeepers_gauntlet")
	hero:RemoveModifierByName("modifier_autumnrock_bracer")
	hero:RemoveModifierByName("modifier_malachite_shade_bracer")
	hero:RemoveModifierByName("modifier_skulldigger_gauntlet")
	hero:RemoveModifierByName("modifier_claws_of_the_ethereal_revenant")
	hero:RemoveModifierByName("modifier_spellfire_gloves")
	hero:RemoveModifierByName("modifier_duskbringer_arcana1")
	hero:RemoveModifierByName("modifier_hand_wind")
	hero:RemoveModifierByName("modifier_hand_ghost")
	hero:RemoveModifierByName("modifier_hand_demon")
	hero:RemoveModifierByName("modifier_hand_lightning")
	hero:RemoveModifierByName("modifier_hand_holy")
	hero:RemoveModifierByName("modifier_hand_undead")
	hero:RemoveModifierByName("modifier_hand_fire")
	hero:RemoveModifierByName("modifier_trapper_arcana1")
	hero:RemoveModifierByName("modifier_hand_water")
	hero:RemoveModifierByName("modifier_blue_rain_gauntlet")
	hero:RemoveModifierByName("modifier_hand_shadow")
	hero:RemoveModifierByName("modifier_shadowflame_fist")
	hero:RemoveModifierByName("modifier_aquasteel_bracers")
	hero:RemoveModifierByName("modifier_demonfire_gauntlet")
	hero:RemoveModifierByName("modifier_spirit_warrior_arcana2")
	hero:RemoveModifierByName("modifier_mountain_protector_arcana1")
	hero:RemoveModifierByName("modifier_paladin_arcana1")
	hero:RemoveModifierByName("modifier_chitinous_lobster_claw")
	hero:RemoveModifierByName("modifier_dark_emissary_glove")
	hero:RemoveModifierByName("modifier_depth_demon_claw")
	hero:RemoveModifierByName("modifier_hydroxis_arcana1")
	hero:RemoveModifierByName("modifier_bahamut_arcana2")
	hero:RemoveModifierByName("modifier_heavy_echo_gauntlet")
	hero:RemoveModifierByName("modifier_flamewaker_arcana2")
	hero:RemoveModifierByName("modifier_astral_arcana2")
	hero:RemoveModifierByName("modifier_energy_whip_glove")
	hero:RemoveModifierByName("modifier_buzukis_finger")
	hero:RemoveModifierByName("modifier_swiftspike_bracer")
	hero:RemoveModifierByName("modifier_hand_movespeed")
	hero:RemoveModifierByName("modifier_sephyr_arcana1")
	hero:RemoveModifierByName("modifier_dinath_arcana1")
	hero:RemoveModifierByName("modifier_conjuror_arcana2")
	hero:RemoveModifierByName("modifier_axe_arcana2")
	hero:RemoveModifierByName("modifier_jex_arcana1")
	hero.stormcloth = false
	Hand:remove_rune_bonuses(hero)
end

function Hand:remove_rune_bonuses(hero)
	hero.runeUnit.hand.q_1 = 0
	hero.runeUnit.hand.w_1 = 0
	hero.runeUnit.hand.e_1 = 0
	hero.runeUnit.hand.r_1 = 0
	hero.runeUnit2.hand.q_2 = 0
	hero.runeUnit2.hand.w_2 = 0
	hero.runeUnit2.hand.e_2 = 0
	hero.runeUnit2.hand.r_2 = 0
	hero.runeUnit3.hand.q_3 = 0
	hero.runeUnit3.hand.w_3 = 0
	hero.runeUnit3.hand.e_3 = 0
	hero.runeUnit3.hand.r_3 = 0
	hero.runeUnit4.hand.q_4 = 0
	hero.runeUnit4.hand.w_4 = 0
	hero.runeUnit4.hand.e_4 = 0
	hero.runeUnit4.hand.r_4 = 0
	Runes:ResetRuneBonuses(hero, "hand")
end
