require("heroes/axe/red_general_constants")
local Helper = require("heroes/util/helper")

function red_general_ability_base_q_skull_basher(event)
	--print("red_general_ability_base_q_skull_basher")
	local caster = event.caster
	local ability = event.ability
	local abilityLevel = ability:GetLevel()

	ability.jump_level = 0

	Filters:CastSkillArguments(1, caster)

	Helper.initializeAbilityRunes(caster, 'axe', 'q')

	EmitSoundOn("Hero_Axe.BerserkersCall.Item.Shoutmask", caster)
	EmitSoundOn("Hero_Axe.BerserkersCall.Item.Shoutmask", caster)

	local targetPoint = event.target_points[1]
	local distance = WallPhysics:GetDistance2d(targetPoint * Vector(1, 1, 0), caster:GetAbsOrigin() * Vector(1, 1, 0))

	ability.jumpFV = ((targetPoint - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	if distance >= 300 then
		ability:ApplyDataDrivenModifier(caster, caster, "modfier_axe_jumping", {duration = 8})
	else
		red_general_ability_base_q_jump_landing(event)
	end

	local animationTime = math.min(500 / distance, 1)
	StartAnimation(caster, {duration = jumpDuration, activity = ACT_DOTA_FLAIL, rate = animationTime, translate = "forcestaff_friendly"})

	local extraHeight = math.max(GetGroundHeight(targetPoint, caster) - caster:GetAbsOrigin().z, 0)
	ability.jump_velocity = math.max(distance / 30 + 5 + extraHeight / 14, 15)
	if caster:HasModifier("modifier_whirlwind") then
		ability.jump_velocity = ability.jump_velocity + 5
	end
	ability.distance = distance
	ability.targetPoint = targetPoint
	ability.lifting = true
	ability.jumpAnimated = false
	Timers:CreateTimer(0.3, function()
		ability.lifting = false
	end)

	if caster:HasModifier("modifier_axe_glyph_7_1") then
		local newCD = RED_GENERAL_GLYPH_7_1_Q_CD
		ability:EndCooldown()
		ability:StartCooldown(newCD)
	end
end

function red_general_ability_base_q_jump_think(event)
	--print("red_general_ability_base_q_jump_think")
	local caster = event.caster
	local ability = event.ability

	local forwardSpeed = math.max(20, ability.distance / 55 + 24)
	if caster.q_3_level > 0 then
		forwardSpeed = math.max(20, ability.distance / 45 + 9)
	end

	if caster:HasModifier("modifier_axe_rune_q_2_invisible") then
		local modifierDuration = caster:FindModifierByName("modifier_axe_rune_q_2_visible"):GetRemainingTime()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_q_2_visible", {duration = modifierDuration})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_q_2_invisible", {duration = modifierDuration})
	end

	local red_general_ability_base_e_whirlwind = require("heroes/axe/abilities/red_general_ability_base_e_whirlwind")
	red_general_rune_base_e_2_refreshBuff(caster)--TODO

	local jumpToPosition = caster:GetAbsOrigin() + Vector(0, 0, ability.jump_velocity) + (ability.jumpFV * forwardSpeed)
	local afterWallPosition = WallPhysics:WallSearch(caster:GetAbsOrigin(), jumpToPosition, caster)
	if afterWallPosition ~= jumpToPosition then
		jumpToPosition = caster:GetAbsOrigin() + Vector(0, 0, ability.jump_velocity)
	end
	caster:SetOrigin(jumpToPosition)
	caster:SetForwardVector(ability.jumpFV)
	ability.jump_velocity = ability.jump_velocity - 3.3

	if caster:GetAbsOrigin().z < (GetGroundHeight(caster:GetAbsOrigin(), caster) + math.abs(ability.jump_velocity) + 20) and not ability.lifting then
		caster:RemoveModifierByName("modfier_axe_jumping")
		caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster))
	end
end

