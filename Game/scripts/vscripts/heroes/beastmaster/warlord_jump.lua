require('heroes/beastmaster/elemental_axes')
require('heroes/beastmaster/warlord_axe_throw')

LinkLuaModifier("modifier_ignore_cast_angle", "modifiers/warlord/modifier_ignore_cast_angle", LUA_MODIFIER_MOTION_NONE)

function jumpStart(event)
	local caster = event.caster
	local ability = event.ability
	ability.liftVelocity = 70
	ability.fallVelocity = 0
	
	Filters:CastSkillArguments(3, caster)
	local targetPoint = event.target_points[1]
	if caster:HasModifier("modifier_warlord_glyph_1_1") then
		swapSkills(event.type, caster, ability)
	end
    local distance = WallPhysics:GetDistance(targetPoint*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
    local jumpFV = ((targetPoint-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
   --print(jumpFV)
    ability.jump_velocity = distance/30 + 15
    ability.jumpFV = jumpFV
    ability.distance = distance
    ability.targetPoint = targetPoint
    ability.lifting = true
    local animationRate = math.min(1100/distance, 2.5)
   --print(animationRate)
    StartAnimation(caster, {duration=0.3+distance/1000, activity=ACT_DOTA_SPAWN, rate=animationRate})
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_warlord_jumping", {duration = 4})
    Timers:CreateTimer(0.3, function()
    	ability.lifting = false
    end)
    
	local info = 
	{
			Ability = ability,
        	EffectName = "particles/units/heroes/hero_tiny/tiny_avalanche_projectile.vpcf",
        	vSpawnOrigin = caster:GetAbsOrigin(),
        	fDistance = distance+100,
        	fStartRadius = 200,
        	fEndRadius = 200,
        	Source = caster,
        	StartPosition = "attach_attack1",
        	bHasFrontalCone = true,
        	bReplaceExisting = false,
        	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        	fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
		vVelocity = ability.jumpFV * ability.jump_velocity*25,
		bProvidesVision = false,
	}
	projectile = ProjectileManager:CreateLinearProjectile(info)
	-- caster:AddNewModifier(caster, ability, "modifier_ignore_cast_angle", {})
    
end

function fireJumpStart(event)
	local caster = event.caster
	local ability = event.ability
	ability.liftVelocity = 70
	ability.fallVelocity = 0
	
	Filters:CastSkillArguments(3, caster)
	local targetPoint = event.target_points[1]
	if caster:HasModifier("modifier_warlord_glyph_1_1") then
		swapSkills(event.type, caster, ability)
	end
    local distance = WallPhysics:GetDistance(targetPoint*Vector(1,1,0), caster:GetAbsOrigin()*Vector(1,1,0))
    local jumpFV = ((targetPoint-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
   --print(jumpFV)
    ability.jump_velocity = distance/20 + 10
    ability.jumpFV = jumpFV
    ability.distance = distance
    ability.targetPoint = targetPoint
    ability.lifting = true
    -- local animationRate = math.min(1100/distance, 2.5)
    --print(animationRate)
    -- StartAnimation(caster, {duration=0.3+distance/1000, activity=ACT_DOTA_SPAWN, rate=animationRate})
    -- ability:ApplyDataDrivenModifier(caster, caster, "modifier_warlord_jumping", {duration = 4})
    Timers:CreateTimer(0.3, function()
    	ability.lifting = false
    end)
    -- caster:AddNewModifier(caster, ability, "modifier_ignore_cast_angle", {})
end

function new_jumping_think(event)
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
		caster:RemoveModifierByName("modifier_warlord_jumping")
		-- caster:RemoveModifierByName("modifier_ignore_cast_angle")
	end
end

function jumpThink(event)
	local caster = event.caster
	local ability = event.ability
	caster:SetAbsOrigin(caster:GetAbsOrigin() +Vector(0,0,ability.liftVelocity))
	ability.liftVelocity = ability.liftVelocity - 6
end

function fallBegin(event)
	local caster = event.caster
	if event.type == "fire" then
		rune_e_3(caster, event.ability)
	end
end

function rune_e_3(caster, ability)
    local runeUnit = caster.runeUnit3
    local runeAbility = runeUnit:FindAbilityByName("warlord_rune_e_3")
    local abilityLevel = runeAbility:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "e_3")
    local totalLevel = abilityLevel + bonusLevel
    if totalLevel > 0 then
 		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
 		local projectileCount = 0
 		ability.e_3_damage = 10000 + totalLevel*15400
	    caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "warlord")
		for _,enemy in pairs(enemies) do
			projectileCount = projectileCount + 1
			c_c_projectile(enemy, caster, ability)
			if projectileCount > 3+totalLevel then
				break
			end
		end	       
    end
end

function c_c_projectile(enemy, caster, ability)
	local info = 
	{
		Target = enemy,
		Source = caster,
		Ability = ability,	
		EffectName = "particles/units/heroes/hero_phoenix/phoenix_base_attack.vpcf",
		StartPosition = "attach_hitloc",
		bDrawsOnMinimap = false, 
	        bDodgeable = true,
	        bIsAttack = false, 
	        bVisibleToEnemies = true,
	        bReplaceExisting = false,
	        flExpireTime = GameRules:GetGameTime() + 4,
		bProvidesVision = true,
		iVisionRadius = 0,
		iMoveSpeed = 1000,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
end

function c_c_projectile_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = ability.e_3_damage
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
end

function fallThink(event)
	local caster = event.caster
	local ability = event.ability
	local position = caster:GetAbsOrigin()
	caster:SetAbsOrigin(position -Vector(0,0,ability.fallVelocity))
	ability.fallVelocity = ability.fallVelocity + 8
	if ability.fallVelocity == 88 then
		StartAnimation(caster, {duration=0.2, activity=ACT_DOTA_TELEPORT_END, rate=1.5})
	end
	if position.z - GetGroundPosition(position, caster).z < 15 then
		caster:RemoveModifierByName("modifier_warlord_falling")
	end
end

function warlordLand(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage

    caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "warlord")

	local radius = event.radius
	local position = caster:GetAbsOrigin()
	local stun_duration = event.stun_duration
	local splitEarthParticle = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
	local pfx = ParticleManager:CreateParticle( splitEarthParticle, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, position )
	ParticleManager:SetParticleControl( pfx, 1, Vector(radius, radius, radius) )
	EmitSoundOn("Hero_Leshrac.Split_Earth", caster)
	WallPhysics:ClearSpaceForUnit(caster, position)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius+5, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_EARTH, RPC_ELEMENT_NONE)
			Filters:ApplyStun(caster, stun_duration, enemy)	
		end
	end 
	Timers:CreateTimer(3.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
end


function fireDashThink(event)
	local caster = event.caster
	local ability = event.ability
	local position = caster:GetAbsOrigin()
	local fv = caster:GetForwardVector()
	local searchPos = Vector(position.x, position.y, GetGroundHeight(position, caster))
	--print("SAERCH POS")
	--print(searchPos)
	local obstruction = WallPhysics:FindNearestObstruction(searchPos+(fv*30))
	local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, searchPos+(fv*30), caster)
	if blockUnit then
		fv = 0
	end

	caster:SetAbsOrigin(position -Vector(0,0,ability.fallVelocity)+fv*ability.jump_velocity)
	ability.fallVelocity = ability.fallVelocity + 6
	if position.z - GetGroundPosition(position, caster).z < 5 then
		caster:RemoveModifierByName("modifier_warlord_falling_fire")
	end
end

function warlordLandFire(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage

    caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "warlord")

	local radius = event.radius
	local position = caster:GetAbsOrigin()+Vector(0,0,200)

	local particleName = "particles/units/heroes/hero_elder_titan/ring_of_fire.vpcf"
      	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      	ParticleManager:SetParticleControl( particle1, 0, position )
      	ParticleManager:SetParticleControl( particle1, 1, position )
      	ParticleManager:SetParticleControl( particle1, 2, position )
      	EmitSoundOn("Hero_OgreMagi.Fireblast.Target", caster)
      	Timers:CreateTimer(2, function()
      		ParticleManager:DestroyParticle(particle1, false)
      	end)
	WallPhysics:ClearSpaceForUnit(caster, position)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius+5, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)	
		end
	end 
	-- caster:RemoveModifierByName("modifier_ignore_cast_angle")
end

function iceSprintStart(event)
	local caster = event.caster
	local ability = event.ability
	ability.forwardVec = caster:GetForwardVector()
	ability.interval = 0
	StartAnimation(caster, {duration=event.duration, activity=ACT_DOTA_RUN, rate=1.2, translate="haste"})
	-- rune_e_2(caster, ability)
	Filters:CastSkillArguments(3, caster)
	if caster:HasModifier("modifier_warlord_glyph_1_1") then
		swapSkills("ice", caster, ability)
	end
	local level = ability:GetLevel()
	caster:MoveToPosition(caster:GetAbsOrigin()+ability.forwardVec*(level/0.03)*25)
	ability.e_2_level = Runes:GetTotalRuneLevel(caster, 2, "e_2", "warlord")
	-- ability.e_2_damage = ability.e_2_level*120 + 300
	ability.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "warlord")
	-- ability.e_2_damage = ability.e_2_damage + 0.0007*(caster:GetStrength()+caster:GetAgility()+caster:GetIntellect())/10*ability.e_4_level*ability.e_2_damage
    -- caster:AddNewModifier(caster, ability, "modifier_ignore_cast_angle", {})
    local iceAxeThrow = caster:FindAbilityByName("axe_throw_ice")
    iceAxeThrow.castPoint = iceAxeThrow:GetCastPoint()
    iceAxeThrow:SetOverrideCastPoint(0)
end


function iceSprintThink(event)
  local caster = event.caster
  local ability = event.ability
  local position = caster:GetAbsOrigin()
  
  ability.interval = ability.interval+1
  position = GetGroundPosition( position, caster )

  local obstruction = WallPhysics:FindNearestObstruction(position)
  local newPosition = position+caster:GetForwardVector()*25
  local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, (position+caster:GetForwardVector()*95), caster)
  if ability.interval%3 == 0 then
  	local baseDamage = event.damage
  	baseDamage = baseDamage + 0.0007*(caster:GetStrength()+caster:GetAgility()+caster:GetIntellect())/10*ability.e_4_level*baseDamage
  	iceSprintBlast(caster, newPosition, event.radius, baseDamage, ability)
  end
  if ability.interval%3 == 0 and ability.e_2_level > 0 then
  	caster:GiveMana(ability.e_2_level*150)
  	PopupMana(caster, ability.e_2_level*150)
  	CustomAbilities:QuickAttachParticle("particles/items3_fx/mango_active.vpcf", caster, 1)
  end
  if not blockUnit then
    caster:SetOrigin(newPosition)
  end
  ProjectileManager:ProjectileDodge(caster)
