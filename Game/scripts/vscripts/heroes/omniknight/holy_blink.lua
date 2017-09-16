function begin_holy_blink(event)
	local caster = event.caster
	local ability = event.ability
	abilityLevel = ability:GetLevel()
	ability.forwardVector = caster:GetForwardVector()
	--ability.location = caster:GetOrigin() + caster:GetForwardVector()*Vector(400,400)
	caster.holy_lift_velocity = 50
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	EmitSoundOn("Hero_Omniknight.GuardianAngel", caster)
	EmitSoundOn("Hero_Omniknight.GuardianAngel", caster)
	ability.jump_level = 0
	ability.explosions_fired = 0
	Filters:CastSkillArguments(3, caster)
	caster.EFV = ability.forwardVector
end

function lift_think(keys)
	
	local caster = keys.caster
	local ability = keys.ability
	local modifier = caster:FindModifierByName("modifier_holy_blink_lift")
	local origin = caster:GetAbsOrigin()
	
	if not caster.holy_lift_velocity then
		caster.holy_lift_velocity = 50
	end
	local obstruction = WallPhysics:FindNearestObstruction(origin*Vector(1,1,0))
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, origin*Vector(1,1,0), caster)
    local forwardSpeed = 25
    if blockUnit then
    	forwardSpeed = 0
    end
     print("FORWARD SPEED UP")
    print(forwardSpeed)   
	local newPosition = origin+Vector(0,0,caster.holy_lift_velocity)+ability.forwardVector*forwardSpeed
	caster.holy_lift_velocity = math.max(caster.holy_lift_velocity - 3, 0)
	caster:SetAbsOrigin(newPosition)
	--if origin.z - groundPosition.z > -200 then
	--	caster:SetAbsOrigin(groundPosition)
	--end
end

function land_damage(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = event.damage
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 3)
end

function begin_drop(event)
	local caster = event.caster
	local ability = event.ability
	caster.holy_lift_velocty = 0
	--caster:SetOrigin(ability.blink_position)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_holy_blink_drop", nil)
	rune_c_c(caster, ability)
end

function drop_think(keys)
	local ability = keys.ability
	local caster = keys.caster
	local modifier = caster:FindModifierByName("modifier_holy_blink_drop")
	local origin = caster:GetAbsOrigin()
	
	if not caster.holy_lift_velocity then
		caster.holy_lift_velocity = 0
	end
	local obstruction = WallPhysics:FindNearestObstruction(origin*Vector(1,1,0))
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, origin*Vector(1,1,0), caster)
    local forwardSpeed = 25
    if blockUnit then
    	forwardSpeed = 0
    end
    print(blockUnit)
    print("FORWARD SPEED")
    print(forwardSpeed)
	local newPosition = origin+Vector(0,0,-caster.holy_lift_velocity)+ability.forwardVector*forwardSpeed
	caster.holy_lift_velocity = math.min(caster.holy_lift_velocity + 3, 50)
	caster:SetAbsOrigin(newPosition)
	if ability.jump_level == 0 then
		if newPosition.z - GetGroundPosition(newPosition, caster).z < 250 then
			caster:RemoveModifierByName("modifier_holy_blink_drop")
		end
	else
		if newPosition.z - GetGroundPosition(newPosition, caster).z < -50 then
			caster:RemoveModifierByName("modifier_holy_blink_drop")
		end
		if newPosition.z - GetGroundPosition(newPosition, caster).z < 400 and ability.explosions_fired == 0 then
			ability.explosions_fired = 1
			--begin_explosion(caster, ability, newPosition+ability.forwardVector*300)
			EmitSoundOn("Hero_Chen.PenitenceImpact", caster)
		end
	end

end

function drop_end(keys)
	local caster = keys.caster
	local ability = keys.ability
	local location = caster:GetAbsOrigin()
	local newLoc = GetGroundPosition(location, caster)
	print("****DROP END****")
	--FindClearSpaceForUnit(caster, newLoc, true)
  	--Timers:CreateTimer(0.5, -- Start this timer 10 game-time seconds later
    --function()
    --  caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
    --end)
	if ability.jump_level == 0 then
		ability.jump_level = 1
		caster.holy_lift_velocity = 50
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_holy_blink_lift", nil)
		EmitSoundOn("Hero_Omniknight.GuardianAngel", caster)
	else
		caster.holy_slide_velocity = 25
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_holy_blink_slide", nil)
		local obstruction = WallPhysics:FindNearestObstruction(newLoc*Vector(1,1,0))
	    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newLoc*Vector(1,1,0), caster)
	    if blockUnit then
	    else
			caster:SetOrigin(newLoc)
		end
	end
	rune_c_c(caster, ability)
	
end

function slide_think(keys)
	local ability = keys.ability
	local caster = keys.caster
	local modifier = caster:FindModifierByName("modifier_holy_blink_slide")
	local origin = caster:GetAbsOrigin()
	
	if not caster.holy_slide_velocity then
		caster.holy_slide_velocity = 25
	end

	caster.holy_slide_velocity = math.max(caster.holy_slide_velocity - 3, 0)
	local newPosition = origin+ability.forwardVector*caster.holy_slide_velocity
	local groundPosition = GetGroundPosition( newPosition, caster )
	local obstruction = WallPhysics:FindNearestObstruction(origin*Vector(1,1,0))
    local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, origin*Vector(1,1,0), caster)
    if blockUnit then
    else
    	caster:SetAbsOrigin(groundPosition)
    end
	

