require ('heroes/moon_ranger/common')
function shroud_animation(event)
  local caster = event.caster
  StartAnimation(caster, {duration=0.6, activity=ACT_DOTA_CAST_ABILITY_2, rate=2})
end

function begin_moon_shroud(event)
	local caster = event.caster
	local ability = event.ability
	local abilityLevel = ability:GetLevel()
	local totalLevel = rune_a_a(caster, ability)
  local c_a_level = rune_c_a(caster, ability)
	local origin = caster:GetForwardVector()*Vector(100,100,0)
	local location = caster:GetOrigin() + origin
	local duration = event.duration
  if caster:HasModifier("modifier_astral_glyph_5_1") then
    duration = duration+2.5
    print("DURATION INCREASED")
  end 
  caster.d_c_level = Runes:GetTotalRuneLevel(caster, 4, "d_c", "astral")
  caster.d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "astral")
  
  duration = Filters:GetAdjustedBuffDuration(caster, duration, false)
	create_moon_shroud_dummy(abilityLevel, location, caster, totalLevel, c_a_level, duration, ability)
  ability.d_a_level = Runes:GetTotalRuneLevel(caster, 4, "d_a", "astral")
	-- rune_b_a(caster, ability, location, duration)
  Filters:CastSkillArguments(1, caster)
  
  if ability.d_a_level > 0 then
    local runeAbility = caster.runeUnit4:FindAbilityByName("astral_rune_d_a")
    runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_astral_rune_d_a_visible", {})
    caster:SetModifierStackCount( "modifier_astral_rune_d_a_visible", runeAbility, ability.d_a_level )
    runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, caster, "modifier_astral_rune_d_a_invisible", {})
    local damageBonus = (caster:GetStrength()+caster:GetAgility()+caster:GetIntellect())*0.5*ability.d_a_level
    caster:SetModifierStackCount( "modifier_astral_rune_d_a_invisible", runeAbility, damageBonus )
  else
    caster:RemoveModifierByName("modifier_astral_rune_d_a_visible")
    caster:RemoveModifierByName("modifier_astral_rune_d_a_invisible")
  end
end

function create_moon_shroud_dummy(abilityLevel, location, caster, totalLevel, c_a_level, duration, ability)
      ability:ApplyDataDrivenThinker(caster, location, "modifier_moon_shroud_thinker", {duration = duration})
      ability:ApplyDataDrivenThinker(caster, location, "friendly_moon_shroud_thinker", {duration = duration})
      ability.caster = caster
      ability.rune_a_a_level = totalLevel
      ability.rune_c_a_level = c_a_level
 --  	local dummy = CreateUnitByName("npc_dummy_unit", location, true, caster, caster, caster:GetTeamNumber())
 --  	dummy.owner = caster:GetPlayerOwnerID()

 --  	dummy:AddAbility("dummy_moon_shroud")
 --  	dummy:NoHealthBar()
 --  	dummy:AddAbility("dummy_unit")
 --  	dummy:FindAbilityByName("dummy_unit"):SetLevel(1)

 --  	local blast = dummy:FindAbilityByName("dummy_moon_shroud")
 --  	blast:SetLevel(abilityLevel)
 --    blast.caster = caster
 --  	blast.rune_a_a_level = totalLevel
 --    blast.rune_c_a_level = c_a_level
	-- local order =
	-- {
	-- 	UnitIndex = dummy:GetEntityIndex(),
	-- 	OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
	-- 	AbilityIndex = blast:GetEntityIndex(),
	-- 	Position = location,
	-- 	Queue = true
	-- }
	-- ExecuteOrderFromTable(order)
	--   Timers:CreateTimer(8, -- Start this timer 10 game-time seconds later
	--   function()
	-- 	UTIL_Remove(dummy)
	--   end)	
end

function moon_shroud_damage(event)
    local target = event.target
    local caster = event.ability.caster
    local damage = event.damage
    Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 1, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
end

function rune_a_a(caster, ability)
  local runeUnit = caster.runeUnit
  local runeAbility = runeUnit:FindAbilityByName("astral_rune_a_a")
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_a")
  local totalLevel = abilityLevel + bonusLevel
  return totalLevel
end

function rune_c_a(caster, ability)
  local runeUnit = caster.runeUnit3
  local runeAbility = runeUnit:FindAbilityByName("astral_rune_c_a")
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_a")
  local totalLevel = abilityLevel + bonusLevel
  return totalLevel
end

