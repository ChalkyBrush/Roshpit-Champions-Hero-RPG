function begin_gale_nova(event)
	local caster = event.caster
	local ability = event.ability
	local location = caster:GetAbsOrigin()
	local abilityLevel = ability:GetLevel()
	local heroName = caster:GetName()

	if event.a_d_level then
		ability.a_d_level = event.a_d_level
	end
	caster.d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "venomort")
	rune_a_a(location, ability, caster)
	local fv = caster:GetForwardVector()
	for i = -4, 4, 1 do
		local rotatedVector = WallPhysics:rotateVector(fv, i*math.pi/4)
		create_gale_two(rotatedVector, caster, ability, location)
	end
	if caster:HasModifier("modifier_venomort_glyph_1_1") then
		ability:EndCooldown()
		ability:StartCooldown(1.5)
	end
	Filters:CastSkillArguments(1, caster)
	local casterOrigin = caster:GetAbsOrigin()
	local modifierKnockback =
	{
		center_x = casterOrigin.x,
		center_y = casterOrigin.y,
		center_z = casterOrigin.z,
		duration = 0.6,
		knockback_duration = 0.5,
		knockback_distance = event.knockback_distance,
		knockback_height = 150
	}
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 375, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			if not enemy.jumpLock then
				enemy:AddNewModifier( caster, nil, "modifier_knockback", modifierKnockback )
			end
		end
	end 	
end

function cobra_invasion_think(event)
	local caster = event.caster
	local ability = caster:FindAbilityByName("gale_nova")
	local a_d_level = Runes:GetTotalRuneLevel(caster, 1, "a_d", "venomort")
	if a_d_level > 0 then
		local galeData = {}
		galeData.caster = caster
		galeData.ability = caster:FindAbilityByName("gale_nova")
		galeData.a_d_level = a_d_level
		begin_gale_nova(galeData)
	end
end

function create_gale_two(fv, caster, ability, position)
	local projectileParticle = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf"
	local projectileOrigin = position + fv*10
	local start_radius = 220
	local end_radius = 220
	local range = 600
	local speed = 1200
		local info = 
		{
				Ability = ability,
	        	EffectName = projectileParticle,
	        	vSpawnOrigin = projectileOrigin+Vector(0,0,60),
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
	        	fExpireTime = GameRules:GetGameTime() + 4.0,
			bDeleteOnHit = false,
			vVelocity = fv * speed,
			bProvidesVision = false,
		}
		projectile = ProjectileManager:CreateLinearProjectile(info)
end

function gale_hit(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = event.damage
	local dot_duration = event.duration
	if ability.a_d_level > 0 then
		damage = damage*ability.a_d_level*0.025
	end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_gale_nova_target", {duration = dot_duration})
	Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
end

function gale_dot_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local damage = event.tick_damage
	Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
end

function create_gale(abilityLevel, caster, targetPoint, casterOrigin)
  	local dummy = CreateUnitByName("npc_dummy_unit", casterOrigin, true, caster, caster, caster:GetTeamNumber())
  	dummy.owner = caster:GetPlayerOwnerID()

  	dummy:AddAbility("custom_gale")
  	dummy:NoHealthBar()
  	dummy:AddAbility("dummy_unit")
  	dummy:FindAbilityByName("dummy_unit"):SetLevel(1)

  	local blast = dummy:FindAbilityByName("custom_gale")
  	blast:SetLevel(abilityLevel)
	local order =
	{
		UnitIndex = dummy:GetEntityIndex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = blast:GetEntityIndex(),
		Position = targetPoint,
		Queue = true
	}
	print("Throwing gale:")
	print(targetPoint)
	ExecuteOrderFromTable(order)
	  Timers:CreateTimer(10, -- Start this timer 10 game-time seconds later
	  function()
		dummy:RemoveSelf() 
	  end)
end

function rune_a_a(location, ability, caster)
    local runeUnit = caster.runeUnit
    local runeAbility = runeUnit:FindAbilityByName("venomort_rune_a_a")
    local abilityLevel = runeAbility:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_a")
    local totalLevel = abilityLevel + bonusLevel
    if totalLevel > 0 then
		ability.a_a_dps = 30*totalLevel + 100
		-- ability.a_a_dps = ability.a_a_dps + ability.d_b_level*caster:GetAverageTrueAttackDamage(caster)/100*0.0006*ability.a_a_dps
		new_a_a_nova(caster, totalLevel, location, ability)
    end
end

function new_a_a_nova(caster, totalLevel, location, ability)
	local radius = 500 + totalLevel*5
	if radius > 900 then
		radius = 900
	end
	radius = radius + 40
	local particleName = "particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf"
  	local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
  	local origin = caster:GetAbsOrigin()
  	ParticleManager:SetParticleControl( particle1, 0, origin )
  	ParticleManager:SetParticleControl( particle1, 1, Vector(radius,1.7,radius) )
  	ParticleManager:SetParticleControl( particle1, 2, Vector(0,0,0) )
  	-- ParticleManager:SetParticleControl( particle1, 3, Vector(radius,radius,radius) )
  	-- ParticleManager:SetParticleControl( particle1, 4, Vector(radius,radius,radius) )
  	-- ParticleManager:SetParticleControl( particle1, 5, Vector(radius,radius,radius) )
  	-- ParticleManager:SetParticleControl( particle1, 6, Vector(radius,radius,radius) )
  	-- ParticleManager:SetParticleControl( particle1, 7, Vector(radius,radius,radius))
  	-- ParticleManager:SetParticleControl( particle1, 8, Vector(radius,radius,radius))
  	-- ParticleManager:SetParticleControl( particle1, 9, Vector(radius,radius,radius) )
  	Timers:CreateTimer(2, function()
  		ParticleManager:DestroyParticle( particle1, false )
  	end)
  	local d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "venomort")
  	for i = 1, 4, 1 do
	  	Timers:CreateTimer(0.45*i, function()
			local enemies = FindUnitsInRadius( caster:GetTeamNumber(), location, nil, radius/(5-i), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					local current_stack = enemy:GetModifierStackCount( "modifier_a_a_nova", ability )
					print("POISON STACK"..current_stack)
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_a_a_nova", {duration = 7})
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_a_a_nova_status", {duration = 7})
					enemy:SetModifierStackCount( "modifier_a_a_nova",  ability, current_stack + 1 )
					if d_a_level > 0 then
						local runeAbility = caster.runeUnit4:FindAbilityByName("venomort_rune_d_a")
						runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, enemy, "modifier_venomort_rune_d_a_effect", {duration = 7})
						local d_a_stacks = (current_stack+1)*d_a_level
						enemy:SetModifierStackCount( "modifier_venomort_rune_d_a_effect",  runeAbility, d_a_stacks )
					end
				end
			end 	
		end)
	end
