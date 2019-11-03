require('heroes/faceless_void/omniro_constants')
require('heroes/faceless_void/omni_orb')

function omni_mace_init_go(event)
end

function omni_mace_main_think(event)
	local caster = event.caster
	local ability = event.ability

	if not caster.omniro_data then
		init_omniro_data(event)
	end
	

	if not caster.omniro_data_initialized then
		init_omniro_detail_data(event)
		caster.omniro_data_initialized = true
	end
	if caster.offload_think_completed then
		omniro_element_charge_think(event)
	end

	local player = caster:GetPlayerOwner()
	local reconstruct = false
	if ability.update_lock then
		ability.update_lock = false
	else
		CustomNetTables:SetTableValue("hero_index", "omniro-"..tostring(caster:GetEntityIndex()), caster.omniro_data)
		if reconstruct then
			CustomGameEventManager:Send_ServerToPlayer(player, "update_omniro", {omniro = caster:GetEntityIndex(), reconstruct = true})
		else
			CustomGameEventManager:Send_ServerToPlayer(player, "update_omniro", {omniro = caster:GetEntityIndex()})
		end
	end

	-- if not caster.omniro_weapon_pfx then
	-- local pfx = ParticleManager:CreateParticle("particles/roshpit/omniro/omniro_weapon_glow.vpcf", PATTACH_POINT_FOLLOW, caster)
	-- ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	-- caster.omniro_weapon_pfx = pfx
	-- end
end

function omni_mace_offload_think(event)
	local caster = event.caster
	local ability = event.ability
	caster.offload_think_completed = true
	local reconstruct = omniro_rune_calculate(event)
	local player = caster:GetPlayerOwner()
	ability.update_lock = true
	CustomNetTables:SetTableValue("hero_index", "omniro-"..tostring(caster:GetEntityIndex()), caster.omniro_data)
	if reconstruct then
		CustomGameEventManager:Send_ServerToPlayer(player, "update_omniro", {omniro = caster:GetEntityIndex(), reconstruct = true})
	else
		CustomGameEventManager:Send_ServerToPlayer(player, "update_omniro", {omniro = caster:GetEntityIndex()})
	end
end

function init_omniro_data(event)
	local caster = event.caster
	local orb_ability = caster:FindAbilityByName("omniro_omni_orb")
	caster.omniro_data = {}
	for i = 1, 18, 1 do
		caster.omniro_data[i] = {}
		caster.omniro_data[i]["enabled"] = true
		caster.omniro_data[i]["element_number"] = i
		caster.omniro_data[i]["active"] = false
		caster.omniro_data[i]["locked"] = false
		caster.omniro_data[i]["in_rotation"] = 1
		caster.omniro_data[i]["ability_index"] = event.ability:GetEntityIndex()
		caster.omniro_data[i]["orb_ability_index"] = orb_ability:GetEntityIndex()
		if i > 1 then
			caster.omniro_data[i]["rune_tier"] = math.floor(((i - 2) / 4) + 1)
		else
			caster.omniro_data[i]["rune_tier"] = 0
		end
	end
	caster.omniro_data[1]["active"] = true
	caster.active_element = 1
end

function init_omniro_detail_data(event)
	local caster = event.caster
	for i = 1, 18, 1 do
		-- if caster.omniro_data[i]["level"] > 0 then
		caster.omniro_data[i]["charges"] = 1
		caster.omniro_data[i]["max_charges"] = 1
		caster.omniro_data[i]["charge_up_fraction"] = 0
		caster.omniro_data[i]["charge_up_fraction_full"] = 100

		-- end
	end
end

