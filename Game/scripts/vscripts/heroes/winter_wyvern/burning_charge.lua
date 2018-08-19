require('heroes/winter_wyvern/arctic_burn')

function burning_charge_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	ability.fv = ((target - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	ability.perpFV = WallPhysics:rotateVector(ability.fv, 2*math.pi/4)
	ability.targetPoint = target
	local warpDuration = 3.0
	ability.fallVelocity = 1
	ability.forwardVelocity = 42
	local q_3_level = caster:GetRuneValue("q", 3)
	local max_distance = 500 + q_3_level*12
	ability.max_distance = max_distance
	ability.distance_travelled = 0
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_dinath_scorch_charge_flying", {duration = warpDuration})

	local totalFlyDistance = math.min(WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target), max_distance)
	EmitSoundOn("Dinath.DiveStart", caster)
	EmitSoundOn("Dinath.ChargeVO", caster)
	local charge_duration = totalFlyDistance/30
	ability.fly_distance = totalFlyDistance
	CustomAbilities:QuickAttachParticle("particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_buff.vpcf", caster, charge_duration)	

	local fireThinker = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())
	fireThinker:FindAbilityByName("dummy_unit"):SetLevel(1)
	local fireDuration = get_arctic_burn_fire_duration(caster)
	local arctic_burn = caster:FindAbilityByName("dinath_arctic_burn")
	fireThinker.line = true
	fireThinker.fv = ability.fv
	fireThinker.distance = 0
	ability.interval = 0
	ability.current_fire_thinker = fireThinker
	arctic_burn:ApplyDataDrivenModifier(caster, fireThinker, "modifier_arctic_burn_fire_thinker", {duration = fireDuration})
	ability.fireDuration = fireDuration
end

function burning_charge_think(event)
	local caster = event.caster
	local ability = event.ability

	ability.forwardVelocity = math.max(ability.forwardVelocity - 0.5, 32)

	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+ability.fv*45), caster)
    local forwardSpeed = ability.forwardVelocity
	if blockUnit then
		forwardSpeed = 0
	end
	ability.distance_travelled = ability.distance_travelled + ability.forwardVelocity
	ability.current_fire_thinker.distance = ability.current_fire_thinker.distance + ability.forwardVelocity
	caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.fv*forwardSpeed)

	ability.interval = ability.interval + 1
	if ability.interval%3 == 0 then
		for i = 1, 2, 1 do
			local perpMult = 60
			if i == 2 then
				perpMult = -60
			end
			local position = caster:GetAbsOrigin() + ability.perpFV*perpMult
			local pfx = ParticleManager:CreateParticle("particles/roshpit/dinath/fire_bomb.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(pfx, 0, position)
			ParticleManager:SetParticleControl(pfx, 11, Vector(0.3,0.3,0.3))
			Timers:CreateTimer(ability.fireDuration, function()
				ParticleManager:DestroyParticle(pfx, false)
			end)
		end
	end
	if ability.distance_travelled >= (ability.fly_distance - 5) then
		caster:RemoveModifierByName("modifier_dinath_scorch_charge_flying")
		local slideDuration = ability.forwardVelocity*0.03
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_dinath_scorch_charge_slide", {duration = slideDuration})
	end
end

function burning_charge_sliding(event)
	local caster = event.caster
	local ability = event.ability

	ability.forwardVelocity = math.max(ability.forwardVelocity - 1, 0)

	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+ability.fv*45), caster)
    local forwardSpeed = ability.forwardVelocity
	if blockUnit then
		forwardSpeed = 0
	end
	ability.distance_travelled = ability.distance_travelled + ability.forwardVelocity
	caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.fv*forwardSpeed)
	if ability.forwardVelocity <= 3 then
		caster:RemoveModifierByName("modifier_dinath_scorch_charge_slide")
	end
end