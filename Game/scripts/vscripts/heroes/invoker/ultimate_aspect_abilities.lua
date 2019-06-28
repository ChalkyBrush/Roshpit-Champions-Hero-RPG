require('heroes/invoker/earthquake')
require('heroes/invoker/arcana/arcana_earth_deity')

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
   --print(jumpFV)
    ability.jump_velocity = distance/30 + 15
    ability.jumpFV = jumpFV
    ability.distance = distance
    ability.targetPoint = targetPoint
    ability.lifting = true
    Timers:CreateTimer(0.3, function()
    	ability.lifting = false
    end)
    if caster.earthDeity then
    	local rate = math.max((1/distance)*1000, 2)
    	rate = math.min(rate, 4)
    	StartAnimation(caster, {duration=1.25, activity=ACT_DOTA_CAST_ABILITY_3, rate=rate})
    	EmitSoundOn("Conjuror.EarthDeity.LiftOff.VO", caster)
    end
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
	--print(ability.jumpFV)
	if caster:GetAbsOrigin().z < GetGroundHeight(caster:GetAbsOrigin(), caster) + 10 and not ability.lifting then
		caster:RemoveModifierByName("modfier_earth_aspect_jumping")
	end
end

function drop_end(keys)
	local caster = keys.caster
	local ability = keys.ability
	local location = caster:GetAbsOrigin()
	local r_1_level = caster.conjuror:GetRuneValue("r", 1)
	FindClearSpaceForUnit(caster, location, false)
	if r_1_level > 0 then
		if caster.conjuror:HasAbility("earthquake") then
			local quakeAbility = caster.conjuror:FindAbilityByName("earthquake")
			local damage = quakeAbility:GetSpecialValueFor("damage")
			fireQuake(location, caster.conjuror, 600, r_1_level*0.1, damage, true, quakeAbility, 1 + 0.3*r_1_level)
		elseif caster.conjuror:HasAbility("arcana_earth_shock") then
			local shockAbility = caster.conjuror:FindAbilityByName("arcana_earth_shock")
			local damage = shockAbility:GetSpecialValueFor("damage")
			damage = damage*(1 + 0.3*r_1_level)
			fire_earth_shock(location, caster.conjuror, 600, shockAbility, damage, 0.1*r_1_level)
			-- fireQuake(location, caster.conjuror, 600, r_1_level*0.1, damage, true, shockAbility, 1 + 0.3*r_1_level)
		end
	end
	if caster.RemoveLeapAbility then
		caster.RemoveLeapAbility = false
		if caster:HasAbility("earth_aspect_quake_leap") then
			caster:RemoveAbility("earth_aspect_quake_leap")
		end
	end
end
