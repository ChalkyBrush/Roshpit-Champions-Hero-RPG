function jex_e_fire_fire_push_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local fv = ability.pushDirection
	local searchPos = target:GetAbsOrigin()

	ability.pushSpeed = Filters:GetAdjustedESpeed(caster, ability.pushSpeed, false)
	local obstruction = WallPhysics:FindNearestObstruction(searchPos+(fv*60))
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, searchPos+(fv*60), target)
	if blockUnit then
		fv = 0
	else
		target:SetAbsOrigin(target:GetAbsOrigin() + ability.pushDirection*ability.pushSpeed)
	end
end

function jex_fire_push_end(event)
	local target = event.target
	Timers:CreateTimer(0.03, function()
		FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
	end)
end

function jex_e_fire_fire_burn_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local w_4_burn_amount = caster:FindAbilityByName("jex_fire_fire_e"):GetSpecialValueFor("w_4_burn_damage_attack_power")
	local damage = w_4_burn_amount*(OverflowProtectedGetAverageTrueAttackDamage(caster)/100)*ability.w_4_level
	Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end