function swingEarth(event)
	local caster = event.caster
	local ability = event.ability
	local swingType = event.type
	local radius = 240
	local damage = event.damage
	damage = damage + rune_w_2(caster) * 0.025 * OverflowProtectedGetAverageTrueAttackDamage(caster)
	local damageDelay = 0.12
	local animationRate = 1.5
	local animationDuration = 0.36
	local swingCooldown = 0.4
	local swingDuration = 0.3
	local q_4_level = caster:GetRuneValue("q", 4)
	if q_4_level > 0 then
		damageDelay = damageDelay - math.min(q_4_level * 0.005, 0.06)
		animationRate = animationRate + math.min(q_4_level * 0.12, 0.6)
		animationDuration = animationDuration - math.min(q_4_level * 0.006, 0.14)
		swingCooldown = swingCooldown - math.min(q_4_level * 0.01, 0.2)
		swingDuration = swingDuration - math.min(q_4_level * 0.008, 0.2)
	end
	if swingType == "earth" then
		hackEarth(caster, radius, damage, damageDelay, 0.4, event.stun_duration)
		swapSkillsToIce(caster, ability, swingCooldown)
		caster:RemoveModifierByName("modifier_elemental_axe_earth")
		caster.warlordElement = "ice"
	elseif swingType == "ice" then

		hackIce(caster, radius, damage, damageDelay, ability)
		swapSkillsToFire(caster, ability, swingCooldown)
		caster:RemoveModifierByName("modifier_elemental_axe_ice")
		caster.warlordElement = "fire"
		-- if caster:HasModifier("modifier_warlord_glyph_2_1") then
		-- local fireAxeAbility = caster:FindAbilityByName("elemental_axe_fire")
		-- fireAxeAbility:ApplyDataDrivenModifier(caster, caster, "modifier_warlord_glyph_2_1_fire_axe_effect", {})
		-- end
	elseif swingType == "fire" then
		hackFire(caster, radius, damage, damageDelay, event.fire_damage, event.fire_radius, ability)
		swapSkillsToEarth(caster, ability, swingCooldown)
		caster:RemoveModifierByName("modifier_elemental_axe_fire")
		caster.warlordElement = "earth"
		-- caster:RemoveModifierByName("modifier_warlord_glyph_2_1_fire_axe_effect")
	end
	if caster:HasModifier("modifier_warlord_glyph_6_1") then
		earthAxeAbility = caster:FindAbilityByName("elemental_axe_earth")
		local glyph_duration = Filters:GetAdjustedBuffDuration(caster, 0.8, false)
		earthAxeAbility:ApplyDataDrivenModifier(caster, caster, "modifier_warlord_glyph_6_1_effect", {duration = glyph_duration})
	end
	StartAnimation(caster, {duration = animationDuration, activity = ACT_DOTA_CAST_ABILITY_1, rate = animationRate})

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_swinging", {duration = swingDuration})
	Filters:CastSkillArguments(1, caster)
end

function rune_w_2(caster)
	local runeUnit = caster.runeUnit2
	local runeAbility = runeUnit:FindAbilityByName("warlord_rune_w_2")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "w_2")
	local totalLevel = abilityLevel + bonusLevel
	return totalLevel
end

