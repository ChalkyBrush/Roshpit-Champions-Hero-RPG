require('heroes/axe/backshock')

function begin_sunder(keys)
  local caster =  keys.caster
  local ability = keys.ability
  local abilityLevel = ability:GetLevel()
  local procs = rune_a_d(caster)
  local damage = keys.damage
  ability.d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "axe")
  ability.b_d_level = Runes:GetTotalRuneLevel(caster, 2, "b_d", "axe")
  if caster:HasModifier("modifier_axe_glyph_3_1") then
    sunderLoop(caster, ability, damage*procs*0.75, "particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_egset.vpcf")
  else
    local delay = Filters:GetDelayWithCastSpeed(caster, 0.35)
    for i = 0, procs, 1 do
  	  Timers:CreateTimer(i*delay,
  	  function()
    		-- dummy_sunder(caster, ability, abilityLevel, procs)
    		sunderLoop(caster, ability, damage, "particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start.vpcf")
    		end)
    end
  end
  rune_c_d(caster)
  Filters:CastSkillArguments(4, caster)
end

function rune_c_d(caster)
    local runeUnit = caster.runeUnit3
    local ability = runeUnit:FindAbilityByName("axe_rune_c_d")
    local abilityLevel = ability:GetLevel()
    local bonusLevel = Runes:GetTotalBonus(runeUnit, "c_d")
    local totalLevel = abilityLevel + bonusLevel
    if totalLevel > 0 then
      ability:ApplyDataDrivenModifier(runeUnit, caster, "modifier_axe_rune_c_d", {duration = 5})
      caster:SetModifierStackCount( "modifier_axe_rune_c_d", ability, totalLevel )
    end
end

function sunderLoop(caster, ability, damage, particle)
caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
  Timers:CreateTimer(0.3, -- Start this timer 10 game-time seconds later
  function()
	CustomAbilities:AxeSunder(caster, ability, damage, 1, particle)
  end)
end

function sunder(caster, ability, damage)
	local slamPoint = caster:GetAbsOrigin() + caster:GetForwardVector()*250
	rune_b_d(ability, caster, slamPoint)
	EmitSoundOn("RedGeneral.Sunder", caster)
      particleName = "particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start.vpcf"
      local particle1 = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
      ParticleManager:SetParticleControl( particle1, 0, slamPoint )
      Timers:CreateTimer(4, 
      function()
        ParticleManager:DestroyParticle( particle1, false )
      end)
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), slamPoint, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false )
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			Filters:TakeArgumentsAndApplyDamage(enemy, caster, damage, DAMAGE_TYPE_MAGICAL, 4, RPC_ELEMENT_NORMAL, RPC_ELEMENT_NONE)
		end
	end       
	
end

function rune_a_d(caster)
	local runeUnit = caster.runeUnit
	local ability = runeUnit:FindAbilityByName("axe_rune_a_d")
	local abilityLevel = ability:GetLevel()
	local bonusLevel = Runes:GetTotalBonus(runeUnit, "a_d")
	local totalLevel = abilityLevel + bonusLevel
	local procs = Runes:Procs(totalLevel, 10, 1)
	return procs
end

function rune_b_d(sunderAbility, caster, strikePosition)

end

function b_d_damage(event)
	local target = event.target
	local caster = event.caster
	local damage = event.ability.damage
  local ability = event.ability

  local shockStrikeTable = {}
  shockStrikeTable.target = target
  shockStrikeTable.caster = caster
  shockStrikeTable.ability = caster:FindAbilityByName("backshock")
  shockStrikeTable.ability.damage = shockStrikeTable.ability:GetSpecialValueFor("main_damage")
  shockStrikeTable.amp = 0.3*ability.b_d_level
  shock_strike(shockStrikeTable)
 --  if not ability.d_d_level then
 --    ability.d_d_level = Runes:GetTotalRuneLevel(caster, 4, "d_d", "axe")
 --  end
 --  if ability.d_d_level > 0 then
 --    local runeAbility = caster.runeUnit4:FindAbilityByName("axe_rune_d_d")
 --    runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, target, "modifier_axe_rune_d_d_visible", {duration = 7})
 --    local current_stacks = target:GetModifierStackCount( "modifier_axe_rune_d_d_visible", runeAbility )
 --    newStacks = current_stacks + math.ceil(damage/100)
 --    target:SetModifierStackCount( "modifier_axe_rune_d_d_visible", runeAbility, newStacks )

 --    runeAbility:ApplyDataDrivenModifier(caster.runeUnit4, target, "modifier_axe_rune_d_d_invisible", {duration = 7})
 --    target:SetModifierStackCount( "modifier_axe_rune_d_d_invisible", runeAbility, newStacks*ability.d_d_level )
 --  end
	-- Filters:TakeArgumentsAndApplyDamage(target, caster, damage, DAMAGE_TYPE_MAGICAL, 4) 
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

function AmplifyDamageParticle( event )
  local target = event.target
  local location = target:GetAbsOrigin()
  local particleName = "particles/units/heroes/hero_slardar/axe_d_d_amp_damage.vpcf"

-- Particle. Need to wait one frame for the older particle to be destroyed
  Timers:CreateTimer(0.01, function() 
    target.AmpDamageParticle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)
    ParticleManager:SetParticleControl(target.AmpDamageParticle, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(target.AmpDamageParticle, 1, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(target.AmpDamageParticle, 2, target:GetAbsOrigin())

    ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 1, target, PATTACH_OVERHEAD_FOLLOW, "attach_overhead", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(target.AmpDamageParticle, 2, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
  end)
end

-- Destroys the particle when the modifier is destroyed
function EndAmplifyDamageParticle( event )
  local target = event.target
  ParticleManager:DestroyParticle(target.AmpDamageParticle,false)
end