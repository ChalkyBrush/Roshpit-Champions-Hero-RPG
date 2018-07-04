function begin_backshock(event)
	local caster = event.caster
	local ability = event.ability
	local location = caster:GetOrigin() - caster:GetForwardVector()*Vector(-100, -100, 0)
	local abilityLevel = ability:GetLevel()
	ability.root_duration_level = rune_b_b(caster)
	ability.speed = event.speed
	ability.damage = event.damage
	rune_a_b(caster, ability)
	ability.c_b_level = rune_c_b(caster, ability)
	local backVector = rotateVector(caster:GetForwardVector(), math.pi)

	if caster:HasModifier("modifier_axe_glyph_2_1") then
		for i = -4, 4, 1 do
			local shockVector = WallPhysics:rotateVector(backVector, (math.pi/4.5)*i)
			create_shock(ability, caster, shockVector, location)
		end
	else
		create_shock(ability, caster, backVector, location)
		local rotatedVector = rotateVector(backVector, math.pi/6)
		create_shock(ability, caster, rotatedVector, location)
		rotatedVector = rotateVector(backVector, -math.pi/6)
		create_shock(ability, caster, rotatedVector, location)
	end
	if caster:HasModifier("modifier_axe_glyph_4_1") then
		StartAnimation(caster, {duration=0.24, activity=ACT_DOTA_CAST_ABILITY_3, rate=1.3, translate="blood_chaser"})
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		local damage = caster:GetAverageTrueAttackDamage(caster)*4
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				Filters:ApplyDamageBasic(enemy,caster,damage,DAMAGE_TYPE_PHYSICAL)
			end
		end 
		EmitSoundOn("RedGeneral.Helix", caster)
		CustomAbilities:QuickAttachParticle("particles/econ/items/axe/axe_weapon_bloodchaser/axe_attack_blur_counterhelix_bloodchaser.vpcf", caster, 0.5)
	end
	if ability.c_b_level > 0 then
		local healAmount = ability.c_b_level*500
		Filters:ApplyHeal(caster, caster, healAmount, true)
		-- PopupHealing(caster, healAmount)
	end
	if caster:HasModifier("modifier_axe_rune_d_c_furnace") then
		local currentStacks = caster:GetModifierStackCount("modifier_axe_rune_d_c_furnace", caster)
		local whirlwind = caster:FindAbilityByName("whirlwind")
		if not whirlwind.d_c_extra_fire then
			whirlwind.d_c_extra_fire = 0
		end
		if not caster:HasModifier("modifier_axe_rune_d_c_extra_stacks") then
			whirlwind.d_c_extra_fire = 0
		end
		if caster:HasModifier("modifier_axe_rune_d_c_extra_stacks") then
			whirlwind.d_c_extra_fire = math.max(whirlwind.d_c_extra_fire, 1)
		end
		local fireballsShot = math.min(whirlwind.d_c_extra_fire + 1, currentStacks)
		print(fireballsShot)
		for i = 1, fireballsShot, 1 do
			local j = i - 1
			local dc_fv = WallPhysics:rotateVector(caster:GetForwardVector(), 2*math.pi*j/(15*fireballsShot))
			createFireBall_d_c(whirlwind, dc_fv, caster, caster:GetAbsOrigin())
		end
		if caster:HasModifier("modifier_axe_rune_d_c_extra_stacks") then
			whirlwind.d_c_extra_fire = whirlwind.d_c_extra_fire + 1
		else
			whirlwind.d_c_extra_fire = 0
		end
		local newStacks = math.max(0, currentStacks-fireballsShot)
		if newStacks > 0 then
			caster:SetModifierStackCount("modifier_axe_rune_d_c_furnace", caster, newStacks)
		else
			caster:RemoveModifierByName("modifier_axe_rune_d_c_furnace")
		end
		local duration = Filters:GetAdjustedBuffDuration(caster, 0.5, false)
		whirlwind:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_d_c_extra_stacks", {duration = duration})
		
	end
	Filters:CastSkillArguments(2, caster)
end

function createFireBall_d_c(ability, fv, caster, casterOrigin)
  local start_radius = 140
  local end_radius = 140
  local range = 1300
  local speed = 900
    local info = 
    {
        Ability = ability,
            EffectName = "particles/roshpit/warlord/fire_ulti_linear.vpcf",
            vSpawnOrigin = casterOrigin+Vector(0,0,120),
            fDistance = range,
            fStartRadius = start_radius,
            fEndRadius = end_radius,
            Source = caster,
            StartPosition = "attach_hitloc",
            bHasFrontalCone = true,
            bReplaceExisting = false,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            fExpireTime = GameRules:GetGameTime() + 5.0,
      bDeleteOnHit = true,
      vVelocity = fv*Vector(1,1,0) * speed,
      bProvidesVision = false,
    }
    projectile = ProjectileManager:CreateLinearProjectile(info)
end

function rune_a_b(caster, ability)
	local runeUnit = caster.runeUnit
	local runeAbility = runeUnit:FindAbilityByName("axe_rune_a_b")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_b")
	local totalLevel = abilityLevel + bonusLevel
	if totalLevel > 0 then
		heel_stomp(caster, ability, totalLevel)
	end
end

