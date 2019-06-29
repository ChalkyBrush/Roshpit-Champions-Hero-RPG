require('heroes/spirit_breaker/duskbringer_helpers')

function begin_specter_rush_two(event)
	local caster = event.caster
	-- caster:Stop()
	local ability = event.ability
	local target = event.target_points[1]
	local chargeSpeed = 1000
	local cast_distance = WallPhysics:GetDistance2d(target, caster:GetAbsOrigin())
	local distance = math.min(cast_distance, event.max_distance)
	local duration = distance / chargeSpeed
	caster:RemoveModifierByName("modifier_terrorize_animation")
	if caster:HasModifier("modifier_terrorize_thinking") then
		StartAnimation(caster, {duration = duration + 0.39, activity = ACT_DOTA_RUN, rate = 0.45, translate = "charge"})
	else
		StartAnimation(caster, {duration = duration + 0.39, activity = ACT_DOTA_RUN, rate = 1.4, translate = "charge"})
	end
	ability.fv = ((target - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
	ability.e_3_level = Runes:GetTotalRuneLevel(caster, 3, "e_3", "duskbringer")
	ability.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "duskbringer")
	-- caster:MoveToPosition(caster:GetAbsOrigin() + ability.fv*800)
	local soundTable = {"spirit_breaker_spir_anger_05", "spirit_breaker_spir_laugh_07", "spirit_breaker_spir_move_03"}
	EmitSoundOn(soundTable[RandomInt(1, #soundTable)], caster)
	ability.interval = 0
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_specter_rush_charging", {duration = duration})
	local e_2_level = caster:GetRuneValue("e", 2)
	if e_2_level > 0 then
		local b_c_duration = DUSKBRINGER_E2_BASE_DUR + DUSKBRINGER_E2_DUR * e_2_level
		b_c_duration = Filters:GetAdjustedBuffDuration(caster, b_c_duration, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_duskbringer_rune_e_2_effect", {duration = b_c_duration})
		caster:SetModifierStackCount("modifier_duskbringer_rune_e_2_effect", caster, 6)
	end

	caster:RemoveModifierByName("modifier_duskbringer_rune_e_4_visible")
	caster:RemoveModifierByName("modifier_duskbringer_rune_e_4_invisible")

	Filters:CastSkillArguments(3, caster)
	

end

function specter_rush_thinking(event)
	local ability = event.ability
	local caster = event.caster
	local movement = 1000 * 0.03
	caster.EFV = ability.fv
	local e_3_level = caster:GetRuneValue("e", 3)
	local newPos = GetGroundPosition(caster:GetAbsOrigin() + ability.fv * movement, caster)
	if caster:HasModifier("modifier_terrorize_thinking") or caster:HasModifier("modifier_name_after_terrorize_falling") then
		newPos = caster:GetAbsOrigin() + ability.fv * movement
		local downspeed = -3
		if caster:GetAbsOrigin().z < GetGroundHeight(caster:GetAbsOrigin(), caster) + 5 then
			downspeed = 0
		elseif caster:GetAbsOrigin().z > 500 then
			downspeed = 0
		end
		newPos = newPos - Vector(0, 0, downspeed)
	end
	local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin() * Vector(1, 1, 0))
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos * Vector(1, 1, 0), caster)
	if not blockUnit then
		caster:SetAbsOrigin(newPos)
	end

	if ability.interval % 9 == 0 and e_3_level > 0 then
		local casterOrigin = caster:GetAbsOrigin()
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), casterOrigin, nil, 380, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
		local modifierKnockback =
		{
			center_x = casterOrigin.x,
			center_y = casterOrigin.y,
			center_z = casterOrigin.z,
			duration = 0.7,
			knockback_duration = 0.5,
			knockback_distance = knockback_distance,
			knockback_height = 70
		}
		if #enemies > 0 then
			EmitSoundOn("Hero_Spirit_Breaker.GreaterBash", caster)
			local stacksCount = Runes:Procs(e_3_level, DUSKBRINGER_E3_PROC_CHANCE, 1)
			for _, enemy in pairs(enemies) do
				increment_duskfire_stacks(caster, enemy, stacksCount)
			end
		end
	end
	ability.interval = ability.interval + 1
end

function specter_rush_end(event)
	local ability = event.ability
	local caster = event.caster
	if caster:HasModifier("modifier_terrorize_thinking") or caster:HasModifier("modifier_name_after_terrorize_falling") then
		if caster:HasAbility("duskbringer_arcana_terrorize") and caster:HasModifier("modifier_terrorize_thinking") then
			EndAnimation(caster)
			local arcana_ability = caster:FindAbilityByName("duskbringer_arcana_terrorize")
			arcana_ability:ApplyDataDrivenModifier(caster, caster, "modifier_terrorize_animation", {})
		end
		return false
	end
	ability.slideVelocity = 30
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_specter_rush_sliding", {duration = 0.45})
	WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
end

function charge_slide_think(event)
	local ability = event.ability
	local caster = event.caster
	if caster:HasModifier("modifier_terrorize_thinking") or caster:HasModifier("modifier_name_after_terrorize_falling") then
		return false
	end
	local newPos = GetGroundPosition(caster:GetAbsOrigin() + ability.fv * ability.slideVelocity, caster)
	local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin() * Vector(1, 1, 0))
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos * Vector(1, 1, 0), caster)
	if not blockUnit then
		FindClearSpaceForUnit(caster, newPos, false)
	else
		ability.slideVelocity = 0
	end
	if ability.slideVelocity > 0 then
		ability.slideVelocity = ability.slideVelocity - 2
	end
	--print("slide think")