end

function iceSprintEnd(event)
	local caster = event.caster
	local position = caster:GetAbsOrigin()
	if not caster:IsChanneling() then
		caster:Stop()
	end
	WallPhysics:ClearSpaceForUnit(caster, position)
	-- caster:RemoveModifierByName("modifier_ignore_cast_angle")
    local iceAxeThrow = caster:FindAbilityByName("axe_throw_ice")
    iceAxeThrow:SetOverrideCastPoint(iceAxeThrow.castPoint)
end

function iceSprintBlast(caster, position, radius, damage, ability)
	local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	local pfx = ParticleManager:CreateParticle( particle, PATTACH_WORLDORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, position )
	ParticleManager:SetParticleControl( pfx, 1, Vector(radius, 2, radius*2) )
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then	
		for _,enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_ice_sprint_slow", {duration = 3})
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_E, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
		end
	end
end

function iceSprintBlast_b_c(caster, position, radius, damage, ability)
	local particle = "particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf"
	position = position+RandomVector(RandomInt(90, 600))
	local pfx = ParticleManager:CreateParticle( particle, PATTACH_WORLDORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, position )
	ParticleManager:SetParticleControl( pfx, 1, Vector(radius, 2, radius*2) )
	Timers:CreateTimer(2.5, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then	
		for _,enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, "modifier_ice_sprint_slow", {duration = 3})
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
		end
	end
end