function omniro_rune_calculate(event)
	local reconstruct = false
	local caster = event.caster
	local ability = event.ability
	local rune_q_1 = caster:GetRuneValue("q", 1)
	local rune_q_2 = caster:GetRuneValue("q", 2)
	local rune_q_3 = caster:GetRuneValue("q", 3)
	local rune_q_4 = caster:GetRuneValue("q", 4)

	local rune_w_1 = caster:GetRuneValue("w", 1)
	local rune_w_2 = caster:GetRuneValue("w", 2)
	local rune_w_3 = caster:GetRuneValue("w", 3)
	local rune_w_4 = caster:GetRuneValue("w", 4)

	local rune_e_1 = caster:GetRuneValue("e", 1)
	local rune_e_2 = caster:GetRuneValue("e", 2)
	local rune_e_3 = caster:GetRuneValue("e", 3)
	local rune_e_4 = caster:GetRuneValue("e", 4)

	local rune_r_1 = caster:GetRuneValue("r", 1)
	local rune_r_2 = caster:GetRuneValue("r", 2)
	local rune_r_3 = caster:GetRuneValue("r", 3)
	local rune_r_4 = caster:GetRuneValue("r", 4)
	

	if caster:HasModifier("modifier_omniro_glyph_4_1") then
		local new_level = 1 + OMNIRO_GLYPH_4_1_NORMAL_LEVELS
		if caster.omniro_data[RPC_ELEMENT_NORMAL]["level"] == new_level then
		else
			caster.omniro_data[RPC_ELEMENT_NORMAL]["level"] = new_level
			reconstruct = true
		end
	else
		caster.omniro_data[RPC_ELEMENT_NORMAL]["level"] = 1
	end

	if caster.omniro_data[RPC_ELEMENT_FIRE]["level"] ~= rune_q_1 then
		caster.omniro_data[RPC_ELEMENT_FIRE]["level"] = rune_q_1
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_EARTH]["level"] ~= rune_w_1 then
		caster.omniro_data[RPC_ELEMENT_EARTH]["level"] = rune_w_1
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_LIGHTNING]["level"] ~= rune_e_1 then
		caster.omniro_data[RPC_ELEMENT_LIGHTNING]["level"] = rune_e_1
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_POISON]["level"] ~= rune_r_1 then
		caster.omniro_data[RPC_ELEMENT_POISON]["level"] = rune_r_1
		reconstruct = true
	end

	if caster.omniro_data[RPC_ELEMENT_TIME]["level"] ~= rune_q_2 then
		caster.omniro_data[RPC_ELEMENT_TIME]["level"] = rune_q_2
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_HOLY]["level"] ~= rune_w_2 then
		caster.omniro_data[RPC_ELEMENT_HOLY]["level"] = rune_w_2
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_COSMOS]["level"] ~= rune_e_2 then
		caster.omniro_data[RPC_ELEMENT_COSMOS]["level"] = rune_e_2
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_ICE]["level"] ~= rune_r_2 then
		caster.omniro_data[RPC_ELEMENT_ICE]["level"] = rune_r_2
		reconstruct = true
	end

	if caster.omniro_data[RPC_ELEMENT_ARCANE]["level"] ~= rune_q_3 then
		caster.omniro_data[RPC_ELEMENT_ARCANE]["level"] = rune_q_3
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_SHADOW]["level"] ~= rune_w_3 then
		caster.omniro_data[RPC_ELEMENT_SHADOW]["level"] = rune_w_3
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_WIND]["level"] ~= rune_e_3 then
		caster.omniro_data[RPC_ELEMENT_WIND]["level"] = rune_e_3
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_GHOST]["level"] ~= rune_r_3 then
		caster.omniro_data[RPC_ELEMENT_GHOST]["level"] = rune_r_3
		reconstruct = true
	end

	if caster.omniro_data[RPC_ELEMENT_WATER]["level"] ~= rune_q_4 then
		caster.omniro_data[RPC_ELEMENT_WATER]["level"] = rune_q_4
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_DEMON]["level"] ~= rune_w_4 then
		caster.omniro_data[RPC_ELEMENT_DEMON]["level"] = rune_w_4
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_NATURE]["level"] ~= rune_e_4 then
		caster.omniro_data[RPC_ELEMENT_NATURE]["level"] = rune_e_4
		reconstruct = true
	end
	if caster.omniro_data[RPC_ELEMENT_UNDEAD]["level"] ~= rune_r_4 then
		caster.omniro_data[RPC_ELEMENT_UNDEAD]["level"] = rune_r_4
		reconstruct = true
	end
	if caster:HasModifier("modifier_omniro_immortal_weapon_3") then
		caster.omniro_data[RPC_ELEMENT_DRAGON]["level"] = 1
	else
		caster.omniro_data[RPC_ELEMENT_DRAGON]["level"] = 0
	end
	if caster:HasModifier("modifier_omniro_glyph_5_1") then
		omnimace_set_lowest_elements_table(caster, event.ability)
	end
	if caster:HasModifier("modifier_omniro_glyph_5_a") or caster:HasModifier("modifier_omniro_glyph_7_1") then
		omnimace_set_highest_elements_table(caster, event.ability)
	end
	for i = 1, #caster.omniro_data, 1 do
		if caster.omniro_data[i]["level"] > 0 then
			caster.omniro_data[i]["enabled"] = true
			local max_charges = 1
			local bonus_max_charges = 0
			if caster.omniro_data[i]["rune_tier"] == 1 then
				bonus_max_charges = math.floor(OMNIRO_T1_RUNE_MAX_CHARGES * caster.omniro_data[i]["level"])
			elseif caster.omniro_data[i]["rune_tier"] == 2 then
				bonus_max_charges = math.floor(OMNIRO_T2_RUNE_MAX_CHARGES * caster.omniro_data[i]["level"])
			elseif caster.omniro_data[i]["rune_tier"] == 3 then
				bonus_max_charges = math.floor(OMNIRO_T3_RUNE_MAX_CHARGES * caster.omniro_data[i]["level"])
			elseif caster.omniro_data[i]["rune_tier"] == 4 then
				bonus_max_charges = math.floor(OMNIRO_T4_RUNE_MAX_CHARGES * caster.omniro_data[i]["level"])
			end
			if i == 1 then
				bonus_max_charges = bonus_max_charges + 9
			end
			if caster:HasModifier("modifier_omniro_glyph_5_1") and WallPhysics:DoesTableHaveValue(ability.lowest_elements_table, caster.omniro_data[i]["element_number"]) then
				bonus_max_charges = bonus_max_charges + OMNIRO_GLYPH_5_1_BOTTOM_ELEMENTS_MAX_CHARGES
			end
			if caster:HasModifier("modifier_omniro_glyph_7_1") and ability.highest_elements_table[1] == caster.omniro_data[i]["element_number"] then
				max_charges = max_charges + OMNIRO_GLYPH_7_1_HIGHEST_ELEMENT_ADDITIONAL_CHARGES
			end
			max_charges = max_charges + bonus_max_charges
			caster.omniro_data[i]["max_charges"] = max_charges
			if caster.omniro_data[i]["charges"] then
				if caster.omniro_data[i]["charges"] > max_charges then
					caster.omniro_data[i]["charges"] = caster.omniro_data[i]["max_charges"]
					caster.omniro_data[i]["charge_up_fraction"] = 0
				end
			end
		end
	end
	return reconstruct
