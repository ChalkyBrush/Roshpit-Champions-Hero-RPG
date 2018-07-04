function a_a(event)
	local caster = event.caster
    local runeUnit = caster.runeUnit
    local ability = runeUnit:FindAbilityByName("voltex_rune_a_a")
    local abilityBASE = event.ability
    local abilityLevel = ability:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_a")
    local totalLevel = abilityLevel + bonusLevel
    local buffDuration = abilityBASE:GetSpecialValueFor("duration")
    if caster:HasModifier("modifier_voltex_glyph_5_a") then
      buffDuration = buffDuration + 3
    end
    print("WOW")
    if totalLevel > 0 then
        ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_voltex_rune_a_a_buff", {duration = buffDuration})
        caster:SetModifierStackCount( "modifier_voltex_rune_a_a_buff", ability, totalLevel )
    end
end

function b_a(event)
	local caster = event.attacker
    local runeUnit = caster.runeUnit2
    local ability = runeUnit:FindAbilityByName("voltex_rune_b_a")
    local abilityLevel = ability:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_a")
    local totalLevel = abilityLevel + bonusLevel
    if totalLevel > 0 then
    	local target = event.target
		local lucky = RandomInt(1, 100)
        local maxTargets = totalLevel+3
		if lucky <= 15 then
            ApplyDamage({ victim = target, attacker = caster, damage = totalLevel*caster:GetAgility(), damage_type = DAMAGE_TYPE_MAGICAL })
			     b_a_lightning_improved(target, caster, totalLevel, 0, maxTargets)
		end
    end
end

function apply_b_a_think(event)
    local caster = event.caster
    local ability = event.ability
    if caster:GetUnitName() == "npc_dota_hero_phantom_assassin" then
        -- ability.b_a_level = Runes:GetTotalRuneLevel(caster, 2, "b_a", "voltex")
        -- if ability.b_a_level > 0 then
        --     ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_rune_b_a", {})
        -- else
        --     caster:RemoveModifierByName("modifier_voltex_rune_b_a")
        -- end
    end
end

function b_a_lightning_improved(target, caster, totalLevel, targetNumber, maxTargets)
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 575, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )
    if #enemies > 0 then
        local damage = totalLevel*1240
        local d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "voltex")
        if d_b_level > 0 then
          local a_b_ability = caster.runeUnit:FindAbilityByName("voltex_rune_a_b")
          local stacks = caster:GetModifierStackCount( "modifier_voltex_rune_a_b", a_b_ability )
          damage = damage + damage*0.03*stacks*d_b_level
        end
        local newTarget = enemies[1]
        if newTarget == target then
            newTarget = enemies[2]
        end
        if newTarget then
            Filters:TakeArgumentsAndApplyDamage(newTarget, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
            EmitSoundOn("Hero_Zuus.ArcLightning.Target", target)
            local particleName = "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf"
            local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, target)
            local targetPos = target:GetAbsOrigin()
            local newTargetPos = newTarget:GetAbsOrigin()
            ParticleManager:SetParticleControl(lightningBolt,0,Vector(targetPos.x,targetPos.y,targetPos.z + target:GetBoundingMaxs().z ))   
            ParticleManager:SetParticleControl(lightningBolt,1,Vector(newTargetPos.x,newTargetPos.y,newTargetPos.z + newTarget:GetBoundingMaxs().z ))
            targetNumber = targetNumber + 1
            if targetNumber <= maxTargets then
                Timers:CreateTimer(0.2, function()
                    b_a_lightning_improved(newTarget, caster, totalLevel, targetNumber, maxTargets)
                end)
            end
        end
    end 
end

function b_a_lightning(target, caster, abilityName, abilityLevel)
    local point = caster:GetAbsOrigin()
    local dummy = CreateUnitByName("npc_dummy_unit", point, true, caster, caster, caster:GetTeamNumber())
    dummy.owner = caster:GetPlayerOwnerID()

    dummy:AddAbility(abilityName)
    dummy:NoHealthBar()
    dummy:AddAbility("dummy_unit")
    dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
    local proc = dummy:FindAbilityByName( abilityName )
    proc:SetLevel(abilityLevel)
    local targetUnit = target
    local order =
    {
        UnitIndex = dummy:GetEntityIndex(),
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
        AbilityIndex = proc:GetEntityIndex(),
        TargetIndex = targetUnit:GetEntityIndex(),
        Queue = true
    }
    ExecuteOrderFromTable(order)
      Timers:CreateTimer(4,
      function()
        UTIL_Remove(dummy)
      end)
end

