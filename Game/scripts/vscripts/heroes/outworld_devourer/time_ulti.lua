require('/heroes/obsidian_destroyer/constants_epoch')

function Vacuum( keys )
    local caster = keys.caster
    local target = keys.target
    local target_location = target:GetAbsOrigin()
    local ability = keys.ability
    local ability_level = ability:GetLevel()
    local damage = keys.damage

    -- Ability variables
    local duration = keys.duration
    local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
    local vacuum_modifier = keys.vacuum_modifier
    local remaining_duration = duration - (GameRules:GetGameTime() - target.vacuum_start_time)

    -- Targeting variables
    local target_teams = ability:GetAbilityTargetTeam() 
    local target_types = ability:GetAbilityTargetType() 
    local target_flags = ability:GetAbilityTargetFlags() 

    local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)
    -- Calculate the position of each found unit
    for _,unit in ipairs(units) do
        local unit_location = unit:GetAbsOrigin()
        local vector_distance = target_location - unit_location
        local distance = (vector_distance):Length2D()
        local direction = (vector_distance):Normalized()

        -- Check if its a new vacuum cast
        -- Set the new pull speed if it is
        if unit.time_ulti_vacuum ~= target then
            unit.time_ulti_vacuum = target
            -- The standard speed value is for 1 second durations so we have to calculate the difference
            -- with 1/duration
            unit.time_ulti_vacuum.pull_speed = distance * 1/duration * 1/50
        end

        -- Apply the stun and no collision modifier then set the new location
        ability:ApplyDataDrivenModifier(caster, unit, vacuum_modifier, {duration = remaining_duration})
        if not unit.jumpLock then
          unit:SetAbsOrigin(unit_location + direction * unit.time_ulti_vacuum.pull_speed)
        end
    end
    if remaining_duration < 0.02 then
      ability.c_d_level = Runes:GetTotalRuneLevel(caster, 3, "c_d", "epoch")
      new_lock(units, target_location, caster, damage, duration, ability, keys.stun_duration)
    	-- knockback(units, target_location, caster, damage, duration)
     --  rune_c_d_lock(units, caster, duration, ability)
    end
end

