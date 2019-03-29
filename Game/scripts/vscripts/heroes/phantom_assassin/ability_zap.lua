require('heroes/phantom_assassin/constants_voltex')

function begin_zap(event)
  local caster = event.caster
  local ability = event.ability
  StartAnimation(caster, {duration=0.25, activity=ACT_DOTA_CAST_ABILITY_2, rate=2})
  Filters:CastSkillArguments(2, caster)
  if caster:HasModifier("modifier_voltex_glyph_7_1") then
    caster:SetMana(0)
    ability:EndCooldown()
    ability:StartCooldown(8)
    local particleName = "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf"
    local particle2 = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, caster )
    ParticleManager:SetParticleControl( particle2, 0, caster:GetAbsOrigin() )
    ParticleManager:SetParticleControl( particle2, 1, Vector(400,400,400) )
    ParticleManager:SetParticleControl( particle2, 2, Vector(1, 1, 1) )
    ParticleManager:SetParticleControl( particle2, 4, Vector(200, 200, 255) )
    Timers:CreateTimer(1.5, 
    function()
      ParticleManager:DestroyParticle( particle2, false )
    end)
    EmitSoundOn("Hero_Zuus.GodsWrath.Target", caster)
  end
  CustomAbilities:QuickParticleAtPoint("particles/units/heroes/hero_stormspirit/storm_spirit_new_loadout.vpcf", caster:GetAbsOrigin()+Vector(0,0,30), 1)
  caster.e_4_level = caster:GetRuneValue("e", 4)
  ability.w_1_level = caster:GetRuneValue("w", 1)
  local w_2_level = caster:GetRuneValue("w", 2)
  if w_2_level > 0 then
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_rune_w_2_self", {})
    caster:SetModifierStackCount( "modifier_voltex_rune_w_2_self", ability, w_2_level )
    local radius = event.radius
    local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    if #allies > 0 then
      for _,ally in pairs(allies) do
        if  ally:GetEntityIndex() == caster:GetEntityIndex() then
        else
          ability:ApplyDataDrivenModifier(caster, ally, "modifier_voltex_rune_w_2_ally", {})
          ally:SetModifierStackCount( "modifier_voltex_rune_w_2_ally", ability, w_2_level )
        end
      end
    end 
  end

  local w_3_level = caster:GetRuneValue("w", 3)
  if w_3_level > 0 then
    local duration = w_3_level*0.1 + 2.1   
    duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
    local currentStacks = caster:GetModifierStackCount("modifier_voltex_rune_w_3_shield", caster)
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_rune_w_3_shield", {duration = duration})
    caster:SetModifierStackCount("modifier_voltex_rune_w_3_shield", caster, 3)
  end
  ability.w_4_level = caster:GetRuneValue("w", 4)
  if caster:HasModifier("modifier_magnet_d_d") then
    caster:Stop()
    if caster:HasAbility("voltex_magnet") then
      local magnetAbility = caster:FindAbilityByName("voltex_magnet")
      magnetAbility:ApplyDataDrivenModifier(caster, caster, "modifier_arcana2_dash", {duration = 1})
      magnetAbility.pushSpeed = 25
    end
  end
end

function zap_damage(event)
    local target = event.target
    local caster = event.caster
    local damage = event.damage
    local ability = event.ability
    -- if caster:HasModifier("modifier_voltex_immortal_weapon_1") then
    --   local percentage = 0.15
    --   if target.mainBoss then
    --     percentage = 0.05
    --   end
    --   damage = damage + target:GetHealth()*percentage
    -- end
    local casterOrigin = caster:GetAbsOrigin()
    
    local currentStacks = target:GetModifierStackCount("modifier_zapped", caster)
    
    if currentStacks <= 6 then
      ability:ApplyDataDrivenModifier(caster, target, "modifier_zapped", {duration = 5})
      target:SetModifierStackCount("modifier_zapped", caster, currentStacks + 1)
      local modifierKnockback =
      {
        center_x = casterOrigin.x,
        center_y = casterOrigin.y,
        center_z = casterOrigin.z,
        duration = 0.4,
        knockback_duration = 0.4,
        knockback_distance = 100,
        knockback_height = 50,
      }

      target:AddNewModifier( caster, nil, "modifier_knockback", modifierKnockback )
    end
    if caster:HasModifier("modifier_voltex_glyph_7_1") then
      damage = damage*200
      Filters:ApplyStun(caster, 2.5, target)
    end
    if ability.w_1_level > 0 then
      local pureDamage = OverflowProtectedGetAverageTrueAttackDamage(caster)*ability.w_1_level*VOLTEX_W1_DMG_PER_ATT_PER_LVL*ability:GetLevel()
      Filters:TakeArgumentsAndApplyDamage(target, caster, pureDamage, DAMAGE_TYPE_PURE, 2, RPC_ELEMENT_NONE, RPC_ELEMENT_NONE)
    end
    if ability.w_4_level > 0 then
      ability:ApplyDataDrivenModifier(caster, target, "modifier_voltex_d_b_debuff", {duration = 12})
      target:SetModifierStackCount("modifier_voltex_d_b_debuff", caster, ability.w_4_level)
    end
    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
end

