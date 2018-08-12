require('heroes/hero_necrolyte/plague_blaster')
local constants = require('heroes/hero_necrolyte/constants')

function cast(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage
	local radius = constants.Q_RANGE
	local duration = constants.Q_DEBUFF_DURATION

	if caster:HasModifier("modifier_venomort_glyph_1_1") then
		ability:EndCooldown()
		ability:StartCooldown(constants.T11_COOLDOWN)
	end

	local q1_level = Runes:GetTotalRuneLevelGeneric(caster, 1, 0)
	local q1_duration = constants.Q1_DURATION

	local q2_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 0)
	if q2_level > 0 then
		damage = damage + constants.Q2_DAMAGE_PER_INT * caster:GetIntellect()
	end
	ability.dot_damage = damage

	local q3_level = Runes:GetTotalRuneLevelGeneric(caster, 3, 0)

	local q4_level =  Runes:GetTotalRuneLevelGeneric(caster, 4, 0)
	if q4_level > 0 then
		radius = radius + q4_level * constants.Q4_RANGE
	end


	for i = 1,2 do
		local pfx = ParticleManager:CreateParticle("particles/roshpit/venomort/venomous_gale.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 0, 0))
	end


	local bossesCount = 0
	local paragonsCount = 0
	local bossesCountAs = constants.BOSSES_COUNT_AS_ENEMIES
	local paragonsCountAs = constants.PARAGONS_COUNT_AS_ENEMIES
	if caster:HasModifier("modifier_venomort_glyph_2_1") then
		bossesCountAs = constants.T21_BOSSES_COUNT_AS_ENEMIESx
		paragonsCountAs = constants.T21_PARAGONS_COUNT_AS_ENEMIES
	end


	local apply_demoralize = false
	local demoralize_duration = 0
	local w_ability = caster:FindAbilityByName('nether_blaster')
	local modifier = caster:FindModifierByName("modifier_venomort_glyph_1_2")
	if modifier then
		local w2_level = Runes:GetTotalRuneLevelGeneric(caster, 2, 1)
		if w2_level > 0 then
			apply_demoralize = true
			demoralize_duration =  w2_level * constants.W2_DURATION * (1 + constants.T12_DURATION_INCREASE_PERCENT/100)
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
				if luck < constants.W2_CHANCE then
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