function a_d(event)
	local caster = event.caster
	local caster = event.attacker
    local runeUnit = caster.runeUnit
    local ability = runeUnit:FindAbilityByName("voltex_rune_a_d")
    local abilityLevel = ability:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_d")
    local totalLevel = abilityLevel + bonusLevel
    	if totalLevel > 0 then
    		local heroOrigin = caster:GetAbsOrigin()
    		for i = 0, totalLevel + 3, 1 do
			      Timers:CreateTimer(i*0.2,
			      function()
    			  	a_d_lightning_cast(heroOrigin+RandomVector(RandomInt(200, 600)), caster, totalLevel, heroOrigin)
    		      end)
    		end
    	end
end

function a_d_lightning_damage(event)
	local caster = event.caster
	local ability = event.ability	

	local targetPoint = event.target_points[1]
	local radius = event.Radius
	local damage = ability.a_d_damage
	EmitSoundOn("Hero_Leshrac.Lightning_Storm", caster)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), targetPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
      Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
		end
	end 
end

function b_d(event)
    --REMOVED
	-- local caster = event.caster
 --    local ability = event.ability
 --    local runeUnit = caster.runeUnit2
 --    local runeAbility = runeUnit:FindAbilityByName("voltex_rune_b_d")
 --    local runeLevel = runeAbility:GetLevel()
 --    local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_d")
 --    local totalLevel = runeLevel + bonusLevel
 --    	if totalLevel > 0 then
 --    		local heroOrigin = caster:GetAbsOrigin()
 --    		for i = 0, totalLevel+3, 1 do
	-- 		      Timers:CreateTimer(i*0.2,
	-- 		      function()
 --    			  	b_d_lightning_stun(caster, ability, heroOrigin, totalLevel*20+30)
 --    		      end)
 --    		end
 --    	end
end

function b_d_lightning_cast(targetPoint, caster, abilityLevel, casterOrigin)
  	local dummy = CreateUnitByName("npc_dummy_unit", targetPoint, true, caster, caster, caster:GetTeamNumber())
  	dummy.owner = caster:GetPlayerOwnerID()

  	dummy:AddAbility("voltex_rune_b_d_thunder_stun")
  	dummy:NoHealthBar()
  	dummy:AddAbility("dummy_unit")
  	dummy:FindAbilityByName("dummy_unit"):SetLevel(1)

  	local blast = dummy:FindAbilityByName("voltex_rune_b_d_thunder_stun")
  	blast:SetLevel(1)
  	blast.damage = abilityLevel*20+30
    blast.voltex = caster
	local order =
	{
		UnitIndex = dummy:GetEntityIndex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = blast:GetEntityIndex(),
		Position = targetPoint,
		Queue = true
	}
	ExecuteOrderFromTable(order)
	  Timers:CreateTimer(5, -- Start this timer 10 game-time seconds later
	  function()
		UTIL_Remove(dummy)
	  end)
end

function b_d_lightning_stun(caster, ability, point, damage)	

	local targetPoint = point
	local radius = 360
    EmitSoundOnLocationWithCaster(point, "Hero_Zuus.ProjectileImpact", caster)
    EmitSoundOnLocationWithCaster(point, "Hero_Zuus.ProjectileImpact", caster)
      local particleName = "particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf"
      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      ParticleManager:SetParticleControl( particle1, 0, point )
      ParticleManager:SetParticleControl( particle1, 1, Vector(400, 0, 0) )
      Timers:CreateTimer(0.6, 
      function()
        ParticleManager:DestroyParticle( particle1, false )
      end)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), targetPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
        if not enemy:HasModifier("voltex_b_d_stun_immunity") then
            ability:ApplyDataDrivenModifier(caster, enemy, "voltex_b_d_stun_stacks", {duration = 5})
            local current_stack = enemy:GetModifierStackCount( "voltex_b_d_stun_stacks", ability )
            if current_stack > 11 then
                ability:ApplyDataDrivenModifier(caster, enemy, "voltex_b_d_stun_immunity", {duration = 5})
            end
            enemy:SetModifierStackCount( "voltex_b_d_stun_stacks", ability, current_stack+1 )
			     Filters:ApplyStun(caster, 0.2, enemy)
        end
        Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
		end
	end 
end

function a_b(event)
	local caster = event.caster
    local runeUnit = caster.runeUnit
    local ability = runeUnit:FindAbilityByName("voltex_rune_a_b")
    local abilityLevel = ability:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_b")
    local totalLevel = abilityLevel + bonusLevel
    if totalLevel > 0 then
        ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_voltex_rune_a_b", {})
        local current_stack = caster:GetModifierStackCount( "modifier_voltex_rune_a_b", ability )
        if current_stack < 30 then
        	caster:SetModifierStackCount( "modifier_voltex_rune_a_b", ability, current_stack+1 )
    	end
    end

end

