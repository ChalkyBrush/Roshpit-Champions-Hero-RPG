function begin_zap(event)
  local caster = event.caster
  local ability = event.ability
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
  caster.d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "voltex")
  ability.a_b_level = Runes:GetTotalRuneLevel(caster, 1, "a_b", "voltex")
  local b_b_level = Runes:GetTotalRuneLevel(caster, 2, "b_b", "voltex")
  if b_b_level > 0 then
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_rune_b_b_self", {})
    caster:SetModifierStackCount( "modifier_voltex_rune_b_b_self", ability, b_b_level )
    local radius = event.radius
    local allies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    if #allies > 0 then
      for _,ally in pairs(allies) do
        if  ally:GetEntityIndex() == caster:GetEntityIndex() then
        else
          ability:ApplyDataDrivenModifier(caster, ally, "modifier_voltex_rune_b_b_ally", {})
          ally:SetModifierStackCount( "modifier_voltex_rune_b_b_ally", ability, b_b_level )
        end
      end
    end 
  end

  local c_b_level = Runes:GetTotalRuneLevel(caster, 3, "c_b", "voltex")
  if c_b_level > 0 then
    local duration = c_b_level*0.1 + 2.1   
    duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
    local currentStacks = caster:GetModifierStackCount("modifier_voltex_rune_c_b_shield", caster)
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_voltex_rune_c_b_shield", {duration = duration})
    caster:SetModifierStackCount("modifier_voltex_rune_c_b_shield", caster, 3)
  end
  ability.d_b_level = Runes:GetTotalRuneLevel(caster, 4, "d_b", "voltex")

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
    if ability.a_b_level > 0 then
      local pureDamage = caster:GetAverageTrueAttackDamage(caster)*ability.a_b_level*0.01*ability:GetLevel()
      Filters:TakeArgumentsAndApplyDamage(target, caster, pureDamage, DAMAGE_TYPE_PURE, 2, RPC_ELEMENT_NONE, RPC_ELEMENT_NONE)
    end
    if ability.d_b_level > 0 then
      ability:ApplyDataDrivenModifier(caster, target, "modifier_voltex_d_b_debuff", {duration = 12})
      target:SetModifierStackCount("modifier_voltex_d_b_debuff", caster, ability.d_b_level)
    end
    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 2, RPC_ELEMENT_LIGHTNING, RPC_ELEMENT_NONE)
end

