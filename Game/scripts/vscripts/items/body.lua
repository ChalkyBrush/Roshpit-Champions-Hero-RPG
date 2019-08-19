if Body == nil then
	Body = class({})
end

function Body:add_modifiers(hero, inventory_unit, item)
	--print("[Body:add_modifiers] ++++++++++++++++++++++++++++++++++++++++++++")
	--DeepPrintTable(item)
	if not item.newItemTable then
		--print("[Error] Body:add_modifiers item.newItemTable is null")
		RPCItems:ItemUTIL_Remove(item)
		return
	end
	local body_ability = inventory_unit:FindAbilityByName("body_slot")
	body_ability.strength = 0
	body_ability.agility = 0
	body_ability.intelligence = 0
	body_ability.magic_resist = 0
	body_ability.armor = 0
	body_ability.health_regen = 0
	body_ability.mana_regen = 0
	body_ability.physical_block = 0
	body_ability.magic_block = 0
	body_ability.respawn_reduce = 0
	body_ability.evasion = 0
	body_ability.max_mana = 0
	body_ability.max_health = 0
	body_ability.attack_damage = 0
	body_ability.base_ability = 0
	body_ability.item_damage = 0
	body_ability.movespeed = 0
	if item.newItemTable.property1name then
		local property1 = RPCItems:AdjustAttributeValue(hero, item.newItemTable.property1)
		Body:action(item.newItemTable.property1name, property1, hero, inventory_unit, body_ability, item)
		Body:runeProperty(item.newItemTable.property1name, item.newItemTable.property1, hero)
	end
	if item.newItemTable.property2name then
		local property2 = RPCItems:AdjustAttributeValue(hero, item.newItemTable.property2)
		Body:action(item.newItemTable.property2name, property2, hero, inventory_unit, body_ability, item)
		Body:runeProperty(item.newItemTable.property2name, item.newItemTable.property2, hero)
	end
	if item.newItemTable.property3name then
		local property3 = RPCItems:AdjustAttributeValue(hero, item.newItemTable.property3)
		Body:action(item.newItemTable.property3name, property3, hero, inventory_unit, body_ability, item)
		Body:runeProperty(item.newItemTable.property3name, item.newItemTable.property3, hero)
	end
	if item.newItemTable.property4name then
		local property4 = RPCItems:AdjustAttributeValue(hero, item.newItemTable.property4)
		Body:action(item.newItemTable.property4name, property4, hero, inventory_unit, body_ability, item)
		Body:runeProperty(item.newItemTable.property4name, item.newItemTable.property4, hero)
	end
end

