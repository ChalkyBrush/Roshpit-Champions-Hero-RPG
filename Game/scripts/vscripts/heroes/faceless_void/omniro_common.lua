require('heroes/faceless_void/omniro_constants')

function InitOmniroData(hero, ability)
	local orb_ability = hero:FindAbilityByName("omniro_omni_orb")
	hero.omniro_data = {}
	for i = 1, 18, 1 do
		hero.omniro_data[i] = {}
		hero.omniro_data[i]["enabled"] = true
		hero.omniro_data[i]["element_number"] = i
		hero.omniro_data[i]["active"] = false
		hero.omniro_data[i]["locked"] = false
		hero.omniro_data[i]["in_rotation"] = 1
		hero.omniro_data[i]["ability_index"] = ability:GetEntityIndex()
		hero.omniro_data[i]["orb_ability_index"] = orb_ability:GetEntityIndex()
		hero.omniro_data[i]["charges"] = 1
		hero.omniro_data[i]["level"] = 0
		hero.omniro_data[i]["max_charges"] = 1
		hero.omniro_data[i]["charge_up_fraction"] = 0
		hero.omniro_data[i]["charge_up_fraction_full"] = 100
		if i > 1 then
			hero.omniro_data[i]["rune_tier"] = math.floor(((i - 2) / 4) + 1)
		else
			hero.omniro_data[i]["rune_tier"] = 0
		end
	end
	hero.omniro_data[1]["active"] = true
	hero.active_element = 1
end

function OmniroElementChargeThink(hero)
	local recharge_rate = 1
	for i = 1, #hero.omniro_data, 1 do
		if hero.omniro_data[i]["level"] > 0 then
			if hero.omniro_data[i]["charges"] < hero.omniro_data[i]["max_charges"] then
				local local_recharge_rate = recharge_rate
				if hero:HasModifier("modifier_omniro_glyph_4_1") and hero.omniro_data[i]["element_number"] == RPC_ELEMENT_NORMAL then
					local_recharge_rate = local_recharge_rate * (1 + OMNIRO_GLYPH_4_1_NORMAL_RECHARGE / 100)
				end
				if hero:HasModifier("modifier_omniro_immortal_weapon_2") and hero.omniro_data[i]["element_number"] ~= RPC_ELEMENT_NORMAL then
					local_recharge_rate = local_recharge_rate * (1 + hero.omniro_data[i]["max_charges"]*OMNIRO_LEGEND_WEAPON_2_RECHARGE_INCREASE / 100)
				end
				hero.omniro_data[i]["charge_up_fraction"] = hero.omniro_data[i]["charge_up_fraction"] + local_recharge_rate
				if hero.omniro_data[i]["charge_up_fraction"] >= hero.omniro_data[i]["charge_up_fraction_full"] then
					hero.omniro_data[i]["charge_up_fraction"] = 0
					hero.omniro_data[i]["charges"] = math.min(hero.omniro_data[i]["charges"] + 1, hero.omniro_data[i]["max_charges"])
				end
			end
		else
			hero.omniro_data[i]["enabled"] = false
		end
	end
end

function OmniroOmniMaceBaseElementData(element)
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

function OmniroRuneCalculate(caster, ability)
	local reconstruct = false
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
	

	local normalLevel = 1
	if caster:HasModifier("modifier_omniro_glyph_4_1") then
		normalLevel = normalLevel + OMNIRO_GLYPH_4_1_NORMAL_LEVELS
	end
	if caster.omniro_data[RPC_ELEMENT_NORMAL]["level"] ~= normalLevel then
		caster.omniro_data[RPC_ELEMENT_NORMAL]["level"] = normalLevel
		reconstruct = true
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
	local dragonLevel = 0
	if caster:HasModifier("modifier_omniro_immortal_weapon_3") then
		dragonLevel = 1
	end
	if caster.omniro_data[RPC_ELEMENT_DRAGON]["level"] ~= dragonLevel then
		caster.omniro_data[RPC_ELEMENT_DRAGON]["level"] = dragonLevel
		reconstruct = true
	end
	if caster:HasModifier("modifier_omniro_glyph_5_1") then
		OmniroSetLowestElementsTable(caster, ability)
	end
	if caster:HasModifier("modifier_omniro_glyph_5_a") or caster:HasModifier("modifier_omniro_glyph_7_1") then
		OmniroSetHighestElementsTable(caster, ability)
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

function OmniroSetLowestElementsTable(caster, ability)
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

function OmniroSetHighestElementsTable(caster, ability)
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

function OmniroOmniMaceUIToggle(msg)
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