function swapSkillsToIce(caster, swingAbility, swingCooldown)
	--Q
	if caster:HasModifier("modifier_warlord_arcana2") then
		local earth_ability = caster:FindAbilityByName("warlord_cataclysm_shaker")
		local ice_ability = caster:FindAbilityByName("warlord_frost_scathe")
		if not ice_ability then
			ice_ability = caster:AddAbility("warlord_frost_scathe")
		end
		ice_ability:SetLevel(earth_ability:GetLevel())
		caster:SwapAbilities("warlord_cataclysm_shaker", "warlord_frost_scathe", false, true)
	else
		local stoneForm = caster:FindAbilityByName("warlord_stone_form")
		local iceShield = caster:FindAbilityByName("warlord_ice_shell")
		if not iceShield then
			iceShield = caster:AddAbility("warlord_ice_shell")
		end
		iceShield:SetLevel(stoneForm:GetLevel())
		caster:SwapAbilities("warlord_stone_form", "warlord_ice_shell", false, true)
	end

	--JUMP
	local iceJump = caster:FindAbilityByName("warlord_jump_ice")
	local jumpAbility = caster:FindAbilityByName("warlord_jump_earth")
	if not iceJump then
		iceJump = caster:AddAbility("warlord_jump_ice")
	end
	iceJump:SetLevel(jumpAbility:GetLevel())
	caster:SwapAbilities("warlord_jump_earth", "warlord_jump_ice", false, true)
	--THROW
	local iceThrow = caster:FindAbilityByName("axe_throw_ice")
	local throwAbility = caster:FindAbilityByName("axe_throw_earth")
	if not iceThrow then
		iceThrow = caster:AddAbility("axe_throw_ice")
	end
	iceThrow:SetLevel(throwAbility:GetLevel())
	caster:SwapAbilities("axe_throw_earth", "axe_throw_ice", false, true)
	iceThrow:ApplyDataDrivenModifier(caster, caster, "modifier_elemental_axe_ice", {})
	caster:RemoveModifierByName("modifier_warlord_rune_w_3_effect")
	caster:RemoveModifierByName("modifier_warlord_rune_w_1_effect")
end

function swapSkillsToFire(caster, swingAbility, swingCooldown)
	local manaPercentage = caster:GetMana() / caster:GetMaxMana()

	if caster:HasModifier("modifier_warlord_arcana2") then
		local ice_ability = caster:FindAbilityByName("warlord_frost_scathe")
		local fire_ability = caster:FindAbilityByName("warlord_flame_wreck")
		if not fire_ability then
			fire_ability = caster:AddAbility("warlord_flame_wreck")
		end
		fire_ability:SetLevel(ice_ability:GetLevel())
		caster:SwapAbilities("warlord_frost_scathe", "warlord_flame_wreck", false, true)
	else
		local iceShield = caster:FindAbilityByName("warlord_ice_shell")
		local flameRush = caster:FindAbilityByName("warlord_flame_rush")
		if not flameRush then
			flameRush = caster:AddAbility("warlord_flame_rush")
		end
		flameRush:SetLevel(iceShield:GetLevel())
		caster:SwapAbilities("warlord_ice_shell", "warlord_flame_rush", false, true)
	end

	--JUMP
	local fireJump = caster:FindAbilityByName("warlord_jump_fire")
	local jumpAbility = caster:FindAbilityByName("warlord_jump_ice")
	if not fireJump then
		fireJump = caster:AddAbility("warlord_jump_fire")
	end
	fireJump:SetLevel(jumpAbility:GetLevel())
	caster:SwapAbilities("warlord_jump_ice", "warlord_jump_fire", false, true)
	--THROW
	local fireThrow = caster:FindAbilityByName("axe_throw_fire")
	local throwAbility = caster:FindAbilityByName("axe_throw_ice")
	if not fireThrow then
		fireThrow = caster:AddAbility("axe_throw_fire")
	end
	fireThrow:SetLevel(throwAbility:GetLevel())
	caster:SwapAbilities("axe_throw_ice", "axe_throw_fire", false, true)
	fireThrow:ApplyDataDrivenModifier(caster, caster, "modifier_elemental_axe_fire", {})

	caster:RemoveModifierByName("modifier_warlord_rune_w_2")
	caster:RemoveModifierByName("modifier_warlord_rune_w_1_effect")
	Timers:CreateTimer(0.05, function()
		caster:SetMana(math.floor(caster:GetMaxMana() * manaPercentage))
	end)
end