end

function a_a_damage_tick(event)
	local caster = event.caster
	local target = event.target
	local damage = event.ability.a_a_dps/5
	damage = damage * target:GetModifierStackCount( "modifier_a_a_nova", event.ability )
	Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
end

function a_a_nova(caster, abilityName, abilityLevel, location)
	print('launch a_a_nova')
    local dummy = CreateUnitByName("npc_dummy_unit", location, true, caster, caster, caster:GetTeamNumber())
    dummy.owner = caster:GetPlayerOwnerID()

    dummy:AddAbility(abilityName)
    dummy:NoHealthBar()
    dummy:AddAbility("dummy_unit")
    dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
    local proc = dummy:FindAbilityByName( abilityName )
    proc:SetLevel(abilityLevel)
	local order =
	{
		UnitIndex = dummy:GetEntityIndex(),
		OrderType =	DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = proc:GetEntityIndex(),
		Queue = true
	}
    ExecuteOrderFromTable(order)
      Timers:CreateTimer(10,
      function()
        UTIL_Remove(dummy)
      end)
end


function c_a(caster, galeAbility)
    local runeUnit = caster.runeUnit3
    local ability = runeUnit:FindAbilityByName("venomort_rune_c_a")
    local abilityLevel = ability:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_a")
    local totalLevel = abilityLevel + bonusLevel
    print("top_c_a")
	if totalLevel > 0 then

	end
end

function gale_target_die(event)
	local caster = event.caster
	local target = event.unit
	local c_a_level = Runes:GetTotalRuneLevel(caster, 3, "c_a", "venomort")
	print("GALE TARGET DIE")
	if c_a_level > 0 then
		local damage = target:GetMaxHealth()*0.012*c_a_level
	      local particleName = "particles/units/heroes/hero_nevermore/venom_raze.vpcf"
	      local shadowFlarePos = GetGroundPosition(target:GetAbsOrigin(), caster)
	      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, caster )
	      ParticleManager:SetParticleControl( particle1, 0, shadowFlarePos )
	      Timers:CreateTimer(1.2, 
	      function()
	        ParticleManager:DestroyParticle( particle1, false )
	      end)
	      particleName = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
	      local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, caster )
	      ParticleManager:SetParticleControl( particle2, 0, shadowFlarePos )
	      ParticleManager:SetParticleControl( particle2, 1, Vector(190,190,190) )
	      ParticleManager:SetParticleControl( particle2, 2, Vector(1.6, 1.6, 1.6) )
	      ParticleManager:SetParticleControl( particle2, 4, Vector(100, 200, 20) )
	      Timers:CreateTimer(1.5, 
	      function()
	        ParticleManager:DestroyParticle( particle2, false )
	      end)
	     EmitSoundOn("Venomort.UnstablePoison", target)
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 260, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 0, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
			end
		end 			
	end
end