
function HideCaster( event )
    event.caster:AddNoDraw()
    event.caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
    local position = event.caster:GetAbsOrigin()
    event.caster.newPosition =  position + event.caster:GetForwardVector()*1000
    DummyPoison(position, event.caster, event.ability:GetLevel(), event.ability)
    local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_loadout.vpcf", PATTACH_ABSORIGIN, event.caster )
        ParticleManager:SetParticleControl( pfx, 0, position )
    event.ability.c_c_level = rune_c_c(event.caster)
    if event.ability.c_c_level > 0 then
        rune_c_c_thinker(event.caster, event.ability)
    end
    local newPosition = WallPhysics:WallSearch(position, event.caster.newPosition, event.caster)
    --event.caster:SetOrigin(newPosition)
    FindClearSpaceForUnit(event.caster, newPosition, false)
    Filters:CastSkillArguments(3, event.caster)
    ProjectileManager:ProjectileDodge(event.caster)
end

function rune_c_c_thinker(caster, ability)
  ability:ApplyDataDrivenThinker(caster, caster:GetAbsOrigin(), "venomort_rune_c_c_thinker", {duration = 8})
end

function rune_c_c(caster)
  local runeUnit = caster.runeUnit3
  local ability = runeUnit:FindAbilityByName("venomort_rune_c_c")
  local abilityLevel = ability:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_c")
  local totalLevel = abilityLevel + bonusLevel
  if totalLevel > 0 then
    return totalLevel
  else
    return 0
  end

end

function rune_c_c_think(event)
  local caster = event.caster
  local ability = event.ability
  local target = event.target
  local abilityLevel = ability.c_c_level
  ability:ApplyDataDrivenModifier(caster, target, "venomort_rune_c_c_slow", {duration = 0.4+0.15*abilityLevel})
  target:SetModifierStackCount( "venomort_rune_c_c_slow", ability, 3 + abilityLevel ) 
end

function ShowCaster( event )
  local caster = event.caster
  local ability = event.ability
  event.caster:RemoveNoDraw()
  event.caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
  DummyPoison(event.caster:GetOrigin(), event.caster, event.ability:GetLevel(), event.ability)
  rune_a_c(event.caster, event.ability)
  if event.ability.c_c_level then
    if event.ability.c_c_level > 0 then
        rune_c_c_thinker(event.caster, event.ability)
    end
  end
  if caster:HasModifier("modifier_venomort_glyph_5_a") then
    local ghostWarp = caster:FindAbilityByName("venomort_ghost_warp")
    if not ghostWarp then
      ghostWarp = caster:AddAbility("venomort_ghost_warp")
    end
    ghostWarp:SetLevel(ability:GetLevel())
    ghostWarp:SetAbilityIndex(2)
    caster:SwapAbilities("phase_walk", "venomort_ghost_warp", false, true)
  end
end

function StopSound( event )
    StopSoundEvent( event.sound_name, event.target )
end

function DummyPoison(location, caster, abilityLevel, ability)
  ability:ApplyDataDrivenThinker(caster, caster:GetAbsOrigin(), "modifier_phase_poison_thinker", {duration = 8})
end

function poison_damage(event)
    local target = event.target
    local caster = event.caster
    local damage = event.damage
    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 3, RPC_ELEMENT_POISON, RPC_ELEMENT_NONE)
    if caster:HasModifier("modifier_venomort_glyph_7_1") then
      event.ability:ApplyDataDrivenModifier(caster, target, "modifier_venomort_glyph_7_1_effect", {duration = 1})
    end
end

function rune_a_c(caster, ability)
  local runeUnit = caster.runeUnit
  local totalLevel = Runes:GetTotalRuneLevel(caster, 1, "a_c", "venomort")
  if totalLevel > 0 then
    print("phase_walk_rune")
    local invisDuration = 0.6+totalLevel*0.12
    if invisDuration > 3.6 then
      invisDuration = 3.6
    end
    invisDuration = Filters:GetAdjustedBuffDuration(caster, invisDuration, false)
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_venomort_rune_a_c", {duration = invisDuration})
    caster:SetModifierStackCount( "modifier_venomort_rune_a_c", ability, totalLevel )
    --caster:AddNewModifier(caster, ability, "modifier_invisible", {duration = inivsDuration}) 
  end
end