function a_b_activate(event)
	local caster = event.caster
    local runeUnit = caster.runeUnit
    local ability = runeUnit:FindAbilityByName("voltex_rune_a_b")   
    local current_stack = caster:GetModifierStackCount( "modifier_voltex_rune_a_b", ability)
    if current_stack > 0 then
  	   
  		local location = caster:GetOrigin()
  		local forwardVector = caster:GetForwardVector()
          local runeLevel = Runes:GetTotalRuneLevel(caster, 1, "a_b", "voltex")
  		for i=-3, 3, 1 do 
  			rotatedVector = rotateVector(forwardVector, i*2*math.pi/7)*Vector(200, 200, 0)
  			targetPoint = rotatedVector + location*Vector(1,1,0)
  			a_b_lightning_cast(targetPoint, caster, runeLevel, location, current_stack)
  		end
      caster:RemoveModifierByName("modifier_voltex_rune_a_b")
	end
end

function a_b_lightning_cast(targetPoint, caster, abilityLevel, casterOrigin, stacks)
  	local dummy = CreateUnitByName("npc_dummy_unit", targetPoint, true, caster, caster, caster:GetTeamNumber())
  	dummy.owner = caster:GetPlayerOwnerID()

  	dummy:AddAbility("voltex_rune_a_b_thunder_stun")
  	dummy:NoHealthBar()
  	dummy:AddAbility("dummy_unit")
  	dummy:FindAbilityByName("dummy_unit"):SetLevel(1)

  	local blast = dummy:FindAbilityByName("voltex_rune_a_b_thunder_stun")
  	blast:SetLevel(1)
  	blast.damage = stacks*130
  	blast.stunDuration = math.min(abilityLevel*0.01*stacks, 5)
    blast.voltex = caster
    blast.stacks = stacks
	local order =
	{
		UnitIndex = dummy:GetEntityIndex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = blast:GetEntityIndex(),
		Position = targetPoint,
		Queue = true
	}
	ExecuteOrderFromTable(order)
	  Timers:CreateTimer(5, -- Start this timer 10 game-time seconds later
	  function()
		UTIL_Remove(dummy)
	  end)
end

function a_b_thunder_stun(event)

	local ability = event.ability	
  local caster = ability.voltex
	local targetPoint = event.target_points[1]
	local radius = event.Radius
	local damage = ability.damage

  local d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "voltex")
  if d_b_level > 0 then
    local a_b_ability = caster.runeUnit:FindAbilityByName("voltex_rune_a_b")
    local stacks = ability.stacks
    damage = damage + damage*0.03*stacks*d_b_level
  end
  local a_b_level = Runes:GetTotalRuneLevel(caster, 1, "a_b", "voltex")

	EmitSoundOn("Hero_Disruptor.ThunderStrike.Target", caster)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), targetPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:ApplyStun(ability.voltex, ability.stunDuration, enemy)
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
		end
	end 
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

function b_b(event)
	local caster = event.caster
    local runeUnit = caster.runeUnit2
    local ability = runeUnit:FindAbilityByName("voltex_rune_b_b")
    local abilityLevel = ability:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_b")
    local totalLevel = abilityLevel + bonusLevel
    if totalLevel > 0 then
        ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_voltex_rune_b_b_self", {})
        caster:SetModifierStackCount( "modifier_voltex_rune_b_b_self", ability, totalLevel )
        local radius = event.radius
		local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
		if #allies > 0 then
			for _,ally in pairs(allies) do
				if 	ally:GetEntityIndex() == caster:GetEntityIndex() then
				else
	        		ability:ApplyDataDrivenModifier(runeUnit, ally, "modifier_voltex_rune_b_b_ally", {})
	        		ally:SetModifierStackCount( "modifier_voltex_rune_b_b_ally", ability, totalLevel )
	        	end
			end
		end 
    end
end

function b_c_think(event)
  local caster = event.target
  local totalLevel = event.ability.b_c_level
  local ability = event.ability
  local damage = (totalLevel*22500 + 300)/2

  local glyphed = false
  if not ability.particles then
    ability.particles = 0
  end
  local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 220, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
  if #enemies > 0 then
  	for _,enemy in pairs(enemies) do
      ability.particles = ability.particles + 1
      Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE) 
      if ability.particles < 12 then
        local particleName = "particles/units/heroes/hero_lina/lina_spell_laguna_blade_impact_sparks.vpcf"
        local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
        ParticleManager:SetParticleControl( particle1, 0, enemy:GetAbsOrigin() )
        ParticleManager:SetParticleControl( particle1, 1, enemy:GetAbsOrigin() )
        ability:ApplyDataDrivenModifier(caster, enemy, "modifier_voltex_rune_b_c_slow_glyphed", {duration = 4})
        Timers:CreateTimer(0.6, 
        function()
          ParticleManager:DestroyParticle( particle1, false )
          ability.particles = ability.particles - 1
        end)
      end
      EmitSoundOn("Item.Maelstrom.Chain_Lightning.Jump", enemy)
    end
  end 
