require('heroes/hero_necrolyte/plague_blaster')
require("/heroes/hero_necrolyte/venomort_constants")

function frostvenom_grasp_start(event)
	local caster = event.caster
	local ability = event.ability
	local q_4_level = caster:GetRuneValue("q", 4)
	local explosions = event.explosions + Runes:Procs(q_4_level, 5, 1)
	local radius = 500
	local counter = 0
	StartAnimation(caster, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_1, rate = 1.0})
	local pfx = CustomAbilities:QuickParticleAtPoint("particles/items4_fx/meteor_hammer_spell_ground_impact.vpcf", caster:GetAbsOrigin(), 5)
	ParticleManager:SetParticleControl(pfx, 3, caster:GetAbsOrigin())
	Timers:CreateTimer(3, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	if not event.amp then
		event.amp = 1
	end
	if caster:HasModifier("modifier_venomort_glyph_1_1") then
		ability:EndCooldown()
		ability:StartCooldown(T11_COOLDOWN)
	end
	local damage = event.damage * event.amp
	EmitSoundOn("Venomort.FrostVenomGrasp.Cast", caster)
	local q_1_level = caster:GetRuneValue("q", 1)
	ability.q_1_level = q_1_level
	local q_2_level = caster:GetRuneValue("q", 2)
	if q_2_level > 0 then
		radius = radius + q_2_level * ARCANA2_Q2_SEARCH_RADIUS
		ability.slideSpeed = ARCANA2_Q2_SPEED_BURST_BASE + q_2_level * ARCANA2_Q2_SPEED_BURST
		ability.fv = caster:GetForwardVector()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_icevenom_slide", {duration = 5})
	end

	local apply_demoralize = false
	local demoralize_duration = 0
	local w_ability = caster:FindAbilityByName('nether_blaster')
	local modifier = caster:FindModifierByName("modifier_venomort_glyph_1_2")
	if modifier then
		local w2_level = caster:GetRuneValue("w", 2)
		if w2_level > 0 then
			apply_demoralize = true
			demoralize_duration = w2_level * W2_DURATION * (1 + T12_DURATION_INCREASE_PERCENT / 100)
		end
	end
	for i = 1, explosions, 1 do
		Timers:CreateTimer((i - 1) * 0.35, function()
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
			if #enemies > 0 then
				local enemy = enemies[1]
				EmitSoundOn("Venomort.FrostVenomGrasp.Impact", enemy)
				CustomAbilities:QuickAttachParticle("particles/roshpit/venomort/frostvenom_grasp.vpcf", enemy, 1)
				local enemies2 = FindUnitsInRadius(caster:GetTeamNumber(), enemy:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
				for _, enemy2 in pairs(enemies2) do
					ability:ApplyDataDrivenModifier(caster, enemy2, "modifier_chilled", {duration = 8})
					ability:ApplyDataDrivenModifier(caster, enemy2, "modifier_chilled_stacking", {duration = 8})
					if q_1_level > 0 then
						local currentStacks = enemy2:GetModifierStackCount("modifier_chilled_stacking", caster)
						enemy2:SetModifierStackCount("modifier_chilled_stacking", caster, currentStacks + 1)
					end
					Filters:TakeArgumentsAndApplyDamage(enemy2, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_POISON, RPC_ELEMENT_ICE)
					if q_4_level > 0 then
						ability:ApplyDataDrivenModifier(caster, caster, "modifier_venomort_arcana2_q_4_visible", {duration = 12})
						local newStacks = math.min(caster:GetModifierStackCount("modifier_venomort_arcana2_q_4_visible", caster) + 1, 50)
						caster:SetModifierStackCount("modifier_venomort_arcana2_q_4_visible", caster, newStacks)
						ability:ApplyDataDrivenModifier(caster, caster, "modifier_venomort_arcana2_q_4_invisible", {duration = 12})
						caster:SetModifierStackCount("modifier_venomort_arcana2_q_4_invisible", caster, newStacks * q_4_level)
					end

					if apply_demoralize then
						local luck = RandomInt(1, 100)
						if luck < W2_CHANCE then
							demoralize(caster, w_ability, enemy, demoralize_duration)
						end

					end
				end
			end
		end)
	end
	Filters:CastSkillArguments(1, caster)
end

function frostvenom_chill_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if ability.q_1_level > 0 then
		local damage = (ability.q_1_level * VENOMORT_ARCANA2_Q1_DAMAGE_PER_HERO_LVL + VENOMORT_ARCANA2_Q1_DAMAGE_PER_HERO_LVL_BASE) * caster:GetLevel() * target:GetModifierStackCount("modifier_chilled_stacking", caster)
		Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_POISON, RPC_ELEMENT_ICE)
	end
end

function icevenom_slide_think(event)
	local caster = event.caster
	local ability = event.ability

	if ability.Q2Toggle == nil then
		ability.Q2Toggle = true
	end

	if ability.Q2Toggle == false then
		caster:RemoveModifierByName("modifier_icevenom_slide")
		return
	end

	local newPosition = GetGroundPosition(caster:GetAbsOrigin() + ability.fv * ability.slideSpeed, caster)
	local obstruction = WallPhysics:FindNearestObstruction(newPosition)
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, caster)
	ability.slideSpeed = math.min(ability.slideSpeed - 0.5, ability.slideSpeed * 0.96)
	if not blockUnit then
		caster:SetOrigin(newPosition)
	else
		caster:RemoveModifierByName("modifier_icevenom_slide")
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	end

	if ability.slideSpeed <= 3.0 then
		caster:RemoveModifierByName("modifier_icevenom_slide")
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	end
end
