require('heroes/dragon_knight/flamewaker_constants')
function start_arcana_ability(event)
	local caster = event.caster
	local ability = event.ability

	local target_point = event.target_points[1]
	local damage = event.strength_mult*caster:GetStrength() + event.damage

	local q_2_level = caster:GetRuneValue("q", 2)
	local q_3_level = caster:GetRuneValue("q", 3)

	if not ability.cannot_cast_before_then then
		ability.cannot_cast_before_then = 0
	end

	local additional_delay = max(ability.cannot_cast_before_then - GameRules:GetGameTime(), 0)
	local is_free_proc = caster:HasModifier('modifier_flamewaker_arcana_q_free_cast')
	local fire_wall_casted = false

	local delay = 0.01

	if ability.old_target_point then
		local distance = WallPhysics:GetDistance2d(ability.old_target_point, target_point)
		if distance > FLAMEWAKER_ARCANA_Q_MIN_DISTANCE and distance < FLAMEWAKER_ARCANA_Q_MAX_DISTANCE then
			fire_wall_casted = true
			local direction = (ability.old_target_point - target_point):Normalized()
			local procs = math.ceil(distance/150)
			local distance_betwen_procs = distance/(procs + 2)
			delay = 0.13 * procs
			local start_point = ability.old_target_point
			for cast_number = 0, procs, 1 do
				Timers:CreateTimer(additional_delay + cast_number*0.13, function()
					local new_position = start_point - direction * (cast_number + 1) * distance_betwen_procs
					cast_dragon_fire_burst(caster, ability, new_position, damage, q_2_level)
				end)
			end
			Timers:CreateTimer(additional_delay, function()
					ability.cannot_cast_before_then = GameRules:GetGameTime() + procs * 0.13
			end)
		end
	end

	if not is_free_proc or fire_wall_casted then
		Timers:CreateTimer(additional_delay + delay, function()
			cast_dragon_fire_burst(caster, ability, target_point, damage, q_2_level)
			if q_3_level > 0 then
				local procs = Runes:Procs(q_3_level, FLAMEWAKER_ARCANA_Q3_PROC_CHANCE, 1)
				for cast_number = 0, procs, 1 do
					Timers:CreateTimer( (cast_number + 1)*FLAMEWAKER_ARCANA_Q3_DELAY, function()
						local casts_in_circle = 5 + cast_number/6
						local new_position = target_point + Vector(math.cos(2 * cast_number * math.pi/casts_in_circle), math.sin(2 * cast_number * math.pi/casts_in_circle), 0) * 150 * (1 + cast_number/6)
						cast_dragon_fire_burst(caster, ability, new_position, damage, q_2_level)

					end)
				end
			end
		end)
	end

	if is_free_proc then
		caster:RemoveModifierByName('modifier_flamewaker_arcana_q_free_cast')
		ability:StartCooldown(FLAMEWAKER_ARCANA_Q_COOLDOWN)
	end
	if not is_free_proc and not ability.used_free_proc then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_flamewaker_arcana_q_free_cast", {duration = FLAMEWAKER_ARCANA_Q_FREE_CAST_DURATION})
		ability:EndCooldown()
		Timers:CreateTimer(FLAMEWAKER_ARCANA_Q_FREE_CAST_DURATION, function ()
			ability:EndCooldown()
			ability:StartCooldown(FLAMEWAKER_ARCANA_Q_COOLDOWN-FLAMEWAKER_ARCANA_Q_FREE_CAST_DURATION)
		end)
	end

	ability.old_target_point = target_point

	if q_2_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_flamewaker_arcana_b_a_effect", {duration = FLAMEWAKER_ARCANA_Q2_DURATION})
		caster:SetModifierStackCount("modifier_flamewaker_arcana_b_a_effect", caster, q_2_level)
		local b_a_particle = CustomAbilities:QuickAttachParticle("particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_arcana_fire_channel.vpcf", caster, 4)
		ParticleManager:SetParticleControlEnt(b_a_particle, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	end
	Filters:CastSkillArguments(1, caster)
end

function cast_dragon_fire_burst(caster, ability, target_point, damage, q_2_level)
	local radius = FLAMEWAKER_ARCANA_Q_RADIUS
	local pfx = ParticleManager:CreateParticle("particles/roshpit/flamewaker/flamewaker_q_arcana1.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, target_point+Vector(0,0,120))
	Timers:CreateTimer(6, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local stunDuration = 1.2
	if caster:HasModifier("modifier_flamewaker_immortal_weapon_3") then
		stunDuration = stunDuration + stunDuration*1.5
	end
	EmitSoundOnLocationWithCaster(target_point, "Flamewaker.ArcanaAbility", caster)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target_point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			if q_2_level > 0 then
				local newStacks = enemy:GetModifierStackCount("modifier_flamewaker_arcana_b_a_effect_stacking_visible", caster) + 1
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_flamewaker_arcana_b_a_effect_stacking_visible", {duration = FLAMEWAKER_ARCANA_Q2_DURATION})
				enemy:SetModifierStackCount("modifier_flamewaker_arcana_b_a_effect_stacking_visible", caster, newStacks)
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_flamewaker_arcana_b_a_effect_stacking_invisible", {duration = FLAMEWAKER_ARCANA_Q2_DURATION})
				enemy:SetModifierStackCount("modifier_flamewaker_arcana_b_a_effect_stacking_invisible", caster, newStacks*q_2_level)
			end
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
			Filters:ApplyStun(caster, stunDuration, enemy)
		end
	end
	GridNav:DestroyTreesAroundPoint(target_point, radius-20, false)
end

function arcana_ability_think(event)
	local caster = event.caster
	local ability = event.ability
	local q_1_level = caster:GetRuneValue("q", 1)
	if q_1_level > 0 then
		local missingHealth = caster:GetMaxHealth() - caster:GetHealth()
		local a_a_stacks = math.min(missingHealth/FLAMEWAKER_ARCANA_Q1_MISSED_HP_FOR_GET_STACK_BASE, FLAMEWAKER_ARCANA_Q1_MAX_STACKS_BASE)*q_1_level

		ability:ApplyDataDrivenModifier(caster, caster, "modifier_flamewaker_arcana_a_a_effect", {})
		caster:SetModifierStackCount("modifier_flamewaker_arcana_a_a_effect", caster, a_a_stacks)
	else
		caster:RemoveModifierByName("modifier_flamewaker_arcana_a_a_effect")
	end

	local q_4_level = caster:GetRuneValue("q", 4)
	ability.q_4_level = q_4_level
	if q_4_level > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_flamewaker_arcana_d_a_effect", {})
		caster:SetModifierStackCount("modifier_flamewaker_arcana_d_a_effect", caster, q_4_level)
	else
		caster:RemoveModifierByName("modifier_flamewaker_arcana_d_a_effect")
	end
end

function d_a_stun(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if not target:HasModifier("modifier_flamewaker_arcana_d_a_immune") then
		local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*FLAMEWAKER_ARCANA_Q4_DMG_PER_ATT*ability.q_4_level
		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Flamewaker.ArcanaDAStun", target)
		CustomAbilities:QuickAttachParticle("particles/econ/items/techies/techies_arcana/techies_suicide_flame.vpcf", target, 3)
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_flamewaker_arcana_d_a_immune", {duration = 0.4})
	end
	-- Filters:ApplyStun(caster, stunDuration, target)	
end