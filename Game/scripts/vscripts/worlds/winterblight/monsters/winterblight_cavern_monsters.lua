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

function aoe_ice_vortex_cast(event)
	local caster = event.caster
	local ability = event.ability
	EmitSoundOn("Winterblight.IceVortexAoe", caster)
	local particleName = "particles/units/heroes/hero_ancient_apparition/ancient_ice_vortex.vpcf"
	local duration = event.duration
	local radius = 300
	StartAnimation(caster, {duration=0.6, activity=ACT_DOTA_RAZE_2, rate=1})
	for i = 1, 3, 1 do
		local position = caster:GetAbsOrigin()+RandomVector(RandomInt(100, 1000))
		local modifierName = "aoe_ice_vortex_thinker"
		position = GetGroundPosition(position, caster) + Vector(0,0,20)
		local pfx = CustomAbilities:QuickParticleAtPoint(particleName, position, duration)
		ParticleManager:SetParticleControl(pfx, 5, Vector(radius*2, radius, radius))
		CustomAbilities:QuickAttachThinker(ability, caster, position, modifierName, {duration = duration})
	end
end

function rock_guardian_attack_start(event)
	local caster = event.caster
	StartAnimation(caster, {duration=1, activity=ACT_DOTA_CUSTOM_TOWER_ATTACK, rate=1.7})
	EmitSoundOn("Winterblight.StoneGuardian.Attack", caster)
end

function rock_guardian_attack_land(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	EmitSoundOn("Winterblight.StoneGuardian.AttackLand", target)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_winterblight_rock_tower_stack", {duratio = 5})
	target:ApplyAndIncrementStack(ability, nil, "modifier_winterblight_rock_tower_stack", 1, 5, 5)

	if target:GetModifierStackCount("modifier_winterblight_rock_tower_stack", nil) == 5 then
		target:RemoveModifierByName("modifier_winterblight_rock_tower_stack")
		ability.pushVector = false
		ability.pushVelocity = 30
		ability.tossPosition = caster:GetAbsOrigin()
		ability:ApplyDataDrivenModifier(caster, target, "modifier_heavy_boulder_pushback", {duration = 1})
	end
end

function rock_guardian_die(event)
	local caster = event.caster
	EndAnimation(caster)
	Timers:CreateTimer(0.09, function()
		StartAnimation(caster, {duration=8, activity=ACT_DOTA_CUSTOM_TOWER_DIE, rate=1})
		EmitSoundOn("Winterblight.StoneGuardian.Die", caster)
	end)
	CustomAbilities:QuickParticleAtPoint("particles/radiant_fx/tower_good3_destroy_lvl3.vpcf", caster:GetAbsOrigin(), 3)
	caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,300))
	Winterblight.StoneGuardiansSlain = Winterblight.StoneGuardiansSlain + 1
	if Winterblight.StoneGuardiansSlain == 3 and Winterblight.OutsideCaveSequence == 0 then
		Winterblight:SpawnMerkurio(Vector(-7252, 4283), Vector(0,-1))
	end
end

function rock_guardian_rising_think(event)
	local caster = event.caster
	local ability = event.ability
	if not ability.interval then
		ability.interval = 0
	end
	ability.interval = ability.interval + 1
	if ability.interval%4 == 0 then
		local groundPos = GetGroundPosition(caster:GetAbsOrigin(), caster)
		local pfx2 = ParticleManager:CreateParticle( "particles/econ/events/ti5/teleport_end_dust_ti5.vpcf", PATTACH_CUSTOMORIGIN, Events.GameMaster )
		ParticleManager:SetParticleControl( pfx2, 0, groundPos+Vector(0,0,60))
		ParticleManager:SetParticleControl( pfx2, 1, Vector(200, 200, 200) )
		Timers:CreateTimer(2, function()
			ParticleManager:DestroyParticle(pfx2, false)
			ParticleManager:ReleaseParticleIndex(pfx2)
		end)
	end
	if ability.interval%15 == 0 then
		EmitSoundOn("Winterblight.StoneGuardian.Rising", caster)
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin()+Vector(0,0,2.2))

end

function winter_heavy_boulder_pushback(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	if not ability.pushVector then
		local impactPoint = target:GetAbsOrigin()
		local pushVector = ((impactPoint - ability.tossPosition)*Vector(1,1,0)):Normalized()
		ability.pushVector = pushVector
		EmitSoundOn("Winterblight.StoneAttack", target)
	end
	local obstruction = WallPhysics:FindNearestObstruction(target:GetAbsOrigin())
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, target:GetAbsOrigin(), target)
	local fv = ability.pushVector

	if blockUnit then
		fv = 0
	end
	target:SetAbsOrigin(target:GetAbsOrigin() + fv*ability.pushVelocity)
	ability.pushVelocity = math.max(ability.pushVelocity - 1, 0)
end

function merkurio_attack_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	StartAnimation(caster, {duration=1, activity=ACT_DOTA_ATTACK, rate=1, translate="attack_normal_range"})
end

function winter_heavy_boulder_push_end(event)
	local caster = event.target
	caster.pushVector = false
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
end

function merkurio_think(event)
	local caster = event.caster
	local boundless = caster:FindAbilityByName("monkey_king_boundless_strike")
	boundless:EndCooldown()
end