function Body:action(propertyName, propertyValue, hero, inventory_unit, body_ability, item)
	--print("[Body:action] propertyName:"..tostring(propertyName))
	if type(propertyValue) == "string" then
		--print("[action] type(propertyValue) == string")
		propertyValue = 1
	end
	if propertyName == "strength" then
		body_ability.strength = body_ability.strength + propertyValue
		Body:addBasicModifier(body_ability.strength, hero, inventory_unit, "modifier_body_strength", body_ability)
	elseif propertyName == "agility" then
		body_ability.agility = body_ability.agility + propertyValue
		Body:addBasicModifier(body_ability.agility, hero, inventory_unit, "modifier_body_agility", body_ability)
	elseif propertyName == "intelligence" then
		body_ability.intelligence = body_ability.intelligence + propertyValue
		Body:addBasicModifier(body_ability.intelligence, hero, inventory_unit, "modifier_body_intelligence", body_ability)
	elseif propertyName == "all_attributes" then
		body_ability.strength = body_ability.strength + propertyValue
		Body:addBasicModifier(body_ability.strength, hero, inventory_unit, "modifier_body_strength", body_ability)
		body_ability.agility = body_ability.agility + propertyValue
		Body:addBasicModifier(body_ability.agility, hero, inventory_unit, "modifier_body_agility", body_ability)
		body_ability.intelligence = body_ability.intelligence + propertyValue
		Body:addBasicModifier(body_ability.intelligence, hero, inventory_unit, "modifier_body_intelligence", body_ability)
	elseif propertyName == "magic_resist" then
		body_ability.magic_resist = body_ability.magic_resist + propertyValue
		Body:addBasicModifier(body_ability.magic_resist, hero, inventory_unit, "modifier_body_magic_resist", body_ability)
	elseif propertyName == "armor" then
		body_ability.armor = body_ability.armor + propertyValue
		Body:addBasicModifier(body_ability.armor, hero, inventory_unit, "modifier_body_armor", body_ability)
	elseif propertyName == "health_regen" then
		body_ability.health_regen = body_ability.health_regen + propertyValue
		Body:addBasicModifier(body_ability.health_regen, hero, inventory_unit, "modifier_body_health_regen", body_ability)
	elseif propertyName == "mana_regen" then
		body_ability.mana_regen = body_ability.mana_regen + propertyValue
		Body:addBasicModifier(body_ability.mana_regen, hero, inventory_unit, "modifier_body_mana_regen", body_ability)
	elseif propertyName == "physical_block" then
		body_ability.physical_block = body_ability.physical_block + propertyValue
		Body:addBasicModifier(body_ability.physical_block, hero, inventory_unit, "modifier_body_physical_block", body_ability)
	elseif propertyName == "magic_block" then
		body_ability.magic_block = body_ability.magic_block + propertyValue
		Body:addBasicModifier(body_ability.magic_block, hero, inventory_unit, "modifier_body_magic_block", body_ability)
	elseif propertyName == "respawn_reduce" then
		body_ability.respawn_reduce = body_ability.respawn_reduce + propertyValue
		Body:addBasicModifier(body_ability.respawn_reduce, hero, inventory_unit, "modifier_body_respawn", body_ability)
	elseif propertyName == "evasion" then
		body_ability.evasion = body_ability.evasion + propertyValue
		Body:addBasicModifier(body_ability.evasion, hero, inventory_unit, "modifier_body_evasion", body_ability)
	elseif propertyName == "max_mana" then
		body_ability.max_mana = body_ability.max_mana + propertyValue
		Body:addBasicModifier(body_ability.max_mana, hero, inventory_unit, "modifier_body_max_mana", body_ability)
	elseif propertyName == "max_health" then
		body_ability.max_health = body_ability.max_health + propertyValue
		Body:addBasicModifier(body_ability.max_health, hero, inventory_unit, "modifier_body_max_health", body_ability)
	elseif propertyName == "attack_damage" then
		body_ability.attack_damage = body_ability.attack_damage + Amulet:AdjustAttackPowerBonus(hero, propertyValue)
		Body:addBasicModifier(body_ability.attack_damage, hero, inventory_unit, "modifier_body_attack_damage", body_ability)
	elseif propertyName == "base_ability" then
		body_ability.base_ability = body_ability.base_ability + propertyValue
		Body:addBasicModifier(body_ability.base_ability, hero, inventory_unit, "modifier_body_base_ability_damage", body_ability)
	elseif propertyName == "item_damage" then
		body_ability.item_damage = body_ability.item_damage + propertyValue
		Body:addBasicModifier(body_ability.item_damage, hero, inventory_unit, "modifier_body_item_damage_inc", body_ability)
	elseif propertyName == "movespeed" then
		body_ability.movespeed = body_ability.movespeed + propertyValue
		Body:addBasicModifier(body_ability.movespeed, hero, inventory_unit, "modifier_body_movespeed", body_ability)
	elseif propertyName == "steelbark" then
		Body:addBasicModifier(1, hero, inventory_unit, "modifier_body_steelbark", body_ability)
	elseif propertyName == "hurricane" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_hurricane_vest", item)
		RPCItems:PreacheArcanaResources(item)
	elseif propertyName == "flooding" then
		Body:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_body_flooding", body_ability)
	elseif propertyName == "avalanche" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_body_avalanche", item)
	elseif propertyName == "violet_guard2" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_body_violet_guard2", item)
	elseif propertyName == "watcher1" then
		Body:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_watcher_one", body_ability)
	elseif propertyName == "watcher2" then
		Body:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_watcher_two", body_ability)
	elseif propertyName == "watcher3" then
		Body:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_watcher_three", body_ability)
	elseif propertyName == "watcher4" then
		Body:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_watcher_four", body_ability)
	elseif propertyName == "sorcerer" then
		Body:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_sorcerers_regalia", body_ability)
	elseif propertyName == "spellslinger" then
		Body:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_spellslinger_coat", body_ability)
	elseif propertyName == "doomplate" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_doomplate", item)
	elseif propertyName == "ice_quill" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_ice_quill_carapace", item)
		item.hero = hero
	elseif propertyName == "featherwhite" then
		Body:SummonFollower(hero, "ivory_gryffin")
	elseif propertyName == "dragon_ceremony" then
		Body:SummonFollower(hero, "beast_of_ceremony")
	elseif propertyName == "secret_temple" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_secret_temple", item)
		hero.refractionItem = item
	elseif propertyName == "vampiric_breastplate" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_vampiric_breastplate", item)
	elseif propertyName == "dark_arts" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_dark_arts", item)
	elseif propertyName == "legion_vest" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_legion_vestments", item)
	elseif propertyName == "nightmare_rider" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_nightmare_rider", item)
	elseif propertyName == "space_tech" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_space_tech", item)
		hero.space_tech = item
	elseif propertyName == "stormshield" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_stormshield_cloak", item)
	elseif propertyName == "soul_cage" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_gilded_soul_cage", item)
	elseif propertyName == "bluestar" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_bluestar_armor", item)
		item.hero = hero
	elseif propertyName == "spike_shell" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_hermit_spikes", item)
	elseif propertyName == "infernal_prison" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_infernal_prison", item)
	elseif propertyName == "enchanted_solar" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_enchanted_solar_cape", item)
	elseif propertyName == "ocean_tempest" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_ocean_tempest_pallium", item)
		hero.ocean_tempest = item
	elseif propertyName == "radiant_ruins" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_radiant_leather_aura", item)
	elseif propertyName == "twilight" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_twilight_vestments", item)
	elseif propertyName == "windsteel" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_windsteel_armor", item)
	elseif propertyName == "ogthun" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_savage_plate_of_ogthun", item)
	elseif propertyName == "skyforge" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_skyforge_flurry_plate", item)
	elseif propertyName == "bladestorm" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_bladestorm_vest", item)
	elseif propertyName == "mageplate" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_infused_mageplate", item)
	elseif propertyName == "depth_crest" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_depth_crest_armor", item)
	elseif propertyName == "terrasic_stone" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_terrasic_stone_plate", item)
	elseif propertyName == "watermage" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_water_mage_robes", item)
	elseif propertyName == "seraphic" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_body_seraphic", item)
	elseif propertyName == "golden_war_plate" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_golden_war_plate", item)
	elseif propertyName == "gold_leon" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_gold_plate_of_leon", item)
	elseif propertyName == "knight_crusher" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_knight_crusher_armor", item)
	elseif propertyName == "topaz_dragon" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_topaz_dragon_scale_armor", item)
	elseif propertyName == "sapphire_dragon" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_sapphire_dragon_scale_armor", item)
	elseif propertyName == "ruby_dragon" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_ruby_dragon_scale_armor", item)
	elseif propertyName == "sacred_trials" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_sacred_trials_armor", item)
	elseif propertyName == "feronia" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_guard_of_feronia", item)
	elseif propertyName == "mystic_mana" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_mystic_mana_wall", item)
	elseif propertyName == "vermillion_dream" then
		hero:AddNewModifier(inventory_unit, nil, 'modifier_vermillion_dream_lua', nil)
	elseif propertyName == "bahamut_arcana1" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_bahamut_arcana1", item)
	elseif propertyName == "baron_storm" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_barons_storm_armor", item)
	elseif propertyName == "conjuror_arcana1" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_conjuror_arcana1", item)
	elseif propertyName == "cosmos" then
		Body:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_body_cosmos", body_ability)
	elseif propertyName == "water" then
		Body:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_body_water", body_ability)
	elseif propertyName == "wind" then
		Body:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_body_wind", body_ability)
	elseif propertyName == "earth" then
		Body:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_body_earth", body_ability)
	elseif propertyName == "holy" then
		Body:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_body_holy", body_ability)
	elseif propertyName == "lightning" then
		Body:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_body_lightning", body_ability)
	elseif propertyName == "shadow" then
		Body:addBasicModifier(propertyValue, hero, inventory_unit, "modifier_body_shadow", body_ability)
	elseif propertyName == "ancient_tanari" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_tanari_wind_armor", item)
	elseif propertyName == "blazing_fury" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_blazing_fury", item)
	elseif propertyName == "spirit_warrior_arcana1" then
		RPCItems:PreacheArcanaResources(item)
		Body:addItemModifier(0, hero, inventory_unit, "modifier_spirit_warrior_arcana1", item)
	elseif propertyName == "outland_stone" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_outland_stone_cuirass", item)
	elseif propertyName == "legion_commander_arcana2" then
		RPCItems:PreacheArcanaResources(item)
		Body:addItemModifier(0, hero, inventory_unit, "modifier_mountain_protector_arcana2", item)
	elseif string.match(propertyName, "!arcana!") then
		RPCItems:PreacheArcanaResources(item)
		local suffix = propertyName:gsub("!arcana!_", "")
		local modifierName = "modifier_"..suffix
		--print(modifierName)
		Head:addItemModifier(0, hero, inventory_unit, modifierName, item)
	elseif propertyName == "atlantis" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_armor_of_atlantis", item)
		RPCItems:PreacheArcanaResources(item)
	elseif propertyName == "sunrise" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_empyreal_sunrise_robe", item)
	elseif propertyName == "sea_giant" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_sea_giants_plate", item)
	elseif propertyName == "light_seer" then
		RPCItems:PreacheArcanaResources(item)
		Body:addItemModifier(0, hero, inventory_unit, "modifier_templar_light_seers_robe", item)
	elseif propertyName == "direwolf" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_direwolf_bulwark", item)
	elseif propertyName == "boreal_granite" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_boreal_granite_vest", item)
	elseif propertyName == "captains_vest" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_captains_vest", item)
	elseif propertyName == "tattered_novice" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_tattered_novice_armor", item)
	elseif propertyName == "erudite_teacher" then
		Body:addItemModifier(0, hero, inventory_unit, "modifier_erudite_teacher", item)
		RPCItems:PreacheArcanaResources(item)
	end
	hero.body = item
	item.hero = hero
