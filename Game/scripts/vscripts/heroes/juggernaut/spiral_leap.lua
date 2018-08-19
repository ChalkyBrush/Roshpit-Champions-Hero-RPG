function spiral_leap_start(event)
	local caster = event.caster
	local ability = event.ability

    local position = event.target_points[1]
    local c_c_level = Runes:GetTotalRuneLevel(caster, 3, "e_3", "monk")
    local maxDistance = c_c_level*5 + 900
    local startPosition = caster:GetAbsOrigin()
    local castedDistance = WallPhysics:GetDistance(startPosition,position)
    local actualDistance = castedDistance
    if castedDistance > maxDistance then
    	local displacementVector = ((position - startPosition)*Vector(1,1,0)):Normalized()
    	position = startPosition + displacementVector*maxDistance
    	actualDistance = maxDistance
    end
    local heightGain = math.min((GetGroundHeight(position, caster) - caster:GetAbsOrigin().z)/10, 20)
    heightGain = math.max(heightGain, - 45)
	ability.liftVelocity = actualDistance/30 + heightGain + 10
	ability.position = position
	ability.propulsion = actualDistance/30 + 20
	ability.forwardVector = ((position - caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
	ability.interval = 0

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_spiral_strike", {duration = 3})
	caster.EFV = ability.forwardVector
	caster:SetForwardVector(Vector(ability.forwardVector.x, ability.forwardVector.y, -math.pi))
	StartAnimation(caster, {duration=3, activity=ACT_DOTA_OVERRIDE_ABILITY_1, rate=1.0})
	EmitSoundOn("juggernaut_jug_ability_omnislash_05", caster)
	caster.w_4_level = Runes:GetTotalRuneLevel(caster, 4, "w_4", "monk")
  	local odachi = caster:FindAbilityByName("odachi_slice")
  	odachi:SetLevel(ability:GetLevel())
  	odachi:SetAbilityIndex(2)
  	caster:SwapAbilities("odachi_slice", "spiral_leap", true, false)
end

function spiral_think(event)
	local caster = event.caster
	local ability = event.ability
	
	if ability.interval % 16 == 0 then
		local particleName = "particles/econ/items/juggernaut/jugg_sword_jade/juggernaut_blade_fury_jade.vpcf"
		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
		ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(pfx, 5, Vector(200, 200, 200))
		Timers:CreateTimer(0.5, function() 
		  ParticleManager:DestroyParticle( pfx, false )
		end) 
		local casterOrigin = caster:GetAbsOrigin()
		StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_OVERRIDE_ABILITY_1, rate=1.0})
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 240, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		local modifierKnockback =
		{
			center_x = casterOrigin.x,
			center_y = casterOrigin.y,
			center_z = casterOrigin.z,
			duration = 0.18,
			knockback_duration = 0.18,
			knockback_distance = 80,
			knockback_height = 15,
		}
	    local damage = caster:GetAverageTrueAttackDamage(caster)
		if #enemies > 0 then
			EmitSoundOn("Hero_Juggernaut.Attack", caster)
			if #enemies > 6 then
				EmitSoundOn("Hero_Juggernaut.Attack", caster)
			end
			if #enemies > 10 then
				EmitSoundOn("Hero_Juggernaut.Attack", caster)
			end
			for _,enemy in pairs(enemies) do
				enemy:AddNewModifier( caster, nil, "modifier_knockback", modifierKnockback )
				Filters:ApplyDamageBasic(enemy,caster,damage,DAMAGE_TYPE_PHYSICAL)
			end
		end 
	end
	local obstruction = WallPhysics:FindNearestObstruction(caster:GetAbsOrigin()*Vector(1,1,0))
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, caster:GetAbsOrigin(), caster)
	local propulsion = ability.propulsion
	local liftVelocity = ability.liftVelocity
	if blockUnit then
		propulsion = 0
	end
	caster:SetAbsOrigin(caster:GetAbsOrigin()+ability.forwardVector*propulsion+Vector(0,0,liftVelocity))
	ability.liftVelocity = ability.liftVelocity - 5
	ability.interval = ability.interval + 1
	local distanceToTarget = WallPhysics:GetDistance(caster:GetAbsOrigin()*Vector(1,1,0), ability.position*Vector(1,1,0))
	if distanceToTarget < 70 then
		caster:RemoveModifierByName("modifier_spiral_strike")
	end
	if ability.interval > 15 then
		if caster:GetAbsOrigin().z < GetGroundHeight(caster:GetAbsOrigin(), caster) + 25 then
			caster:RemoveModifierByName("modifier_spiral_strike")
		end
	end
	ProjectileManager:ProjectileDodge(caster)
end

function spiral_end(event)
	local caster = event.caster
	local ability = event.ability
	WallPhysics:ClearSpaceForUnit(caster, caster:GetAbsOrigin())
	caster:SetForwardVector(ability.forwardVector*Vector(1,1,0))
	EndAnimation(caster)
	caster.EFV = nil
end