end

function omniro_element_charge_think(event)
	local caster = event.caster
	local recharge_rate = 1
	if caster:HasModifier("modifier_omniro_immortal_weapon_2") then
		recharge_rate = recharge_rate * (1 + OMNIRO_LEGEND_WEAPON_2_RECHARGE_INCREASE / 100)
	end
	for i = 1, #caster.omniro_data, 1 do
		if caster.omniro_data[i]["level"] > 0 then
			if caster.omniro_data[i]["charges"] < caster.omniro_data[i]["max_charges"] then
				local local_recharge_rate = recharge_rate
				if caster:HasModifier("modifier_omniro_glyph_4_1") and caster.omniro_data[i]["element_number"] == RPC_ELEMENT_NORMAL then
					local_recharge_rate = local_recharge_rate * (1 + OMNIRO_GLYPH_4_1_NORMAL_RECHARGE / 100)
				end
				caster.omniro_data[i]["charge_up_fraction"] = caster.omniro_data[i]["charge_up_fraction"] + local_recharge_rate
				if caster.omniro_data[i]["charge_up_fraction"] >= caster.omniro_data[i]["charge_up_fraction_full"] then
					caster.omniro_data[i]["charge_up_fraction"] = 0
					caster.omniro_data[i]["charges"] = math.min(caster.omniro_data[i]["charges"] + 1, caster.omniro_data[i]["max_charges"])
				end
			end
		else
			caster.omniro_data[i]["enabled"] = false
		end
	end
end

