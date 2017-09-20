require('heroes/moon_ranger/astral_arcana_ability')

function star_blink_impact(event)

	local caster = event.caster
    local ability = event.ability
    local abilityLevel = ability:GetLevel()
    local target = event.target_points[1]
    target = WallPhysics:WallSearch(caster:GetAbsOrigin(), target, caster)
    rune_a_c(caster, target, ability)
    rune_b_c(caster)
    rune_c_c(caster, target)
    print("particle attached")
    caster.d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "astral")
    caster.d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "astral")
    local delay = 2
    if caster:HasModifier("modifier_astral_glyph_4_1") then
      delay = 1
    end
    local particleName = "particles/units/heroes/hero_wisp/wisp_relocate_marker_endpoint.vpcf"
    local particleLocation = target
    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
    ParticleManager:SetParticleControl( particle1, 0, particleLocation )
    Timers:CreateTimer(delay, -- Start this timer 10 game-time seconds later
    function()
      ability:ApplyDataDrivenModifier(caster, caster, "modifier_star_blink_moving", {duration = 0.3})
      ParticleManager:DestroyParticle( particle1, false )
      particleName = "particles/units/heroes/hero_dark_seer/dark_seer_surge_start.vpcf"

      local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      ParticleManager:SetParticleControl( particle2, 0, caster:GetAbsOrigin() )
      local particle3 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      ParticleManager:SetParticleControl( particle3, 0, target )
      caster:SetAbsOrigin(target)
      FindClearSpaceForUnit(caster, target, true)
      ProjectileManager:ProjectileDodge(caster)
      Timers:CreateTimer(2, -- Start this timer 10 game-time seconds later
      function()
        ParticleManager:DestroyParticle( particle2, false )
        ParticleManager:DestroyParticle( particle3, false )
      end)
      if caster:HasModifier("modifier_astral_arcana_on_platform") then
        arcana_star_blink_move(caster, ability)
      end
    end)
    local b_c_level = Runes:GetTotalRuneLevel(caster, 2, "b_c", "astral")
    if b_c_level > 0 then
      local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target, nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
      if #enemies > 0 then
        for _,enemy in pairs(enemies) do
          CustomAbilities:QuickAttachParticle("particles/roshpit/astral_ranger/e2_flash.vpcf", enemy, 1)
          caster:PerformAttack(enemy, true, true, true, false, true, false, false)
        end
      end

    end
    Filters:CastSkillArguments(3, caster)
end

function star_blink_damage(event)
    local target = event.target
    local caster = event.caster
    local damage = event.damage
    local stun_duration = event.stun_duration
    Filters:ApplyStun(caster, stun_duration, target)
    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, 3, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
end

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

  starAbility.rootDuration = totalLevel*0.05 + 0.5
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
      print('stacksCount')
      print(newStacks)
      print(newStacks * ability.level)
      print('duration')
      print(ability.rootDuration)
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
      local c_c_duration = Filters:GetAdjustedBuffDuration(caster, 6.0, false)
      ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_astral_rune_c_c", {duration = c_c_duration})
      caster:SetModifierStackCount( "modifier_astral_rune_c_c", ability, totalLevel )
  end

end

function rune_c_c_think(event)
    Filters:CleanseStuns(eventtarget)
    Filters:CleanseSilences(target)
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