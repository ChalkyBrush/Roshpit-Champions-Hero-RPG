function duskbringer_terrorize_start(event)
	local caster = event.caster
	local ability = event.ability

	local min_distance = 600
	ability.target_point = WallPhysics:WallSearch(caster:GetAbsOrigin(), event.target_points[1], caster)
	if WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.target_point) < min_distance then
		local moveVector = ((ability.target_point-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
		ability.target_point = WallPhysics:WallSearch(caster:GetAbsOrigin(), caster:GetAbsOrigin()+(moveVector*min_distance), caster)
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_terrorize_thinking", {duration = 3})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_terrorize_animation", {duration = 3})
	ability.phase = 0
	ability.pushSpeed = 90
	ability.liftSpeed = 50
	local desired_height = 500
	local movement_ticks = (WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.target_point)/ability.pushSpeed)/0.03
	ability.liftSpeed = (desired_height/movement_ticks)/0.03
	ability.liftSpeed = math.min(ability.liftSpeed, 120)
end

function duskbringer_terrorize_thinker(event)
	local caster = event.caster
	local ability = event.ability
	ability.moveVector = ((ability.target_point-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	if ability.phase == 0 then
		ability.pushSpeed = ability.pushSpeed - 1
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
end

function duskbringer_terrorize_falling_think(event)
	local caster = event.caster
	local ability = event.ability
	ability.fallSpeed = ability.fallSpeed + 1
	caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,ability.fallSpeed))
	if caster:GetAbsOrigin().z < GetGroundHeight(caster:GetAbsOrigin(), caster) + ability.fallSpeed then
		caster:RemoveModifierByName("modifier_name_after_terrorize_falling")
	end
end