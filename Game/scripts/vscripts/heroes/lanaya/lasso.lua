require('heroes/lanaya/constants')
local glyphs = require('heroes/lanaya/glyphs')

function trapper_lasso_start(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local radius = event.radius
	local pullToPoint = caster:GetAbsOrigin()+caster:GetForwardVector()*90

	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )

	local pullDistance = WallPhysics:GetDistance2d(point, caster:GetAbsOrigin())
	ability.lassoTargetPoint = caster:GetAbsOrigin()
	local netTrap = caster:FindAbilityByName("net_trap")
	if netTrap then
		if netTrap.traps then
			if IsValidEntity(netTrap.traps[1]) then
				local trapLocation = netTrap.traps[1]:GetAbsOrigin()
				local distance = WallPhysics:GetDistance2d(trapLocation, caster:GetAbsOrigin())
				if distance <= 1000 then
					ability.lassoTargetPoint = trapLocation
				end
			end
		end
	end
    ability.lifting = true
    ability.lassoJumpVelocity = pullDistance/25 + 10

    EmitSoundOn("Trapper.LassoCast", caster)

    Timers:CreateTimer(0.3, function()
    	ability.lifting = false
    end)
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			if not enemy.pushLock and not enemy.jumpLock then
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_lasso_pull", {duration = 3.4})
				enemy.lassoLiftSpeed = 32
			end
		end
	else
		local pfx = ParticleManager:CreateParticle( "particles/roshpit/trapper/arcana_lasso.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
		Timers:CreateTimer(0.3, function() 
			ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
		  ParticleManager:DestroyParticle( pfx, false )
		  ParticleManager:ReleaseParticleIndex(pfx)
		end) 
	end
	ability.c_b_level = Runes:GetTotalRuneLevel(caster, 3, "c_b_arcana1", "trapper")
	caster.d_b_arcana_level = Runes:GetTotalRuneLevel(caster, 4, "d_b_arcana1", "trapper")
	Filters:CastSkillArguments(2, caster)
end

function trapper_lasso_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local jumpFV = ((ability.lassoTargetPoint-target:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	local jumpVelocity = ability.lassoJumpVelocity
	local distance = WallPhysics:GetDistance2d(caster:GetAbsOrigin(), target:GetAbsOrigin())
	if distance < 100 then
		if target.lassoLiftSpeed > -2 then
			target.lassoLiftSpeed = -3
		end
		jumpVelocity = 0
	end
	local oldTargetPosition = target:GetAbsOrigin()
	local newTargetPosition = oldTargetPosition + Vector(0,0,target.lassoLiftSpeed) + jumpFV*jumpVelocity
	local travelDistance = WallPhysics:GetDistance(oldTargetPosition, newTargetPosition)
	target:SetAbsOrigin(newTargetPosition)
	target.lassoLiftSpeed = target.lassoLiftSpeed - 2.4
	if ability.c_b_level > 0 then
		local damage = ability.c_b_level * travelDistance/100 * ARCANA1_W3_AGI_DAMAGE * caster:GetAgility()
		Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
	end
	if not ability.lifting then
		if target:GetAbsOrigin().z < GetGroundHeight(target:GetAbsOrigin(), target) + 40 then
			target:RemoveModifierByName("modifier_lasso_pull")
			FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
			Filters:ApplyStun(caster, 1, target)
		end
	end
end

function trapper_poison_whip_start(event)
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local radius = event.radius * glyphs.t51_get_radius_amplify(caster)

	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	Filters:CastSkillArguments(2, caster)
    EmitSoundOn("Trapper.LassoCast", caster)
    ability.a_b_level = Runes:GetTotalRuneLevel(caster, 1, "a_b_arcana1", "trapper")
    EmitSoundOn("Trapper.VenomwhipCast", caster)
    if caster:HasModifier("modifier_trapper_arcana1") then
    	caster.d_b_arcana_level = Runes:GetTotalRuneLevel(caster, 4, "d_b_arcana1", "trapper")
	end
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			local pfx = ParticleManager:CreateParticle("particles/roshpit/trapper/venom_whip.vpcf", PATTACH_POINT_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin()+Vector(0,0,60), true)
			Timers:CreateTimer(0.3, function() 
				ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin()+Vector(0,0,60), true)
			  ParticleManager:DestroyParticle( pfx, false )
			  ParticleManager:ReleaseParticleIndex(pfx)
			end) 
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_poison_whip", {duration = 5})
			local newStacks = enemy:GetModifierStackCount("modifier_poison_whip", caster) + 1
			enemy:SetModifierStackCount("modifier_poison_whip", caster, newStacks)
			EmitSoundOn("Trapper.Venomwhip.Impact", enemy)
		end
	else
			local pfx = ParticleManager:CreateParticle("particles/roshpit/trapper/venom_whip.vpcf", PATTACH_POINT_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
			Timers:CreateTimer(0.3, function() 
				ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
			  ParticleManager:DestroyParticle( pfx, false )
			  ParticleManager:ReleaseParticleIndex(pfx)
			end) 
	end	
end

function poison_whip_think(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local attack_mult = event.attack_mult/100
	local stacks = target:GetModifierStackCount("modifier_poison_whip", caster)
	local damage = caster:GetAverageTrueAttackDamage(caster)*attack_mult*stacks
	Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
end

	-- ParticleManager:SetParticleControlEnt( pfx, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true )
	-- ParticleManager:SetParticleControlEnt( pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
    -- local distance = WallPhysics:GetDistance(targetPoint*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
    -- local jumpFV = ((targetPoint-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
    -- print(jumpFV)
    -- ability.jump_velocity = distance/30 + 15
    -- ability.jumpFV = jumpFV
    -- ability.distance = distance
    -- ability.targetPoint = targetPoint
    -- ability.lifting = true
    -- Timers:CreateTimer(0.3, function()
    -- 	ability.lifting = false
    -- end)