function moon_shroud_think(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if (caster:GetPlayerOwner() == target:GetPlayerOwner()) and ability.rune_a_a_level > 0 then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_rune_a_a", {duration = 0.3})
		target:SetModifierStackCount( "modifier_rune_a_a", ability, ability.rune_a_a_level )
	end
  if (caster:GetPlayerOwner() == target:GetPlayerOwner()) and ability.rune_c_a_level > 0 then
    ability:ApplyDataDrivenModifier(caster, target, "modifier_astral_rune_c_a", {duration = 0.3})
    target:SetModifierStackCount( "modifier_astral_rune_c_a", ability, ability.rune_c_a_level )
  end
end

function c_a_projectile_add(event)
  local target = event.target
  target:SetRangedProjectileName("particles/units/heroes/hero_drow/astral_c_a_particle_attackfrost_arrow.vpcf")
end

function c_a_projectile_remove(event)
  local target = event.target
  target:SetRangedProjectileName("particles/units/heroes/hero_drow/drow_base_attack.vpcf")
end

function rune_b_a(caster, ability, origin, duration)
  local runeUnit = caster.runeUnit2
  local runeAbility = runeUnit:FindAbilityByName("astral_rune_b_a")
  local abilityLevel = runeAbility:GetLevel()
  local bonusLevel = Runes:GetTotalBonus(runeUnit, "b_a")
  local totalLevel = abilityLevel + bonusLevel
  if totalLevel > 0 then
  	create_andromeda(caster, ability, totalLevel, origin, duration)
  end
end

function create_andromeda(caster, ability, level, position, duration)
    local dummy = CreateUnitByName("andromeda", position, true, caster, caster, caster:GetTeamNumber())
    dummy.owner = caster:GetPlayerOwnerID()
    --StartAnimation(dummy, {duration=0.8, activity=ACT_DOTA_FLAIL, rate=0.5})
    EmitSoundOn("Hero_Luna.LucentBeam.Cast", dummy)
    dummy:AddAbility("replica")
    dummy:FindAbilityByName("replica"):SetLevel(1)
    StartAnimation(dummy, {duration=0.5, activity=ACT_DOTA_SPAWN, rate=1.0})
    
    local damageBonus = (caster:GetStrength()+caster:GetAgility()+caster:GetIntellect())*0.05*ability.d_a_level*level
    dummy:SetBaseDamageMin(damageBonus)
    dummy:SetBaseDamageMax(damageBonus) 

 ability:ApplyDataDrivenModifier(caster, dummy, "modifier_rune_b_a", {duration = duration})
 dummy:SetModifierStackCount( "modifier_rune_b_a", ability, level )
 dummy:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = 1, incoming_damage = 1 })
 
 dummy:MakeIllusion()
    -- FindClearSpaceForUnit(dummy, position, true)
      Timers:CreateTimer(duration + 0.5, -- Start this timer 10 game-time seconds later
      function()
      UTIL_Remove(dummy)
      end)  
end

function moon_shroud_debuff_apply(event)
  local target = event.target
  target.origAcquisition = target:GetAcquisitionRange()
  target:SetAcquisitionRange(100)
  local caster = event.caster
  local moveDirection = ((target:GetAbsOrigin()-caster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
  if target:HasGroundMovementCapability() then
    target:MoveToPosition(target:GetAbsOrigin() + moveDirection*200)
  end
end

function moon_shroud_debuff_end(event)
  local target = event.target
  target:SetAcquisitionRange(target.origAcquisition)
  target:Stop()
end

function moon_shroud_attack_land(event)
  local caster = event.attacker
  local target = event.target
  local damage = caster:GetAverageTrueAttackDamage(caster)
  local b_a_level = 0
  if caster:HasModifier("modifier_astral_arcana1") then
    b_a_level = Runes:GetTotalRuneLevel(caster, 2, "b_a_arcana1", "astral")
  else
    b_a_level = Runes:GetTotalRuneLevel(caster, 2, "b_a", "astral")
  end
  if target.dummy then
    return false
  end
  if b_a_level > 0 then
    local procMin = 20
    if caster:HasModifier("modifier_astral_immortal_weapon_2") then
      procMin = 40
    end
    procMin = getProcChance(caster, procMin)
    local luck = RandomInt(1, 100)
    if luck <= procMin then
      local ability = event.ability
      local mult = 0.03
      if caster:HasModifier("modifier_astral_arcana1") then
        mult = 0.05
      end
      local pureDamage = damage*(b_a_level*mult)
      local particleName = "particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf"
      local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, target )
      ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
      Timers:CreateTimer(0.6, function() 
        ParticleManager:DestroyParticle( pfx, false )
      end)  
          Timers:CreateTimer(0.45, -- Start this timer 10 game-time seconds later
          function()
            if target:IsAlive() then
               Filters:TakeArgumentsAndApplyDamage(target, caster, pureDamage, DAMAGE_TYPE_PURE, 0, RPC_ELEMENT_COSMOS, RPC_ELEMENT_NONE)
              EmitSoundOn("Ability.StarfallImpact", target)
              if caster:HasModifier("modifier_astral_arcana1") then
                ability = caster:FindAbilityByName("astral_arcana_ability")
                ability:ApplyDataDrivenModifier(caster, target, "modifier_astral_b_a_arcana_armor_loss", {duration = 6})
                target:SetModifierStackCount("modifier_astral_b_a_arcana_armor_loss", ability, b_a_level)                
              else
                ability:ApplyDataDrivenModifier(caster, target, "modifier_astral_b_a_armor_loss", {duration = 6})
                target:SetModifierStackCount("modifier_astral_b_a_armor_loss", ability, b_a_level)
              end
            end
          end)     
    end
  end
end