require('heroes/moon_ranger/astral_arcana_ability')
require('heroes/moon_ranger/init')

function rune_a_c(caster, targetPoint, starAbility)
  local runeUnit = caster.runeUnit
  local ability = runeUnit:FindAbilityByName("astral_rune_a_c")
  local abilityLevel = ability:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_c")
  local totalLevel = abilityLevel + bonusLevel
  if totalLevel > 0 then 
    local startPoint = caster:GetAbsOrigin()
    rune_a_c_projectile(caster, targetPoint, totalLevel, starAbility, startPoint)
    if caster:HasModifier("modifier_astral_glyph_1_1") then

        Timers:CreateTimer(1.9, function()
          local nextStartPoint = caster:GetAbsOrigin()
          Timers:CreateTimer(0.1, function()
            rune_a_c_projectile(caster, nextStartPoint, totalLevel, starAbility, targetPoint)
            Timers:CreateTimer(2, function()
              rune_a_c_projectile(caster, caster:GetAbsOrigin(), totalLevel, starAbility, nextStartPoint)
              nextStartPoint = caster:GetAbsOrigin()
              Timers:CreateTimer(2, function()
                rune_a_c_projectile(caster, caster:GetAbsOrigin(), totalLevel, starAbility, nextStartPoint)
              end)
            end)
          end)
        end)
    end
  end
end

function rune_a_c_projectile(caster, targetPoint, totalLevel, starAbility, startPoint)
  local casterOrigin = startPoint
  local start_radius = 350
  local end_radius = 350
  local range = getDistance(casterOrigin, targetPoint)
  local speed = (range*7)/11
  local fv = getFacingVector(casterOrigin, targetPoint)
  -- local d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "astral")
  -- damage = damage + 0.002*caster:GetAgility()/10*d_c_level*damage

  starAbility.rootDuration = totalLevel*E1_ADD_DURATION + E1_START_DURATION
  starAbility.level = totalLevel
  if starAbility.rootDuration > 9 then
    starAbility.rootDuration = 9
  end
  local info = 
  {
      Ability = starAbility,
          EffectName = "particles/units/heroes/hero_vengeful/astral_wave_terror.vpcf",
          vSpawnOrigin = casterOrigin,
          fDistance = range,
          fStartRadius = start_radius,
          fEndRadius = end_radius,
          Source = caster,
          StartPosition = "attach_origin",
          bHasFrontalCone = false,
          bReplaceExisting = false,
          iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
          iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
          iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
          iVisionRadius = 500,
          fExpireTime = GameRules:GetGameTime() + 5.0,
    bDeleteOnHit = false,
    vVelocity = fv * speed,
    bProvidesVision = true,
  }
  projectile = ProjectileManager:CreateLinearProjectile(info)
end

function getDistance(a,b)
    local x, y, z = a.x-b.x, a.y-b.y, a.z-b.z
    return math.sqrt(x*x+y*y+z*z)
end

function getFacingVector(a, b)
  local netVector = b-a
  return netVector:Normalized()*Vector(1,1,0)
end

function rune_a_c_strike(event)
  local target = event.target
  local caster = event.caster
  local ability = event.ability

  if ability.rootDuration > 0 then
      local newStacks = math.min(target:GetModifierStackCount("modifier_astral_rune_a_c_visible", caster) + 1, 10)

      caster:RemoveModifierByName("modifier_astral_rune_a_c_invisible")
      caster:RemoveModifierByName("modifier_astral_rune_a_c_visible")

      ability:ApplyDataDrivenModifier(caster, target, "modifier_astral_rune_a_c_invisible", {duration = ability.rootDuration})
      ability:ApplyDataDrivenModifier(caster, target, "modifier_astral_rune_a_c_visible", {duration = ability.rootDuration})

      target:SetModifierStackCount("modifier_astral_rune_a_c_visible", caster, newStacks);
      target:SetModifierStackCount("modifier_astral_rune_a_c_invisible", caster, newStacks * ability.level);
  end
end

function rune_b_c(caster)
  local runeUnit = caster.runeUnit2
  local ability = runeUnit:FindAbilityByName("astral_rune_b_c")
  local abilityLevel = ability:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_c")
  local totalLevel = abilityLevel + bonusLevel
  if totalLevel > 0 then
    local b_c_duration = Filters:GetAdjustedBuffDuration(caster, 8, false)
    ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_astral_rune_b_c", {duration = b_c_duration})
    caster:SetModifierStackCount( "modifier_astral_rune_b_c", ability, totalLevel )
  end
end

function rune_c_c(caster, targetPoint)
  local runeUnit = caster.runeUnit3
  local ability = runeUnit:FindAbilityByName("astral_rune_c_c")
  local abilityLevel = ability:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_c")
  local totalLevel = abilityLevel + bonusLevel
  if totalLevel > 0 then
      local c_c_duration = Filters:GetAdjustedBuffDuration(caster, E3_START_DURATION + E3_ADD_DURATION * totalLevel, false)
      ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_astral_rune_c_c", {duration = c_c_duration})
  end
end

function rune_c_c_think(event)
    print('test think')
    Filters:CleanseStuns(event.target)
    Filters:CleanseSilences(event.target)
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