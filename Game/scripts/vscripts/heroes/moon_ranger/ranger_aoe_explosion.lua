require('heroes/moon_ranger/init')
function begin_explosion(event)
  local caster = event.caster
  local ability = event.ability
  ability.origCaster = caster
  local abilityLevel = ability:GetLevel()
  local location = caster:GetOrigin()
  local forwardVector = caster:GetForwardVector()
  local damage = ability:GetSpecialValueFor("damage")
  caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "astral")
  caster.r_4_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "astral")

  if caster:HasModifier("modifier_astral_glyph_7_1") then
    damage = damage * 10
  end
  StopSoundEvent("Astral.CelestialBurst.Start", caster)
  StartAnimation(caster, {duration = 1, activity = ACT_DOTA_CAST_ABILITY_3, rate = 1})
  for i = -3, 3, 1 do
    rotatedVector = rotateVector(forwardVector, i * 2 * math.pi / 7) * Vector(200, 200, 0)
    targetPoint = rotatedVector + location * Vector(1, 1, 0)
    create_individual_explosion(abilityLevel, caster, targetPoint, location, "dummy_aoe_explosion", 0, damage)
  end
  local soundChance = RandomInt(1, 2)
  if soundChance == 3 then
    EmitSoundOn("Astral.CelestialBurst.ExplosionVO", caster)
  end
  -- EmitSoundOn("Hero_Leshrac.Split_Earth.Tormented", caster)
  -- local smashLevel = caster:GetRuneValue("r",2)
  -- if smashLevel > 0 then
  --    local b_d_damage = smashLevel*R2_DAMAGE
  --    -- b_d_damage = b_d_damage + 0.002*caster:GetStrength()/10*d_d_level*b_d_damage
  --    if caster:HasModifier("modifier_astral_glyph_7_1") then
  --      b_d_damage = b_d_damage*10
  --    end
  -- local duration = ability:GetSpecialValueFor("duration")
  --   Timers:CreateTimer(duration + 0.2,
  --   function()
  --   EmitSoundOn("Hero_Leshrac.Split_Earth", caster)
  -- for i=-3, 3, 1 do
  -- rotatedVector = rotateVector(forwardVector, i*2*math.pi/7)*Vector(200, 200, 0)
  -- targetPoint = rotatedVector + location*Vector(1,1,0)
  -- create_individual_explosion(abilityLevel, caster, targetPoint, location, "dummy_aoe_explosion_rune_r_2", smashLevel, b_d_damage)
  -- end
  --   end)
  -- end
  rune_r_3(caster, ability)
  Filters:CastSkillArguments(4, caster)
end

function ranger_aoe_explosion_damage(event)
  local target = event.target
  local ability = event.ability
  local damage = ability.damage
  local caster = ability.origCaster
  Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_R, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
end