function swapSkillsToEarth(caster, swingAbility, swingCooldown)
	if caster:HasModifier("modifier_warlord_arcana2") then
		local fire_ability = caster:FindAbilityByName("warlord_flame_wreck")
		local earth_ability = caster:FindAbilityByName("warlord_cataclysm_shaker")
		if not earth_ability then
			earth_ability = caster:AddAbility("warlord_cataclysm_shaker")
		end
		earth_ability:SetLevel(fire_ability:GetLevel())
		caster:SwapAbilities("warlord_flame_wreck", "warlord_cataclysm_shaker", false, true)
	else
		local flameRush = caster:FindAbilityByName("warlord_flame_rush")
		local stoneForm = caster:FindAbilityByName("warlord_stone_form")
		stoneForm:SetLevel(flameRush:GetLevel())
		caster:SwapAbilities("warlord_flame_rush", "warlord_stone_form", false, true)
	end

	--JUMP
	local earthJump = caster:FindAbilityByName("warlord_jump_earth")
	local jumpAbility = caster:FindAbilityByName("warlord_jump_fire")
	earthJump:SetLevel(jumpAbility:GetLevel())
	caster:SwapAbilities("warlord_jump_fire", "warlord_jump_earth", false, true)
	--THROW
	local earthThrow = caster:FindAbilityByName("axe_throw_earth")
	local throwAbility = caster:FindAbilityByName("axe_throw_fire")
	earthThrow:SetLevel(throwAbility:GetLevel())
	caster:SwapAbilities("axe_throw_fire", "axe_throw_earth", false, true)
	earthThrow:ApplyDataDrivenModifier(caster, caster, "modifier_elemental_axe_earth", {})
	-- local w_1_level = Runes:GetTotalRuneLevel(caster, 1, "w_1", "warlord")
	-- if w_1_level > 0 then
	-- earthThrow:ApplyDataDrivenModifier(caster, caster,  "modifier_warlord_rune_w_1_effect", {})
	-- caster:SetModifierStackCount("modifier_warlord_rune_w_1_effect", caster, w_1_level)
	-- end
	caster:RemoveModifierByName("modifier_warlord_rune_w_2")
	caster:RemoveModifierByName("modifier_warlord_rune_w_3_effect")
end

function hackEarth(caster, radius, damage, delay, knockback_duration, stun_duration)
	Timers:CreateTimer(delay, function()
		local casterOrigin = caster:GetAbsOrigin()
		local position = casterOrigin + caster:GetForwardVector() * (radius - 60)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		local modifierKnockback =
		{
			center_x = casterOrigin.x,
			center_y = casterOrigin.y,
			center_z = casterOrigin.z,
			duration = knockback_duration,
			knockback_duration = knockback_duration,
			knockback_distance = 120,
			knockback_height = 20,
		}

		if #enemies > 0 then
			EmitSoundOnLocationWithCaster(casterOrigin, "Visage_Familar.StoneForm.Cast", caster)
			EmitSoundOn("Hero_Beastmaster.Attack", caster)
			if #enemies > 6 then
				EmitSoundOn("Hero_Beastmaster.Attack", caster)
			end
			if #enemies > 10 then
				EmitSoundOn("Hero_Beastmaster.Attack", caster)
			end
			for _, enemy in pairs(enemies) do
				Filters:ApplyStun(caster, stun_duration, enemy)
				enemy:AddNewModifier(caster, nil, "modifier_knockback", modifierKnockback)
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, 1)
			end
		end
	end)
end

function hackIce(caster, radius, damage, delay, ability)
	Timers:CreateTimer(delay, function()
		local casterOrigin = caster:GetAbsOrigin()
		local position = casterOrigin + caster:GetForwardVector() * (radius - 60)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)

		if #enemies > 0 then
			EmitSoundOnLocationWithCaster(casterOrigin, "Hero_Tusk.IceShards.Cast", caster)
			EmitSoundOn("Hero_Beastmaster.Attack", caster)
			local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
			local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, position)
			ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 2, radius * 2))
			Timers:CreateTimer(2.5, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
			if #enemies > 6 then
				EmitSoundOn("Hero_Beastmaster.Attack", caster)
			end
			if #enemies > 10 then
				EmitSoundOn("Hero_Beastmaster.Attack", caster)
			end
			local iceSlowDuration = Filters:GetAdjustedBuffDuration(caster, 1.2, false)
			for _, enemy in pairs(enemies) do
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_elemental_axe_ice_slow", {duration = iceSlowDuration})
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, 1)
			end
		end
	end)
end

function hackFire(caster, radius, damage, delay, fire_damage, fire_radius, ability)
	Timers:CreateTimer(delay, function()
		local casterOrigin = caster:GetAbsOrigin()
		local position = casterOrigin + caster:GetForwardVector() * (radius - 60)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			EmitSoundOn("Hero_Beastmaster.Attack", caster)
			if #enemies > 6 then
				EmitSoundOn("Hero_Beastmaster.Attack", caster)
			end
			for _, enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, 1)
			end
		end
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, fire_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			EmitSoundOnLocationWithCaster(casterOrigin, "Hero_Jakiro.LiquidFire", caster)
			for _, enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, fire_damage, DAMAGE_TYPE_MAGICAL, 1)
				enemy:RemoveModifierByName("modifier_axe_fire_burn")
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_axe_fire_burn", {duration = 0.6})
			end
		end
	end)