function red_general_ability_base_q_jump_landing(event)
	--print("red_general_ability_base_q_jump_landing")
	local caster = event.caster
	local ability = event.ability
	local location = caster:GetAbsOrigin()

	caster:RemoveModifierByName("modifier_whirlwind_flying_portion")

	local skullBasherDuration = Filters:GetAdjustedBuffDuration(caster, event.duration, false)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_stun_attack", {duration = skullBasherDuration})

	if not red_general_rune_base_q_3_start(caster, ability) then
		StartAnimation(caster, {duration = 0.4, activity = ACT_DOTA_FORCESTAFF_END, rate = 1})
	end
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
end

function red_general_ability_base_q_attackLand(event, q2_think)
	-- print("red_general_ability_base_q_attackLand")
	if not q2_think then
		red_general_rune_base_q_1_attackLand(event)
	end
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	Helper.initializeAbilityRunes(caster, 'axe', 'q')
	local runesCount = caster.q_2_level

	if runesCount <= 0 then
		return
	end
	local duration = Filters:GetAdjustedBuffDuration(caster, RED_GENERAL_Q2_DURATION, false)

	local stacksGain = 1

	if caster:HasModifier("modifier_axe_glyph_3_2") and (target.mainBoss or target.bossStatus) then
		stacksGain = RED_GENERAL_GLYPH_3_2_STACKS_GAIN
	end

	local maxStacksCount = RED_GENERAL_Q2_MAX_STACKS_COUNT

	if caster:HasModifier("modifier_axe_glyph_7_2") then
		if caster:HasModifier("modifier_stun_attack") then
			stacksGain = stacksGain * RED_GENERAL_GLYPH_7_2_AMP_STACKS_PER_ATTACK
		end
		maxStacksCount = RED_GENERAL_GLYPH_7_2_MAX_STACKS_COUNT
	end

	local visibleModifier = "modifier_axe_rune_q_2_visible"
	local currentStacks = caster:GetModifierStackCount(visibleModifier, caster)
	local newStacks = math.min(currentStacks + stacksGain, maxStacksCount)

	local halfOfStacks = math.floor(maxStacksCount / 2)
	if q2_think then
		local modifier = caster:FindModifierByName("modifier_axe_rune_q_2_visible")
		local modifierDuration = 0
		if modifier then
			modifierDuration = modifier:GetRemainingTime()
		end

		if currentStacks > halfOfStacks and modifierDuration >= 1 then
			return
		end
		if currentStacks <= newStacks or modifierDuration < 1 then
			newStacks = halfOfStacks
		end
	end

	ability:ApplyDataDrivenModifier(caster, caster, visibleModifier, {duration = duration})
	caster:SetModifierStackCount(visibleModifier, caster, newStacks)
	local invisibleModifier = "modifier_axe_rune_q_2_invisible"
	ability:ApplyDataDrivenModifier(caster, caster, invisibleModifier, {duration = duration})
	caster:SetModifierStackCount(invisibleModifier, caster, newStacks * runesCount)
end

