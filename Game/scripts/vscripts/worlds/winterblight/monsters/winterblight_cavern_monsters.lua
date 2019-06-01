function gang_up_think(event)
	local caster = event.caster
	local ability = event.ability
	local radius = 650
	local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )	
	local stacks = 0
	for i = 1, #allies, 1 do
		local ally = allies[1]
		if ally:HasAbility(ability:GetAbilityName()) then
			stacks = stacks + 1
		end
	end
	if stacks > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_gangup_stack", {})
		caster:SetModifierStackCount("modifier_gangup_stack", caster, stacks)
	else
		caster:RemoveModifierByName("modifier_gangup_stack")
	end
end

function damage_sap_attack(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	caster:ApplyAndIncrementStack(ability, caster, "modifier_damage_sap_stack_owner", 1, 0, 8)
	target:ApplyAndIncrementStack(ability, caster, "modifier_damage_sap_stack_enemy", 1, 0, 8)	
end

function relict_jump_pre_start(event)
	local caster = event.caster

	local distance = WallPhysics:GetDistance2d(event.target_points[1], caster:GetAbsOrigin())

	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Winterblight.Relict.Jump", caster)

	EndAnimation(caster)
	StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_3_END, rate=1})
	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_monkey_king/monkey_king_spring_channel_rings.vpcf", caster:GetAbsOrigin()+Vector(0,0,20), 0.6)
	-- StartAnimation(caster, {duration=0.44, activity=ACT_DOTA_MK_SPRING_CAST, rate=1.2})
end

function relict_monkey_jump_start(event)
	local caster = event.caster
	local ability = event.ability
	ability.targetPoint = event.target_points[1] + caster:GetForwardVector()*240
	ability:ApplyDataDrivenModifier(caster, caster,"modifier_monkey_jump", {duration = 4})
	local distance = WallPhysics:GetDistance2d(ability.targetPoint, caster:GetAbsOrigin())
	ability.jumpVelocity = distance/20
	ability.liftVelocity = 20
	local heightDiff = caster:GetAbsOrigin().z - ability.targetPoint.z
	if heightDiff > 300 then
		heightDiff = 300
	elseif heightDiff < -300 then
		heightDiff = -300
	end
	ability.liftVelocity = ability.liftVelocity - heightDiff/20
	ability.rising = true
	ability.jumpFV = ((ability.targetPoint - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()

	ability.interval = 0
end

function relict_jump_think(event)
	local caster = event.caster
	local ability = event.ability

	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), ability.targetPoint)

	local fv = ability.jumpFV
	-- if distance < 60 then
	-- 	fv = Vector(0,0)
	-- end
	local height = (caster:GetAbsOrigin().z - GetGroundHeight(caster:GetAbsOrigin(), caster))
	if height < math.abs(ability.liftVelocity) then
		print(height)
		if not ability.rising then
			caster:RemoveModifierByName("modifier_monkey_jump")
		end
	end

	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+ability.jumpFV*30), caster)
	if blockUnit then
		fv = Vector(0,0)
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin() + fv*ability.jumpVelocity + Vector(0,0,ability.liftVelocity))
	ability.liftVelocity = ability.liftVelocity - 2
	if ability.liftVelocity <= 0 then
		ability.rising = false
	end
	ability.interval = ability.interval + 1
	if ability.interval%3 == 0 then
		-- local pfx = ParticleManager:CreateParticle("particles/roshpit/arkimus/jump_fade.vpcf", PATTACH_CUSTOMORIGIN, caster)
		-- ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
		-- Timers:CreateTimer(0.4, function()
		-- 	ParticleManager:DestroyParticle(pfx, false)
		-- end)
	end
end

function relict_jump_end(event)
	local caster = event.caster
	local ability = event.ability
	EndAnimation(caster)
	CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_monkey_king/monkey_king_spring_channel_rings.vpcf", caster:GetAbsOrigin()+Vector(0,0,20), 0.6)
	Timers:CreateTimer(0.03, function()
		StartAnimation(caster, {duration=1, activity=ACT_DOTA_TELEPORT_END, rate=1})
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
	end)
end