end

function elementalThink(event)
	local caster = event.caster
	local element = event.type
	if not caster.warlordElement then
		caster.warlordElement = "earth"
	end
	if caster.warlordElement == "earth" and element == "earth" then
		local runeUnit = caster.runeUnit
		local runeAbility = runeUnit:FindAbilityByName("warlord_rune_q_1")
		local abilityLevel = runeAbility:GetLevel()
		local bonusLevel = Runes:GetTotalBonus(runeUnit, "q_1")
		local totalLevel = abilityLevel + bonusLevel
		if totalLevel > 0 then
			runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_earth_buff", {})
			caster:SetModifierStackCount("modifier_earth_buff", runeAbility, totalLevel)
		end
		caster:RemoveModifierByName("modifier_ice_buff")
		caster:RemoveModifierByName("modifier_fire_buff")
	elseif caster.warlordElement == "ice" and element == "ice" then
		local runeUnit = caster.runeUnit2
		local runeAbility = runeUnit:FindAbilityByName("warlord_rune_q_2")
		local abilityLevel = runeAbility:GetLevel()
		local bonusLevel = Runes:GetTotalBonus(runeUnit, "q_2")
		local totalLevel = abilityLevel + bonusLevel
		if totalLevel > 0 then
			runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_ice_buff", {})
			caster:SetModifierStackCount("modifier_ice_buff", runeAbility, totalLevel)
		end
		caster:RemoveModifierByName("modifier_earth_buff")
		caster:RemoveModifierByName("modifier_fire_buff")
	elseif caster.warlordElement == "fire" and element == "fire" then
		local runeUnit = caster.runeUnit3
		local runeAbility = runeUnit:FindAbilityByName("warlord_rune_q_3")
		local abilityLevel = runeAbility:GetLevel()
		local bonusLevel = Runes:GetTotalBonus(runeUnit, "q_3")
		local totalLevel = abilityLevel + bonusLevel
		if totalLevel > 0 then
			runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_fire_buff", {})
			caster:SetModifierStackCount("modifier_fire_buff", runeAbility, totalLevel)
		end
		caster:RemoveModifierByName("modifier_earth_buff")
		caster:RemoveModifierByName("modifier_ice_buff")
	end
end

