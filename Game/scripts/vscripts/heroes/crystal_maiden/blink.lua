
function HideCaster( event )
    event.caster:AddNoDraw()
    event.caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
    local position = event.caster:GetAbsOrigin()
    local caster = event.caster
    local target = event.target_points[1]
    local casterOrigin = caster:GetAbsOrigin()
    target = WallPhysics:WallSearch(casterOrigin, target, caster)
    -- local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_loadout.vpcf", PATTACH_ABSORIGIN, event.caster )
    --     ParticleManager:SetParticleControl( pfx, 0, position )
    local newPosition = target
    FindClearSpaceForUnit(event.caster, newPosition, false)
    rune_e_1(event.caster, event.ability)
    rune_e_3(event.caster, event.ability)
    --WATER ELEMENTAL
    if not caster:HasModifier("modifier_sorceress_immortal_ice_avatar") and not caster:HasModifier("modifier_sorceress_immortal_fire_avatar") then
      rune_e_2(event.caster, newPosition, event.ability)
    end
    Filters:CastSkillArguments(3, event.caster)
    ProjectileManager:ProjectileDodge(event.caster)
end


function ShowCaster( event )
    event.caster:RemoveNoDraw()
    event.caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
end

function rune_e_1(caster, ability)
  local totalLevel = caster:GetRuneValue("e", 1)
  if totalLevel > 0 then
    local current_stack = caster:GetModifierStackCount( "modifier_flicker_charges", ability )
    if current_stack >= 10 then
        ability:EndCooldown()
        EmitSoundOn("DOTA_Item.DiffusalBlade.Activate", caster)
        EmitSoundOn("DOTA_Item.DiffusalBlade.Activate", caster)
        caster:SetModifierStackCount( "modifier_flicker_charges", ability, current_stack-10 ) 
    else
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_flicker_charges", {})
        caster:SetModifierStackCount( "modifier_flicker_charges", ability, current_stack+totalLevel ) 
    end
  end   
end

function rune_e_2(caster, origin, ability)
  local runeUnit = caster.runeUnit2
  local runeAbility = runeUnit:FindAbilityByName("sorceress_rune_e_2")
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "e_2")
  local totalLevel = abilityLevel + bonusLevel
  if totalLevel > 0 then
    if not caster.waterElemental then
      summon_water_elemental(caster, origin, totalLevel, ability)
    else
      FindClearSpaceForUnit(caster.waterElemental, origin+RandomVector(200), false)
    end
  end   
end

function conjureImage(caster, origin, ability, duration)
     local health = caster:GetMaxHealth()
     local illusion = CreateUnitByName("sorceress_clone", origin, true, caster, nil, caster:GetTeamNumber())
     Timers:CreateTimer(0.05, function()
     illusion:SetMaxHealth(health)
     end)
     illusion:SetHealth(health)
     --illusion:SetPlayerID(caster:GetPlayerID())
     illusion:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)

     --EmitSoundOn("Hero_Disruptor.ThunderStrike.Target", illusion)

     -- Set the unit as an illusion
     -- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle 
     illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = 1, incoming_damage = 0.1 })
     -- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
     illusion:MakeIllusion()
end



function rune_e_3(caster, ability)
  local totalLevel = caster:GetRuneValue("e", 3)
  if totalLevel > 0 then
    local lucky = RandomInt(1, 2)
    if lucky == 1 then
        EmitSoundOn("Sorceress.ClearCast", caster)
        caster:RemoveModifierByName("modifier_pyro_cooldown")
        local pyroblast = caster:FindAbilityByName("pyroblast")
        local c_c_amp = totalLevel*0.05
        if pyroblast then
          pyroblast.e_3_amp = c_c_amp
        end
        local clearCastDuration = Filters:GetAdjustedBuffDuration(caster, 3, false)
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_clear_cast", {duration = clearCastDuration})
        local pyroblast = caster:FindAbilityByName("pyroblast")
        if pyroblast then
            pyroblast:EndCooldown()
        end
        local ice_tornado = caster:FindAbilityByName("sorceress_arcana_ice_tornado")
        if ice_tornado then
            ice_tornado.e_3_amp = c_c_amp
            ice_tornado:EndCooldown()
        end
    end
  end   
end

function clearcast_end(event)
  local caster = event.caster
  local ice_tornado = caster:FindAbilityByName("sorceress_arcana_ice_tornado")
  if ice_tornado then
      ice_tornado.e_3_amp = 0
  end
end

