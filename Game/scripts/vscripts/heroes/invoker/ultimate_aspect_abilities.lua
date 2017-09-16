require('heroes/invoker/earthquake')

function begin_ultimate_jump(event)
	local caster = event.caster
	local ability = event.ability
	abilityLevel = ability:GetLevel()
	--ability.location = caster:GetOrigin() + caster:GetForwardVector()*Vector(400,400)

	caster:StartGesture(ACT_DOTA_SPAWN)


    ability:ApplyDataDrivenModifier(caster, caster, "modfier_earth_aspect_jumping", {duration = 8})
    local targetPoint = event.target_points[1]
    local distance = WallPhysics:GetDistance(targetPoint*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
    local jumpFV = ((targetPoint-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
    print(jumpFV)
    ability.jump_velocity = distance/30 + 15
    ability.jumpFV = jumpFV
    ability.distance = distance
    ability.targetPoint = targetPoint
    ability.lifting = true
    Timers:CreateTimer(0.3, function()
    	ability.lifting = false
    end)
end

function earth_aspect_jumping_think(event)
	local caster = event.caster
	local ability = event.ability
	local forwardSpeed  = ability.distance/60 + 15
	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+ability.jumpFV*35), caster)
	if blockUnit then
		forwardSpeed = 0
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,ability.jump_velocity)+ability.jumpFV*forwardSpeed)
	ability.jump_velocity = ability.jump_velocity - 3.3
	print(ability.jumpFV)
	if caster:GetAbsOrigin().z < GetGroundHeight(caster:GetAbsOrigin(), caster) + 10 and not ability.lifting then
		caster:RemoveModifierByName("modfier_earth_aspect_jumping")
	end
end

function drop_end(keys)
	local caster = keys.caster
	local ability = keys.ability
	local location = caster:GetAbsOrigin()
	local a_d_level = Runes:GetTotalRuneLevel(caster.conjuror, 1, "a_d", "conjuror")
	FindClearSpaceForUnit(caster, location, false)
	if a_d_level > 0 then
		local quakeAbility = caster.conjuror:FindAbilityByName("earthquake")
		local damage = quakeAbility:GetSpecialValueFor("damage")
		fireQuake(location, caster.conjuror, 600, a_d_level*0.1, damage, true, quakeAbility, 1 + 0.3*a_d_level)
	end
	if caster.RemoveLeapAbility then
		caster.RemoveLeapAbility = false
		if caster:HasAbility("earth_aspect_quake_leap") then
			caster:RemoveAbility("earth_aspect_quake_leap")
		end
	end
end
