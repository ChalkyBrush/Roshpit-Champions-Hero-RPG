function ghost_warp_start(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	ability.fv = ((target - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	ability.targetPoint = target
	local warpDuration = 3.0
	ability.fallVelocity = 1
	ability.forwardVelocity = 15
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_ghost_warp_flying", {duration = warpDuration})
	if ability.pfx then
		ParticleManager:DestroyParticle(ability.pfx, true)
		ability.pfx = false
	end
    local phaseWalk = caster:FindAbilityByName("phase_walk")
    phaseWalk:SetLevel(ability:GetLevel())
    phaseWalk:SetAbilityIndex(2)
    caster:SwapAbilities("phase_walk", "venomort_ghost_warp", true, false)

    EmitSoundOn("Venomort.GhostWarp", caster)
    local a_c_level = Runes:GetTotalRuneLevel(caster, 1, "a_c", "venomort")
    phaseWalk:ApplyDataDrivenModifier(caster, caster, "modifier_venomort_rune_a_c", {duration = warpDuration})
    caster:SetModifierStackCount( "modifier_venomort_rune_a_c", caster, a_c_level )

    ability.pfx = ParticleManager:CreateParticle("particles/econ/courier/courier_polycount_01/courier_trail_polycount_01.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(ability.pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(ability.pfx, 15, Vector(100, 220, 100))
    Filters:CastSkillArguments(3, caster)
end

function ghost_warping_think(event)
	local caster = event.caster
	local ability = event.ability

	ability.forwardVelocity = ability.forwardVelocity + 0.5

	local blockSearch = caster:GetAbsOrigin()*Vector(1,1,0)+Vector(0,0,GetGroundHeight(caster:GetAbsOrigin(), caster))
    local obstruction = WallPhysics:FindNearestObstruction(blockSearch)
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (blockSearch+ability.fv*45), caster)
    local forwardSpeed = ability.forwardVelocity
	if blockUnit then
		forwardSpeed = 0
	end
	
	caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.fv*forwardSpeed + Vector(0,0,3))
	local distance = WallPhysics:GetDistance2d(ability.targetPoint, caster:GetAbsOrigin())
	if distance < 100 then
		caster:RemoveModifierByName("modifier_ghost_warp_flying")
		caster:RemoveModifierByName("modifier_venomort_rune_a_c")
		if ability.pfx then
			ParticleManager:DestroyParticle(ability.pfx, false)
			ability.pfx = false
		end
	end
end

function after_warp_falling(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetAbsOrigin(caster:GetAbsOrigin()-Vector(0,0,ability.fallVelocity))
	ability.fallVelocity = ability.fallVelocity + 2
	local groundHeight = GetGroundHeight(caster:GetAbsOrigin(), caster)
	if caster:GetAbsOrigin().z - groundHeight < ability.fallVelocity/2 then
		caster:RemoveModifierByName("modifier_end_ghost_warp_falling")
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_SPAWN, rate=1})
	end
end