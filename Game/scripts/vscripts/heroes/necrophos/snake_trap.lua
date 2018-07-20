function begin_snake_channel(event)
  local caster = event.caster
  StartAnimation(caster, {duration=2.0, activity=ACT_DOTA_CAST_ABILITY_4, rate=0.46, translate="death_protest"})
  -- EmitSoundOn("necrolyte_necr_deny_11", caster)
end

function channel_interrupt(event)
  EndAnimation(event.caster)
end

function begin_snakes(event)
  local sound_table = {"necrolyte_necr_level_09", "necrolyte_necr_level_10", "necrolyte_necr_level_08"}
	local caster = event.caster
	local ability = event.ability
	local snake_damage = event.snake_damage
	local snake_count = event.snake_count
    -- b_d(caster)
    local netherBlaster = caster:FindAbilityByName("nether_blaster")
    ability.b_d_damage = Runes:GetTotalRuneLevel(caster, 2, "b_d", "venomort")*0.5*netherBlaster:GetLevelSpecialValueFor("blast_damage", netherBlaster:GetLevel())
    -- rune_c_d(caster, ability)
    ability.c_d_level = Runes:GetTotalRuneLevel(caster, 3, "c_d", "venomort")
     StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_CAST_ABILITY_1, rate=1})
  local velocity = 550
  local baseRange = event.range

  local d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "venomort")
  if d_d_level > 0 then
    local d_d_ability = caster.runeUnit4:FindAbilityByName("venomort_rune_d_d")
    local d_d_duration = Filters:GetAdjustedBuffDuration(caster, 12, false)
    d_d_ability:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_venomort_rune_d_d", {duration = d_d_duration})
    caster:SetModifierStackCount( "modifier_venomort_rune_d_d", d_d_ability, d_d_level )
  end


  EmitSoundOn(sound_table[RandomInt(1, 3)], caster)
  EmitSoundOn("Hero_Medusa.MysticSnake.Cast", caster)
  local originalOrigin = caster:GetAbsOrigin()
  local fv = caster:GetForwardVector()
  fire_snake(ability, fv, originalOrigin+fv*60, caster, velocity, baseRange)
  local rotation1 = WallPhysics:rotateVector(fv, math.pi/11)
  local rotation2 = WallPhysics:rotateVector(fv, -math.pi/11)
  local perpVector = WallPhysics:rotateVector(fv, math.pi/2)
  local delay = 0.5
    Timers:CreateTimer(delay, function()
      local origin = originalOrigin+fv*(120+velocity*delay)
      fire_snake(ability, rotation1, origin, caster, velocity, baseRange-velocity*delay)
      fire_snake(ability, rotation2, origin, caster, velocity, baseRange-velocity*delay)
      EmitSoundOn("Hero_Medusa.MysticSnake.Cast", caster)

    end)
    Timers:CreateTimer(delay*2, function()
      local perp1 = WallPhysics:rotateVector(rotation1, math.pi/2)
      local perp2 = WallPhysics:rotateVector(rotation1, -math.pi/2)
      local origin = originalOrigin+fv*(60+velocity*delay)+rotation1*velocity*delay+perp1*90
      fire_snake(ability, rotation1, origin, caster, velocity, baseRange-velocity*delay*2)
      origin = origin-perp1*180
      fire_snake(ability, rotation1, origin, caster, velocity, baseRange-velocity*delay*2)
      if ability.b_d_damage > 0 then
        create_plague_blast(caster, origin+fv*100, 300, ability.b_d_damage)
      end

      origin = originalOrigin+fv*(60+velocity*delay)+rotation2*velocity*delay+perp2*90
      fire_snake(ability, rotation2, origin, caster, velocity, baseRange-velocity*delay*2)

      origin = origin-perp2*180
      fire_snake(ability, rotation2, origin, caster, velocity, baseRange-velocity*delay*2)


      origin = originalOrigin+fv*(60+velocity*delay*2)+perpVector*90
      fire_snake(ability, fv, origin, caster, velocity, baseRange-velocity*delay*2)

      origin = origin-perpVector*180
      fire_snake(ability, fv, origin, caster, velocity, baseRange-velocity*delay*2)


      EmitSoundOn("Hero_Medusa.MysticSnake.Cast", caster)
    end)
    if ability.b_d_damage > 0 then
      local perp1 = WallPhysics:rotateVector(rotation1, math.pi/2)
      local perp2 = WallPhysics:rotateVector(rotation1, -math.pi/2)
      Timers:CreateTimer(0.6, function()
        create_plague_blast(caster, originalOrigin+fv*560, 260, ability.b_d_damage)
      end)
      Timers:CreateTimer(1.2, function()
        create_plague_blast(caster, originalOrigin+fv*860, 260, ability.b_d_damage)
        create_plague_blast(caster, originalOrigin+fv*860+perp1*220, 260, ability.b_d_damage)
        create_plague_blast(caster, originalOrigin+fv*860+perp2*220, 260, ability.b_d_damage)
      end)
      Timers:CreateTimer(1.8, function()
          create_plague_blast(caster, originalOrigin+fv*1280, 260, ability.b_d_damage)
          create_plague_blast(caster, originalOrigin+fv*1280+perp1*180, 260, ability.b_d_damage)
          create_plague_blast(caster, originalOrigin+fv*1280+perp2*180, 260, ability.b_d_damage)
          create_plague_blast(caster, originalOrigin+fv*1280+perp1*360, 260, ability.b_d_damage)
          create_plague_blast(caster, originalOrigin+fv*1280+perp2*360, 260, ability.b_d_damage)
      end)
    end

    Filters:CastSkillArguments(4, caster)
