require ('heroes/moon_ranger/common')
function shroud_animation(event)
  local caster = event.caster
  StartAnimation(caster, {duration = 0.6, activity = ACT_DOTA_CAST_ABILITY_2, rate = 2})
end

function begin_moon_shroud(event)
  local caster = event.caster
  local ability = event.ability
  local origin = caster:GetForwardVector() * Vector(100, 100, 0)
  local location = caster:GetOrigin() + origin
  local duration = event.duration

  duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
  create_moon_shroud_dummy(location, caster, duration, ability)
  ability.q_4_level = caster:GetRuneValue("q", 4)
  Filters:CastSkillArguments(1, caster)

  if ability.q_4_level > 0 then
    local runeAbility = caster.runeUnit4:FindAbilityByName("astral_rune_q_4")
    runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_astral_rune_q_4_visible", {})
    caster:SetModifierStackCount("modifier_astral_rune_q_4_visible", runeAbility, ability.q_4_level)
    runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_astral_rune_q_4_invisible", {})
    local damageBonus = (caster:GetStrength() + caster:GetAgility() + caster:GetIntellect() + caster:GetSpirit()) * ASTRAL_RANGER_Q4_ATTACK_DAMAGE_PER_ATTRIBUTE * ability.q_4_level
    caster:SetModifierStackCount("modifier_astral_rune_q_4_invisible", runeAbility, damageBonus)
  else
    caster:RemoveModifierByName("modifier_astral_rune_q_4_visible")
    caster:RemoveModifierByName("modifier_astral_rune_q_4_invisible")
  end
end

function create_moon_shroud_dummy(location, caster, duration, ability)
  local dummy = caster.moon_shroud_dummy
  if not dummy then
    dummy = CreateUnitByName("npc_dummy_unit", location, false, nil, nil, DOTA_TEAM_GOODGUYS)
    dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
    dummy.hero = caster
    caster.moon_shroud_dummy = dummy
  else
    dummy:SetAbsOrigin(location)
  end
  ability:ApplyDataDrivenModifier(dummy, dummy, "modifier_moon_shroud_thinker", {duration = duration})
  ability:ApplyDataDrivenModifier(dummy, dummy, "friendly_moon_shroud_thinker", {duration = duration})

  if dummy.pfx then
    ParticleManager:DestroyParticle(dummy.pfx, false)
  end
  dummy.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/astral_smoke.vpcf", PATTACH_CUSTOMORIGIN, nil)
  ParticleManager:SetParticleControl(dummy.pfx, 0, location + Vector(0, 0, 80))
  ParticleManager:SetParticleControl(dummy.pfx, 1, Vector(400, 400, 200))
end

function moon_shroud_move(caster, point)
  if caster:HasModifier("modifier_moon_shroud_buff") then
    local ability = caster:FindAbilityByName("moon_shroud")
    local duration = ability:GetSpecialValueFor("duration")
    if not ability then return end
    local dummy = caster.moon_shroud_dummy
    dummy:SetAbsOrigin(point)
    local bonus_duration = ability:GetSpecialValueFor("add_duration")
    if caster:HasModifier("modifier_astral_glyph_4_1") then
      bonus_duration = bonus_duration * (1 - ASTRAL_RANGER_GLYPH_4_1_DURATION_REDUCTION_PCT / 100)
    end
    local duration = dummy:FindModifierByName("modifier_moon_shroud_thinker"):GetRemainingTime() + bonus_duration
    dummy:FindModifierByName("modifier_moon_shroud_thinker"):SetDuration(duration, true)
    dummy:FindModifierByName("friendly_moon_shroud_thinker"):SetDuration(duration, true)
    local newPfx = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/astral_smoke.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(newPfx, 0, point * Vector(1, 1, 0) + Vector(0, 0, 80) + GetGroundHeight(point, caster) * Vector(0, 0, 1))
    ParticleManager:SetParticleControl(newPfx, 1, Vector(400, 400, 200))
    ParticleManager:DestroyParticle(dummy.pfx, false)
    dummy.pfx = newPfx
  end
end

-- 177013
function moon_shroud_damage(event)
  local target = event.target
  local caster = event.caster.hero
  local damage = event.damage
  Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, BASE_ABILITY_Q, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
end

function moon_shroud_end(event)
  local caster = event.caster
  if caster.pfx then
    ParticleManager:DestroyParticle(caster.pfx, false)
    caster.pfx = nil
  end
end

function moon_shroud_buff_created(event)
  local caster = event.caster
  local target = event.target
  local ability = event.ability
  if target.moon_shroud_dummy and target.moon_shroud_dummy:GetEntityIndex() == caster:GetEntityIndex() then
    local q_1_level = target:GetRuneValue("q", 1)
    local q_3_level = target:GetRuneValue("q", 3)
    if q_1_level > 0 then
      ability:ApplyDataDrivenModifier(target, target, "modifier_astral_rune_q_1", {})
      target:FindModifierByName("modifier_astral_rune_q_1"):SetStackCount(q_1_level)
    end
    if q_3_level > 0 then
      ability:ApplyDataDrivenModifier(target, target, "modifier_astral_rune_q_3", {})
      target:FindModifierByName("modifier_astral_rune_q_3"):SetStackCount(q_3_level)
    end
  end
end