end

function c_a(event)
    local ability = event.ability
    local caster = event.caster
    local runeUnit = caster.runeUnit3
    local runeAbility = runeUnit:FindAbilityByName("voltex_rune_c_a")
    local abilityLevel = runeAbility:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_a")
    local totalLevel = abilityLevel + bonusLevel
    ability.c_a_level = totalLevel
    ability.c_a_ability = runeAbility
    ability.c_a_runeUnit = runeUnit
    ability.d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "voltex")
end

function c_b(event)
    local ability = event.ability
    local caster = event.caster
    local radius = event.radius
    local runeUnit = caster.runeUnit3
    local runeAbility = runeUnit:FindAbilityByName("voltex_rune_c_b")
    local abilityLevel = runeAbility:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_b")
    local totalLevel = abilityLevel + bonusLevel
    if totalLevel > 0 then
    	rune_c_b_strike(caster, ability, totalLevel, caster, radius)
    	runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "voltex_rune_c_b_heal_effect", {})
    end
end

function rune_c_b_strike(attacker, ability, totalLevel, target, radius)

    local particleName = "particles/items_fx/green_lightning.vpcf"
    local radius = radius + 200
    local damage = 800

    local enemies = FindUnitsInRadius( attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    local heal = totalLevel*40 + 100
    for _,unit in pairs(enemies) do
            if unit ~= target then
                -- Particle
                attacker:Heal(heal, attacker)
                local origin = unit:GetAbsOrigin()
                local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, attacker)
                ParticleManager:SetParticleControl(lightningBolt,0,Vector(attacker:GetAbsOrigin().x,attacker:GetAbsOrigin().y,attacker:GetAbsOrigin().z + attacker:GetBoundingMaxs().z ))   
                ParticleManager:SetParticleControl(lightningBolt,1,Vector(origin.x,origin.y,origin.z + unit:GetBoundingMaxs().z ))
            
                -- Damage
                ApplyDamage({ victim = unit, attacker = attacker, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

                -- Increment counter
            end
    end
end

function rune_c_c_think(event)
    local ability = event.ability
    local caster = event.target
    local particleName = "particles/items_fx/chain_lightning.vpcf"
    local totalLevel = ability.c_c_level
    local radius = 300 + totalLevel*20
    local damage = 12*totalLevel
    local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, attacker)
    local casterPos = caster:GetAbsOrigin()
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    for _,unit in pairs(enemies) do
            if unit ~= target then
                -- Particle
                local origin = unit:GetAbsOrigin()
                local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
                ParticleManager:SetParticleControl(lightningBolt,0,Vector(casterPos.x,casterPos.y,casterPos.z + caster:GetBoundingMaxs().z ))   
                ParticleManager:SetParticleControl(lightningBolt,1,Vector(origin.x,origin.y,origin.z + unit:GetBoundingMaxs().z ))

                ApplyDamage({ victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

            end
    end
end

function illusion_end(event)
  -- local target = event.target
  -- UTIL_Remove(target)
end

function rune_unit_2_think(event)
    local caster = event.caster
    local ability = event.ability
    local hero = caster.hero
    local totalLevel = Runes:GetTotalRuneLevel(hero, 2, "b_d", "voltex")
    ability.b_d_level = totalLevel
    if totalLevel > 0 then
        ability:ApplyDataDrivenModifier(caster, hero, "modifier_voltex_rune_b_d_rune_effect", {})
    else
    	hero:RemoveModifierByName("modifier_voltex_rune_b_d_rune_effect")
    end
end

function b_d_attack(event)
    local luck = RandomInt(1,10)
    if luck <= 3 then
        local attacker = event.attacker
        local target = event.target
        local ability = event.ability
        local damage = attacker:GetAverageTrueAttackDamage(attacker)*(1+0.1*ability.b_d_level)
        Filters:ApplyStun(attacker, 0.2, target)
        Filters:TakeArgumentsAndApplyDamage(target, attacker, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
        -- Renders the particle on the target
        local particle = ParticleManager:CreateParticle("particles/roshpit/voltex/voltex_bolt_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, target)
        -- Raise 1000 value if you increase the camera height above 1000
        ParticleManager:SetParticleControl(particle, 0, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
        ParticleManager:SetParticleControl(particle, 1, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z+1000 ))
        ParticleManager:SetParticleControl(particle, 2, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))

        ability:ApplyDataDrivenModifier(attacker.runeUnit2, target, "modifier_voltex_rune_b_d_armor_loss", {duration = 6})
        target:SetModifierStackCount( "modifier_voltex_rune_b_d_armor_loss", ability, ability.b_d_level )
        EmitSoundOn("Voltex.LightningBolt", target)
        Timers:CreateTimer(2, function()
            ParticleManager:DestroyParticle(particle, false)
        end)
    end
end