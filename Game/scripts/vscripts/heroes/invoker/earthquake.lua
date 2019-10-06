require('heroes/invoker/conjuror_runes')

function earthquake_cast(event)
	local caster = event.caster
	local ability = event.ability
	local stun_duration = event.stun_duration
	local radius = event.radius
	local point = event.target_points[1]
	local damage = event.damage

	if caster:HasModifier("modifier_conjuror_glyph_5_1") then
		radius = radius + CONJUROR_GLYPH_5_1_Q_BONUS_RADIUS
	end
	ability.q_3_level = get_q_3_level(caster, ability)
	fireQuake(point, caster, radius, stun_duration, damage, true, ability, 1)
	if caster.earthAspect then
		fireQuake(caster.earthAspect:GetAbsOrigin(), caster, radius, stun_duration, damage, false, ability, 1)
	end
	local duration = 1.7
	if caster:HasModifier("modifier_conjuror_glyph_5_1") then
		duration = duration + CONJUROR_GLYPH_5_1_FREE_CAST_DURATION_INCREASE
	end
	duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	if not caster:HasModifier("modifier_free_quake") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_free_quake", {duration = duration})
	end
	if not ability.procCast then
		Filters:CastSkillArguments(1, caster)
		ability.procCast = true
	end
	if caster.earthAspect then
		local rune_q_2_level = Runes:GetTotalRuneLevel(caster, 2, "q_2", "conjuror")
		if rune_q_2_level > 0 then
			local eventTable = {}
			eventTable.caster = caster.earthAspect
			eventTable.rune_q_2_level = rune_q_2_level
			eventTable.ability = caster.earthAspect:FindAbilityByName("earth_aspect_rune_q_2_clap")
			rune_q_2_clap_start(eventTable)
		end
	end
end

function fireQuake(position, caster, radius, stun_duration, damage, bSound, ability, amp)
	caster.q_4_level = Runes:GetTotalRuneLevel(caster, 4, "q_4", "conjuror")
	-- damage = damage + 0.0015*caster:GetStrength()/10*q_4_level*damage
	damage = damage * amp

	local splitEarthParticle = "particles/roshpit/conjuror/earthquake.vpcf"
	local pfx = ParticleManager:CreateParticle(splitEarthParticle, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, position)
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius))
	if bSound then
		EmitSoundOn("Conjuror.Earthquake", caster)
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius + 5, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
	if #enemies > 0 then
		for _, enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE)
			Filters:ApplyStun(caster, stun_duration, enemy)

			-- healUnit(caster, ability)
			-- healUnit(caster.earthAspect, ability)
			-- healUnit(caster.fireAspect, ability)
			-- healUnit(caster.shadowAspect, ability)
		end
	end
end

function free_quake_expire(event)
	local ability = event.ability
	local caster = event.caster
	ability.procCast = false
	local cooldown = 12
	if caster:HasModifier("modifier_grand_guardian_in_deity") then
		cooldown = 0
	end
	Filters:ReduceCooldownAll(caster, ability, cooldown)
end

function get_q_3_level(caster, ability)
	local runeUnit = caster.runeUnit3
	local runeAbility = runeUnit:FindAbilityByName("conjuror_rune_q_3")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "q_3")
	local totalLevel = abilityLevel + bonusLevel
	ability.runeUnit = runeUnit
	ability.runeAbility = runeAbility
	return totalLevel
end

function healUnit(unit, ability)
	if unit and ability.q_3_level > 0 then
		amount = ability.q_3_level * 8
		Filters:ApplyHeal(unit, unit, amount, true)
		ability.runeAbility:ApplyDataDrivenModifier(ability.runeUnit, unit, "conjuror_rune_q_3_heal_effect", {})
	end
end

function get_a_d_level(caster)
	local runeUnit = caster.runeUnit
	local runeAbility = runeUnit:FindAbilityByName("conjuror_rune_r_1")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "r_1")
	local totalLevel = abilityLevel + bonusLevel
	return totalLevel
end