function OmniroOmniOrbChargeProceed(caster, ability, target, basic_damage)
	local mace_hit_data = OmniroOmniMaceBaseElementData(caster.active_element)
	local orb_ability = caster:FindAbilityByName("omniro_omni_orb")
	if caster.active_element == RPC_ELEMENT_NORMAL then
		local damage = OMNIRO_ORB_NORMAL_ATTACK_POWER_MULT_PCT[orb_ability:GetLevel()] * OverflowProtectedGetAverageTrueAttackDamage(caster) * caster.omniro_data[RPC_ELEMENT_NORMAL]["level"]
		local pfx = ParticleManager:CreateParticle("particles/roshpit/omniro/omniro_normal_orb.vpcf", PATTACH_ABSORIGIN, caster)
		-- local pull_direction = ((target:GetAbsOrigin() - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin() + Vector(0, 0, 40))
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, mace_hit_data["damage_type"], BASE_ABILITY_W, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
			end
		end
		Timers:CreateTimer(0.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		EmitSoundOn("Omniro.Orb.Normal", target)
	elseif caster.active_element == RPC_ELEMENT_FIRE then
		local damage = OMNIRO_ORB_FIRE_ATTACK_POWER_MULT_PCT[orb_ability:GetLevel()] * OverflowProtectedGetAverageTrueAttackDamage(caster) * caster.omniro_data[RPC_ELEMENT_FIRE]["level"]

		local particleName = "particles/units/heroes/hero_elder_titan/ring_of_fire.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		local origin = target:GetAbsOrigin()
		ParticleManager:SetParticleControl(particle1, 0, origin + Vector(0, 0, 50))
		for i = 1, 9, 1 do
			ParticleManager:SetParticleControl(particle1, i, Vector(440, 440, 440))
		end

		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), origin, nil, OMNIRO_ORB_FIRE_AOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, mace_hit_data["damage_type"], BASE_ABILITY_W, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
			end
		end
		Timers:CreateTimer(1, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)

		EmitSoundOn("Omniro.Orb.Fire", target)
	elseif caster.active_element == RPC_ELEMENT_EARTH then
		local damage = OMNIRO_ORB_EARTH_STR_MULT_PCT[orb_ability:GetLevel()] * caster:GetStrength() * caster.omniro_data[RPC_ELEMENT_EARTH]["level"]
		local radius = OMNIRO_ORB_EARTH_AOE
		local position = target:GetAbsOrigin()
		local stun_duration = OMNIRO_ORB_EARTH_STUN_DUR * caster.omniro_data[RPC_ELEMENT_EARTH]["level"]
		local splitEarthParticle = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
		local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, position)
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
		EmitSoundOn("Omniro.Orb.Earth", target)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius + 5, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, mace_hit_data["damage_type"], BASE_ABILITY_W, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE)
				Filters:ApplyStun(caster, stun_duration, enemy)
			end
		end
		Timers:CreateTimer(3.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
	elseif caster.active_element == RPC_ELEMENT_LIGHTNING then
		local damage = OMNIRO_ORB_LIGHTNING_AGI_MULT_PCT[orb_ability:GetLevel()] * caster:GetAgility() * caster.omniro_data[RPC_ELEMENT_LIGHTNING]["level"]

		local chain = {}
		chain.index_hit = 0
		chain.enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, OMNIRO_ORB_LIGHTNING_SEARCH_RADIUS, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)
		local targets_to_hit = OMNIRO_ORB_LIGHTNING_BASE_BOUNCES + caster.omniro_data[RPC_ELEMENT_LIGHTNING]["max_charges"]
		for i = 1, targets_to_hit, 1 do
			Timers:CreateTimer((i - 1) * 0.15, function()
				local enemy = chain.enemies[i]
				if IsValidEntity(enemy) and enemy:IsAlive() then
					EmitSoundOn("Omniro.Orb.Lightning", enemy)
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, mace_hit_data["damage_type"], BASE_ABILITY_W, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
					local particleName = "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf"
					local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
					local attach_unit_1 = caster
					if i > 1 then
						attach_unit_1 = chain.enemies[i - 1]
					end
					ParticleManager:SetParticleControl(pfx, 0, attach_unit_1:GetAbsOrigin() + Vector(0, 0, attach_unit_1:GetBoundingMaxs().z + 80))
					ParticleManager:SetParticleControl(pfx, 1, enemy:GetAbsOrigin() + Vector(0, 0, enemy:GetBoundingMaxs().z + 100))
					Timers:CreateTimer(0.3, function()
						ParticleManager:DestroyParticle(pfx, false)
					end)
				end
			end)
		end
	elseif caster.active_element == RPC_ELEMENT_POISON then
		local thinkerDuration = OMNIRO_ORB_POISON_POOL_DURATION
		local particleName = "particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf"
		CustomAbilities:QuickAttachThinker(orb_ability, caster, target:GetAbsOrigin(), "modifier_omniro_poison_orb_pool", {duration = thinkerDuration})
		StartSoundEvent("Omniro.Orb.Poison", target)
		Timers:CreateTimer(4, function()
			if target and IsValidEntity(target) then
				StopSoundEvent("Omniro.Orb.Poison", target)
			end
		end)
		local pfx = CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", target:GetAbsOrigin(), thinkerDuration)
		ParticleManager:SetParticleControl(pfx, 1, Vector(OMNIRO_ORB_POISON_POOL_RADIUS, OMNIRO_ORB_POISON_POOL_RADIUS, OMNIRO_ORB_POISON_POOL_RADIUS))
	elseif caster.active_element == RPC_ELEMENT_TIME then
		local debuff_duration = OMNIRO_ORB_TIME_FREEZE_DURATION * caster.omniro_data[RPC_ELEMENT_TIME]["level"] + OMNIRO_TIME_ORB_BASE_DURATION
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, OMNIRO_ORB_TIME_AOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				CustomAbilities:QuickAttachParticle("particles/roshpit/omniro/timelock.vpcf", enemy, 3)
				--enemy:AddNewModifier(caster, orb_ability, "modifier_omniro_time_freeze", {duration = debuff_duration})
				orb_ability:ApplyDataDrivenModifier(caster, enemy, "modifier_omniro_time_freeze", {duration = debuff_duration})
			end
		end
		EmitSoundOn("Omniro.Orb.Time.Start", target)
	elseif caster.active_element == RPC_ELEMENT_HOLY then
		local damage = OMNIRO_ORB_HOLY_INT_MULT_PCT[orb_ability:GetLevel()] * caster:GetIntellect() * caster.omniro_data[RPC_ELEMENT_HOLY]["level"] + OMNIRO_ORB_HOLY_ARMOR_MULT_PCT[orb_ability:GetLevel()] * caster:GetRoshpitArmor() * caster.omniro_data[RPC_ELEMENT_HOLY]["level"]
		EmitSoundOn("Omniro.Orb.Holy", caster)
		local radius = OMNIRO_ORB_HOLY_AOE
		local particleName = "particles/units/heroes/hero_elder_titan/paladin_holy_nova.vpcf"
		local position = caster:GetAbsOrigin()
		local particleVector = position + Vector(0, 0, 40)

		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, particleVector)
		Timers:CreateTimer(1, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		local filteredDamage = 0
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				filteredDamage = Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, mace_hit_data["damage_type"], BASE_ABILITY_W, RPC_ELEMENT_HOLY, RPC_ELEMENT_NONE)
			end
		end
		local allies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		local heal = filteredDamage * (OMNIRO_ORB_HOLY_HEAL_PCT / 100)
		if #allies > 0 then
			for _, ally in pairs(allies) do
				Filters:ApplyHeal(caster, ally, heal, false)
				PopupHealing(ally, heal)
			end
		end
	elseif caster.active_element == RPC_ELEMENT_COSMOS then
		local comet_damage = OMNIRO_ORB_COSMIC_ATTACK_POWER_MULT_PCT[orb_ability:GetLevel()] * OverflowProtectedGetAverageTrueAttackDamage(caster) * caster.omniro_data[RPC_ELEMENT_COSMOS]["level"] + OMNIRO_ORB_COSMIC_HP_MULT_PCT[orb_ability:GetLevel()] * caster:GetMaxHealth() * caster.omniro_data[RPC_ELEMENT_COSMOS]["level"]
		local starParticle = "particles/roshpit/solunia/comet_moon_attack_attack.vpcf"
		local position = target:GetAbsOrigin()
		local pfx = CustomAbilities:QuickParticleAtPoint(starParticle, position, 3)
		EmitSoundOnLocationWithCaster(position, "Omniro.Orb.Cosmic.Start", caster)
		Timers:CreateTimer(0.45, function()
			local radius = OMNIRO_ORB_COSMIC_RADIUS
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				for _, enemy in pairs(enemies) do
					Filters:TakeArgumentsAndApplyDamage(enemy, caster, comet_damage, mace_hit_data["damage_type"], BASE_ABILITY_W, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
				end
			end
			CustomAbilities:QuickParticleAtPoint("particles/roshpit/omniro/cosmic_orb_impact.vpcf", position, 3)
			EmitSoundOnLocationWithCaster(position, "Omniro.Orb.Cosmic", caster)
		end)
	elseif caster.active_element == RPC_ELEMENT_ICE then
		local mace_ability = caster:FindAbilityByName("omniro_omni_mace")
		EmitSoundOn("Omniro.Orb.Ice", target)
		local duration = OMNIRO_ICE_SPECIAL_DURATION
		local icePoint = target:GetAbsOrigin()
		local radius = OMNIRO_ICE_ORB_BASE_RADIUS + OMNIRO_ORB_ICE_RADIUS_GROW * caster.omniro_data[RPC_ELEMENT_ICE]["level"]
		local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
		local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)

		local agi_mult = 1
		local str_mult = 1
		local int_mult = 1
		local spir_mult = 1
		if caster:GetAgility() < caster:GetStrength() and caster:GetAgility() < caster:GetIntellect() and caster:GetAgility() < caster:GetSpirit() then
			agi_mult = OMNIRO_ICE_LOWEST_ATTRIBUTE_MULT
		elseif caster:GetStrength() < caster:GetAgility() and caster:GetStrength() < caster:GetIntellect() and caster:GetStrength() < caster:GetSpirit() then
			str_mult = OMNIRO_ICE_LOWEST_ATTRIBUTE_MULT
		elseif caster:GetIntellect() < caster:GetStrength() and caster:GetIntellect() < caster:GetAgility() and caster:GetIntellect() < caster:GetSpirit()  then
			agi_mult = OMNIRO_ICE_LOWEST_ATTRIBUTE_MULT
		else
			spir_mult = OMNIRO_ICE_LOWEST_ATTRIBUTE_MULT
		end
		local damage = OMNIRO_ORB_ICE_ALL_ATTRIBUTES_MULT_PCT[orb_ability:GetLevel()] * (caster:GetIntellect() * int_mult + caster:GetStrength() * str_mult + caster:GetAgility() * agi_mult + caster:GetSpirit() * spir_mult) * caster.omniro_data[RPC_ELEMENT_ICE]["level"]
		ParticleManager:SetParticleControl(pfx, 0, icePoint)
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
		Timers:CreateTimer(2.5, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), icePoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				enemy:AddNewModifier(caster, mace_ability, "modifier_omniro_omni_mace_ice", {duration = duration})
				enemy:SetModifierStackCount("modifier_omniro_omni_mace_ice", caster, caster.omniro_data[RPC_ELEMENT_ICE]["level"])
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, mace_hit_data["damage_type"], BASE_ABILITY_W, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
			end
		end
	elseif caster.active_element == RPC_ELEMENT_ARCANE then
		EmitSoundOn("Omniro.Orb.Arcane", caster)

		local debuff_duration = OMNIRO_ARCANE_ORB_MR_LOSS_DURATION
		local radius = OMNIRO_ARCANE_BASE_AOE + OMNIRO_ORB_ARCANE_RADIUS_GROW * caster.omniro_data[RPC_ELEMENT_ARCANE]["level"]
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		local pulses = OMNIRO_ARCANE_ORB_BASE_PULSES + caster.omniro_data[RPC_ELEMENT_ARCANE]["max_charges"]
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				--enemy:AddNewModifier(caster, orb_ability, "modifier_arcane_orb_magic_resist", {duration = debuff_duration})
				orb_ability:ApplyDataDrivenModifier(caster, enemy, "modifier_arcane_orb_magic_resist", {duration = debuff_duration})
				enemy:SetModifierStackCount("modifier_arcane_orb_magic_resist", caster, caster.omniro_data[RPC_ELEMENT_ARCANE]["level"])
				enemy:CalculateAndSaveRoshpitAttributes()
				for i = 1, pulses, 1 do
					Timers:CreateTimer((i - 1) * 0.5, function()
						if enemy and IsValidEntity(enemy) then
							local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/omniro/omni_mace.vpcf", enemy, 0.4)
							ParticleManager:SetParticleControl(pfx, 1, mace_hit_data["color"])
							Filters:TakeArgumentsAndApplyDamage(enemy, caster, basic_damage, mace_hit_data["damage_type"], BASE_ABILITY_W, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
							EmitSoundOn("Omniro.Orb.Arcane.Sub", enemy)
						end
					end)
				end

			end
		end
	elseif caster.active_element == RPC_ELEMENT_SHADOW then
		local mace_ability = caster:FindAbilityByName("omniro_omni_mace")
		EmitSoundOn("Omniro.Orb.Shadow", target)
		local damage = OMNIRO_ORB_SHADOW_ATTACK_POWER_MULT_PCT[orb_ability:GetLevel()] * OverflowProtectedGetAverageTrueAttackDamage(caster) * caster.omniro_data[RPC_ELEMENT_SHADOW]["level"]
		local shadowRadius = OMNIRO_SHADOW_ORB_BASE_AOE + OMNIRO_ORB_SHADOW_RADIUS_GROW * caster.omniro_data[RPC_ELEMENT_SHADOW]["level"]
		local duration = OMNIRO_SHADOW_SPECIAL_DURATION
		local origin = target:GetAbsOrigin()
		local particleName = "particles/roshpit/items/nightmare_rider_mantle_cowlofice.vpcf"
		local particle1 = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControl(particle1, 0, origin + Vector(0, 0, 20))
		ParticleManager:SetParticleControl(particle1, 1, Vector(shadowRadius, 2, shadowRadius))
		ParticleManager:SetParticleControl(particle1, 3, Vector(shadowRadius, shadowRadius, shadowRadius))
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(particle1, false)
		end)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), origin, nil, shadowRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				enemy:AddNewModifier(caster, mace_ability, "modifier_omniro_omni_mace_shadow", {duration = duration})
				enemy:SetModifierStackCount("modifier_omniro_omni_mace_shadow", caster, caster.omniro_data[RPC_ELEMENT_SHADOW]["level"])
				enemy:CalculateAndSaveRoshpitAttributes()
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, mace_hit_data["damage_type"], BASE_ABILITY_W, RPC_ELEMENT_SHADOW, RPC_ELEMENT_NONE)
			end
		end
	elseif caster.active_element == RPC_ELEMENT_WIND then
		local fv = caster:GetForwardVector()
		local speed = 1300
		local rune_ability = caster.runeUnit3:FindAbilityByName("omniro_rune_e_3")
		local wind_range = OMNIRO_WIND_ORB_RANGE
		EmitSoundOn("Omniro.Orb.Wind", target)
		orb_ability.wind_orb_damage = OMNIRO_ORB_WIND_ATTACK_POWER_MULT_PCT[orb_ability:GetLevel()] * OverflowProtectedGetAverageTrueAttackDamage(caster) * caster.omniro_data[RPC_ELEMENT_WIND]["level"] + OMNIRO_ORB_WIND_AGI_MULT_PCT[orb_ability:GetLevel()] * caster:GetAgility() * caster.omniro_data[RPC_ELEMENT_WIND]["level"]
		for i = 1, 8, 1 do
			local wind_fv = WallPhysics:rotateVector(fv, 2 * math.pi * i / 8)
			local info =
			{
				Ability = rune_ability,
				EffectName = "particles/items/hurricane_vest_projectile.vpcf",
				vSpawnOrigin = target:GetAbsOrigin() + Vector(0, 0, 60),
				fDistance = wind_range,
				fStartRadius = 130,
				fEndRadius = 130,
				Source = caster,
				StartPosition = "attach_attack1",
				bHasFrontalCone = true,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime = GameRules:GetGameTime() + 5.0,
				bDeleteOnHit = false,
				vVelocity = wind_fv * Vector(1, 1, 0) * speed,
				bProvidesVision = false,
			}
			projectile = ProjectileManager:CreateLinearProjectile(info)
		end
	elseif caster.active_element == RPC_ELEMENT_GHOST then
		local radius = OMNIRO_GHOST_ORB_AOE
		local duration = OMNIRO_GHOST_ORB_BASE_DURATION + OMNIRO_ORB_GHOST_ADD_DURATION * caster.omniro_data[RPC_ELEMENT_GHOST]["level"]
		local location = target:GetAbsOrigin()
		local dummy = CreateUnitByName("npc_dummy_unit", location, false, nil, nil, caster:GetTeamNumber())
		dummy:SetAbsOrigin(location)
		dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
		dummy.hero = caster
		--dummy:AddNewModifier(dummy, orb_ability, "modifier_ghost_orb_aura", {duration = duration})
		orb_ability:ApplyDataDrivenModifier(dummy, dummy, "modifier_ghost_orb_aura", {duration = duration})
		dummy.pfx = ParticleManager:CreateParticle("particles/roshpit/omniro/ghost_orb_cloud.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(dummy.pfx, 0, location + Vector(0, 0, 80))
		ParticleManager:SetParticleControl(dummy.pfx, 1, Vector(radius, radius, 200))
		EmitSoundOn("Omniro.Orb.Ghost", target)
	elseif caster.active_element == RPC_ELEMENT_WATER then
		local damage = OMNIRO_ORB_WATER_ATTACK_POWER_MULT_PCT[orb_ability:GetLevel()] * OverflowProtectedGetAverageTrueAttackDamage(caster) * caster.omniro_data[RPC_ELEMENT_WATER]["level"]
		local hydroPosition = target:GetAbsOrigin()
		hydroPosition = GetGroundPosition(hydroPosition, target)
		EmitSoundOnLocationWithCaster(hydroPosition, "Omniro.Orb.Water", caster)
		local pfx = ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, hydroPosition)
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), hydroPosition, nil, OMNIRO_WATER_ORB_AOE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				if not enemy.jumpLock then
					if enemy:GetAbsOrigin().z - GetGroundHeight(enemy:GetAbsOrigin(), enemy) < 500 then
						if not Filters:HasFlyingModifier(enemy) then
							if not enemy:IsMagicImmune() then
								--enemy:AddNewModifier(caster, orb_ability, "modifier_torrent_stun", {duration = 4})
								--enemy:AddNewModifier(caster, orb_ability, "modifier_torrent_lifting", {duration = OMNIRO_WATER_STUN_DURATION})
								orb_ability:ApplyDataDrivenModifier(caster, enemy, "modifier_torrent_stun", {duration = 4})
								orb_ability:ApplyDataDrivenModifier(caster, enemy, "modifier_torrent_lifting", {duration = OMNIRO_WATER_STUN_DURATION})
								enemy.torrentLiftVelocity = 19
							end
						end
					end
				end
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, mace_hit_data["damage_type"], BASE_ABILITY_W, RPC_ELEMENT_WATER, RPC_ELEMENT_NONE)
			end
		end
	elseif caster.active_element == RPC_ELEMENT_DEMON then
		local damage = OMNIRO_ORB_DEMON_ATTACK_POWER_MULT_PCT[orb_ability:GetLevel()] * OverflowProtectedGetAverageTrueAttackDamage(caster) * caster.omniro_data[RPC_ELEMENT_DEMON]["level"]
		CustomAbilities:QuickAttachParticle("particles/roshpit/omniro/omniro_demon_orb.vpcf", target, 3)
		EmitSoundOn("Omniro.Orb.Demon", target)
		caster.ignore_steadfast = true
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, mace_hit_data["damage_type"], BASE_ABILITY_W, RPC_ELEMENT_DEMON, RPC_ELEMENT_NONE)
	elseif caster.active_element == RPC_ELEMENT_NATURE then
		EmitSoundOn("Omniro.Orb.Nature", target)
		local max_shield_stacks = OMNIRO_NATURE_SHIELD_BASE_MAX_STACKS + OMNIRO_ORB_NATURE_ADD_SHIELDS * caster.omniro_data[RPC_ELEMENT_NATURE]["level"]
		local current_stacks = caster:GetModifierStackCount("modifier_omniro_nature_shield", caster)
		local additional_stacks = Runes:Procs(caster.omniro_data[RPC_ELEMENT_NATURE]["level"], OMNIRO_ORB_NATURE_SHIELDS_CHANCE, 1)
		local final_new_stacks = math.min(current_stacks + additional_stacks, max_shield_stacks)

		local shield_duration = Filters:GetAdjustedBuffDuration(caster, OMNIRO_NATURE_SHIELD_DURATION, false)
		CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_oracle/grithault_heal_core.vpcf", caster, 3)
		orb_ability:ApplyDataDrivenModifier(caster, caster, "modifier_omniro_nature_shield", {duration = shield_duration})
		--caster:AddNewModifier(caster, orb_ability, "modifier_omniro_nature_shield", {duration = shield_duration})
		caster:SetModifierStackCount("modifier_omniro_nature_shield", caster, final_new_stacks)
	elseif caster.active_element == RPC_ELEMENT_UNDEAD then
		local fv = caster:GetForwardVector()
		local speed = 1200
		local rune_ability = caster.runeUnit4:FindAbilityByName("omniro_rune_r_4")
		local wind_range = OMNIRO_UNDEAD_ORB_RANGE
		EmitSoundOn("Omniro.Orb.Undead", target)
		orb_ability.undead_orb_damage = OMNIRO_ORB_UNDEAD_ATTACK_POWER_MULT_PCT[orb_ability:GetLevel()] * OverflowProtectedGetAverageTrueAttackDamage(caster) * caster.omniro_data[RPC_ELEMENT_UNDEAD]["level"] + OMNIRO_ORB_UNDEAD_DAMAGE_PER_CURR_HERO_HP[orb_ability:GetLevel()] * caster:GetHealth() * caster.omniro_data[RPC_ELEMENT_UNDEAD]["level"]

		local undead_fv = fv
		local info =
		{
			Ability = rune_ability,
			EffectName = "particles/roshpit/omniro/omniro_undead_orb_terror.vpcf",
			vSpawnOrigin = target:GetAbsOrigin() + Vector(0, 0, 60),
			fDistance = wind_range,
			fStartRadius = 130,
			fEndRadius = 130,
			Source = caster,
			StartPosition = "attach_attack1",
			bHasFrontalCone = true,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = undead_fv * Vector(1, 1, 0) * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
	elseif caster.active_element == RPC_ELEMENT_DRAGON then
		EmitSoundOn("Omniro.Orb.Dragon", caster)
		for i = 1, 17, 1 do
			caster.omniro_data[i]["charges"] = caster.omniro_data[i]["max_charges"]
			caster.omniro_data[i]["charge_up_fraction"] = 0
		end
		CustomAbilities:QuickAttachParticle("particles/act_2/frostbitten_icicle.vpcf", caster, 3)
	end
	Filters:CastSkillArguments(BASE_ABILITY_W, caster)
	caster:RemoveModifierByName("modifier_burnout")
end

function OmniroOmniMaceBasicHit(caster, ability, target)
	local mace_hit_data = OmniroOmniMaceBaseElementData(caster.active_element)
	local pfx = CustomAbilities:QuickAttachParticle("particles/roshpit/omniro/omni_mace.vpcf", target, 0.4)
	ParticleManager:SetParticleControl(pfx, 1, mace_hit_data["color"])
	local damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * OMNIRO_MACE_BASE_Q_ATTACK_DAMAGE_PCT[ability:GetLevel()]
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, mace_hit_data["damage_type"], BASE_ABILITY_Q, caster.active_element, RPC_ELEMENT_NONE)

	if caster.active_element == RPC_ELEMENT_FIRE then
		local duration = Filters:GetAdjustedBuffDuration(caster, OMNIRO_FIRE_SPECIAL_DURATION, false)
		caster:AddNewModifier(caster, ability, "modifier_omniro_omni_mace_fire", {duration = duration})
		caster:SetModifierStackCount("modifier_omniro_omni_mace_fire", caster, caster.omniro_data[RPC_ELEMENT_FIRE]["level"])
	elseif caster.active_element == RPC_ELEMENT_EARTH then
		local duration = Filters:GetAdjustedBuffDuration(caster, OMNIRO_EARTH_SPECIAL_DURATION, false)
		caster:AddNewModifier(caster, ability, "modifier_omniro_omni_mace_earth", {duration = duration})
		caster:SetModifierStackCount("modifier_omniro_omni_mace_earth", caster, caster.omniro_data[RPC_ELEMENT_EARTH]["level"])
	elseif caster.active_element == RPC_ELEMENT_LIGHTNING then
		local lightning_dmg = caster:GetAgility() * OMNIRO_MACE_LIGHTNING_DAMAGE_PER_AGI[ability:GetLevel()] * caster.omniro_data[RPC_ELEMENT_LIGHTNING]["level"]
		Filters:TakeArgumentsAndApplyDamage(target, caster, lightning_dmg, mace_hit_data["damage_type"], BASE_ABILITY_Q, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
	elseif caster.active_element == RPC_ELEMENT_POISON then
		local duration = 2
		target:AddNewModifier(caster, ability, "modifier_omniro_omni_mace_poison", {duration = duration})
	elseif caster.active_element == RPC_ELEMENT_TIME then
		local duration = Filters:GetAdjustedBuffDuration(caster, OMNIRO_TIME_SPECIAL_DURATION, false)
		caster:AddNewModifier(caster, ability, "modifier_omniro_omni_mace_time", {duration = duration})
		caster:SetModifierStackCount("modifier_omniro_omni_mace_time", caster, caster.omniro_data[RPC_ELEMENT_TIME]["level"])
	elseif caster.active_element == RPC_ELEMENT_HOLY then
		local base_duration = OMNIRO_MACE_HOLY_SPELL_IMMUN_DURATION[ability:GetLevel()] * caster.omniro_data[RPC_ELEMENT_HOLY]["level"]
		local duration = Filters:GetAdjustedBuffDuration(caster, base_duration, false)
		caster:AddNewModifier(caster, ability, "modifier_omniro_omni_mace_holy", {duration = duration})
	elseif caster.active_element == RPC_ELEMENT_COSMOS then
		local duration = Filters:GetAdjustedBuffDuration(caster, OMNIRO_COSMIC_SPECIAL_DURATION, false)
		caster:AddNewModifier(caster, ability, "modifier_omniro_omni_mace_cosmic", {duration = duration})
		caster:SetModifierStackCount("modifier_omniro_omni_mace_cosmic", caster, caster.omniro_data[RPC_ELEMENT_COSMOS]["level"])
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
				enemy:AddNewModifier(caster, ability, "modifier_omniro_omni_mace_ice", {duration = duration})
				enemy:SetModifierStackCount("modifier_omniro_omni_mace_ice", caster, caster.omniro_data[RPC_ELEMENT_ICE]["level"])
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, mace_hit_data["damage_type"], BASE_ABILITY_Q, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
			end
		end
	elseif caster.active_element == RPC_ELEMENT_ARCANE then
		local manaDrain = math.min(caster:GetMana(), caster:GetMaxMana() * (OMNIRO_ARCANE_MANA_DRAIN_PERCENTAGE / 100))
		caster:ReduceMana(manaDrain)
		local arcane_damage = OMNIRO_MACE_ARCANE_DMG_PER_MANA[ability:GetLevel()] * manaDrain * caster.omniro_data[RPC_ELEMENT_ARCANE]["level"]
		Filters:TakeArgumentsAndApplyDamage(target, caster, arcane_damage, mace_hit_data["damage_type"], BASE_ABILITY_Q, RPC_ELEMENT_ARCANE, RPC_ELEMENT_NONE)
		return arcane_damage
	elseif caster.active_element == RPC_ELEMENT_SHADOW then
		local duration = OMNIRO_SHADOW_SPECIAL_DURATION
		target:AddNewModifier(caster, ability, "modifier_omniro_omni_mace_shadow", {duration = duration})
		local shadow_damage = OMNIRO_MACE_SHADOW_Q_HIT_MULT_PCT[ability:GetLevel()] * damage * caster.omniro_data[RPC_ELEMENT_SHADOW]["level"]
		Filters:TakeArgumentsAndApplyDamage(target, caster, shadow_damage, mace_hit_data["damage_type"], BASE_ABILITY_Q, RPC_ELEMENT_SHADOW, RPC_ELEMENT_NONE)
		target:SetModifierStackCount("modifier_omniro_omni_mace_shadow", caster, caster.omniro_data[RPC_ELEMENT_SHADOW]["level"])
		target:CalculateAndSaveRoshpitAttributes()
	elseif caster.active_element == RPC_ELEMENT_WIND then
		local duration = Filters:GetAdjustedBuffDuration(caster, OMNIRO_WIND_SPECIAL_DURATION, false)
		caster:AddNewModifier(caster, ability, "modifier_omniro_omni_mace_wind", {duration = duration})
		caster:SetModifierStackCount("modifier_omniro_omni_mace_wind", caster, caster.omniro_data[RPC_ELEMENT_WIND]["level"])
	elseif caster.active_element == RPC_ELEMENT_GHOST then
		local base_duration = OMNIRO_MACE_GHOST_EVASION_DURATION[ability:GetLevel()] * caster.omniro_data[RPC_ELEMENT_GHOST]["level"]
		local duration = Filters:GetAdjustedBuffDuration(caster, base_duration, false)
		caster:AddNewModifier(caster, ability, "modifier_omniro_omni_mace_ghost", {duration = duration})
	elseif caster.active_element == RPC_ELEMENT_WATER then
		local duration = Filters:GetAdjustedBuffDuration(caster, OMNIRO_WATER_SPECIAL_DURATION, false)
		caster:AddNewModifier(caster, ability, "modifier_omniro_omni_mace_water", {duration = duration})
		caster:SetModifierStackCount("modifier_omniro_omni_mace_water", caster, caster.omniro_data[RPC_ELEMENT_WATER]["level"])
		local flat_heal = OMNIRO_MACE_WATER_HEAL[ability:GetLevel()] * caster.omniro_data[RPC_ELEMENT_WATER]["level"]
		Filters:ApplyHeal(caster, caster, flat_heal, true)
		CustomAbilities:QuickAttachParticle("particles/roshpit/omniro/basic_water_heal.vpcf", caster, 1)
	elseif caster.active_element == RPC_ELEMENT_DEMON then
		local duration = Filters:GetAdjustedBuffDuration(caster, OMNIRO_DEMON_SPECIAL_DURATION, false)
		caster:AddNewModifier(caster, ability, "modifier_omniro_omni_mace_demon", {duration = duration})
		caster:SetModifierStackCount("modifier_omniro_omni_mace_demon", caster, caster.omniro_data[RPC_ELEMENT_DEMON]["level"])
	elseif caster.active_element == RPC_ELEMENT_NATURE then
		local base_duration = OMNIRO_MACE_NATURE_ROOT_DURATION * caster.omniro_data[RPC_ELEMENT_NATURE]["level"]
		target:AddNewModifier(caster, ability, "modifier_omniro_omni_mace_nature", {duration = base_duration})
	elseif caster.active_element == RPC_ELEMENT_UNDEAD then
		local base_duration = OMNIRO_MACE_UNDEAD_HP_REGEN_DISABLE_DUR * caster.omniro_data[RPC_ELEMENT_UNDEAD]["level"]
		target:AddNewModifier(caster, ability, "modifier_omniro_omni_mace_undead_debuff", {duration = base_duration})
		local duration = Filters:GetAdjustedBuffDuration(caster, OMNIRO_UNDEAD_SPECIAL_DURATION, false)
		caster:AddNewModifier(caster, ability, "modifier_omniro_omni_mace_undead_buff", {duration = duration})
		caster:SetModifierStackCount("modifier_omniro_omni_mace_undead_buff", caster, caster.omniro_data[RPC_ELEMENT_UNDEAD]["level"])
	elseif caster.active_element == RPC_ELEMENT_DRAGON then
		local duration = Filters:GetAdjustedBuffDuration(caster, OMNIRO_DRAGON_SPECIAL_DURATION, false)
		caster:AddNewModifier(caster, ability, "modifier_omniro_omni_mace_dragon", {duration = duration})
		caster:SetModifierStackCount("modifier_omniro_omni_mace_dragon", caster, caster.omniro_data[RPC_ELEMENT_DRAGON]["level"])
	end
end

function OmniroElementalBonus(element1, element2, caster)
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