function rune_r_2_strike(event)
  local ability = event.ability
  local target = event.target
  local caster = event.caster
  local damage = ability.damage
  local duration = ability.smashLevel * R2_ADD_DURATION + R2_START_DURATION
  if duration > 3.5 then
    duration = 3.5
  end
  ability:ApplyDataDrivenModifier(caster, target, "modifier_backstab_jumping", {duration = 0.09})
  Filters:TakeArgumentsAndApplyDamage(target, ability.origCaster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
  Filters:ApplyStun(caster, duration, target)
end

function rune_r_1(event)
  -- local caster = event.caster
  -- local ability = event.ability
  -- local runeUnit = caster.runeUnit
  -- local runeAbility = runeUnit:FindAbilityByName("astral_rune_r_1")
  -- local abilityLevel = runeAbility:GetLevel()
  -- local bonusLevel = Runes:GetTotalBonus(runeUnit, "r_1")
  -- local totalLevel = abilityLevel + bonusLevel
  -- if totalLevel > 0 then
  --   rune_r_1_start(caster, totalLevel, ability)
  -- end
end

function rune_r_1_start(caster, level, ability)
  -- local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
  -- ability.stars_dropped = 0
  -- if #enemies > 0 then
  --   for i = level
  --     for _,enemy in pairs(enemies) do
  --     if ability.stars_dropped > level*2 then
  --     break
  --     end
  --  Timers:CreateTimer(timeInterval*ability.stars_dropped,  --  function()
  --       dropStar(enemy, caster, 300+level*80, , ability)
  --  end)
  --  ability.stars_dropped = ability.stars_dropped + 1
  --     end
  -- end
end

function create_individual_explosion(abilityLevel, caster, targetPoint, casterOrigin, abilityName, smashLevel, damage)
  local dummy = CreateUnitByName("npc_dummy_unit", casterOrigin, true, caster, caster, caster:GetTeamNumber())
  dummy.owner = caster:GetPlayerOwnerID()

  dummy:AddAbility(abilityName)
  dummy:NoHealthBar()
  dummy:AddAbility("dummy_unit")
  dummy:FindAbilityByName("dummy_unit"):SetLevel(1)

  local blast = dummy:FindAbilityByName(abilityName)
  blast:SetLevel(abilityLevel)
  blast.smashLevel = smashLevel
  blast.damage = damage
  blast.origCaster = caster
  local order =
  {
    UnitIndex = dummy:GetEntityIndex(),
    OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
    AbilityIndex = blast:GetEntityIndex(),
    Position = targetPoint,
    Queue = true
  }

  ExecuteOrderFromTable(order)
  Timers:CreateTimer(5, function()
    UTIL_Remove(dummy)
  end)
end

function rune_r_3(caster, mainAbility)
  local runeUnit = caster.runeUnit3
  local ability = runeUnit:FindAbilityByName("astral_rune_r_3")
  local totalLevel = caster:GetRuneValue("r", 3)
  ability.astral = caster
  ability.totalLevel = totalLevel
  if totalLevel > 0 then
    ability.origCaster = caster
    ability.r_3_level = totalLevel
    local dummy = CreateUnitByName("phoenix_summon", caster:GetAbsOrigin() - Vector(100, 100, 0), true, caster, caster, caster:GetTeamNumber())
    dummy:SetModelScale(1)
    EmitSoundOn("phoenix_phoenix_bird_attack", dummy)
    dummy.owner = caster:GetPlayerOwnerID()
    dummy:AddAbility("replica")
    dummy.dummy = true
    dummy:FindAbilityByName("replica"):SetLevel(1)
    ability:ApplyDataDrivenModifier(runeUnit, dummy, "modifier_rune_r_3_phoenix", {duration = ASTRAL_RANGER_R3_DURATION})
    dummy:MoveToNPC(caster)
    if caster:HasModifier("modifier_astral_glyph_2_1") then
      dummy.glyphed = true
    else
      dummy.glyphed = false
    end
  end
end

function rotateVector(vector, radians)
  XX = vector.x
  YY = vector.y

  Xprime = math.cos(radians) * XX - math.sin(radians) * YY
  Yprime = math.sin(radians) * XX + math.cos(radians) * YY

  vectorX = Vector(1, 0, 0) * Xprime
  vectorY = Vector(0, 1, 0) * Yprime
  rotatedVector = vectorX + vectorY
  return rotatedVector

end

-- function end_channel(event)
--   local caster = event.caster
--   if caster:HasModifier("modifier_astral_glyph_5_1") then
--     begin_explosion({caster = caster, ability = event.ability})
--   end
-- end

function channel_interrupt(event)
  local caster = event.caster
  local ability = event.ability
  if not caster:HasModifier("modifier_astral_glyph_5_1") then
    caster:RemoveModifierByName("modifier_channel_start")
    caster:RemoveModifierByName("modifier_astral_glyph_7_1_evasion_effect")
    if caster.r_timer then
      Timers:RemoveTimer(caster.r_timer)
      caster.r_timer = nil
    end
  end
  StopSoundEvent("Astral.CelestialBurst.Start", caster)
  EndAnimation(caster)
end

function starfall_initiate(event)
  local ability = event.ability
  local caster = event.caster
  local delay = ability:GetChannelTime()
  caster:RemoveModifierByName("modifier_channel_start")
  if caster:HasModifier("modifier_iron_treads_of_destruction") then
    begin_explosion({caster = caster, ability = ability})
  else
    if caster.r_timer then
      Timers:ResetTimer(caster.r_timer)
    else
      caster.r_timer = Timers:CreateTimer(ability:GetChannelTime(), function()
        begin_explosion({caster = caster, ability = ability})
        caster.r_timer = nil
      end)
    end
  end
  StartSoundEvent("Astral.CelestialBurst.Start", caster)
  if not caster:HasModifier("modifier_astral_glyph_5_1") then
    StartAnimation(caster, {duration = 2, activity = ACT_DOTA_TELEPORT, rate = 1})
    local channelVOchance = RandomInt(1, 3)
    if channelVOchance == 1 then
      EmitSoundOn("Astral.CelestialBurst.ChannelVO", caster)
    end
  else
    local cd = ability:GetCooldown(ability:GetLevel() - 1) - ASTRAL_RANGER_GLYPH_5_1_CD_REDUCTION
    ability:EndCooldown()
    ability:StartCooldown(cd)
  end
  if not caster.r_4_level then
    caster.e_4_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "astral")
    caster.r_4_level = Runes:GetTotalRuneLevel(caster, 4, "r_4", "astral")
  end
  ability.r_1_level = caster:GetRuneValue("r", 1)
  ability.maxStars = ability.r_1_level + 20
  ability.hit_mult = math.floor(ability.maxStars / 40)
  ability.remainingStars = ability.maxStars % 40
  ability.star_damage = ability.r_1_level * ASTRAL_RANGER_R1_DAMAGE
  if caster:HasModifier("modifier_astral_glyph_7_1") then
    ability.star_damage = ability.star_damage * 10
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_astral_glyph_7_1_evasion_effect", {duration = ability:GetChannelTime()})
  end
  ability.extraTargetsStruck = 0
  if caster:HasModifier("modifier_astral_glyph_5_1") then
    Timers:CreateTimer(0.03, function()
      caster:InterruptChannel()
    end)
  end
