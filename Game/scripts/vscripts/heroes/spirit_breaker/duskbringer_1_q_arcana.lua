require('heroes/spirit_breaker/duskbringer_1_q')
require('/heroes/spirit_breaker/duskbringer_constants')

function duskbringer_terrorize_start(event)
	local caster = event.caster
	local ability = event.ability

	local min_distance = 600
	ability.target_point = WallPhysics:WallSearch(caster:GetAbsOrigin(), event.target_points[1], caster)
	if WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.target_point) < min_distance then
		local moveVector = ((ability.target_point-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		ability.target_point = WallPhysics:WallSearch(caster:GetAbsOrigin(), caster:GetAbsOrigin()+(moveVector*min_distance), caster)
	end
	local q_3_level = caster:GetRuneValue("q", 3)
	local q_4_level = caster:GetRuneValue("q", 4)
	local terrorize_duration = event.base_duration + q_3_level*DUSKBRINGER_Q3_ARCANA2_DURATION_INCREASE
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_terrorize_thinking", {duration = terrorize_duration})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_terrorize_animation", {duration = terrorize_duration})
	if q_4_level > 0 then
		local q_4_duration = DUSKBRINGER_Q4_DURATION_AFTER + terrorize_duration
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_duskbringer_arcana_q_4", {duration = q_4_duration})
		caster:SetModifierStackCount("modifier_duskbringer_arcana_q_4", caster, q_4_level)
	end
	ability.phase = 0
	ability.pushSpeed = 90
	ability.liftSpeed = 50
	local desired_height = 500
	local movement_ticks = (WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.target_point)/ability.pushSpeed)/0.03
	ability.liftSpeed = (desired_height/movement_ticks)/0.03
	ability.liftSpeed = math.min(ability.liftSpeed, 120)
	ability.impact_count = 0
	EmitSoundOn("Duskbringer.Terrorize.Start", caster)
	ability.playSound = true
	caster:RemoveModifierByName("modifier_name_after_terrorize_falling")
	local ability_in_slot = caster:GetAbilityByIndex(0)
	if ability_in_slot:GetAbilityName() == ability:GetAbilityName() then
		CustomAbilities:AddAndOrSwapSkill(caster, ability:GetAbilityName(), "duskbringer_arcana_terrorize_phantom_plasma", 0)
	end
end

function duskbringer_terrorize_thinker(event)
	local caster = event.caster
	local ability = event.ability
	ability.moveVector = ((ability.target_point-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	if ability.phase == 0 then
		ability.pushSpeed = math.max(ability.pushSpeed - 1, 1)
		ability.liftSpeed = ability.liftSpeed - 1
	end
	local liftSpeed = ability.liftSpeed
	if caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster) > 650 then
		liftSpeed = 0
	end
	local newPos = caster:GetAbsOrigin()+ability.moveVector*ability.pushSpeed+Vector(0,0,liftSpeed)
	local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin()*Vector(1,1,0))
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos*Vector(1,1,0), caster)
	if blockUnit then
		newPos = caster:GetAbsOrigin()+Vector(0,0,liftSpeed)
	end	
	caster:SetAbsOrigin(newPos)
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.target_point)
	-- if not caster:HasModifier("modifier_specter_rush_charging") then
	-- 	ability:ApplyDataDrivenModifier(caster, caster, "modifier_terrorize_animation", {})
	-- end
	if distance < ability.pushSpeed*1.5 and ability.phase == 0 then
		if ability.playSound then
			Timers:CreateTimer(0.15, function()
				EmitSoundOn("Duskbringer.Terrorize.StartScare", caster)
			end)
			ability.playSound = false
		end
		ability.pushSpeed = 1
		ability.liftSpeed = -0.1
		ability.phase = 1
	end
end