function summon_water_elemental(caster, origin, totalLevel, ability)
  local summonPosition = origin
  caster.waterElemental = CreateUnitByName("sorc_water_elemental", summonPosition, true, caster, caster, caster:GetTeamNumber())
  caster.waterElemental.sorceress = caster
  caster.waterElemental.owner = caster:GetPlayerOwnerID()
  caster.waterElemental:SetOwner(caster)
  caster.waterElemental:FindAbilityByName("sorc_elemental_ability"):SetLevel(1)
    caster.waterElemental:SetControllableByPlayer(caster:GetPlayerID(), true)
    local aiAbility = caster.waterElemental:FindAbilityByName("hero_summon_ai")
    aiAbility:ToggleAbility()
  -- local aspectAbility = caster.earthAspect:FindAbilityByName("aspect_abilities")
  -- aspectAbility:SetLevel(1)
  -- aspectAbility:ApplyDataDrivenModifier(caster.earthAspect, caster.earthAspect, "modifier_aspect_main", {})

    local waterParticle = "particles/units/heroes/hero_morphling/morphling_adaptive_strike.vpcf"
  local pfx = ParticleManager:CreateParticle( waterParticle, PATTACH_CUSTOMORIGIN, caster.waterElemental )
  ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster.waterElemental:GetAbsOrigin(), true)

  EmitSoundOn("Hero_Morphling.AdaptiveStrike.Cast", caster.waterElemental)

    ability:ApplyDataDrivenModifier(caster, caster.waterElemental, "modifier_water_elemental", {})
    if caster:HasModifier("modifier_sorceress_glyph_4_1") then
      ability:ApplyDataDrivenModifier(caster, caster.waterElemental, "modifier_water_elemental_4_1_enchancement", {})
    end
    local health = caster:GetMaxHealth()
    local baseDamage = 300+totalLevel*500

    local d_c_level = Runes:GetTotalRuneLevel(caster, 4, "e_4", "sorceress")
    baseDamage = baseDamage + 0.008*(OverflowProtectedGetAverageTrueAttackDamage(caster))/100*d_c_level*baseDamage
    baseDamage = math.min(baseDamage, 2^30)
    Timers:CreateTimer(0.05, function()
      
      caster.waterElemental:SetMaxHealth(health)
      caster.waterElemental:SetBaseMaxHealth(health)
      caster.waterElemental:SetHealth(health)
      caster.waterElemental:Heal(health, caster.waterElemental)
      caster.waterElemental:SetBaseDamageMin(baseDamage)
      caster.waterElemental:SetBaseDamageMax(baseDamage)
      caster.waterElemental:SetPhysicalArmorBaseValue(caster:GetPhysicalArmorValue())
      caster.waterElemental.e_4_level = d_c_level
    end)
    caster:ReduceMana(totalLevel*100 + 100)
  
end

function elemental_die(event)
  local sorc = event.caster.sorceress
  sorc.waterElemental = false
end

function water_elemental_think(event)

end

function water_elemental_attack(event)
  local attacker = event.attacker
  local target = event.target
  local ability = event.ability
  local particleName = "particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf"
    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
    local origin = target:GetAbsOrigin()
    ParticleManager:SetParticleControl( particle1, 0, origin )
    ParticleManager:SetParticleControl( particle1, 1, origin )
    Timers:CreateTimer(3, function()
      ParticleManager:DestroyParticle(particle1, false)
    end)
    -- EmitSoundOn("Hero_Ancient_Apparition.IceBlast.Target", caster)
    local radius = 390
    local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker)
    local enemies = FindUnitsInRadius( attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    local slowDuration = 1.2
    if #enemies > 0 then
      for _,enemy in pairs(enemies) do
        Filters:TakeArgumentsAndApplyDamage(enemy, attacker, damage, DAMAGE_TYPE_MAGICAL, 0, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
        ability:ApplyDataDrivenModifier(attacker, enemy, "modifier_elemental_slow", {duration = slowDuration})
      end
    end 
    if attacker.e_4_level > 0 then
      local luck = RandomInt(1, 100)
      if luck < attacker.e_4_level then
        elemental_projectile(attacker, target, ability)
      end
    end
end

function elemental_projectile(attacker, enemy, ability)
  StartAnimation(attacker, {duration=0.6, activity=ACT_DOTA_ATTACK, rate=1.8})
  local info = 
  {
    Target = enemy,
    Source = attacker,
    Ability = ability,  
    EffectName = "particles/units/heroes/hero_morphling/morphling_base_attack.vpcf",
    vSourceLoc= attacker:GetAbsOrigin(),
    bDrawsOnMinimap = false, 
          bDodgeable = true,
          bIsAttack = false, 
          bVisibleToEnemies = true,
          bReplaceExisting = false,
          flExpireTime = GameRules:GetGameTime() + 10,
    bProvidesVision = true,
    iVisionRadius = 0,
    iMoveSpeed = 1400,
    iVisionTeamNumber = attacker:GetTeamNumber()
  }
  projectile = ProjectileManager:CreateTrackingProjectile(info)
end

function elemental_extra_attack_strike(event)
  local attacker = event.caster
  local target = event.target
  local ability = event.ability
  local particleName = "particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf"
    local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, attacker )
    local origin = target:GetAbsOrigin()
    ParticleManager:SetParticleControl( particle1, 0, origin )
    ParticleManager:SetParticleControl( particle1, 1, origin )
    Timers:CreateTimer(3, function()
      ParticleManager:DestroyParticle(particle1, false)
    end)
    -- EmitSoundOn("Hero_Ancient_Apparition.IceBlast.Target", caster)
    local radius = 390
    local damage = OverflowProtectedGetAverageTrueAttackDamage(attacker)
    local enemies = FindUnitsInRadius( attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
    local slowDuration = 1.2
    if #enemies > 0 then
      for _,enemy in pairs(enemies) do
        Filters:TakeArgumentsAndApplyDamage(enemy, attacker, damage, DAMAGE_TYPE_MAGICAL, 0, RPC_ELEMENT_ICE, RPC_ELEMENT_NONE)
        ability:ApplyDataDrivenModifier(attacker, enemy, "modifier_elemental_slow", {duration = slowDuration})
      end
    end 
end