end

function create_plague_blast(caster, targetPoint, radius, damage)
    local particleName =  "particles/units/heroes/hero_pugna/pugna_netherblast.vpcf"
    local particleVector = targetPoint
      local pfx = ParticleManager:CreateParticle( particleName, PATTACH_POINT, caster )
      ParticleManager:SetParticleControl( pfx, 0, particleVector )
      ParticleManager:SetParticleControl( pfx, 1, Vector(radius, radius, radius) )
        Timers:CreateTimer(0.4, function() 
          ParticleManager:DestroyParticle( pfx, false )
        end)  

        EmitSoundOnLocationWithCaster(targetPoint, "Hero_Necrolyte.DeathPulse", caster)
  local enemies = FindUnitsInRadius( caster:GetTeamNumber(), targetPoint, nil, radius+10, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
  if #enemies > 0 then
    for _,enemy in pairs(enemies) do
      Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
    end
  end 
end

function fire_snake(ability, fv, startPosition, caster, speed, range)
  local projectileParticle = "particles/units/heroes/hero_medusa/veno_ulti_snake_projectile.vpcf"
  local projectileOrigin = startPosition + fv*10
  local start_radius = 140
  local end_radius = 140
  -- local speed = 300
    local info = 
    {
        Ability = ability,
            EffectName = projectileParticle,
            vSpawnOrigin = projectileOrigin+Vector(0,0,120),
            fDistance = range,
            fStartRadius = start_radius,
            fEndRadius = end_radius,
            Source = caster,
            StartPosition = "attach_attack1",
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

function snake_strike(event)
  local caster = event.caster
  local target = event.target
  local ability = event.ability
  local damage = event.damage
  caster:GiveMana(event.mana_restore)
  PopupMana(caster, event.mana_restore)
  EmitSoundOn("Hero_Medusa.MysticSnake.Target", target)
  local buffedDamage = Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
  if ability.c_d_level > 0 then
    target.venomort_c_d_tick = buffedDamage*0.01*ability.c_d_level
    ability:ApplyDataDrivenModifier(caster, target, "modifier_venomort_c_d_poison", {duration = 7})
  end

end

function c_d_damage_tick(event)
  local caster = event.caster
  local target = event.target
  local ability = event.ability
  local damage = target.venomort_c_d_tick
  Filters:ApplyDotDamage(caster, ability, target, damage, DAMAGE_TYPE_MAGICAL, 0)
end

function b_d(caster)

    local runeUnit = caster.runeUnit2
    local ability = runeUnit:FindAbilityByName("venomort_rune_b_d")
    local abilityLevel = ability:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_d")
    local totalLevel = abilityLevel + bonusLevel
    local origin = caster:GetAbsOrigin()
    if totalLevel > 0 then
        for i = 0, totalLevel, 1 do
          Timers:CreateTimer(0.2*i, -- Start this timer 10 game-time seconds later
          function()
            b_d_create_ward(origin, caster, runeUnit, ability)
          end)
        end
        
    end

end

function b_d_create_ward(origin, caster, runeUnit, ability)
    local randomVector = origin + RandomVector(RandomInt(100, 700))
    local dummy = CreateUnitByName("snake_trap_ward", randomVector, true, caster, caster, caster:GetTeamNumber())
    dummy.owner = caster:GetPlayerOwnerID()
    StartAnimation(dummy, {duration=0.8, activity=ACT_DOTA_FLAIL, rate=0.5})
    EmitSoundOn("hero_viper.poisonAttack.Cast", dummy)
    dummy:AddAbility("replica")
    dummy:FindAbilityByName("replica"):SetLevel(1)
    local duration = 5
    dummy:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})
    local rune = dummy:AddAbility("venomort_rune_b_d")
    rune:SetLevel(1)
    rune:ApplyDataDrivenModifier(dummy, dummy, "modifier_venomort_rune_b_d", {duration = 1})

    FindClearSpaceForUnit(dummy, randomVector, true)
      Timers:CreateTimer(10, -- Start this timer 10 game-time seconds later
      function()
      UTIL_Remove(dummy)
      end)  
