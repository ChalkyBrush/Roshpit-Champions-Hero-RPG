function begin_dash(keys)  
  local hero =  keys.caster
  local ability = keys.ability
  local abilityLevel = ability:GetLevel()
  ability.forwardVec = hero:GetForwardVector()
  ability.interval = 0
  ability.tornados_fired = 0
  hero:StartGesture(ACT_DOTA_CAST_ABILITY_3)
  rune_e_3(hero, ability)

  ability.e_2_level = hero:GetRuneValue("e", 2)
  if ability.e_2_level > 0 then
    local b_c_duration = Filters:GetAdjustedBuffDuration(hero, 5, false)
    ability:ApplyDataDrivenModifier(hero, hero, "modifier_axe_rune_e_2_tornado", {duration = b_c_duration})
    hero:SetModifierStackCount("modifier_axe_rune_e_2_tornado", hero, ability.e_2_level)
  end
  ability.e_4_level = hero:GetRuneValue("e", 4)
  Filters:CastSkillArguments(3, hero)
  ability.forwardVelocity = 20
  local modifierName = "modifier_whirlwind"
  if hero:HasModifier("modifier_axe_glyph_5_a") then
    modifierName = "modifier_whirlwind_glyphed"
  end
  ability:ApplyDataDrivenModifier(hero, hero, modifierName, {duration = 1.5})
  ability:ApplyDataDrivenModifier(hero, hero, "modifier_whirlwind_flying_portion", {duration = 4.0})
  print("BEGIN WHIRLWIND")
end

function dash_think(event)
  local ability = event.ability
  local interval = ability.interval
  local hero = event.caster
  local position = hero:GetAbsOrigin()
  position = GetGroundPosition( position, hero )

  if ability.interval > 40 then
    ability.forwardVelocity = ability.forwardVelocity - 2
  end
  local forwardVelocity = ability.forwardVelocity
  if hero:HasModifier("modfier_axe_jumping") then
    forwardVelocity = 0
  end
  hero.EFV = hero:GetForwardVector()
  local newPosition = position+ability.forwardVec*forwardVelocity
  local obstruction = WallPhysics:FindNearestObstruction(newPosition)
  local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, newPosition, hero)
  ability.forwardVec = ((ability.forwardVec*3+hero:GetForwardVector())/4):Normalized()
  if not blockUnit then
    if hero:HasModifier("modifier_axe_glyph_5_a") then
    else
      if hero:HasModifier("modfier_axe_jumping") then
      else
        local obstruction = WallPhysics:FindNearestObstruction(position)
        local blockUnit = WallPhysics:ShouldBlockUnit(obstruction, position, hero)
        if not blockUnit then
          hero:SetOrigin(newPosition)
        end
      end
    end
  else
    hero:RemoveModifierByName("modifier_whirlwind_flying_portion")
  end
  
  if interval%13 == 0 then
        hero:StartGesture(ACT_DOTA_CAST_ABILITY_3)
        EmitSoundOn("Hero_Beastmaster.Wild_Axes", hero)
        dash_damage_and_knockback(ability,hero,position,event.damage,event.knockback_distance)
        CustomAbilities:QuickAttachParticle("particles/econ/items/axe/axe_weapon_bloodchaser/axe_attack_blur_counterhelix_bloodchaser.vpcf", hero, 2)
  end
  -- if interval%3==0 then
  --   if ability.tornados_fired<ability.tornado_count then
  --     rune_e_2(ability, hero, newPosition)
  --     ability.tornados_fired = ability.tornados_fired + 1
  --   end
  -- end
  ability.interval = ability.interval+1
end

function dash_damage_and_knockback(ability,caster,position,damage_percent,distance)
  local modifierKnockback =
  {
    center_x = position.x,
    center_y = position.y,
    center_z = position.z,
    duration = 1,
    knockback_duration = 0.8,
    knockback_distance = distance,
    knockback_height = 160,
  }
    local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)*damage_percent/100
    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, 260, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    if #enemies > 0 then
        for _,enemy in pairs(enemies) do
          Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PHYSICAL, 3, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
        end
    end 
end

function dash_end(event)
  local hero = event.caster
  local ability = event.ability
  hero.EFV = false
  -- if ability.e_2_level > 0 then
  --   print("APPLY BC AGAIN")
  --   ability:ApplyDataDrivenModifier(hero, hero, "modifier_axe_rune_e_2_tornado", {duration = 2})
  -- end
  if not hero:HasModifier("modfier_axe_jumping") then
    hero:RemoveModifierByName("modifier_whirlwind_flying_portion")
    FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), true)
  end
end

function rune_e_1(caster)
  local runeUnit = caster.runeUnit
  local ability = runeUnit:FindAbilityByName("axe_rune_e_1")
  local abilityLevel = ability:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "e_1")
  local totalLevel = abilityLevel + bonusLevel
  return totalLevel
end