function new_lock(units, target_location, caster, damage, duration, ability, stun_duration)
  EmitSoundOn("Epoch.UltiExplode", caster)

    for _,unit in ipairs(units) do
      Filters:TakeArgumentsAndApplyDamage(unit, caster, damage, DAMAGE_TYPE_PURE, 4, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
      local knockVector = ((unit:GetAbsOrigin()-target_location)*Vector(1,1,0)):Normalized()
      ability:ApplyDataDrivenModifier(caster, unit, "modifier_time_ult_flailing", {duration = 0.6})
      for i = 1, 20, 1 do
        Timers:CreateTimer(i*0.03, function()
          unit:SetAbsOrigin(unit:GetAbsOrigin()+knockVector*math.sin(math.pi/20)*16+Vector(0,0,25)*math.sin(math.pi/20))
        end)
      end
      Timers:CreateTimer(0.6, function()
        ability:ApplyDataDrivenModifier(caster, unit, "modifier_time_ulti_locked", {duration = stun_duration})
        if ability.c_d_level > 0 then
          ability:ApplyDataDrivenModifier(caster, unit, "modifier_time_ulti_locked_rune_c_d_exploding", {duration = stun_duration})
        end
        Timers:CreateTimer(stun_duration, function()
          WallPhysics:Jump(unit, Vector(1,1), 0, 0, 0, 1)
        end)
      end)
    end
end


function VacuumStart( keys )
    local target = keys.target
    local caster = keys.caster
    local ability = keys.ability
    local target_location = target:GetAbsOrigin()
    local duration = keys.duration
    target.vacuum_start_time = GameRules:GetGameTime()
    rune_a_d(caster, target_location, duration, ability)
    StartAnimation(caster, {duration=0.6, activity=ACT_DOTA_ATTACK, rate=1.8})

      local particleName = "particles/econ/items/enigma/enigma_world_chasm/time_ulti.vpcf"
      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      ParticleManager:SetParticleControl( particle1, 0, target_location )
      Timers:CreateTimer(duration, 
      function()
        ParticleManager:DestroyParticle( particle1, false )
      end)
    Filters:CastSkillArguments(4, caster)
end

function rune_a_d(caster, target_location, duration, ability)
  local a_d_level = Runes:GetTotalRuneLevel(caster, 1, "a_d", "epoch")
  if a_d_level > 0 then
    for i = 1, 4, 1 do
      local position = caster:GetAbsOrigin()
      local particleName = "particles/econ/items/monkey_king/arcana/death/mk_arcana_spring_cast_outer_death_pnt.vpcf"
      -- CustomAbilities:QuickAttachParticle(particleName, caster, 3)
      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      ParticleManager:SetParticleControl( particle1, 0, position )
      Timers:CreateTimer(8, 
      function()
        ParticleManager:DestroyParticle( particle1, false )
      end)
    end
    local a_d_duration = Filters:GetAdjustedBuffDuration(caster, 10 + a_d_level*epoch_r1_extra_duration, false)
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_time_ulti_a_d_visible", {duration = a_d_duration})
    caster:SetModifierStackCount("modifier_time_ulti_a_d_visible", caster, a_d_level)

    ability:ApplyDataDrivenModifier(caster, caster, "modifier_time_ulti_a_d_invisible", {duration = a_d_duration})
    --ability:ApplyDataDrivenModifier(caster, caster, "modifier_time_ulti_a_d_invisible_str_and_agi", {duration = a_d_duration})
    
  end
  -- local runeUnit = caster.runeUnit
  -- local runeAbility = runeUnit:FindAbilityByName("epoch_rune_a_d")
  -- local abilityLevel = runeAbility:GetLevel()
  -- local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_d")
  -- local totalLevel = abilityLevel + bonusLevel
  -- if totalLevel > 0 then
  --   local distance = 600
  --   ability.damage = 40 + totalLevel*40
  --     local position = target_location+Vector(distance, distance)
  --     local fv = (target_location-position):Normalized() 
  --     create_epoch_copy(caster, ability, position, duration, fv, distance, totalLevel)

  --     position = target_location+Vector(distance*-1, distance)
  --     local fv = (target_location-position):Normalized() 
  --     create_epoch_copy(caster, ability, position, duration, fv, distance, totalLevel)

  --     position = target_location+Vector(distance, distance*-1)
  --     local fv = (target_location-position):Normalized() 
  --     create_epoch_copy(caster, ability, position, duration, fv, distance, totalLevel)

  --     position = target_location+Vector(distance*-1, distance*-1)
  --     local fv = (target_location-position):Normalized() 
  --     create_epoch_copy(caster, ability, position, duration, fv, distance, totalLevel)
  -- end
end

function a_d_buff_think(event)
  local caster = event.caster
  local ability = event.ability

  local a_d_level = caster:GetModifierStackCount("modifier_time_ulti_a_d_visible", caster)

  local percent_damage_stacks = caster:GetMana()*a_d_level*epoch_r1_dmg_pct/1000
  caster:SetModifierStackCount("modifier_time_ulti_a_d_invisible", caster, percent_damage_stacks)

  --local missingManaStacks = ((caster:GetMaxMana()-caster:GetMana())/caster:GetMaxMana())*10
  --missingManaStacks = math.ceil(missingManaStacks)
  --caster:SetModifierStackCount("modifier_time_ulti_a_d_invisible_str_and_agi", caster, missingManaStacks*a_d_level)
  
end

function create_epoch_copy(caster, ability, position, duration, fv, distance, totalLevel)
    local dummy = CreateUnitByName("epoch_summon", position, true, caster, caster, caster:GetTeamNumber())
    dummy.owner = caster:GetPlayerOwnerID()
    --StartAnimation(dummy, {duration=0.8, activity=ACT_DOTA_FLAIL, rate=0.5})
    --EmitSoundOn("Hero_Luna.LucentBeam.Cast", dummy)
    dummy:AddAbility("replica")
    dummy:FindAbilityByName("replica"):SetLevel(1)
    StartAnimation(dummy, {duration=0.5, activity=ACT_DOTA_SPAWN, rate=1.0})
    dummy:SetForwardVector(fv)


 ability:ApplyDataDrivenModifier(caster, dummy, "modifier_time_ulti_ghost", {duration = duration+1})

    -- FindClearSpaceForUnit(dummy, position, true)
      Timers:CreateTimer(duration, -- Start this timer 10 game-time seconds later
      function()
      
        local particleName =  "particles/units/heroes/hero_oracle/oracle_false_promise_cast.vpcf"
        local particleVector = position
        -- local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, dummy )
        -- ParticleManager:SetParticleControlEnt( pfx, 0, dummy, PATTACH_POINT_FOLLOW, "attach_hitloc", particleVector, true )
      local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, dummy )
      ParticleManager:SetParticleControl( pfx, 0, particleVector )
        Timers:CreateTimer(0.4, function() 
          ParticleManager:DestroyParticle( pfx, false )
          UTIL_Remove(dummy)
        end)  
      end)  
        local start_radius = 130
        local end_radius = 130
        local speed = (distance/duration)*6
       
    for i = 0, duration*5, 1 do
      Timers:CreateTimer(i*0.15, function() 

        local info = 
        {
            Ability = ability,
              EffectName = "particles/units/heroes/hero_alchemist/epoch_rune_a_d_concoction_projectile.vpcf",
              vSpawnOrigin = position+Vector(0,0,100),
              fDistance = math.sqrt(distance*distance+distance*distance),
              fStartRadius = start_radius,
              fEndRadius = end_radius,
              Source = caster,
              StartPosition = "attach_attack1",
              bHasFrontalCone = true,
              bReplaceExisting = false,
              iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
              iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
              iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
              fExpireTime = GameRules:GetGameTime() + 5.0,
          bDeleteOnHit = false,
          vVelocity = fv*speed,
          bProvidesVision = false,
        }
        projectile = ProjectileManager:CreateLinearProjectile(info) 
      end)
    end
