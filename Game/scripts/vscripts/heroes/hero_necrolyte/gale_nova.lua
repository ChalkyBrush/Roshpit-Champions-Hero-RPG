require('heroes/hero_necrolyte/plague_blaster')
require('heroes/hero_necrolyte/constants')

function cast(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage
	local radius = Q_RANGE
	local duration = Q_DEBUFF_DURATION

	StartAnimation(caster, {duration=0.7, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.3})
	Filters:CastSkillArguments(1, caster)

	if caster:HasModifier("modifier_venomort_glyph_1_1") then
		ability:EndCooldown()
		ability:StartCooldown(T11_COOLDOWN)
	end

	local q1_level = caster:GetRuneValue("q", 1)
	local q1_duration = Q1_DURATION

	local q2_level = caster:GetRuneValue("q", 2)
	if q2_level > 0 then
		damage = damage + Q2_DAMAGE_PER_INT * q2_level * caster:GetIntellect()
	end
	ability.dot_damage = damage

	local q3_level = caster:GetRuneValue("q", 3)

	local q4_level =  caster:GetRuneValue("q", 4)
	if q4_level > 0 then
		radius = radius + q4_level * Q4_RANGE
	end
	

	-- for i = 1,1 do
	-- 	local pfx_highlight = ParticleManager:CreateParticle("particles/roshpit/venomort/venomous_gale.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
	-- 	ParticleManager:SetParticleControl(pfx_highlight, 0, caster:GetAbsOrigin())
	-- 	ParticleManager:SetParticleControl(pfx_highlight, 1, Vector(radius, 0, 0))
	-- end
	local pfx = ParticleManager:CreateParticle("particles/roshpit/venomort/spreading_plague_marker.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 0, 0))
	ParticleManager:SetParticleControl(pfx, 2, Vector(radius, 0, 0))
	ParticleManager:SetParticleControl(pfx, 3, Vector(radius*0.7, 0, 0))
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)
	end)

	local bossesCount = 0
	local paragonsCount = 0
	local bossesCountAs = BOSSES_COUNT_AS_ENEMIES
	local paragonsCountAs = PARAGONS_COUNT_AS_ENEMIES
	if caster:HasModifier("modifier_venomort_glyph_2_1") then
		bossesCountAs = T21_BOSSES_COUNT_AS_ENEMIES
		paragonsCountAs = T21_PARAGONS_COUNT_AS_ENEMIES
	end


	local apply_demoralize = false
	local demoralize_duration = 0
	local w_ability = caster:FindAbilityByName('nether_blaster')
	local modifier = caster:FindModifierByName("modifier_venomort_glyph_1_2")
	if modifier then
		local w2_level = caster:GetRuneValue("w", 2)
		if w2_level > 0 then
			apply_demoralize = true
			demoralize_duration =  w2_level * W2_DURATION * (1 + T12_DURATION_INCREASE_PERCENT/100)
		end
	end



	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			if enemy.mainBoss then
				bossesCount = bossesCount + 1
			end
			if enemy.paragon then
				paragonsCount = paragonsCount + 1
			end
			if q3_level > 0 then
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_gale_nova_attack_slow", {duration = duration})
				local modifier = enemy:FindModifierByName("modifier_gale_nova_attack_slow")
				modifier:SetStackCount(q3_level)
			end
			if apply_demoralize then
				local luck = RandomInt(1,100)
				if luck < W2_CHANCE then
					demoralize(caster, w_ability, enemy, demoralize_duration)
				end

			end

			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_gale_nova_dot", {duration = duration})
		end
	end
	if q1_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_gale_nova_bad", {duration = q1_duration})
		caster:SetModifierStackCount( "modifier_gale_nova_bad", caster, q1_level * (#enemies + bossesCount * (bossesCountAs - 1) + paragonsCount * (paragonsCountAs - 1)))
	end

end
function dot_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = ability.dot_damage

	Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
end