function elemental_axe_attack_land(event)
	local element = event.element
	local attacker = event.attacker
	local ability = event.ability
	local charges = event.charges
	local caster = attacker
	if caster:HasModifier("modifier_warlord_immortal_weapon_1") then
		charges = charges * WARLORD_IMMORTAL_WEAPON_1_STACK_MULT
	end
	local maxCharges = 20
	if caster:HasModifier("modifier_warlord_glyph_6_1") then
		maxCharges = maxCharges + WARLORD_GLYPH_6_1_ADDITIONAL_CHARGES
	end
	if caster:HasAbility("enhchant_tomahawk") then
		local additionalMaxCharges = caster:GetRuneValue("r", 4)
		maxCharges = maxCharges + additionalMaxCharges
	end
	if element == "earth" then
		local a_c_level = Runes:GetTotalRuneLevel(caster, 1, "e_1", "warlord")
		if a_c_level > 0 then
			maxCharges = maxCharges + a_c_level
		end
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_warlord_earth_charge", {})
		local newStacks = math.min(caster:GetModifierStackCount("modifier_warlord_earth_charge", caster) + charges, maxCharges)
		caster:SetModifierStackCount("modifier_warlord_earth_charge", caster, newStacks)
		if a_c_level > 0 then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_warlord_rune_e_1_effect", {})
			caster:SetModifierStackCount("modifier_warlord_rune_e_1_effect", caster, newStacks * a_c_level * 5)
		end
	elseif element == "ice" then

		ability:ApplyDataDrivenModifier(caster, caster, "modifier_warlord_ice_charge", {})
		local newStacks = math.min(caster:GetModifierStackCount("modifier_warlord_ice_charge", caster) + charges, maxCharges)
		caster:SetModifierStackCount("modifier_warlord_ice_charge", caster, newStacks)

	elseif element == "fire" then
		if caster:HasAbility("enhchant_tomahawk") then
			local additionalMaxCharges = caster:GetRuneValue("r", 3)
			maxCharges = maxCharges + additionalMaxCharges
		end
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_warlord_fire_charge", {})
		local newStacks = math.min(caster:GetModifierStackCount("modifier_warlord_fire_charge", caster) + charges, maxCharges)
		caster:SetModifierStackCount("modifier_warlord_fire_charge", caster, newStacks)
		if caster:HasAbility("elemental_overload_2") then
			local c_d_level = Runes:GetTotalRuneLevel(caster, 3, "r_3", "warlord")
			if c_d_level > 0 then
				local c_d_stacks = math.ceil(newStacks * 1.0 * c_d_level)
				local runeAbility = caster.runeUnit3:FindAbilityByName("warlord_rune_r_3")
				runeAbility:ApplyDataDrivenModifier(caster.runeUnit3, caster, "modifier_warlord_rune_r_3_effect", {})
				caster:SetModifierStackCount("modifier_warlord_rune_r_3_effect", caster.runeUnit3, c_d_stacks)
			end
		elseif caster:HasAbility("enhchant_tomahawk") then
			local d_d_level = caster:GetRuneValue("r", 4)
			if d_d_level > 0 then
				local d_d_stacks = math.ceil(newStacks * 1.0 * d_d_level)
				local tomahawk = caster:FindAbilityByName("enhchant_tomahawk")
				tomahawk:ApplyDataDrivenModifier(caster, caster, "modifier_warlord_rune_r_4_effect", {})
				caster:SetModifierStackCount("modifier_warlord_rune_r_4_effect", caster, d_d_stacks)
			end
		end
	end
	if caster:HasModifier("modifier_warlord_glyph_2_1") then
		if not event.bNoLoop then
			local eventTable = {}
			eventTable.target = caster
			warlord_immo_3_think(eventTable)
			-- if caster:HasModifier("modifier_warlord_ice_shell") then
			-- local gain = 4
			-- if caster:HasModifier("modifier_warlord_immortal_weapon_1") then
			-- gain = gain*2
			-- end
			-- ability:ApplyDataDrivenModifier(caster, caster, "modifier_warlord_ice_charge", {})
			-- local newStacks = math.min(caster:GetModifierStackCount("modifier_warlord_ice_charge", caster) + gain, maxCharges)
			-- caster:SetModifierStackCount("modifier_warlord_ice_charge", caster, newStacks)
			-- end
		end
	end
end

function warlord_glyph_5_a(event)
	local eventTable = {}
	eventTable.element = "fire"
	eventTable.attacker = event.unit
	if not event.unit:HasAbility("axe_throw_fire") then
		local newAbility = event.unit:AddAbility("axe_throw_fire")
		newAbility:SetAbilityIndex(1)
		newAbility:SetHidden(true)
	end
	eventTable.ability = event.unit:FindAbilityByName("axe_throw_fire")
	eventTable.charges = WARLORD_GLYPH_5_A_FIRE_CHARGES_PER_DMG_TAKEN
	elemental_axe_attack_land(eventTable)
end

function warlord_immo_3_think(event)
	local caster = event.target
	local elementTable = {"earth", "ice", "fire"}
	if not caster:HasAbility("axe_throw_fire") then
		local newAbility = caster:AddAbility("axe_throw_fire")
		newAbility:SetAbilityIndex(1)
		newAbility:SetHidden(true)
	end
	if not caster:HasAbility("axe_throw_ice") then
		local newAbility = caster:AddAbility("axe_throw_ice")
		newAbility:SetAbilityIndex(1)
		newAbility:SetHidden(true)
	end
	for i = 1, #elementTable, 1 do
		local eventTable = {}
		eventTable.caster = caster
		eventTable.attacker = caster
		eventTable.element = elementTable[i]
		eventTable.charges = WARLORD_IMMORTAL_WEAPON_3_CHARGES_PER_TICK
		eventTable.ability = caster:FindAbilityByName("axe_throw_"..elementTable[i])
		eventTable.bNoLoop = true
		elemental_axe_attack_land(eventTable)
	end
end