end

function rune_c_d(caster, mainAbility)
  local runeUnit = caster.runeUnit3
  local ability = runeUnit:FindAbilityByName("venomort_rune_c_d")
  local abilityLevel = ability:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_d")
  local totalLevel = abilityLevel + bonusLevel
  ability.venomort = caster
  ability.totalLevel = totalLevel
  if totalLevel > 0 then
    local dummy = CreateUnitByName("viper_summon", caster:GetAbsOrigin()-Vector(100,100,0), true, caster, caster, caster:GetTeamNumber())
    dummy:SetModelScale(1+totalLevel/60)
    dummy.owner = caster:GetPlayerOwnerID()
    dummy:AddAbility("replica")
    dummy:FindAbilityByName("replica"):SetLevel(1)
    --dummy:SetAbsOrigin(dummy:GetAbsOrigin()+200)
    ability:ApplyDataDrivenModifier(runeUnit, dummy, "modifier_rune_c_d_viper", {duration = 8})
    dummy:MoveToNPC(caster)
  end

end

function c_d_end(event)
 local target = event.target
 target:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
 local origin = target:GetAbsOrigin()
 for i = 0, 30, 1 do
      Timers:CreateTimer(0.05*i,
      function()
        target:SetAbsOrigin(origin+Vector(0,0,20*i)+target:GetForwardVector()*i*10)
        if i == 30 then
            UTIL_Remove(target)
        end
      end)
 end
end

function c_d_enter(event)
 local target = event.target
StartAnimation(target, {duration=1.5, activity=ACT_DOTA_SPAWN, rate=1.0})
end

function viper_attack(event)
    local target = event.target
    local caster = event.caster
    local ability = event.ability
    local totalLevel = ability.totalLevel
    local damage = totalLevel*130
    local damageTable = {
        victim = target,
        attacker = ability.venomort,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
    }
     
    ApplyDamage(damageTable)
    ability:ApplyDataDrivenModifier(caster, target, "modifier_rune_c_d_viper_slow", {duration = 4})
    target:SetModifierStackCount( "modifier_rune_c_d_viper_slow", ability, totalLevel )
    
end