end

function time_orb_strike(event)
  local target = event.target
  local caster = event.caster
  local damage = event.ability.damage
  Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
  ApplyDamage(damageTable)
end

function rune_c_d_lock(units, caster, duration, ability)
  local runeUnit = caster.runeUnit3
  local runeAbility = runeUnit:FindAbilityByName("epoch_rune_c_d")
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_d")
  local totalLevel = abilityLevel + bonusLevel
  if totalLevel > 0 then
    local lockDuration = 0.5 + 0.2*totalLevel
    Timers:CreateTimer(1.1, function() 
      for _,unit in ipairs(units) do
        if unit:IsAlive() then
          ability:ApplyDataDrivenModifier(caster, unit, "modifier_time_ulti_locked", {duration = lockDuration})
        end
      end
    end)
  end  
end

function keep_in_space_think(event)
  local target = event.target
  target:SetAbsOrigin(target.timeLockPos)
end

function knockback(units, point, caster, damage, duration)
	
      

      --local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      --ParticleManager:SetParticleControl( particle2, 0, point )
      --Timers:CreateTimer(1, -- Start this timer 10 game-time seconds later
     -- function()
     --   ParticleManager:DestroyParticle( particle2, false )
     -- end)
      -- EmitSoundOn("Hero_Warlock.RainOfChaos", caster)
	local modifierKnockback =
	{
		center_x = point.x,
		center_y = point.y,
		center_z = point.z,
		duration = 1,
		knockback_duration = 1,
		knockback_distance = 280,
		knockback_height = 250
	}
    for _,unit in ipairs(units) do
      if not unit.jumpLock then
        unit:AddNewModifier( unit, nil, "modifier_knockback", modifierKnockback )
      end
      Filters:TakeArgumentsAndApplyDamage(unit, caster, damage, DAMAGE_TYPE_PURE, 4, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
    end


	local dummy = CreateUnitByName("npc_dummy_unit", point, false, caster, caster, caster:GetTeam())
  	dummy.owner = caster:GetPlayerOwnerID()

  	dummy:AddAbility("dummy_unit")
  	dummy:FindAbilityByName("dummy_unit"):SetLevel(1)

    local particleName = "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf"
    local particleVector = point
    local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, caster )
    ParticleManager:SetParticleControlEnt( pfx, 0, dummy, PATTACH_POINT_FOLLOW, "attach_hitloc", particleVector, true )

	Timers:CreateTimer(duration, function() 
		UTIL_Remove(dummy) 
		ParticleManager:DestroyParticle( pfx, false )
	end)	
end