function heel_stomp(caster, ability, totalLevel)
	local particleName = "particles/units/heroes/hero_brewmaster/general_heel_stomp.vpcf"
      	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      	local origin = caster:GetAbsOrigin()
      	ParticleManager:SetParticleControl( particle1, 0, origin )
      	ParticleManager:SetParticleControl( particle1, 1, Vector(300,300,300) )
      	ParticleManager:SetParticleControl( particle1, 2, Vector(300,300,300) )
      	ParticleManager:SetParticleControl( particle1, 3, Vector(300,300,300) )
      	ParticleManager:SetParticleControl( particle1, 4, Vector(300,300,300) )
      	ParticleManager:SetParticleControl( particle1, 5, Vector(300,300,300) )
      	ParticleManager:SetParticleControl( particle1, 6, Vector(300,300,300) )
      	ParticleManager:SetParticleControl( particle1, 7, Vector(300,300,300) )
      	ParticleManager:SetParticleControl( particle1, 8, Vector(300,300,300) )
      	ParticleManager:SetParticleControl( particle1, 9, Vector(300,300,300) )
      	Timers:CreateTimer(2, function()
      		ParticleManager:DestroyParticle( particle1, false )
      	end)
      	if not caster:HasModifier("modifier_axe_glyph_4_1") then
      		StartAnimation(caster, {duration=0.2, activity=ACT_DOTA_RUN, rate=1, translate="start"})
      	end
      	local radius = 300
      	local damage = totalLevel*350
	    local d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "axe")
	    damage = damage + 0.0003*caster:GetStrength()/10*d_b_level*damage
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), origin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
				if d_b_level > 0 then
					Filters:ApplyStun(caster, 0.01*d_b_level, enemy)
				end
			end
		end 
end

function rune_b_b(caster)
	local runeUnit = caster.runeUnit2
	local ability = runeUnit:FindAbilityByName("axe_rune_b_b")
	local abilityLevel = ability:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_b")
	local totalLevel = abilityLevel + bonusLevel
	if not totalLevel then
		totalLevel = 0
	end
	return totalLevel
end

function rune_c_b(caster, ability)
	local runeUnit = caster.runeUnit3
	local runeAbility = runeUnit:FindAbilityByName("axe_rune_c_b")
	local abilityLevel = runeAbility:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_b")
	local totalLevel = abilityLevel + bonusLevel
	ability.runeAbility_c_b = runeAbility
	runeAbility.totalLevel = totalLevel
	if not totalLevel then
		totalLevel = 0
	end
	return totalLevel
end

function create_shock(ability, caster, shotVector, casterOrigin)
		local start_radius = 110
		local end_radius = 300
		local range = 800
		local speed = ability.speed
		if not speed then
			speed = 600
		end
		--EmitSoundOn("Hero_Magnataur.ShockWave.Particle", caster)
		local info = 
		{
				Ability = ability,
		    	EffectName = "particles/units/heroes/hero_magnataur/red_general_shockwave.vpcf",
		    	vSpawnOrigin = casterOrigin,
		    	fDistance = range,
		    	fStartRadius = start_radius,
		    	fEndRadius = end_radius,
		    	Source = caster,
		    	StartPosition = "attach_origin",
		    	bHasFrontalCone = true,
		    	bReplaceExisting = false,
		    	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		    	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		    	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		    	fExpireTime = GameRules:GetGameTime() + 5.0,
			bDeleteOnHit = false,
			vVelocity = shotVector * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)	
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

function shock_strike(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local damage = ability.damage
	if caster:HasModifier("modifier_axe_rune_c_d") then
	    local runeUnit = caster.runeUnit3
	    local runeAbility = runeUnit:FindAbilityByName("axe_rune_c_d")
		local current_stack = caster:GetModifierStackCount( "modifier_axe_rune_c_d", runeAbility )
		damage = damage*(1+current_stack/10)
	end
	if event.amp then
		damage = damage*event.amp
	end
    local d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "axe")
    damage = damage + 0.0003*caster:GetStrength()/10*d_b_level*damage
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)

	-- if ability.c_b_level > 0 then
	-- 	tracking_c_b_projectile(caster, target, ability)
	-- end
	if ability.root_duration_level then
		if ability.root_duration_level > 0 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_backshock_root", {duration = ability.root_duration_level*0.05 + 0.2})
		end
	end
end

function tracking_c_b_projectile(caster, enemy, ability)
	local info = 
	{
		Target = caster,
		Source = enemy,
		Ability = ability.runeAbility_c_b,	
		EffectName = "particles/base_attacks/ranged_tower_bad.vpcf",
		vSourceLoc= enemy:GetAbsOrigin(),
		bDrawsOnMinimap = false, 
	        bDodgeable = false,
	        bIsAttack = false, 
	        bVisibleToEnemies = true,
	        bReplaceExisting = false,
	        flExpireTime = GameRules:GetGameTime() + 2,
		bProvidesVision = true,
		iVisionRadius = 0,
		iMoveSpeed = 1600,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	projectile = ProjectileManager:CreateTrackingProjectile(info)
end

function c_b_projectile_hit(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local totalLevel = ability.totalLevel
	local duration = Filters:GetAdjustedBuffDuration(caster, 4, false)
    ability:ApplyDataDrivenModifier(caster, target, "modifier_axe_rune_c_b_visible", {duration = duration})
    local current_stack = target:GetModifierStackCount( "modifier_axe_rune_c_b_visible", ability )
    --if current_stack < 21 then
    	target:SetModifierStackCount( "modifier_axe_rune_c_b_visible",  ability, current_stack + 1 )
    	ability:ApplyDataDrivenModifier(caster, target, "modifier_axe_rune_c_b_invisible", {duration = duration})
    	target:SetModifierStackCount( "modifier_axe_rune_c_b_invisible", ability, current_stack*totalLevel )
	--end
end