end

function slide_end(keys)

	local caster = keys.caster
	local location = caster:GetAbsOrigin()
	local ability = keys.ability
	local newLoc = GetGroundPosition(location, caster)
	rune_d_c(caster, ability)
	caster:SetOrigin(newLoc)
	FindClearSpaceForUnit(caster, newLoc, true)
  	Timers:CreateTimer(0.5, -- Start this timer 10 game-time seconds later
    function()
      caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
    end)
    caster.EFV = nil
	
end

function rune_c_c(caster, ability)
  local runeUnit = caster.runeUnit3
  local runeAbility = runeUnit:FindAbilityByName("paladin_rune_c_c")
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_c")
  local totalLevel = abilityLevel + bonusLevel
  if totalLevel > 0 then
  	local position = caster:GetAbsOrigin()
  	local radius = 650	
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	ability.projectileDamage = 300 + totalLevel*80
	if #enemies > 0 then
		local projectileCount = 0
		for _,enemy in pairs(enemies) do
			local info = 
			{
				Target = enemy,
				Source = caster,
				Ability = ability,	
				EffectName = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt.vpcf",
				StartPosition = "attach_hitloc",
				bDrawsOnMinimap = false, 
			        bDodgeable = true,
			        bIsAttack = false, 
			        bVisibleToEnemies = true,
			        bReplaceExisting = false,
			        flExpireTime = GameRules:GetGameTime() + 4,
				bProvidesVision = true,
				iVisionRadius = 0,
				iMoveSpeed = 400,
				iVisionTeamNumber = caster:GetTeamNumber()
			}
			projectile = ProjectileManager:CreateTrackingProjectile(info)
			projectileCount = projectileCount + 1
			if projectileCount == totalLevel + 2 then
				break
			end
		end
	end  	
  end
end

function paladin_rune_c_c_strike(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local damage = ability.projectileDamage
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
end

function rune_d_c(caster, ability)
	local d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "paladin")
	if not ability.projectileDamage then
		ability.projectileDamage = 0
	end
	if d_c_level > 0 then
		local position = caster:GetAbsOrigin()
		local runeAbility = caster.runeUnit4:FindAbilityByName("paladin_rune_d_c")
		runeAbility.paladin = caster
		runeAbility.projectileDamage = ability.projectileDamage
		runeAbility.d_c_level = d_c_level
		local particleName = "particles/econ/items/enigma/enigma_world_chasm/paladin_d_c_ring_spiral.vpcf"
		  local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, caster )
		  ParticleManager:SetParticleControl( particle1, 0, caster:GetAbsOrigin()+Vector(0,0,50) )

		  	local dummy = CreateUnitByName("npc_dummy_unit", position, true, caster, caster, caster:GetTeamNumber())
		  	dummy.owner = caster:GetPlayerOwnerID()
		  	dummy:NoHealthBar()
		  	dummy:AddAbility("dummy_unit")
		  	dummy:FindAbilityByName("dummy_unit"):SetLevel(1)

		  Timers:CreateTimer(10, 
		  function()
		    ParticleManager:DestroyParticle( particle1, false )
		    Timers:CreateTimer(0.5, function()
		    	UTIL_Remove(dummy)
		    end)
		  end)
		  for i = 0, 10, 1 do
		  	Timers:CreateTimer(i, function()
		  		local targets = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY+DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		  		for j = 1, #targets, 1 do
		  			d_c_projectile(dummy, runeAbility, targets[j], position)
		  		end
		  	end)
		  end
	end
end

function d_c_projectile(caster, runeAbility, target, position)
	
			local info = 
			{
				Target = target,
				Source = caster,
				Ability = runeAbility,	
				EffectName = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt.vpcf",
				StartPosition = "attach_origin",
				vSpawnOrigin = position+Vector(0,0,200),
				bDrawsOnMinimap = false, 
			        bDodgeable = true,
			        bIsAttack = false, 
			        bVisibleToEnemies = true,
			        bReplaceExisting = false,
			        flExpireTime = GameRules:GetGameTime() + 4,
				bProvidesVision = true,
				iVisionRadius = 0,
				iMoveSpeed = 480,
				iVisionTeamNumber = caster:GetTeamNumber()
			}
			projectile = ProjectileManager:CreateTrackingProjectile(info)
end

function d_c_projectile_hit(event)
	print("HIT")
	local ability = event.ability
	local caster = ability.paladin
	local target = event.target
	if target:GetTeamNumber() == caster:GetTeamNumber() then
		local healAmount = math.floor(ability.projectileDamage * 0.1 * ability.d_c_level)
		
		target:Heal(healAmount, caster)
		PopupHealing(target, healAmount)
	else
		print('d_c_projectile damage')
		local damage = ability.projectileDamage * 0.5 * ability.d_c_level
		print(damage)
		ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
	end
end