function rune_e_2(whirlwindAbility, caster, strikePosition)

    local start_radius = 240
    local end_radius = 240
    local range = 1400
    local speed = 600
    local fv = caster:GetForwardVector()
    local randomRotation = math.pi/RandomInt(-8, 8)
    local randomNeg = RandomInt(0, 1)
      fv = rotateVector(fv, randomRotation-(2*randomRotation*randomNeg))
      local info = 
      {
          Ability = whirlwindAbility,
            EffectName = "particles/units/heroes/hero_invoker/red_general_tornado.vpcf",
            vSpawnOrigin = strikePosition,
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
        vVelocity = fv * speed,
        bProvidesVision = false,
      }
      projectile = ProjectileManager:CreateLinearProjectile(info) 
end

function b_c_damage(event)
  local target = event.target
  local caster = event.caster
  local damage = event.ability.tornado_damage

  local damageTable = {
    victim = target,
    attacker = caster,
    damage = damage,
    damage_type = DAMAGE_TYPE_MAGICAL,
  }
       
  ApplyDamage(damageTable)
end

function rune_e_3(caster, ability)
    local e_3_level = caster:GetRuneValue("e", 3)
    if e_3_level > 0 then
      local duration = Filters:GetAdjustedBuffDuration(caster, 12, false)
      ability:ApplyDataDrivenModifier(caster, caster, "modifier_axe_rune_e_3_shield", {duration = duration})
      caster:SetModifierStackCount("modifier_axe_rune_e_3_shield", caster, e_3_level)
      -- ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_axe_rune_e_3", {duration = 1.8})
      -- caster:SetModifierStackCount( "modifier_axe_rune_e_3", ability, totalLevel )
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

function c_c_take_damage(event)
  local caster = event.caster
  local ability = event.ability
  local attacker = event.attacker
  local unit = caster.hero
  local level = ability:GetLevel()
  local bonusLevels = Runes:GetTotalBonus(unit.runeUnit3, "e_3")
  local totalLevel = level + bonusLevels
  local attack_damage = event.attack_damage
  local damage = attack_damage*1*totalLevel+100+50*totalLevel
  local origin = attacker:GetAbsOrigin()
  if attacker:GetMaxHealth()>200 then
    ApplyDamage({ victim = attacker, attacker = unit, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
          local particleName = "particles/units/heroes/hero_treant/treant_leech_seed_damage_pulse.vpcf"
          local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, attacker)
          ParticleManager:SetParticleControlEnt(lightningBolt, 0, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
          ParticleManager:SetParticleControlEnt(lightningBolt, 1, attacker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
          Timers:CreateTimer(0.5, function()
            ParticleManager:DestroyParticle(lightningBolt, false)
          end)
  end

end

function a_c_think(event)
  local caster = event.caster
  local e_1_level = caster:GetRuneValue("e", 1)
  if e_1_level > 0 then
    local stacks = math.floor(20 - 20*(caster:GetHealth()/caster:GetMaxHealth()))
    local runeAbility = caster.runeUnit:FindAbilityByName("axe_rune_e_1")
    if stacks > 0 then
      runeAbility:ApplyDataDrivenModifier(caster.runeUnit, caster, "modifier_axe_rune_e_1_visible", {})
      caster:SetModifierStackCount( "modifier_axe_rune_e_1_visible", runeAbility, stacks )
      runeAbility:ApplyDataDrivenModifier(caster.runeUnit, caster, "modifier_axe_rune_e_1_invisible", {})
      caster:SetModifierStackCount( "modifier_axe_rune_e_1_invisible", runeAbility, stacks * e_1_level )
    else
      caster:RemoveModifierByName("modifier_axe_rune_e_1_visible")
      caster:RemoveModifierByName("modifier_axe_rune_e_1_invisible")
    end
  end
end

function createFireBall(ability, fv, caster, casterOrigin)
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

function d_c_projectile_hit(event)
  local caster = event.caster
  local target = event.target
  
  local ability = event.ability
  if not ability.e_4_level then
    ability.e_4_level = caster:GetRuneValue("e", 4)
  end

  local damage = (1 + ability.e_4_level*0.3)*OverflowProtectedGetAverageTrueAttackDamage(caster)
  local radius = 190
  local position = target:GetAbsOrigin()

  EmitSoundOn("RedGeneral.FireImpact", target)

  local particleName = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
  local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, caster )
  ParticleManager:SetParticleControl( particle2, 0, position )
  ParticleManager:SetParticleControl( particle2, 1, Vector(radius,radius,radius) )
  ParticleManager:SetParticleControl( particle2, 2, Vector(2.0, 2.0, 2.0) )
  ParticleManager:SetParticleControl( particle2, 4, Vector(255, 90, 20) )
  Timers:CreateTimer(1.5, 
    function()
    ParticleManager:DestroyParticle( particle2, false )
  end)
  local enemies = FindUnitsInRadius( caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
  if #enemies > 0 then  
    for _,enemy in pairs(enemies) do
      Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_FIRE, RPC_ELEMENT_NONE)
    end
  end
end