function channel_start(event)
  local caster = event.caster
  -- local ability = event.ability
  StartAnimation(caster, {duration=2.1, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.18})
  -- local runeUnit = caster.runeUnit2
  -- local runeAbility = runeUnit:FindAbilityByName("epoch_rune_b_d")
  -- caster:RemoveModifierByName("modifier_epoch_rune_d_d_visible")
  -- local abilityLevel = runeAbility:GetLevel()
  -- local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_d")
  -- local totalLevel = abilityLevel + bonusLevel
  -- ability.rune_b_d_level = totalLevel
  -- if not ability.agesTable then
  --   ability.agesTable = {}
  -- end
  -- if totalLevel > 0 then

  --   if caster:HasModifier("modifier_epoch_glyph_4_1") then
  --     -- local fv = WallPhysics:rotateVector(caster:GetForwardVector(), math.pi/8)
  --     local position = caster:GetAbsOrigin() - caster:GetForwardVector()*Vector(300,300)
  --     spawnGuardian(caster, event.ability, totalLevel, position)
  --     position = caster:GetAbsOrigin() + caster:GetForwardVector()*Vector(-300,300)
  --     spawnGuardian(caster, event.ability, totalLevel, position)
  --   else
  --     local position = caster:GetAbsOrigin() - caster:GetForwardVector()*Vector(300,300)
  --     spawnGuardian(caster, event.ability, totalLevel, position)
  --   end
  -- else
  --   ability.dummy = nil 
  -- end
end

-- function spawnGuardian(caster, ability, totalLevel, position)
--     local fv = caster:GetForwardVector()
--     local dummy = CreateUnitByName("epoch_summon", position, true, caster, caster, caster:GetTeamNumber())
--     dummy:SetModelScale(math.min(1+totalLevel/60, 1.6))
--     dummy.owner = caster:GetPlayerOwnerID()
--     --StartAnimation(dummy, {duration=0.8, activity=ACT_DOTA_FLAIL, rate=0.5})
--     --EmitSoundOn("Hero_Luna.LucentBeam.Cast", dummy)
--     dummy:AddAbility("replica")
--     dummy:FindAbilityByName("replica"):SetLevel(1)

--     dummy:AddAbility("dark_ranger_life_drain")
--     local transferAbility = dummy:FindAbilityByName("dark_ranger_life_drain")
--     transferAbility:SetLevel(1)

--       local order =
--       {
--           UnitIndex = dummy:GetEntityIndex(),
--           OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
--           AbilityIndex = transferAbility:GetEntityIndex(),
--           TargetIndex = caster:GetEntityIndex(),
--           Queue = true
--       }
--       ExecuteOrderFromTable(order)
--     ability.transferAbility = transferAbility

--     StartAnimation(dummy, {duration=2, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.2})
--     dummy:SetForwardVector(fv)
--     ability.dummy = dummy
--     table.insert(ability.agesTable, dummy)
--     ability.d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "epoch")
--     ability.d_d_ability = caster.runeUnit4:FindAbilityByName("epoch_rune_d_d")
--     -- local particleName = "particles/units/heroes/hero_wisp/tether_green.vpcf"
--     -- local particleVector = point
--     -- local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
--     -- ParticleManager:SetParticleControlEnt( pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", casterOrigin, true )
--     -- ParticleManager:SetParticleControlEnt( pfx, 0, dummy, PATTACH_POINT_FOLLOW, "attach_hitloc", position, true )
--     -- ability.transfer_particle = pfx

--     ability:ApplyDataDrivenModifier(caster, dummy, "modifier_time_ulti_ghost", {duration = 3})
-- end

-- function channel_think(event)
--   local caster = event.caster
--   local ability = event.ability
--   local totalLevel = ability.rune_b_d_level
--   if totalLevel > 0 then
--     if caster:HasModifier("modifier_epoch_glyph_4_1") then
--       totalLevel = totalLevel*2
--     end
--     caster:Heal(totalLevel*15, caster)
--     local manaRestore = totalLevel*8
--     caster:GiveMana(manaRestore)
--     if ability.d_d_level > 0 then
--       local d_d_duration = Filters:GetAdjustedBuffDuration(caster, 12, false)
--       ability.d_d_ability:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_epoch_rune_d_d_visible", {duration = d_d_duration})
--       local current_stack = caster:GetModifierStackCount( "modifier_epoch_rune_d_d_visible", ability.d_d_ability )
--       local newStack = current_stack + manaRestore*0.2*ability.d_d_level
--       caster:SetModifierStackCount( "modifier_epoch_rune_d_d_visible", ability.d_d_ability, newStack )      
--     end
--   end
-- end

-- function channel_end(event)
--   local ability = event.ability
--   local caster = event.caster
--   for i = 1, #ability.agesTable, 1 do
--     local dummy = ability.agesTable[i]
--     if IsValidEntity(dummy) then
--       local particleName =  "particles/units/heroes/hero_oracle/oracle_false_promise_cast.vpcf"
--       local particleVector = dummy:GetAbsOrigin() + Vector(0,0,150)
--       local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, dummy )
--       ParticleManager:SetParticleControl( pfx, 0, particleVector )
--     end
--   end
--   Timers:CreateTimer(0.5, function() 
--     for i = 1, #ability.agesTable, 1 do
--       local dummy = ability.agesTable[i]
--       if IsValidEntity(dummy) then
--        UTIL_Remove(dummy)
--       end
--       caster:RemoveModifierByName("modifier_life_drain")
--     end
--     caster:RemoveModifierByName("modifier_life_drain")
--     ability.agesTable = {}
--   end)
  