function moon_shroud_buff_end(event)
  local caster = event.caster
  local target = event.target
  local ability = event.ability
  target:RemoveModifierByName("modifier_astral_rune_q_1")
  target:RemoveModifierByName("modifier_astral_rune_q_3")
end

function c_a_projectile_add(event)
  local target = event.target
  target:SetRangedProjectileName("particles/units/heroes/hero_drow/astral_c_a_particle_attackfrost_arrow.vpcf")
end

function c_a_projectile_remove(event)
  local target = event.target
  target:SetRangedProjectileName("particles/units/heroes/hero_drow/drow_base_attack.vpcf")
end

function moon_shroud_debuff_apply(event)
  local target = event.target
  target.origAcquisition = target:GetAcquisitionRange()
  target:SetAcquisitionRange(100)
  local caster = event.caster
  local moveDirection = ((target:GetAbsOrigin() - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()
  if target:HasGroundMovementCapability() then
    target:MoveToPosition(target:GetAbsOrigin() + moveDirection * 200)
  end
end

function moon_shroud_debuff_end(event)
  local target = event.target
  target:SetAcquisitionRange(target.origAcquisition)
  target:Stop()
end

function moon_shroud_start_thinkers(event)
  local target = event.target_points[1]
  local caster = event.caster
  local ability = event.ability
  local ability_level = ability:GetLevel()
  local thinkerDuration = ability:GetLevelSpecialValueFor("duration", ability_level)
  if target and caster and ability and thinkerDuration then
    CustomAbilities:QuickAttachThinker(ability, caster, target, "modifier_moon_shroud_thinker", {duration = thinkerDuration})
    CustomAbilities:QuickAttachThinker(ability, caster, target, "friendly_moon_shroud_thinker", {duration = thinkerDuration})
  end
end

-- function rune_q_2(caster, ability, origin, duration)
--   local q_2_level = caster:GetRuneValue("q", 2)
--   create_andromeda(caster, ability, q_2_level, origin, duration)
-- end

-- function create_andromeda(caster, ability, level, position, duration)
--     local dummy = CreateUnitByName("andromeda", position, true, caster, caster, caster:GetTeamNumber())
--     dummy.owner = caster:GetPlayerOwnerID()
--     --StartAnimation(dummy, {duration=0.8, activity=ACT_DOTA_FLAIL, rate=0.5})
--     EmitSoundOn("Hero_Luna.LucentBeam.Cast", dummy)
--     dummy:AddAbility("replica")
--     dummy:FindAbilityByName("replica"):SetLevel(1)
--     StartAnimation(dummy, {duration=0.5, activity=ACT_DOTA_SPAWN, rate=1.0})

--     local damageBonus = (caster:GetStrength()+caster:GetAgility()+caster:GetIntellect())*0.05*ability.q_4_level*level
--     dummy:SetBaseDamageMin(damageBonus)
--     dummy:SetBaseDamageMax(damageBonus)

--  ability:ApplyDataDrivenModifier(caster, dummy, "modifier_rune_q_2", {duration = duration})
--  dummy:SetModifierStackCount( "modifier_rune_q_2", ability, level )
--  dummy:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = 1, incoming_damage = 1 })

--  dummy:MakeIllusion()
--     -- FindClearSpaceForUnit(dummy, position, true)
--       Timers:CreateTimer(duration + 0.5, function()
--       UTIL_Remove(dummy)
--       end)
-- end

-- function moon_shroud_attack_land(event)
--   local caster = event.attacker
--   local target = event.target
--   local damage = OverflowProtectedGetAverageTrueAttackDamage(caster)
--   local q_2_level = 0
--   q_2_level = caster:GetRuneValue("q", 2)
--   if target.dummy then
--     return false
--   end
--   if q_2_level > 0 then
--     local procMin = 20
--     if caster:HasModifier("modifier_astral_immortal_weapon_2") then
--       procMin = 40
--     end
--     procMin = getProcChance(caster, procMin)
--     local luck = RandomInt(1, 100)
--     if luck <= procMin then
--       local ability = event.ability
--       local mult = 0.03
--       if caster:HasModifier("modifier_astral_arcana1") then
--         mult = 0.05
--       end
--       local pureDamage = damage*(q_2_level*mult)
--       local particleName = "particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf"
--       local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
--       ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
--       Timers:CreateTimer(0.6, function()
--         ParticleManager:DestroyParticle( pfx, false )
--       end)
--           Timers:CreateTimer(0.45, function()
--             if target:IsAlive() then
--                Filters:TakeArgumentsAndApplyDamage(target, caster, pureDamage, DAMAGE_TYPE_PURE, BASE_ITEM, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
--               EmitSoundOn("Ability.StarfallImpact", target)
--               if caster:HasModifier("modifier_astral_arcana1") then
--                 ability = caster:FindAbilityByName("astral_arcana_ability")
--                 ability:ApplyDataDrivenModifier(caster, target, "modifier_astral_b_a_arcana_armor_loss", {duration = 6})
--                 target:SetModifierStackCount("modifier_astral_b_a_arcana_armor_loss", ability, q_2_level)
--               else
--                 ability:ApplyDataDrivenModifier(caster, target, "modifier_astral_b_a_armor_loss", {duration = 6})
--                 target:SetModifierStackCount("modifier_astral_b_a_armor_loss", ability, q_2_level)
--               end
--             end
--           end)
--     end
--   end
-- end