function terrorize_lift_end(event)
	local caster = event.caster
	local ability = event.ability
	StartAnimation(caster, {duration=0.8, activity=ACT_DOTA_TELEPORT_END, rate=1.0})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_name_after_terrorize_falling", {})
	ability.fallSpeed = 20
	caster:RemoveModifierByName("modifier_terrorize_animation")

	local ability_in_slot = caster:GetAbilityByIndex(0)
	if ability_in_slot:GetAbilityName() == "duskbringer_arcana_terrorize_phantom_plasma" then
		CustomAbilities:AddAndOrSwapSkill(caster, "duskbringer_arcana_terrorize_phantom_plasma", ability:GetAbilityName(), 0)
	end
	if caster:HasModifier("modifier_duskbringer_arcana_q_4") then
		local q_4_duration = DUSKBRINGER_Q4_DURATION_AFTER
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_duskbringer_arcana_q_4", {duration = q_4_duration})
	end
end

function duskbringer_terrorize_falling_think(event)
	local caster = event.caster
	local ability = event.ability
	if not caster:HasModifier("modifier_name_after_terrorize_falling") then
		return false
	end
	ability.fallSpeed = ability.fallSpeed + 1
	caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,ability.fallSpeed))
	if caster:GetAbsOrigin().z < GetGroundHeight(caster:GetAbsOrigin(), caster) + ability.fallSpeed then
		caster:RemoveModifierByName("modifier_name_after_terrorize_falling")
		if not caster:HasModifier("modifier_terrorize_thinking") then
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end
	end
end

function duskbringer_terrorize_bomb_start(event)
	local caster = event.caster
	local ability = event.ability

	local point = event.target_points[1]
	local travel_speed = 2000
	local particleStartPoint = caster:GetAbsOrigin()+Vector(0,0,40)+caster:GetForwardVector()*40
	local pfx = CustomAbilities:QuickParticleAtPoint("particles/roshpit/duskbringer/terrorize_cast.vpcf", particleStartPoint, 4)
	ParticleManager:SetParticleControl(pfx, 1, point)
	local projectile_model = "particles/units/heroes/hero_dark_willow/dark_willow_base_attack.vpcf"
	local particle = projectile_model


	local distance = WallPhysics:GetDistance(particleStartPoint, point)
	local travel_speed = 2500
	local time_to_reach_end_point = distance/travel_speed
	local stack_increment = 1
	if caster:HasModifier("modifier_duskbringer_glyph_2_2") then
		stack_increment = DUSKBRINGER_GLYPH_2_2_Q1_STACKS
	end
	local terrorize_ability = caster:FindAbilityByName("duskbringer_arcana_terrorize")
	local damage = event.damage
	local damage = damage + OverflowProtectedGetAverageTrueAttackDamage(caster)*(event.additional_damage_atk_power_pct/100)
	Timers:CreateTimer(time_to_reach_end_point, function()
		local q_1_level = caster:GetRuneValue("q", 1)
		local q_2_level = caster:GetRuneValue("q", 2)
		local aoe = 600
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if q_1_level > 0 then
					increment_duskfire_stacks(caster, enemy, stack_increment)
				end
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, 1, RPC_ELEMENT_GHOST, RPC_ELEMENT_NONE)
				if q_2_level > 0 then
					local duration = DUSKBRINGER_Q2_ARCANA2_DURATION_PER_LV*q_2_level
					if not enemy:HasModifier("modifier_terrorize_panic_immune") then
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_terrorize_panic", {duration = duration})
						ability:ApplyDataDrivenModifier(caster, enemy, "modifier_terrorize_panic_immune", {duration = duration+3})
					end
				end
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_terrorize_slow", {duration = 10})
			end
		end		
	end)
	if terrorize_ability then
		terrorize_ability.impact_count = math.min(terrorize_ability.impact_count + 1, 5)
		EmitSoundOnLocationWithCaster(point, "Duskbringer.Terrorize.Impact"..terrorize_ability.impact_count, caster)
	else
		EmitSoundOnLocationWithCaster(point, "Duskbringer.Terrorize.Impact"..RandomInt(1, 5), caster)
	end

	EmitSoundOn("Duskbringer.Terrorize.Breath", caster)
	Filters:CastSkillArguments(1, caster)
end

function terrorize_panic_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local direction = ((target:GetAbsOrigin() - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	target:MoveToPosition(target:GetAbsOrigin()+direction*200)
end