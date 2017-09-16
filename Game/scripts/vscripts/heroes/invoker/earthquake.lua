require('heroes/invoker/conjuror_runes')

function earthquake_cast(event)
	local caster = event.caster
	local ability = event.ability
	local stun_duration = event.stun_duration
	local radius = event.radius
	local point = event.target_points[1]
	local damage = event.damage

    

    
    if caster:HasModifier("modifier_conjuror_glyph_5_1") then
    	radius = radius + 80
    end
	ability.c_a_level = get_c_a_level(caster, ability)
	fireQuake(point, caster, radius, stun_duration, damage, true, ability, 1)
	if caster.earthAspect then
		fireQuake(caster.earthAspect:GetAbsOrigin(), caster, radius, stun_duration, damage, false, ability, 1)
	end
	local duration = 1.7
    if caster:HasModifier("modifier_conjuror_glyph_5_1") then
    	duration = duration + 1.5
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
		local rune_b_a_level = Runes:GetTotalRuneLevel(caster, 2, "b_a", "conjuror")
		if rune_b_a_level > 0 then
			local eventTable = {}
			eventTable.caster = caster.earthAspect
			eventTable.rune_b_a_level = rune_b_a_level
			eventTable.ability = caster.earthAspect:FindAbilityByName("earth_aspect_rune_b_a_clap")
			rune_b_a_clap_start(eventTable)
		end
	end
end

function fireQuake(position, caster, radius, stun_duration, damage, bSound, ability, amp)
	caster.d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "conjuror")
	-- damage = damage + 0.0015*caster:GetStrength()/10*d_a_level*damage
	damage = damage*amp

	local splitEarthParticle = "particles/roshpit/conjuror/earthquake.vpcf"
	local pfx = ParticleManager:CreateParticle( splitEarthParticle, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, position )
	ParticleManager:SetParticleControl( pfx, 1, Vector(radius, radius, radius) )
	if bSound then
		EmitSoundOn("Conjuror.Earthquake", caster)
	end
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius+5, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE)
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
	Filters:ReduceCooldownAll(caster, ability, 12)
end

function get_c_a_level(caster, ability)
	local runeUnit = caster.runeUnit3
	local runeAbility = runeUnit:FindAbilityByName("conjuror_rune_c_a")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_a")
	local totalLevel = abilityLevel + bonusLevel
	ability.runeUnit = runeUnit
	ability.runeAbility = runeAbility
	return totalLevel
end

function healUnit(unit, ability)
	if unit and ability.c_a_level > 0 then
		amount = ability.c_a_level*8
		Filters:ApplyHeal(unit, unit, amount, true)
		ability.runeAbility:ApplyDataDrivenModifier(ability.runeUnit, unit, "conjuror_rune_c_a_heal_effect", {})
	end
end

function get_a_d_level(caster)
	local runeUnit = caster.runeUnit
	local runeAbility = runeUnit:FindAbilityByName("conjuror_rune_a_d")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_d")
	local totalLevel = abilityLevel + bonusLevel
	return totalLevel
end