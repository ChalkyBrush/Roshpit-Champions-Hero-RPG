require("heroes/axe/red_general_constants")
local Helper = require("heroes/util/helper")
local WAmplify = require('heroes/axe/glyphs/t52_w_amplify')
local ImmortalWeapon3 = require('heroes/axe/weapons/immortal_weapon_3')

function red_general_ability_arcana1_r_startChannel(event)
	local caster = event.caster
	local ability = event.ability
	ability.isInterrupted = false
	Helper.initializeAbilityRunes(caster, 'axe', 'r')
	ImmortalWeapon3.amplifyShieldsCount(caster)

	local stun_duration = event.stun_duration
	local amp = event.amp
	local forks = event.forks
	ability.amp = amp

	local point = event.target_points[1]
	local direction = ((point - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	ability.attack_power_mult_percent = event.attack_power_mult_percent

	Timers:CreateTimer(0.1, function()
	local startPoint = caster:GetAbsOrigin() + direction * 200
	local max = 0
	local min = 0

	local divisor = 9
	local tremorsCount = red_general_rune_arcana1_r_4_getTremorsCount(caster)
	local additionalRadius = red_general_rune_arcana1_r_4_getAdditionalRadius(caster)
	if forks == 1 then
		tremorsCount = math.ceil(tremorsCount / 2)
		additionalRadius = math.ceil(additionalRadius / 2)
	end
	local damageRadius = RED_GENERAL_ARCANA1_R_RADIUS + additionalRadius
	min = -math.ceil((tremorsCount - 1) / 2)
	max = tremorsCount + min - 1

	ability.pfx = {}

	local damage = 0

	StartAnimation(caster, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_prevent_turning_invisible", {duration = 0.15})
	Timers:CreateTimer(0.15, function()
		local direction = caster:GetForwardVector()
		local startPoint = caster:GetAbsOrigin() + direction * 200
		local pfx2 = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_fire_base.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx2, 0, startPoint)
		Timers:CreateTimer(1.5, function()
			ParticleManager:DestroyParticle(pfx2, false)
			ParticleManager:ReleaseParticleIndex(pfx2)			end)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), startPoint, nil, 280, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		if #enemies > 0 then
			for _, enemy in pairs(enemies) do
				red_general_rune_arcana1_r_3_applyDebuff(caster, enemy, ability)
				red_general_rune_arcana1_r_2_applyBuff(caster, ability)
				damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * event.attack_power_mult_percent / 100
				damage = damage * amp

				if caster:HasModifier("modifier_axe_glyph_5_a") then
					damage = damage * (1 + RED_GENERAL_GLYPH_5_A_AMPLIFY_PERCENT / 100)
				end
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, BASE_ABILITY_R, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
				Filters:ApplyStun(caster, stun_duration, enemy)
			end
		end
		EmitSoundOnLocationWithCaster(startPoint, "RedGeneral.ArcanaSunder.Start", caster)

		local procs = 1
		if caster:HasModifier("modifier_axe_glyph_6_1") then
			procs = RED_GENERAL_GLYPH_6_1_DUNKS_COUNT
		end
		-- if forks == 1 then
		--     Timers:CreateTimer(1.8 , function()
		--         EarthShatter.applyBuff(caster)
		--     end)
		-- end

		for procNumber = 0, procs - 1, 1 do
			for i = min, max, 1 do
				local forkDirection = WallPhysics:rotateVector(direction, math.pi * i / divisor)
				local endPoint = startPoint + forkDirection * damageRadius
				local visualEndPoint = startPoint + 1.69 * forkDirection * damageRadius
				Timers:CreateTimer(procNumber * 0.5 + 0.15, function()
					if ability.isInterrupted then
						return
					end

					if procNumber == 0 then
						StartSoundEvent("RedGeneral.ArcanaSunder.Moving", caster)
					end
					local particleName = "particles/roshpit/axe/arcana_sunder.vpcf"
					local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControl(pfx, 0, startPoint - direction * 50 + forkDirection * 50)
					ParticleManager:SetParticleControl(pfx, 1, visualEndPoint)
					ParticleManager:SetParticleControl(pfx, 3, Vector(100, 2, 100)) -- y COMPONENT = duration
					-- ParticleManager:SetParticleControl(pfx, 1, point)

					if forks ~= 1 then
						table.insert(ability.pfx,
							{
								particle = pfx,
								startPoint = startPoint,
								endPoint = endPoint,
								procNumber = procNumber
							})
						else
							Timers:CreateTimer(1.9, function()
								red_general_ability_arcana1_r_dealDamage(caster, ability, damage, stun_duration, startPoint, endPoint)
								Timers:CreateTimer(3, function()
									ParticleManager:DestroyParticle(pfx, true)
									ParticleManager:ReleaseParticleIndex(pfx)
								end)
							end)
						end
					end)
				end
			end

			-- if forks == 1 then
			--     Timers:CreateTimer(procs*0.5 + 2.2 , function()
			--         EarthShatter.removeBuff(caster)
			--     end)
			-- end
		end)
	end)
end

function red_general_ability_arcana1_r_successfullCast(event)
	local caster = event.caster
	local ability = event.ability
	local damage = ability.damage
	local stun_duration = event.stun_duration

	-- EarthShatter.applyBuff(caster)
	Filters:CastSkillArguments(4, caster)
	WAmplify.applyBuff(caster)

	local lastProcNumber = 0
	local pfx = ability.pfx
	while #pfx > 0 do
		local currentParticle = pfx[1]
		lastProcNumber = currentParticle.procNumber
		Timers:CreateTimer(currentParticle.procNumber * 0.5 + 0.15, function()
			red_general_ability_arcana1_r_dealDamage(caster, ability, 0, stun_duration, currentParticle.startPoint, currentParticle.endPoint)
			ParticleManager:DestroyParticle(currentParticle.particle, false)
			ParticleManager:ReleaseParticleIndex(currentParticle.particle)
		end)
		table.remove(pfx, 1)
	end

	Timers:CreateTimer(lastProcNumber * 0.5 + 0.4, function()
		StartSoundEvent("RedGeneral.ArcanaSunder.Moving", caster)
		-- EarthShatter.removeBuff(caster)
	end)
end

function red_general_ability_arcana1_r_interruptCast(event)
	local caster = event.caster
	Timers:CreateTimer(0.2, function()
		StopSoundEvent("RedGeneral.ArcanaSunder.Moving", caster)
		local ability = event.ability
		ability.isInterrupted = true
		local pfx = ability.pfx

		while #pfx > 0 do
			ParticleManager:DestroyParticle(pfx[1].particle, true)
			ParticleManager:ReleaseParticleIndex(pfx[1].particle)
			table.remove(pfx, 1)
		end
	end)
end

function red_general_ability_arcana1_r_take_damage(event)
	local caster = event.caster
	local damage = event.damage
	local ability = event.ability
	--print(damage)
	local b_d_level = caster:GetRuneValue("r", 2)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_arcana_b_d_attack_power", {duration = 4})
	local currentStacks = caster:GetModifierStackCount("modifier_axe_arcana_b_d_attack_power", caster)
	local additionalStacks = damage * 0.05 * b_d_level
	local newStacks = math.min(currentStacks + additionalStacks, 50000 * b_d_level)
	caster:SetModifierStackCount("modifier_axe_arcana_b_d_attack_power", caster, newStacks)
end

function red_general_ability_arcana1_r_dealDamage(caster, ability, damage, stun_duration, startPoint, endPoint)
	ability.particle = nil
	for i = 1, 3, 1 do
		EmitSoundOnLocationWithCaster(startPoint, "RedGeneral.ArcanaSunder.Explode"..i, caster)
	end

	local enemies = FindUnitsInLine(caster:GetTeamNumber(), startPoint, endPoint, nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0)
	for _, enemy in pairs(enemies) do
		red_general_rune_arcana1_r_2_applyBuff(caster, ability)
		red_general_rune_arcana1_r_3_applyDebuff(caster, enemy, ability)
		damage = OverflowProtectedGetAverageTrueAttackDamage(caster) * ability.attack_power_mult_percent / 100
		damage = damage * ability.amp

		if caster:HasModifier("modifier_axe_glyph_5_a") then
			damage = damage * (1 + RED_GENERAL_GLYPH_5_A_AMPLIFY_PERCENT / 100)
		end
		Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_R, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
		Filters:ApplyStun(caster, stun_duration, enemy)
		--ability:ApplyDataDrivenModifier(caster, targetUnit, "modifier_stun_explosion", {})
	end
end

function red_general_rune_arcana1_r_2_applyBuff(caster, ability)
	local runesCount = caster:GetRuneValue("r", 2)

	if runesCount <= 0 then
		return
	end

	local duration = Filters:GetAdjustedBuffDuration(caster, RED_GENERAL_ARCANA1_R2_DURATION, false)

	-- Helper.updateStackModifier(caster, caster, ability, 'axe_rune_r_2_arcana1', duration, RED_GENERAL_ARCANA1_R2_MAX_STACKS_COUNT, runesCount)
	-- modifier_axe_rune_r_2_arcana1_invisible
	local visibleModifierStacks = 1
	local modifier = caster:FindModifierByName("modifier_axe_rune_r_2_arcana1_visible")
	if modifier then
		visibleModifierStacks = math.min(modifier:GetStackCount() + 1, 5)
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_r_2_arcana1_visible", {duration = duration})
	caster:SetModifierStackCount("modifier_axe_rune_r_2_arcana1_visible", caster, visibleModifierStacks)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_r_2_arcana1_invisible", {duration = duration})
	caster:SetModifierStackCount("modifier_axe_rune_r_2_arcana1_invisible", caster, visibleModifierStacks * runesCount * RED_GENERAL_ARCANA1_R2_BONUS_DAMAGE)
end

function red_general_rune_arcana1_r_3_applyDebuff(caster, target, ability)
	local runesCount = caster:GetRuneValue("r", 3)
	if runesCount <= 0 then
		return
	end
	local duration = Filters:GetAdjustedBuffDuration(caster, RED_GENERAL_ARCANA1_R3_DURATION, false)
	local new_stacks = runesCount * RED_GENERAL_ARCANA1_R3_RESIST_REDUCE_PERCENT
	ability:ApplyDataDrivenModifier(caster, target, "modifier_axe_rune_r_3_arcana1_visible", {duration = duration})
	target:SetModifierStackCount("modifier_axe_rune_r_3_arcana1_visible", caster, new_stacks)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_axe_rune_r_3_arcana1_invisible", {duration = duration})
	target:SetModifierStackCount("modifier_axe_rune_r_3_arcana1_invisible", caster, new_stacks)
	target:CalculateAndSaveRoshpitAttributes()
end

function red_general_rune_arcana1_r_4_getTremorsCount(caster)
    local runesCount = caster:GetRuneValue("r", 4)
    if runesCount <= 0 then
        return 1
    else
        return 1 + Runes:Procs(runesCount, RED_GENERAL_ARCANA1_R4_ADD_TREMOR_CHANCE, 1)
    end
end

function red_general_rune_arcana1_r_4_getAdditionalRadius(caster)
    local runesCount = caster:GetRuneValue("r", 4)
    if runesCount <= 0 then
        return 0
    else
        return runesCount * RED_GENERAL_ARCANA1_R4_INCREASE_RADIUS
    end
end
