function chronosphere( keys )
	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local target_point = caster:GetAbsOrigin()
	local duration = keys.duration
	local vision_radius = keys.vision_radius
	-- Special Variables

	-- Dummy
	local dummy_modifier = "modifier_chronosphere_aura_datadriven"
	local dummy = CreateUnitByName("npc_dummy_unit", target_point, false, caster, caster, caster:GetTeam())
  	--dummy:NoHealthBar()
  	--dummy:AddAbility("dummy_unit")
  	--dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
	ability:ApplyDataDrivenModifier(caster, dummy, dummy_modifier, {})
	dummy:AddNewModifier(caster, nil, "modifier_phased", {})

	-- Vision
	ability:CreateVisibilityNode(target_point, vision_radius, duration)

	-- Timer to remove the dummy
	Timers:CreateTimer(duration+0.2, function() UTIL_Remove(dummy) end)
      
      --particleName = "particles/units/heroes/hero_faceless_void/faceless_void_chronosphere.vpcf"
      --local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      --ParticleManager:SetParticleControl( particle1, 0, target_point )
      --Timers:CreateTimer(duration, 
      --function()
      --  ParticleManager:DestroyParticle( particle1, false )
      --end)
	ability.radius = vision_radius
	rune_r_1(caster, target_point, ability, duration, vision_radius)
	rune_r_2_level(caster, ability, target_point)
	rune_r_3(caster, ability)
	Filters:CastSkillArguments(4, caster)
end

function rune_r_2_level(caster, ability, target_point)
	  local runeUnit = caster.runeUnit2
	  local runeAbility = runeUnit:FindAbilityByName("paladin_rune_r_2")
	  local abilityLevel = runeAbility:GetLevel()
	  local bonusLevel = Runes:GetTotalBonus(runeUnit, "r_2")
	  local totalLevel = abilityLevel + bonusLevel
	  ability.runeUnit = runeUnit
	  ability.runeAbility_b_d = runeAbility
	  ability.centerPoint = target_point
	  ability.rune_r_2_level = totalLevel
end



function rune_r_1(caster, target_point, ability, duration, radius)
	  local runeUnit = caster.runeUnit
	  local runeAbility = runeUnit:FindAbilityByName("paladin_rune_r_1")
	  local abilityLevel = runeAbility:GetLevel()
	  local bonusLevel = Runes:GetTotalBonus(runeUnit, "r_1")
	  local totalLevel = abilityLevel + bonusLevel
	  if totalLevel > 0 then
		local hammer = CreateUnitByName("prop_unit", target_point, false, caster, caster, caster:GetTeam())
		ability:ApplyDataDrivenModifier(caster, hammer, "modifier_hammer_ghost", {duration = 10})
		local hammerPos = hammer:GetAbsOrigin() +Vector(-220,0,200)
		hammer:SetAbsOrigin(hammerPos)
		hammer:SetForwardVector(Vector(0,1))
    	hammer:AddAbility("replica")
    	hammer:FindAbilityByName("replica"):SetLevel(1)
    	hammer:SetModelScale(2.2)
		Timers:CreateTimer(duration, function() UTIL_Remove(hammer) end)
		ability.hammer = hammer
		ability.hammerPosition = hammerPos
		ability.liftPos = 0
		ability.totalLift = 0
		ability.liftVelocity = 0
		ability.lifting = true
		ability.r_1_level = totalLevel
		ability.caster = caster
		ability.r_4_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "paladin")
		ability.r_4_ability = caster.runeUnit4:FindAbilityByName("paladin_rune_r_4")
	  end
end

function hammer_think(event)
	local ability = event.ability
	if ability.lifting then
		ability.liftVelocity = ability.liftVelocity + 1
		ability.liftPos = ability.liftPos + ability.liftVelocity
		ability.totalLift = ability.totalLift + 10
	else
		ability.liftVelocity = ability.liftVelocity - 1
		ability.liftPos = ability.liftPos + ability.liftVelocity
		ability.totalLift = ability.totalLift + 10
	end
	if ability.totalLift%400 == 100 then
		ability.lifting = false
	end
	if (ability.totalLift+200)%400 == 100 then
		ability.lifting = true
	end
	ability.hammer:SetAbsOrigin(ability.hammerPosition + Vector(0,0,ability.liftPos))
	if ability.totalLift%100 == 0 then
		hammer_strike(ability, ability.hammer, ability.r_1_level, ability.radius, ability.caster)
	end
end