-- end

function c_d_crackle_think(event)
  local target = event.target
  local caster = event.caster
  local ability = event.ability
  local damage = caster:GetAverageTrueAttackDamage(caster)*ability.c_d_level*epoch_r3_dmg_multi_pct/100
  Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
  CustomAbilities:QuickAttachParticle("particles/econ/items/morphling/morphling_crown_of_tears/morphling_crown_waveform_dmg_flash.vpcf", target, 1)
end

function time_ulti_script(event)
  local caster = event.caster
  local ability = event.ability
  local point = event.target_points[1]
  local radius = event.radius

  EmitSoundOn("Epoch.UltiStart", caster)
  ability:ApplyDataDrivenThinker(caster, point, "modifier_time_ulti_vacuum_thinker_datadriven", {})
  Timers:CreateTimer(4.0, function()
    rune_a_d(caster, point, 3, ability)
  end)
  local enemies = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
  if #enemies > 0 then
    for _,enemy in pairs(enemies) do
      ability:ApplyDataDrivenModifier(caster, enemy, "modifier_time_ulti_locked_datadriven", {duration = event.duration})
    end
  end 
end

function immortal_weapon_2_die(event)
  local caster = event.unit
  local ulti = caster:GetAbilityByIndex(DOTA_ULTIMATE_SLOT)
  local respawnPoint = caster:GetAbsOrigin()
  print("IMMO DIE: "..ulti:GetCooldownTimeRemaining())
  if ulti:GetCooldownTimeRemaining() == 0 then
    if ulti:GetAbilityName() == "time_ulti" then
      local eventTable = {}
      eventTable.caster = caster
      eventTable.ability = ulti
      eventTable.target_points = {}
      eventTable.target_points[1] = respawnPoint
      eventTable.radius = ulti:GetLevelSpecialValueFor("radius", ulti:GetLevel())
      eventTable.duration = ulti:GetLevelSpecialValueFor("duration", ulti:GetLevel())
      time_ulti_script(eventTable)
      local CD = ulti:GetCooldown(ulti:GetLevel())
      ulti:StartCooldown(CD*1.5)
    end
    Timers:CreateTimer(3, function()
      if caster:IsAlive() then
      else
        caster:RespawnHero(false, false)
        caster:SetAbsOrigin(respawnPoint)
      end
    end)
  end
end

function rune_think(event)
  local caster = event.caster
  rune_a_b(caster)
  rune_b_a(caster)
end

function epoch_rune_b_d_think(event)
  local caster = event.caster
  local runeUnit = caster.runeUnit2
  local runeAbility = runeUnit:FindAbilityByName("epoch_rune_b_d")
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_d")
  local totalLevel = abilityLevel + bonusLevel
  if totalLevel > 0 then
    runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_epoch_b_d_buff", {})
    caster:SetModifierStackCount( "modifier_epoch_b_d_buff", runeAbility, totalLevel )
  else
    caster:RemoveModifierByName("modifier_epoch_b_d_buff")
  end
  -- print(totalLevel)
end