end

function starfall_think(event)
  local caster = event.caster
  local ability = event.ability
  local maxStars = ability.r_1_level + 20

  if ability.r_1_level > 0 then
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
    if #enemies > 0 then
      local hit_mult = ability.hit_mult
      if ability.remainingStars > 0 then
        hit_mult = hit_mult + 1
        ability.remainingStars = ability.remainingStars - 1
      end
      if hit_mult > 0 then
        dropStar(enemies[RandomInt(1, #enemies)], caster, ability.star_damage, ability, hit_mult)
      end

      -- if ability.extraTargetsStruck < ability.remainingStars then
      --   Timers:CreateTimer(0.05, function()
      --     dropStar(enemies[RandomInt(1, #enemies)], caster, ability.star_damage, ability, 1)
      --     ability.extraTargetsStruck = ability.extraTargetsStruck + 1
      --   end)
      -- end
    end
  end
end

function dropStar(enemy, caster, damage, ability, hit_mult)
  -- ability:ApplyDataDrivenModifier(caster, enemy, "modifier_starfall", {duration = 2})
  local particleName = "particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf"
  local pfx = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, enemy)
  ParticleManager:SetParticleControlEnt(pfx, 0, enemy, PATTACH_OVERHEAD_FOLLOW, "attach_hitlock", enemy:GetAbsOrigin(), true)
  Timers:CreateTimer(0.6, function()
    ParticleManager:DestroyParticle(pfx, false)
  end)
  Timers:CreateTimer(0.6, function()
    for i = 1, hit_mult do
      if enemy:IsAlive() and ability.r_1_level > 0 then
        Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_PURE, BASE_ABILITY_R, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
      end
      if caster:GetRuneValue("r", 2) > 0 then
        r_2_quake(damage, ability, caster, caster:GetRuneValue("r", 2), enemy)
      end
      -- ability:ApplyDataDrivenModifier(caster, enemy, "modifier_starfall_a_d_invisible", {duration = 7})
      -- enemy:SetModifierStackCount("modifier_starfall_a_d_invisible", caster, newStacks*ability.r_1_level)
    end
    EmitSoundOn("Ability.StarfallImpact", enemy)
  end)
end

function r_2_quake(damage, ability, caster, r_2_level, target)
  local radius = ASTRAL_RANGER_R2_BASE_RADIUS + ASTRAL_RANGER_ASTRAL_R2_RADIUS * r_2_level
  damage = damage * ASTRAL_RANGER_R2_DAMAGE_PCT / 100 * r_2_level
  local particles_names = {
    "particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic_embers.vpcf",
    "particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast_explosion_trail.vpcf",
    "particles/units/heroes/hero_leshrac/astral_rune_b_d.vpcf"
  }
  if not target.r_2_quake_particle_lock then
    target.r_2_quake_particle_lock = true
    for i, name in pairs(particles_names) do
      local pfx = ParticleManager:CreateParticle(name, PATTACH_CUSTOMORIGIN, nil)
      ParticleManager:SetParticleControl(pfx, 0, target:GetAbsOrigin())
      ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, 0))
      ParticleManager:SetParticleControl(pfx, 2, Vector(radius, radius, 0))
      Timers:CreateTimer(4, function()
        ParticleManager:DestroyParticle(pfx, true)
      end)
    end
    EmitSoundOn("Astral.CelesialBurst.R2", target)
    Timers:CreateTimer(0.1, function() target.r_2_quake_particle_lock = false end)
  end
  local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
  for _, enemy in pairs(enemies) do
    Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_R, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
    Filters:ApplyStun(caster, ASTRAL_RANGER_R2_STUN_DURATION, target)
  end
end