function red_general_rune_base_q_1_attackLand(event)
	-- print("red_general_rune_base_q_1_attackLand")
	local caster = event.attacker
	local ability = event.ability
	local hero = caster
	local abilityLevel = ability:GetLevel()

	local targetUnit = event.target
	local position = targetUnit:GetAbsOrigin()
	local stun_duration = event.duration
	local aoe_damage = event.aoe_damage
	aoe_damage = aoe_damage + red_general_rune_base_q_1_getAdditionalDamage(caster);
	if caster:HasModifier("modifier_axe_glyph_5_1") then
		aoe_damage = aoe_damage * RED_GENERAL_GLYPH_5_1_Q_DAMAGE_AMP
		stun_duration = RED_GENERAL_GLYPH_5_1_Q_STUN
	end
	local base_radius = event.base_radius

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), targetUnit:GetAbsOrigin(), nil, base_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	local dealDamage = not caster:HasModifier("modifier_axe_glyph_7_1")
	for i = 1, #enemies do
		Filters:ApplyStun(caster, stun_duration, enemies[i])
		if dealDamage then
			Filters:TakeArgumentsAndApplyDamage(enemies[i], caster, aoe_damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_Q, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
		end

		red_general_rune_base_q_4_applyDebuff(caster, enemies[i], ability)
	end
	EmitSoundOn("Hero_ElderTitan.EchoStomp", targetUnit)
end

function red_general_rune_base_q_1_getAdditionalDamage(caster)
	-- print("red_general_rune_base_q_1_getAdditionalDamage")
	if caster.q_1_level > 0 then
		return caster.q_1_level * OverflowProtectedGetAverageTrueAttackDamage(caster) * RED_GENERAL_Q1_ATTACK_DAMAGE_PROCENT / 100
	else
		return 0
	end
end

function red_general_rune_base_q_2_think(event)
	--print("red_general_rune_base_q_2_think")
	if event.caster:HasModifier("modifier_axe_glyph_7_2") then
		red_general_ability_base_q_attackLand(event, true)
	end
end

function red_general_rune_base_q_3_start(caster, ability)
	--print("red_general_rune_base_q_3_start")

	if caster.q_3_level <= 0 then
		return false
	end

	local damageAmp = caster.q_3_level * RED_GENERAL_Q3_AMPLIFY_PERCENT / 100
	if caster:HasAbility("red_general_ability_base_r_sunder") then
		print("HasAbility red_general_ability_base_r_sunder")
		local sunderAbility = caster:FindAbilityByName("red_general_ability_base_r_sunder")
		local damage = sunderAbility:GetSpecialValueFor("main_damage") / 100 * caster:GetHealth() * damageAmp
		local procsCount = 1
		local delay = Filters:GetDelayWithCastSpeed(caster, 0.35)
		if caster:HasModifier("modifier_axe_glyph_6_1") then
			procsCount = RED_GENERAL_GLYPH_6_1_DUNKS_COUNT
		end

		local red_general_ability_base_r_sunder = require("heroes/axe/abilities/red_general_ability_base_r_sunder")

		for i = 0, procsCount - 1, 1 do
			Timers:CreateTimer(i * delay, function()
				red_general_ability_base_r_sunder_createDunk(caster, damage)
			end)
		end
	elseif caster:HasAbility("red_general_ability_arcana1_r_tectonic_sunder") then
		local eventTable = {}
		eventTable.caster = caster
		eventTable.ability = caster:FindAbilityByName("red_general_ability_arcana1_r_tectonic_sunder")
		eventTable.target_points = {}
		eventTable.forks = 1
		eventTable.amp = damageAmp
		eventTable.attack_power_mult_percent = eventTable.ability:GetLevelSpecialValueFor("attack_power_mult_percent", eventTable.ability:GetLevel() - 1)
		eventTable.stun_duration = eventTable.ability:GetLevelSpecialValueFor("stun_duration", eventTable.ability:GetLevel() - 1)
		eventTable.target_points[1] = caster:GetAbsOrigin() + ability.jumpFV * 200

		Timers:CreateTimer(0.1, function()
			caster:SetForwardVector(ability.jumpFV)
		end)
		local red_general_ability_arcana1_r_tectonic_sunder = require("heroes/axe/abilities/red_general_ability_arcana1_r_tectonic_sunder")
		red_general_ability_arcana1_r_startChannel(eventTable)
	else
		return false
	end
	return true
end

function red_general_rune_base_q_4_applyDebuff(caster, target, ability)
	-- print("red_general_rune_base_q_4_applyDebuff")
	if caster.q_4_level > 0 then
		local runesCount = caster.q_4_level
		Helper.updateStackModifier(target, caster, ability, 'axe_rune_q_4', RED_GENERAL_Q4_DURATION, RED_GENERAL_Q4_MAX_STACKS_COUNT, runesCount)
		if caster:HasModifier("modifier_axe_glyph_2_2") then
			local glyphAbility = caster:FindModifierByName("modifier_axe_glyph_2_2"):GetAbility()
			Helper.updateStackModifier(target, caster, glyphAbility, 'axe_glyph_2_2', RED_GENERAL_Q4_DURATION, RED_GENERAL_Q4_MAX_STACKS_COUNT, nil)
		end
	end
end