end

function charge_slide_end(event)
	--print("slide END")
	local caster = event.caster
	caster.EFV = nil
end

function d_c_up(caster, d_c_level, damage)
	local d_c_duration = Filters:GetAdjustedBuffDuration(caster, 15, false)
	local runeAbility = caster.runeUnit4:FindAbilityByName("duskbringer_rune_e_4")
	runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_duskbringer_rune_e_4_visible", {duration = d_c_duration})
	local current_stacks = caster:GetModifierStackCount("modifier_duskbringer_rune_e_4_visible", runeAbility)
	newStacks = current_stacks + 1
	caster:SetModifierStackCount("modifier_duskbringer_rune_e_4_visible", runeAbility, newStacks)

	runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_duskbringer_rune_e_4_invisible", {duration = d_c_duration})
	local current_stacks_true = caster:GetModifierStackCount("modifier_duskbringer_rune_e_4_invisible", runeAbility)
	local new_stacks_true = current_stacks_true + (damage / 100) * 0.5 * d_c_level
	caster:SetModifierStackCount("modifier_duskbringer_rune_e_4_invisible", runeAbility, new_stacks_true)
end

function immortal3_attack_land(event)
	local caster = event.attacker
	local target = event.target
	local proc = Filters:GetProc(caster, 25)
	if proc then
		local casterOrigin = caster:GetAbsOrigin()
		local modifierKnockback =
		{
			center_x = casterOrigin.x,
			center_y = casterOrigin.y,
			center_z = casterOrigin.z,
			duration = 0.7,
			knockback_duration = 0.5,
			knockback_distance = knockback_distance,
			knockback_height = 70
		}

		EmitSoundOn("Hero_Spirit_Breaker.GreaterBash", target)

		Filters:ApplyStun(caster, 2.0, target)
		if not target.jumpLock then
			target:AddNewModifier(caster, nil, "modifier_knockback", modifierKnockback)
		end
		local particleName = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf"
		local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, target)
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		Timers:CreateTimer(1.0, function()
			ParticleManager:DestroyParticle(pfx, false)
		end)
		local ability = caster:FindAbilityByName("specter_rush_two")
		local e_2_level = caster:GetRuneValue("e", 2)
		local b_c_duration = DUSKBRINGER_E2_BASE_DUR + DUSKBRINGER_E2_DUR * e_2_level
		b_c_duration = Filters:GetAdjustedBuffDuration(caster, b_c_duration, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_duskbringer_rune_e_2_effect", {duration = b_c_duration})
		caster:SetModifierStackCount("modifier_duskbringer_rune_e_2_effect", caster, 5)

	end
end

function duskbringer_rune_e_1_refresh(caster, duration)
	if not caster:IsHero() then
		return false
	end
	local event = {}
	event.caster = caster.runeUnit
	event.duration = duration
	event.ability = caster.runeUnit:FindAbilityByName("duskbringer_rune_e_1")
	event.ability.distanceMoved = 350
	duskbringer_rune_e_1_think(event)
end

function duskbringer_rune_e_1_think(event)
	local caster = event.caster
	local ability = event.ability
	local hero = caster.hero
	if not IsValidEntity(hero) then
		return false
	end
	local e_1_level = hero:GetRuneValue("e", 1)
	if e_1_level > 0 then
		local target = hero
		if not ability.ticks then
			ability.ticks = 0
		end
		if not ability.lastStackTime then
			ability.lastStackTime = -20
		end
		if not ability.lastPos then
			ability.lastPos = target:GetAbsOrigin()
		end
		if not ability.distanceMoved then
			ability.distanceMoved = 0
		end
		ability.newPos = target:GetAbsOrigin()
		ability.hero = target
		local distance = WallPhysics:GetDistance(ability.newPos, ability.lastPos)
		ability.distanceMoved = ability.distanceMoved + distance
		local e_1_duration = DUSKBRINGER_E1_BASE_DUR
		if event.duration then
			e_1_duration = event.duration
		end
		if hero:HasModifier('modifier_duskbringer_glyph_3_1') then
			e_1_duration = e_1_duration + DUSKBRINGER_GLYPH_3_1_INCR_DUR
		end
		e_1_duration = Filters:GetAdjustedBuffDuration(hero, e_1_duration, false)
		if ability.distanceMoved > 300 and (ability.ticks - ability.lastStackTime) >= 20 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_duskbringer_rune_e_1_effect", {duration = e_1_duration})
			target:SetModifierStackCount("modifier_duskbringer_rune_e_1_effect", ability, e_1_level)
			ability.distanceMoved = ability.distanceMoved % 300
		end
		ability.lastPos = target:GetAbsOrigin()
	end
end
