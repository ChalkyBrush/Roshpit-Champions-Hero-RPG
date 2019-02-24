function jex_e_fire_fire_push_thinker(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local fv = ability.pushDirection
	local searchPos = target:GetAbsOrigin()

	local obstruction = WallPhysics:FindNearestObstruction(searchPos+(fv*60))
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, searchPos+(fv*60), target)
	if blockUnit then
		fv = 0
	end

	target:SetAbsOrigin(target:GetAbsOrigin() + ability.pushDirection*ability.pushSpeed)
end

function jex_fire_push_end(event)
	local target = event.target
	Timers:CreateTimer(0.03, function()
		FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
	end)
end