end

function Body:SummonFollower(hero, unitName)
	local summon = CreateUnitByName(unitName, hero:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
	summon.owner = hero:GetPlayerOwnerID()
	summon.summoner = hero
	summon:SetOwner(hero)
	summon:SetControllableByPlayer(hero:GetPlayerID(), true)
	summon.hero = hero
	if not hero.summonTable then
		hero.summonTable = {}
	end
	table.insert(hero.summonTable, summon)
	return summon
end

function Body:addItemModifier(propertyValue, hero, inventory_unit, modifier_name, head_ability)
	head_ability:ApplyDataDrivenModifier(inventory_unit, hero, modifier_name, {})
	if propertyValue > 0 then
		hero:SetModifierStackCount(modifier_name, head_ability, propertyValue)
	end
end

function Body:runeProperty(propertyName, propertyValue, hero)
	if hero:HasModifier("modifier_puzzlers_locket") then
		if string.match(propertyName, "_2") then
			propertyName = string.gsub(propertyName, "_2", "_3")
		elseif string.match(propertyName, "_3") then
			propertyName = string.gsub(propertyName, "_3", "_2")
		end
	end
	if type(propertyValue) == "string" then
		--print("[Body:runeProperty] propertyValue:"..propertyValue)
		return
	end
	if propertyName == "rune_q_1" then
		hero.runeUnit.body.q_1 = hero.runeUnit.body.q_1 + propertyValue
		Body:setRuneBonusNetTable(hero.runeUnit.body.q_1, propertyName, hero)
	elseif propertyName == "rune_w_1" then
		hero.runeUnit.body.w_1 = hero.runeUnit.body.w_1 + propertyValue
		Body:setRuneBonusNetTable(hero.runeUnit.body.w_1, propertyName, hero)
	elseif propertyName == "rune_e_1" then
		hero.runeUnit.body.e_1 = hero.runeUnit.body.e_1 + propertyValue
		Body:setRuneBonusNetTable(hero.runeUnit.body.e_1, propertyName, hero)
	elseif propertyName == "rune_r_1" then
		hero.runeUnit.body.r_1 = hero.runeUnit.body.r_1 + propertyValue
		Body:setRuneBonusNetTable(hero.runeUnit.body.r_1, propertyName, hero)
	elseif propertyName == "rune_q_2" then
		hero.runeUnit2.body.q_2 = hero.runeUnit2.body.q_2 + propertyValue
		Body:setRuneBonusNetTable(hero.runeUnit2.body.q_2, propertyName, hero)
	elseif propertyName == "rune_w_2" then
		hero.runeUnit2.body.w_2 = hero.runeUnit2.body.w_2 + propertyValue
		Body:setRuneBonusNetTable(hero.runeUnit2.body.w_2, propertyName, hero)
	elseif propertyName == "rune_e_2" then
		hero.runeUnit2.body.e_2 = hero.runeUnit2.body.e_2 + propertyValue
		Body:setRuneBonusNetTable(hero.runeUnit2.body.e_2, propertyName, hero)
	elseif propertyName == "rune_r_2" then
		hero.runeUnit2.body.r_2 = hero.runeUnit2.body.r_2 + propertyValue
		Body:setRuneBonusNetTable(hero.runeUnit2.body.r_2, propertyName, hero)
	elseif propertyName == "rune_q_3" then
		hero.runeUnit3.body.q_3 = hero.runeUnit3.body.q_3 + propertyValue
		Body:setRuneBonusNetTable(hero.runeUnit3.body.q_3, propertyName, hero)
	elseif propertyName == "rune_w_3" then
		hero.runeUnit3.body.w_3 = hero.runeUnit3.body.w_3 + propertyValue
		Body:setRuneBonusNetTable(hero.runeUnit3.body.w_3, propertyName, hero)
	elseif propertyName == "rune_e_3" then
		hero.runeUnit3.body.e_3 = hero.runeUnit3.body.e_3 + propertyValue
		Body:setRuneBonusNetTable(hero.runeUnit3.body.e_3, propertyName, hero)
	elseif propertyName == "rune_r_3" then
		hero.runeUnit3.body.r_3 = hero.runeUnit3.body.r_3 + propertyValue
		Body:setRuneBonusNetTable(hero.runeUnit3.body.r_3, propertyName, hero)
	elseif propertyName == "rune_q_4" then
		hero.runeUnit4.body.q_4 = hero.runeUnit4.body.q_4 + propertyValue
		Body:setRuneBonusNetTable(hero.runeUnit4.body.q_4, propertyName, hero)
	elseif propertyName == "rune_w_4" then
		hero.runeUnit4.body.w_4 = hero.runeUnit4.body.w_4 + propertyValue
		Body:setRuneBonusNetTable(hero.runeUnit4.body.w_4, propertyName, hero)
	elseif propertyName == "rune_e_4" then
		hero.runeUnit4.body.e_4 = hero.runeUnit4.body.e_4 + propertyValue
		Body:setRuneBonusNetTable(hero.runeUnit4.body.e_4, propertyName, hero)
	elseif propertyName == "rune_r_4" then
		hero.runeUnit4.body.r_4 = hero.runeUnit4.body.r_4 + propertyValue
		Body:setRuneBonusNetTable(hero.runeUnit4.body.r_4, propertyName, hero)
	elseif propertyName == "t1_runes" then
		local runeTable = {"rune_q_1", "rune_w_1", "rune_e_1", "rune_r_1"}
		for i = 1, #runeTable, 1 do
			Body:runeProperty(runeTable[i], propertyValue, hero)
		end
	elseif propertyName == "t2_runes" then
		local runeTable = {"rune_q_2", "rune_w_2", "rune_e_2", "rune_r_2"}
		for i = 1, #runeTable, 1 do
			Body:runeProperty(runeTable[i], propertyValue, hero)
		end
	elseif propertyName == "t3_runes" then
		local runeTable = {"rune_q_3", "rune_w_3", "rune_e_3", "rune_r_3"}
		for i = 1, #runeTable, 1 do
			Body:runeProperty(runeTable[i], propertyValue, hero)
		end
	end
	local letter, tier = propertyName:match("rune_(.)_(.)")
	if letter ~= nil and tier ~= nil then
		Runes:OnRuneCountUpdate(hero, letter, tier)
	end
end

function Body:setRuneBonusNetTable(value, rune, hero)
	CustomNetTables:SetTableValue("skill_tree", tostring(hero:GetEntityIndex()) .. "_"..rune.."_body", {bonus = value})
	--print("Setting Rune Net Table: ")
	--print(tostring(hero:GetEntityIndex()).."_"..rune.."_body")
end

function Body:addBasicModifier(propertyValue, hero, inventory_unit, modifier_name, body_ability)
	--print(inventory_unit)
	--local stacks = hero:GetModifierStackCount(modifierName, inventory_unit)
	body_ability = inventory_unit:FindAbilityByName("body_slot")
	body_ability:ApplyDataDrivenModifier(inventory_unit, hero, modifier_name, {})
	--hero:SetModifierStackCount( modifier_name, body_ability, (propertyValue+stacks) )
	hero:SetModifierStackCount(modifier_name, body_ability, propertyValue)
end

function Body:remove_modifiers(hero)
	hero:RemoveModifierByName("modifier_body_strength")
	hero:RemoveModifierByName("modifier_body_agility")
	hero:RemoveModifierByName("modifier_body_intelligence")
	hero:RemoveModifierByName("modifier_body_magic_resist")
	hero:RemoveModifierByName("modifier_body_armor")
	hero:RemoveModifierByName("modifier_body_health_regen")
	hero:RemoveModifierByName("modifier_body_mana_regen")
	hero:RemoveModifierByName("modifier_body_physical_block")
	hero:RemoveModifierByName("modifier_body_magic_block")
	hero:RemoveModifierByName("modifier_body_max_mana")
	hero:RemoveModifierByName("modifier_body_max_health")
	hero:RemoveModifierByName("modifier_body_attack_damage")
	hero:RemoveModifierByName("modifier_body_movespeed")
	hero:RemoveModifierByName("modifier_body_respawn")
	hero:RemoveModifierByName("modifier_body_steelbark")
	hero:RemoveModifierByName("modifier_hurricane_vest")
	hero:RemoveModifierByName("modifier_body_flooding")
	hero:RemoveModifierByName("modifier_body_avalanche")
	hero:RemoveModifierByName("modifier_body_violet_guard")
	hero:RemoveModifierByName("modifier_body_seraphic")
	hero:RemoveModifierByName("modifier_watcher_one")
	hero:RemoveModifierByName("modifier_watcher_two")
	hero:RemoveModifierByName("modifier_watcher_three")
	hero:RemoveModifierByName("modifier_watcher_four")
	hero:RemoveModifierByName("modifier_sorcerers_regalia")
	hero:RemoveModifierByName("modifier_spellslinger_coat")
	hero:RemoveModifierByName("modifier_doomplate")
	hero:RemoveModifierByName("modifier_body_base_ability_damage")
	hero:RemoveModifierByName("modifier_body_item_damage_inc")
	hero:RemoveModifierByName("modifier_body_cosmos")
	hero:RemoveModifierByName("modifier_body_water")
	hero:RemoveModifierByName("modifier_body_wind")
	hero:RemoveModifierByName("modifier_body_earth")
	hero:RemoveModifierByName("modifier_body_lightning")
	hero:RemoveModifierByName("modifier_body_shadow")
	hero:RemoveModifierByName("modifier_body_holy")

	hero:RemoveModifierByName("modifier_ice_quill_carapace")
	hero:RemoveModifierByName("modifier_secret_temple")
	hero:RemoveModifierByName("modifier_vampiric_breastplate")
	hero:RemoveModifierByName("modifier_dark_arts")
	hero:RemoveModifierByName("modifier_dark_arts_effect")
	hero:RemoveModifierByName("modifier_legion_vestments")
	hero:RemoveModifierByName("modifier_legion_vestments_effect_str")
	hero:RemoveModifierByName("modifier_legion_vestments_effect_int")
	hero:RemoveModifierByName("modifier_legion_vestments_effect_agi")
	hero:RemoveModifierByName("modifier_nightmare_rider")
	hero:RemoveModifierByName("modifier_space_tech")
	hero:RemoveModifierByName("modifier_stormshield_cloak")
	hero:RemoveModifierByName("modifier_gilded_soul_cage")
	hero:RemoveModifierByName("modifier_bluestar_armor")
	hero:RemoveModifierByName("modifier_hermit_spikes")
	hero:RemoveModifierByName("modifier_infernal_prison")
	hero:RemoveModifierByName("modifier_enchanted_solar_cape")
	hero:RemoveModifierByName("modifier_ocean_tempest_pallium")
	hero:RemoveModifierByName("modifier_radiant_leather_aura")
	hero:RemoveModifierByName("modifier_twilight_vestments")
	hero:RemoveModifierByName("modifier_windsteel_armor")
	hero:RemoveModifierByName("modifier_savage_plate_of_ogthun")
	hero:RemoveModifierByName("modifier_skyforge_flurry_plate")
	hero:RemoveModifierByName("modifier_bladestorm_vest")
	hero:RemoveModifierByName("modifier_infused_mageplate")
	hero:RemoveModifierByName("modifier_depth_crest_armor")
	hero:RemoveModifierByName("modifier_terrasic_stone_plate")
	hero:RemoveModifierByName("modifier_water_mage_robes")
	hero:RemoveModifierByName("modifier_golden_war_plate")
	hero:RemoveModifierByName("modifier_gold_plate_of_leon")
	hero:RemoveModifierByName("modifier_knight_crusher_armor")
	hero:RemoveModifierByName("modifier_topaz_dragon_scale_armor")
	hero:RemoveModifierByName("modifier_ruby_dragon_scale_armor")
	hero:RemoveModifierByName("modifier_sapphire_dragon_scale_armor")
	hero:RemoveModifierByName("modifier_sacred_trials_armor")
	hero:RemoveModifierByName("modifier_guard_of_feronia")
	hero:RemoveModifierByName("modifier_mystic_mana_wall")
	hero:RemoveModifierByName("modifier_vermillion_dream_robes")
	hero:RemoveModifierByName("modifier_vermillion_dream_lua")
	hero:RemoveModifierByName("modifier_bahamut_arcana1")
	hero:RemoveModifierByName("modifier_barons_storm_armor")
	hero:RemoveModifierByName("modifier_body_violet_guard2")
	hero:RemoveModifierByName("modifier_conjuror_arcana1")
	hero:RemoveModifierByName("modifier_tanari_wind_armor")
	hero:RemoveModifierByName("modifier_blazing_fury")
	hero:RemoveModifierByName("modifier_spirit_warrior_arcana1")
	hero:RemoveModifierByName("modifier_outland_stone_cuirass")
	hero:RemoveModifierByName("modifier_mountain_protector_arcana2")
	hero:RemoveModifierByName("modifier_venomort_arcana1")
	hero:RemoveModifierByName("modifier_chernobog_arcana1")
	hero:RemoveModifierByName("modifier_sorceress_arcana1")
	hero:RemoveModifierByName("modifier_axe_arcana1")
	hero:RemoveModifierByName("modifier_armor_of_atlantis")
	hero:RemoveModifierByName("modifier_empyreal_sunrise_robe")
	hero:RemoveModifierByName("modifier_sea_giants_plate")
	hero:RemoveModifierByName("modifier_templar_light_seers_robe")
	hero:RemoveModifierByName("modifier_warlord_arcana1")
	hero:RemoveModifierByName("modifier_solunia_arcana2")
	hero:RemoveModifierByName("modifier_direwolf_bulwark")
	hero:RemoveModifierByName("modifier_arkimus_arcana2")
	hero:RemoveModifierByName("modifier_djanghor_arcana1")
	hero:RemoveModifierByName("modifier_zonik_arcana2")
	hero:RemoveModifierByName("modifier_boreal_granite_vest")
	hero:RemoveModifierByName("modifier_captains_vest")
	hero:RemoveModifierByName("modifier_tattered_novice_armor")
	hero:RemoveModifierByName("modifier_hydroxis_arcana2")
	hero:RemoveModifierByName("modifier_astral_arcana3")
	hero:RemoveModifierByName("modifier_erudite_teacher")
	hero.ocean_tempest = nil

	hero.space_tech = nil
	if hero.summonTable then
		for i = 1, #hero.summonTable, 1 do
			if not hero.summonTable[i]:IsNull() then
				UTIL_Remove(hero.summonTable[i])
			end
		end
	end
	Body:remove_rune_bonuses(hero)
end

function Body:remove_rune_bonuses(hero)
	hero.runeUnit.body.q_1 = 0
	hero.runeUnit.body.w_1 = 0
	hero.runeUnit.body.e_1 = 0
	hero.runeUnit.body.r_1 = 0
	hero.runeUnit2.body.q_2 = 0
	hero.runeUnit2.body.w_2 = 0
	hero.runeUnit2.body.e_2 = 0
	hero.runeUnit2.body.r_2 = 0
	hero.runeUnit3.body.q_3 = 0
	hero.runeUnit3.body.w_3 = 0
	hero.runeUnit3.body.e_3 = 0
	hero.runeUnit3.body.r_3 = 0
	hero.runeUnit4.body.q_4 = 0
	hero.runeUnit4.body.w_4 = 0
	hero.runeUnit4.body.e_4 = 0
	hero.runeUnit4.body.r_4 = 0
	Runes:ResetRuneBonuses(hero, "body")
end
