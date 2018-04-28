require('heroes/spirit_breaker/whirling_flail')
function begin_specter_rush_two(event)
	local caster = event.caster
	-- caster:Stop()
	local ability = event.ability
	local target = event.target_points[1]
	local chargeSpeed = 1000
	local distance = WallPhysics:GetDistance2d(target,caster:GetAbsOrigin())
	local duration = distance/chargeSpeed
	StartAnimation(caster, {duration=duration+0.39, activity=ACT_DOTA_RUN, rate=1.4, translate="charge"})
	ability.fv = ((target-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	ability.c_c_level = Runes:GetTotalRuneLevel(caster, 3, "c_c", "duskbringer")
	ability.d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "duskbringer")
	print("charge wind up")
	-- caster:MoveToPosition(caster:GetAbsOrigin() + ability.fv*800)
	local soundTable = {"spirit_breaker_spir_anger_05", "spirit_breaker_spir_laugh_07", "spirit_breaker_spir_move_03"}
	EmitSoundOn(soundTable[RandomInt(1,#soundTable)], caster)
	ability.interval = 0
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_specter_rush_charging", {duration = duration})
	local b_c_level = Runes:GetTotalRuneLevel(caster, 2, "b_c", "duskbringer")
	if b_c_level > 0 then
		local b_c_duration = 0.7 + 0.2*b_c_level
		b_c_duration = Filters:GetAdjustedBuffDuration(caster, b_c_duration, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_duskbringer_ghost_armor", {duration = b_c_duration})
		caster:SetModifierStackCount("modifier_duskbringer_ghost_armor", caster, 6)
	end

	caster:RemoveModifierByName("modifier_duskbringer_rune_d_c_visible")
	caster:RemoveModifierByName("modifier_duskbringer_rune_d_c_invisible")
	
	Filters:CastSkillArguments(3, caster)

	
end

function specter_rush_thinking(event)
	local ability = event.ability
	local caster = event.caster
	local movement = 1000*0.03
	caster.EFV = ability.fv
	local newPos = GetGroundPosition(caster:GetAbsOrigin() + ability.fv*movement, caster)
	local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin()*Vector(1,1,0))
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos*Vector(1,1,0), caster)
	if not blockUnit then
		caster:SetAbsOrigin(newPos)
	end

	if ability.interval%9==0 and ability.c_c_level > 0 then
		local casterOrigin = caster:GetAbsOrigin()
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), casterOrigin, nil, 380, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
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
		local flailAbility = caster:FindAbilityByName("whirling_flail")
		if #enemies > 0 then
			EmitSoundOn("Hero_Spirit_Breaker.GreaterBash", caster)
			local stacksCount = Runes:Procs(ability.c_c_level, E3_PROC_CHANCE, 1)
			for _,enemy in pairs(enemies) do
				increment_duskfire_stacks(caster,enemy, flailAbility, stacksCount)
			end
		end 			
	end
	ability.interval = ability.interval + 1
end

function specter_rush_end(event)
	local ability = event.ability
	local caster = event.caster
	ability.slideVelocity = 30
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_specter_rush_sliding", {duration = 0.45})
	WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
end

function charge_slide_think(event)
	local ability = event.ability
	local caster = event.caster
	local newPos = GetGroundPosition(caster:GetAbsOrigin() + ability.fv*ability.slideVelocity, caster)
	local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin()*Vector(1,1,0))
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPos*Vector(1,1,0), caster)
	if not blockUnit then
		FindClearSpaceForUnit(caster, newPos, false)
	else
		ability.slideVelocity = 0
	end	
	if ability.slideVelocity > 0 then
		ability.slideVelocity = ability.slideVelocity - 2
	end
	print("slide think")
end

function charge_slide_end(event)
	print("slide END")
	local caster = event.caster
	caster.EFV = nil
end

function d_c_up(caster, d_c_level, damage)
	local d_c_duration = Filters:GetAdjustedBuffDuration(caster, 15, false)
    local runeAbility = caster.runeUnit4:FindAbilityByName("duskbringer_rune_d_c")
    runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_duskbringer_rune_d_c_visible", {duration = d_c_duration})
    local current_stacks = caster:GetModifierStackCount( "modifier_duskbringer_rune_d_c_visible", runeAbility )
    newStacks = current_stacks + 1
    caster:SetModifierStackCount( "modifier_duskbringer_rune_d_c_visible", runeAbility, newStacks )


    runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_duskbringer_rune_d_c_invisible", {duration = d_c_duration})
    local current_stacks_true = caster:GetModifierStackCount( "modifier_duskbringer_rune_d_c_invisible", runeAbility )
    local new_stacks_true = current_stacks_true + (damage/100) * 0.5 * d_c_level
    caster:SetModifierStackCount( "modifier_duskbringer_rune_d_c_invisible", runeAbility, new_stacks_true)
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
			target:AddNewModifier( caster, nil, "modifier_knockback", modifierKnockback )
		end
		local particleName = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf"
		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
		ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		Timers:CreateTimer(1.0, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end) 	
		local ability = caster:FindAbilityByName("specter_rush_two")
		local b_c_level = Runes:GetTotalRuneLevel(caster, 2, "b_c", "duskbringer")
		local b_c_duration = 0.7 + 0.2*b_c_level
		b_c_duration = Filters:GetAdjustedBuffDuration(caster, b_c_duration, false)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_duskbringer_ghost_armor", {duration = b_c_duration})
		caster:SetModifierStackCount("modifier_duskbringer_ghost_armor", caster, 5)

	end
end


function duskbringer_passive_think(event)
	local caster = event.caster
	caster.d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "duskbringer")
end