function hammer_strike(ability, hammer, abilityLevel, radius, caster)
	local totalLevel = ability:GetLevel()
	local particleName = "particles/units/heroes/hero_shadowshaman/paladin_rune_q_1.vpcf"
	local damage = 15*abilityLevel

	

	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), hammer:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		EmitSoundOn("Hero_Chen.HandOfGodHealCreep", hammer)
	end
	local d_d_ability = ability.r_4_ability
	local d_d_level = ability.r_4_level
	for _,unit in pairs(enemies) do
		-- Particle
		local origin = unit:GetAbsOrigin()
		local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, hammer)
		ParticleManager:SetParticleControl(lightningBolt,0,Vector(hammer:GetAbsOrigin().x+220,hammer:GetAbsOrigin().y,hammer:GetAbsOrigin().z + hammer:GetBoundingMaxs().z +200 ))	
		ParticleManager:SetParticleControl(lightningBolt,1,Vector(origin.x,origin.y,origin.z + unit:GetBoundingMaxs().z ))
	
		-- Damage
		ApplyDamage({ victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		if d_d_level > 0 then
		    d_d_ability:ApplyDataDrivenModifier(caster.runeUnit4, unit, "modifier_paladin_rune_r_4_effect", {duration = 7})
		    local current_stacks = unit:GetModifierStackCount( "modifier_paladin_rune_r_4_effect", d_d_ability )
		    newStacks = current_stacks + math.ceil(damage/100)*d_d_level
		    unit:SetModifierStackCount( "modifier_paladin_rune_r_4_effect", d_d_ability, newStacks )
		end
		-- Increment counter
		--targets_shocked = targets_shocked + 1
	end
end

function b_d_think(event)
	local ability = event.ability
	local caster = event.caster
	local runeAbility = ability.runeAbility_b_d
	local level = ability.rune_r_2_level
	if level > 0 then
		local allies = FindUnitsInRadius( event.caster:GetTeamNumber(), ability.centerPoint, nil, ability.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		for _,unit in pairs(allies) do
	        local current_stack = unit:GetModifierStackCount( "modifier_paladin_rune_r_2", ability )
	        if not current_stack then
	        	current_stack = 0
	        end
	        ability:ApplyDataDrivenModifier(caster, unit, "modifier_paladin_rune_r_2", {duration = 5})
	        unit:SetModifierStackCount( "modifier_paladin_rune_r_2", ability, current_stack+level )		
		end
	end
end

function rune_r_3(caster, ability)
  local runeUnit = caster.runeUnit3
  local runeAbility = runeUnit:FindAbilityByName("paladin_rune_r_3")
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "r_3")
  local totalLevel = abilityLevel + bonusLevel
  if totalLevel > 0 then
	-- EmitSoundOn("DOTA_Item.BlackKingBar.Activate", caster)
	runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_paladin_rune_r_3_savior", {duration = 8})
	runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_paladin_rune_r_3_buff", {duration = 8})
	caster:SetModifierStackCount( "modifier_paladin_rune_r_3_buff", runeAbility, totalLevel )
  end
end

function c_d_apply(event)
	local caster = event.target
	EmitSoundOn("Hero_Omniknight.GuardianAngel", caster)
	caster:SetRangedProjectileName("particles/units/heroes/hero_skywrath_mage/skywrath_mage_base_attack.vpcf")
	caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	--print("APPLY AVATAR BROOO")
end

function c_d_attack_start(event)
	event.caster:StopSound("Hero_Omniknight.Attack")
end

function c_d_end(event)
	local caster = event.target
	caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
end

function c_d_attack_hit(event)
	local attacker = event.attacker
	local target= event.target
	local ability = event.ability
	ability.r_3_damage = OverflowProtectedGetAverageTrueAttackDamage(attacker)
	ability.r_3_source = attacker
	      local enemies = FindUnitsInRadius( attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE+DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false )
	      if #enemies > 0 then
	      	local count = 0
	        for _,enemy in pairs(enemies) do
	        	if count > 8 then
	        		break
	        	end
	        	if target == enemy then
	        	else
	        		create_split_attack_c_d(attacker, enemy, target, ability, ("particles/units/heroes/hero_skywrath_mage/skywrath_mage_base_attack.vpcf"))
	        		count = count+1
	        	end
	        end  	
		  end
end

function create_split_attack_c_d(attacker, enemy, target, ability, arrowParticle)
	local info = 
	{
		Target = enemy,
		Source = target,
		Ability = ability,	
		EffectName = arrowParticle,
		vSourceLoc= target:GetAbsOrigin(),
		bDrawsOnMinimap = false, 
	        bDodgeable = true,
	        bIsAttack = false, 
	        bVisibleToEnemies = true,
	        bReplaceExisting = false,
	        flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = true,
		iVisionRadius = 0,
		iMoveSpeed = 900,
		iVisionTeamNumber = attacker:GetTeamNumber()
	}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
end

function paladin_rune_r_3_splash_attack_hit(event)
	local caster = event.ability.r_3_source
	local target = event.target
	local damage = event.ability.r_3_damage
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
end

function hammer_throwing_thinker(event)
	local caster = event.caster
	local ability = event.ability
	ability.hammerThrowThinks = ability.hammerThrowThinks + 1
		local rotatedVector = rotateVector(ability.fv, math.pi/30*ability.hammerThrowThinks)
		caster:SetForwardVector(rotatedVector)
	if ability.hammerThrowThinks%2 == 0 then
		EmitSoundOn("Hero_Gyrocopter.ART_Barrage.Launch", caster)
		local spellOrigin = caster:GetAbsOrigin()
		local fv = rotatedVector
		local info = 
		{
			Ability = ability.runeAbility,
	        	EffectName = "particles/econ/items/mirana/mirana_crescent_arrow/paladin_linear_hammer.vpcf",
	        	vSpawnOrigin = spellOrigin,
	        	fDistance = 1450,
	        	fStartRadius = 200,
	        	fEndRadius = 200,
	        	Source = caster,
	        	StartPosition = "attach_attack2",
	        	bHasFrontalCone = true,
	        	bReplaceExisting = false,
	        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	        	fExpireTime = GameRules:GetGameTime() + 7.0,
			bDeleteOnHit = false,
			vVelocity = fv * 800,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)

	end
end

function paladin_rune_r_3_strike(event)
	local target = event.target
	local ability = event.ability
	local caster = ability.origCaster
	local damage = ability.r_3_level*100
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
end

function rotateVector(vector, radians)
   XX = vector.x	
   YY = vector.y
   
   Xprime = math.cos(radians)*XX -math.sin(radians)*YY
   Yprime = math.sin(radians)*XX +math.cos(radians)*YY

   vectorX = Vector(1,0,0)*Xprime
   vectorY = Vector(0,1,0)*Yprime
   rotatedVector = vectorX + vectorY
   return rotatedVector
end