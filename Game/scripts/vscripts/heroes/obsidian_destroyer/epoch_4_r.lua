require('/heroes/obsidian_destroyer/epoch_constants')

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
        if unit.eternity_flood_vacuum ~= target then
            unit.eternity_flood_vacuum = target
            -- The standard speed value is for 1 second durations so we have to calculate the difference
            -- with 1/duration
            unit.eternity_flood_vacuum.pull_speed = distance * 1/duration * 1/50
        end

        -- Apply the stun and no collision modifier then set the new location
        ability:ApplyDataDrivenModifier(caster, unit, vacuum_modifier, {duration = remaining_duration})
        if not unit.jumpLock then
          unit:SetAbsOrigin(unit_location + direction * unit.eternity_flood_vacuum.pull_speed)
        end
    end
    if remaining_duration < 0.02 then
      ability.r_3_level = caster:GetRuneValue("r", 3)
      new_lock(units, target_location, caster, damage, duration, ability, keys.stun_duration)
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
        ability:ApplyDataDrivenModifier(caster, unit, "modifier_eternity_flood_locked", {duration = stun_duration})
        if ability.r_3_level > 0 then
          ability:ApplyDataDrivenModifier(caster, unit, "modifier_eternity_flood_locked_rune_r_3_exploding", {duration = stun_duration})
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
    epoch_r_1(caster, target_location, duration, ability)
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

function epoch_r_1(caster, target_location, duration, ability)
  local r_1_level = caster:GetRuneValue("r", 1)
  if r_1_level > 0 then
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
    local a_d_duration = Filters:GetAdjustedBuffDuration(caster, 10 + r_1_level*EPOCH_R1_EXTRA_DURATION, false)
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_eternity_flood_r_1_visible", {duration = a_d_duration})
    caster:SetModifierStackCount("modifier_eternity_flood_r_1_visible", caster, r_1_level)

    ability:ApplyDataDrivenModifier(caster, caster, "modifier_eternity_flood_r_1_invisible", {duration = a_d_duration})
    --ability:ApplyDataDrivenModifier(caster, caster, "modifier_eternity_flood_r_1_invisible_str_and_agi", {duration = a_d_duration})
    
  end
  -- local runeUnit = caster.runeUnit
  -- local runeAbility = runeUnit:FindAbilityByName("epoch_rune_r_1")
  -- local abilityLevel = runeAbility:GetLevel()
  -- local bonusLevel = Runes:GetTotalBonus(runeUnit, "r_1")
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

function epoch_r_1_buff_think(event)
  local caster = event.caster
  local ability = event.ability

  local r_1_level = caster:GetModifierStackCount("modifier_eternity_flood_r_1_visible", caster)

  local percent_damage_stacks = caster:GetMana()*r_1_level*EPOCH_R1_DMG_PCT/1000
  caster:SetModifierStackCount("modifier_eternity_flood_r_1_invisible", caster, percent_damage_stacks)

  --local missingManaStacks = ((caster:GetMaxMana()-caster:GetMana())/caster:GetMaxMana())*10
  --missingManaStacks = math.ceil(missingManaStacks)
  --caster:SetModifierStackCount("modifier_eternity_flood_r_1_invisible_str_and_agi", caster, missingManaStacks*r_1_level)
  
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


 ability:ApplyDataDrivenModifier(caster, dummy, "modifier_eternity_flood_ghost", {duration = duration+1})

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
              EffectName = "particles/units/heroes/hero_alchemist/epoch_rune_r_1_concoction_projectile.vpcf",
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

function channel_start(event)
  local caster = event.caster
  StartAnimation(caster, {duration=2.1, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.18})
end


function epoch_r_3_crackle_think(event)
  local target = event.target
  local caster = event.caster
  local ability = event.ability
  local damage = caster:GetAverageTrueAttackDamage(caster)*ability.r_3_level*EPOCH_R3_DMG_MULTI_PCT/100
  Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_TIME, RPC_ELEMENT_NONE)
  CustomAbilities:QuickAttachParticle("particles/econ/items/morphling/morphling_crown_of_tears/morphling_crown_waveform_dmg_flash.vpcf", target, 1)
end

function eternity_flood_script(event)
  local caster = event.caster
  local ability = event.ability
  local point = event.target_points[1]
  local radius = event.radius

  EmitSoundOn("Epoch.UltiStart", caster)
  ability:ApplyDataDrivenThinker(caster, point, "modifier_eternity_flood_vacuum_thinker_datadriven", {})
  Timers:CreateTimer(4.0, function()
    epoch_r_1(caster, point, 3, ability)
  end)
  local enemies = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
  if #enemies > 0 then
    for _,enemy in pairs(enemies) do
      ability:ApplyDataDrivenModifier(caster, enemy, "modifier_eternity_flood_locked_datadriven", {duration = event.duration})
    end
  end 
end

function immortal_weapon_2_die(event)
  local caster = event.unit
  local ulti = caster:GetAbilityByIndex(DOTA_ULTIMATE_SLOT)
  local respawnPoint = caster:GetAbsOrigin()
  print("IMMO DIE: "..ulti:GetCooldownTimeRemaining())
  if ulti:GetCooldownTimeRemaining() == 0 then
    if ulti:GetAbilityName() == "eternity_flood" then
      local eventTable = {}
      eventTable.caster = caster
      eventTable.ability = ulti
      eventTable.target_points = {}
      eventTable.target_points[1] = respawnPoint
      eventTable.radius = ulti:GetLevelSpecialValueFor("radius", ulti:GetLevel())
      eventTable.duration = ulti:GetLevelSpecialValueFor("duration", ulti:GetLevel())
      eternity_flood_script(eventTable)
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

function epoch_rune_r_2_think(event)
  local caster = event.caster
  local runeUnit = caster.runeUnit2
  local runeAbility = runeUnit:FindAbilityByName("epoch_rune_r_2")
  local r_2_level = caster:GetRuneValue("r", 2)
  if r_2_level > 0 then
    runeAbility:ApplyDataDrivenModifier(runeUnit, caster, "modifier_epoch_r_2_buff", {})
    caster:SetModifierStackCount( "modifier_epoch_r_2_buff", runeAbility, r_2_level )
  else
    caster:RemoveModifierByName("modifier_epoch_r_2_buff")
  end
end