function omnimace_set_lowest_elements_table(caster, ability)
	local lowest_elements_table = WallPhysics:CloneTable(caster.omniro_data)
	table.sort(lowest_elements_table, function (left, right)
		return left["level"] < right["level"]
	end)
	local next_lowest_table = {}
	for i = 1, #lowest_elements_table, 1 do
		if lowest_elements_table[i]["level"] > 0 then
			if lowest_elements_table[i]["element_number"] == RPC_ELEMENT_NORMAL or lowest_elements_table[i]["element_number"] == RPC_ELEMENT_DRAGON then
			else
				table.insert(next_lowest_table, lowest_elements_table[i]["element_number"])
			end
		end
		if #next_lowest_table == 4 then
			break
		end
	end
	ability.lowest_elements_table = next_lowest_table
end

function omnimace_set_highest_elements_table(caster, ability)
	local highest_elements_table = WallPhysics:CloneTable(caster.omniro_data)
	table.sort(highest_elements_table, function (left, right)
		return left["level"] > right["level"]
	end)
	local next_highest_table = {}
	for i = 1, #highest_elements_table, 1 do
		if highest_elements_table[i]["level"] > 0 then
			if highest_elements_table[i]["element_number"] == RPC_ELEMENT_DRAGON then
			else
				table.insert(next_highest_table, highest_elements_table[i]["element_number"])
			end
		end
		if #next_highest_table == 4 then
			break
		end
	end
	ability.highest_elements_table = next_highest_table

end

function is_bottom_four_leveled_element(caster, element, ability)
	if WallPhysics:DoesTableHaveValue(ability.lowest_elements_table, element) then
		return true
	else
		return false
	end
end

function omniro_mace_attack_land(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if target.dummy then
		return false
	end
	local active_element = caster.active_element

	-- CURRENT ELEMENT EFFECT HERE

	local next_element = nil
	if active_element == 18 then

	else
		for i = active_element, 17, 1 do
			if caster.omniro_data[i + 1]["level"] > 0 and caster.omniro_data[i + 1]["in_rotation"] == 1 then
				if caster:HasModifier("modifier_omniro_glyph_1_1") then
					if caster.omniro_data[i + 1]["charges"] > 0 then
						next_element = i + 1
						break
					end
				else
					next_element = i + 1
					break
				end
			end
		end
	end
	if not next_element then
		next_element = active_element
		for i = 1, 18, 1 do
			if caster.omniro_data[i]["level"] > 0 and caster.omniro_data[i]["in_rotation"] == 1 then
				if caster:HasModifier("modifier_omniro_glyph_1_1") then
					if caster.omniro_data[i]["charges"] > 0 then
						next_element = i
						break
					end
				else
					next_element = i
					break
				end
			end
		end
	end
	--print("---")
	--print(active_element)
	--print(next_element)
	local basic_damage = omni_mace_basic_hit(caster, ability, target, event)
	if caster:HasModifier("modifier_omniro_immortal_weapon_1") then
		omni_mace_basic_hit(caster, ability, target, event)
	end

	if caster:HasModifier("modifier_omni_orb_active") then
		if caster.omniro_data[active_element]["charges"] > 0 or caster:HasModifier("modifier_dimension_stalker_active") then
			if not caster:HasModifier("modifier_dimension_stalker_active") then
				caster.omniro_data[active_element]["charges"] = caster.omniro_data[active_element]["charges"] - 1
			end
			omni_orb_charge_procced(event, basic_damage)
		end
	end
	if caster:HasModifier("modifier_omniro_glyph_6_1") then
		caster.omniro_data[active_element]["charge_up_fraction"] = caster.omniro_data[active_element]["charge_up_fraction"] + OMNIRO_GLYPH_6_1_RECHARGE_ON_ATTACK_PERCENT

	end
	if not caster.omniro_data[caster.active_element]["locked"] then
		caster.omniro_data[active_element]["active"] = false
		caster.omniro_data[next_element]["active"] = true
		caster.active_element = next_element

		local mace_hit = omni_mace_basic_element_data(next_element)
		-- if caster.omniro_weapon_pfx then
		-- ParticleManager:SetParticleControl(caster.omniro_weapon_pfx, 1, mace_hit["color"])
		-- end
	end

	-- local player = caster:GetPlayerOwner()
	-- CustomGameEventManager:Send_ServerToPlayer(player, "update_omniro", {omniro = caster:GetEntityIndex()})
end

function omni_mace_toggle_on(event)
	local caster = event.caster
	caster.omniro_data[caster.active_element]["locked"] = true
end

function omni_mace_toggle_off(event)
	local caster = event.caster
	caster.omniro_data[caster.active_element]["locked"] = false
end

function omni_mace_ui_toggle(msg)
	local caster = EntIndexToHScript(msg.omniro)
	if msg.alt == 1 then
		local total_elements_active_count = 0
		for i = 1, #caster.omniro_data, 1 do
			if caster.omniro_data[i]["level"] > 0 and caster.omniro_data[i]["in_rotation"] == 1 then
				total_elements_active_count = total_elements_active_count + 1
			end
		end
		if caster.omniro_data[msg.element_index]["in_rotation"] == 1 and total_elements_active_count > 1 then
			caster.omniro_data[msg.element_index]["in_rotation"] = 0
		else
			caster.omniro_data[msg.element_index]["in_rotation"] = 1
		end
		CustomNetTables:SetTableValue("hero_index", "omniro-"..tostring(caster:GetEntityIndex()), caster.omniro_data)
		local player = caster:GetPlayerOwner()
		CustomGameEventManager:Send_ServerToPlayer(player, "update_omniro", {omniro = caster:GetEntityIndex(), reconstruct = true})
	else
		local lock_new_skill = false
		caster.omniro_data[caster.active_element]["active"] = false
		if caster.omniro_data[caster.active_element]["locked"] then
			lock_new_skill = true
			caster.omniro_data[caster.active_element]["locked"] = false
		end
		if lock_new_skill then
			caster.omniro_data[msg.element_index]["locked"] = true
		end
		caster.omniro_data[msg.element_index]["active"] = true
		caster.active_element = msg.element_index
		CustomNetTables:SetTableValue("hero_index", "omniro-"..tostring(caster:GetEntityIndex()), caster.omniro_data)
		CustomGameEventManager:Send_ServerToPlayer(player, "update_omniro", {omniro = caster:GetEntityIndex()})
	end
end

function omni_mace_basic_hit(caster, ability, target, event)
	local mace_hit_data = omni_mace_basic_element_data(caster.active_element)
	local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/omniro/omni_mace.vpcf", target, 0.4)
	--print(mace_hit_data["color"])
	ParticleManager:SetParticleControl(pfx, 1, mace_hit_data["color"])
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * (event.damage_mult / 100) * caster.omniro_data[caster.active_element]["level"]
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, mace_hit_data["damage_type"], BASE_ABILITY_Q, caster.active_element, RPC_ELEMENT_NONE)

	if caster.active_element == RPC_ELEMENT_FIRE then
		local duration = Filters:GetAdjustedBuffDuration(caster, OMNIRO_FIRE_SPECIAL_DURATION, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omnimace_fire_buff", {duration = duration})
		caster:SetModifierStackCount("modifier_omnimace_fire_buff", caster, caster.omniro_data[RPC_ELEMENT_FIRE]["level"])
	elseif caster.active_element == RPC_ELEMENT_EARTH then
		local duration = Filters:GetAdjustedBuffDuration(caster, OMNIRO_EARTH_SPECIAL_DURATION, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omnimace_earth_buff", {duration = duration})
		caster:SetModifierStackCount("modifier_omnimace_earth_buff", caster, caster.omniro_data[RPC_ELEMENT_EARTH]["level"])
	elseif caster.active_element == RPC_ELEMENT_LIGHTNING then
		local lightning_dmg = target:GetHealth() * (event.lightning_special_a / 100) * caster.omniro_data[RPC_ELEMENT_LIGHTNING]["level"]
		Filters:TakeArgumentsAndApplyDamage(target, caster, lightning_dmg, mace_hit_data["damage_type"], BASE_ABILITY_Q, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
	elseif caster.active_element == RPC_ELEMENT_POISON then
		local duration = 2
		ability:ApplyDataDrivenModifier(caster, target, "modifier_omnimace_poison_debuff", {duration = duration})
	elseif caster.active_element == RPC_ELEMENT_TIME then
		local duration = Filters:GetAdjustedBuffDuration(caster, OMNIRO_TIME_SPECIAL_DURATION, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omnimace_time_buff", {duration = duration})
		caster:SetModifierStackCount("modifier_omnimace_time_buff", caster, caster.omniro_data[RPC_ELEMENT_TIME]["level"])
	elseif caster.active_element == RPC_ELEMENT_HOLY then
		local base_duration = event.holy_special_a * caster.omniro_data[RPC_ELEMENT_HOLY]["level"]
		local duration = Filters:GetAdjustedBuffDuration(caster, base_duration, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omnimace_holy_buff", {duration = duration})
	elseif caster.active_element == RPC_ELEMENT_COSMOS then
		local duration = Filters:GetAdjustedBuffDuration(caster, OMNIRO_COSMIC_SPECIAL_DURATION, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omnimace_cosmic_buff", {duration = duration})
		caster:SetModifierStackCount("modifier_omnimace_cosmic_buff", caster, caster.omniro_data[RPC_ELEMENT_COSMOS]["level"])
	elseif caster.active_element == RPC_ELEMENT_ICE then
		local duration = OMNIRO_ICE_SPECIAL_DURATION
		local icePoint = target:GetAbsOrigin()
		local radius = OMNIRO_ICE_SPECIAL_RADIUS
		local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
		local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, icePoint)
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
		Timers:CreateTimer(2.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), icePoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_ice_debuff", {duration = duration})
				enemy:SetModifierStackCount("modifier_ice_debuff", caster, caster.omniro_data[RPC_ELEMENT_ICE]["level"])
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, mace_hit_data["damage_type"], BASE_ABILITY_Q, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
			end
		end
	elseif caster.active_element == RPC_ELEMENT_ARCANE then
		local manaDrain = math.min(caster:GetMana(), caster:GetMaxMana() * (OMNIRO_ARCANE_MANA_DRAIN_PERCENTAGE / 100))
		caster:ReduceMana(manaDrain)
		local arcane_damage = (event.arcane_special_a) * manaDrain * caster.omniro_data[RPC_ELEMENT_ARCANE]["level"]
		Filters:TakeArgumentsAndApplyDamage(target, caster, arcane_damage, mace_hit_data["damage_type"], BASE_ABILITY_Q, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
		return arcane_damage
	elseif caster.active_element == RPC_ELEMENT_SHADOW then
		local duration = OMNIRO_SHADOW_SPECIAL_DURATION
		ability:ApplyDataDrivenModifier(caster, target, "modifier_omniro_shadow_debuff", {duration = duration})
		local shadow_damage = (event.shadow_special_a / 100) * damage * caster.omniro_data[RPC_ELEMENT_SHADOW]["level"]
		Filters:TakeArgumentsAndApplyDamage(target, caster, shadow_damage, mace_hit_data["damage_type"], BASE_ABILITY_Q, RPC_ELEMENT_SHADOW, RPC_ELEMENT_NONE)
		target:SetModifierStackCount("modifier_omniro_shadow_debuff", caster, caster.omniro_data[RPC_ELEMENT_SHADOW]["level"])
		target:CalculateAndSaveRoshpitAttributes()
	elseif caster.active_element == RPC_ELEMENT_WIND then
		local duration = Filters:GetAdjustedBuffDuration(caster, OMNIRO_WIND_SPECIAL_DURATION, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omnimace_wind_buff", {duration = duration})
		caster:SetModifierStackCount("modifier_omnimace_wind_buff", caster, caster.omniro_data[RPC_ELEMENT_WIND]["level"])
	elseif caster.active_element == RPC_ELEMENT_GHOST then
		local base_duration = event.ghost_special_a * caster.omniro_data[RPC_ELEMENT_GHOST]["level"]
		local duration = Filters:GetAdjustedBuffDuration(caster, base_duration, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omnimace_ghost_buff", {duration = duration})
	elseif caster.active_element == RPC_ELEMENT_WATER then
		local duration = Filters:GetAdjustedBuffDuration(caster, OMNIRO_WATER_SPECIAL_DURATION, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omnimace_water_buff", {duration = duration})
		caster:SetModifierStackCount("modifier_omnimace_water_buff", caster, caster.omniro_data[RPC_ELEMENT_WATER]["level"])
		local flat_heal = event.water_special_a * caster.omniro_data[RPC_ELEMENT_WATER]["level"]
		Filters:ApplyHeal(caster, caster, flat_heal, true)
		CustomAbilities:QuickAttachParticle("particles/roshpit/omniro/basic_water_heal.vpcf", caster, 1)
	elseif caster.active_element == RPC_ELEMENT_DEMON then
		local duration = Filters:GetAdjustedBuffDuration(caster, OMNIRO_DEMON_SPECIAL_DURATION, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omnimace_demon_buff", {duration = duration})
		caster:SetModifierStackCount("modifier_omnimace_demon_buff", caster, caster.omniro_data[RPC_ELEMENT_DEMON]["level"])
	elseif caster.active_element == RPC_ELEMENT_NATURE then
		local base_duration = event.nature_special_a * caster.omniro_data[RPC_ELEMENT_NATURE]["level"]
		ability:ApplyDataDrivenModifier(caster, target, "modifier_omnimace_nature_debuff", {duration = base_duration})
	elseif caster.active_element == RPC_ELEMENT_UNDEAD then
		local base_duration = event.undead_special_a * caster.omniro_data[RPC_ELEMENT_UNDEAD]["level"]
		ability:ApplyDataDrivenModifier(caster, target, "modifier_omnimace_undead_debuff", {duration = base_duration})

		local duration = Filters:GetAdjustedBuffDuration(caster, OMNIRO_UNDEAD_SPECIAL_DURATION, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omnimace_undead_buff", {duration = duration})
		caster:SetModifierStackCount("modifier_omnimace_undead_buff", caster, caster.omniro_data[RPC_ELEMENT_UNDEAD]["level"])
	elseif caster.active_element == RPC_ELEMENT_DRAGON then
		local duration = Filters:GetAdjustedBuffDuration(caster, OMNIRO_DRAGON_SPECIAL_DURATION, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_omniro_dragon_buff", {duration = duration})
		caster:SetModifierStackCount("modifier_omniro_dragon_buff", caster, caster.omniro_data[RPC_ELEMENT_DRAGON]["level"])
	end
end

function omnimace_poison_debuff_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local poison_damage = (event.poison_special_a / 100) * OverflowProtectedGetAverageTrueAttackDamage(caster)
	if target:HasModifier("modifier_omniro_poison_pool_enemy") then
		poison_damage = poison_damage * OMNIRO_POISON_MULTIPLE_FOR_DOUBLE
	end
	local hit_data = omni_mace_basic_element_data(RPC_ELEMENT_POISON)
	Filters:ApplyDotDamage(caster, ability, target, poison_damage, hit_data["damage_type"], 1, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
end

function omnimace_root_think(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local nature_damage = (event.nature_special_b / 100) * OverflowProtectedGetAverageTrueAttackDamage(caster)
	local hit_data = omni_mace_basic_element_data(RPC_ELEMENT_NATURE)
	Filters:ApplyDotDamage(caster, ability, target, nature_damage, hit_data["damage_type"], 1, RPC_ELEMENT_NATURE, RPC_ELEMENT_NONE)
end

function omni_mace_basic_element_data(element)
	mace_hit_data = {}
	if element == RPC_ELEMENT_NORMAL then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_PHYSICAL
	elseif element == RPC_ELEMENT_FIRE then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_PHYSICAL
	elseif element == RPC_ELEMENT_EARTH then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_PHYSICAL
	elseif element == RPC_ELEMENT_LIGHTNING then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_PHYSICAL
	elseif element == RPC_ELEMENT_POISON then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_MAGICAL
	elseif element == RPC_ELEMENT_TIME then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_PURE
	elseif element == RPC_ELEMENT_HOLY then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_MAGICAL
	elseif element == RPC_ELEMENT_COSMOS then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_PURE
	elseif element == RPC_ELEMENT_ICE then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_MAGICAL
	elseif element == RPC_ELEMENT_ARCANE then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_MAGICAL
	elseif element == RPC_ELEMENT_SHADOW then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_MAGICAL
	elseif element == RPC_ELEMENT_WIND then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_MAGICAL
	elseif element == RPC_ELEMENT_GHOST then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_PHYSICAL
	elseif element == RPC_ELEMENT_WATER then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_PURE
	elseif element == RPC_ELEMENT_DEMON then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_PURE
	elseif element == RPC_ELEMENT_NATURE then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_MAGICAL
	elseif element == RPC_ELEMENT_UNDEAD then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_MAGICAL
	elseif element == RPC_ELEMENT_DRAGON then
		mace_hit_data["damage_type"] = DAMAGE_TYPE_PURE
	end
	local name, hex = Elements:GetElementNameAndColorByCode(element)
	local red, green, blue = Elements:hex2rgb(hex)
	mace_hit_data["color"] = Vector(red, green, blue) / 255
	return mace_hit_data
end

function omniro_elemental_bonus(element1, element2, caster)
	local ability = caster:FindAbilityByName("omniro_omni_mace")
	local mult = 0
	if element1 == -1 or element1 == 0 then
		return 0
	end
	if element2 == -1 or element2 == 0 then
		element2 = element1
	end
	if caster:HasModifier("modifier_omniro_glyph_5_a") then
		if caster.omniro_data[element1] then
			if WallPhysics:DoesTableHaveValue(ability.highest_elements_table, caster.omniro_data[element1]["element_number"]) then
				if ability.highest_elements_table[1] == element1 or ability.highest_elements_table[1] == element2 then
					mult = mult + OMNIRO_GLYPH_5_A_TOP_1_BONUS / 100
				end
				if ability.highest_elements_table[2] == element1 or ability.highest_elements_table[2] == element2 then
					mult = mult + OMNIRO_GLYPH_5_A_TOP_2_BONUS / 100
				end
				if ability.highest_elements_table[3] == element1 or ability.highest_elements_table[3] == element2 then
					mult = mult + OMNIRO_GLYPH_5_A_TOP_3_BONUS / 100
				end
				if ability.highest_elements_table[4] == element1 or ability.highest_elements_table[4] == element2 then
					mult = mult + OMNIRO_GLYPH_5_A_TOP_4_BONUS / 100
				end
			end
		end
	end
	return mult
end

function omniro_AmplifyDamageParticle(event)
	local target = event.target
	local location = target:GetAbsOrigin()
	local particleName = "particles/roshpit/omniro/shadow_armor_shred.vpcf"
	if target.AmpDamageParticle then
		ParticleManager:DestroyParticle(target.AmpDamageParticle, false)
	end
	-- Particle. Need to wait one frame for the older particle to be destroyed
	Timers:CreateTimer(0.01, function()
		target.AmpDamageParticle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControl(target.AmpDamageParticle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(target.AmpDamageParticle, 1, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(target.AmpDamageParticle, 2, target:GetAbsOrigin())

		ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 1, target, PATTACH_OVERHEAD_FOLLOW, "attach_overhead", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 2, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	end)

end

-- Destroys the particle when the modifier is destroyed
function omniro_EndAmplifyDamageParticle(event)
	local target = event.target
	if target.AmpDamageParticle then
		ParticleManager:DestroyParticle(target.AmpDamageParticle, false)
		target.AmpDamageParticle = nil
	end
end
-- RPC_ELEMENT_NONE = -1
-- RPC_ELEMENT_NORMAL = 1
-- RPC_ELEMENT_FIRE = 2
-- RPC_ELEMENT_EARTH = 3
-- RPC_ELEMENT_LIGHTNING = 4
-- RPC_ELEMENT_POISON = 5
-- RPC_ELEMENT_TIME = 6
-- RPC_ELEMENT_HOLY = 7
-- RPC_ELEMENT_COSMOS = 8
-- RPC_ELEMENT_ICE = 9
-- RPC_ELEMENT_ARCANE = 10
-- RPC_ELEMENT_SHADOW = 11
-- RPC_ELEMENT_WIND = 12
-- RPC_ELEMENT_GHOST = 13
-- RPC_ELEMENT_WATER = 14
-- RPC_ELEMENT_DEMON = 15
-- RPC_ELEMENT_NATURE = 16
-- RPC_ELEMENT_UNDEAD = 17
-- RPC_ELEMENT_DRAGON = 18
